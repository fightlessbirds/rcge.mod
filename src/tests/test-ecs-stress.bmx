SuperStrict

?win32
Framework SDL.d3d9sdlmax2d
?Not win32
Framework SDL.gl2sdlmax2d
?

Import BRL.PNGLoader
Import BRL.Random

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

Type TKillTag
EndType

Type TDrawable
	
	Field image:TImage
	
EndType

Type TMoveSystem Extends TSystem

	Method update(entities:TEntity[], deltaTime:Float)
		For Local e:TEntity = EachIn entities
			Local posRect:TPosition = TPosition(e.getComponent("TPosition"))
			posRect.x :+ posRect.velX * deltaTime
			posRect.y :+ posRect.velY * deltaTime
		Next
	EndMethod

	Function GetArchetype:String[]()
		Return ["TPosition", "TDrawable"]
	EndFunction
	
EndType

Type TDrawSystem Extends TSystem

	Method update(entities:TEntity[], deltaTime:Float)
		For Local e:TEntity = EachIn entities
			Local pos:TPosition = TPosition(e.getComponent("TPosition"))
			Local drawable:TDrawable = TDrawable(e.getComponent("TDrawable"))
			DrawImage(drawable.image, pos.x, pos.y)
		Next
	EndMethod

	Function GetArchetype:String[]()
		Return ["TPosition", "TDrawable"]
	EndFunction
	
EndType

Type TKillSystem Extends TSystem
	
	Method update(entities:TEntity[], deltaTime:Float)
		If KeyHit(Key_Backspace)
			LogInfo("Killing test entities")
			For Local e:TEntity = EachIn entities
				e.kill()
			Next
		Else
			For Local e:TEntity = EachIn entities
				Local pos:TPosition = TPosition(e.getComponent("TPosition"))
				Local isOffScreen:Int = False
				If pos.x < 0 Or pos.x > SCREEN_WIDTH Or pos.y < 0 Or pos.y > SCREEN_HEIGHT Then isOffScreen = True
				If isOffScreen
					LogInfo("Entity moved off screen " + e.getId())
					e.kill()
				EndIf
			Next
		EndIf
	EndMethod
	
	Function GetArchetype:String[]()
		Return ["TKillTag"]
	EndFunction
	
EndType

Type TTestScene Extends TScene
	
	Field ecs:TEcs = New TEcs()

	Method init()
		ecs.addComponentType("TPosition")
		ecs.addComponentType("TDrawable")
		ecs.addComponentType("TKillTag")
		ecs.addSystem(New TMoveSystem())
		ecs.addSystem(New TDrawSystem())
		ecs.addSystem(New TKillSystem())
		addTestEntity()
	EndMethod
	
	Method update(deltaTime:Float)
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		If KeyHit(Key_Space)
			'add some test entities
			For Local i:Int = 0 Until 10
				addTestEntity()
			Next
		EndIf
		ecs.update(deltaTime)
	EndMethod
	
	Method render()
		DrawText("Press spacebar to create entities.", 20, 20)
		DrawText("Press backspace to kill all entities.", 20, 80)
	EndMethod
	
	Method cleanup()
	EndMethod
	
	Method addTestEntity()
		Local e:TEntity = ecs.createEntity()
		Local pos:TPosition = TPosition(e.bind("TPosition"))
		pos.x = Rand(0, SCREEN_WIDTH)
		pos.y = Rand(0, SCREEN_HEIGHT)
		pos.velX = Rand(-20, 20)
		pos.velY = Rand(-20, 20)
		Local drawable:TDrawable = TDrawable(e.bind("TDrawable"))
		drawable.image = TestImage
		e.bind("TKillTag")
	EndMethod

EndType

Local myGame:TGame = TGame.CreateGame(800, 600)
myGame.addScene("TTestScene")
myGame.start()