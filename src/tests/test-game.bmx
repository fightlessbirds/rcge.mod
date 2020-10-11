SuperStrict

Framework SDL.gl2sdlmax2d

Import rcge.game

Type TTestSceneA Extends TScene
	
	Method init()
		Print("test init scene A")
	EndMethod
	
	Method update(deltaTime:Float)
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		If KeyHit(Key_Enter)
			TGame.GetInstance().setNextScene("TTestSceneB")
			Self.isFinished = True
		EndIf
	EndMethod
	
	Method render()
		DrawText("It works! This is scene A, press ENTER for scene B", 100, 100)
	EndMethod
	
	Method cleanup()
		Print("test cleanup scene A")
	EndMethod

EndType

Type TTestSceneB Extends TScene
	
	Method init()
		Print("test init scene B")
	EndMethod
	
	Method update(deltaTime:Float)
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		If KeyHit(Key_Enter)
			TGame.GetInstance().setNextScene("TTestSceneA")
			Self.isFinished = True
		EndIf
	EndMethod
	
	Method render()
		DrawText(":) This is scene B, press ENTER for scene A", 100, 100)
	EndMethod
	
	Method cleanup()
		Print("test cleanup scene B")
	EndMethod

EndType

Local myGame:TGame = TGame.CreateGame(800, 600)
myGame.addScene("TTestSceneA")
myGame.addScene("TTestSceneB")
myGame.start()