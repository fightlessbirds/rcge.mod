SuperStrict

Import rcge.ecs

Type TMessage
	Field msg:String
EndType

Type TTestSystem Extends TSystem
	Function Update(entities:TList, deltaTime:Float)
		For Local e:TEntity = EachIn entities
			Local c:TMessage = TMessage(e.getComponent("TMessage"))
			DrawText(c.msg, 300, 200)
		Next
	EndFunction
	
	Function GetArchetype:String[]()
		Return ["TMessage"]
	EndFunction
EndType

Local ecs:TEcs = New TEcs()
ecs.addComponentType("TMessage")
ecs.addSystem(New TTestSystem())

Local e:TEntity = ecs.createEntity()
Local c:TMessage = TMessage(e.bind("TMessage"))
c.msg = "Hello ECS =)"

Graphics(640, 480)
Repeat
	Cls()
	ecs.update(MilliSecs() / 1000.0)
	Flip()
Until KeyHit(Key_Escape)