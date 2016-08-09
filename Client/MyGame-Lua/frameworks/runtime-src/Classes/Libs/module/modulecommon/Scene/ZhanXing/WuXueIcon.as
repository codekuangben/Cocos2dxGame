package modulecommon.scene.zhanxing 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Label;
	import com.bit101.drag.DragComponentBase;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;	
	
	import modulecommon.scene.zhanxing.ZStar;
	import common.event.DragAndDropEvent;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	
	
	/**
	 * ...
	 * @author 
	 */
	public class WuXueIcon extends DragComponentBase 
	{
		public static const DisplayOffsetX:Number = 33;
		public static const DisplayOffsetY:Number = 33;
		
		protected var m_gkContext:GkContext;
		protected var m_star:ZStar;
		protected var m_ani:Ani;
		protected var m_nameLabel:Label;
		protected var m_levelLabel:Label;
		public function WuXueIcon(gk:GkContext, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			
			m_gkContext = gk;			
			super(parent, xpos, ypos);
			m_disPlayX = 33;
			m_disPlayY = 33;
			m_display.setPos(DisplayOffsetX, DisplayOffsetY);			
			setSize(67, 68);
			m_display.setSize(this.width, this.height);
			m_display.mouseChildren = false;
			m_display.mouseEnabled = false;		
			
		}
		public function setZStar(star:ZStar):void
		{
			
			if (star == m_star)
			{
				return;
			}
			if (m_star != null)
			{
				unload();
			}
			m_star = star;
			load();
			m_nameLabel.setFontColor(m_star.colorValue);
			m_levelLabel.setFontColor(m_star.colorValue);
		}
		
		public function removeZStar():void
		{
			if (m_star)
			{
				unload();
				m_star = null;
			}
		}
		
		public function updateStar():void
		{
			m_nameLabel.text = m_star.m_base.m_name;
			m_levelLabel.text = "Lv." + m_star.m_tStar.m_level;
		}
		
		public function get zStar():ZStar
		{
			return m_star;
		}
		
		protected function load():void
		{
			if (m_nameLabel == null)
			{
				m_nameLabel = new Label(m_display, 0, 5);
				m_nameLabel.align = CENTER;
				
				m_levelLabel = new Label(m_display, 0, 18);
				m_levelLabel.align = CENTER;
			}
			m_nameLabel.visible = true;
			m_levelLabel.visible = true;
			
			m_ani = new Ani(m_con);
			m_ani.centerPlay = true;
			m_ani.useFrames = true;
			m_ani.duration = 50;
			m_ani.repeatCount = 0;
			m_ani.setAutoStopWhenHide();
			m_ani.setImageAni(m_star.path);
			m_display.addChild(m_ani);
			m_display.setChildIndex(m_ani, 0);
			m_ani.begin();
			this.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseEnter);
			updateStar();
		}
		
		protected function unload():void
		{
			if (m_ani)
			{
				if (m_ani.parent != null)
				{
					m_ani.parent.removeChild(m_ani);
				}
				m_ani.dispose();
				m_ani = null;
			}
			
			if (m_nameLabel)
			{
				m_nameLabel.visible = false;
				m_levelLabel.visible = false;
			}			
		}
		private function onMouseEnter(e:MouseEvent):void
		{
			if (m_star == null)
			{
				return;
			}
			
			var pt:Point = this.localToScreen();
			//pt.y += 40;
			
			var str:String;
			UtilHtml.beginCompose();
			if (m_star.isjingyan())
			{
				str = UtilHtml.formatBold(m_star.m_base.m_name);
				UtilHtml.add(str, m_star.colorValue, 14);
				UtilHtml.breakline();
				str = m_star.attrName + " +" + m_star.m_numberBase.m_baseValue;
				UtilHtml.add(str, UtilColor.GREEN, 12);
				UtilHtml.breakline();
				UtilHtml.add("该武学不可升级，只可被其他武学吞噬", UtilColor.RED, 12);
			}
			else
			{
				str = UtilHtml.formatBold(m_star.m_base.m_name + " LV." + m_star.m_tStar.m_level);
				UtilHtml.add(str, m_star.colorValue, 14);
				UtilHtml.breakline();
				
				if (m_star.isTopLevel)
				{
					str = m_star.m_tStar.m_totalExp.toString() + "/" + m_star.m_tStar.m_totalExp.toString();
				}
				else
				{
					str = m_star.m_tStar.m_totalExp.toString() + "/" + m_star.needExpForNext.toString();
				}
				UtilHtml.add("经验 " + str, UtilColor.WHITE_B, 12);
				UtilHtml.breakline();
				
				if (m_star.isTopColor)
				{
					str = m_star.attrName + " +" + m_star.attrValueOfPurple;
					UtilHtml.add(str, UtilColor.GREEN, 12);
					UtilHtml.breakline();
					str = m_star.attrName + " +" + m_star.attrValue + "%";
					UtilHtml.add(str, UtilColor.GREEN, 12);
				}
				else
				{
					str = m_star.attrName + " +" + m_star.attrValue;
					UtilHtml.add(str, UtilColor.GREEN, 12);
				}
			}
			
			m_gkContext.m_uiTip.hintHtiml(pt.x - 165, pt.y + 30, UtilHtml.getComposedContent(), 180, true, 8);
		}
		
		public function onDragStart(e:DragAndDropEvent):void
		{
			
		}
		
		public function onReadyDrop(e:DragAndDropEvent):void
		{			
		
		}
		
		public function onDragDrop(e:DragAndDropEvent):void
		{
			
		}
		
		public function onDragEnter(e:DragAndDropEvent):void
		{
		}
		
		public function onDragOverring(e:DragAndDropEvent):void
		{
		}
		
		public function onDragExit(e:DragAndDropEvent):void
		{
		}
	}

}