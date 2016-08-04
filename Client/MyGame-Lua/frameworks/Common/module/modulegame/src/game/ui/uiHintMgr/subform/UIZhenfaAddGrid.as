package game.ui.uiHintMgr.subform 
{
	import com.bit101.components.Panel;
	import flash.events.MouseEvent;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import game.ui.uiHintMgr.UIHintMgr;
	/**
	 * ...
	 * @author ...
	 * 阵法中，上阵武将人数上限增加时提示
	 */
	public class UIZhenfaAddGrid extends UIHint
	{
		private var m_zhenfaPanel:Panel;
		
		public function UIZhenfaAddGrid(mgr:UIHintMgr) 
		{
			super(mgr);
		}
		
		override public function onReady():void 
		{
			m_zhenfaPanel = new Panel(this, 20, 26);
			m_zhenfaPanel.setPanelImageSkin("commoncontrol/panel/sysbtn/zhenxingbtn.png");
			
			super.onReady();
		}
		
		public function addDesc():void
		{
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("您开启了新的阵法位置，请立刻安排武将驻守！");
			var str:String = UtilHtml.getComposedContent();
			this.setText(str);
			m_funBtn.label = "立刻变阵";
		}
		
		override protected function onFunBtnClick(event:MouseEvent):void 
		{
			if (false == m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIZhenfa))
			{				
				m_gkcontext.m_UIMgr.showFormWidthProgress(UIFormID.UIZhenfa);
			}
			
			exit();
		}
		
	}

}