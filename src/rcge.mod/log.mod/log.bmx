SuperStrict

Module rcge.log

Import BRL.StandardIO
Import BRL.StringBuilder

Global Rcge_GameStartTime:Int = MilliSecs()

Function RcgeTimestampConvert:TStringBuilder(timeMilliseconds:Int)
	Local milliseconds:Int = timeMilliseconds Mod 1000
	Local seconds:Int = ((timeMilliseconds - milliseconds) / 1000) Mod 60
	Local minutes:Int = ((((timeMilliseconds - milliseconds) / 1000) - seconds) / 60) Mod 60
	Local hours:Int = (((((timeMilliseconds - milliseconds) / 1000) - seconds) / 60) - minutes) / 60
	Local timestamp:TStringBuilder = new TStringBuilder()
	timestamp.append(hours)
	timestamp.append(":")
	timestamp.append(minutes)
	timestamp.append(":")
	timestamp.append(seconds)
	timestamp.append(":")
	timestamp.append(milliseconds)
	Return timestamp
EndFunction

Function RcgeLogInfo(msg:String)
	Local uptime:Int = MilliSecs() - Rcge_GameStartTime
	Local logStringBuilder:TStringBuilder = RcgeTimestampConvert(uptime)
	logStringBuilder.append(" [INFO] ")
	logStringBuilder.append(msg)
	Print(logStringBuilder.toString())
EndFunction

Function RcgeThrowError(err:String)
	Local uptime:Int = MilliSecs() - Rcge_GameStartTime
	Local logStringBuilder:TStringBuilder = RcgeTimestampConvert(uptime)
	logStringBuilder.append(" [ERROR] ")
	logStringBuilder.append(err)
	Throw(logStringBuilder.toString())
EndFunction