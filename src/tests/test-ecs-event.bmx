SuperStrict

Framework SDL.gl2sdlmax2d

Import rcge.game
Import rcge.ecs
Import rcge.logger

Global POSITION_TYPE:TTypeId = TTypeId.ForName("TPosition")
Type TPosition
	Field x:Float
	Field y:Float
EndType

Global KILLTAG_TYPE:TTypeId = TTypeId.ForName("TKillTag")
Type TKillTag
EndType

Global TEST_ARCHETYPE:TTypeId[] = [POSITION_TYPE, KILLTAG_TYPE]

Type TMoveSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		For Local e:TEntity = EachIn entities
			Local pos:TPosition = TPosition(e.getComponent(POSITION_TYPE))
			pos.x = MouseX()
			pos.y = MouseY()
		Next
	EndMethod
	
	Function GetArchetype:TTypeId[]() Override
		Return [POSITION_TYPE]
	EndFunction
EndType

Type TKillSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		For Local e:TEntity = EachIn entities
			If MouseHit(1)
				LogInfo("Mouse button pressed, triggering kill event")
				getEcs().triggerEvent("Kill", e)
			EndIf
		Next
	EndMethod
	
	Function GetArchetype:TTypeId[]() Override
		Return [KILLTAG_TYPE]
	EndFunction
EndType

Type TDrawSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		For Local e:TEntity = EachIn entities
			Local pos:TPosition = TPosition(e.getComponent(POSITION_TYPE))
			SetColor(255, 0, 0)
			DrawRect(pos.x, pos.y, 50, 50)
		Next
	EndMethod
	
	Function GetArchetype:TTypeId[]() Override
		Return [POSITION_TYPE]
	EndFunction
EndType

Type TKillEventListener Implements IEventListener
	Method getEventName:String() Override
		Return "Kill"
	EndMethod
		
	Method onEvent(dispatcher:TEventDispatcher, context:Object=Null) Override
		dispatcher.remove(Self)
		Local e:TEntity = TEntity(context)
		e.kill()
	EndMethod
EndType

Type TTestScene Extends TScene
	
	Field ecs:TEcs = New TEcs()
	
	Method Init() Override
		ecs.addComponentType(POSITION_TYPE)
		ecs.addComponentType(KILLTAG_TYPE)
		
		ecs.addSystem(New TMoveSystem())
		ecs.addSystem(New TDrawSystem())
		ecs.addSystem(New TKillSystem())

		Local e:TEntity = ecs.createEntity(TEST_ARCHETYPE)
		ecs.addEventListener(New TKillEventListener())
	EndMethod
	
	Method update(deltaTime:Float) Override
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		ecs.update(deltaTime)
	EndMethod
	
	Method render() Override
	EndMethod
	
	Method cleanup() Override
	EndMethod

EndType

Local myGame:TGame = TGame.CreateGame(800, 600)
myGame.addScene("TTestScene")
myGame.start()
