package com.util 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class UtilDictionary 
	{
		
		public static function isEmpty(dic:Dictionary):Boolean
		{
			var key:Object;
			for (key in dic)
			{
				return false;
			}
			return true;
		}
	}
}