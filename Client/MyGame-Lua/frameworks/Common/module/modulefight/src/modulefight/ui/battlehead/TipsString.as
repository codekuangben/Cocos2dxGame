package modulefight.ui.battlehead 
{
	import com.util.UtilXML;
	/**
	 * ...
	 * @author 
	 */
	public class TipsString 
	{
		public var m_minlevel:uint;//最低等级
		public var m_maxlevel:uint;//最高等级
		public var m_strList:Array;//等级段内的可选内容数组
		public function TipsString() 
		{
			m_strList = new Array();
		}
		public function parse(xml:XML):void
		{
			m_minlevel = parseInt(xml.@min);
			m_maxlevel = parseInt(xml.@max);
			for each(var item:* in xml.child("tip"))
			{
				var str:String = item.@desc;
				m_strList.push(str);
			}
		}
		public function accordLevel(level:uint):Boolean
		{
			if (m_minlevel <= level && level <= m_maxlevel)
			{
				return true;
			}
			return false;
		}
		public function getString():String
		{
			return m_strList[Math.floor(Math.random() * m_strList.length)];
		}
	}

}