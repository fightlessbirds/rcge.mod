SuperStrict

?win32
Framework SDL.d3d9sdlmax2d
?Not win32
Framework SDL.gl2sdlmax2d
?

Import rcge.game
Import rcge.ecs
Import rcge.log

Type c_Position Extends TComponent
	
	Field x:Float
	Field y:Float
	
	Method getName:String()
		Return "Position"
	EndMethod
	
EndType

Type TMoveSystem Extends TSystem
	Method update(e:TEntity)
		Local pos:c_Position = c_Position(e.getComponent("Position"))
		pos.x = MouseX()
		pos.y = MouseY()
	EndMethod
EndType

Type TDrawSystem Extends TSystem
	Method update(e:TEntity)
		Local pos:c_Position = c_Position(e.getComponent("Position"))
		SetColor(255, 0, 0)
		DrawRect(pos.x, pos.y, 50, 50)
	EndMethod
EndType

Type TKillSystem Extends TSystem
	Method update(e:TEntity)
		If MouseHit(1)
			RcgeLogInfo("Mouse button pressed, killing test entity")
			e.kill()
		EndIf
	EndMethod
EndType

Type TTestScene Extends TScene
	
	Field moveSystem:TMoveSystem = New TMoveSystem()
	Field drawSystem:TDrawSystem = New TDrawSystem()
	Field killSystem:TKillSystem = New TKillSystem()
	
	Field testEntityId:Int
	
	Method getName:String()
		Return "ecs test scene"
	EndMethod

	Method init()
		Local components:TList = New TList()
		components.addLast(New c_Position())
		testEntityId = TEntity.CreateEntity(components)
	EndMethod
	
	Method update(deltaTime:Float)
		If KeyHit(Key_Escape) Then TGame.Instance.stop()
		Local e:TEntity = TEntity.GetEntity(testEntityId)
		If e
			moveSystem.update(e)
			killSystem.update(e)
		EndIf
	EndMethod
	
	Method render()
		Local e:TEntity = TEntity.GetEntity(testEntityId)
		If e
			drawSystem.update(e)
		EndIf
	EndMethod
	
	Method cleanup()
	EndMethod

EndType

Local myGame:TGame = New TGame()
myGame.addScene(New TTestScene())
StartGame(myGame, 800, 600)