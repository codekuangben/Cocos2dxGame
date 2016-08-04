package game.ui.uiZhenfa 
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import com.dnd.DragManager;	
	import flash.geom.Point;
	import flash.text.TextField;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilHtml;
	import game.ui.uiZhenfa.event.DragWuEvent;
	
	
	import flash.events.MouseEvent;
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
		
		public function ZhenfaGridEV(gk:GkContext, parent:DisplayObjectContainer, xPos:int, yPos:int, grid:zhenfaGrid):void		
		{
			super(parent, xPos, yPos);
			m_gkContext = gk;
			m_grid = grid;
			m_grid.gridEV = this;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			this.setDropTrigger(true);			
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
			
			DragManager.startDrag(this, null, m_grid, m_grid, true);		
			this.dispatchEvent(new DragWuEvent(DragWuEvent.DRAG_WU, m_grid.wu));
		}
		protected function onMouseOver(event:MouseEvent):void
		{
			if (m_grid.isOpen() == false)
			{
				return;
			}
			if (m_grid.isGray == false)
			{
				m_grid.toHightLight(true);
				addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				
				if (m_grid.wu)
				{
					var pt:Point = this.localToScreen(new Point(30, -65));
					if (null == m_wuName)
					{
						m_wuName = new TextField();
					}
					UtilHtml.beginCompose();
					UtilHtml.add(m_grid.wu.fullName, m_grid.wu.colorValue, 14);
					m_wuName.htmlText = UtilHtml.getComposedContent();
					m_gkContext.m_uiTip.hintCondense(pt, m_wuName.htmlText);
				}
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{				
			if (this.hasEventListener(MouseEvent.ROLL_OUT))
			{
				if (m_gkContext.m_newHandMgr.isVisible() 
					&& (SysNewFeatures.NFT_ZHENFA == m_gkContext.m_sysnewfeatures.m_nft || SysNewFeatures.NFT_FHLIMIT4 == m_gkContext.m_sysnewfeatures.m_nft))
				{
					//新手引导过程中，阵位格子总是高亮（与鼠标移动无关）
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
			this.graphics.drawRect(0, 0, m_grid.width, m_grid.height);
			if (m_grid.wu != null)
			{				
				this.graphics.drawRect(0, -60, m_grid.width, 60);
			}
			this.graphics.endFill();
		}

		public override function isDragAcceptableInitiator(com:Component):Boolean
		{
			var dragWu:WuProperty;
			if (com is ZhenfaGridEV)
			{
				dragWu = (com as ZhenfaGridEV).grid.wu;
			}
			else if (com is WuIconItem)
			{
				dragWu = (com as WuIconItem).wu;
			}
			if (dragWu == null)
			{
				return false;
			}
			if (dragWu.isMain || (dragWu as WuHeroProperty).m_npcBase.m_iZhenwei == grid.zhenwei)
			{
				return true;
			}
			return false;
		}	
		
		public function get grid():zhenfaGrid
		{
			return m_grid;
		}
	}

}