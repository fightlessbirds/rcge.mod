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
	bbdoc: Get the ECS this entity belongs to.
	EndRem
	Method getEcs:TEcs()
		Return _ecs
	EndMethod
	
	Rem
	bbdoc: Check if the entity has a specific component.
	EndRem
	Method hasComponent:Int(cType:TTypeId)
		Return _components.contains(cType)
	EndMethod
	
	Rem
	bbdoc: Get a component object from the entity.
	returns: The component object.
	about: Throws an exception if there is no component for @cType.
	EndRem
	Method getComponent:Object(cType:TTypeId)
		Local c:Object = _components[cType]
		If c = Null
			Throw("TEcs.getComponent(): Could not get component " + cType.name() + " from entity " + _id)
		EndIf
		Return c
	EndMethod
	
	Rem
	bbdoc: Add a component to the entity.
	about: Throws an exception if there is no component for @cType.
	EndRem
	Method bind:Object(cType:TTypeId)
		Return _ecs.bind(Self, cType)
	EndMethod
	
	Rem
	bbdoc: Add an existing component object to the entity.
	about: Throws and exception if the component type is invalid.
	EndRem
	Method bind(obj:Object)
		_ecs.bind(Self, obj)
	EndMethod
	
	Rem
	bbdoc: Remove a component from the entity.
	about: Throws an exception if there is no component for @cType.
	EndRem
	Method unbind(cType:TTypeId)
		_ecs.unbind(_id, cType)
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
	
	Field _components:TMap = New TMap()

	Field _alive:Int = True

	Field _ecs:TEcs
	
	Method New()
	EndMethod

	Method New(id:Int, ecs:TEcs)
		_id = id
		_ecs = ecs
	EndMethod

EndType
