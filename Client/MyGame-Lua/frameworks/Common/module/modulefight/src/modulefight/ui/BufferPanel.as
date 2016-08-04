package modulefight.ui 
{
	import com.bit101.components.PanelContainer;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulefight.netmsg.stmsg.stEntryState;
	import flash.events.MouseEvent;
	import modulefight.scene.fight.FightDB;
	import modulefight.ui.tip.UIBattleTip;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BufferPanel extends PanelContainer 
	{
		private var m_gkContext:GkContext;
		private var m_fightDB:FightDB;
		private var m_icon:BuffIcon;
		private var m_bufferState:stEntryState;
		public function BufferPanel(gk:GkContext,fightDB:FightDB) 
		{
			m_gkContext = gk;
			m_fightDB = fightDB
			m_icon = new BuffIcon(gk);
			this.addChild(m_icon);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		public function setBufferState(state:stEntryState):void
		{
			m_bufferState = state;
			m_icon.setIconPath(state.base.icon_id.toString());
		}
		public function get bufferState():stEntryState
		{
			return m_bufferState;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			var tip:UIBattleTip = (m_fightDB.m_fightControl.getUIBattleTip() as UIBattleTip);
			if (tip)
			{
				tip.hideTip();
			}			
		}
		protected function onMouseOver(event:MouseEvent):void
		{			
			var pt:Point = this.localToScreen(new Point(45, 45));			
					
			(m_fightDB.m_fightControl.getUIBattleTip() as UIBattleTip).showTipBuffer(pt, m_bufferState);			
				
		}
	
	}

}