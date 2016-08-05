package modulecommon.ui 
{
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class FormStyleExitBtn extends Form 
	{
		protected var m_exitBtn:PushButton;
		public function FormStyleExitBtn() 
		{
			super();
			m_exitBtn = new PushButton(this,0,4);
			m_exitBtn.m_musicType = PushButton.BNMClose;
			//m_exitBtn.setPanelImageSkin("commoncontrol/button/exitbtn.swf");
			m_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
		}
		override public function dispose():void
		{
			if (m_exitBtn)
			{
				m_exitBtn.removeEventListener(MouseEvent.CLICK, onExitBtnClick);
			}
			super.dispose();
		}
	}

}