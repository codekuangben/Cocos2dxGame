package modulecommon.scene.jiuguan 
{
	/**
	 * ...
	 * @author 
	 */
	public class Heropub 
	{
		public var m_level:uint;		//紫将开放等级
		public var m_purpleheroList:Vector.<uint>;	//开放等级段武将
		
		public function Heropub()
		{
			m_purpleheroList = new Vector.<uint>();
		}
		
		public function parseXml(xml:XML):void
		{
			m_level = parseInt(xml.@id);
			
			var str:String;
			var ar:Array;
			var wu:uint;
			str = xml.@heros;
			if (null != str)
			{
				ar = str.split("-");
				for (var i:int = 0; i < ar.length; i++)
				{
					wu = parseInt(ar[i]);
					m_purpleheroList.push(wu);
				}
			}
		}
		
		//该组紫色武将是否已开放 level:玩家等级
		public function isEnlist(level:uint):Boolean
		{
			return level >= m_level;
		}
		
	}

}