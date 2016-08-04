package game.ui.treasurehunt 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Label;
	import modulecommon.appcontrol.MoneyPanel;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	//import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import game.ui.treasurehunt.msg.stStartHuntingCmd;
	//import modulecommon.scene.prop.object.ZObject;
	import modulecommon.ui.FormStyleExitBtn;
	import com.util.UtilColor;
	import modulecommon.uiinterface.IUITreasureHunt;
	import com.bit101.components.Component;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.commonfuntion.ConfirmDialogMgr;
	import modulecommon.scene.prop.BeingProp;
	
	/**
	 * ...
	 * @author ...
	 */
	public class UITreasureHunt extends FormStyleExitBtn implements IUITreasureHunt
	{
		private var m_leftPart:leftList;
		private var m_rightPart:rightList;
		private var m_middlePart:midPart;
		private var m_btnList:Vector.<PushButton>;
		private var m_ruleBtn:ButtonText;
		private var m_buttomLabel:Label;
		private var m_tag:int;
		private var m_exchangeBtn:PushButton;
		private var m_scoreLabel:Label;
		public function UITreasureHunt() 
		{
			super();
			_hitYMax = 95;
			
			this.exitMode = EXITMODE_HIDE;
			setAniForm(70);
			timeForTimingClose = 20;
		}
		override public function onReady():void 
		{
			super.onReady();
			
			this.setSize(994, 616);
			this.setPanelImageSkin("commoncontrol/panel/treasurehunt/huntbg.png");
			m_exitBtn.setPos(965,67);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			
			m_gkcontext.m_treasurehuntMgr.loadConfig();
			m_gkcontext.m_treasurehuntMgr.m_uitreasurehunt = this;
			m_leftPart = new leftList(this, 35, 175);
			m_leftPart.setdata(m_gkcontext.m_treasurehuntMgr.bigPrize,m_gkcontext.m_treasurehuntMgr.bigPrizev);
			m_rightPart = new rightList(this, 725, 175);
			m_rightPart.setdata(m_gkcontext.m_treasurehuntMgr.userPrize);
			m_btnList = new Vector.<PushButton>();
			var posx:int = 226;
			var posy:int = 543;
			var posvx:int = 142;
			for (var i:int = 1; i < 3; i++ )
			{
				var btn:PushButton = new PushButton(this, posx + posvx * i, posy, btnclick);
				btn.setSkinButton1Image("commoncontrol/panel/treasurehunt/findbtn" + i + ".png");
				btn.tag = i;
				btn.addEventListener(MouseEvent.MOUSE_OVER, onBtnMouseEnter);
				btn.addEventListener(MouseEvent.MOUSE_OUT, m_gkcontext.hideTipOnMouseOut);
				m_btnList.push(btn);
			}
			m_middlePart = new midPart(m_gkcontext, this, 270, 150);
			m_ruleBtn = new ButtonText(this, 617, 104, "规则说明");
			m_ruleBtn.normalColor = UtilColor.YELLOW;
			m_ruleBtn.overColor = UtilColor.GREEN;
			m_ruleBtn.setSize(60, 20);
			m_ruleBtn.letterSpacing = 1;
			m_ruleBtn.labelComponent.underline = true;
			m_ruleBtn.addEventListener(MouseEvent.MOUSE_OVER, onRuleMouseEnter);
			m_ruleBtn.addEventListener(MouseEvent.MOUSE_OUT, m_gkcontext.hideTipOnMouseOut);
			m_buttomLabel = new Label(this, 501, 484, "", UtilColor.GOLD, 14);
			m_buttomLabel.align = Component.CENTER;
			m_exchangeBtn = new PushButton(this, 817, posy, exchangeClick);
			m_exchangeBtn.setSkinButton1Image("commoncontrol/panel/treasurehunt/exchangebtn.png");
			m_scoreLabel = new Label(this, 891, 484, "", 16777215, 14);
			m_scoreLabel.align = CENTER;
			refrashScore();
		}
		override public function onShow():void 
		{
			super.onShow();
			updataButoon();
			m_middlePart.onshow();
		}
		override public function onHide():void 
		{
			if (m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIHuntExchange))
			{
				m_gkcontext.m_UIMgr.exitForm(UIFormID.UIHuntExchange);
			}
			super.onHide();
		}
		public function updataLeftPart(strlist:Array,strlistv:Array):void
		{
			m_leftPart.updata(strlist,strlistv);
		}
		public function updataRightPart(strlist:Array):void
		{
			m_rightPart.updata(strlist);
		}
		public function updataButoon():void
		{
			m_buttomLabel.text = "您拥有的藏宝图:" + m_gkcontext.m_objMgr.computeObjNumInCommonPackage(10414);//藏宝图ID:10414
		}
		
		private function exchangeClick(e:MouseEvent):void
		{
			var form:Form = m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIHuntExchange);
			form.show();
		}
		private function btnclick(e:MouseEvent):void
		{
			m_tag = (e.target as PushButton).tag;
			var showDlg:Boolean = false;
			var numNeedPay:int;
			var numTu:int = m_gkcontext.m_objMgr.computeObjNumInCommonPackage(10414);
			if (m_tag == 1)
			{
				if (numTu >= 1)
				{
					showDlg = false;
				}
				else
				{
					showDlg = true;
					numNeedPay = 50;
				}
			}
			else if (m_tag == 2)
			{
				if (numTu >= 10)
				{
					showDlg = false;
				}
				else
				{
					showDlg = true;
					numNeedPay = 45 * (10 - numTu);
				}
			}
			else
			{
				if (numTu >= 50)
				{
					showDlg = false;
				}
				else
				{
					showDlg = true;
					numNeedPay = 40 * (50 - numTu);
				}
			}
			if (!m_gkcontext.m_treasurehuntMgr.bNoQuery && showDlg)
			{
				var radio:Object = new Object();
				radio[ConfirmDialogMgr.RADIOBUTTON_select] = false;
				radio[ConfirmDialogMgr.RADIOBUTTON_desc] = "下次不再提示";
				var param:Object = new Object();
				param[ConfirmDialogMgr.RADIOBUTTON_panelType] = BeingProp.YUAN_BAO;
				var pt:Point = new Point(0, 65);
				pt.x = numNeedPay.toString().length * 8 + 240;
				param[ConfirmDialogMgr.RADIOBUTTON_panelPos] = pt;
				var desc:String = "您本次探宝需要额外支付 " + numNeedPay;
				m_gkcontext.m_confirmDlgMgr.showMode1(this.id, desc, ConfirmBringBtnFn, null, "确认", "取消", radio, false, null, param);
			}
			else
			{
				ConfirmBringBtnFn();
			}
			
			
		}
		private function ConfirmBringBtnFn():Boolean
		{
			if (m_gkcontext.m_confirmDlgMgr.isRadioButtonCheck())
			{
				m_gkcontext.m_treasurehuntMgr.bNoQuery = true;
			}
			var send:stStartHuntingCmd = new stStartHuntingCmd();
			send.hunttype = m_tag;
			m_gkcontext.sendMsg(send);
			
			return true;
		}
		private function onRuleMouseEnter(e:MouseEvent):void
		{
			var str:String = m_gkcontext.m_treasurehuntMgr.treasurerule;
			if (str)
			{
				var pt:Point = m_ruleBtn.localToScreen();
				pt.x -= 5;
				pt.y += 20;
				m_gkcontext.m_uiTip.hintHtiml(pt.x, pt.y, str);
			}
		}
		private function onBtnMouseEnter(e:MouseEvent):void
		{
			var str:String;
			if (e.target.tag == 1)
			{
				str = "寻宝1次消耗1个藏宝图或50元宝";
			}
			else if (e.target.tag == 2)
			{
				str = "寻宝10次消耗10个藏宝图或450元宝";
			}
			else
			{
				str = "寻宝50次消耗50个藏宝图或2000元宝";
			}
			if (str)
			{
				var pt:Point = (e.target as PushButton).localToScreen();
				pt.x -= 5;
				pt.y -= 50;
				m_gkcontext.m_uiTip.hintHtiml(pt.x, pt.y, str);
			}
		}
		/*public function processMsg(msg:ByteArray):void
		{
			var rev:stRefreshHuntingPersonalPrizeCmd = new stRefreshHuntingPersonalPrizeCmd();
			rev.deserialize(msg);
			updataRightPart(rev.m_prizestr);
		}*/
		public function processMsg_stHuntingResultCmd(msg:ByteArray):void
		{
			m_middlePart.updataResurt(msg);
			updataButoon();
		}
		public function refrashScore():void
		{
			m_scoreLabel.text="寻宝积分："+m_gkcontext.m_treasurehuntMgr.score.toString();
		}
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.sysBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.screenBtn.getBtnPosInScreen(ScreenBtnMgr.Btn_TreasureHunting);
				if (pt)
				{
					pt.x -= 13;
					pt.y -= 17;
					return pt;
				}
			}
			return null;
		}
		override public function dispose():void 
		{
			if (m_btnList)
			{
				for each(var btn:PushButton in m_btnList)
				{
					btn.removeEventListener(MouseEvent.MOUSE_OVER, onBtnMouseEnter);
					btn.removeEventListener(MouseEvent.MOUSE_OUT, m_gkcontext.hideTipOnMouseOut);
				}
			}
			if (m_ruleBtn)
			{
				m_ruleBtn.removeEventListener(MouseEvent.MOUSE_OVER, onRuleMouseEnter);
				m_ruleBtn.removeEventListener(MouseEvent.MOUSE_OUT, m_gkcontext.hideTipOnMouseOut);
			}
			super.dispose();
		}
	}

}