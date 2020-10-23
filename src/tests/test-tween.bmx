SuperStrict

?win32
Framework SDL.D3D9SDLMax2D
?Not win32
Framework SDL.GL2SDLMax2D
?

Type TMyScene Extends TScene
    Field ecs:TEcs = New TEcs()

	Method init() Override
	    ecs.addComponent(POSITION_TYPE)
	    ecs.addComponent(TWEEN_TYPE)
	    ecs.addComponent(DRAWABLE_TYPE)
	    ecs.addSystem(New TTweenSystem())
	    ecs.addSystem(New TDrawSystem())
	EndMethod
	
	Method update(dt:Float) Override
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
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

Type TTween Implements IPoolable
	Const LINEAR = 1
	
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
	
    Method reset:()
		Self.tweenType = 0
		Self.componentType = componentType
		Self.fieldName = fieldName
		Self.start = start
		Self.finish = finish
		Self.duration = duration
		Self.eventListener = eventListener
	EndMethod
	
	Function CreateTween:TTween(tweenType:Int, componentType:TTypeId, fieldName:String, start:Float, finish:Float, duration:Float, eventListener:ITweenEventListener=Null)
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
