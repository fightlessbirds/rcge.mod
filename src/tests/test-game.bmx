SuperStrict

?win32
Framework SDL.d3d9sdlmax2d
?Not win32
Framework SDL.gl2sdlmax2d
?

Import rcge.game

Type TTestScene Extends TScene

	Method getName:String()
		Return "test scene"
	EndMethod

	Method init()
		Print("test init")
	EndMethod
	
	Method update(deltaTime:Float)
		If KeyHit(Key_Escape) Then TGame.Instance.stop()
	EndMethod
	
	Method render()
		DrawText("It works!", 100, 100)
	EndMethod
	
	Method cleanup()
		Print("test cleanup")
	EndMethod

EndType

Local myGame:TGame = New TGame()
myGame.addScene(New TTestScene())
StartGame(myGame, 800, 600)