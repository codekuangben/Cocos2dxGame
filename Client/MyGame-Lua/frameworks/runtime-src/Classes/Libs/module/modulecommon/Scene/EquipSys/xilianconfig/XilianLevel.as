package modulecommon.scene.equipsys.xilianconfig 
{
	/**
	 * ...
	 * @author 
	 */
	public class XilianLevel 
	{
		public var m_min:int;
		public var m_max:int;
		public var m_fenjiecost:int;	//分解装备所需要的银币
		public var m_colorList:Vector.<XilianColor>;
		public function XilianLevel() 
		{
			m_colorList = new Vector.<XilianColor>();
		}
		public function parseXml(xml:XML):void
		{
			m_min = parseInt(xml.@min);
			m_max = parseInt(xml.@max);
			m_fenjiecost = parseInt(xml.@fenjiecost);
			var listXML:XMLList = xml.child("color");
			var i:int;
			var colorItem:XilianColor;
			for (i = 0; i < listXML.length(); i++)
			{
				colorItem = new XilianColor();
				colorItem.parseXml(listXML[i]);
				m_colorList.push(colorItem);
			}
		}
		
		public function getColor(color:int):XilianColor
		{
			var i:int;
			for (i = 0; i < m_colorList.length; i++)
			{
				if (color == m_colorList[i].m_color)
				{
					return m_colorList[i];
				}
			}
			return null;
		}		
	}

}