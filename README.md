
# RCGE
Random Cruft Game Engine - A BlitzMax game framework

### game.mod
##### Usage Example
``` BlitzMax
SuperStrict
Import rcge.game

Type TMyScene Extends TScene
	Method init()
	EndMethod
	
	Method update(dt:Float)
		If KeyHit(Key_Escape) Then TGame.GetInstance().stop()
	EndMethod
	
	Method render()
		DrawText("It works!", 100, 100)
	EndMethod
	
	Method cleanup()
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
Local rect:TPosRect = TPosRect(e.bind("TPosRect"))
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
	Function Update(entities:TList, deltaTime:Float)
		For Local e:TEntity = EachIn entities
			'The system can get whatever component it needs from the entity.
			Local pos:TPosRect = TPosRect(e.getComponent("TPosRect"))
			pos.x :+ MISSILE_SPEED * deltaTime
			'Maybe do some collision check and stuff...
		Next
	EndFunction
	
	'Archetypes allow systems to say which entities they care about.
	Function getArchetype:String[]()
		Return ["TEnemyMissile"]
	EndFunction
EndType
```
##### Archetypes
Archetypes are a combination of components held by one or more entities. They are used to query for and create new entities.
``` BlitzMax
ENEMY_MISSILE_ARCHETYPE = ["TPosRect", "TImage", "TEnemyMissile"]
```
##### Usage Example
``` BlitzMax
SuperStrict
Import rcge.ecs

Type TMessage
	Field msg:String
EndType

Type TTestSystem Extends TSystem
	Function Update(entities:TList, deltaTime:Float)
		For Local e:TEntity = EachIn entities
			Local c:TMessage = TMessage(e.getComponent("TMessage"))
			DrawText(c.msg, 300, 200)
		Next
	EndFunction
	
	Function GetArchetype:String[]()
		Return ["TMessage"]
	EndFunction
EndType

Local ecs:TEcs = New TEcs()
ecs.addComponentType("TMessage")
ecs.addSystem(New TTestSystem())

Local e:TEntity = ecs.createEntity()
Local c:TMessage = TMessage(e.bind("TMessage"))
c.msg = "Hello ECS =)"

Graphics(640, 480)
Repeat
	Cls()
	ecs.update(MilliSecs() / 1000.0)
	Flip()
Until KeyHit(Key_Escape)
```
