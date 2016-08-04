package game.ui.recharge 
{
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import com.util.UtilCommon;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.time.Daojishi;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.FormStyleNine;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIRechatge;
	
	/**
	 * 定时充值返利
	 */
	public class UIDTRechatge extends FormStyleNine implements IUIRechatge
	{
		/**
		 * 充值返利格式控制列表 每一条目是RechargeRebateItem
		 */
		private var m_list:ControlListVHeight;
		/**
		 * 活动倒计时
		 */
		private var m_daojishi:Daojishi;
		/**
		 * 剩余时间背景
		 */
		private var m_timebg:Panel;
		/**
		 * 剩余时间
		 */
		private var m_timeList:Vector.<DigitComponent>;
		/**
		 * 活动时间说明
		 */
		private var m_timetext:TextNoScroll;
		/**
		 * "再购买xx元宝可得这些东西"文本
		 */
		private var m_catchYBText:TextNoScroll;
		/**
		 * 累计充值元宝
		 */
		private var m_cumulateYBLabel:Label;
		/**
		 * 充值按钮
		 */
		private var m_btnRecharge:PushButton;
		/**
		 * 显示再充值文本所在条目的序号
		 */
		private var m_showNextid:int = -1;
		public function UIDTRechatge() 
		{
			super();
			this.id = UIFormID.UIDTRechatge;
			setAniForm(75);
			exitMode = EXITMODE_HIDE;
		}
		override public function onReady():void 
		{
			super.onReady();
			beginPanelDrawBg(703, 565);
			endPanelDraw();
			m_gkcontext.m_UIs.dtRechatge = this;
			var bgpanel:Panel = new Panel(this, 18, 37);//背景图片
			bgpanel.setPanelImageSkin("module/benefithall/rebate/rebatebg.png");
			setTitleDraw(282, "module/benefithall/title/rechargerebate.png", null, 94);//标题
			m_catchYBText = new TextNoScroll();
			m_catchYBText.width = 600;
			var myTextFormat:TextFormat = new TextFormat();//文本格式
			myTextFormat.bold = true;
			m_catchYBText.defaultTextFormat = myTextFormat;
			updateYBText();
			m_cumulateYBLabel = new Label(this, 680, 214,"",UtilColor.WHITE_Yellow);
			m_cumulateYBLabel.align = RIGHT;
			m_cumulateYBLabel.setBold(true);
			updateYBLabel();
			m_list = new ControlListVHeight(this, 18, 241);
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();//列表配套格式
			param.m_class = DTRechargeRebateItem;
			var dataParam:Object = new Object();//传递参数
			dataParam["gk"] = m_gkcontext;
			dataParam["Text"] = m_catchYBText;
			param.m_dataParam = dataParam;
			param.m_width = 640;//宽度
			param.m_height = 100;
			param.m_marginLeft = 5;
			param.m_marginRight = 5;
			param.m_heightList = 300;//高度
			param.m_lineSize = param.m_heightList;
			param.m_scrollType = 0;
			param.m_bCreateScrollBar = true;
			m_list.setParam(param);
			m_list.setDatas(m_gkcontext.m_dtRechargeRebateMgr.rebateItemList);
			showNextYB();
			
			m_daojishi = new Daojishi(m_gkcontext.m_context);
			m_daojishi.timeMode = Daojishi.TIMEMODE_1Minute;
			m_daojishi.funCallBack = TimeUpdate;
			
			UtilHtml.beginCompose();
			UtilHtml.add("活动时间：", UtilColor.YELLOW);
			var str:String = m_gkcontext.m_context.m_timeMgr.calendarToTimeL(m_gkcontext.m_dtRechargeRebateMgr.m_bTime).formatString_ymdhms() + "—" +
							m_gkcontext.m_context.m_timeMgr.calendarToTimeL(m_gkcontext.m_dtRechargeRebateMgr.m_bTime + m_gkcontext.m_dtRechargeRebateMgr.m_dTime).formatString_ymdhms();
			UtilHtml.add(str, UtilColor.WHITE);
			UtilHtml.breakline();
			UtilHtml.add("活动规则：", UtilColor.YELLOW);
			UtilHtml.add("活动期间内充值有效", UtilColor.WHITE);
			m_timetext = new TextNoScroll(this, 26,168);
			m_timetext.setMiaobian();
			m_timetext.width = 600;
			m_timetext.setBodyCSS(UtilColor.WHITE, 12, 1, 6);
			m_timetext.setBodyHtml(UtilHtml.getComposedContent());
		
			
			m_timebg = new Panel(this, 26, 135);
			m_timebg.setPanelImageSkin("module/benefithall/xianshifangsong/timebg.png");
			m_timeList = new Vector.<DigitComponent>();
			for (var i:uint = 0; i < 3; i++ )
			{
				var score:DigitComponent = new DigitComponent(m_gkcontext.m_context, m_timebg, 0, 3);
				score.align = CENTER;
				score.setParam("commoncontrol/digit/digit02", 13, 25);
				m_timeList.push(score);
			}
			m_timeList[0].x = 136;
			m_timeList[1].x = 212;
			m_timeList[2].x = 300;
			
			m_btnRecharge = new PushButton(this, 553, 167, rechargeClick);
			m_btnRecharge.setSkinButton1Image("module/benefithall/rebate/btnrecharge.png");
		}
		/**
		 * 接口更新
		 */
		public function update(param:Object = null):void 
		{
			updateSt(param);
		}
		/**
		 * 点击充值按钮事件
		 */
		private function rechargeClick(e:MouseEvent):void
		{
			m_gkcontext.m_context.m_platformMgr.openRechargeWeb();
		}
		/**
		 * 更新再充值
		 */
		private function updateYBText():void
		{
			UtilHtml.beginCompose();
			UtilHtml.add("再充值 ", UtilColor.WHITE_Yellow);
			UtilHtml.add(m_gkcontext.m_dtRechargeRebateMgr.catchYB.toString(), UtilColor.YELLOW);
			UtilHtml.add(" 元宝可领此豪华大礼", UtilColor.WHITE_Yellow);
			m_catchYBText.htmlText = UtilHtml.getComposedContent();
		}
		/**
		 * 累计充值更新
		 */
		private function updateYBLabel():void
		{
			m_cumulateYBLabel.text = "已累计充值:" + m_gkcontext.m_dtRechargeRebateMgr.cumulativeYB;
		}
		override public function onShow():void 
		{
			super.onShow();
			if (m_daojishi)
			{
				
				var leftTime:Number = m_gkcontext.m_dtRechargeRebateMgr.m_bTime + m_gkcontext.m_dtRechargeRebateMgr.m_dTime - m_gkcontext.m_context.m_timeMgr.getCalendarTimeSecond();
				if (leftTime < 0)
				{
					leftTime = 0;
				}
				m_daojishi.initLastTime_Second = leftTime;
				m_daojishi.begin();
				m_daojishi.onTimeUpdate();//立即更新
			}
		}
		override public function onHide():void 
		{
			m_daojishi.pause();
			super.onHide();
		}
		/**
		 * 倒计时每分钟动作
		 */
		private function TimeUpdate(d:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_daojishi.end();
			}
			updataLabel(m_daojishi.timeSecond);
		}
		/**
		 * 时间更新
		 */
		private function updataLabel(time:Number):void
		{
			m_timeList[0].digit = Math.floor(time / (3600 * 24));
			m_timeList[1].digit = Math.floor((time % (3600 * 24)) / 3600);
			m_timeList[2].digit = Math.floor((time % 3600) / 60);
		}
		/**
		 * 显示再充钱给东西文本
		 */
		private function showNextYB():void//这样写是因为ControlListVHeight控件有个事件冒泡，事件侦听去不掉，所以模仿其setselect写了一个这样函数
		{
			var index:uint = m_gkcontext.m_dtRechargeRebateMgr.nextRebateid();
			if (m_showNextid == index)
			{
				return;
			}
			if (m_showNextid >= 0 && m_showNextid < m_list.controlList.length)
			{
				(m_list.controlList[m_showNextid] as RechargeRebateItem).onNotShowNext();
			}
			if (index >= 0 && index < m_list.controlList.length)
			{
				(m_list.controlList[index] as RechargeRebateItem).onShowNext();
			}
			m_showNextid = index;
		}
		/**
		 * 充值&领奖 更新
		 */
		public function updateSt(param:Object = null):void 
		{
			if (param.type == 1)
			{
				showNextYB();
				updateYBLabel();
				updateYBText();
				for (var i:uint = 0; i < m_list.controlList.length; i++ )
				{
					if (UtilCommon.isSetUint((param.state as uint), i))
					{
						(m_list.controlList[i] as RechargeRebateItem).updateNoReceiveBtn();
					}
				}
			}
			else
			{
				(m_list.controlList[param.state] as RechargeRebateItem).updateBtnToReceive();
			}
		}
		override public function dispose():void 
		{
			if (m_daojishi)
			{
				m_daojishi.dispose();
			}
			super.dispose();
		}
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.screenBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.screenBtn.getBtnPosInScreen(ScreenBtnMgr.Btn_DTRechargeRebate);
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