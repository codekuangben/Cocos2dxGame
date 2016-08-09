package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import com.util.UtilTools;
	/**
	 * ...
	 * @author ...
	 */
	public class CoolDownControl extends Component 
	{
		private var m_bg:Panel;
		private var m_wordShenjiLengque:Panel;
		private var m_timeLabel:Label;
		private var m_funBtn:PushButton;
		private var m_funSpeedUpCallBack:Function;
		public function CoolDownControl(bShowBg:Boolean, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);		
			if (bShowBg)
			{
				m_bg = new Panel(this, -25,-20);
				m_bg.setPanelImageSkin("commoncontrol/panel/corps/shengjilengquebg.png");
			}
			m_wordShenjiLengque = new Panel(this);
			m_wordShenjiLengque.setPanelImageSkin("commoncontrol/panel/corps/word_shengjilengque.png");
			m_timeLabel = new Label(this, 77, 3);
			m_funBtn = new PushButton(this, 141, 2, onfunBtn);
			m_funBtn.setPanelImageSkin("commoncontrol/button/timeSpeedBtn.swf");
		}
		
		private function onfunBtn(event:MouseEvent):void
		{
			m_funSpeedUpCallBack();
		}
		override public function dispose():void 
		{
			m_funSpeedUpCallBack = null;
			super.dispose();
		}
		
		public function set funSpeedUpCallBack(fun:Function):void
		{
			m_funSpeedUpCallBack = fun;
		}
		
		//设置剩余时间，单位：秒
		public function set remainTime(t:int):void
		{
			m_timeLabel.text = UtilTools.formatTimeToString(t);
		}
		
	}

}