SuperStrict

Rem
bbdoc: RCGE Entity Component System
about: An object-oriented entity component system.
EndRem
Module rcge.ecs

ModuleInfo "Version: 0.3.3"
ModuleInfo "Author: Jason Gosen"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2021 Jason Gosen"

ModuleInfo "History: TEntity.bind(Object) added for binding existing component objects."
ModuleInfo "History: Improved system profiler."
ModuleInfo "History: TEcs.clear() for quickly destroying all entities."
ModuleInfo "History: Added TIntervalSystem class which supports updating entities at set time intervals."
ModuleInfo "History: 0.3.0"
ModuleInfo "History: Added an event dispatcher to TEcs. Event listeners can be added, removed and triggered with optional context data."
ModuleInfo "Histroy: Added a component operation buffer that is flushed after each system is update for better concurrency."
ModuleInfo "History: Changed TList to TObjectList in some key performance areas."
ModuleInfo "History: Entities are now passed to systems as a simple array TEntity[]."
ModuleInfo "History: Systems can be standalone and operate once per loop without entities."
ModuleInfo "History: Wait until update is finished before removing dead entities."
ModuleInfo "History: Fixed a bug with query() being too strict, added new method queryStrict() as a side-effect."
ModuleInfo "History: 0.2.0"
ModuleInfo "History: Able to query for entities by their constituent components."
ModuleInfo "History: Entities can by constructed from an Archetype which is a set of component types."
ModuleInfo "History: Complete rewrite, the ECS is now an object and there can be many of them."
ModuleInfo "History: 0.1.0"
ModuleInfo "History: Initial Release"

Import BRL.LinkedList
Import BRL.Map
Import BRL.ObjectList
Import BRL.Reflection

Import rcge.event
Import rcge.logger
Import rcge.datatypes

Include "TEntity.bmx"
Include "TSystem.bmx"
Include "TIntervalSystem.bmx"
Include "TComponentOperationBuffer.bmx"
Include "TEcs.bmx"
