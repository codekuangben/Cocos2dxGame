package game.ui.market.module.timeLimt 
{
	import com.bit101.components.PanelShowAndHide;
	import com.pblabs.engine.core.ITimeUpdateObject;
	import flash.display.DisplayObjectContainer;
	import game.ui.market.module.CommodityBase;
	import modulecommon.GkContext;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.market.stMarketOnSaleObj;
	import modulecommon.time.Daojishi;
	
	import com.bit101.components.controlList.ControlAlignmentParam_ForPageMode;
	import com.bit101.components.controlList.ControlList;
	import com.bit101.components.pageturn.PageTurn;
	/**
	 * ...
	 * @author ...
	 */
	public class TimeLimitPart extends PanelShowAndHide implements ITimeUpdateObject
	{		
		private var m_market:stMarket;
		private var m_list:ControlList;
		private var m_gkContext:GkContext;
		private var m_turnPageBtn:PageTurn;
		private var m_daojishi:Daojishi;
		private var m_curList:Array;
		public function TimeLimitPart(gk:GkContext, market:stMarket, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_market = market;
			
			m_daojishi = new Daojishi(m_gkContext.m_context);
			
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkContext;
			m_list = new ControlList(this, 8,40);
			var param:ControlAlignmentParam_ForPageMode = new ControlAlignmentParam_ForPageMode();
			param.m_class = TimeLimitCommodity;
			param.m_height = 111;
			param.m_marginLeft = 10;
			param.m_marginRight = 10;
			param.m_width = 198;
			param.m_numColumn = 1;
			param.m_numRow = 3;
			param.m_intervalV = 6;		
			param.m_dataParam = dataParam;
			m_list.setParamForPageMode(param);
			m_list.bInitSubCtrlOnShow = true;
			
			m_turnPageBtn = new PageTurn(this, 70, 403);			
			m_turnPageBtn.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			m_turnPageBtn.setBtnPos(0, 0, 75, 0, 0, 18);
			m_turnPageBtn.setParam(onPageTurn);
			updateList();
		}
		
		private function updateList():void
		{
			var curTime:uint = m_gkContext.m_context.m_timeMgr.getCalendarTimeSecond();
			var item:stMarketOnSaleObj;
			var newList:Array = new Array();
			for each(item in m_market.m_list)
			{
				if (curTime >= item.starttime && curTime < item.endtime)
				{
					newList.push(item);
				}
			}
			var bUpdate:Boolean = false;
			if (m_curList == null)
			{
				bUpdate = true;
			}
			else
			{
				if (m_curList.length != newList.length)
				{
					bUpdate = true;
				}
				else
				{
					var i:int;
					for (i = 0; i < m_curList.length; i++)
					{
						if (m_curList[i] != newList[i])
						{
							bUpdate = true;
							break;
						}
					}
				}
			}		
			
			if (bUpdate)
			{
				m_curList = newList;
				m_list.setDatas(m_curList);
				m_turnPageBtn.pageCount = m_list.pageCount;
				m_turnPageBtn.curPage = m_list.curPage;
			}
		}
		
		public function onUIMarketShow():void
		{
			m_list.execFun(CommodityBase.s_aniShowOrHid, true);
			this.m_gkContext.m_context.m_processManager.add1MinuteUpateObject(this);
		}
		
		public function onUIMarketHide():void
		{
			m_list.execFun(CommodityBase.s_aniShowOrHid, false);
			this.m_gkContext.m_context.m_processManager.remove1MinuteUpateObject(this);
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
		public function update():void
		{
			m_list.update();
		}
		public function onTimeUpdate():void
		{
			updateList();
			m_list.update();
		}
		
	}

}