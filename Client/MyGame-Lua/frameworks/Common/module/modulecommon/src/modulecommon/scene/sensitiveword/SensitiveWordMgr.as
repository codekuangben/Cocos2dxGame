package modulecommon.scene.sensitiveword 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.TDataItem;
	import modulecommon.scene.prop.table.TSensitiveWordItem;
	/**
	 * ...
	 * @author ...
	 */
	public class SensitiveWordMgr 
	{		
		private var m_wordList:Vector.<String>;
		private var m_regExpList:Vector.<RegExp>;			
		public function SensitiveWordMgr()
		{
			
		}
		
		public function init(bytes:ByteArray):void
		{
			var len:uint = bytes.readUnsignedInt();
			m_regExpList = new Vector.<RegExp>(len, true);
			
			var i:uint = 0;
			var word:String;
			var regExp:RegExp;
			var strRegExp:String;
			var k:int;		
			for (i = 0; i < len; i++)
			{
				bytes.position += 4;
				word = TDataItem.readString(bytes);
				
						
				strRegExp = word.charAt(0);
				for (k = 1; k < word.length; k++)
				{
					strRegExp += " *" + word.charAt(k);					
				}
				regExp = new RegExp(strRegExp, "g");
				m_regExpList[i] = regExp;				
			}
		}
		/*public function init(tableData:Vector.<TDataItem>):void
		{
			m_regExpList = new Vector.<RegExp>(tableData.length, true);			
			
			var item:TSensitiveWordItem;
			var i:int = 0;
			var regExp:RegExp;
			var strRegExp:String;
			for each(item in tableData)
			{
				var k:Number;				
				strRegExp = item.m_strWord.charAt(0);
				for (k = 1; k < item.m_strWord.length; k++)
				{
					strRegExp += " *" + item.m_strWord.charAt(k);					
				}
				regExp = new RegExp(strRegExp, "g");
				m_regExpList[i] = regExp;				
				i++;				
			}
		}*/
		public function filter(strData:String):String
		{
			var sentence:String = strData;	
			var regExp:RegExp;
			for each(regExp in m_regExpList)
			{
				if ( -1 != sentence.search(regExp))
				{					
					sentence = sentence.replace(regExp, replFN);
				}
			}
			return sentence;
		}
		
		public function searchFirtSensitiveWord(strData:String):String
		{
			var sentence:String = strData;	
			var regExp:RegExp;
			for each(regExp in m_regExpList)
			{
				
				if ( -1 != sentence.search(regExp))
				{
					var list:Array = sentence.match(regExp);
					if (list && list.length)
					{
						return list[0];
					}					
				}
			}
			return null;
		}
		private static function replFN():String {
			var ret:String;			
			var len:int = arguments[0].length
			switch(len)
			{				
				case 2:ret = "**";	break;
				case 3:ret = "***";	break;
				case 4:ret = "****";	break;
				case 5:ret = "*****";	break;
				default:
				{
					ret = "*";
					var i:int;
					for (i = 1; i < len; i++)
					{
						ret += "*";
					}
				}
			}
			return ret;
		}
	}

}