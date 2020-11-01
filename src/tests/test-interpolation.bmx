SuperStrict

?win32
Framework SDL.D3D9SDLMax2D
?Not win32
Framework SDL.GL2SDLMax2D
?

Import rcge.tween

Graphics 512,512
 
Local pix_linear:TPixmap=CreatePixmap(128,256,PF_RGB888)
Local pix_cosine:TPixmap=pix_linear.copy()
Local pix_cubic:TPixmap=pix_linear.copy()
Local pix_hermite:TPixmap=pix_linear.copy()
 
Local begin_r%=0
Local begin_g%=10
Local begin_b%=32
 
Local end_r%=255
Local end_g%=70
Local end_b%=4
 
Local before_r%=0
Local before_g%=0
Local before_b%=0
 
Local after_r%=255
Local after_g%=255
Local after_b%=255
 
For Local y%=0 Until pix_linear.height
	' linear
	Local value!=y/Double(pix_linear.height)
	Local red%=  InterpolateLinear(begin_r,end_r,value)
	Local green%=InterpolateLinear(begin_g,end_g,value)
	Local blue%= InterpolateLinear(begin_b,end_b,value)
	red=Min(255,Max(0,red));green=Min(255,Max(0,green));blue=Min(255,Max(0,blue))
	Local rgb_linear%=red Shl 16 | green Shl 8 | blue
	' cosine
	red%=  InterpolateCosine(begin_r,end_r,value)
	green%=InterpolateCosine(begin_g,end_g,value)
	blue%= InterpolateCosine(begin_b,end_b,value)
	red=Min(255,Max(0,red));green=Min(255,Max(0,green));blue=Min(255,Max(0,blue))
	Local rgb_cosine%=red Shl 16 | green Shl 8 | blue
	' cubic
	red%=  InterpolateCubic(before_r,begin_r,end_r,after_r,value)
	green%=InterpolateCubic(before_g,begin_g,end_g,after_g,value)
	blue%= InterpolateCubic(before_b,begin_b,end_b,after_b,value)
	red=Min(255,Max(0,red));green=Min(255,Max(0,green));blue=Min(255,Max(0,blue))
	Local rgb_cubic%=red Shl 16 | green Shl 8 | blue
	' hermite
	red%=  InterpolateHermite(before_r,begin_r,end_r,after_r,value,0.5,0.5)
	green%=InterpolateHermite(before_g,begin_g,end_g,after_g,value,0.5,0.5)
	blue%= InterpolateHermite(before_b,begin_b,end_b,after_b,value,0.5,0.5)
	red=Min(255,Max(0,red));green=Min(255,Max(0,green));blue=Min(255,Max(0,blue))
	Local rgb_hermite%=red Shl 16 | green Shl 8 | blue
	For Local x%=0 Until pix_linear.width
		pix_linear.WritePixel(x,y,rgb_linear)
		pix_cosine.WritePixel(x,y,rgb_cosine)
		pix_cubic.WritePixel(x,y,rgb_cubic)
		pix_hermite.WritePixel(x,y,rgb_hermite)
	Next
Next
 
Local start_y%=0
Local end_y%=0
Local before_y%=0
Local after_y%=0
Local editpoint%=0
 
Repeat
	Cls
	DrawPixmap pix_linear,0,0
	DrawPixmap pix_cosine,128,0
	DrawPixmap pix_cubic,256,0
	DrawPixmap pix_hermite,384,0
	lines before_y,start_y,end_y,after_y,128,382,256
	SetColor 255,255,255
	DrawText "Linear",2,2
	DrawText "Cosine",130,2
	DrawText "Cubic",258,2
	DrawText "Hermite",386,2
	SetColor 128,128,128
	DrawText "Linear",2,260
	SetColor 255,0,0
	DrawText "Cosine",2,280
	SetColor 0,255,0
	DrawText "Cubic",2,300
	SetColor 255,255,0
	DrawText "Hermite",2,320
	Local modifier%=KeyDown(key_down)-KeyDown(key_up)
	If KeyHit(key_left) Or KeyHit(key_right) Then editpoint=Not editpoint
	If editpoint Then start_y:+modifier Else end_y:+modifier
	start_y=Min(100,Max(-100,start_y))
	end_y=Min(100,Max(-100,end_y))
	Flip
Until KeyDown(key_escape) Or AppTerminate()
 
Function lines(a%,b%,c%,d%,x%,y%,w%)
	For Local i%=0 Until w
		Local value!=i/Double(w)
		SetColor 128,128,128
		Plot x+i,y+InterpolateLinear(b,c,value)
		SetColor 255,0,0
		Plot x+i,y+InterpolateCosine(b,c,value)
		SetColor 0,255,0
		Plot x+i,y+InterpolateCubic(a,b,c,d,value)
		SetColor 255,255,0
		Plot x+i,y+InterpolateHermite(a,b,c,d,value,0.5,0.5)
	Next
End Function
