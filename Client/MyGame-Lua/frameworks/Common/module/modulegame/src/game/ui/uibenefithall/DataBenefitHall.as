package game.ui.uibenefithall
{
	import flash.sampler.NewObjectSample;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.ui.uibenefithall.msg.stRetRankRewardRankInfoCmd;
	import game.ui.uibenefithall.subcom.RightPanel;
	import game.ui.uibenefithall.subcom.sevenlogin.QiriBottomPart;
	import game.ui.uibenefithall.xml.XmlData;
	import modulecommon.GkContext;
	import modulecommon.uiinterface.IUIBenefitHall;
	
	/**
	 * @brief 全局数据
	 */
	public class DataBenefitHall
	{
		public var m_gkContext:GkContext;
		public var m_mainForm:IUIBenefitHall;
		public var m_rightPanel:RightPanel;
		public var m_qiriBottomPart:QiriBottomPart;
		public var m_dicRank:Dictionary;
		public var m_curSelectBtnID:int;
		
		public var m_xmlData:XmlData;

		public function DataBenefitHall() 
		{
			m_dicRank = new Dictionary();
		}
		
		public function process_stRetRankRewardRankInfoCmd(rev:stRetRankRewardRankInfoCmd):void
		{			
			m_dicRank[rev.day] = rev;
		}
		
		public function getRankByDay(day:int):stRetRankRewardRankInfoCmd
		{
			return m_dicRank[day];
		}
	}
}