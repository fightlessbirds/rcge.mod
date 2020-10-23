SuperStrict

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

Enum ETweenType
    Linear
EndEnum

Type TTween
    Field type:ETweenType
    
    Field componentType:TTypeId
    Field fieldName:String
    
    Field start:Float
    Field end:Float
    Field duration:Float
    Field position:Float
    
    Function CreateTween:TTween(tweenType:ETweenType, componentType:TTypeId, field:String, start:Float, end:Float, duration:Float, eventListener:ITweenEventListener=Null)
        
    EndFunction
    
    
    Private
    
    Global TweenPool:TPool<TTween> = New TPool<TTween>()
    
    'Private constructor
    Method New()
    EndMethod
EndType

Type TTweenable
    Field tweens:TList = New TList()
    
    Method startTween(tweenType:ETweenType, componentType:TTypeId, field:String, start:Float, end:Float, duration:Float, eventListener:ITweenEventListener=Null)
        
    EndMethod
    
    Method stopTween(componentType:TTypeId, field:String)
    
    EndMethod
    
    Method stopTweens(componentType:TTypeId)
    
    EndMethod
    
    Method stopAllTweens()
    
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
