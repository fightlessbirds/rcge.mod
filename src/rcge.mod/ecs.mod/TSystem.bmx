Rem
bbdoc: System base class
about: Systems hold the logic that is applied to an archetype.
EndRem
Type TSystem Abstract

	Rem
	bbdoc: Whether the system should be updated.
	EndRem
	Field isActive:Int = True
	
	Rem
	bbdoc: Get the archetype for the system.
	about: Override this function to return an array of component types.
		The component types must be the same as provided by TTypeId.name().
		If the system has no archetype then Update() will be called once
		per loop and passed an empty list of entities.
	EndRem
	Function GetArchetype:TTypeId[]()
		Return New TTypeId[0]
	EndFunction
	
	Rem
	bbdoc: Update an entity.
	about: Override this method and put logic inside. @deltaTime is seconds
		since the previous update.
	EndRem
	Method update(entities:TEntity[], deltaTime:Float) Abstract
	
	Method getEcs:TEcs()
		Return _ecs
	EndMethod
	
	Method addNotify(ecs:TEcs)
		_ecs = ecs
	EndMethod
	
	Private
	
	Field _ecs:TEcs

EndType
