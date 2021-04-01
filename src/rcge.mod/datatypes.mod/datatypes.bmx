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
	
	Method toString:String()
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object)
		Return value - TByte(withObject).value
	EndMethod
EndType

Type TShort
	Field value:Short
	
	Method toString:String()
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object)
		Return value - TShort(withObject).value
	EndMethod
EndType

Type TInt
	Field value:Int
	
	Method toString:String()
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object)
		Return value - TInt(withObject).value
	EndMethod
EndType

Type TUInt
	Field value:UInt
	
	Method toString:String()
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object)
		Return value - TUInt(withObject).value
	EndMethod
EndType

Type TLong
	Field value:Long
	
	Method toString:String()
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object)
		Return value - TLong(withObject).value
	EndMethod
EndType

Type TULong
	Field value:ULong
	
	Method toString:String()
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object)
		Return value - TULong(withObject).value
	EndMethod
EndType

Type TFloat
	Field value:Float
	
	Method toString:String()
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object)
		Return value - TFloat(withObject).value
	EndMethod
EndType

Type TDouble
	Field value:Double
	
	Method toString:String()
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object)
		Return value - TDouble(withObject).value
	EndMethod
EndType

Type TString
	Field value:String
	
	Method toString:String()
		Return String(value)
	EndMethod
	
	Method compare:Int(withObject:Object)
		If value < TString(withObject).value Then Return -1
		If value > TString(withObject).value Then Return 1
		Return 0
	EndMethod
EndType
