package game.ui.uibenefithall
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.FormStyleNine;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIBenefitHall;
	import game.ui.uibenefithall.subcom.leftpart.LeftPanel;
	import game.ui.uibenefithall.subcom.RightPanel;
	
	/**
	 * @brief 利益大厅
	 */
	public class UIBenefitHall extends FormStyleNine implements IUIBenefitHall
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		
		protected var m_uiRoot:Component;
		protected var m_pnlLeft:LeftPanel;
		protected var m_pnlRight:RightPanel;

		public function UIBenefitHall()
		{
			super();
			this.id = UIFormID.UIBenefitHall;
			setAniForm(75);
			exitMode = EXITMODE_HIDE;
		}
		
		override public function onReady():void
		{
			super.onReady();
			var panel:Panel;			
			beginPanelDrawBg(863, 565);
			
			panel = new Panel(null, 17, 36);
			panel.setPanelImageSkin("module/benefithall/leftbg.png");
			m_bgPart.addDrawCom(panel);
			
			endPanelDraw();
			
			setTitleDraw(282, "module/benefithall/title.png", null, 94);
			
			m_dataBenefitHall = new DataBenefitHall();
			m_dataBenefitHall.m_gkContext = m_gkcontext;
			m_dataBenefitHall.m_mainForm = this;
			m_dataBenefitHall.m_curSelectBtnID = BenefitHallMgr.BUTTON_HuoyueFuli;
			
			m_uiRoot = new Component(this);			
			m_pnlRight = new RightPanel(m_dataBenefitHall, m_uiRoot, 178,37);
			m_dataBenefitHall.m_rightPanel = m_pnlRight;
			
			m_pnlLeft = new LeftPanel(m_dataBenefitHall, m_uiRoot, 14, 55);			
			m_pnlLeft.initData();
			m_gkcontext.m_UIs.benefitHall = this;
		}
		override public function show():void 
		{
			super.show();
			if (m_dataBenefitHall.m_curSelectBtnID != BenefitHallMgr.BUTTON_Num)
			{
				m_pnlLeft.setSelected(m_dataBenefitHall.m_curSelectBtnID);
			}
		}
		
		public function openPage(id:int = BenefitHallMgr.BUTTON_Num):void
		{
			m_dataBenefitHall.m_curSelectBtnID = id;
			this.show();
		}
		
		public function addPage(id:int):void
		{
			m_pnlLeft.addItem(id);
		}
		
		public function removePage(id:int):void
		{
			m_pnlLeft.deleItem(id);
		}
		
		public function updateDataOnePage(id:int = BenefitHallMgr.BUTTON_Num, param:Object = null):void
		{
			m_pnlRight.updateDataOnePage(id, param);
		}
		
		public function showRewardFlag(id:int, bShow:Boolean):void
		{
			m_pnlLeft.showRewardFlag(id, bShow);
		}
		override public function onDestroy():void 
		{
			m_gkcontext.m_UIs.benefitHall = null;
			super.onDestroy();
		}
		
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.screenBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.screenBtn.getBtnPosInScreen(ScreenBtnMgr.Btn_BenefitHall);
				if (pt)
				{
					pt.x -= 13;
					pt.y -= 17;
					return pt;
				}
			}
			return null;
		}
		public function getPageId():uint
		{
			if (m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_REG))
			{
				for (var i:uint = 0; i < BenefitHallMgr.BUTTON_Num; i++ )
				{
					if (m_gkcontext.m_benefitHallMgr.hasRewardByID(i))
					{
						return i;
					}
				}
				return BenefitHallMgr.BUTTON_HuoyueFuli;
			}
			else
			{
				return BenefitHallMgr.BUTTON_MeiriQiandao;
			}
		}
		
		public function psupdateRewardBackCmd(msg:ByteArray):void
		{
			m_pnlRight.psupdateRewardBackCmd(msg);
		}
	}
}