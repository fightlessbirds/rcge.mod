SuperStrict

Module rcge.game

Import BRL.LinkedList
Import BRL.Max2D
Import BRL.Graphics

Import rcge.deltatimer
Import rcge.log

Function CreateGame:TGame()
	If TGame.Instance = Null
		Return New TGame()
	EndIf
	Return TGame.Instance
EndFunction

Type TGame
	
	Function GetInstance:TGame()
		Return Instance
	EndFunction
	
	Field isRunning:Int
	
	Field scenes:TList = New TList()
	
	Field currentScene:TScene
	
	Field nextScene:TScene
	
	Field deltaTimer:TDeltaTimer = New TDeltaTimer()
	
	Method addScene(scene:TScene)
		scenes.addLast(scene)
		scene.parent = Self
		If nextScene = Null Then nextScene = scene
		LogInfo("Added scene: " + scene.getName())
	EndMethod
	
	Method setNextScene(sceneName:String)
		For Local scene:TScene = EachIn scenes
			If sceneName = scene.getName()
				nextScene = scene
				LogInfo("Next scene: " + sceneName)
				Exit
			EndIf
		Next
	EndMethod
	
	Method start()
		LogInfo("Starting game")
		If CountList(scenes) = 0
			ThrowError("Cannot start game, there are no scenes")
		EndIf
		isRunning = True
		While isRunning
			Local scene:TScene = nextScene
			currentScene = scene
			scene.isFinished = False
			LogInfo("Initializing scene: " + scene.getName())
			scene.init()
			While scene.isFinished = False
				If AppTerminate()
					LogInfo("App terminate request recieved")
					stop()
					Exit
				EndIf
				Cls()
				deltaTimer.update()
				scene.update(deltaTimer.deltaTime)
				scene.render()
				Flip()
			Wend
			LogInfo("Cleaning up scene: " + scene.getName())
			scene.cleanup()
		Wend
		LogInfo("Exiting game")
	EndMethod
	
	Method stop()
		If isRunning
			currentScene.isFinished = True
			isRunning = False
		EndIf
	EndMethod
	
Protected
	
	Global Instance:TGame
	
	Method New()
		If Instance = Null
			Instance = Self
		EndIf
	EndMethod

EndType

Type TScene Abstract

	Field isFinished:Int
	
	Field parent:TGame
	
	Method getName:String() Abstract
	
	Method init() Abstract
	
	Method update(deltaTime:Float) Abstract
	
	Method render() Abstract
	
	Method cleanup() Abstract

EndType

Function StartGame(game:TGame, screenWidth:Int, screenHeight:Int, isFullscreen:Int=False)
	If isFullscreen
		Graphics(screenWidth, screenHeight, 32)
	Else
		Graphics(screenWidth, screenHeight)
	EndIf
	game.start()
EndFunction