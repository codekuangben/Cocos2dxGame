package game.ui.market.corps 
{
	import com.bit101.components.controlList.ControlAlignmentParam_ForPageMode;
	import com.bit101.components.pageturn.PageTurn;
	import flash.display.DisplayObjectContainer;
	import game.ui.market.module.common.CommonPart;
	import modulecommon.GkContext;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.market.stMarketBaseObj;
	/**
	 * ...
	 * @author 
	 */
	public class CorpsPart extends CommonPart 
	{
		private var m_curCorpsLevel:int;
		private var m_market:stMarket;
		public function CorpsPart(pageTurn:PageTurn, gk:GkContext, market:stMarket, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(pageTurn, gk, parent, xpos, ypos);
			
			m_market = market;
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkContext;
			dataParam["market"] = market;
			var param:ControlAlignmentParam_ForPageMode = new ControlAlignmentParam_ForPageMode();
			param.m_class = CorpsCommodity;
			param.m_height = 98;
			param.m_width = 204;
			param.m_numColumn = 3;
			param.m_numRow = 3;
			param.m_intervalV = 10;
			param.m_intervalH = 11;
			param.m_marginLeft = 10;
			param.m_marginRight = 10;
			param.m_dataParam = dataParam;
			m_list.setParamForPageMode(param);
			m_list.bInitSubCtrlOnShow = true;
			updateList();		
		}
		
		public function updateList():void
		{
			if (m_gkContext.m_corpsMgr.m_corpsInfo.level == m_curCorpsLevel)
			{
				return;
			}
			m_curCorpsLevel = m_gkContext.m_corpsMgr.m_corpsInfo.level;
			
			m_market.m_list.sort(compare);
			m_list.setDatas(m_market.m_list);
		}
		
		public function compare(a:stMarketBaseObj, b:stMarketBaseObj):int
		{
			if (a.state == m_curCorpsLevel + 1)
			{
				return -1;
			}
			if (b.state == m_curCorpsLevel + 1)
			{
				return 1;
			}
			
			if (a.state <= m_curCorpsLevel)
			{
				if (b.state > m_curCorpsLevel)
				{
					return -1;
				}
				return a.state >= b.state? -1:1;
			}
			
			if (b.state <= m_curCorpsLevel)
			{
				return 1;
			}
			
			return a.state <= b.state ? -1:1;	
		}
		
	}

}