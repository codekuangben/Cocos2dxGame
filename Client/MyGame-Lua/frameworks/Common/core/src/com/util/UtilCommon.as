package com.util 
{
	/**
	 * ...
	 * @author 
	 */
	public class UtilCommon 
	{
		public static const UNITSIZE:int = 32;
		public static function setState(list:Vector.<uint>, id:uint):void
		{
			var index:int = id / UNITSIZE;
			var subIndex:int = id % UNITSIZE;
			list[index] |= 1 << subIndex;
		}
		
		public static function clearState(list:Vector.<uint>, id:uint):void
		{
			var index:int = id / UNITSIZE;
			var subIndex:int = id % UNITSIZE;
			list[index] &= ~(1 << subIndex);
		}
		
		public static function isSet(list:Vector.<uint>, id:uint):Boolean
		{
			var index:int = id / UNITSIZE;
			var subIndex:int = id % UNITSIZE;
			return (list[index] & (1 << subIndex)) != 0;
		}
		
		
		public static function setStateUint(uFlag:uint, id:uint):uint
		{			
			uFlag |= 1 << id;
			return uFlag;
		}
		
		public static function clearStateUint(uFlag:uint, id:uint):uint
		{			
			uFlag &= ~(1 << id);
			return uFlag;
		}
		
		public static function isSetUint(uFlag:uint, id:uint):Boolean
		{			
			return (uFlag & (1 << id)) != 0;
		}
		
	}

}