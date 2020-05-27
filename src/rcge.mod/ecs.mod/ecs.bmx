SuperStrict

Rem
bbdoc: RCGE Entity Component System
about: An object-oriented entity component system.
EndRem
Module rcge.ecs

ModuleInfo "Version: 0.2.2"
ModuleInfo "Author: fightlessbirds"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2020 fightlessbirds"

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
Import BRL.Reflection

Rem
bbdoc: ECS class
about:
EndRem
Type TEcs
	
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
	about: @cName is the name of a component type as provided by TTypeId.name().<br>
		Throws an exception if duplicate component types are added.
	EndRem
	Method addComponentType(cName:String)
		Local cType:TTypeId = TTypeId.ForName(cName)
		If cType = Null
			Throw("TEcs.addComponentType(): Could not get TTypeId for component name " + cName)
		EndIf
		If _componentTypes.contains(cName)
			Throw("TEcs.addComponentType(): Cannot add duplicate component type")
		EndIf
		_componentTypes.insert(cName, cType)
		_relationships.insert(cName, New TIntMap())
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
	about: @archetype is an array of component type names.
		The entity will be assembled with these components.<br>
		Throws an exception if any of the components in @archetype can't be found.
	EndRem
	Method createEntity:TEntity(archetype:String[])
		Local e:TEntity = createEntity()
		For Local cName:String = EachIn archetype
			bind(e._id, cName)
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
	about: Throws an exception if @cName has no matching component type.
	EndRem
	Method bind:Object(entityId:Int, cName:String)
		Local e:TEntity = getEntity(entityId)
		Local c:Object = TTypeId(_componentTypes.valueForKey(cName)).newObject()
		e._components.insert(cName, c)
		Local relationship:TIntMap = TIntMap(_relationships.valueForKey(cName))
		relationship.insert(entityId, e)
		Return c
	EndMethod
	
	Rem
	bbdoc: Remove a component from an entity.
	about: Throws an exception if @cName has no matching component type.
	EndRem
	Method unbind(entityId:Int, cName:String)
		Local e:TEntity = getEntity(entityId)
		e._components.remove(cName)
		Local relationship:TIntMap = TIntMap(_relationships.valueForKey(cName))
		relationship.remove(e._id)
	EndMethod
	
	Rem
	bbdoc: Get a list of entities with a certain component.
	about: Throws an exception if @cName has no matching component type.
	EndRem
	Method query:TList(cName:String)
		Local relationship:TIntMap = TIntMap(_relationships.valueForKey(cName))
		If relationship = Null
			Throw("TEcs.query(): Undefined component " + cName)
		EndIf
		Local resultList:TList = New TList()
		For Local e:TEntity = EachIn relationship.values()
			resultList.addLast(e)
		Next
		Return resultList
	EndMethod
	
	Rem
	bbdoc: Get a list of entities matching an archetype.
	about: Throws an exception if any of the component types in @archetype are missing from the ECS.
	EndRem
	Method query:TList(archetype:String[])
		Local componentCount:Int = Len(archetype)
		If componentCount = 0
			Return New TList()
		ElseIf componentCount = 1
			Return query(archetype[0])
		EndIf
		Local resultList:TList = query(archetype[0])
		For Local i:Int = 1 Until Len(archetype)
			Local listB:TList = query(archetype[i])
			For Local e:TEntity = EachIn listB
				If Not resultList.contains(e) Then resultList.addLast(e)
			Next
		Next
		Return resultList
	EndMethod
	
	Rem
	bbdoc: Get a list of entities strictly matching an archetype.
	about: Any entities with extra components will be excluded from the results.
		Throws an exception if any of the component types in @archetype are missing from the ECS.
	EndRem
	Method queryStrict:TList(archetype:String[])
		Local componentCount:Int = Len(archetype)
		If componentCount = 0
			Return New TList()
		ElseIf componentCount = 1
			Return query(archetype[0])
		EndIf
		Local resultList:TList = query(archetype[0])
		For Local i:Int = 1 Until Len(archetype)
			Local relationship:TIntMap = TIntMap(_relationships.valueForKey(archetype[i]))
			If relationship = Null
				Throw("TEcs.queryStrict(): Undefined component " + archetype[i])
			EndIf
			For Local e:TEntity = EachIn resultList
				If Not relationship.contains(e._id)
					resultList.remove(e)
				EndIf
			Next
		Next
	EndMethod
	
	Rem
	bbdoc: Update all systems.
	about: Systems are updated sequentially in the same order they were added to the ECS.<br>
		@deltaTime is the number of seconds since the previous update.
	EndRem
	Method update(deltaTime:Float)
		For Local s:TSystem = EachIn _systems
			Try
				Local archetype:String[] = s.GetArchetype()
				If Len(archetype) = 0
					'System has no archetype, update it once with an empty list
					s.Update(New TList(), deltaTime)
				EndIf
				Local entities:TList = query(archetype)
				If entities
					s.Update(entities, deltaTime)
				EndIf
			Catch ex:Object
				Throw("TEcs.update(): Error updating system " + TTypeId.ForObject(s).name() + ": " + ex.toString())
			EndTry
		Next
		'Clear dead entities
		For Local e:TEntity = EachIn _deadEntities
			Local id:Int = e._id
			Local cNames:TList = New TList()
			For Local cName:String = EachIn e._components.keys()
				cNames.addLast(cName)
			Next
			For Local cName:String = EachIn cNames
				unbind(id, cName)
			Next
			_entities.remove(id)
			e._ecs = Null
		Next
		_deadEntities.clear()
	EndMethod
	
