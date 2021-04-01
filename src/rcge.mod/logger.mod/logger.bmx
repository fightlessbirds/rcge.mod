SuperStrict

Rem
bbdoc: Logging functions
EndRem
Module rcge.logger

ModuleInfo "Version: 0.1.0"
ModuleInfo "Author: Jason Gosen"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2021 Jason Gosen"

ModuleInfo "History: 0.1.0"
ModuleInfo "History: Initial Release"

Import BRL.StandardIO
Import BRL.StringBuilder

Function LogInfo(msg:String)
	Local uptime:Int = MilliSecs() - Rcge_GameStartTime
	Local logStringBuilder:TStringBuilder = TimestampConvert(uptime)
	logStringBuilder.append(" [INFO] ")
	logStringBuilder.append(msg)
	Print(logStringBuilder.toString())
EndFunction

Function LogWarn(msg:String)
	Local uptime:Int = MilliSecs() - Rcge_GameStartTime
	Local logStringBuilder:TStringBuilder = TimestampConvert(uptime)
	logStringBuilder.append(" [WARN] ")
	logStringBuilder.append(msg)
	Print(logStringBuilder.toString())
EndFunction

Function LogError(err:String)
	Local uptime:Int = MilliSecs() - Rcge_GameStartTime
	Local logStringBuilder:TStringBuilder = TimestampConvert(uptime)
	logStringBuilder.append(" [ERROR] ")
	logStringBuilder.append(err)
	Print(logStringBuilder.toString())
EndFunction

Private

Global Rcge_GameStartTime:Int = MilliSecs()

Function TimestampConvert:TStringBuilder(timeMilliseconds:Int)
	Local milliseconds:Int = timeMilliseconds Mod 1000
	Local seconds:Int = ((timeMilliseconds - milliseconds) / 1000) Mod 60
	Local minutes:Int = ((((timeMilliseconds - milliseconds) / 1000) - seconds) / 60) Mod 60
	Local hours:Int = (((((timeMilliseconds - milliseconds) / 1000) - seconds) / 60) - minutes) / 60
	Local timestamp:TStringBuilder = New TStringBuilder()
	timestamp.append(hours)
	
	If minutes < 10
		timestamp.append(":0")
	Else
		timestamp.append(":")
	EndIf
	timestamp.append(minutes)
	
	If seconds < 10
		timestamp.append(":0")
	Else
		timestamp.append(":")
	EndIf
	timestamp.append(seconds)
	
	If milliseconds < 10
		timestamp.append(":00")
	ElseIf milliseconds < 100
		timestamp.append(":0")
	Else
		timestamp.append(":")
	EndIf
	timestamp.append(milliseconds)
	
	Return timestamp
EndFunction
