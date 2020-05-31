SuperStrict

Rem
bbdoc: RCGE Entity Component System
about: An object-oriented entity component system.
EndRem
Module rcge.ecs

ModuleInfo "Version: 0.2.4"
ModuleInfo "Author: fightlessbirds"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2020 fightlessbirds"

ModuleInfo "Histroy: Added a component operation buffer that is flushed after each system is update for better concurrency."
ModuleInfo "History: Changed TList to TObjectList in some key performance areas."
ModuleInfo "History: Entities are now passed to systems as a simple array TEntity[]."
ModuleInfo "History: Systems can be standalone and operate once per loop without entities."
ModuleInfo "History: Wait until update is finished before removing dead entities."
ModuleInfo "History: Fixed a bug with query() being too strict, added new method queryStrict() as a side-effect."
ModuleInfo "History: 0.2.0"
ModuleInfo "History: Able to query for entities by their constituent components."
ModuleInfo "History: Entities can by constructed from an Archetype which is a set of component types."
ModuleInfo "History: Complete rewrite, the ECS is now an object and there can be many of them."
ModuleInfo "History: 0.1.0"
ModuleInfo "History: Initial Release"

Import BRL.LinkedList
Import BRL.Map
Import BRL.ObjectList
Import BRL.Reflection

Import rcge.log
Import rcge.pool

Include "TEntity.bmx"
Include "TSystem.bmx"
Include "TComponentOperationBuffer.bmx"

