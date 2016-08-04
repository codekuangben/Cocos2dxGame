package game.ui.uiTeamFBSys.bossmoney
{
	import com.bit101.components.Panel;
	import game.ui.uiTeamFBSys.UITFBSysData;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;

	/**
	 * @brief 组队ＢＯＳ地图中，增加显示到该关数累积的金钱
	 */
	public class UIBossMoney extends Form
	{
		protected var m_pnlBG:Panel;
		public var m_TFBSysData:UITFBSysData;
		private var m_zhanliDC:DigitComponent;
		
		public function UIBossMoney()
		{
			id = UIFormID.UIBossMoney;
		}
		
		override public function onReady():void
		{
			super.onReady();
			this.setSize(582, 42);
			m_bCloseOnSwitchMap = false;
			this.alignVertial = TOP;
			this._marginTop = 50;
			
			m_pnlBG = new Panel(this);
			m_pnlBG.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysrd.leijizi");
			
			m_zhanliDC = new DigitComponent(m_gkcontext.m_context, this, 233, 12);
			m_zhanliDC.setParam("commoncontrol/digit/digit01", 10, 18);
			
			var total:uint = 0;
			if (m_gkcontext.m_teamFBSys.count - 1)	// 如果有闯过关
			{
				total = m_TFBSysData.m_xmlData.getTotalByIdx(m_gkcontext.m_teamFBSys.count - 1);
			}
			
			m_zhanliDC.digit = total;
		}
		
		override public function exit():void
		{
			m_TFBSysData.m_onUIClose(this.id);
			super.exit();
		}
	}
}