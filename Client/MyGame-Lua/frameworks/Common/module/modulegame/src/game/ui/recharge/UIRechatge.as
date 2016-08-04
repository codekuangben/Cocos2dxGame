package game.ui.recharge 
{
	import com.bit101.components.Ani;
	import com.bit101.components.ButtonText;
	import com.bit101.components.controlList.ControlHAlignmentParam;
	import com.bit101.components.label.Label2;
	import com.bit101.components.Panel;
	import com.bit101.components.progressBar.BarInProgress2;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.net.msg.activityCmd.getRechargeBackRewardCmd;
	import modulecommon.scene.benefithall.rebate.RechargeRebateMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import com.bit101.components.controlList.ControlListH
	import modulecommon.time.Daojishi;
	import modulecommon.ui.FormStyleExitBtn;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIRechatge;
	/**
	 * 此项目原为充值返利 后改为充值送将
	 * 总体结构就是bgimage上摆个进度条、一个由单一带特效、按钮效果的objpanel为单元的hlist控件、再来一个hlist控件、和一个领奖按钮
	 */
	public class UIRechatge extends FormStyleExitBtn implements IUIRechatge
	{
		/**
		 * 进度条下面的一排物品按钮行
		 */
		private var m_list:ControlListH;
		/**
		 * 奖励list
		 */
		private var m_rewardList:ControlListH;
		/**
		 * 元宝进度条 非线性
		 */
		private var m_valueBar:BarInProgress2;
		/**
		 * 领奖按钮
		 */
		private var m_btn:PushButton;
		/**
		 * 待释放的背景动画
		 */
		private var m_bgAniVec:Vector.<Ani>;
		/**
		 * 当前选中序号
		 */
		public var m_curSelectIndex:int;
		/**
		 * 元宝爆炸图片bg
		 */
		private var m_cumulativePanel:Panel;
		/**
		 * 元宝数美术字
		 */
		private var m_digitYB:DigitComponent;
		/**
		 * 当前充值元宝数
		 */
		private var m_curYuanbao:Label2;
		/**
		 * 活动时间说明
		 */
		private var m_ruleBtn:ButtonText;
		/**
		 * 活动倒计时
		 */
		private var m_jishiqi:Daojishi;
		public function UIRechatge()
		{
			super();
			this.id = UIFormID.UIRechatge;
			setAniForm(75);
			_hitYMax = 60;
			exitMode = EXITMODE_HIDE;
			m_curSelectIndex = -1;
		}
		override public function onReady():void 
		{
			super.onReady();
			setSize(860,575);
			setPanelImageSkin("module/benefithall/rebate/sjbg.png");
			m_exitBtn.setPos(830,27);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			m_gkcontext.m_UIs.rechatge = this;
			
			m_bgAniVec = new Vector.<Ani>();
			for (var i:int = 0; i < 3; i++ )
			{
				var wubg:Panel = new Panel(this, 58 + i * 265, 113);
				wubg.buttonMode = true;
				wubg.addEventListener(MouseEvent.CLICK, linkClick);
				wubg.setPanelImageSkin("module/benefithall/rebate/beingbg.png");
				var bgani:Ani = new Ani(m_gkcontext.m_context);
				wubg.addChild(bgani);
				bgani.x = 106;
				bgani.y = 127;
				bgani.scaleX = 1.30;
				bgani.scaleY = 1.30;
				bgani.centerPlay = true;
				bgani.duration = 1.7;
				bgani.repeatCount = 0;
				bgani.mouseEnabled = false;
				var wupanel:Panel = new Panel(wubg, 0, 0);
				if (i == 0)
				{
					wubg.tag = 0;
					bgani.setImageAni("ejwujiangkabeijinglan.swf");
					wupanel.setPanelImageSkin("module/benefithall/rebate/beinglj.png");
				}
				else if (i == 1)
				{
					wubg.tag = 1;
					bgani.setImageAni("ejwujiangkabeijingzi.swf");
					wupanel.setPanelImageSkin("module/benefithall/rebate/beinglb.png");
				}
				else
				{
					wubg.tag = 2;
					bgani.setImageAni("ejwujiangkabeijingzi.swf");
					wupanel.setPanelImageSkin("module/benefithall/rebate/beinght.png");
				}
				bgani.begin();
				m_bgAniVec.push(bgani);
			}
			
			m_valueBar = new BarInProgress2(this, 140, 392);
			m_valueBar.setSize(581, 11);
			m_valueBar.autoSizeByImage = false;
			m_valueBar.setPanelImageSkin("commoncontrol/panel/barblue.png");
			m_valueBar.maximum = 1;
			//m_valueBar.initValue = 0;
			var barbg:Panel = new Panel(this, 118, 389);
			barbg.setSize(625, 17);
			barbg.setHorizontalImageSkin("commoncontrol/horstretch/progressBg2_mirror.png");
			var node:int = m_gkcontext.m_rechargeRebateMgr.rebateItemList.length;
			var nodeV:int = 581 / node;
			for (i = 0; i < node; i++)
			{
				var num:int = m_gkcontext.m_rechargeRebateMgr.rebateItemList[i].m_numYB;
				var label:Label2 = new Label2(barbg, 10 + nodeV + i * nodeV, -18);
				label.text = num.toString() + "元宝";
				label.letterspace = 1;
				label.setFontColor(UtilColor.GOLD);
				label.x = label.x - num.toString().length*4;
				if (i != (node-1))
				{
					var panel:Panel = new Panel(barbg, 10 + nodeV + i * nodeV, 1);
					panel.setPanelImageSkin("module/benefithall/rebate/barpoint.png");
				}
			}
			label = new Label2(barbg,  0, -18);
			label.text = "0元宝";
			label.letterspace = 1;
			label.setFontColor(UtilColor.GOLD);
			label.x = label.x - 0;
			updataBar();
			
			m_list = new ControlListH(this, 109 + nodeV, 411);
			/**
			 * 横行m_list布局参数
			 */
			var param:ControlHAlignmentParam = new ControlHAlignmentParam();
			param.m_class = SJItemOfHlist;
			/**
			 * 传入每个单元的参数
			 */
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkcontext;
			dataParam["ui"] = this;
			param.m_dataParam = dataParam;
			param.m_intervalH = nodeV;
			param.m_height = 76;
			param.m_widthList = 600;
			m_list.setParam(param);		
			m_list.setDatas(m_gkcontext.m_rechargeRebateMgr.m_rewardList);
			
			m_rewardList = new ControlListH(this, 259, 488);
			/**
			 * 横行m_rewardList布局参数
			 */
			var rewardParam:ControlHAlignmentParam = new ControlHAlignmentParam();
			rewardParam.m_class = SJItemOfReward;
			/**
			 * 传入每个单元的参数
			 */
			var rewardDataParam:Object = new Object();
			rewardDataParam["gk"] = m_gkcontext;
			rewardParam.m_dataParam = rewardDataParam;
			rewardParam.m_intervalH = 62;
			rewardParam.m_height = 76;
			rewardParam.m_widthList = 400;
			m_rewardList.setParam(rewardParam);		
			
			m_btn = new PushButton(this, 622, 509, btnClick);
			m_btn.recycleSkins = true;
			
			m_curYuanbao = new Label2(this, 24, 455);
			m_curYuanbao.letterspace = 1;
			m_curYuanbao.setFontColor(UtilColor.GOLD);
			m_curYuanbao.text = "当前已充值:" + m_gkcontext.m_rechargeRebateMgr.cumulativeYB + "元宝";
			
			m_cumulativePanel = new Panel(this, 22, 484);
			m_cumulativePanel.setPanelImageSkin("module/benefithall/rebate/ybbg.png");
			m_digitYB = new DigitComponent(m_gkcontext.m_context, m_cumulativePanel, 130, 26);
			m_digitYB.align = RIGHT;
			m_digitYB.setParam("commoncontrol/digit/gambledigit", 22, 40);
			
			m_ruleBtn = new ButtonText(this, 24, 430);
			m_ruleBtn.normalColor = UtilColor.YELLOW;
			m_ruleBtn.overColor = UtilColor.GREEN;
			m_ruleBtn.autoAdjustLabelPos = false;
			m_ruleBtn.setSize(60, 20);
			m_ruleBtn.letterSpacing = 1;
			m_ruleBtn.labelComponent.underline = true;
			m_ruleBtn.addEventListener(MouseEvent.MOUSE_OVER, onRuleMouseEnter);
			m_ruleBtn.addEventListener(MouseEvent.MOUSE_OUT, m_gkcontext.hideTipOnMouseOut);
			
			m_jishiqi = new Daojishi(m_gkcontext.m_context);
			m_jishiqi.timeMode = Daojishi.TIMEMODE_1Minute;
			m_jishiqi.funCallBack = TimeUpdate;
			initSJdata();
		}
		/**
		 * 触发定时器动作
		 * @param	d
		 */
		private function TimeUpdate(d:Daojishi):void
		{
			if (m_jishiqi.isStop())
			{
				m_jishiqi.end();
			}
			updataLabel(m_jishiqi.timeSecond);
		}
		/**
		 * 更新倒计时显示面板
		 * @param	time
		 */
		private function updataLabel(time:Number):void
		{
			m_ruleBtn.label = "距离活动结束：" + Math.floor(time / (3600 * 24)) + "天" + Math.floor(time / 3600) % 24 + "小时";
		}
		/**
		 * 初始化送将数据
		 */
		private function initSJdata():void
		{
			m_list.setSeleced(0);
		}
		/**
		 * 活动说明tips
		 * @param	e
		 */
		private function onRuleMouseEnter(e:MouseEvent):void
		{
			UtilHtml.beginCompose();
			UtilHtml.add("活动时间：", UtilColor.YELLOW);
			var str:String = m_gkcontext.m_context.m_timeMgr.calendarToTimeL(m_gkcontext.m_context.m_timeMgr.openservertime).formatString_ymdhms() + " —" +
							m_gkcontext.m_context.m_timeMgr.calendarToTimeL(m_gkcontext.m_context.m_timeMgr.openservertime+RechargeRebateMgr.RECHARGEREBATE_activeTime*24*3600).formatString_ymdhms();
			UtilHtml.add(str, UtilColor.WHITE);
			UtilHtml.breakline();
			UtilHtml.add("活动规则：", UtilColor.YELLOW);
			UtilHtml.add("活动期间内充值有效", UtilColor.WHITE);
			var pt:Point = m_ruleBtn.localToScreen();
			pt.x -= 279;
			m_gkcontext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent(),270);
		}
		/**
		 * 点击武将大图也能打开相应奖励区
		 * @param	e
		 */
		private function linkClick(e:MouseEvent):void
		{
			if (e.currentTarget.tag == 0)
			{
				m_list.setSeleced(2);
			}
			else if (e.currentTarget.tag == 1)
			{
				m_list.setSeleced(4);
			}
			else
			{
				m_list.setSeleced(6);
			}
		}
		/**
		 * 根据奖励序号显示奖励区物品
		 */
		public function openRewardByIndex(index:int,state:int):void
		{
			m_curSelectIndex = index;
			m_rewardList.x = 432 - m_gkcontext.m_rechargeRebateMgr.rebateItemList[index].m_rebateObjList.length * 31;
			m_rewardList.setDatas(m_gkcontext.m_rechargeRebateMgr.rebateItemList[index].m_rebateObjList);
			m_digitYB.digit = m_gkcontext.m_rechargeRebateMgr.rebateItemList[index].m_numYB;
			if (state == 2)
			{
				m_rewardList.becomeGray();
				m_cumulativePanel.becomeGray();
				m_digitYB.becomeGray();
			}
			else
			{
				m_rewardList.becomeUnGray();
				m_cumulativePanel.becomeUnGray();
				m_digitYB.becomeUnGray();
			}
		}
		/**
		 * 更新 充值&领奖
		 */
		public function update(param:Object = null):void 
		{
			m_list.update();
			updataBar();
			m_curYuanbao.text = "当前已充值:" + m_gkcontext.m_rechargeRebateMgr.cumulativeYB+"元宝";
		}
		/**
		 * 领奖按钮
		 */
		private function btnClick(e:MouseEvent):void
		{
			var send:getRechargeBackRewardCmd = new getRechargeBackRewardCmd();
			send.m_index = m_list.selectedIndex;
			m_gkcontext.sendMsg(send);
		}
		/**
		 * 更新进度条长度
		 */
		private function updataBar():void
		{
			var node:int = m_gkcontext.m_rechargeRebateMgr.rebateItemList.length;
			var nextNo:uint = m_gkcontext.m_rechargeRebateMgr.nextRebateid();
			if (nextNo == uint.MAX_VALUE)
			{
				m_valueBar.initValue = 1;
				return;
			}
			var nextYuanbao:int = m_gkcontext.m_rechargeRebateMgr.rebateItemList[nextNo].m_numYB;
			if (nextNo!=0)
			{
				var thisYuanbao:int = m_gkcontext.m_rechargeRebateMgr.rebateItemList[nextNo - 1].m_numYB;
			}
			else
			{
				thisYuanbao = 0;
			}
			m_valueBar.initValue = (nextNo + (nextYuanbao - thisYuanbao - m_gkcontext.m_rechargeRebateMgr.catchYB) / (nextYuanbao - thisYuanbao))/node;
		}
		/**
		 * 帮助子控件获取其位置
		 */
		public function getSJItemIndex(item:SJItemOfHlist):int
		{
			return m_list.findCtrolIndexByData(item.data);
		}
		/**
		 * 设置btn上图片
		 * @param	state
		 */
		public function setBtnState(state:int):void
		{
			if (state == 0)
			{
				m_btn.setSkinButton1Image("module/benefithall/rebate/btnnotcatch.png");
				m_btn.enabled = false;
			}
			else if (state == 1)
			{
				m_btn.setSkinButton1Image("module/benefithall/rebate/btnget.png");
				m_btn.enabled = true;
			}
			else
			{
				m_btn.setSkinButton1Image("module/benefithall/rebate/btnreceived.png");
				m_btn.enabled = false;
			}
			
		}
		override public function onShow():void 
		{
			super.onShow();
			if (m_jishiqi)
			{
				var leftsecond:int = m_gkcontext.m_context.m_timeMgr.openservertime + RechargeRebateMgr.RECHARGEREBATE_activeTime * 24 * 3600 - m_gkcontext.m_context.m_timeMgr.getCalendarTimeSecond();
				if (leftsecond < 0)
				{
					leftsecond=0
				}
				m_jishiqi.initLastTime_Second = leftsecond;
				m_jishiqi.begin();
				m_jishiqi.onTimeUpdate();
			}
		}
		override public function onHide():void 
		{
			if (m_jishiqi)
			{
				m_jishiqi.pause();
			}
			super.onHide();
		}
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.screenBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.screenBtn.getBtnPosInScreen(ScreenBtnMgr.Btn_RechargeRebate);
				if (pt)
				{
					pt.x -= 10;
					return pt;
				}
			}
			return null;
		}
		override public function dispose():void 
		{
			if (m_ruleBtn)
			{
				m_ruleBtn.removeEventListener(MouseEvent.MOUSE_OVER, onRuleMouseEnter);
				m_ruleBtn.removeEventListener(MouseEvent.MOUSE_OUT, m_gkcontext.hideTipOnMouseOut);
			}
			if (m_bgAniVec)
			{
				for each(var item:Ani in m_bgAniVec)
				{
					item.disposeEx();
				}
			}
			if (m_jishiqi)
			{
				m_jishiqi.dispose();
				m_jishiqi = null;
			}
			super.dispose();
		}
	}

}