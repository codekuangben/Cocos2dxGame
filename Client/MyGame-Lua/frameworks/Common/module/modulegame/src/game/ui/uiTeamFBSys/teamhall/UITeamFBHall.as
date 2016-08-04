package game.ui.uiTeamFBSys.teamhall
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import flash.utils.ByteArray;
	import game.ui.uiTeamFBSys.msg.retOpenMultiCopyUiUserCmd;
	import game.ui.uiTeamFBSys.msg.stGainTeamAssistGiftUserCmd;
	import game.ui.uiTeamFBSys.msg.stReqTeamAssistInfoUserCmd;
	import game.ui.uiTeamFBSys.msg.stRetTeamAssistInfoUserCmd;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import modulecommon.net.msg.copyUserCmd.stReqCreateCopyUserCmd;
	import modulecommon.scene.MapInfo;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITeamFBSys;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.msg.openMultiCopyUiUserCmd;
	import modulecommon.net.msg.copyUserCmd.reqTeamBossRankUserCmd;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;

	/**
	 * @brief 组队大厅
	 * */
	public class UITeamFBHall extends Form
	{
		public var m_TFBSysData:UITFBSysData;
		protected var m_uiroot:Component;
		
		protected var m_leftroot:Component;
		protected var m_rightroot:Component;
		protected var m_rtopRoot:Component;

		protected var _exitBtn:PushButton;
		protected var m_bgPanel:Panel;
		
		//protected var m_lblCopy:Label;		// 组队副本
		//protected var m_lblThrough:Label;	// 组队闯关 
		
		protected var m_textCopy:TextNoScroll;		// 组队副本
		protected var m_textThrough:TextNoScroll;	// 组队闯关
		
		protected var m_lblCopyAttr:Label;		// 组队副本
		protected var m_lblThroughAttr:Label;	// 组队闯关
		
		protected var m_btnCopy:PushButton;		// 组队副本
		protected var m_btnThrough:PushButton;	// 组队闯关
		
		protected var m_lblDesc1f:Label;	// 组队闯关
		protected var m_lblDesc2f:Label;	// 组队闯关
		protected var m_lblDesc3f:Label;	// 组队闯关
		
		private var m_rewardPanel:Vector.<Panel>;
		protected var m_btnRank:ButtonText;	// 组队闯关
		protected var m_pnlMid:MidPnl;	// 中间面板
		
		public function UITeamFBHall()
		{
			this.id = UIFormID.UITeamFBHall;
			setAniForm(70);
		}
		
		override public function onReady():void
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			this.setSize(582, 486);
			//this.title = "组队大厅";
			_hitYMax = 100;
			
			//var xoff:uint = 100;
			
			m_bgPanel = new Panel(null);
			this.addBackgroundChild(m_bgPanel);
			m_bgPanel.setPanelImageSkin("module/teamfb/teamhall.png");
			
			_exitBtn = new PushButton(this);
			_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			
			_exitBtn.setPos(552, 66);
			
			m_uiroot = new Component(this, 30, 30);
			
			m_leftroot = new Component(m_uiroot, 3);
			m_rightroot = new Component(m_uiroot, 290);
			m_rtopRoot = new Component(m_uiroot, 434, 69);
			
			//m_lblCopy = new Label(m_leftroot, xoff, 80, "组队副本", UtilColor.COLOR2);
			//m_lblCopy.align = Component.CENTER;
			//m_lblThrough = new Label(m_rightroot, xoff, 80, "组队闯关", UtilColor.COLOR2);
			//m_lblThrough.align = Component.CENTER;
			
			m_textCopy = new TextNoScroll();
			m_leftroot.addChild(m_textCopy);
			m_textCopy.width = 200;
			m_textCopy.height = 100;
			m_textCopy.x = 15;
			m_textCopy.y = 268;
			m_textCopy.mouseEnabled = false;
			m_textCopy.mouseWheelEnabled = false;
			
			UtilHtml.beginCompose();
			UtilHtml.add("和二位好友一起组队挑战经典战役的Boss们，可获得大量金装和紫装材料!!!", UtilColor.COLOR2);
			m_textCopy.htmlText = UtilHtml.getComposedContent();
			
			m_textThrough = new TextNoScroll();
			m_rightroot.addChild(m_textThrough);
			m_textThrough.width = 200;
			m_textThrough.height = 100;
			m_textThrough.x = 15;
			m_textThrough.y = 268;
			m_textThrough.mouseEnabled = false;
			m_textThrough.mouseWheelEnabled = false;
			
			UtilHtml.beginCompose();
			UtilHtml.add("每日都记得和好友一起来尝试下能闯到哪一层哦!凌晨7点邮件发奖，层数越高奖励越多!", UtilColor.COLOR2);
			m_textThrough.htmlText = UtilHtml.getComposedContent();
			
			//m_lblCopyAttr = new Label(m_leftroot, 100, 350, "今日剩余奖励次数(" + m_gkcontext.m_teamFBSys.leftUseCnt + "/2)", UtilColor.COLOR2);
			m_lblCopyAttr = new Label(m_leftroot, 100, 350, "今日剩余奖励次数(" + m_TFBSysData.m_usecnt + "/" + m_TFBSysData.m_gkcontext.m_teamFBSys.maxCountsFight + ")", UtilColor.COLOR2);
			m_lblCopyAttr.align = Component.CENTER;
			
			m_lblThroughAttr = new Label(m_rightroot, 100, 350, "今日关数: " + m_gkcontext.m_teamFBSys.count + "关", UtilColor.COLOR2);
			m_lblThroughAttr.align = Component.CENTER;
			
			m_btnCopy = new PushButton(m_leftroot, 50, 370, onBtnCopy);
			m_btnCopy.setSkinButton1Image("commoncontrol/panel/sanguozhanchang/enterbtn.png");
			
			m_btnThrough = new PushButton(m_rightroot, 50, 370, onBtnThrough);
			m_btnThrough.setSkinButton1Image("commoncontrol/panel/sanguozhanchang/enterbtn.png");
			
			m_lblDesc1f = new Label(m_rtopRoot, 0, 0, "关数奖励:", UtilColor.COLOR2);
			m_lblDesc2f = new Label(m_rtopRoot, 0, 20, "名次奖励:", UtilColor.COLOR2);
			m_lblDesc3f = new Label(m_rtopRoot, 0, 40, "每日7点发奖", UtilColor.COLOR2);
			
			m_rewardPanel = new Vector.<Panel>(2, true);
			m_rewardPanel[0] = new Panel(m_rtopRoot, 70);
			m_rewardPanel[0].tag = 0;
			m_rewardPanel[0].addEventListener(MouseEvent.ROLL_OVER, onRankRewardMouseRollOver);
			m_rewardPanel[0].addEventListener(MouseEvent.ROLL_OUT, onRankRewardMouseRollOut);
			m_rewardPanel[0].setPanelImageSkin("commoncontrol/panel/box.png");
			
			m_rewardPanel[1] = new Panel(m_rtopRoot, 70, 20);
			m_rewardPanel[1].tag = 1;
			m_rewardPanel[1].addEventListener(MouseEvent.ROLL_OVER, onRankRewardMouseRollOver);
			m_rewardPanel[1].addEventListener(MouseEvent.ROLL_OUT, onRankRewardMouseRollOut);
			m_rewardPanel[1].setPanelImageSkin("commoncontrol/panel/box.png");
			
			m_btnRank = new ButtonText(m_rtopRoot, 15, 57, "排行榜", onBtnClkRank);
			m_btnRank.normalColor = UtilColor.RED;
			m_btnRank.overColor = UtilColor.GREEN;
			m_btnRank.setSize(60, 20);
			m_btnRank.labelComponent.underline = true;
			
			m_pnlMid = new MidPnl(m_TFBSysData, m_uiroot, 220, 80);
			
			var cmd:stReqTeamAssistInfoUserCmd = new stReqTeamAssistInfoUserCmd();
			m_TFBSysData.m_gkcontext.sendMsg(cmd);
			
			// 有个数据需要请求一下
			m_TFBSysData.m_gkcontext.m_teamFBSys.openHallMulMsg = true;
			var cmdMul:openMultiCopyUiUserCmd = new openMultiCopyUiUserCmd();
			m_TFBSysData.m_gkcontext.sendMsg(cmdMul);
		}
		
		override public function dispose():void
		{
			m_rewardPanel[0].removeEventListener(MouseEvent.ROLL_OVER, onRankRewardMouseRollOver);
			m_rewardPanel[0].removeEventListener(MouseEvent.ROLL_OUT, onRankRewardMouseRollOut);
			
			m_rewardPanel[1].removeEventListener(MouseEvent.ROLL_OVER, onRankRewardMouseRollOver);
			m_rewardPanel[1].removeEventListener(MouseEvent.ROLL_OUT, onRankRewardMouseRollOut);
			
			super.dispose();
		}
		
		override public function exit():void
		{
			super.exit();
			m_TFBSysData.m_onUIClose(this.id);
		}
		
		private function onBtnCopy(event:MouseEvent):void
		{
			m_TFBSysData.m_gkcontext.m_teamFBSys.copyType = 1;
			var cmd:openMultiCopyUiUserCmd = new openMultiCopyUiUserCmd();
			m_TFBSysData.m_gkcontext.sendMsg(cmd);
			
			m_TFBSysData.m_gkcontext.m_teamFBSys.clkBtn = false;
		}
		
		private function onBtnThrough(event:MouseEvent):void
		{
			m_TFBSysData.m_gkcontext.m_teamFBSys.copyType = 2;

			var cmd:stReqCreateCopyUserCmd = new stReqCreateCopyUserCmd();
			cmd.copyid = MapInfo.MAPID_TeamChuanGuan;
			cmd.type = 0;
			m_TFBSysData.m_gkcontext.sendMsg(cmd);
			exit();
		}
		
		private function onBtnClkRank(e:MouseEvent):void
		{
			var cmd:reqTeamBossRankUserCmd = new reqTeamBossRankUserCmd();
			m_TFBSysData.m_gkcontext.sendMsg(cmd);
			
			(m_TFBSysData.m_form as IUITeamFBSys).openUI(UIFormID.UITeamFBCGRank);
		}
		
		public function onRankRewardMouseRollOver(e:MouseEvent):void
		{
			var idx:uint = (e.currentTarget as Component).tag;
			m_rewardPanel[idx].filtersAttr(true); 
			var str:String = "";
			var stridx:int = 0;
			var total:uint = 0;
			if(idx == 0)	// 关数奖励，可以设置一个参数
			{
				if (m_gkcontext.m_teamFBSys.count - 1)	// 如果有闯过关
				{
					str = m_TFBSysData.m_xmlData.m_guanshujianglitip;
					stridx = str.indexOf("%1");	// 可以放一个参数
					
					if (stridx != -1)
					{
						total = m_TFBSysData.m_xmlData.getTotalByIdx(m_gkcontext.m_teamFBSys.count - 1);
						//str.replace("%1", total + "");
						str = str.split("%1").join(total + "");
					}
				}
				else
				{
					str = m_TFBSysData.m_xmlData.m_defGuanshujianglitip;
				}
			}
			else
			{
				if (m_TFBSysData.getHeroRank() > 0)		// 有排行
				{
					str = m_TFBSysData.m_xmlData.getTextByRank(m_TFBSysData.getHeroRank());
				}
				else
				{
					str = m_TFBSysData.m_xmlData.m_defMingcijianglitip;
				}
			}
			if (str)
			{
				var pt:Point = m_rewardPanel[idx].localToScreen();
				pt.x += 21;
				m_TFBSysData.m_gkcontext.m_uiTip.hintHtiml(pt.x, pt.y, str);
			}
		}
		
		public function onRankRewardMouseRollOut(e:MouseEvent):void
		{
			var idx:uint = (e.currentTarget as Component).tag;
			m_TFBSysData.m_gkcontext.m_uiTip.hideTip();
			m_rewardPanel[idx].filtersAttr(false);
		}
		
		public function psstGainTeamAssistGiftUserCmd(msg:ByteArray):void
		{
			m_pnlMid.psstGainTeamAssistGiftUserCmd(msg);
		}
		
		public function psstRetTeamAssistInfoUserCmd(msg:ByteArray):void
		{
			m_pnlMid.psstRetTeamAssistInfoUserCmd(msg);
		}
		
		public function psretOpenMultiCopyUiUserCmd(msg:retOpenMultiCopyUiUserCmd):void
		{
			m_TFBSysData.m_usecnt = msg.count;
			m_TFBSysData.m_gkcontext.m_teamFBSys.usecnt = msg.count;		// 记录次数，有个确认对话框还要用这个值
			m_lblCopyAttr.text = "今日剩余奖励次数(" + msg.count + "/" + m_TFBSysData.m_gkcontext.m_teamFBSys.maxCountsFight + ")";
		}
		
		override public function getDestPosForHide():Point 
		{
			if (m_TFBSysData.m_gkcontext.m_UIs.screenBtn)
			{
				var pt:Point = m_TFBSysData.m_gkcontext.m_UIs.screenBtn.getBtnPosInScreen(ScreenBtnMgr.Btn_TeamFB);
				if (pt)
				{
					pt.x -= 10;
					return pt;
				}
			}
			return null;
		}
	}
}