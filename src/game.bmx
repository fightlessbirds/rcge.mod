SuperStrict

Import "deltatimer.bmx"
Import "log.bmx"

Type TGame
	
	Global Instance:TGame
	
	Field isRunning:Int
	
	Field scenes:TList
	
	Field currentScene:TScene
	
	Field nextScene:TScene
	
	Field deltaTimer:TDeltaTimer
	
	Method New()
		Self.Instance = Self
		Self.scenes = CreateList()
		Self.deltaTimer = New TDeltaTimer()
	EndMethod
	
	Method addScene(scene:TScene)
		Self.scenes.addLast(scene)
		scene.parent = Self
		If Self.nextScene = Null Then Self.nextScene = scene
		RcgeLogInfo("Added scene: " + scene.getName())
	EndMethod
	
	Method setNextScene(sceneName:String)
		For Local scene:TScene = EachIn Self.scenes
			If sceneName = scene.getName()
				Self.nextScene = scene
				RcgeLogInfo("Next scene: " + sceneName)
				Exit
			EndIf
		Next
	EndMethod
	
	Method start()
		RcgeLogInfo("Starting game")
		If CountList(Self.scenes) = 0
			RcgeThrowError("Cannot start game, there are no scenes")
		EndIf
		Self.isRunning = True
		While Self.isRunning
			Local scene:TScene = nextScene
			Self.currentScene = scene
			scene.isFinished = False
			RcgeLogInfo("Initializing scene: " + scene.getName())
			scene.init()
			While scene.isFinished = False
				If AppTerminate()
					RcgeLogInfo("App terminate request recieved")
					Self.stop()
					Exit
				EndIf
				Self.deltaTimer.update()
				scene.update(Self.deltaTimer.deltaTime)
				Cls()
				scene.render()
				Flip()
			Wend
			RcgeLogInfo("Cleaning up scene: " + scene.getName())
			scene.cleanup()
		Wend
		RcgeLogInfo("Exiting game")
	EndMethod
	
	Method stop()
		If Self.isRunning
			Self.currentScene.isFinished = True
			Self.isRunning = False
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