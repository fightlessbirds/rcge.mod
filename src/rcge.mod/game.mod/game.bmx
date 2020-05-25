SuperStrict

Rem
bbdoc: RCGE Game module
about: Game window and scene management.
EndRem
Module rcge.game

ModuleInfo "Version: 0.2.0"
ModuleInfo "Author: fightlessbirds"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2020 fightlessbirds"

ModuleInfo "History: 0.2.0"
ModuleInfo "History: Scenes are added by type and instantiated by TGame internally."
ModuleInfo "History: TGame handles initialization of Graphics."
ModuleInfo "History: Removed the need for TScene.getName()."
ModuleInfo "History: 0.1.0"
ModuleInfo "History: A game window and scene switching."
ModuleInfo "History: Initial Release"

Import BRL.LinkedList
Import BRL.Max2D
Import BRL.Graphics
Import BRL.Reflection

Import rcge.deltatimer
Import rcge.log

Rem
bbdoc: Game class
about: A singleton class that creates the game window and manages scenes.
EndRem
Type TGame
	
	Rem
	bbdoc: Create a new game window.
	returns: The TGame instance ready for adding scenes.
	about: Throws an exception if a TGame instance already exists.
	EndRem
	Function CreateGame:TGame(screenW:Int, screenH:Int, fullscreen:Int=False)
		If Instance = Null
			Instance = New TGame(screenW, screenH, fullscreen)
			Return Instance
		EndIf
		LogError("TGame.CreateGame(): Cannot instantiate multiple TGame objects")
	EndFunction
	
	Rem
	bbdoc: Get the singleton instance of TGame.
	about: Throws an exception if TGame has not been instantiated.
	EndRem
	Function GetInstance:TGame()
		If Instance = Null
			LogError("TGame.GetInstance(): No instance available")
		EndIf
		Return Instance
	EndFunction
	
	Rem
	bbdoc: Add a scene to the game.
	about: @sceneName is the type name of the scene as provided by TTypeId.name().<br>
		Throws an exception if the scene cannot be found.
	EndRem
	Method addScene(sceneName:String)
		Local sceneType:TTypeId = TTypeId.ForName(sceneName)
		If sceneType = Null
			Throw("TGame.addScene(): Could not find scene " + sceneName)
		EndIf
		scenes.addLast(sceneType)
		If nextScene = Null Then nextScene = sceneType
		LogInfo("Added scene: " + sceneName)
	EndMethod
	
	Rem
	bbdoc: Set the next scene to load.
	about: @sceneName is the type name of the scene as provided by TTypeId.name().<br>
		Throws an exception if the scene cannot be found.
	EndRem
	Method setNextScene(sceneName:String)
		For Local sceneType:TTypeId = EachIn scenes
			If sceneName = sceneType.name()
				nextScene = sceneType
				LogInfo("Next scene: " + sceneName)
				Return
			EndIf
		Next
		LogError("TGame.setNextScene(): Could not find scene " + sceneName)
	EndMethod
	
	Rem
	bbdoc: Start the game.
	about: By default the first scene added is the starting scene.<br>
		Throws an exception if no scenes have been added.
	EndRem
	Method start()
		LogInfo("Starting game")
		If CountList(scenes) = 0
			LogError("TGame.start(): Cannot start game, there are no scenes")
			Return
		EndIf
		isRunning = True
		While isRunning
			Local scene:TScene = TScene(nextScene.newObject())
			currentScene = scene
			scene.isFinished = False
			LogInfo("Initializing scene: " + TTypeId.ForObject(scene).name())
			Try
				scene.init()
				'Update deltaTimer between scene switches to avoid inflating deltaTime
				deltaTimer.update()
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
				LogInfo("Cleaning up scene: " + TTypeId.ForObject(scene).name())
				scene.cleanup()
			Catch ex:Object
				LogError(ex.toString())
				Return
			EndTry
		Wend
		LogInfo("Exiting game")
	EndMethod
	
	Rem
	bbdoc: Stop the game.
	about: Clean up the current scene and exit the game loop.
	EndRem
	Method stop()
		If isRunning
			currentScene.isFinished = True
			isRunning = False
		EndIf
	EndMethod
	
Private
	
	Global Instance:TGame
	
	Method New(screenW:Int, screenH:Int, fullscreen:Int=False)
		Instance = Self
		If fullscreen
			Graphics(screenW, screenH, 32)
		Else
			Graphics(screenW, screenH)
		EndIf
	EndMethod

	Field isRunning:Int
	
	Field scenes:TList = New TList()
	
	Field currentScene:TScene
	
	Field nextScene:TTypeId
	
	Field deltaTimer:TDeltaTimer = New TDeltaTimer()
	
EndType

Rem
bbdoc: Scene base class
about:
EndRem
Type TScene Abstract

	Rem
	bbdoc: Finished flag.
	about: Set as True to mark the scene finished. It will be cleaned up
		at the end of the loop and the next scene loaded.
	EndRem
	Field isFinished:Int
	
	Rem
	bbdoc: Initialize the scene.
	about: Override this method and add initialization logic.
	EndRem
	Method init() Abstract
	
	Rem
	bbdoc: Update the scene.
	returns: Some stuff
	about:
	This function is just an example
	Pass @someText a string
	EndRem
	Method update(deltaTime:Float) Abstract
	
	Rem
	bbdoc: Render the scene.
	about: render() is called after update() by TGame. While rendering can
		also be done in update() it can be helpful separate logic from rendering.
	EndRem
	Method render() Abstract
	
	Rem
	bbdoc: Clean up after the scene.
	about: Override this method to clean up after a scene is finished.
	EndRem
	Method cleanup() Abstract

EndType
