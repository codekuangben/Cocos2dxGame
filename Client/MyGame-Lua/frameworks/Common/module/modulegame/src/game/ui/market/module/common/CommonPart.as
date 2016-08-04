package game.ui.market.module.common 
{
	import com.bit101.components.controlList.ControlAlignmentParam_ForPageMode;
	import com.bit101.components.controlList.ControlList;
	import com.bit101.components.pageturn.PageTurn;
	import com.bit101.components.PanelShowAndHide;
	import flash.display.DisplayObjectContainer;

	import modulecommon.GkContext;
	import modulecommon.scene.market.stMarket;
	/**
	 * ...
	 * @author ...
	 */
	public class CommonPart extends PanelShowAndHide 
	{
		public var m_turnPageBtn:PageTurn;
		public var m_list:ControlList;
		public var m_gkContext:GkContext;
		public function CommonPart(pageTurn:PageTurn, gk:GkContext, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);			
			m_gkContext = gk;
			m_turnPageBtn = pageTurn;
			m_list = new ControlList(this);	
			m_list.bInitSubCtrlOnShow = true;
		}
		
		private function onPageTurn(pre:Boolean):void
		{
			if (pre)
			{
				m_list.toPreLine();
			}
			else
			{
				m_list.toNextLine();
			}
		}
		
		override public function onShow():void
		{
			m_turnPageBtn.setParam(onPageTurn);			
			m_turnPageBtn.pageCount = m_list.pageCount;
			m_turnPageBtn.curPage = m_list.curPage;			
		}
		
		public function onUIMarketShow():void
		{
			
		}
		
		public function onUIMarketHide():void
		{
			
		}
		public function update():void
		{
			m_list.update();
		}
	}

}