SuperStrict

Module rcge.deltatimer

Type TDeltaTimer

	Field TargetFPS:Float = 60
	Field CurrentTicks:Int
	Field LastTicks:Int
	Field FrameTime:Float
	Field DeltaTime:Float
	Field TimeScale:Float = 1.0
	Field ElapsedDelta:Float = 0.0
	Field ElapsedTime:Float = 0.0

	Method New()
		LastTicks = MilliSecs()
	End Method

Rem
bbdoc: Returns the delta time.
End Rem
	Method GetDeltaTime:Float()
		Return DeltaTime
	End Method

Rem
bbdoc: Returns the elapsed time in seconds.
End Rem
	Method GetElapsedTime:Float()
		Return ElapsedTime
	End Method
	
Rem
bbdoc: Returns the elapsed delta time in seconds.
End Rem
	Method GetElapsedDelta:Float()
		Return ElapsedDelta
	End Method

Rem
bbdoc: Returns the elapsed frame time in ms.
End Rem
	Method GetFrameTime:Float()
		Return FrameTime
	End Method

	Method Resume:Int()
		LastTicks = MilliSecs()
	End Method
	
Rem
bbdoc: Returns the target frames per second.
End Rem
	Method GetTargetFPS:Int()
		Return TargetFPS
	End Method
	
Rem
bbdoc: Sets the target frames per second.
End Rem
	Method SetTargetFPS:Int(TargetFPS:Int)
		Self.TargetFPS = TargetFPS
	End Method
	
Rem
bbdoc: Returns the Current time scale.
End Rem
	Method GetTimeScale:Float()
		Return TimeScale
	End Method
	
Rem
bbdoc: Sets time scale.
End Rem
	Method SetTimeScale:Int(TimeScale:Float)
		Self.TimeScale = TimeScale
	End Method
	
Rem
bbdoc: Updates the timers.
about: Call this when your application needs To update itself.
End Rem
	Method Update:Int()
		FrameTime = MilliSecs() - LastTicks
		LastTicks = MilliSecs()
		ElapsedTime = ElapsedTime + FrameTime
		DeltaTime = FrameTime / (1000.0 / TargetFPS) * TimeScale
		ElapsedDelta = ElapsedDelta + (DeltaTime / TargetFPS)
	End Method

End Type