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

Type TEventDispatcher
	
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
	
	Method remove(listener:IEventListener)
		Local eventName:String = listener.getEventName()
		Local listeners:TList = TList(_events.valueForKey(eventName))
		If listeners
			listeners.remove(listener)
		EndIf
	EndMethod
	
	Method removeEvent(eventName:String)
		_events.remove(eventName)
	EndMethod
	
	Method removeAll()
		_events.clear()
	EndMethod
	
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

Interface IEventListener
	
	Method getEventName:String()
	
	Method onEvent(dispatcher:TEventDispatcher, context:Object=Null)
	
EndInterface
