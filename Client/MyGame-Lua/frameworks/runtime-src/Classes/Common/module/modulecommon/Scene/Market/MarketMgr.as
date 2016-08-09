package modulecommon.scene.market
{
	import com.util.UtilCommon;
	import com.util.UtilXML;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.shoppingCmd.stBuyMarketObjCmd;
	import modulecommon.net.msg.shoppingCmd.stReqObjBuyLimitNumCmd;
	import modulecommon.net.msg.shoppingCmd.stRetAllMarketObjInfoCmd;
	import modulecommon.net.msg.shoppingCmd.stRetHonorMallDataCmd;
	import modulecommon.net.msg.shoppingCmd.stRetMarketGiftBoxContentCmd;
	import modulecommon.net.msg.shoppingCmd.stRetObjBuyLimitNumCmd;
	import com.util.UtilColor;
	import modulecommon.uiinterface.IUICorpsMarket;
	import modulecommon.uiinterface.IUIMarket;
	//import modulecommon.net.msg.shoppingCmd.stNotifyMarketDataUpdateCmd;
	import modulecommon.net.msg.shoppingCmd.stReqShoppingMallDataCmd;
	import modulecommon.net.msg.shoppingCmd.stRetGoldMallDataCmd;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author ...
	 * 商场系统
	 * 在没有商城数据的情况下打开商城,分为3步:
	 * 1. 向服务器请求商城内容的数据
	 * 2. 向服务器请求商城限购商品的数据
	 * 3. 打开界面
	 */
	public class MarketMgr
	{
		public static const cmd_null:int = 0;
		public static const cmd_OpenMarket:int = 1; //打开商场
		public static const cmd_Buy:int = 2; //购买商品
		public static const cmd_OpenCorpsMarket:int = 3; //军团商城
		public static const cmd_QuickBuy:int = 4; //快速购买
		
		public static const RequestDataStep_null:int = 0;
		public static const RequestDataStep_marekt:int = 1;
		//public static const RequestDataStep_ObjBuyLimit:int = 2;
		
		private var m_gkContext:GkContext;
		private var m_bBuyLimitRequested:Boolean; //true表示已经请求过了购买数量消息
		
		private var m_requestDataStep:int;
		
		private var m_MarketData:MarketsData;
		private var m_dicObjBuyLimit:Dictionary;
		private var m_dicObjBuyLimitForCorpsMarket:Dictionary;
		private var m_dicGiftPack:Dictionary;
		
		private var m_cmdAfterRecevieMarketData:int; //收到商场数据后，要执行的命令
		private var m_openPageID:int; //stMarket.TYPE_remai定义
		private var m_dicQuickBuyIDToMarket:Dictionary; //[id, uint:按位表示(stMarket.MONEYTYPE_yuanbao)]
		
		private var m_buyData:stMarketBaseObj;
		private var m_quickMarketInfo:MarketObjIDWidthNum
		public var m_uiMarketForm:IUIMarket;
		public var m_uiCorpsMarketForm:IUICorpsMarket;
		
		public function MarketMgr(gk:GkContext)
		{
			m_gkContext = gk;
			m_dicObjBuyLimit = new Dictionary();
			m_dicObjBuyLimitForCorpsMarket = new Dictionary();
			
			m_bBuyLimitRequested = false;
			m_requestDataStep = RequestDataStep_null;
			m_MarketData = new MarketsData();
		}
		
		public function requestMarketData():void
		{
			m_requestDataStep = RequestDataStep_marekt;
			
			var send:stReqShoppingMallDataCmd = new stReqShoppingMallDataCmd();
			m_gkContext.sendMsg(send);
		}
		
		public function requestReqObjBuyLimitNumCmd():void
		{
			var send:stReqObjBuyLimitNumCmd = new stReqObjBuyLimitNumCmd();
			m_gkContext.sendMsg(send);
		}
		
		//元宝商场数据
		public function processst_stRetAllMarketObjInfoCmd(msg:ByteArray, param:int):void
		{
			var rev:stRetAllMarketObjInfoCmd = new stRetAllMarketObjInfoCmd();
			rev.deserializeYuanbao(m_MarketData, msg);
			m_requestDataStep = RequestDataStep_null;
			processAfterReceiveMsg();
		}
		
		private function loadQuickBuyIDToMarket():void
		{
			if (m_dicQuickBuyIDToMarket != null)
			{
				return;
			}
			
			m_dicQuickBuyIDToMarket = new Dictionary();
			var xml:XML = m_gkContext.m_commonXML.getItem(10);
			var list:XMLList = UtilXML.getChildXmlList(xml, "object");
			var id:int;
			var type:int;
			var marketList:Array;
			var str:String;
			var marketFlag:uint;
			for each (xml in list)
			{
				id = UtilXML.attributeIntValue(xml, "id");
				str = UtilXML.attributeValue(xml, "market");
				marketList = str.split(",");
				marketFlag = 0;
				for each (str in marketList)
				{
					type = parseInt(str);
					marketFlag = UtilCommon.setStateUint(marketFlag, type);
				}
				m_dicQuickBuyIDToMarket[id] = marketFlag;
			}
		}
		
		//判断此道具可以从商城快速购买
		public function canQuickBuy(id:uint):Boolean
		{
			loadQuickBuyIDToMarket();
			return m_dicQuickBuyIDToMarket[id] != undefined;
		}
		
		public function getQuickBuyMarketFlag(id:uint):uint
		{
			return m_dicQuickBuyIDToMarket[id];
		}
		
		public function processsstRetObjBuyLimitNumCmd(msg:ByteArray, param:int):void
		{
			var rev:stRetObjBuyLimitNumCmd = new stRetObjBuyLimitNumCmd();
			rev.deserialize(msg);
			
			m_bBuyLimitRequested = true;
			
			var id:uint;
			var moneyType:int;
			var bForGoldMarket:Boolean;
			var bForCorpsMarket:Boolean;
			if (rev.list)
			{
				var item:stBuyLimitObjInfo;
				for each (item in rev.list)
				{
					moneyType = item.objid % 10;
					id = item.objid / 10;
					if (moneyType == stBuyMarketObjCmd.MARKETTYPE_GOLD)
					{
						m_dicObjBuyLimit[id] = item.buynum;
						bForGoldMarket = true;
					}
					else if (moneyType == stBuyMarketObjCmd.MARKETTYPE_CorpsGongxian)
					{
						m_dicObjBuyLimitForCorpsMarket[id] = item.buynum;
						bForCorpsMarket = true;
					}
				}
			}
			
			if (m_uiMarketForm && m_uiMarketForm.isVisible() && bForGoldMarket)
			{
				m_uiMarketForm.updateNumOfbuy();
			}
			
			if (m_uiCorpsMarketForm && m_uiCorpsMarketForm.isVisible() && bForCorpsMarket)
			{
				m_uiCorpsMarketForm.updateNumOfbuy();
			}
		}
		
		//在收到stRetObjBuyLimitNumCmd和stRetGoldMallDataCmd2个消息后，调用此函数
		private function processAfterReceiveMsg():void
		{
			if (m_cmdAfterRecevieMarketData == cmd_OpenMarket)
			{
				openUIMarketEx();
			}
			else if (m_cmdAfterRecevieMarketData == cmd_OpenCorpsMarket)
			{
				openUICorpsMarketEx();
			}
			else if (m_cmdAfterRecevieMarketData == cmd_QuickBuy)
			{
				buyQuickEx(m_quickMarketInfo);
			}
			else if (m_cmdAfterRecevieMarketData == cmd_Buy)
			{
				if (m_buyData)
				{
					buyEx(m_buyData);
					m_buyData = null;
				}
			}
		}
		
		public function getMarket(type:int):stMarket
		{
			return m_MarketData.m_dic[type];
		}
		
		//荣誉商场内的数据
		/*public function processs_stRetHonorMallDataCmd(msg:ByteArray, param:int):void
		   {
		   var rev:stRetHonorMallDataCmd = new stRetHonorMallDataCmd();
		   rev.deserialize(msg);
		
		   var marekt:stMarket = new stMarket(stMarket.TYPE_Rongyu,stMarket.MONEYTYPE_rongyu);
		   marekt.setList(rev.m_list);
		   m_MarketData.add(stMarket.TYPE_Rongyu, marekt);
		 }*/
		
		public function processstNotifyMarketDataUpdateCmd(msg:ByteArray, param:int):void
		{
			m_MarketData.clearAllData();
			if (m_uiMarketForm)
			{
				(m_uiMarketForm as Form).destroy();
			}
		}
		
		public function processstRetMarketGiftBoxContentCmd(msg:ByteArray, param:int):void
		{
			var rev:stRetMarketGiftBoxContentCmd = new stRetMarketGiftBoxContentCmd();
			rev.deserialize(msg);
			if (m_dicGiftPack == null)
			{
				m_dicGiftPack = new Dictionary();
			}
			m_dicGiftPack[rev.m_objID] = rev.m_list;
			
			var formGift:Form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIGiftWatch);
			formGift.updateData(rev.m_objID);
			formGift.show();
		}
		
		public function getGiftPackContent(id:uint):Array
		{
			if (m_dicGiftPack == null)
			{
				return null;
			}
			return m_dicGiftPack[id];
		}
		
		public function openUIMarket(pageID:int = stMarket.TYPE_remai):void
		{
			m_openPageID = pageID;
			if (isBuyLimitRequested == false)
			{
				requestReqObjBuyLimitNumCmd();
			}
			
			if (m_requestDataStep != RequestDataStep_null)
			{
				return;
			}
			
			if (m_MarketData.hasMarket(stMarket.TYPE_remai) == false)
			{
				m_cmdAfterRecevieMarketData = cmd_OpenMarket;
				requestMarketData();
				
				return;
			}
			
			openUIMarketEx();
		}
		
		private function openUIMarketEx():void
		{
			if (m_uiMarketForm == null)
			{
				if (m_gkContext.m_UIMgr.getForm(UIFormID.UIMarket))
				{
					return;
				}
				
				m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIMarket);
				return;
			}
			
			if (m_uiMarketForm)
			{
				m_uiMarketForm.show();
			}
		}
		
		public function openUICorpsMarket():void
		{
			if (m_requestDataStep != RequestDataStep_null)
			{
				return;
			}
			if (m_MarketData.hasMarket(stMarket.TYPE_remai) == false)
			{
				m_cmdAfterRecevieMarketData = cmd_OpenCorpsMarket;
				requestMarketData();
				return;
			}
			
			openUICorpsMarketEx();
		}
		
		private function openUICorpsMarketEx():void
		{
			if (m_uiCorpsMarketForm == null)
			{
				if (m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsMarket))
				{
					return;
				}
				
				m_gkContext.m_UIMgr.createFormInGame(UIFormID.UICorpsMarket);
				return;
			}
			
			if (m_uiCorpsMarketForm)
			{
				m_uiCorpsMarketForm.show();
			}
		}
		
		//快速购买
		public function buyQuick(id:uint, num:uint = 1):void
		{
			if (m_quickMarketInfo == null)
			{
				m_quickMarketInfo = new MarketObjIDWidthNum();
			}
			m_quickMarketInfo.m_objID = id;
			m_quickMarketInfo.m_num = num;
				
			loadQuickBuyIDToMarket();
			if (m_requestDataStep != RequestDataStep_null)
			{
				return;
			}
			if (m_MarketData.hasMarket(stMarket.TYPE_remai) == false)
			{
				m_cmdAfterRecevieMarketData = cmd_QuickBuy;
				requestMarketData();
				return;
			}
			
			buyQuickEx(m_quickMarketInfo);
		}
		
		private function buyQuickEx(marketInfo:MarketObjIDWidthNum):void
		{
			if (marketInfo.m_objID == 0)
			{
				return;
			}
			var marketList:Array = getMarketListForObject(marketInfo.m_objID);
			if (marketList.length >= 2)
			{
				var form:Form;
				form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIMarketBuy_Quick);
				form.updateData(marketInfo);
				form.show();
			}
			else if (marketList.length == 1)
			{
				var mo:stMarketBaseObj = getMarketByMoneyTypeAndID(marketList[0], marketInfo.m_objID);
				if (mo)
				{
					buyEx(mo, marketInfo.m_num);
				}
				else
				{
					m_gkContext.m_systemPrompt.promptOnTopOfMousePos("商场" + marketList[0] + "不卖道具" + marketInfo.m_objID, UtilColor.RED);
				}
			}
		}
		
		public function getMarketListForObject(id:uint):Array
		{
			var marketFlag:uint = this.getQuickBuyMarketFlag(id);
			var type:int;
			var retList:Array = new Array();
			for (type = 0; type <= stMarket.MONEYTYPE_corpsGongxian; type++)
			{
				if (UtilCommon.isSetUint(marketFlag, type))
				{
					retList.push(type);
				}
			}
			return retList;
		}
		
		//在商城中购买
		public function buy(data:stMarketBaseObj):void
		{
			if (m_requestDataStep != RequestDataStep_null)
			{
				return;
			}
			if (m_MarketData.hasMarket(stMarket.TYPE_remai) == false)
			{
				m_buyData = data;
				m_cmdAfterRecevieMarketData = cmd_Buy;
				requestMarketData();
				return;
			}
			buyEx(data);
		}
		
		public function getMarketByMoneyTypeAndID(type:int, id:uint):stMarketBaseObj
		{
			return m_MarketData.getMarketByMoneyTypeAndID(type, id);
		}
		
		//在军团商城购买
		public function buyInCorpsMarket(data:stMarketBaseObj):void
		{
			buyEx(data);
		}
		
		private function buyEx(data:stMarketBaseObj, num:uint = 1):void
		{
			var obj:MarkerBaseObjWithNum = new MarkerBaseObjWithNum();
			obj.m_data = data;
			obj.m_num = num;
			var form:Form = getBuyForm(data.m_market.m_moneyType);
			form.updateData(obj);
			form.show();
		}
		
		private function getBuyForm(type:int):Form
		{
			var form:Form;
			var id:int;
			if (stMarket.MONEYTYPE_yuanbao == type)
			{
				id = UIFormID.UIMarketBuy_Gold;
			}
			else if (stMarket.MONEYTYPE_rongyu == type)
			{
				id = UIFormID.UIMarketBuy_Rongyu;
			}
			else if (stMarket.MONEYTYPE_corpsGongxian == type)
			{
				id = UIFormID.UIMarketBuy_Corps;
			}
			
			form = m_gkContext.m_UIMgr.createFormInGame(id);
			return form;
		}
		
		public function getPrice(id:uint):stMarketBaseObj
		{
			return m_MarketData.getPrice(id);
		}
		
		public function closeUIMarket():void
		{
			if (m_uiMarketForm)
			{
				m_uiMarketForm.exit();
			}
		}
		
		public function isUIMarketVisible():Boolean
		{
			if (m_uiMarketForm && m_uiMarketForm.isVisible())
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		// 7 点重置
		public function process7ClockUserCmd():void
		{
			m_dicObjBuyLimit = new Dictionary();
			if (m_uiMarketForm)
			{
				m_uiMarketForm.updateNumOfbuy();
			}
			
			m_dicObjBuyLimitForCorpsMarket = new Dictionary();
			
			if (m_uiCorpsMarketForm)
			{
				m_uiCorpsMarketForm.updateNumOfbuy();
			}
		}
		
		//返回当日已经购买指定道具(id)的数量
		public function queryNumObjBuy(id:uint):int
		{
			return m_dicObjBuyLimit[id] as int;
		}
		
		//返回当日已经购买指定道具(id)的数量
		public function queryNumObjBuyInCorpsMarket(id:uint):int
		{
			return m_dicObjBuyLimitForCorpsMarket[id] as int;
		}
		
		public function get requestDataStep():int
		{
			return m_requestDataStep;
		}
		
		public function get isBuyLimitRequested():Boolean
		{
			return m_bBuyLimitRequested;
		}
		
		public function get openPageID():int
		{
			return m_openPageID;
		}
		
		public function get marketData():MarketsData
		{
			return m_MarketData;
		}
	}

}