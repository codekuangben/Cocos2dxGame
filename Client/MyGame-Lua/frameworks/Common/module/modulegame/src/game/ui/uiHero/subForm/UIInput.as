package game.ui.uiHero.subForm 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneUserCmd.TestVipRechargeScoreUserCmd;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.FormTitle;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 */
	public class UIInput extends FormTitle
	{
		private var m_gkContext:GkContext;
		private var m_exitBtn:PushButton;
		private var m_funBtn:ButtonText;
		private var m_numLabel:Label2;
		private var m_inputBg:PanelContainer;
		private var m_input:InputText;
		
		public function UIInput(gk:GkContext) 
		{
			this.draggable = false;
			this.exitMode = EXITMODE_HIDE;
			this.id = UIFormID.UIInput;
			
			m_gkContext = gk;
			
			m_exitBtn = new PushButton(this, 223,3, onExitBtnClick);
			m_exitBtn.setPanelImageSkin("commoncontrol/button/exitbtn2.swf");
			
			m_funBtn = new ButtonText(this, 67, 125,"确定",onFunBtnClick);
			m_funBtn.setSize(130, 40);
			m_funBtn.setGrid9ImageSkin("commoncontrol/button/button2.swf");
			m_funBtn.letterSpacing = 4;
			m_funBtn.normalColor = 0xfbdda2;
			m_funBtn.overColor = 0xfff1d6;
			m_funBtn.downColor = 0xf3c976;
			m_funBtn.labelComponent.setFontSize(14);
			m_funBtn.labelComponent.setBold(true);
			
			var label:Label = new Label(this, 35, 40, "VIP充值", UtilColor.RED, 16);
			
			m_numLabel = new Label2(this, 34, 80);
			var lf:LabelFormat = new LabelFormat();
			lf.size = 14;
			lf.color = UtilColor.GOLD;
			lf.text = "输入金额：              （元）";
			lf.bMiaobian = false;
			m_numLabel.labelFormat = lf;
			
			m_inputBg = new PanelContainer(this, 110, 70);
			//m_inputBg.setPanelImageSkin("commoncontrol/panel/nameback.png");
			m_input = new InputText(m_inputBg, 2, 2);
			m_input.setSize(70, 30);
			m_input.showBack();
			m_input.setTextFormat(0x0, 16,true);
			m_input.number = true;
			m_input.text = "0";
			
			this.setPanelImageSkin("commoncontrol/panel/hintback.png");
		}
		
		override public function onReady():void 
		{
			this.darkOthers(0, 0);
			super.onReady();
		}
		
		override public function show():void
		{
			super.show();
			this.darkOthers();
			m_input.text = "0";
		}
		
		protected function onFunBtnClick(e:MouseEvent):void
		{
			var cmd:TestVipRechargeScoreUserCmd = new TestVipRechargeScoreUserCmd();
			cmd.rmb = parseInt(m_input.text);
			m_gkContext.sendMsg(cmd);
			
			exit();
		}
		
		override public function onStageReSize():void 
		{
			super.onStageReSize();
			this.darkOthers();
		}		
		
	}

}