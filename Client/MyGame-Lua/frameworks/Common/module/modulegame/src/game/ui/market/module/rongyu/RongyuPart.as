package game.ui.market.module.rongyu 
{
	import com.bit101.components.controlList.ControlAlignmentParam_ForPageMode;
	import com.bit101.components.pageturn.PageTurn;
	import flash.display.DisplayObjectContainer;
	import game.ui.market.module.common.CommonPart;
	import modulecommon.GkContext;
	import modulecommon.scene.market.stMarket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RongyuPart extends CommonPart 
	{
		
		public function RongyuPart(pageTurn:PageTurn, gk:GkContext, market:stMarket, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(pageTurn, gk, parent, xpos, ypos);
			
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkContext;
			dataParam["market"] = market;
			var param:ControlAlignmentParam_ForPageMode = new ControlAlignmentParam_ForPageMode();
			param.m_class = RongyuCommodity;
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
			
			m_list.setDatas(market.m_list);		
		}
		override public function onShow():void
		{
			super.onShow();
			m_turnPageBtn.x = 300;
			//m_turnPageBtn.setBtnPos(0, 0, 75, 0, 0, 18);		
			
		}
	}

}