SuperStrict

Rem
bbdoc: Simple event dispatcher and listener interface.
EndRem
Module rcge.event

ModuleInfo "Version: 1.0.0"
ModuleInfo "Author: fightlessbirds"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2020 fightlessbirds"

ModuleInfo "History: 1.0.0"
ModuleInfo "History: Initial Release"

Import BRL.LinkedList
Import BRL.Map

Rem
bbdoc: EventDispatcher class
EndRem
Type TEventDispatcher
	
	Rem
	bbdoc: Add an event listener.
	EndRem
	Method add(listener:IEventListener)
		Local eventName:String = listener.getEventName()
		Local listeners:TList = TList(_events.valueForKey(eventName))
		'Check if this is the first time a listener with this name was added.
		If listeners
			listeners.addLast(listener)
		Else
			listeners = New TList()
			listeners.addLast(listener)
			_events.insert(eventName, listeners)
		EndIf
	EndMethod
	
	Rem
	bbdoc: Remove an event listener.
	EndRem
	Method remove(listener:IEventListener)
		Local eventName:String = listener.getEventName()
		Local listeners:TList = TList(_events.valueForKey(eventName))
		If listeners
			listeners.remove(listener)
		EndIf
	EndMethod
	
	Rem
	bbdoc: Remove all event listeners bound to @eventName.
	EndRem
	Method removeEvent(eventName:String)
		_events.remove(eventName)
	EndMethod
	
	Rem
	bbdoc: Remove all event listeners.
	EndRem
	Method removeAll()
		_events.clear()
	EndMethod
	
	Rem
	bbdoc: Trigger events with @eventName.
	about: Optionally pass a @context to the recieving listener.
	EndRem
	Method trigger(eventName:String, context:Object=Null)
		Local listeners:TList = TList(_events.valueForKey(eventName))
		If listeners
			For Local listener:IEventListener = EachIn listeners
				listener.onEvent(Self, context)
			Next
		EndIf
	EndMethod
	
	
	Private
	
	Field _events:TStringMap = New TStringMap()
	
EndType

Rem
bbdoc: EventListener interface
EndRem
Interface IEventListener
	
	Rem
	bbdoc: Override to return a String specifying which event to listen for.
	EndRem
	Method getEventName:String()
	
	Rem
	bbdoc: Called when the event is triggered.
	about: Reference to @dispatcher can be used to remove the event listener if necessary.
	The dispatcher may pass an additional @context object.
	EndRem
	Method onEvent(dispatcher:TEventDispatcher, context:Object=Null)
	
EndInterface
