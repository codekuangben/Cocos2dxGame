package game.ui.sanguozhanchang.sanguoZhanchangRelive 
{
	import com.bit101.components.Label;
	import modulecommon.time.Daojishi;
	import com.util.UtilColor;
	import com.util.UtilTools;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import game.netmsg.stResRobCmd.reqReliveUserCmd;
	
	/**
	 * ...
	 * @author ...
	 */
	public class UISanguoZhanchangRelive extends Form 
	{
		private var m_daojishi:Daojishi;
		private var m_timeLabel:Label;
		
		public function UISanguoZhanchangRelive() 
		{
			super();
			this.alignVertial = BOTTOM;
			marginBottom = 100;
			this.id = UIFormID.UISanguoZhanchangRelive;
			this.draggable = false;
			
		}
		override public function onReady():void 
		{
			super.onReady();
			
			m_daojishi = new Daojishi(m_gkcontext.m_context);
			m_daojishi.funCallBack = timeUpdate;
			
			var label:Label = new Label(this, 37, 32, "等待复活时间", UtilColor.YELLOW, 14);
			m_timeLabel = new Label(this, label.x+100, 32, "", UtilColor.YELLOW, 16);
			m_timeLabel.setBold(true);
			this.setSize(234,79);
			setPanelImageSkin("commoncontrol/panel/task/yugaobg.png");
		}
		
		override public function dispose():void 
		{
			m_daojishi.dispose();
			super.dispose();
		}
		
		private function timeUpdate(d:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_daojishi.end();
				var send:reqReliveUserCmd = new reqReliveUserCmd();
				m_gkcontext.sendMsg(send);
				this.exit();
				return;
			}
			var str:String = UtilTools.formatTimeToString(m_daojishi.timeSecond, false);
			m_timeLabel.text = str;
		}
		
		override public function updateData(param:Object = null):void 
		{
			begin();
		}
		public function begin():void
		{
			m_daojishi.initLastTime = 45 * 1000;
			m_daojishi.begin();
			show();
		}
	}

}