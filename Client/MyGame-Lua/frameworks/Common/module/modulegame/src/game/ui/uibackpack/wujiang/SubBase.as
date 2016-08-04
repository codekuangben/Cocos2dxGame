package game.ui.uibackpack.wujiang 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	public class SubBase  extends Component 
	{
		protected var m_allWu:AllWuPanel;
		protected var m_wu:WuProperty;		
		protected var m_gkContext:GkContext;
		protected var m_wuPanel:WuPanel;
		private var m_parent:DisplayObjectContainer;
		public function SubBase(allPanel:AllWuPanel, parent:DisplayObjectContainer, gk:GkContext)
		{
			m_allWu = allPanel;
			m_gkContext = gk;
			m_wuPanel = parent as WuPanel;
			m_parent = parent;
		}		
		
		public function show():void
		{
			if (this.parent != m_parent)
			{
				m_parent.addChild(this);
				onShow();
			}
		}
		
		override public function isVisible():Boolean 
		{
			return this.parent != null;
		}
		
		public function hide():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function onShow():void
		{
			
		}
		public function update():void
		{
			
		}
		public function onShowThisWu():void
		{
			
		}
		public function onUIBackPackShow():void
		{
			
		}
	}

}