package com.util 
{
	import org.ffilmation.engine.datatypes.fPoint3d;
	/**
	 * ...
	 * @author zouzhiqiang 
	 */
	public class UtilColor 
	{		
		public static const WHITE_Yellow:uint = 0xfbdda2;
		public static const WHITE_B:uint = 0xbbbbbb;		
		public static const WHITE:uint = 0xffffff;		
		public static const GREEN:uint = 0x04EF25;
		public static const RED:uint = 0xff0000;
		public static const BLUE:uint = 0x32A2F8;
		public static const PURPLE:uint = 0xA838F7;
		public static const GOLD:uint = 0xFFE251;
		public static const WHITE2:uint = 0xcccccc;
		public static const WHITE3:uint = 0xbbbbbb;
		public static const GRAY:uint = 0x999999;
		public static const BLACK:uint = 0x000000;
		public static const YELLOW:uint = 0xFFFF00;
		public static const COLOR2:uint = 0xffeec0;	// label 颜色
		
		public static const COLOR1:uint = tuple3Touint(140, 110, 84);
		
		//将3元组的数值转换为一个uint数值
		public static function tuple3Touint(r:uint, g:uint, b:uint):uint
		{
			return (r << 16) + (g << 8) + b;
		}
		
		public static function tuple3TouintEx(sor:fPoint3d):uint
		{
			return tuple3Touint(sor.x,sor.y,sor.z);
		}
		
		public static function uintToTuple3(color:uint):fPoint3d
		{
			var ret:fPoint3d = new fPoint3d(0,0,0);
			
			ret.x = (color & 0xff0000) >> 16;
			ret.y = (color & 0xff00) >> 8;
			ret.z = (color & 0xff);
			return ret;
		}
		public static function Tuple3Scale(sor:fPoint3d, s:Number):fPoint3d
		{
			var ret:fPoint3d = new fPoint3d(0,0,0);
			ret.x = sor.x * s;	if (ret.x > 255) ret.x = 255;
			ret.y = sor.y * s;	if (ret.y > 255) ret.y = 255;
			ret.z = sor.z * s;	if (ret.z > 255) ret.z = 255;
			return ret;
		}
		
		public static function unitScale(color:uint, s:Number):uint
		{
			return tuple3TouintEx(Tuple3Scale(uintToTuple3(color), s));
	
		}
		
	}

}