package game.ui.uipaoshangsys.xml
{
	import flash.utils.Dictionary;
	import game.ui.uimysteryshop.CommodityBase;
	/**
	 * @brief xml 数据
	 */
	public class XmlData 
	{
		public var m_xmlPath:XmlPath;
		public var m_topGoodsDic:Dictionary;		// 存放顶级货物 id ，key 是 objid ，value 是 1 ，说明有
		public var m_extraAddDic:Dictionary;		// 额外加成数据 key 是2 3 或者 4 ，value 是加成值
		
		public var m_randGoodLst:Array;				// 随机货物列表，换货的时候需要随机播放的物品
		public var m_type2ObjIdDic:Dictionary;		// 服务器道具类型到客户端道具 id 的关系
		
		public function XmlData()
		{
			m_xmlPath = new XmlPath();
			m_topGoodsDic = new Dictionary();
			m_extraAddDic = new Dictionary();
			m_type2ObjIdDic = new Dictionary();
		}
		
		public function isTopGood(id:uint):Boolean
		{
			return (m_topGoodsDic[id] != null);
		}
		
		public function extraAddValue(key:uint):uint
		{
			return m_extraAddDic[key];
		}
		
		public function parseTopGoodXml(xml:XML):void
		{
			var str:String = xml.@topgoodlst;
			var arr:Array = str.split(",");
			var idx:uint = 0;
			while (idx < arr.length)
			{
				m_topGoodsDic[arr[idx]] = 1;
				++idx;
			}
		}
		
		public function parseExtraAdd(xml:XML):void
		{
			m_extraAddDic[2] = parseInt(xml.@two);
			m_extraAddDic[3] = parseInt(xml.@three);
			m_extraAddDic[4] = parseInt(xml.@four);
			m_extraAddDic[5] = parseInt(xml.@five);
		}
		
		public function parseRandGood(xml:XML):void
		{
			var str:String = xml.@randgood;
			m_randGoodLst = str.split(",");			
		}
		
		public function parseType2ObjId(xml:XML):void
		{
			var str:String = xml.@type2id;
			var arr:Array = str.split(",");
			var idx:uint = 0;
			var arrtype2objid:Array;
			while (idx < arr.length)
			{
				arrtype2objid = arr[idx].split("-");
				m_type2ObjIdDic[arrtype2objid[0]] = arrtype2objid[1];
				++idx;
			}
		}
	}
}