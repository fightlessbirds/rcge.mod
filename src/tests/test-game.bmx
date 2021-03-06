SuperStrict

?win32
Framework SDL.D3D9SDLMax2D
?Not win32
Framework SDL.GL2SDLMax2D
?

Import rcge.game

Type TTestSceneA Extends TScene
	
	Method initialize() Override
		Print("test init scene A")
	EndMethod
	
	Method update(deltaTime:Float) Override
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		If KeyHit(Key_Enter)
			TGame.GetInstance().setNextScene("TTestSceneB")
			Self.isFinished = True
		EndIf
	EndMethod
	
	Method render() Override
		DrawText("It works! This is scene A, press ENTER for scene B", 100, 100)
	EndMethod
	
	Method cleanup() Override
		Print("test cleanup scene A")
	EndMethod

EndType

Type TTestSceneB Extends TScene
	
	Method initialize() Override
		Print("test init scene B")
	EndMethod
	
	Method update(deltaTime:Float) Override
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		If KeyHit(Key_Enter)
			TGame.GetInstance().setNextScene("TTestSceneA")
			Self.isFinished = True
		EndIf
	EndMethod
	
	Method render() Override
		DrawText(":) This is scene B, press ENTER for scene A", 100, 100)
	EndMethod
	
	Method cleanup() Override
		Print("test cleanup scene B")
	EndMethod

EndType

Local myGame:TGame = TGame.CreateGame(800, 600)
myGame.addScene("TTestSceneA")
myGame.addScene("TTestSceneB")
myGame.start()