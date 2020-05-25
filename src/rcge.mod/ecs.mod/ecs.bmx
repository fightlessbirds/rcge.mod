SuperStrict

Rem
bbdoc: RCGE Entity Component System
about: An object-oriented entity component system.
EndRem
Module rcge.ecs

ModuleInfo "Version: 0.2.0"
ModuleInfo "Author: fightlessbirds"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2020 fightlessbirds"

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
		For Local i:TSystem = EachIn systems
			If TTypeId.ForObject(i) = sType
				Throw("TEcs.addSystem(): Cannot add duplicate system " + sType.name())
			EndIf
		Next
		systems.addLast(s)
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
		If componentTypes.contains(cName)
			Throw("TEcs.addComponentType(): Cannot add duplicate component type")
		EndIf
		componentTypes.insert(cName, cType)
		relationships.insert(cName, New TIntMap())
	EndMethod
	
	Rem
	bbdoc: Create an empty entity.
	returns: The new entity object.
	about: 
	EndRem
	Method createEntity:TEntity()
		Local e:TEntity = New TEntity(nextEntityId, Self)
		nextEntityId :+ 1
		entities.insert(e.id, e)
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
			bind(e.id, cName)
		Next
		Return e
	EndMethod
	
	Rem
	bbdoc: Get an entity object from the ECS.
	returns: The entity object for @id.
	EndRem
	Method getEntity:TEntity(id:Int)
		Local e:TEntity = TEntity(entities.valueForKey(id))
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
		Local c:Object = createComponent(cName)
		e.addComponent(c)
		Local relationship:TIntMap = getRelationship(cName)
		relationship.insert(entityId, e)
		Return c
	EndMethod
	
	Rem
	bbdoc: Remove a component from an entity.
	about: Throws an exception if @cName has no matching component type.
	EndRem
	Method unbind(entityId:Int, cName:String)
		Local e:TEntity = getEntity(entityId)
		e.removeComponent(cName)
		Local relationship:TIntMap = getRelationship(cName)
		relationship.remove(e.id)
	EndMethod
	
	Rem
	bbdoc: Get a list of entities with a certain component.
	returns: Null if there are no entities with this component.
	about: Throws an exception if @cName has no matching component type.
	EndRem
	Method query:TList(cName:String)
		Local relationship:TIntMap = getRelationship(cName)
		Local resultList:TList = New TList()
		For Local e:TEntity = EachIn relationship.values()
			resultList.addLast(e)
		Next
		Return resultList
	EndMethod
	
	Rem
	bbdoc: Get a list of entities matching an archetype.
	returns: Null if there are no entities with this archetype.
	about: Throws an exception if any of the component types in @archetype are missing from the ECS.
	EndRem
	Method query:TList(archetype:String[])
		Local componentCount:Int = Len(archetype)
		If componentCount = 0
			Return Null
		ElseIf componentCount = 1
			Return query(archetype[0])
		EndIf
		Local resultList:TList = query(archetype[0])
		For Local i:Int = 1 Until Len(archetype)
			Local relationship:TIntMap = getRelationship(archetype[i])
			For Local e:TEntity = EachIn resultList
				If Not relationship.contains(e.id)
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
		For Local s:TSystem = EachIn systems
			Try
				Local archetype:String[] = s.GetArchetype()
				Local entities:TList = query(archetype)
				If entities
					For Local e:TEntity = EachIn entities
						s.Update(e, deltaTime)
					Next
				EndIf
			Catch ex:Object
				Throw("TEcs.update(): Error updating system " + TTypeId.ForObject(s).name() + ": " + ex.toString())
			EndTry
		Next
	EndMethod
	
Private
	
	Field entities:TIntMap = New TIntMap()
	
	Field nextEntityId:Int = 0
	
	Field componentTypes:TStringMap = New TStringMap()
	
	'TStringMap<TIntMap<TEntity>>
	Field relationships:TStringMap = New TStringMap()
	
	Field systems:TList = New TList()
	
	'Convenience method for safely creating a component object.
	Method createComponent:Object(cName:String)
		Local cType:TTypeId = TTypeId(componentTypes.valueForKey(cName))
		If cType = Null
			Throw("TEcs.bind(): Attempted to bind unknown component " + cName)
		EndIf
		Return cType.newObject()
	EndMethod
	
	'Convenience method for safely retrieving a relationship.
	Method getRelationship:TIntMap(cName:String)
		Local r:TIntMap = TIntMap(relationships.valueForKey(cName))
		If r = Null
			Throw("TEcs.getRelationship(): Unknown component " + cName)
		EndIf
		Return r
	EndMethod

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
		Return id
	EndMethod
	
	Rem
	bbdoc: Get a component object from the entity.
	returns: The component object.
	about: Throws an exception if there is no component for @cName.
	EndRem
	Method getComponent:Object(cName:String)
		Local c:Object = components[cName]
		If c = Null
			Throw("TEcs.getComponent(): Could not get component " + cName + " from entity " + id)
		EndIf
		Return c
	EndMethod
	
	Rem
	bbdoc: Add a component to the entity.
	about: Throws an exception if there is no component for @cName.
	EndRem
	Method bind:Object(cName:String)
		Return ecs.bind(id, cName)
	EndMethod
	
	Rem
	bbdoc: Remove a component from the entity.
	about: Throws an exception if there is no component for @cName.
	EndRem
	Method unbind(cName:String)
		ecs.unbind(id, cName)
	EndMethod
	
	Rem
	bbdoc: Check if the entity is alive. Dead entities do not belong to an ECS.
	returns: Boolean True or False.
	EndRem
	Method isAlive:Int()
		Return alive
	EndMethod
	
	Rem
	bbdoc: Kill the entity.
	about: Unbinds the entity from all related components and removes it from the system.
	EndRem
	Method kill()
		For Local cName:String = EachIn components.keys()
			ecs.unbind(id, cName)
		Next
		ecs.entities.remove(id)
		ecs = Null
		alive = False
	EndMethod
	
Private

	Field id:Int
	
	Field components:TStringMap = New TStringMap()

	Field alive:Int = True

	Field ecs:TEcs
	
	Method New()
	EndMethod

	Method New(id:Int, ecs:TEcs)
		Self.id = id
		Self.ecs = ecs
	EndMethod
	
	Method addComponent(c:Object)
		Local cName:String = TTypeId.ForObject(c).name()
		components.insert(cName, c)
	EndMethod
	
	Method removeComponent(cName:String)
		components.remove(cName)
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
	EndRem
	Function GetArchetype:String[]() Abstract
	
	Rem
	bbdoc: Update an entity.
	about: Override this method and put logic inside.
	EndRem
	Function Update(entity:TEntity, deltaTime:Float) Abstract

EndType