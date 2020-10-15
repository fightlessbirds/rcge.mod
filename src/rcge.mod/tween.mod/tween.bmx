SuperStrict

Rem
bbdoc: Interpolation functions
about: These functions were adapted from the interpolation algorithms described at
http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
http://www.blitzbasic.com/codearcs/codearcs.php?code=781
EndRem
Module rcge.tween

ModuleInfo "Version: 1.0.1"
ModuleInfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
ModuleInfo "License: Public Domain"
ModuleInfo "Copyright: 2020 Sophie Kirschner"

ModuleInfo "History: 1.0.0"
ModuleInfo "History: Initial Release"

Import BRL.Math

Rem
bbdoc: Linear interpolation
about: a --- b
EndRem
Function InterpolateLinear:Double(a:Float,b:Float,t:Double)
	Return a*(1-t)+b*t
End Function

Rem
bbdoc: Cosine interpolation
about: a --- b
EndRem
Function InterpolateCosine:Double(a:Float,b:Float,t:Double)
	Local f:Float=(1-Cos(t*180))*.5
	Return a*(1-f)+b*f
End Function

Rem
bbdoc: Cubic interpolation
about: a     b --- c     d
EndRem
Function InterpolateCubic:Double(a:Float,b:Float,c:Float,d:Float,t:Double)
	Local p:Float=(d-c)-(a-b)
	Return p*t*t*t+((a-b)-p)*t*t+(c-a)*t+b
End Function

Rem
bbdoc: Hermite interpolation
about: a     b --- c     d
EndRem
Function InterpolateHermite:Double(a:Float,b:Float,c:Float,d:Float,t:Double,tension:Float,bias:Float)
	Local t2:Double=t*t
	Local t3:Double=t*t2
	Local tb:Double=(1+bias)*(1-tension)/2:Double
	Return (2*t3-3*t2+1)*b+(((t3-2*t2+t)*(a+c))+(t3-t2)*(b+d))*tb+(3*t2-2*t3)*c
End Function
