SuperStrict

?win32
Framework SDL.D3D9SDLMax2D
?Not win32
Framework SDL.GL2SDLMax2D
?

Import BRL.PNGLoader
Import BRL.RandomDefault

Import rcge.game
Import rcge.ecs
Import rcge.logger

Const SCREEN_WIDTH:Int = 800
Const SCREEN_HEIGHT:Int = 600
Global TestImage:TImage = LoadImage("test-image.png")

Global EntityCount:Int = 0

Type TPosition
	Field x:Float
	Field y:Float
	Field velX:Float
	Field velY:Float
EndType
Global POSITION_TYPE:TTypeId = TTypeId.ForName("TPosition")

Type TKillTag
EndType
Global KILLTAG_TYPE:TTypeId = TTypeId.ForName("TKillTag")

Type TDrawable
	Field image:TImage
EndType
Global DRAWABLE_TYPE:TTypeId = TTypeId.ForName("TDrawable")

Type TMoveSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		For Local e:TEntity = EachIn entities
			Local pos:TPosition = TPosition(e.getComponent(POSITION_TYPE))
			Local x:Int = pos.x
			Local y:Int = pos.y
			Local velX:Int = pos.velX
			Local velY:Int = pos.velY
			
			pos.x :+ velX * deltaTime
			pos.y :+ velY * deltaTime
			
			If x < 0 And velX < 0
				pos.velX = velX * -1
			ElseIf x > SCREEN_WIDTH And velX > 0
				pos.velX = velX * -1
			EndIf
			If y < 0 And velY < 0
				pos.velY = velY * -1
			ElseIf y > SCREEN_HEIGHT And velY > 0
				pos.velY = velY * -1
			EndIf
		Next
	EndMethod

	Function GetArchetype:TTypeId[]() Override
		Return [POSITION_TYPE, DRAWABLE_TYPE]
	EndFunction
EndType

Type TDrawSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		For Local e:TEntity = EachIn entities
			Local pos:TPosition = TPosition(e.getComponent(POSITION_TYPE))
			Local drawable:TDrawable = TDrawable(e.getComponent(DRAWABLE_TYPE))
			DrawImage(drawable.image, pos.x, pos.y)
		Next
	EndMethod

	Function GetArchetype:TTypeId[]() Override
		Return [POSITION_TYPE, DRAWABLE_TYPE]
	EndFunction
EndType

Type TKillSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		If KeyHit(Key_Backspace)
			LogInfo("Killing test entities")
			For Local e:TEntity = EachIn entities
				e.kill()
			Next
			EntityCount = 0
		EndIf
	EndMethod
	
	Function GetArchetype:TTypeId[]() Override
		Return [KILLTAG_TYPE]
	EndFunction
EndType

Type TTestScene Extends TScene
	
	Field ecs:TEcs = New TEcs()
	
	Field fps:Int = 0
	Field timeSinceFpsUpdate:Float = 0.0

	Method initialize() Override
		ecs.isProfilingEnabled = True
		ecs.addComponentType(POSITION_TYPE)
		ecs.addComponentType(DRAWABLE_TYPE)
		ecs.addComponentType(KILLTAG_TYPE)
		ecs.addSystem(New TMoveSystem())
		ecs.addSystem(New TDrawSystem())
		ecs.addSystem(New TKillSystem())
	EndMethod
	
	Method update(deltaTime:Float) Override
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		If KeyHit(Key_Space)
			'add some test entities
			For Local i:Int = 0 Until 1000
				addTestEntity()
			Next
			EntityCount :+ 1000
		EndIf
		ecs.update(deltaTime)
		timeSinceFpsUpdate :+ deltaTime
		If timeSinceFpsUpdate > 1.0
			fps = 1.0 / deltaTime
			timeSinceFpsUpdate = 0.0
		EndIf
		DrawText("FPS: " + fps, 600, 20)
		DrawText("Entity count: " + EntityCount, 600, 40)
	EndMethod
	
	Method render() Override
		DrawText("Press spacebar to create 100 entities.", 20, 20)
		DrawText("Press backspace to kill all entities.", 20, 80)
	EndMethod
	
	Method cleanup() Override
	EndMethod
	
	Method addTestEntity()
		Local e:TEntity = ecs.createEntity()
		Local pos:TPosition = TPosition(e.bind(POSITION_TYPE))
		pos.x = Rand(0, SCREEN_WIDTH)
		pos.y = Rand(0, SCREEN_HEIGHT)
		pos.velX = Rand(-20, 20)
		pos.velY = Rand(-20, 20)
		Local drawable:TDrawable = TDrawable(e.bind(DRAWABLE_TYPE))
		drawable.image = TestImage
		e.bind(KILLTAG_TYPE)
	EndMethod

EndType

Local myGame:TGame = TGame.CreateGame(800, 600)
myGame.addScene("TTestScene")
myGame.start()