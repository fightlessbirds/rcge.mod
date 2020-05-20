SuperStrict

'Framework BRL.Max2D
'Game is crashing in Framework mode :(

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