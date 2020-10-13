
# RCGE
Random Cruft Game Engine - A BlitzMax game framework

(Requires BlitzMax v0.120.3.41)

### game.mod
##### Usage Example
``` BlitzMax
SuperStrict
Import rcge.game

Type TMyScene Extends TScene
	Method init() Override
	EndMethod
	
	Method update(dt:Float) Override
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
	EndMethod
	
	Method render() Override
		DrawText("It works!", 100, 100)
	EndMethod
	
	Method cleanup() Override
	EndMethod
EndType

Local myGame:TGame = TGame.CreateGame(800, 600)
myGame.addScene("TMyScene")
myGame.start()
```

### ecs.mod
##### Entities
Entities are essentially a bag of components.
``` BlitzMax
'Creation of a new entity
Local e:TEntity = ecs.createEntity()
'Add a component to the entity and initialize the data if necessary
Local rect:TPosRect = TPosRect(e.bind(POSRECT_TYPE))
rect.x = 100.0
rect.y = 100.0
rect.w = 50.0
rect.h = 50.0

'Entities can also be created from an archetype
Local e:TEntity = ecs.createEntity(ENEMY_MISSILE_ARCHETYPE)
```
##### Components
A component is simply a class.
``` BlitzMax
Type TPosRect
	Field x:Float
	Field y:Float
	Field w:Float
	Field h:Float
EndType

Type TEnemyMissile
	'Empty components can be used as a sort of "tag" for certain entities.
EndType
```
##### Systems
Systems contain the logic that is applied to a specific archetype.
``` BlitzMax
Type TEnemyMissileSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		For Local e:TEntity = EachIn entities
			'The system can get whatever component it needs from the entity.
			Local pos:TPosRect = TPosRect(e.getComponent(POSRECT_TYPE))
			pos.x :+ MISSILE_SPEED * deltaTime
			'Maybe do some collision check and stuff...
		Next
	EndMethod
	
	'Archetypes allow systems to say which entities they care about.
	Function GetArchetype:TTypeId[]() Override
		Return [ENEMY_MISSILE_ARCHETYPE]
	EndFunction
EndType
```
##### Archetypes
Archetypes are a combination of components held by one or more entities. They are used to query for and create new entities. In the code they are expressed as an array of TTypeId objects.

##### Usage Example
``` BlitzMax
SuperStrict

Framework SDL.gl2sdlmax2d

Import rcge.ecs

'Component type definition
Type TMessage
	Field msg:String
EndType
'Hold on to the TTypeId so we don't have to lookup again.
Global MESSAGE_TYPE:TTypeId = TTypeId.ForName("TMessage")

'System definition
Type TTestSystem Extends TSystem
	Method update(entities:TEntity[], deltaTime:Float) Override
		For Local e:TEntity = EachIn entities
			'Typecast the retrieved component. It is assumed that all
			'component types are known at compile time.
			Local c:TMessage = TMessage(e.getComponent(MESSAGE_TYPE))
			DrawText(c.msg, 300, 200)
		Next
	EndMethod
	
	'Let the ECS know which entities this system will process.
	Function GetArchetype:TTypeId[]() Override
		Return [MESSAGE_TYPE]
	EndFunction
EndType

'Create and initialize the ECS
Local ecs:TEcs = New TEcs()
ecs.addComponentType(MESSAGE_TYPE)
ecs.addSystem(New TTestSystem())

'Create a test entity
Local e:TEntity = ecs.createEntity()
Local c:TMessage = TMessage(e.bind(MESSAGE_TYPE))
c.msg = "Hello ECS =)"

'Start app loop
Graphics(640, 480)
Repeat
	Cls()
	ecs.update(MilliSecs() / 1000.0)
	Flip()
Until KeyHit(Key_Escape)
```
