package game.ui.recharge 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelPage;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import com.util.UtilCommon;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import game.ui.uibenefithall.DataBenefitHall;
	import game.ui.uibenefithall.subcom.PageBase;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.GkContext;
	import modulecommon.time.Daojishi;
	import time.UtilTime;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.scene.benefithall.rebate.RechargeRebateMgr;
	
	/**
	 * ...
	 * @author 
	 */
	public class RechargeRebatePage extends PanelPage 
	{
		private var m_list:ControlListVHeight;
		private var m_daojishi:Daojishi;
		private var m_timebg:Panel;
		private var m_timeList:Vector.<DigitComponent>;//剩余时间
		private var m_timetext:TextNoScroll;//活动时间标语
		private var m_gkcontext:GkContext;
		private var m_catchYBText:TextNoScroll;
		private var m_cumulateYBLabel:Label;
		private var m_btnRecharge:PushButton;
		private var m_showNextid:int = -1;
		public function RechargeRebatePage(gk:GkContext, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			/*super(parent, xpos, ypos);
			m_gkcontext = gk;
			this.setPanelImageSkin("module/benefithall/rebate/rebatebg.png");
			
			m_catchYBText = new TextNoScroll();
			m_catchYBText.width = 600;
			var myTextFormat:TextFormat = new TextFormat();
			myTextFormat.bold = true;
			m_catchYBText.defaultTextFormat = myTextFormat;
			updateYBText();
			m_cumulateYBLabel = new Label(this, 662, 177,"",UtilColor.WHITE_Yellow);
			m_cumulateYBLabel.align = Component.RIGHT;
			m_cumulateYBLabel.setBold(true);
			updateYBLabel();
			m_list = new ControlListVHeight(this, 0, 204);
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_class = RechargeRebateItem;
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkcontext;
			//dataParam["parent"] = this;
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
			m_list.setDatas(m_gkcontext.m_rechargeRebateMgr.rebateItemList);
			showNextYB();
			
			m_daojishi = new Daojishi(m_gkcontext.m_context);//倒计时
			m_daojishi.timeMode = Daojishi.TIMEMODE_1Minute;
			m_daojishi.funCallBack = TimeUpdate;
			
			UtilHtml.beginCompose();
			UtilHtml.add("活动时间：", UtilColor.YELLOW);
			var str:String = m_gkcontext.m_context.m_timeMgr.calendarToTimeL(m_gkcontext.m_context.m_timeMgr.openservertime).formatString_ymdhms() + "—" +
							m_gkcontext.m_context.m_timeMgr.calendarToTimeL(UtilTime.s_getDay_0(m_gkcontext.m_context.m_timeMgr.openservertime+RechargeRebateMgr.RECHARGEREBATE_activeTime*24*3600)).formatString_ymdhms();
			UtilHtml.add(str, UtilColor.WHITE);
			UtilHtml.breakline();
			UtilHtml.add("活动规则：", UtilColor.YELLOW);
			UtilHtml.add("活动期间内充值有效", UtilColor.WHITE);
			m_timetext = new TextNoScroll(this, 8,131);
			m_timetext.setMiaobian();
			m_timetext.width = 600;
			m_timetext.setBodyCSS(UtilColor.WHITE, 12,1,6);
			m_timetext.setBodyHtml(UtilHtml.getComposedContent());
		
			
			m_timebg = new Panel(this,8,98);
			m_timebg.setPanelImageSkin("module/benefithall/xianshifangsong/timebg.png");
			m_timeList = new Vector.<DigitComponent>();
			for (var i:uint = 0; i < 3; i++ )
			{
				var score:DigitComponent = new DigitComponent(m_gkcontext.m_context, m_timebg, 0, 3);
				score.align = Component.CENTER;
				score.setParam("commoncontrol/digit/digit02", 13, 25);
				m_timeList.push(score);
			}
			m_timeList[0].x = 136;
			m_timeList[1].x = 212;
			m_timeList[2].x = 300;
			
			m_btnRecharge = new PushButton(this,535, 130, rechargeClick);
			m_btnRecharge.setSkinButton1Image("module/benefithall/rebate/btnrecharge.png");*/
		}
		/*private function rechargeClick(e:MouseEvent):void
		{
			m_gkcontext.m_context.m_platformMgr.openRechargeWeb();
		}
		private function updateYBText():void//更新再充值
		{
			UtilHtml.beginCompose();
			UtilHtml.add("再充值 ", UtilColor.WHITE_Yellow);
			UtilHtml.add(m_gkcontext.m_rechargeRebateMgr.catchYB.toString(), UtilColor.YELLOW);
			UtilHtml.add(" 元宝可领此豪华大礼", UtilColor.WHITE_Yellow);
			m_catchYBText.htmlText = UtilHtml.getComposedContent();
		}
		private function updateYBLabel():void//累计充值更新
		{
			m_cumulateYBLabel.text = "已累计充值:"+m_gkcontext.m_rechargeRebateMgr.cumulativeYB;
		}
		override public function onShow():void 
		{
			super.onShow();
			if (m_daojishi)
			{
				
				var leftTime:Number = UtilTime.s_getDay_0(m_gkcontext.m_context.m_timeMgr.openservertime+RechargeRebateMgr.RECHARGEREBATE_activeTime*24*3600) - m_gkcontext.m_context.m_timeMgr.getCalendarTimeSecond();
				if (leftTime < 0)
				{
					leftTime = 0;
				}
				m_daojishi.initLastTime_Second = leftTime;
				m_daojishi.begin();
				m_daojishi.onTimeUpdate();
			}
		}
		override public function onHide():void 
		{
			m_daojishi.pause();
			super.onHide();
		}
		private function TimeUpdate(d:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_daojishi.end();
			}
			updataLabel(m_daojishi.timeSecond);
		}
		private function updataLabel(time:Number):void
		{
			m_timeList[0].digit = Math.floor(time / (3600 * 24));
			m_timeList[1].digit = Math.floor((time % (3600 * 24)) / 3600);
			m_timeList[2].digit = Math.floor((time % 3600) / 60);
		}
		private function showNextYB():void//这样写是因为控件有个事件冒泡，事件侦听去不掉，所以模仿setselec写了一个这样函数
		{
			var index:uint = m_gkcontext.m_rechargeRebateMgr.nextRebateid();
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
		
		public function updateData(param:Object = null):void 
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
		}*/
	}

}