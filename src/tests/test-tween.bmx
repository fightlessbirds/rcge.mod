SuperStrict

?win32
Framework SDL.D3D9SDLMax2D
?Not win32
Framework SDL.GL2SDLMax2D
?

Import BRL.PNGLoader
Import BRL.Reflection

Import rcge.game
Import rcge.ecs
Import rcge.tween
Import rcge.logger

Type TTweenTestScene Extends TScene
	Field ecs:TEcs = New TEcs()
	
	Field testEntity:TEntity

	Method Init() Override
	    ecs.addComponentType(POSITION_TYPE)
		ecs.addComponentType(DRAWABLE_TYPE)
		ecs.addComponentType(TWEENABLE_TYPE)
	    ecs.addSystem(New TTweenSystem())
		ecs.addSystem(New TDrawSystem())
		
		testEntity = ecs.createEntity()
		testEntity.bind(POSITION_TYPE)
		Local drawable:TDrawable = TDrawable(testEntity.bind(DRAWABLE_TYPE))
		drawable.image = LoadImage("test-image.png")
		testEntity.bind(TWEENABLE_TYPE)
	EndMethod
	
	Method update(dt:Float) Override
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		If MouseHit(1)
			LogInfo("Tweening to new position")
			Local tweenable:TTweenable = TTweenable(testEntity.getComponent(TWEENABLE_TYPE))
			Local pos:TPosition = TPosition(testEntity.getComponent(POSITION_TYPE))
			tweenable.stopAllTweens()
			tweenable.startTween(ETweenType.LINEAR, POSITION_TYPE, "x", pos.x, MouseX(), 0.5, New TTestTweenEventListener())
			tweenable.startTween(ETweenType.LINEAR, POSITION_TYPE, "y", pos.y, MouseY(), 0.5)
		EndIf
		ecs.update(dt)
	EndMethod
	
	Method render() Override
		DrawText("Click to move entity", 20.0, 20.0)
	EndMethod
	
	Method cleanup() Override
	EndMethod
EndType

Type TTestTweenEventListener Implements ITweenEventListener
	Method onTweenFinish(e:TEntity) Override
		LogInfo("Tween completed")
	EndMethod
EndType

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

Enum ETweenType
	LINEAR
EndEnum

Type TTween
	Field tweenType:ETweenType
    
    Field componentType:TTypeId
    Field fieldName:String
    
    Field start:Float
    Field finish:Float
    Field duration:Float
	Field position:Float
	
	Field eventListener:ITweenEventListener
	
	Method New(tweenType:ETweenType, componentType:TTypeId, fieldName:String, start:Float, finish:Float, duration:Float, eventListener:ITweenEventListener=Null)
		If duration <= 0 Then Throw("TTween.New(): duration must be greater than zero")
		Self.tweenType = tweenType
		Self.componentType = componentType
		Self.fieldName = fieldName
		Self.start = start
		Self.finish = finish
		Self.duration = duration
		Self.eventListener = eventListener
	EndMethod
EndType

Type TTweenable
    Field tweens:TList = New TList()
    
    Method startTween(tweenType:ETweenType, componentType:TTypeId, fieldName:String, start:Float, finish:Float, duration:Float, eventListener:ITweenEventListener=Null)
		tweens.addLast(New TTween(tweenType, componentType, fieldName, start, finish, duration, eventListener))
    EndMethod
    
    Method stopTweens(componentType:TTypeId)
		For Local tween:TTween = EachIn tweens
			If tween.componentType = componentType
				tweens.remove(tween)
			EndIf
		Next
    EndMethod
    
    Method stopAllTweens()
		For Local tween:TTween = EachIn tweens
			tweens.remove(tween)
		Next
    EndMethod
EndType
Global TWEENABLE_TYPE:TTypeId = TTypeId.ForName("TTweenable")

Interface ITweenEventListener
	Method onTweenFinish(e:TEntity)
EndInterface

Type TTweenSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		For Local e:TEntity = EachIn entities
			Local tweenable:TTweenable = TTweenable(e.getComponent(TWEENABLE_TYPE))
			For Local tween:TTween = EachIn tweenable.tweens
				Local tweenComponent:Object = e.getComponent(tween.componentType)
				Local tweenField:TField = tween.componentType.findField(tween.fieldName)
				If Not tweenField Then Throw("TTweenSystem.update(): component missing field " + tween.fieldName)
				If tween.tweenType = ETweenType.LINEAR
					tween.position :+ (deltaTime / tween.duration)
					If tween.position > 1.0 Then tween.position = 1.0
					tweenField.SetFloat(tweenComponent, InterpolateLinear(tween.start, tween.finish, tween.position))
					If tween.position >= 1.0
						If tween.eventListener Then tween.eventListener.onTweenFinish(e)
						tweenable.tweens.remove(tween)
					EndIf
				EndIf
			Next
		Next
	EndMethod
	
	Function GetArchetype:TTypeId[]() Override
		Return [TWEENABLE_TYPE]
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

Global game:TGame = TGame.CreateGame(800, 600)
game.addScene("TTweenTestScene")
game.start()
