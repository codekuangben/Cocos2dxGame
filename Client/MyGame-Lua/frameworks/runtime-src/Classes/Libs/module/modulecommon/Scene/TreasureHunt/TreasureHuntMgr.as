package modulecommon.scene.treasurehunt 
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.treesurehuntCmd.stNotifyTreasureHuntingScoreCmd;
	import modulecommon.net.msg.treesurehuntCmd.stRefreshHuntingBigPrizeCmd;
	import modulecommon.net.msg.treesurehuntCmd.stRefreshHuntingPersonalPrizeCmd;
	import modulecommon.net.msg.treesurehuntCmd.stTreasureHuntingUIInfoCmd;
	import modulecommon.scene.prop.xml.DataXml;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIHuntExchange;
	import modulecommon.uiinterface.IUITreasureHunt;
	/**
	 * ...
	 * @author ...
	 */
	public class TreasureHuntMgr 
	{
		private var m_bNoQuery:Boolean;
		private var m_gkContext:GkContext;
		private var m_treasureInfoList:Array;//宝物说明treasureInfoList
		private var m_huntExchangeList:Array//宝物兑换
		private var m_score:uint//元宝寻宝积分
		private var m_treasurerule:String;//xml格式寻宝规则
		private var m_bigprize:Array;//大奖
		private var m_bigprizev:Array;//置顶大奖
		private var m_userprize:Array;//自己的奖
		public var m_bLoadConfig:Boolean;
		public var m_uitreasurehunt:IUITreasureHunt;
		public static const LEFTLIST_MAXLINE:int = 10;
		public static const RIGHTLIST_MAXLINE:int = 50;
		public function TreasureHuntMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_bigprize = new Array();
			m_bigprizev = new Array();
			m_userprize = new Array();
			m_bNoQuery = false;
			m_bLoadConfig = false;
		}
		public function loadConfig():void
		{
			if (m_bLoadConfig)
			{
				return;
			}
			m_treasureInfoList = new Array();
			m_huntExchangeList = new Array();
			var xml:XML = m_gkContext.m_dataXml.getXML(DataXml.XML_Treasurehunting);
			var tabXmlList:XML;
			for each (tabXmlList in xml.elements("pics"))
			{
				var item:treasureInfoList = new treasureInfoList();
				item.parse(tabXmlList);
				m_treasureInfoList.push(item);
			}
			for each (tabXmlList in xml.elements("objlist").elements("*"))
			{
				var itema:huntExchangeItem = new huntExchangeItem();
				itema.parse(tabXmlList);
				m_huntExchangeList.push(itema);
			}
			m_treasurerule = xml.child("rule").toString();
			m_bLoadConfig = true;
		}
		public function processStTreasureHuntingUIInfoCmd(byte:ByteArray):void
		{
			var rev:stTreasureHuntingUIInfoCmd = new stTreasureHuntingUIInfoCmd();
			rev.deserialize(byte);
			m_bigprize = rev.m_bigprize;
			m_bigprizev = rev.m_superprize;
			m_userprize = rev.m_userprize;
		}
		public function processstNotifyTreasureHuntingScoreCmd(byte:ByteArray):void
		{
			var rev:stNotifyTreasureHuntingScoreCmd = new stNotifyTreasureHuntingScoreCmd();
			rev.deserialize(byte);
			m_score = rev.m_score;
			if (m_uitreasurehunt)
			{
				m_uitreasurehunt.refrashScore();
			}
			var form:IUIHuntExchange = m_gkContext.m_UIMgr.getForm(UIFormID.UIHuntExchange) as IUIHuntExchange;
			if (form)
			{
				form.refreshScore();
			}
		}
		public function processStRefreshHuntingBigPrizeCmd(byte:ByteArray):void
		{
			var rev:stRefreshHuntingBigPrizeCmd = new stRefreshHuntingBigPrizeCmd();
			rev.deserialize(byte);
			for (var i:uint = 0; i < rev.m_superprizestr.length; i++ )
			{
				if (m_bigprizev.length == 3)
				{
					m_bigprizev.splice(0,1);
				}
				m_bigprizev.push(rev.m_superprizestr[i]);
			}
			var num:uint = LEFTLIST_MAXLINE-m_bigprizev.length;
			while (m_bigprize.length > num)
			{
				m_bigprize.splice(0,1);
			}
			for (i = 0; i < rev.m_bigprizestr.length; i++ )
			{
				if (m_bigprize.length == num)
				{
					m_bigprize.splice(0,1);
				}
				m_bigprize.push(rev.m_bigprizestr[i]);
			}
			if (m_uitreasurehunt)
			{
				m_uitreasurehunt.updataLeftPart(rev.m_bigprizestr,rev.m_superprizestr);
			}
			
		}
		public function processStRefreshHuntingPersonalPrizeCmd(byte:ByteArray):void
		{
			var rev:stRefreshHuntingPersonalPrizeCmd = new stRefreshHuntingPersonalPrizeCmd();
			rev.deserialize(byte);
			for (var i:uint = 0; i < rev.m_prizestr.length; i++ )
			{
				if (m_userprize.length == RIGHTLIST_MAXLINE)
				{
					m_userprize.splice(0,1);
				}
				m_userprize.push(rev.m_prizestr[i]);
			}
			if (m_uitreasurehunt)
			{
				m_uitreasurehunt.updataRightPart(rev.m_prizestr);
			}
			
		}
		public function get userPrize():Array
		{
			return m_userprize;
		}
		public function get bigPrize():Array
		{
			return m_bigprize;
		}
		public function get bigPrizev():Array
		{
			return m_bigprizev;
		}
		public function get treasurerule():String
		{
			return m_treasurerule;
		}
		public function get treasureInfoL():Array
		{
			for each(var item:treasureInfoList in m_treasureInfoList)
			{
				if (item.m_minLevel <= m_gkContext.playerMain.level && m_gkContext.playerMain.level <= item.m_maxLevel)
				{
					return item.m_treasureInfoList;
				}
			}
			return null;
		}
		public function get huntExchangeList():Array
		{
			return m_huntExchangeList;
		}
		public function get score():uint
		{
			return m_score;
		}
		public function set bNoQuery(bool:Boolean):void
		{
			m_bNoQuery = bool;
		}
		public function get bNoQuery():Boolean
		{
			return m_bNoQuery;
		}
	}

}