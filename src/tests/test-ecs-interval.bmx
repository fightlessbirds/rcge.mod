SuperStrict

Framework SDL.gl2sdlmax2d

Import BRL.PNGLoader
Import BRL.RandomDefault

Import rcge.game
Import rcge.ecs
Import rcge.log

Const SCREEN_WIDTH:Int = 800
Const SCREEN_HEIGHT:Int = 600
Global TestImage:TImage = LoadImage("test-image.png")

Type TPosition
	Field x:Float
	Field y:Float
	Field velX:Float
	Field velY:Float
EndType
Global POSITION_TYPE:TTypeId = TTypeId.ForName("TPosition")

Type TDrawable
	Field image:TImage
EndType
Global DRAWABLE_TYPE:TTypeId = TTypeId.ForName("TDrawable")

Type TInterval
EndType
Global INTERVAL_TYPE:TTypeId = TTypeId.ForName("TInterval")

Type TMoveSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		For Local e:TEntity = EachIn entities
			'Skip processing entities with INTERVAL_TYPE
			If e.hasComponent(INTERVAL_TYPE) Then Continue
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
		Return [POSITION_TYPE]
	EndFunction
EndType

Type TIntervalMoveSystem Extends TIntervalSystem
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
	
	Function GetInterval:Float() Override
		Return 0.3
	EndFunction

	Function GetArchetype:TTypeId[]() Override
		Return [POSITION_TYPE, INTERVAL_TYPE]
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

Type TTestScene Extends TScene
	
	Field ecs:TEcs = New TEcs()

	Method init() Override
		ecs.profilingEnabled = True
		ecs.addComponentType(POSITION_TYPE)
		ecs.addComponentType(INTERVAL_TYPE)
		ecs.addComponentType(DRAWABLE_TYPE)
		ecs.addSystem(New TMoveSystem())
		ecs.addSystem(New TIntervalMoveSystem())
		ecs.addSystem(New TDrawSystem())
		addEntity(False)
		addEntity(True)
	EndMethod
	
	Method addEntity(isIntervalEntity:Int)
		Local e:TEntity = ecs.createEntity()
		Local pos:TPosition = TPosition(e.bind(POSITION_TYPE))
		pos.x = Rand(0, SCREEN_WIDTH)
		pos.y = Rand(0, SCREEN_HEIGHT)
		pos.velX = 25
		pos.velY = 25
		Local drawable:TDrawable = TDrawable(e.bind(DRAWABLE_TYPE))
		drawable.image = TestImage
		If isIntervalEntity
			e.bind(INTERVAL_TYPE)
		EndIf
	EndMethod
	
	Method update(deltaTime:Float) Override
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		ecs.update(deltaTime)
	EndMethod
	
	Method render() Override
	EndMethod
	
	Method cleanup() Override
	EndMethod
	
EndType

Local myGame:TGame = TGame.CreateGame(800, 600)
myGame.addScene("TTestScene")
myGame.start()