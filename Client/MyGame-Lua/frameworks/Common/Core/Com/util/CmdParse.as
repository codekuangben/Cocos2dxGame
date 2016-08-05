package com.util 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class CmdParse 
	{
		private var _cmd:String;
		private var _dic:Dictionary;
		public function CmdParse() 
		{
			_dic = new Dictionary();
		}
		public function parse(param:String):void
		{
			var ar:Array;
			ar = param.match(/[^\s=]+/);
			if (ar == null || ar.length == 0)
			{
				return;
			}
			_cmd = ar[0];
			
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
		public function get cmd():String
		{
			return _cmd;
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
		
		public function getUintValue(name:String):uint
		{
			var ret:uint;
			var value:String = getValue(name);
			if (value == null)
			{
				return 0;
			}
			ret = parseFloat(value) as uint;
			return ret;
		}
		
		public function get dic():Dictionary
		{
			return _dic;
		}
		
	}

}