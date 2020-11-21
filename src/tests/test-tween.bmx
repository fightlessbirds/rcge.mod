SuperStrict

?win32
Framework SDL.D3D9SDLMax2D
?Not win32
Framework SDL.GL2SDLMax2D
?

Type TMyScene Extends TScene
	Field ecs:TEcs = New TEcs()
	
	Field testEntity:TEntity

	Method init() Override
	    ecs.addComponent(POSITION_TYPE)
		ecs.addComponent(DRAWABLE_TYPE)
		ecs.addComponent(TWEEN_TYPE)
	    ecs.addSystem(New TTweenSystem())
		ecs.addSystem(New TDrawSystem())
		
		testEntity = ecs.createEntity()
		testEntity.bind(POSITION_TYPE)
		Local drawable:TDrawable = TDrawable(testEntity.bind(DRAWABLE_TYPE))
		drawable.image = LoadImage("test-image.png")
		testEntity.bind(TWEEN_TYPE)
	EndMethod
	
	Method update(dt:Float) Override
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
		If MouseHit(1)
			Local tweenable:TTweenable = TTweenable(testEntity.getComponent(TWEEN_TYPE))
			Local pos:TPosition = TPosition(testEntity.getComponent(POSITION_TYPE))
			tweenable.stopAllTweens()
			tweenable.startTween(ETweenType.LINEAR, POSITION_TYPE, "x", pos.x, MouseX(), 2.0)
			tweenable.startTween(ETweenType.LINEAR, POSITION_TYPE, "y", pos.y, MouseY(), 2.0)
		EndIf
		ecs.update(dt)
	EndMethod
	
	Method render() Override
	EndMethod
	
	Method cleanup() Override
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

Type TTween Implements IPoolable
	Field tweenType:Int
    
    Field componentType:TTypeId
    Field fieldName:String
    
    Field start:Float
    Field finish:Float
    Field duration:Float
	Field position:Float
	
	Field eventListener:ITweenEventListener
	
	Method destroy()
		TweenPool.free(Self)
	EndMethod
	
    Method reset()
		Self.tweenType = ETweenType.LINEAR
		Self.componentType = Null
		Self.fieldName = Null
		Self.start = 0.0
		Self.finish = 0.0
		Self.duration = 0.0
		Self.eventListener = Null
	EndMethod
	
	Function CreateTween:TTween(tweenType:ETweenType, componentType:TTypeId, fieldName:String, start:Float, finish:Float, duration:Float, eventListener:ITweenEventListener=Null)
		Local tween:TTween = TweenPool.obtain()
		tween.tweenType = tweenType
		tween.componentType = componentType
		tween.fieldName = fieldName
		tween.start = start
		tween.finish = finish
		tween.duration = duration
		tween.eventListener = eventListener
		Return tween
	EndFunction
    
    
    Private
    
    Global TweenPool:TPool<TTween> = New TPool<TTween>()
EndType

Type TTweenable
    Field tweens:TList = New TList()
    
    Method startTween(tweenType:Int, componentType:TTypeId, fieldName:String, start:Float, finish:Float, duration:Float, eventListener:ITweenEventListener=Null)
		tweens.addLast(TTween.CreateTween(tweenType, componentType, fieldName, start, finish, duration, eventListener))
    EndMethod
    
    Method stopTweens(componentType:TTypeId)
		For Local tween:TTween = EachIn tweens
			If tween.tweenType = componentType
				tweens.remove(tween)
				tween.destroy()
			EndIf
		Next
    EndMethod
    
    Method stopAllTweens()
		For Local tween:TTween = EachIn tweens
			tweens.remove(tween)
			tween.destroy()
		Next
    EndMethod
EndType
Global TWEENABLE_TYPE:TTypeId = TTypeId.forName("TTweenable")

Interface ITweenEventListener
	Method onTweenFinish(e:TEntity)
EndInterface

Type TTweenSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		For Local e:TEntity = EachIn entities
			'TODO update tweens
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
game.addScene("TTweenTest")
game.start()
