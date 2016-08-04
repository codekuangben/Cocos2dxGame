package game.ui.uibenefithall.subcom
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.subcom.activewelfare.ActiveWelfarePage;
	import game.ui.uibenefithall.subcom.jihuoma.JihuomaPage;
	import game.ui.uibenefithall.subcom.jlzhaohui.JLZhaoHuiPage;
	import game.ui.uibenefithall.subcom.peoplerank.PeopleRankPage;
	import game.ui.uibenefithall.subcom.regdaily.RegDailyPage;
	import game.ui.uibenefithall.subcom.sevenlogin.PageSevenLogin;
	import game.ui.uibenefithall.subcom.welfarepackage.PageWelfare;
	import game.ui.uibenefithall.subcom.xianshifangsong.PageFangSong;
	import game.ui.uibenefithall.TypeConst;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	
	/**
	 * @brief 右边面板
	 */
	public class RightPanel extends Component
	{
		protected var m_dataBenefitHall:DataBenefitHall;		
		protected var m_listTabWidget:Dictionary

		public function RightPanel(data:DataBenefitHall, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			
			m_dataBenefitHall = data;
			m_listTabWidget = new Dictionary();		
		}
		
		public	function showPage(iPage:int):void
		{
			var pageBase:PageBase=m_listTabWidget[iPage];
			if (pageBase == null)
			{
				pageBase = createPage(iPage);
				m_listTabWidget[iPage] = pageBase;
			}
			if (pageBase)
			{
				pageBase.show();
			}
		}
		
		private function createPage(iPage:int):PageBase
		{
			var pageBase:PageBase;
			switch(iPage)
			{
				case BenefitHallMgr.BUTTON_QiriDenglu:
					{
						pageBase = new PageSevenLogin(m_dataBenefitHall, this);
						break;
					}
				case BenefitHallMgr.BUTTON_Jihuoma:
					{
						pageBase = new JihuomaPage(m_dataBenefitHall, this);
						break;
					}
				case BenefitHallMgr.BUTTON_MeiriQiandao:
					{
						pageBase = new RegDailyPage(m_dataBenefitHall, this);
						break;
					}
				case BenefitHallMgr.BUTTON_HuoyueFuli:
					{
						pageBase = new ActiveWelfarePage(m_dataBenefitHall, this);
						break;
					}
				case BenefitHallMgr.BUTTON_XianshiFangsong1:
					{
						pageBase = new PageFangSong(m_dataBenefitHall, this, 0);
						break;
					}
				case BenefitHallMgr.BUTTON_XianshiFangsong2:
					{
						pageBase = new PageFangSong(m_dataBenefitHall, this, 1);
						break;
					}
				case BenefitHallMgr.BUTTON_XianshiFangsong3:
					{
						pageBase = new PageFangSong(m_dataBenefitHall, this, 2);
						break;
					}
				case BenefitHallMgr.BUTTON_XianshiFangsong4:
					{
						pageBase = new PageFangSong(m_dataBenefitHall, this, 3);
						break;
					}
				case BenefitHallMgr.BUTTON_FuliLibao:
					{
						pageBase = new PageWelfare(m_dataBenefitHall, this);
						break;
					}
				case BenefitHallMgr.BUTTON_Quanminchongbang:
					{
						pageBase = new PeopleRankPage(m_dataBenefitHall, this);
						break;
					}
				case BenefitHallMgr.BUTTON_JLZhaoHui:
				{
					pageBase = new JLZhaoHuiPage(m_dataBenefitHall, this, 4);
					break;
				}
			}
			return pageBase;
		}
		
		public function removePage(iPage:int):void
		{
			var pageBase:PageBase = m_listTabWidget[iPage];
			if (pageBase)
			{
				pageBase.hide();
				pageBase.dispose();
				delete m_listTabWidget[iPage];
			}
		}
		
		public function updateDataOnePage(iPage:int, param:Object = null):void
		{
			var pageBase:PageBase = m_listTabWidget[iPage];
			
			if (pageBase /*&& pageBase.isVisible()*/)
			{
				pageBase.updateData(param);
			}
		}
		
		override public function dispose():void 
		{
			var pageBase:PageBase;
			for each(pageBase in m_listTabWidget)
			{
				if (pageBase&&pageBase.parent == null)
				{
					pageBase.dispose();
				}
			}
			super.dispose();
		}
		
		public function psupdateRewardBackCmd(msg:ByteArray):void
		{
			if (m_listTabWidget[BenefitHallMgr.BUTTON_JLZhaoHui])
			{
				(m_listTabWidget[BenefitHallMgr.BUTTON_JLZhaoHui] as JLZhaoHuiPage).psupdateRewardBackCmd(msg);
			}
		}
	}
}