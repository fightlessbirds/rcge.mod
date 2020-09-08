SuperStrict

Rem
bbdoc: Interpolation functions
about: These functions were adapted from the interpolation algorithms described at
http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
http://www.blitzbasic.com/codearcs/codearcs.php?code=781
EndRem
Module rcge.tween

ModuleInfo "Version: 1.0.0"
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
Function InterpolateLinear:Double(a:Float,b:Float,x:Double)
	Return a*(1-x)+b*x
End Function

Rem
bbdoc: Cosine interpolation
about: a --- b
EndRem
Function InterpolateCosine:Double(a:Float,b:Float,x:Double)
	Local f:Float=(1-Cos(x*180))*.5
	Return a*(1-f)+b*f
End Function

Rem
bbdoc: Cubic interpolation
about: a     b --- c     d
EndRem
Function InterpolateCubic:Double(a:Float,b:Float,c:Float,d:Float,x:Double)
	Local p:Float=(d-c)-(a-b)
	Return p*x*x*x+((a-b)-p)*x*x+(c-a)*x+b
End Function

Rem
bbdoc: Hermite interpolation
about: a     b --- c     d
EndRem
Function InterpolateHermite:Double(a:Float,b:Float,c:Float,d:Float,x:Double,tension:Float,bias:Float)
	Local x2:Double=x*x
	Local x3:Double=x*x2
	Local xb:Double=(1+bias)*(1-tension)/2:Double
	Return (2*x3-3*x2+1)*b+(((x3-2*x2+x)*(a+c))+(x3-x2)*(b+d))*xb+(3*x2-2*x3)*c
End Function
