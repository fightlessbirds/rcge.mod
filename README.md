# rcge
Random Cruft Game Engine - A BlitzMax game framework

### Usage Example

``` BlitzMax
Import rcge.game

Type TMyScene Extends TScene

	Method getName:String()
		Return "MyScene"
	EndMethod

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

Local myGame:TGame = CreateGame()
myGame.addScene(New TMyScene())
StartGame(myGame, 800, 600)
```
