SuperStrict

?win32
Framework SDL.d3d9sdlmax2d
?Not win32
Framework SDL.gl2sdlmax2d
?

Import rcge.game
Import rcge.ecs
Import rcge.log

Global TEST_ARCHETYPE:String[] = ["TPosition", "TKillTag"]

Type TPosition
	
	Field x:Float
	Field y:Float
	
EndType

Type TKillTag
EndType

Type TMoveSystem Extends TSystem
	
	Function Update(e:TEntity, deltaTime:Float)
		Local pos:TPosition = TPosition(e.getComponent("TPosition"))
		pos.x = MouseX()
		pos.y = MouseY()
	EndFunction
	
	Function GetArchetype:String[]()
		Return ["TPosition"]
	EndFunction
	
EndType

Type TKillSystem Extends TSystem
	
	Function Update(e:TEntity, deltaTime:Float)
		If MouseHit(1)
			LogInfo("Mouse button pressed, killing test entity")
			e.kill()
		EndIf
	EndFunction
	
	Function GetArchetype:String[]()
		Return ["TKillTag"]
	EndFunction
	
EndType

Type TDrawSystem Extends TSystem
	
	Function Update(e:TEntity, deltaTime:Float)
		Local pos:TPosition = TPosition(e.getComponent("TPosition"))
		SetColor(255, 0, 0)
		DrawRect(pos.x, pos.y, 50, 50)
	EndFunction
	
	Function GetArchetype:String[]()
		Return ["TPosition"]
	EndFunction
	
EndType

Type TTestScene Extends TScene
	
	Field ecs:TEcs = New TEcs()
	
	Method init()
		
		ecs.addComponentType("TPosition")
		ecs.addComponentType("TKillTag")
		
		ecs.addSystem(New TMoveSystem())
		ecs.addSystem(New TDrawSystem())
		ecs.addSystem(New TKillSystem())

		ecs.createEntity(TEST_ARCHETYPE)
	EndMethod
	
	Method update(deltaTime:Float)
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		ecs.update(deltaTime)
	EndMethod
	
	Method render()
		'  ¯\_(ツ)_/¯
	EndMethod
	
	Method cleanup()
	EndMethod

EndType

Local myGame:TGame = TGame.CreateGame(800, 600)
myGame.addScene("TTestScene")
myGame.start()