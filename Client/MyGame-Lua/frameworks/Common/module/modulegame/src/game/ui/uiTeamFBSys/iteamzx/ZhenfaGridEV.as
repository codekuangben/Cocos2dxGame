package game.ui.uiTeamFBSys.iteamzx 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.dnd.DragManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilColor;
	
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragData;
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragEvent;
	import game.ui.uiTeamFBSys.iteamzx.tip.TipSlave;

	/**
	 * ...
	 * @author zouzhiqiang
	 * 代表阵法中的一个格子，负责相应鼠标事件
	 */
	
	public class ZhenfaGridEV extends Component
	{
		private var m_gkContext:GkContext;
		private var m_grid:zhenfaGrid;
		private var m_wuName:TextField;
		public var m_lblDesc:Label;		// 描述
		
		public function ZhenfaGridEV(gk:GkContext, parent:DisplayObjectContainer, xPos:int, yPos:int, grid:zhenfaGrid):void		
		{
			super(parent, xPos, yPos);
			m_gkContext = gk;
			m_grid = grid;
			m_grid.gridEV = this;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.setDropTrigger(true);
			
			m_lblDesc = new Label(this, -20, -20, "", UtilColor.GREEN);
			m_lblDesc.text = "等待队友拖入武将";
			m_lblDesc.visible = false;
		}
		
		override public function dispose():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			super.dispose();
		}
		
		public function onMouseDown(e:MouseEvent):void
		{
			if (DragManager.isDragging() == true)
			{
				return;
			}
			if (m_grid.wu == null)
			{
				return;
			}
			
			if(!m_grid.m_TFBSysData.isSelfRow(m_grid.m_serverRowNO))
			{
				m_gkContext.m_systemPrompt.prompt("不能拖动别人的武将");
				return;
			}
			
			if (m_grid)
			{
				DragManager.startDrag(this, null, m_grid, m_grid, true);	
				// 注意这里传入 null ，整个流程好像没有使用这个值
				var data:TeamDragData = new TeamDragData();
				data.m_isMain = m_grid.isMain();
				data.m_npcBase = m_grid.npcBase();
				
				this.dispatchEvent(new TeamDragEvent(TeamDragEvent.DRAG_WU, data));
			}
		}

		protected function onMouseOver(event:MouseEvent):void
		{
			if (m_grid.isOpen() == false)
			{
				return;
			}
			//if (m_grid.isGray == false)
			//{
				if(m_grid.m_TFBSysData.isSelfRow(m_grid.m_serverRowNO))	// 如果是自己所在的行
				{
					m_grid.toHightLight(true);
				}
				addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				
				if (m_grid.wu)
				{
					/*
					var pt:Point = this.localToScreen(new Point(30, -65));
					if (null == m_wuName)
					{
						m_wuName = new TextField();
					}
					UtilHtml.beginCompose();
					UtilHtml.add(m_grid.fullName(), m_grid.colorValue(), 14);
					m_wuName.htmlText = UtilHtml.getComposedContent();
					m_gkContext.m_uiTip.hintCondense(pt, m_wuName.htmlText);
					*/
					var pt:Point = this.localToScreen(new Point(-60, -220));
					
					var tip:TipSlave = m_grid.m_uizhenfa.tip as TipSlave;
					tip.showTip(m_grid.m_serverRowNO, m_grid.m_serverGridNO);
					m_gkContext.m_uiTip.hintComponent(pt, tip);		
				}
			//}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{				
			if (this.hasEventListener(MouseEvent.ROLL_OUT))
			{
				if (m_gkContext.m_newHandMgr.isVisible() && m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_ZHENFA)
				{
				}
				else
				{
					m_grid.toHightLight(false);
				}
				m_gkContext.m_uiTip.hideTip();
				removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
		}

		override public function draw():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			//this.graphics.beginFill(0xFF);
			this.graphics.drawRect(0, 0, m_grid.width, m_grid.height);
			if (m_grid.wu != null)
			{				
				this.graphics.drawRect(0, -60, m_grid.width, 60);
			}
			this.graphics.endFill();
		}

		public override function isDragAcceptableInitiator(com:Component):Boolean
		{
			var dragWu:WuProperty;	// 这个主要是从武将列表拖动
			var srcgrid:zhenfaGrid;	// 开始拖动的阵法格子
			if (com is ZhenfaGridEV)
			{
				// 这个通过阵法格子判断
				srcgrid = (com as ZhenfaGridEV).grid;
				if (srcgrid.wu == null)
				{
					return false;
				}
				if (srcgrid.isMain() || srcgrid.npcBase().m_iZhenwei == grid.zhenwei)
				{
					return true;
				}
			}
			else if (com is WuIconItem)
			{
				// 这个通过武将属性判断
				dragWu = (com as WuIconItem).wu;
				if (dragWu == null)
				{
					return false;
				}
				if (dragWu.isMain || (dragWu as WuHeroProperty).m_npcBase.m_iZhenwei == grid.zhenwei)
				{
					return true;
				}
			}
			
			return false;
		}	
		
		public function get grid():zhenfaGrid
		{
			return m_grid;
		}
		
		public function get lblDesc():Label
		{
			return m_lblDesc;
		}
	}
}