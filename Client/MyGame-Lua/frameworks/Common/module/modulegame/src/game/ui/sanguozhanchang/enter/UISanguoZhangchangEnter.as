package game.ui.sanguozhanchang.enter 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import com.util.UtilXML;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.net.msg.copyUserCmd.stReqCreateCopyUserCmd;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import time.TimeL;
	import time.UtilTime;
	import com.util.UtilColor;
	import modulecommon.ui.FormStyleEight;
	
	/**
	 * ...
	 * @author ...
	 * 进入界面
	 */
	public class UISanguoZhangchangEnter extends FormStyleEight 
	{
		private var m_enterBtn:PushButton;
		private var m_huodongState:Label;
		private var m_rongyuBtn:PushButton;
		private var m_timesLabel:Label;
		private var m_rightDesc:TextNoScroll;
		public function UISanguoZhangchangEnter() 
		{
			super();
			this.exitMode = EXITMODE_HIDE;			
			timeForTimingClose = 5;
			setAniForm(75);			
		}
		override public function onReady():void 
		{
			super.onReady();
			_hitYMax = 105;
			m_exitBtn.setPos(565,67);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			this.beginWholeImage(608, 500, "commoncontrol/panel/sanguozhanchang/sanguozhanchangbg.png");
			
			var label:Label;
			label = new Label(this, 69, 140, "大量银币", UtilColor.YELLOW); m_bgPart.addDrawCom(label);
			label = new Label(this, 69, 160, "荣誉勋章", UtilColor.YELLOW); m_bgPart.addDrawCom(label);
			
			var left:Number = 46;
			var top:Number = 217;
			var interval:Number = 19;
			label = new Label(this, left, top, "场次：", UtilColor.GREEN); m_bgPart.addDrawCom(label);	top += interval;
			label = new Label(this, left, top, "13:00 ~ 13:20", UtilColor.GREEN); m_bgPart.addDrawCom(label);	top += interval;
			label = new Label(this, left, top, "15:00 ~ 15:20", UtilColor.GREEN); m_bgPart.addDrawCom(label);	top += interval;
			label = new Label(this, left, top, "17:00 ~ 17:20", UtilColor.GREEN); m_bgPart.addDrawCom(label);	top += interval;
			label = new Label(this, left, top, "19:00 ~ 19:20", UtilColor.GREEN); m_bgPart.addDrawCom(label);	top += interval;
			label = new Label(this, left, top, "21:00 ~ 21:20", UtilColor.GREEN); m_bgPart.addDrawCom(label);	top += interval;
			m_timesLabel = new Label(this, left, top, "", UtilColor.WHITE_Yellow); m_bgPart.addDrawCom(label);	top += interval;
			
			var tf:TextNoScroll = new TextNoScroll();
			tf.x = 65;
			tf.y = 410;
			tf.width = 350;
			var str:String = m_gkcontext.m_sanguozhanchangMgr.getRulerDesc();
			if (str)
			{
				tf.setBodyCSS(UtilColor.WHITE_Yellow, 12, 1, 2);
				tf.setBodyHtml(str);				
			}
			m_bgPart.addDrawCom(tf);
			this.endPanelDraw();
			
			m_enterBtn = new PushButton(this, 454, 423,onFunBtnClick);
			m_enterBtn.setSkinButton1Image("commoncontrol/panel/sanguozhanchang/enterbtn.png");	
			
			
			m_huodongState = new Label(this, 260, 110, "", UtilColor.WHITE_Yellow); m_huodongState.mouseEnabled = true;
			m_huodongState.align = Component.CENTER;
			m_huodongState.x = this.width / 2;
			
			m_rongyuBtn = new PushButton(this, 486, 102, onRongyuBtnClick);
			m_rongyuBtn.setSize(76, 76);
			m_rongyuBtn.setSkinButton1Image("screenbtn/rongyushangdian.png");
			m_rongyuBtn.beginLiuguang();
			
			
			m_rightDesc = new TextNoScroll(this, 450, 230);
			m_rightDesc.width = 150;
			m_rightDesc.setBodyCSS(UtilColor.WHITE_Yellow, 12, 1, 8);
			var xml:XML = m_gkcontext.m_commonXML.getItem(5);
			if (xml)
			{
				str = UtilXML.getSubXml(xml, "changcihuafen_desc");
				m_rightDesc.setBodyHtml(str);				
			}
			
			timeForTimingClose = 10;
		}
		override public function onShow():void 
		{
			super.onShow();
			updateState();
			updateTimes();
		}
		
		public function updateState():void
		{
			var iHuodongState:int = -1;
			var date:TimeL = m_gkcontext.m_context.m_timeMgr.getServerTimeL();
			//var date:Date = m_gkcontext.m_timeMgr.date;
			var h:int = date.m_hour;
			
			var str:String;
			if (UtilTime.s_isGreaterOrEqualInDay(date, 13, 0) == false)
			{
				str = "下场时间: 13：00";
			}
			else if (UtilTime.s_isGreaterOrEqualInDay(date, 13, 20) == false)
			{
				str = "活动中。。。";
			}
			else if (UtilTime.s_isGreaterOrEqualInDay(date, 15, 0) == false)
			{
				str = "下场时间: 15：00";
			}
			else if (UtilTime.s_isGreaterOrEqualInDay(date, 15, 20) == false)
			{
				str = "活动中。。。";
			}
			else if (UtilTime.s_isGreaterOrEqualInDay(date, 17, 0) == false)
			{
				str = "下场时间: 17：00";
			}
			else if (UtilTime.s_isGreaterOrEqualInDay(date, 17, 20) == false)
			{
				str = "活动中。。。";
			}
			else if (UtilTime.s_isGreaterOrEqualInDay(date, 19, 0) == false)
			{
				str = "下场时间: 19：00";
			}
			else if (UtilTime.s_isGreaterOrEqualInDay(date, 19, 20) == false)
			{
				str = "活动中。。。";
			}
			else if (UtilTime.s_isGreaterOrEqualInDay(date, 21, 0) == false)
			{
				str = "下场时间: 21：00";
			}
			else if (UtilTime.s_isGreaterOrEqualInDay(date, 21, 20) == false)
			{
				str = "活动中。。。";
			}
			else
			{
				str = "活动结束";
			}
			
			m_huodongState.text = str;
		
		}
		private function onFunBtnClick(event:MouseEvent):void
		{
			var send:stReqCreateCopyUserCmd = new stReqCreateCopyUserCmd();
			send.copyid = stReqCreateCopyUserCmd.COPYID_SanguoZhanchang;
			m_gkcontext.sendMsg(send);
		}
		private function onRongyuBtnClick(e:MouseEvent):void
		{
			m_gkcontext.m_marketMgr.openUIMarket(stMarket.TYPE_Rongyu);
		}
		
		//更新进入次数
		public function updateTimes():void
		{
			m_timesLabel.text = "剩余领奖次数 " + m_gkcontext.m_sanguozhanchangMgr.timesOfReward + "/" + m_gkcontext.m_sanguozhanchangMgr.maxTimes;
		}
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.screenBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.screenBtn.getBtnPosInScreen(ScreenBtnMgr.Btn_Sanguozhanchang);
				if (pt)
				{
					pt.x -= 10;
					pt.y -= 15;
					return pt;
				}
			}
			return null;
		}
	}

}