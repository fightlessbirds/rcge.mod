
# RCGE
Random Cruft Game Engine - A BlitzMax game framework

### game.mod
##### Usage Example
``` BlitzMax
Import rcge.game

Type TMyScene Extends TScene
	Method init()
	EndMethod
	
	Method update(dt:Float)
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
	EndMethod
	
	Method render()
		DrawText("It works!", 100, 100)
	EndMethod
	
	Method cleanup()
	EndMethod
EndType

Local myGame:TGame = TGame.CreateGame(800, 600)
myGame.addScene("TMyScene")
myGame.start()
```