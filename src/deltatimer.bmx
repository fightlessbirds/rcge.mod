SuperStrict

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
		Self.LastTicks = MilliSecs()
	End Method

Rem
bbdoc: Returns the delta time.
End Rem
	Method GetDeltaTime:Float()
		Return Self.DeltaTime
	End Method

Rem
bbdoc: Returns the elapsed time in seconds.
End Rem
	Method GetElapsedTime:Float()
		Return Self.ElapsedTime
	End Method
	
Rem
bbdoc: Returns the elapsed delta time in seconds.
End Rem
	Method GetElapsedDelta:Float()
		Return Self.ElapsedDelta
	End Method

Rem
bbdoc: Returns the elapsed frame time in ms.
End Rem
	Method GetFrameTime:Float()
		Return Self.FrameTime
	End Method

	Method Resume:Int()
		Self.LastTicks = MilliSecs()
	End Method
	
Rem
bbdoc: Returns the target frames per second.
End Rem
	Method GetTargetFPS:Int()
		Return Self.TargetFPS
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
		Return Self.TimeScale
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
		Self.FrameTime = MilliSecs() - Self.LastTicks
		Self.LastTicks = MilliSecs()
		Self.ElapsedTime = Self.ElapsedTime + Self.FrameTime
		Self.DeltaTime = Self.FrameTime / (1000.0 / Self.TargetFPS) * Self.TimeScale
		Self.ElapsedDelta = Self.ElapsedDelta + (Self.DeltaTime / Self.TargetFPS)
	End Method

End Type