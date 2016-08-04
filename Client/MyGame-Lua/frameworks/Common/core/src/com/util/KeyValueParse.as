package com.util 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 * 键-值解析器
	 * parse的参数形式为"caption=帮刘德华 eventid=v1003 questid=10020 embranchmentid=2"
	 */
	import flash.utils.Dictionary;
	public class KeyValueParse 
	{
		private var _dic:Dictionary;
		public function KeyValueParse() 
		{
			_dic = new Dictionary();
		}
		public function parse(param:String):void
		{
			var ar:Array;
			
			var arAttr:Array;
			ar = param.match(/[^\s=]+ *= *[^\s=]+/g);
			for (var i:int = 0; i < ar.length; i++)
			{
				arAttr = ar[i].match(/[^\s=]+/g);
				if (arAttr.length == 2)
				{
					_dic[arAttr[0]] = arAttr[1];
				}
			}			
		}		
		public function getValue(name:String):String
		{
			if (_dic[name] != undefined)
			{
				return _dic[name] as String;
			}
			return null;
		}
		
		public function getIntValue(name:String):int
		{
			var ret:int;
			var value:String = getValue(name);
			if (value == null)
			{
				return 0;
			}
			ret = parseInt(value, 10);
			return ret;
		}
		public function getNumberValue(name:String):Number
		{
			var ret:Number;
			var value:String = getValue(name);
			if (value == null)
			{
				return 0;
			}
			ret = parseFloat(value);
			return ret;
		}
		public function get dic():Dictionary
		{
			return _dic;
		}
	}

}