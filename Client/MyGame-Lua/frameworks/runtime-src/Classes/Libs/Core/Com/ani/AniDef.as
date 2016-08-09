package com.ani 
{
	/**
	 * ...
	 * @author 
	 */
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Bounce;
	import com.gskinner.motion.easing.Circular;
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.easing.Elastic;
	import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Quadratic;
	import com.gskinner.motion.easing.Quartic;
	import com.gskinner.motion.easing.Quintic;
	import com.gskinner.motion.easing.Sine;
	
	public class AniDef 
	{
		
		public static function s_nameToClass(name:String):Class
		{			
			switch(name)
			{
				case "AniComposeParallel": return AniComposeParallel;
				case "AniPropertys": return AniPropertys;
				case "AniComposeSequence": return AniComposeSequence;		
				case "AniPause": return AniPause;	
				case "AniToDestPostion_BezierCurve1": return AniToDestPostion_BezierCurve1;	
				case "AniToDestPostion_BezierCurve2": return AniToDestPostion_BezierCurve2;	
				
			}
			return null;
		}
		public static function s_getEaseFunByName(funType:String):Function
		{
			var type:int = AniDef[funType];
			return s_getEaseFun(type);
		}
		public static function s_getEaseFun(funType:int):Function
		{
			var ret:Function;
			switch(funType)
			{
				case EASE_Back_easeIn:ret = Back.easeIn; break;
				case EASE_Back_easeOut:ret = Back.easeOut; break;
				case EASE_Back_easeInOut:ret = Back.easeInOut; break;
				
				case EASE_Bounce_easeIn:ret = Bounce.easeIn; break;
				case EASE_Bounce_easeOut:ret = Bounce.easeOut; break;
				case EASE_Bounce_easeInOut:ret = Bounce.easeInOut; break;
				
				case EASE_Circular_easeIn:ret = Circular.easeIn; break;
				case EASE_Circular_easeOut:ret = Circular.easeOut; break;
				case EASE_Circular_easeInOut:ret = Circular.easeInOut; break;
				
							
				case EASE_Cubic_easeIn:ret = Cubic.easeIn; break;
				case EASE_Cubic_easeOut:ret = Cubic.easeOut; break;
				case EASE_Cubic_easeInOut:ret = Cubic.easeInOut; break;
				
				case EASE_Elastic_easeIn:ret = Elastic.easeIn; break;
				case EASE_Elastic_easeOut:ret = Elastic.easeOut; break;
				case EASE_Elastic_easeInOut:ret = Elastic.easeInOut; break;
				
				case EASE_Exponential_easeIn:ret = Exponential.easeIn; break;
				case EASE_Exponential_easeOut:ret = Exponential.easeOut; break;
				case EASE_Exponential_easeInOut:ret = Exponential.easeInOut; break;
				
				case EASE_Linear_easeNone:ret = Linear.easeNone; break;				
				
				case EASE_Quadratic_easeIn:ret = Quadratic.easeIn; break;
				case EASE_Quadratic_easeOut:ret = Quadratic.easeOut; break;
				case EASE_Quadratic_easeInOut:ret = Quadratic.easeInOut; break;
				
				case EASE_Quartic_easeIn:ret = Quartic.easeIn; break;
				case EASE_Quartic_easeOut:ret = Quartic.easeOut; break;
				case EASE_Quartic_easeInOut:ret = Quartic.easeInOut; break;
				
				case EASE_Quintic_easeIn:ret = Quintic.easeIn; break;
				case EASE_Quintic_easeOut:ret = Quintic.easeOut; break;
				case EASE_Quintic_easeInOut:ret = Quintic.easeInOut; break;
				
				case EASE_Sine_easeIn:ret = Sine.easeIn; break;
				case EASE_Sine_easeOut:ret = Sine.easeOut; break;
				case EASE_Sine_easeInOut:ret = Sine.easeInOut; break;
				
			}
			return ret;
		}
		public static const EASE_Back_easeIn:int = 33;
		public static const EASE_Back_easeOut:int = 1;
		public static const EASE_Back_easeInOut:int = 2;
		
		public static const EASE_Bounce_easeIn:int = 3;
		public static const EASE_Bounce_easeOut:int = 4;
		public static const EASE_Bounce_easeInOut:int = 5;
		
		public static const EASE_Circular_easeIn:int = 6;
		public static const EASE_Circular_easeOut:int = 7;
		public static const EASE_Circular_easeInOut:int = 8;
		
		public static const EASE_Cubic_easeIn:int = 9;
		public static const EASE_Cubic_easeOut:int = 10;
		public static const EASE_Cubic_easeInOut:int = 11;
		
		public static const EASE_Elastic_easeIn:int = 12;
		public static const EASE_Elastic_easeOut:int = 13;
		public static const EASE_Elastic_easeInOut:int = 14;
		
		public static const EASE_Exponential_easeIn:int = 15;
		public static const EASE_Exponential_easeOut:int = 16;
		public static const EASE_Exponential_easeInOut:int = 17;
		
		public static const EASE_Linear_easeNone:int = 18;		
		
		public static const EASE_Quadratic_easeIn:int = 21;
		public static const EASE_Quadratic_easeOut:int = 22;
		public static const EASE_Quadratic_easeInOut:int = 23;
		
		public static const EASE_Quartic_easeIn:int = 24;
		public static const EASE_Quartic_easeOut:int = 25;
		public static const EASE_Quartic_easeInOut:int = 26;
		
		public static const EASE_Quintic_easeIn:int = 27;
		public static const EASE_Quintic_easeOut:int = 28;
		public static const EASE_Quintic_easeInOut:int = 29;	
		
		public static const EASE_Sine_easeIn:int = 30;
		public static const EASE_Sine_easeOut:int = 31;
		public static const EASE_Sine_easeInOut:int = 32;	
		
	}

}