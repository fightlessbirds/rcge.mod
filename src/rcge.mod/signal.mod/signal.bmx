SuperStrict

Rem
bbdoc: Signal/Slot
about: A simple way to dispatch an object to any interested parties.
EndRem
Module rcge.signal

ModuleInfo "Version: 1.0.0"
ModuleInfo "Author: fightlessbirds"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2020 fightlessbirds"

ModuleInfo "History: 1.0.0"
ModuleInfo "History: Initial Release"

Import BRL.LinkedList

Rem
bbdoc: Signal class
EndRem
Type TSignal<T>
	
	Rem
	bbdoc: Added slots will be notified when dispatch() is called.
	EndRem
	Method add(slot:TSlot<T>)
		_slots.addLast(slot)
	EndMethod
	
	Method remove(slot:TSlot<T>)
		_slots.remove(slot)
	EndMethod
	
	Method removeAll()
		_slots.clear()
	EndMethod
	
	Rem
	bbdoc: Send an object to all connected slots.
	EndRem
	Method dispatch(obj:T)
		For Local slot:TSlot<T> = EachIn _slots
			slot.recieve(Self, obj)
		Next
	EndMethod
	
	
	Private
	
	Field _slots:TList = New TList()
	
EndType

Rem
bbdoc: Slot interface
EndRem
Interface ISlot<T>
	
	Method recieve(signal:TSignal<T>, obj:T)
	
EndInterface
