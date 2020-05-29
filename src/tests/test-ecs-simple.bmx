SuperStrict

Import rcge.ecs

'Component type definition
Type TMessage
	Field msg:String
EndType
'Hold on to the TTypeId so we don't have to lookup again.
Global MESSAGE_TYPE:TTypeId = TTypeId.ForName("TMessage")

'System definition
Type TTestSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float)
		For Local e:TEntity = EachIn entities
			'Typecast the retrieved component. It is assumed that all
			'component types are known at compile time.
			Local c:TMessage = TMessage(e.getComponent(MESSAGE_TYPE))
			DrawText(c.msg, 300, 200)
		Next
	EndMethod
	
	'Let the ECS know which entities this system will process.
	Function GetArchetype:TTypeId[]()
		Return [MESSAGE_TYPE]
	EndFunction
EndType

'Create and initialize the ECS
Local ecs:TEcs = New TEcs()
ecs.addComponentType(MESSAGE_TYPE)
ecs.addSystem(New TTestSystem())

'Create a test entity
Local e:TEntity = ecs.createEntity()
Local c:TMessage = TMessage(e.bind(MESSAGE_TYPE))
c.msg = "Hello ECS =)"

'Start app loop
Graphics(640, 480)
Repeat
	Cls()
	ecs.update(MilliSecs() / 1000.0)
	Flip()
Until KeyHit(Key_Escape)
