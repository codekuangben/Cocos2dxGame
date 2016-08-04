package game.ui.uibackpack.wujiang 
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.appcontrol.WuIcon;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneHeroCmd.ActiveHero;
	import modulecommon.scene.wu.WuHeroProperty;
	import com.bit101.components.Panel;
	/**
	 * ...
	 * @author 
	 */
	public class WuCardBase extends Component 
	{
		protected var m_gkContext:GkContext;
		protected var m_wuMain:WuHeroProperty;			
		protected var m_wuRP:WuRelationPanelBase;
		protected var m_cardPanel:WuIcon;
		protected var m_activeHero:ActiveHero;
		public function WuCardBase(wurp:WuRelationPanelBase, gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			m_wuRP = wurp;
			m_gkContext = gk;
			super(parent, xpos, ypos);
			m_cardPanel = new WuIcon(m_gkContext, this);
			m_cardPanel.showFrame = false;
			addEventListener(MouseEvent.ROLL_OUT, onActiveHeroMouseOut);
			addEventListener(MouseEvent.ROLL_OVER, onActiveHeroMouseOver);
		}
		public function setIDs(wu:WuHeroProperty, activeHero:ActiveHero):void
		{
			m_wuMain = wu;			
			m_activeHero = activeHero;		
			m_cardPanel.setIconNameByTableID(m_activeHero.tableID);		
			
		}
		public function get wutableIDCard():uint
		{
			return m_activeHero.tableID;
		}
		protected function onActiveHeroMouseOut(event:MouseEvent):void
		{			
			m_gkContext.m_wuMgr.hideWuMouseOverPanel(this);
			if (!m_gkContext.m_newHandMgr.isVisible())
			{
				m_gkContext.m_uiTip.hideTip();
			}
		}
		
		protected function onActiveHeroMouseOver(event:MouseEvent):void
		{			
			m_gkContext.m_wuMgr.showWuMouseOverPanel(this);
			if (!m_gkContext.m_newHandMgr.isVisible())
			{
				var localP:Point = new Point(m_cardPanel.width, 0);
				var pt:Point = this.localToScreen(localP);				
				
				m_gkContext.m_uiTip.hintActiveWu_watch(pt, m_wuMain.m_uHeroID, m_activeHero.tableID,m_activeHero.bOwned);		
			}
		}
	}

}