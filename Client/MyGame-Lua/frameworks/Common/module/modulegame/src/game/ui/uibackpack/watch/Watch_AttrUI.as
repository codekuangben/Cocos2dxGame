package game.ui.uibackpack.watch 
{
	import com.bit101.components.Component;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import modulecommon.scene.wu.WuProperty;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class Watch_AttrUI extends PanelContainer 
	{
		private var m_duibiBtn:PushButton
		private var m_attrList:Watch_AttrList;
		private var m_ui:UIWatchPlayer;
		public function Watch_AttrUI(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			super(parent, xpos, ypos);
			m_ui = parent as UIWatchPlayer;
			m_duibiBtn = new PushButton(this, 55, 34, onBtnClick);
			m_duibiBtn.setPanelImageSkin("commoncontrol/button/duibi.swf");
			this.setPanelImageSkin("commoncontrol/panel/watch_back1.png");
			m_attrList = new Watch_AttrList(this, 20, 67, Watch_NameValue);
			
		}
		public function switchToWu(wu:WuProperty):void
		{
			m_attrList.switchToWu(wu);
			if (m_ui.uiWatchSelf)
			{
				m_ui.uiWatchSelf.curWuOfWatch = wu;
			}			
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var selfUI:UIWatchSelfAttr = m_ui.showUIWatchSelf();
			selfUI.curWuOfWatch = m_attrList.wu;
			selfUI.show();
			
		}
	}

}