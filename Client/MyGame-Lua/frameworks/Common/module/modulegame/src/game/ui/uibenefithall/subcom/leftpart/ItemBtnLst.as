package game.ui.uibenefithall.subcom.leftpart
{	
	import com.bit101.components.ButtonTab;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Panel;
	import flash.events.MouseEvent;
	import game.ui.uibenefithall.DataBenefitHall;
	import modulecommon.scene.benefithall.BenefitHallMgr;
	
	/**
	 * @brief 按钮列表 item
	 * */
	public class ItemBtnLst extends CtrolVHeightComponent
	{
		protected var m_dataBenefitHall:DataBenefitHall;
		protected var m_id:int;
		protected var m_btn:ButtonTab;
		protected var m_rewardIcon:Panel;

		public function ItemBtnLst(param:Object)
		{
			super();
			m_dataBenefitHall = param["data"] as DataBenefitHall;
			
			this.setSize(203, 40);	
		}

		// 设置数据
		override public function setData(data:Object):void
		{
			super.setData(data);
			m_id = data as int;
			if (m_btn)
			{
				m_btn.dispose();
				if (m_btn.parent)
				{
					m_btn.parent.removeChild(m_btn);
				}
			}
			m_btn = new ButtonTab(this, 0, 0);
			m_btn.setSize(164, 48);
			m_btn.setSkinButton2ImageAndImageCaptionForTab("commoncontrol/button/button2ImageTab2.swf", "module/benefithall/title/" + getCaptionResName(m_id) + ".png");	
			
			if (m_dataBenefitHall.m_gkContext.m_benefitHallMgr.hasRewardByID(m_id))
			{
				showRewardIcon();
			}
		}
		
		public function getCaptionResName(id:int):String
		{
			var ret:String;
			switch(id)
			{
				case BenefitHallMgr.BUTTON_HuoyueFuli:ret = "huoyuefuli"; break;
				case BenefitHallMgr.BUTTON_MeiriQiandao:ret = "meiriqiandao"; break;
				case BenefitHallMgr.BUTTON_QiriDenglu:ret = "qiridenglu"; break;
				case BenefitHallMgr.BUTTON_FuliLibao:ret = "fulilibao"; break;		
				case BenefitHallMgr.BUTTON_XianshiFangsong1:ret = "zhaojianghuodong"; break;
				case BenefitHallMgr.BUTTON_XianshiFangsong2:ret = "baoshifangsong"; break;
				case BenefitHallMgr.BUTTON_XianshiFangsong3:ret = "zuojijuexing"; break;
				case BenefitHallMgr.BUTTON_XianshiFangsong4:ret = "xianjiangchuanshuo"; break;
				case BenefitHallMgr.BUTTON_Jihuoma:ret = "jihuoma"; break;
				case BenefitHallMgr.BUTTON_Quanminchongbang:ret = "quanminchongbang"; break;
				case BenefitHallMgr.BUTTON_JLZhaoHui:ret = "jianglizhaohui"; break;
			}
			return ret;
		}
		override public function onSelected():void 
		{
			super.onSelected();
			m_btn.selected = true;
		}
		override public function onNotSelected():void 
		{
			super.onNotSelected();
			m_btn.selected = false;
		}
		public function get id():int
		{
			return m_id;
		}
		//bShow=true:显示奖icon，bShow=false:去掉奖icon
		public function showRewardFlag(bShow:Boolean):void
		{
			if (bShow)
			{
				showRewardIcon();
			}
			else
			{
				hideRewardIcon();
			}
		}
		
		private function showRewardIcon():void
		{
			if (m_rewardIcon == null)
			{
				m_rewardIcon = new Panel(this,-8,5);
				m_rewardIcon.setPanelImageSkin("commoncontrol/panel/rewardicon.png");
				m_rewardIcon.mouseChildren = false;
				m_rewardIcon.mouseEnabled = false;
			}
			m_rewardIcon.visible = true;
		}
		private function hideRewardIcon():void
		{
			if (m_rewardIcon)
			{
				m_rewardIcon.visible = false;
			}
		}
	}
}