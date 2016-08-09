package modulecommon.commonfuntion.confirmdlg.subform
{
	import com.bit101.components.ButtonRadio;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import modulecommon.appcontrol.MoneyPanel;
	import com.util.UtilHtml;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import modulecommon.commonfuntion.ConfirmDialogMgr;
	import modulecommon.res.ResGrid9;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import com.bit101.components.InputText;
	
	public class UIConfirm_Common extends UIConfirmBase
	{

		protected var m_dicFun:Dictionary;
		
		protected var m_descRadio:TextNoScroll;
		
		protected var m_radioBtn:ButtonRadio;
		protected var m_moneyPanel:MoneyPanel;
		protected var m_exitBtn:PushButton;
		
		protected var m_funOnRadio:Function; //当前，此函数无效
		protected var m_funOnExit:Function; //点击关闭按钮时的回调函数
		protected var m_image1f:Panel; //显示一个小 icon
		protected var m_inputYes:InputText;
		protected var m_showYesConfirm:Boolean = false;
		
		public function UIConfirm_Common(/*uiMgr:UIConfirmDlg*/)
		{
			//m_uiConfirmMgr = uiMgr;
			
			m_dicFun = new Dictionary();
			m_dicFun[ConfirmDialogMgr.MODE1] = showMode1;
			m_dicFun[ConfirmDialogMgr.MODE2] = showMode2;
		}
		
		override public function onReady():void
		{
			super.onReady();
			this.width = 400;
			
			m_descRadio = new TextNoScroll();
			this.addChild(m_descRadio);
			m_descRadio.width = 340;
			m_descRadio.setCSS("body", {color: "#eeeeee", fontSize: 14});
			
			m_radioBtn = new ButtonRadio(this, 55, 0);
			m_radioBtn.setPanelImageSkin("commoncontrol/button/bb_buttonradio.swf");
			m_descRadio.x = m_radioBtn.x + 25;
			
			m_exitBtn = new PushButton(this, this.width - 60, 34, onExitBtnClick);
			m_exitBtn.setPanelImageSkin("commoncontrol/button/exitbtn.swf");
			m_exitBtn.visible = false;
			
			m_image1f = new Panel(this, 205, 114);
			m_image1f.visible = false;
			
			m_inputYes = new InputText(this, 158, 0, "");
			m_inputYes.setTextFormat(0xffffff, 14);
			m_inputYes.maxChars = 3;
			m_inputYes.marginLeft = 5;
			m_inputYes.align = Component.CENTER;
			m_inputYes.setHorizontalImageSkin("commoncontrol/horstretch/inputBg_mirror.png");
			m_inputYes.visible = false;
			
			var label:Label = new Label(m_inputYes, 55, -25);
			label.align = Component.CENTER;
			UtilHtml.beginCompose();
			UtilHtml.add("请在下方输入", UtilColor.WHITE_Yellow, 14);
			UtilHtml.add("【YES】", UtilColor.GREEN, 14);
			UtilHtml.add("确认操作。", UtilColor.WHITE_Yellow, 14);
			label.htmlText = UtilHtml.getComposedContent();
			
			this.setSkinGrid9Image9(ResGrid9.StypeSix);
		}
		
		override public function onDestroy():void
		{
			super.onDestroy();			
		}
		
		override public function onHide():void
		{
			super.onHide();
			m_funOnRadio = null;
			m_funOnExit = null;
			m_gkcontext.m_confirmDlgMgr.resetData();
		}
		
		private function resetControls():void
		{
			m_descRadio.visible = false;
			m_cancelBtn.visible = false;
			if (m_radioBtn)
				m_radioBtn.visible = false;
			m_exitBtn.visible = false;
			m_image1f.visible = false;
			m_inputYes.visible = false;
			
			m_showYesConfirm = false;
		}
		
		public function process(data:Object):void
		{
			resetControls();
			m_mode = data["mode"];
			m_dicFun[m_mode](data);
		
		}
		
		//一段文字，下面是2个按钮，分别是确认，取消
		public function showMode1(param:Object):void
		{
			var top:int;
			var nameConfirm:String;
			var nameConcel:String;
			
			var desc:String = param["desc"];
			var funConfirm:Function = param["funConfirm"];
			var funConcel:Function = param["funConcel"];
			var radioButton:Object = param["radioButton"];
			if (param[ConfirmDialogMgr.Param_YesConfirm] != undefined)
			{
				m_showYesConfirm = param[ConfirmDialogMgr.Param_YesConfirm] as Boolean;
			}
			else
			{
				m_showYesConfirm = false;
			}
			
			if (param["nameConfirm"] != undefined)
			{
				nameConfirm = param["nameConfirm"]
			}
			else
			{
				nameConfirm = "确认"
			}
			if (param["nameConcel"] != undefined)
			{
				nameConcel = param["nameConcel"]
			}
			else
			{
				nameConcel = "取消";
			}
			
			if (param["exitBtn"] != undefined)
			{
				m_exitBtn.visible = true;
				if (param["funExit"] != undefined)
				{
					m_funOnExit = param["funExit"];
				}
			}
			
			if (param["image"])
			{
				m_image1f.visible = true;
				m_image1f.setPanelImageSkin(param["image"]);
			}
			else
			{
				m_image1f.visible = false;
			}
			
			if (param["RADIOBUTTON_panelType"] != undefined && param["RADIOBUTTON_panelPos"] != undefined)
			{
				if (!m_moneyPanel)
				{
					m_moneyPanel = new MoneyPanel(m_gkcontext, this);
				}
				m_moneyPanel.visible = true;
				m_moneyPanel.type = param["RADIOBUTTON_panelType"];
				m_moneyPanel.setPos(param["RADIOBUTTON_panelPos"].x, param["RADIOBUTTON_panelPos"].y);
			}
			else
			{
				if (m_moneyPanel)
				{
					m_moneyPanel.visible = false;
				}
			}
			
			m_tf.htmlText = "<body>" + desc + "</body>";
			top = m_tf.y + m_tf.textHeight + 15;
			
			if (radioButton != null)
			{
				m_descRadio.htmlText = "<body>" + radioButton[ConfirmDialogMgr.RADIOBUTTON_desc] + "</body>";
				m_funOnRadio = radioButton[ConfirmDialogMgr.RADIOBUTTON_clickFuntion];
				m_radioBtn.selected = radioButton[ConfirmDialogMgr.RADIOBUTTON_select];
				
				m_radioBtn.y = top;
				m_descRadio.y = top + 0;
				
				m_descRadio.visible = true;
				m_radioBtn.visible = true;
				
				top += 25;
			}
			
			if (m_showYesConfirm)
			{
				m_inputYes.visible = true;
				m_inputYes.focus = true;
				m_inputYes.text = "";
				m_inputYes.y = top + 30;
				
				top = m_inputYes.y + 30;
			}
			
			top += 80;
			if (top < 199)
			{
				top = 199;
			}
			this.height = top;
			
			m_confirmBtn.setPos(72, top - 70);
			setButtonName(m_confirmBtn, nameConfirm);
			
			m_cancelBtn.visible = true;
			m_cancelBtn.setPos(224, top - 70);
			setButtonName(m_cancelBtn, nameConcel);
			
			m_funOnConfirm = funConfirm;
			m_funOnConcel = funConcel;
			
			this.adjustPosWithAlign();
			
			if (this.parent && this.parent is Sprite)
			{
				var p:DisplayObjectContainer = this.parent;
				p.removeChild(this);
				p.addChild(this);
			}
			this.darkOthers();
			m_mode = ConfirmDialogMgr.MODE1;
		}
		
		public function showMode2(param:Object):void
		{
			var top:int;
			var nameConfirm:String;
			
			var desc:String = param["desc"];
			var funConfirm:Function = param["funConfirm"];
			
			if (param["nameConfirm"] != undefined)
			{
				nameConfirm = param["nameConfirm"]
			}
			else
			{
				nameConfirm = "确认"
			}
			
			m_tf.htmlText = "<body>" + desc + "</body>";
			
			top = m_tf.y + m_tf.textHeight + 95;
			
			if (top < 199)
			{
				top = 199;
			}
			this.height = top;
			
			m_confirmBtn.setPos((this.width - 120) / 2, top - 70);
			setButtonName(m_confirmBtn, nameConfirm);
			
			m_funOnConfirm = funConfirm;
			
			this.adjustPosWithAlign();
			this.darkOthers();
			m_mode = ConfirmDialogMgr.MODE2;
		}
		
		public function isRadioButtonCheck():Boolean
		{
			return m_radioBtn.selected;
		}
		
		override public function updateDesc(desc:String):void
		{
			m_tf.htmlText = "<body>" + desc + "</body>";
		}
		
		override public function onConfirmBtnClick(e:MouseEvent):void
		{
			if (m_showYesConfirm)
			{
				var str:String = m_inputYes.text;
				str.toLowerCase();
				if (str.toLowerCase() != "yes")
				{
					m_gkcontext.m_systemPrompt.prompt("输入错误，请重新输入");
					return;
				}
			
			}
			super.onConfirmBtnClick(e);
		}
		
		override protected function onExitBtnClick(e:MouseEvent):void
		{
			var bClose:Boolean = false;
			if (m_funOnExit != null)
			{
				if (m_funOnExit())
				{
					bClose = true;
					m_funOnExit = null;
				}
			}
			else
			{
				bClose = true;
			}
			
			if (bClose)
			{
				this.exit();
			}
		}
		
		public function clearData():void
		{
			m_funOnConfirm = null;
			m_funOnConcel = null;
			m_funOnRadio = null;
			m_funOnExit = null;
		}
	}

}