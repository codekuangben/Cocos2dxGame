package game.ui.collectProgress 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.progressbar.progressAni.ProgressAni;
	import com.bit101.progressbar.progressbarClass1.ProgressBarClass1;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class UICollectProgress extends Form 
	{
		private var m_progressAni:ProgressAni;
		private var m_title:Label;
		private var m_type:int;
		public function UICollectProgress() 
		{
			super();		
			id = UIFormID.UICollectProgress;
			this.alignVertial = Component.BOTTOM;
			marginBottom = 220;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.exitMode = EXITMODE_HIDE;
		}
		
		override public function onReady():void
		{
			super.onReady();
			var pb:ProgressBarClass1 = new ProgressBarClass1();
			m_progressAni = new ProgressAni(this);
			m_progressAni.setParam(1.2, onProgressComplete, pb);
			
			m_title = new Label(this, 110, -25, "", UtilColor.GREEN);
			this.setSize(m_progressAni.width,m_progressAni.height);
		}
		
		public function process_notifyBeginPlayProgressUserCmd(rev:notifyBeginPlayProgressUserCmd):void
		{
			m_type = rev.m_type;
			var title:String = "";
			if (m_type == notifyBeginPlayProgressUserCmd.PROCESS_RESROB)
			{
				title = "采集中...";
			}
			else if (m_type == notifyBeginPlayProgressUserCmd.PROCESS_CORPSTREASURE)
			{
				title = "拾取中...";
			}
			m_title.text = title;
			begin()
		}
		private function begin():void
		{
			m_progressAni.begin();
			this.show();
		}
		override public function onHide():void 
		{
			super.onHide();
			m_progressAni.stop();
		}
		private function onProgressComplete():void
		{
			var send:reqEndPlayProgressUserCmd = new reqEndPlayProgressUserCmd();
			send.m_type = m_type;
			m_gkcontext.sendMsg(send);
			this.exit();
		}		
	}

}