Rem
bbdoc: IntervalSystem base class
about: A system that updates at a set interval rather than every frame.
EndRem
Type TIntervalSystem Extends TSystem Abstract
	
	Field time:Float
	
	Rem
	bbdoc: Get the time interval that the system should update at.
	about: Override this to return the number of seconds to wait between updating the system.
	EndRem
	Function GetInterval:Float() Abstract
	
	Rem
	bbdoc: Increase the system's interval timer.
	EndRem
	Method addTime(time:Float)
		Self.time :+ time
	EndMethod
	
	Rem
	bbdoc: Reset the system's interval timer.
	EndRem
	Method resetTime()
		time = 0.0
	EndMethod
	
EndType
