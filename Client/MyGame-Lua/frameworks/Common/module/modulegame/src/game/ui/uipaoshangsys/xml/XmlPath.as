package game.ui.uipaoshangsys.xml
{
	import flash.geom.Point;
	import game.ui.uimysteryshop.CommodityBase;
	import game.ui.uimysteryshop.CommodityHero;
	import game.ui.uimysteryshop.CommodityMoney;
	import game.ui.uimysteryshop.CommodityObject;
	import game.ui.uimysteryshop.CommodityWuxue;
	/**
	 * @brief 对应 xml 配置文件中的 levelrange 标签
	 */
	public class XmlPath
	{
		public var m_pathLst:Vector.<XmlSegm>;
		public var m_totalLen:Number;
		
		public function XmlPath()
		{
			m_pathLst = new Vector.<XmlSegm>();
			m_totalLen = 0;
		}
		
		public function parse(xml:XML):void
		{
			var lst:Vector.<Point> = new Vector.<Point>();
			var ptList:XMLList = xml.child("pt");
			var itemXML:XML;
			var pt:Point;
			for each(itemXML in ptList)
			{
				pt = new Point(parseInt(itemXML.@x), parseInt(itemXML.@y));
				lst.push(pt);
			}
			
			var idx:int = 0;
			var seg:XmlSegm;
			while (idx < lst.length - 1)
			{
				seg = new XmlSegm();
				seg.m_startPt = lst[idx];
				seg.m_endPt = lst[idx + 1];
				m_pathLst.push(seg);
				m_totalLen += seg.calcLen();
				++idx;
			}
		}
	}
}