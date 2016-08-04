package game.ui.uicorpsduobao.enter 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextNoScroll;
	import com.util.UtilColor;
	import com.util.UtilXML;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.ui.FormStyleEight;
	import time.TimeL;
	import time.UtilTime;
	/**
	 * ...
	 * @author ...
	 * 军团夺宝—进入界面
	 */
	public class UICorpsTreasureEnter extends FormStyleEight
	{
		private var m_enterBtn:PushButton;
		private var m_huodongState:Label;
		private var m_rewardsStr:String;
		private var m_acttimesStr:String;
		private var m_ruleStr:String;
		
		public function UICorpsTreasureEnter() 
		{
			super();
			this.exitMode = EXITMODE_HIDE;
			timeForTimingClose = 5;
			setAniForm(75);
		}
		
		override public function onReady():void
		{
			super.onReady();
			
			_hitYMax = 90;
			m_exitBtn.setPos(552,67);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			
			var xml:XML = m_gkcontext.m_commonXML.getItem(11);
			if (xml)
			{
				m_rewardsStr = UtilXML.getSubXml(xml, "rewards_desc");
				m_acttimesStr = UtilXML.getSubXml(xml, "acttimes_desc");
				m_ruleStr = UtilXML.getSubXml(xml, "rule_desc");
			}
			
			this.beginWholeImage(582, 486, "commoncontrol/panel/juntuanduobao/enterbg.png");
			
			var tf:TextNoScroll;
			
			//奖励说明
			tf = new TextNoScroll();
			tf.x = 55;
			tf.y = 140;
			tf.width = 120;
			if (m_rewardsStr)
			{
				tf.setBodyCSS(UtilColor.YELLOW, 12, 2, 6);
				tf.setBodyHtml(m_rewardsStr);
			}
			m_bgPart.addDrawCom(tf);
			
			//活动时间
			tf = new TextNoScroll();
			tf.x = 30;
			tf.y = 245;
			tf.width = 120;
			if (m_acttimesStr)
			{
				tf.setBodyCSS(UtilColor.YELLOW, 12, 2, 8);
				tf.setBodyHtml(m_acttimesStr);
			}
			m_bgPart.addDrawCom(tf);
			
			//规则说明
			tf = new TextNoScroll();
			tf.x = 40;
			tf.y = 408;
			tf.width = 450;
			if (m_ruleStr)
			{
				tf.setBodyCSS(UtilColor.WHITE_Yellow, 12, 1, 2);
				tf.setBodyHtml(m_ruleStr);
			}
			m_bgPart.addDrawCom(tf);
			
			this.endPanelDraw();
			
			m_huodongState = new Label(this, this.width/2, 110, "", UtilColor.WHITE_Yellow); m_huodongState.mouseEnabled = true;
			m_huodongState.align = Component.CENTER;
			
			m_enterBtn = new PushButton(this, 450, 422, onEnterBtnClick);
			m_enterBtn.setSkinButton1Image("commoncontrol/panel/sanguozhanchang/enterbtn.png");	
		}
		
		override public function onShow():void 
		{
			super.onShow();
			
			updateState();
		}
		
		public function updateState():void
		{
			var date:TimeL = m_gkcontext.m_context.m_timeMgr.getServerTimeL();
			var str:String;
			
			if (UtilTime.s_isGreaterOrEqualInDay(date, 20, 30) == false)
			{
				str = "活动未开始";
			}
			else if (UtilTime.s_isGreaterOrEqualInDay(date, 20, 55) == false)
			{
				str = "活动中。。。";
			}
			else
			{
				str = "活动结束";
			}
			
			m_huodongState.text = str;
		}
		
		private function onEnterBtnClick(event:MouseEvent):void
		{
			//请求进入军团夺宝
			m_gkcontext.m_CorpsDuobaoMgr.reqIntoCorpsTreasure();
		}
		
		override public function getDestPosForHide():Point 
		{
			if (m_gkcontext.m_UIs.screenBtn)
			{
				var pt:Point = m_gkcontext.m_UIs.screenBtn.getBtnPosInScreen(ScreenBtnMgr.Btn_CorpsTreasure);
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