Private
	
	Field _entities:TIntMap = New TIntMap()
	
	Field _nextEntityId:Int = 0
	
	Field _deadEntities:TList = New TList()
	
	Field _componentTypes:TStringMap = New TStringMap()
	
	'TStringMap<TIntMap<TEntity>>
	Field _relationships:TStringMap = New TStringMap()
	
	Field _systems:TList = New TList()

EndType

Rem
bbdoc: Entity class
about: Entities hold no data or functionality. They are essentially a unique identifier
	for a collection of components.
EndRem
Type TEntity
	
	Rem
	bbdoc: Get the entitys ID.
	EndRem
	Method getId:Int()
		Return _id
	EndMethod
	
	Rem
	bbdoc: Get a component object from the entity.
	returns: The component object.
	about: Throws an exception if there is no component for @cName.
	EndRem
	Method getComponent:Object(cName:String)
		Local c:Object = _components[cName]
		If c = Null
			Throw("TEcs.getComponent(): Could not get component " + cName + " from entity " + _id)
		EndIf
		Return c
	EndMethod
	
	Rem
	bbdoc: Add a component to the entity.
	about: Throws an exception if there is no component for @cName.
	EndRem
	Method bind:Object(cName:String)
		Return _ecs.bind(_id, cName)
	EndMethod
	
	Rem
	bbdoc: Remove a component from the entity.
	about: Throws an exception if there is no component for @cName.
	EndRem
	Method unbind(cName:String)
		_ecs.unbind(_id, cName)
	EndMethod
	
	Rem
	bbdoc: Check if the entity is alive. Dead entities do not belong to an ECS.
	returns: Boolean True or False.
	EndRem
	Method isAlive:Int()
		Return _alive
	EndMethod
	
	Rem
	bbdoc: Kill the entity.
	about: Unbinds the entity from all related components and removes it from the system.
	EndRem
	Method kill()
		_ecs._deadEntities.addLast(Self)
		_alive = False
	EndMethod
	
Private

	Field _id:Int
	
	Field _components:TStringMap = New TStringMap()

	Field _alive:Int = True

	Field _ecs:TEcs
	
	Method New()
	EndMethod

	Method New(id:Int, ecs:TEcs)
		_id = id
		_ecs = ecs
	EndMethod

EndType

Rem
bbdoc: System base class
about: Systems hold the logic that is applied to an archetype.
EndRem
Type TSystem Abstract

	Rem
	bbdoc: Get the archetype for the system.
	about: Override this function to return an array of component types.
		The component types must be the same as provided by TTypeId.name().
		If the system has no archetype then Update() will be called once
		per loop and passed an empty list of entities.
	EndRem
	Function GetArchetype:String[]()
		Return []
	EndFunction
	
	Rem
	bbdoc: Update an entity.
	about: Override this method and put logic inside. @deltaTime is seconds
		since the previous update.
	EndRem
	Function Update(entities:TList, deltaTime:Float) Abstract

EndType