package game.ui.uiHero.bufferIcon 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.GkContext;
	import modulecommon.scene.hero.AttrBufferMgr;
	/**
	 * ...
	 * @author ...
	 */
	public class BufferBase extends Component
	{
		protected var m_gkContext:GkContext;
		protected var m_bufferIconPanel:BufferIconPanel;
		protected var m_bufferID:uint;
		protected var m_iconPanel:Panel;
		protected var m_type:int;
		
		public function BufferBase(gk:GkContext, parent:DisplayObjectContainer = null)
		{
			super(parent);
			m_gkContext = gk;
			m_bufferIconPanel = parent as BufferIconPanel;
			
			m_iconPanel = new Panel(this, 0, 0);
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		public function initData(id:uint, icon:String = null, type:int = 0):void
		{
			m_bufferID = id;
			m_type = type;
			m_iconPanel.setPanelImageSkin(AttrBufferMgr.getBufferIconPath(icon));
		}
		
		public function get bufferID():uint
		{
			return m_bufferID;
		}
		
		public function get type():int
		{
			return m_type;
		}
		
		protected function onRollOver(event:MouseEvent):void
		{
			
		}
		
		protected function onRollOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
		}
	}

}