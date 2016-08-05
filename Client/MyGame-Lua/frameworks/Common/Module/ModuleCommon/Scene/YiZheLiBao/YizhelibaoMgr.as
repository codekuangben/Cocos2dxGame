package modulecommon.scene.yizhelibao 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.giftCmd.stAlreadyPurchaseYZLBObjListCmd;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIYizhelibao;
	import org.ffilmation.engine.datatypes.IntPoint;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	/**
	 * ...
	 * @author 
	 */
	public class YizhelibaoMgr 
	{
		private var m_gkContext:GkContext;
		public var m_dicTablabel:Dictionary;	//[level, YizheTabLabel]的集合	
		public var m_pageTolevel:Array;		
		private var m_commodityBuyedList:Vector.<uint>;// 已经购买的商品的数组，每个元素的类型是uint(其含义：千位百位: 标签编号 十位个位:物品唯一编号) 
	
		public function YizhelibaoMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_commodityBuyedList = new Vector.<uint>();
		}
		
		public function loadConfig():void
		{
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Yizhelibao);
			m_dicTablabel = new Dictionary();
			m_pageTolevel = new Array();
			
			var tabXml:XML;
			var tabObject:YizheTabLabel;
			var tabList:XMLList = xml.child("tablabel");
			for each(tabXml in tabList)
			{
				tabObject = new YizheTabLabel();
				tabObject.parse(tabXml);
				m_dicTablabel[tabObject.m_iOpenlevel] = tabObject;
				m_pageTolevel.push(tabObject.m_iOpenlevel);
			}
		}
		
		public function whetherShowEffect():Boolean
		{
			loadConfig();
			var totleCommoditrNum:int = 0;
			var labelForNum:YizheTabLabel;			
			for each(labelForNum in m_dicTablabel)
			{
				if (labelForNum.m_iOpenlevel <= m_gkContext.playerMain.level )
				totleCommoditrNum += labelForNum.m_list.length;
			}
			if (totleCommoditrNum == m_commodityBuyedList.length)
			{
				return false;
			}
			return true
		}
		
		public function process_stAlreadyPurchaseYZLBObjListCmd(byte:ByteArray):void
		{
			var rev:stAlreadyPurchaseYZLBObjListCmd = new stAlreadyPurchaseYZLBObjListCmd();
			rev.deserialize(byte);
			
			var data:uint;
			for each(data in rev.m_list)
			{
				m_commodityBuyedList.push(data);
			}			
			
			var ui:IUIYizhelibao = m_gkContext.m_UIMgr.getForm(UIFormID.UIYizhelibao) as IUIYizhelibao;
			if (ui&&ui.isVisible() && rev.m_list.length>0)
			{
				var serverData:IntPoint = s_buyInfoConvertFromServerToClient(rev.m_list[0]);
				var table:YizheTabLabel = getTablabelByID(serverData.x);
				ui.onBuyCommodity(table.m_iOpenlevel, serverData.y);
			}
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_TenpercentGiftbox, whetherShowEffect());
			}
			
		}
		public function levelUpdate():void
		{
			var ui:IUIYizhelibao = m_gkContext.m_UIMgr.getForm(UIFormID.UIYizhelibao) as IUIYizhelibao;
			if (ui&&ui.isVisible())
			{
				ui.showForLevelup();
			}
			if (m_gkContext.m_UIs.screenBtn)
			{
				m_gkContext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_TenpercentGiftbox, whetherShowEffect());
			}
		}
		public function getTabLabel(level:int):YizheTabLabel
		{
			if (m_dicTablabel == null)
			{
				loadConfig();
			}
			return m_dicTablabel[level];
		
		}
		
		public function getPagetolevel():Array
		{
			if (m_pageTolevel == null)
			{
				loadConfig();
			}
			return m_pageTolevel;
		
		}
		
		/*
		 * desc: 返回指定商品是否购买过了
		 * param: tabID:标签ID
		 * 		  commodityID:商品ID
		 * return: true-表示已经购买过了
		 */ 
		public function isCommodityBuyed(tabID:int, commodityID:int):Boolean
		{
			var data:uint = s_buyInfoConvertFromClientToServer(tabID,commodityID);
			var i:int = m_commodityBuyedList.indexOf(data);
			return -1 == i?false:true;
		}
		
		public function getTablabelByID(tableID:int):YizheTabLabel
		{
			var ret:YizheTabLabel;
			for each(ret in m_dicTablabel)
			{
				if (ret.m_id == tableID)
				{
					return ret;
				}
			}
			return ret;
		}
		
		public static function s_buyInfoConvertFromClientToServer(tableID:int, commodityID:int):int
		{
			return tableID * 100 + commodityID;
		}
		
		/*
		 * IntPoint.x 代表tableID
		 */ 
		public static function s_buyInfoConvertFromServerToClient(dataServer:int):IntPoint
		{
			var ret:IntPoint = new IntPoint();
			ret.x = dataServer / 100;
			ret.y = dataServer % 100;
			return ret;
		}
	}

}