SuperStrict

Rem
bbdoc: DataTypes module
about: Object wrappers for primitive data types.
EndRem
Module rcge.datatypes

ModuleInfo "Version: 0.1.0"
ModuleInfo "Author: Jason Gosen"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2021 Jason Gosen"

ModuleInfo "History: 0.1.0"
ModuleInfo "History: Initial Release"

Type TByte
	Field value:Byte
	
	Method New(value:Byte)
		Self.value = value
	EndMethod

	Method toString:String() Override
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object) Override
		Return value - TByte(withObject).value
	EndMethod
EndType

Type TShort
	Field value:Short
	
	Method New(value:Short)
		Self.value = value
	EndMethod

	Method toString:String() Override
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object) Override
		Return value - TShort(withObject).value
	EndMethod
EndType

Type TInt
	Field value:Int
	
	Method New(value:Int)
		Self.value = value
	EndMethod
	
	Method toString:String() Override
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object) Override
		Return value - TInt(withObject).value
	EndMethod
EndType

Type TUInt
	Field value:UInt
	
	Method New(value:UInt)
		Self.value = value
	EndMethod
	
	Method toString:String() Override
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object) Override
		Return value - TUInt(withObject).value
	EndMethod
EndType

Type TLong
	Field value:Long
	
	Method New(value:Long)
		Self.value = value
	EndMethod
	
	Method toString:String() Override
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object) Override
		Return value - TLong(withObject).value
	EndMethod
EndType

Type TULong
	Field value:ULong
	
	Method New(value:ULong)
		Self.value = value
	EndMethod
	
	Method toString:String() Override
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object) Override
		Return value - TULong(withObject).value
	EndMethod
EndType

Type TFloat
	Field value:Float
	
	Method New(value:Float)
		Self.value = value
	EndMethod
	
	Method toString:String() Override
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object) Override
		Return value - TFloat(withObject).value
	EndMethod
EndType

Type TDouble
	Field value:Double
	
	Method New(value:Double)
		Self.value = value
	EndMethod
	
	Method toString:String() Override
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object) Override
		Return value - TDouble(withObject).value
	EndMethod
EndType

Type TString
	Field value:String
	
	Method New(value:String)
		Self.value = value
	EndMethod
	
	Method toString:String() Override
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object) Override
		If value < TString(withObject).value Then Return -1
		If value > TString(withObject).value Then Return 1
		Return 0
	EndMethod
EndType
