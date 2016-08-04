package game.ui.uiZhenfa.xiayewulist 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.pageturn.PageTurn;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.dgrigg.image.Image;
	import com.dnd.DragListener;
	import com.dnd.DragManager;
	import common.event.DragAndDropEvent;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneHeroCmd.stSetHeroXiaYeCmd;
	import modulecommon.scene.wu.WuProperty;
	import game.ui.uiZhenfa.UIZhenfa;
	import game.ui.uiZhenfa.WuIconList;
	/**
	 * ...
	 * @author ...
	 * 下野武将列表
	 */
	public class XiayeWuList extends PanelContainer implements DragListener
	{
		private var m_gkContext:GkContext;
		private var m_ui:UIZhenfa;
		private var m_titlePanel:PanelContainer;
		private var m_xiayewuList:ControlListVHeight;
		private var m_param:Object;
		private var m_pageTurn:PageTurn;
		private var m_oldPageCount:int;
		public var m_wuIconList:WuIconList;
		
		public function XiayeWuList(gk:GkContext, ui:UIZhenfa, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			
			this.setSize(180, 479);
			this.setSkinForm("form9.swf");
			this.setDropTrigger(true);
			
			m_titlePanel = new PanelContainer(this, 19, 10);
			
			m_xiayewuList = new ControlListVHeight(this, 21, 35);
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			
			m_param = new Object();
			m_param["gk"] = m_gkContext;
			m_param["dragListener"] = this;
			m_param["listCtl"] = m_xiayewuList;
			
			param.m_class = WuBtnItem;
			param.m_marginBottom = 2;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_marginTop = 2;
			param.m_intervalV = 4;
			param.m_width = 130;
			param.m_heightList = param.m_marginTop + param.m_marginBottom + 37 + (37 + param.m_intervalV) * 9;
			param.m_lineSize = param.m_heightList;
			param.m_scrollType = 1;
			param.m_dataParam = m_param;
			m_xiayewuList.setParam(param);
			m_xiayewuList.bInitSubCtrlOnShow = true;
			
			m_pageTurn = new PageTurn(this, 50, 448);
			m_pageTurn.setBtnPos(0, 0, 60, 0, 0, 18);
			m_pageTurn.setParam(onPageTurn);
			m_pageTurn.setBtnNameHorizontal_Mirror("leftArrow2.swf");
			m_pageTurn.curPage = 0;
		}
		
		public function setDatas():void
		{
			var panel:Panel = new Panel(m_titlePanel, 33, 2);
			panel.setPanelImageSkin("commoncontrol/panel/zaiyewujiang.png");
			m_titlePanel.setPanelImageSkinMirror("commoncontrol/panel/glodflightsmall.png", Image.MirrorMode_LR);
			
			var list:Array = m_gkContext.m_wuMgr.getXiayeWuList();
			m_xiayewuList.setDatas(list);
			
			m_oldPageCount = Math.ceil(m_xiayewuList.controlList.length / 10);
			m_pageTurn.pageCount = m_oldPageCount;
		}
		
		public function updateWuNum(wu:WuProperty):void
		{
			var wubtnitem:WuBtnItem = m_xiayewuList.getCtrl(wu) as WuBtnItem;
			if (wubtnitem)
			{
				wubtnitem.refresh();
			}
		}
		
		private function onPageTurn(pre:Boolean):void
		{
			if (pre)
			{
				m_xiayewuList.toPreLine();
			}
			else
			{
				m_xiayewuList.toNextLine();
			}
		}
		
		public function addXiayeWu(wu:WuProperty):void
		{
			var list:Array = m_gkContext.m_wuMgr.getXiayeWuList();				
			var i:int = list.indexOf(wu);
			m_xiayewuList.insertData(i, wu, m_param);
			
			m_oldPageCount = Math.ceil(m_xiayewuList.controlList.length / 10);
			m_pageTurn.pageCount = m_oldPageCount;
		}
		
		public function removeXiayeWu(wu:WuProperty):void
		{
			m_xiayewuList.deleteDataByData(wu);
			
			m_pageTurn.pageCount = Math.ceil(m_xiayewuList.controlList.length / 10);
			if (m_pageTurn.curPage >= m_pageTurn.pageCount)
			{
				m_pageTurn.curPage = m_oldPageCount - (m_oldPageCount - Math.ceil(m_xiayewuList.controlList.length / 10)) - 1;
			}
		}
		
		public function onReadyDrop(e:DragAndDropEvent) : void
		{
			var targetCom:Component = e.getTargetComponent();
			
			if (targetCom && (targetCom == m_wuIconList || m_wuIconList.contains(targetCom)))
			{
				var notXiayeList:Array = m_gkContext.m_wuMgr.getNotXiayeWuList();
				if (notXiayeList.length >= 11)
				{
					m_gkContext.m_systemPrompt.prompt("最多只能携带10个武将！");
					return;
				}
				
				var wubtnitem:WuBtnItem = e.getDragInitiator() as WuBtnItem;
				var cmd:stSetHeroXiaYeCmd = new stSetHeroXiaYeCmd();
				cmd.heroid = wubtnitem.wu.m_uHeroID;
				cmd.toXiaye = false;
				m_gkContext.sendMsg(cmd);
				
				return;
			}
			
			DragManager.drop();
		}
		
		public function onDragDrop (e:DragAndDropEvent) : void
		{
			var wubtnitem:WuBtnItem = e.getDragInitiator() as WuBtnItem;
			wubtnitem.becomeUnGray();
		}
		
		public function onDragEnter (e:DragAndDropEvent) : void{}
		
		public function onDragExit (e:DragAndDropEvent) : void{}
		
		public function onDragOverring (e:DragAndDropEvent) : void{}
		
		public function onDragStart (e:DragAndDropEvent) : void { }
		
	}

}