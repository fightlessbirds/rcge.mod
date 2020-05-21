SuperStrict

Module rcge.ecs

Import BRL.LinkedList
Import BRL.Map

Import rcge.log

Type TEntity

	Global NextEntityId:Int = 0
	
	Global Entities:TIntMap = New TIntMap()
	
	Function CreateEntity:Int(components:TList)
		Local e:TEntity = New TEntity()
		For Local c:TComponent = EachIn components
			e.addComponent(c)
		Next
		Return e.id
	EndFunction
	
	Function GetEntity:TEntity(id:Int)
		Return TEntity(Entities.valueForKey(id))
	EndFunction
	
	Field id:Int
	
	Field components:TStringMap = New TStringMap()
	
	Field isAlive:Int = True
	
	Method New()
		id = NextEntityId
		NextEntityId :+ 1
		Entities.insert(id, Self)
	EndMethod
	
	Method addComponent(c:TComponent)
		components.insert(c.getName(), c)
		c.addNotify(Self)
	EndMethod
	
	Method removeComponent(cName:String)
		components.remove(cName)
	EndMethod
	
	Method getComponent:TComponent(cName:String)
		Local c:TComponent = TComponent(components[cName])
		If c = Null
			RcgeThrowError("Could not get component " + cName + " from entity " + id)
		EndIf
		Return c
	EndMethod
	
	Method kill()
		Entities.remove(id)
		isAlive = False
	EndMethod

EndType

Type TComponent Abstract
	
	Field parent:TEntity
	
	Method getName:String() Abstract
	
	Method addNotify(parent:TEntity)
		Self.parent = parent
	EndMethod
	
	Method init(state:Object=Null)
	EndMethod
	
EndType

Type TSystem Abstract

	Method update(entity:TEntity) Abstract

EndType