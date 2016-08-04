package game.logic
{
	import modulecommon.logicinterface.IRankSys;
	import modulecommon.GkContext;
	import modulecommon.net.msg.rankcmd.CorpsLevelRankItem;
	import modulecommon.net.msg.rankcmd.stPersonalZhanLiRankListCmd;
	import modulecommon.net.msg.rankcmd.stPersonlLevelRankListCmd;
	import modulecommon.net.msg.rankcmd.stRetCorpsCombatPowerRankListUserCmd;
	import modulecommon.net.msg.rankcmd.stRetCorpsLevelRankListUserCmd;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIRanklist;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RankSys implements IRankSys
	{
		protected var m_gkContext:GkContext;
		// 军团等级区域
		protected var m_corpsLevelRank:stRetCorpsLevelRankListUserCmd;			// 军团登记排行榜数据
		// 军团战力
		protected var m_corpsCombatRank:stRetCorpsCombatPowerRankListUserCmd;
		// 个人等级
		protected var m_personLevelRank:stPersonlLevelRankListCmd;
		// 个人战力
		protected var m_personCombatRank:stPersonalZhanLiRankListCmd;
		
		// 打开的排行榜页签
		protected var m_page:int;
		
		// 公用数据放在这里
		protected var m_commonData:CommonData;
		
		public function RankSys(value:GkContext)
		{
			m_gkContext = value;
			
			// 测试
			//test();
			m_commonData = new CommonData();
		}
		
		public function get corpsLevelRank():stRetCorpsLevelRankListUserCmd
		{
			return m_corpsLevelRank;
		}
		
		public function set corpsLevelRank(value:stRetCorpsLevelRankListUserCmd):void
		{
			m_corpsLevelRank = value;
		}
		
		public function get corpsCombatRank():stRetCorpsCombatPowerRankListUserCmd
		{
			return m_corpsCombatRank;
		}
		
		public function set corpsCombatRank(value:stRetCorpsCombatPowerRankListUserCmd):void
		{
			m_corpsCombatRank = value;
		}
		
		public function get personLevelRank():stPersonlLevelRankListCmd
		{
			return m_personLevelRank;
		}
		
		public function set personLevelRank(value:stPersonlLevelRankListCmd):void
		{
			m_personLevelRank = value;
		}
		
		public function get personCombatRank():stPersonalZhanLiRankListCmd
		{
			return m_personCombatRank;
		}
		
		public function set personCombatRank(value:stPersonalZhanLiRankListCmd):void
		{
			m_personCombatRank = value;
		}
		
		public function get corpsLevelRankLst():Array
		{
			return m_corpsLevelRank.data;
		}
		
		public function get corpsCombatRankLst():Array
		{
			return m_corpsCombatRank.data;
		}
		
		public function get personLevelRankList():Array
		{
			return m_personLevelRank.lrlist;
		}
		
		public function get personCombatRankList():Array
		{
			return m_personCombatRank.zllist;
		}
		
		// 测试功能
		public function test():void
		{
			m_corpsLevelRank = new stRetCorpsLevelRankListUserCmd();
			m_corpsLevelRank.data = [];
			
			var total:uint = 50;
			var idx:int = 0;
			var item:CorpsLevelRankItem;
			
			m_corpsLevelRank.size = total;
			
			while (idx < total)
			{
				item = new CorpsLevelRankItem();
				item.id = idx;
				item.level = idx;
				item.mNo = idx + 1;
				item.name = "军团名字" + idx;
				item.tuanzhang = "团长名字" + idx;
				m_corpsLevelRank.data[m_corpsLevelRank.data.length] = item;
				++idx;
			}
		}
		
		// 打开排行榜并且切换到某一页
		// page 值参考 client_maintrunk\client\ui\uiRanklist\src\uiranklist\TypeConst.as
		public function openRankAndToggleToPage(page:int):void
		{
			m_page = page;
			var uirank:IUIRanklist = m_gkContext.m_UIMgr.getForm(UIFormID.UIRanklist) as IUIRanklist;
			if(!uirank)
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIRanklist);
			}
			else
			{
				uirank.openRankAndToggleToPage(m_page);
				uirank.show();
				m_page = 0;
			}
		}
		
		public function get page():int
		{
			return m_page;
		}
		
		public function set page(value:int):void
		{
			m_page = value;
		}
		
		// 公共数据访问接口
		public function get msbNoQuery():Boolean
		{
			return m_commonData.m_bNoQuery;
		}
		
		public function set msbNoQuery(value:Boolean):void
		{
			m_commonData.m_bNoQuery = value;
		}
		
		public function get objlist():Array
		{
			return m_commonData.m_objlist;
		}
		
		public function set objlist(value:Array):void
		{
			m_commonData.m_objlist = value;
		}
		
		public function get bOpenPaoShang():Boolean
		{
			return m_commonData.m_bOpenPaoShang;
		}
		
		public function set bOpenPaoShang(value:Boolean):void
		{
			m_commonData.m_bOpenPaoShang = value;
		}
	}
}