Rem
bbdoc: ECS class
about:
EndRem
Type TEcs
	
	Field profilingEnabled:Int = False
	
	Rem
	bbdoc: Add a system to the ECS.
	about: Throws an exception if duplicate systems are added.
	EndRem
	Method addSystem(s:TSystem)
		If s = Null
			Throw("TEcs.addSystem(): Null argument")
		EndIf
		Local sType:TTypeId = TTypeId.ForObject(s)
		For Local i:TSystem = EachIn _systems
			If TTypeId.ForObject(i) = sType
				Throw("TEcs.addSystem(): Cannot add duplicate system " + sType.name())
			EndIf
		Next
		_systems.addLast(s)
	EndMethod
	
	Rem
	bbdoc: Add a component type to the ECS.
	about: @cType is the type of a component.<br>
		Throws an exception if duplicate component types are added.
	EndRem
	Method addComponentType(cType:TTypeId)
		If _componentTypes.contains(cType)
			Throw("TEcs.addComponentType(): Cannot add duplicate component type" + cType.name())
		EndIf
		_componentTypes.addLast(cType)
		_relationships.insert(cType, New TIntMap())
	EndMethod
	
	Rem
	bbdoc: Create an empty entity.
	returns: The new entity object.
	about: 
	EndRem
	Method createEntity:TEntity()
		Local e:TEntity = New TEntity(_nextEntityId, Self)
		_nextEntityId :+ 1
		_entities.insert(e._id, e)
		Return e
	EndMethod
	
	Rem
	bbdoc: Create an entity from an archetype.
	returns: The new entity object.
	about: @archetype is an array of component types.
		The entity will be assembled with these components.<br>
		Throws an exception if any of the components in @archetype can't be found.
	EndRem
	Method createEntity:TEntity(archetype:TTypeId[])
		Local e:TEntity = createEntity()
		For Local cType:TTypeId = EachIn archetype
			bind(e._id, cType)
		Next
		Return e
	EndMethod
	
	Rem
	bbdoc: Get an entity object from the ECS.
	returns: The entity object for @id.
	EndRem
	Method getEntity:TEntity(id:Int)
		Local e:TEntity = TEntity(_entities.valueForKey(id))
		If e Then Return e
		Throw("Ecs.getEntity(): Could not find entity with id " + id)
	EndMethod
	
	Rem
	bbdoc: Add a component to an entity.
	returns: The newly added component object.
	about: Throws an exception if there is no entity with @entityId or if @cType has no matching component type.
	EndRem
	Method bind:Object(entityId:Int, cType:TTypeId)
		Local relationship:TIntMap = TIntMap(_relationships.valueForKey(cType))
		If relationship = Null
			Throw("TEcs.bind(): Can not bind unknown component type " + cType.name())
		EndIf
		Local e:TEntity = getEntity(entityId)
		Local c:Object = cType.newObject()
		If _isUpdating
			_componentOperationBuffer.enqueueBind(relationship, e, cType, c)
		Else
			e._components.insert(cType, c)
			relationship.insert(entityId, e)
		EndIf
		Return c
	EndMethod
	
	Rem
	bbdoc: Remove a component from an entity.
	about: Throws an exception if @cType has no matching component type.
	EndRem
	Method unbind(entityId:Int, cType:TTypeId)
		Local relationship:TIntMap = TIntMap(_relationships.valueForKey(cType))
		If relationship = Null
			Throw("TEcs.unbind(): Can not unbind unknown component type " + cType.name())
		EndIf
		Local e:TEntity = getEntity(entityId)
		If _isUpdating
			_componentOperationBuffer.enqueueUnbind(relationship, e, cType)
		Else
			e._components.remove(cType)
			relationship.remove(entityId)
		EndIf
	EndMethod
	
	Rem
	bbdoc: Get an array of entities with a certain component.
	about: Throws an exception if @cType has no matching component type.
	EndRem
	Method query:TEntity[](cType:TTypeId)
		Return _ObjectListToEntityArray(_query(cType))
	EndMethod
	
	Rem
	bbdoc: Get an array of entities matching an archetype.
	about: Throws an exception if any of the component types in @archetype are missing from the ECS.
	EndRem
	Method query:TEntity[](archetype:TTypeId[])
		Local componentCount:Int = Len(archetype)
		If componentCount = 0
			Return New TEntity[0]
		ElseIf componentCount = 1
			Return query(archetype[0])
		EndIf
		Local resultList:TObjectList = _query(archetype[0])
		For Local i:Int = 1 Until Len(archetype)
			Local compareList:TObjectList = _query(archetype[i])
			For Local e:TEntity = EachIn compareList
				If Not resultList.contains(e) Then resultList.addLast(e)
			Next
		Next
		Return _ObjectListToEntityArray(resultList)
	EndMethod
	
	Rem
	bbdoc: Get an array of entities strictly matching an archetype.
	about: Any entities with extra components will be excluded from the results.
		Throws an exception if any of the component types in @archetype are missing from the ECS.
	EndRem
	Method queryStrict:TEntity[](archetype:TTypeId[])
		Local componentCount:Int = Len(archetype)
		If componentCount = 0
			Return New TEntity[0]
		ElseIf componentCount = 1
			Return query(archetype[0])
		EndIf
		Local resultList:TObjectList = _query(archetype[0])
		For Local i:Int = 1 Until Len(archetype)
			Local relationship:TIntMap = TIntMap(_relationships.valueForKey(archetype[i]))
			If relationship = Null
				Throw("TEcs.queryStrict(): Undefined component " + archetype[i].name())
			EndIf
			For Local e:TEntity = EachIn resultList
				If Not relationship.contains(e._id)
					resultList.remove(e)
				EndIf
			Next
		Next
		Return _ObjectListToEntityArray(resultList)
	EndMethod
	
	Rem
	bbdoc: Update all systems.
	about: Systems are updated sequentially in the same order they were added to the ECS.<br>
		@deltaTime is the number of seconds since the previous update.
	EndRem
	Method update(deltaTime:Float)
		_isUpdating = True
		Local profilerStartMillis:Int
		For Local s:TSystem = EachIn _systems
			Try
				If profilingEnabled Then profilerStartMillis = MilliSecs()
				Local archetype:TTypeId[] = s.GetArchetype()
				If Len(archetype) = 0
					'System has no archetype, update it once with an empty list
					s.update(New TEntity[0], deltaTime)
				EndIf
				Local entities:TEntity[] = query(archetype)
				If Len(entities)
					s.update(entities, deltaTime)
				EndIf
				_componentOperationBuffer.flush()
				_clearDeadEntities()
				If profilingEnabled
					Local updateTookMillis:Int = MilliSecs() - profilerStartMillis
					LogInfo(TTypeId.ForObject(s).name() + " updated in ms: " + updateTookMillis)
				EndIf
			Catch ex:Object
				Throw("TEcs.update(): Error updating system " + TTypeId.ForObject(s).name() + ": " + ex.toString())
			EndTry
		Next
		_isUpdating = False
	EndMethod
	
	
	Private
	
	Field _isUpdating:Int
	
	Field _entities:TIntMap = New TIntMap()
	
	Field _nextEntityId:Int = 0
	
	Field _deadEntities:TObjectList = New TObjectList()
	
	Field _componentTypes:TObjectList = New TObjectList()
	
	Field _componentOperationBuffer:TComponentOperationBuffer = New TComponentOperationBuffer(Self)
	
	'TMap<K=TTypeId,V=TIntMap<TEntity>>
	Field _relationships:TMap = New TMap()
	
	Field _systems:TList = New TList()
	
	'Private version of query() that returns a TListObject rather than an array
	Method _query:TObjectList(cType:TTypeId)
		Local relationship:TIntMap = TIntMap(_relationships.valueForKey(cType))
		If relationship = Null
			Throw("TEcs.query(): Undefined component " + cType.name())
		EndIf
		Local resultList:TObjectList = New TObjectList()
		For Local e:TEntity = EachIn relationship.values()
			resultList.addLast(e)
		Next
		Return resultList
	EndMethod
	
	Method _clearDeadEntities()
		For Local e:TEntity = EachIn _deadEntities
			Local id:Int = e._id
			Local cTypes:TList = New TList()
			For Local cType:TTypeId = EachIn e._components.keys()
				cTypes.addLast(cType)
			Next
			For Local cType:TTypeId = EachIn cTypes
				unbind(id, cType)
			Next
			_entities.remove(id)
			e._ecs = Null
		Next
		_deadEntities.clear()
	EndMethod
	
	'Convenience function for converting a TObjectList to TEntity[]
	Function _ObjectListToEntityArray:TEntity[](objectList:TObjectList)
		Local resultCount:Int = objectList.count()
		Local resultArray:TEntity[] = New TEntity[resultCount]
		Local i:Int = 0
		For Local e:Object = EachIn objectList
			resultArray[i] = TEntity(e)
			i :+ 1
		Next
		Return resultArray
	EndFunction

EndType
