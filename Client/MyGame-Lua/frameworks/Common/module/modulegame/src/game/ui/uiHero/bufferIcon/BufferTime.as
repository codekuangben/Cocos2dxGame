package game.ui.uiHero.bufferIcon 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.hero.AttrBufferMgr;
	import modulecommon.time.Daojishi;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author ...
	 * 有倒计时的buffer
	 */
	public class BufferTime extends BufferBase
	{
		protected var m_leftTimeLabel:Label;
		protected var m_daojishi:Daojishi;
		protected var m_leftTime:int;
		
		public function BufferTime(gk:GkContext, parent:DisplayObjectContainer)
		{
			super(gk, parent);
			
			m_leftTimeLabel = new Label(this, -1, 25);
			m_leftTimeLabel.setSize(26, 16);
			m_leftTimeLabel.autoSize = false;
			m_leftTimeLabel.align = Component.CENTER;
			m_leftTimeLabel.miaobian = false;
			m_leftTimeLabel.drawRectBG();
			m_leftTimeLabel.graphics.beginFill(0, 0.6);
			m_leftTimeLabel.graphics.drawRoundRect(0, 0, m_leftTimeLabel.width, m_leftTimeLabel.height, 10, 10);
			m_leftTimeLabel.graphics.endFill();
			
			m_daojishi = new Daojishi(m_gkContext.m_context);
		}
		
		//time(时间/秒)
		protected function beginDaojishi(time:int):void
		{
			m_daojishi.funCallBack = updateDaojishi;
			m_daojishi.initLastTime = time * 1000;
			m_daojishi.begin();
		}
		
		private function updateDaojishi(d:Daojishi):void
		{
			if (m_daojishi.isStop())
			{
				m_daojishi.end();
				daojishiEnd();
			}
			
			m_leftTime = d.timeSecond;
			
			var str:String;
			var color:uint = UtilColor.WHITE;
			
			if (m_leftTime >= 3600)
			{
				str = Math.floor(m_leftTime / 3600).toString() + "时";
			}
			else if(m_leftTime >= 60)
			{
				str = Math.floor(m_leftTime / 60).toString() + "分";
			}
			else
			{
				str = m_leftTime.toString() + "秒";
				color = UtilColor.RED;
			}
			
			m_leftTimeLabel.setFontColor(color);
			m_leftTimeLabel.text = str;
		}
		
		protected function daojishiEnd():void
		{
			m_bufferIconPanel.removeBufferIcon(bufferID);
		}
		
		override public function dispose():void
		{
			m_leftTimeLabel.graphics.clear();
			m_daojishi.dispose();
			
			super.dispose();
		}
	}

}