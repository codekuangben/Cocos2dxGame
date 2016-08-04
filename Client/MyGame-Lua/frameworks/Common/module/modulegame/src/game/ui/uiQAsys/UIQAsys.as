package game.ui.uiQAsys
{
	import com.ani.AniPropertys;
	import com.bit101.components.Ani;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.TextNoScroll;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import game.ui.uiQAsys.msg.stAnswerQuestionCmd;
	import game.ui.uiQAsys.msg.stRetQuestionInfoCmd;
	import modulecommon.time.Daojishi;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.FormStyleExitBtn
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author 
	 */
	public class UIQAsys extends FormStyleExitBtn 
	{
		private var m_serialNumberLabel:Label;
		private var m_questionText:TextNoScroll;
		private var m_answers:AnswersList;
		private var m_resultWordPanel:Panel;
		private var m_resultWordAni:AniPropertys;
		private var m_resultBgPanel:Panel;
		private var m_resultBgAni:AniPropertys;
		private var m_daojishi:Daojishi;
		private var m_aniend:Boolean;
		public function UIQAsys() 
		{
			super();
			id = UIFormID.UIQAsys;
			setSize(450, 406);
			_hitYMax = 100;
			m_exitBtn.setPos(396,69);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			setPanelImageSkin("commoncontrol/panel/qasys/qabg.png");
			exitMode = EXITMODE_HIDE;
			setFade();
		}
		override public function onReady():void 
		{
			super.onReady();
			m_serialNumberLabel = new Label(this, 64, 135, "", UtilColor.WHITE_Yellow,14);
			m_questionText = new TextNoScroll(this, 89, 132);
			var textFormat:TextFormat = new TextFormat();
			textFormat.leading = 4;
			textFormat.letterSpacing = 1;
			m_questionText.defaultTextFormat = textFormat;
			m_questionText.setFont(UtilColor.WHITE_Yellow, 14);;
			m_questionText.width = 300;
			m_answers = new AnswersList(this, 60, 212);
			
			m_resultBgPanel = new Panel(this);
			m_resultBgAni = new AniPropertys()
			m_resultBgAni.repeatCount = 1;
			m_resultBgAni.duration = 0.25;
			m_resultBgAni.onEnd = onAniEnd;
			m_resultBgAni.sprite = m_resultBgPanel;
			m_resultBgAni.resetValues( { alpha:1, x: 177, y:223, scaleX:1, scaleY:1 } );
			
			m_resultWordPanel = new Panel(this);
			m_resultWordAni = new AniPropertys()
			m_resultWordAni.repeatCount = 1;
			m_resultWordAni.duration = 0.25;
			m_resultWordAni.onEnd = onAniEnd;
			m_resultWordAni.sprite = m_resultWordPanel;
			m_resultWordAni.resetValues( { alpha:1, x: 221, y:228, scaleX:1, scaleY:1 } );
			
			m_daojishi = new Daojishi(m_gkcontext.m_context);
			m_daojishi.initLastTime_Second = 2;
			m_daojishi.funCallBack = onDaojishiEnd;
		}
		override public function onShow():void 
		{
			super.onShow();
			m_resultBgPanel.x = 285;
			m_resultBgPanel.y = 272;
			m_resultBgPanel.alpha = 0;
			m_resultBgPanel.scaleX = 0;
			m_resultBgPanel.scaleY = 0;
			m_resultWordPanel.x = 365;
			m_resultWordPanel.y = 113;
			m_resultWordPanel.alpha = 0;
			m_resultWordPanel.scaleX = 3;
			m_resultWordPanel.scaleY = 3;
			if (m_daojishi)
			{
				m_daojishi.end();
			}
		}
		public function process_stRetQuestionInfoCmd(msg:ByteArray):void//收到答题内容消息
		{
			var rev:stRetQuestionInfoCmd = new stRetQuestionInfoCmd();
			rev.deserialize(msg);
			onShow();
			m_serialNumberLabel.text = rev.m_num + ". ";
			m_questionText.text =rev.m_question;
			m_answers.setdata(rev.m_answersList);
		}
		public function result(isright:Boolean):void//玩家选择后
		{
			var send:stAnswerQuestionCmd = new stAnswerQuestionCmd();
			if (isright)
			{
				send.m_result = 1;
				m_resultBgPanel.setPanelImageSkin("commoncontrol/panel/qasys/bluebg.png");
				m_resultWordPanel.setPanelImageSkin("commoncontrol/panel/qasys/right.png");
			}
			else
			{
				send.m_result = 0;
				m_resultBgPanel.setPanelImageSkin("commoncontrol/panel/qasys/redbg.png");
				m_resultWordPanel.setPanelImageSkin("commoncontrol/panel/qasys/error.png");
			}
			m_aniend = false;
			m_resultBgAni.begin();
			m_resultWordAni.begin();
			m_gkcontext.sendMsg(send);
		}
		private function onAniEnd():void//判正动画结束开启倒计时准备关闭界面
		{
			if (m_aniend)
			{
				m_daojishi.begin();
			}
			else
			{
				m_aniend = true;
			}
		}
		private function onDaojishiEnd(e:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_daojishi.end();
				this.exit();
			}
		}
		override public function dispose():void 
		{
			if (m_daojishi)
			{
				m_daojishi.dispose();
			}
			if (m_resultBgAni)
			{
				m_resultBgAni.dispose();
			}
			if (m_resultWordAni)
			{
				m_resultWordAni.dispose();
			}
			super.dispose();
		}
		
	}

}