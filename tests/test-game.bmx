SuperStrict

Import "../src/game.bmx"

Type TTestScene Extends TScene

	Method getName:String()
		Return "test scene"
	EndMethod

	Method init()
		Print("test init")
	EndMethod
	
	Method update(deltaTime:Float)
		If KeyHit(Key_Escape)
			Self.isFinished = True
			Self.parent.isRunning = False
		EndIf
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