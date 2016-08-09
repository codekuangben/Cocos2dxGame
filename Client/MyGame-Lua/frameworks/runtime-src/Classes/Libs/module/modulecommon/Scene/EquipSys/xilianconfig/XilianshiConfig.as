package modulecommon.scene.equipsys.xilianconfig 
{
	/**
	 * ...
	 * @author 
	 */
	import modulecommon.GkContext;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.XMLResource;
	import modulecommon.scene.prop.xml.DataXml;
	
	public class XilianshiConfig 
	{
		public var m_gkContext:GkContext;
		private var m_levelList:Vector.<XilianLevel>;
		
		
		public function XilianshiConfig(gk:GkContext) 
		{
			m_gkContext = gk;			
		}		
		public function isLoaded():Boolean
		{
			return m_levelList != null;
		}
		public function parseXml():void
		{
			if (isLoaded())
			{
				return;
			}
			m_levelList = new Vector.<XilianLevel>;
			
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_EquipXilian);
			
			var levelList:XMLList;
			var levelXML:XML;		
			var level:XilianLevel;
			
			levelList = xml.child("level");
			for each(levelXML in levelList)
			{
				level = new XilianLevel();
				level.parseXml(levelXML);
				m_levelList.push(level);
			}
		}
		
		private	function getColor(level:int, color:int):XilianColor
		{
			parseXml();
			var i:int;
			var xilianLevel:XilianLevel;
			for (i = 0; i < m_levelList.length; i++)
			{
				xilianLevel = m_levelList[i];
				if (xilianLevel.m_min <= level && xilianLevel.m_max >= level )
				{
					return xilianLevel.getColor(color);
				}
			}
			return null;
		}
		
		public function getXilianshiForXilian(level:int, color:int):Xilianshi
		{
			parseXml();
			var colorXilian:XilianColor = getColor(level, color);
			if (colorXilian)
			{
				return colorXilian.m_xilian;
			}
			return new Xilianshi();
		}
		
		public function getXilianshiForFenjie(level:int, color:int):Xilianshi
		{
			parseXml();
			var colorXilian:XilianColor = getColor(level, color);
			if (colorXilian)
			{
				return colorXilian.m_fenjie;
			}
			return new Xilianshi();
		}
		
		//分解装备所获银币数:=5*装备等级*(1+当前装备强化数)*当强装备强化数
		public function  getCostForEquip(enhancelevel:int, level:int):int
		{
			return (5 * level * (1 + enhancelevel) * enhancelevel);
		}
		
	}

}