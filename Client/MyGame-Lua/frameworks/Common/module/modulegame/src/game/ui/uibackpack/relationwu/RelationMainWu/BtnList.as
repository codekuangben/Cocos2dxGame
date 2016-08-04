package game.ui.uibackpack.relationwu.RelationMainWu 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.pageturn.PageTurn;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author ...
	 * "我的三国关系"——关系项列表
	 */
	public class BtnList extends Component
	{
		private var m_gkContext:GkContext;
		private var m_relationMainWuPanel:RelationMainWuPanel;
		private var m_list:ControlListVHeight;
		private var m_param:Object;
		private var m_pageTurn:PageTurn;
		private var m_btnLight:PanelDisposeEx;
		
		public function BtnList(gk:GkContext, parentPanel:RelationMainWuPanel, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_relationMainWuPanel = parentPanel;
			
			m_list = new ControlListVHeight(this, 6, 3);
			
			m_btnLight = new PanelDisposeEx();
			m_btnLight.setPos( -13, -13);
			m_btnLight.setPanelImageSkin("commoncontrol/panel/backpack/mainwurelation/btnlight.png");
			m_btnLight.mouseEnabled = false;
			
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			m_param = new Object();
			m_param["gk"] = m_gkContext;
			m_param["btnlist"] = this;
			m_param["lightpanel"] = m_btnLight;
			
			param.m_class = BtnItem;
			param.m_marginBottom = 6;
			param.m_marginLeft = 5;
			param.m_marginRight = 5;
			param.m_marginTop = 2;
			param.m_intervalV = 6;
			param.m_width = 103;
			param.m_heightList = param.m_marginTop + param.m_marginBottom + 36 + (36 + param.m_intervalV) * 10;
			param.m_lineSize = param.m_heightList;
			param.m_scrollType = 1;
			param.m_dataParam = m_param;
			
			m_list.setParam(param);
			m_list.bInitSubCtrlOnShow = true;
			m_list.addEventListener(Event.SELECT, onBtnSelected);
			
			m_pageTurn = new PageTurn(this, 30, 460);
			m_pageTurn.setBtnPos(0, 0, 60, 0, 0, 18);
			m_pageTurn.setParam(onPageTurn);
			m_pageTurn.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			m_pageTurn.curPage = 0;
			
		}
		
		public function setDatas():void
		{
			var list:Array = m_gkContext.m_wuMgr.vecActHerosGroup;
			m_list.setDatas(list);
			m_list.setSeleced(0);
			
			m_pageTurn.pageCount = Math.ceil(m_list.controlList.length / 11);
		}
		
		private function onBtnSelected(event:Event):void
		{
			var btnitem:BtnItem = m_list.getControlSelected() as BtnItem;
			
			if (btnitem)
			{
				m_relationMainWuPanel.showAttrActWus(btnitem.groupID);
			}
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
		
		override public function dispose():void
		{
			m_btnLight.disposeEx();
			
			super.dispose();
		}
	}

}