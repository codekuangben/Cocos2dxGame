package game.ui.market.module.common 
{
	import com.bit101.components.controlList.ControlAlignmentParam_ForPageMode;
	import com.bit101.components.pageturn.PageTurn;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.market.stMarket;
	import game.ui.market.module.CommodityBase;
	/**
	 * ...
	 * @author ...
	 */
	public class YuanBaoPart extends CommonPart 
	{
		
		public function YuanBaoPart(pageTurn:PageTurn, gk:GkContext, market:stMarket, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(pageTurn, gk, parent, xpos, ypos);
			
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkContext;
			dataParam["market"] = market;
			var param:ControlAlignmentParam_ForPageMode = new ControlAlignmentParam_ForPageMode();
			param.m_class = CommonItem;
			param.m_height = 98;
			param.m_width = 204;
			param.m_numColumn = 2;
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
			m_turnPageBtn.x = 193;
			
			m_list.execFun(CommodityBase.s_aniShowOrHid, true);
		}
		
		override public function onHide():void 
		{
			super.onHide();
			m_list.execFun(CommodityBase.s_aniShowOrHid, false);
		}
		
		override public function onUIMarketShow():void
		{
			m_list.execFun(CommodityBase.s_aniShowOrHid, true);			
		}
		override public function onUIMarketHide():void
		{
			m_list.execFun(CommodityBase.s_aniShowOrHid, false);			
		}
	}

}