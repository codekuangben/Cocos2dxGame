package game.ui.uibackpack.wujiang 
{
	import com.bit101.components.Component;
	import modulecommon.GkContext;
	import modulecommon.scene.wu.WuHeroProperty;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import modulecommon.scene.wu.WuProperty;
	/**
	 * ...
	 * @author 
	 */
	public class WuRelationPanelBase extends Component 
	{
		protected var m_gkContext:GkContext;
		protected var m_wu:WuHeroProperty;
		protected var m_cardParent:Panel;
		
		public function WuRelationPanelBase(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			m_gkContext = gk;
			super(parent, xpos, ypos);
			m_cardParent = new Panel(this);			
		}
		
	}

}