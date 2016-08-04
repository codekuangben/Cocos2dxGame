package game.ui.uibackpack.subForm 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	import com.bit101.components.PanelContainer;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.FormTitle;
	import flash.events.MouseEvent;
	import com.bit101.components.PushButton;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author 
	 */
	public class UIChaifenDlg extends FormTitle 
	{
		private var m_exitBtn:PushButton;
		private var m_numLabel:Label2;
		private var m_input:InputText;
		private var m_funBtn:ButtonText;
		private var m_inputBg:PanelContainer;
		
		private var m_callBack:Function;
		private var m_param:Object;
		public function UIChaifenDlg()
		{
			this.draggable = false;
			this.exitMode = EXITMODE_HIDE;
			this.id = UIFormID.UIChaifenDlg;
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
			
			m_numLabel = new Label2(this, 34, 60);
			var lf:LabelFormat = new LabelFormat();
			lf.size = 14;
			lf.color = UtilColor.GOLD;
			lf.text = "输入数量";
			lf.bMiaobian = false;
			m_numLabel.labelFormat = lf;
			
			m_inputBg = new PanelContainer(this, 100, 50);
			//m_inputBg.setPanelImageSkin("commoncontrol/panel/nameback.png");
			m_input = new InputText(m_inputBg, 2, 2);
			m_input.setSize(100, 30);
			m_input.showBack();
			m_input.setTextFormat(0x0, 16,true);
			m_input.number = true;
			
			this.setPanelImageSkin("commoncontrol/panel/hintback.png");
		}
		
		override public function onReady():void 
		{
			this.darkOthers(0, 0);
			super.onReady();
		}
		protected function onFunBtnClick(e:MouseEvent):void
		{
			m_callBack(parseInt(m_input.text), m_param);
			m_param = null;
			m_callBack = null;
			exit();
		}
		
		override public function onStageReSize():void 
		{
			super.onStageReSize();
			this.darkOthers();
		}
		
		public function setParam(fun:Function, param:Object):void
		{
			m_callBack = fun;
			m_param = param;
			
			var obj:ZObject = (param as ObjectPanel).objectIcon.zObject;
			m_input.text = "1";
			m_input.minNumber = 0;
			m_input.maxNumber = obj.m_object.num;
		}
		override protected function onExitBtnClick(e:MouseEvent):void
		{
			m_param = null;
			m_callBack = null;
			exit();
		}
	}

}