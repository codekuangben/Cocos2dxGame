package game.ui.uiNewHand
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.ani.AniPosition;
	import modulecommon.ui.Form;
	import game.ui.uiNewHand.focus.Circle;
	import game.ui.uiNewHand.focus.CircleEffect;
	import game.ui.uiNewHand.subcom.HalfingPart;
	
	/**
	 * ...
	 * @author
	 */
	public class UINewHand extends Form
	{
		private var m_halfing:HalfingPart;
		private var m_ani:AniPosition;
		private var m_circleEffect:CircleEffect;
		private var m_flickerEffect:Circle;
		private var m_text:String;
		private var m_rectFrame:Rectangle;
		private var m_bShowFrame:Boolean;
		private var m_frameType:uint;	//指向对象显示外框样式 0:4框嵌套框 1:闪烁框
		
		public function UINewHand()
		{
			m_halfing = new HalfingPart(this);
			m_ani = new AniPosition();
			m_ani.sprite = this;
			m_ani.onEnd = onFlyEnd;
			
			m_rectFrame = new Rectangle();
			this.exitMode = EXITMODE_HIDE;
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		override public function onReady():void
		{
			super.onReady();
			m_gkcontext.m_newHandMgr.m_ui = this;
			
			m_circleEffect = new CircleEffect();
			m_circleEffect.mouseEnabled = false;
			
			m_flickerEffect = new Circle();
			m_flickerEffect.mouseEnabled = false;
			m_flickerEffect.setFlickerValue();
			
		}
		
		override public function onDestroy():void
		{
			super.onDestroy();
			m_gkcontext.m_newHandMgr.m_ui = null;
		}
		
		override public function updateData(param:Object = null):void
		{
			if (param is int)
			{
				promptOver();
			}
			else
			{
				prompt(param["right"], param["xPos"], param["yPos"], param["text"], param["focusCom"], param["rectFrame"], param["frameType"]);
			}
		}
		
		override public function dispose():void
		{
			//super.dispose();
			//m_ani.dispose();
		}
		
		override public function adjustPosWithAlign():void
		{
		
		}
		
		override public function isVisible():Boolean
		{
			return (this.parent != null && (this.parent is Loader)==false);
		}
		
		override public function hide():void
		{
			if (this.parent != null)
			{
				this.parent.removeChild(this);
			}
			
			m_gkcontext.uiFocus.focusOut();
			hideFrame();
		}
		
		public function promptOver():void
		{
			m_gkcontext.uiFocus.focusOut();
			if (this.parent != null)
			{
				var p1:Point = (this.parent as Component).posInRelativeParent(m_gkcontext.m_UIMgr);
				this.setPos(p1.x + this.x, p1.y + this.y);
				this.parent.removeChild(this);
				this.show();
			}
		}
		
		public function prompt(right:Boolean, xPos:Number, yPos:Number, text:String, focusCom:Component, rectFrame:Rectangle, type:uint):void
		{
			m_gkcontext.uiFocus.focusOn(focusCom);
			m_halfing.set(right);
			
			var offset:Point = m_halfing.getOffset();
			
			//destPoint是this相对于focusCom.parent的位置,focusCom.parent是Form类型
			var destPoint:Point = new Point(xPos - offset.x + focusCom.x, yPos - offset.y + focusCom.y);
			
			if (rectFrame)
			{
				m_bShowFrame = true;
				m_rectFrame.x = rectFrame.x + focusCom.x - destPoint.x;
				m_rectFrame.y = rectFrame.y + focusCom.y - destPoint.y;
				m_rectFrame.width = rectFrame.width;
				m_rectFrame.height = rectFrame.height;
				m_frameType = type;
			}
			else
			{
				m_bShowFrame = false;
			}
			
			var bFly:Boolean = false;
			if (this.isVisible())
			{
				var p1:Point = this.posInRelativeParent(m_gkcontext.m_UIMgr);
				var p2:Point = (focusCom.parent as Component).posInRelativeParent(m_gkcontext.m_UIMgr);
				var sorPoint:Point = p1.subtract(p2);
				if (!destPoint.equals(sorPoint))
				{
					//飞行到指定地方
					m_text = text;
					m_halfing.hideText();
					m_ani.setBeginPos(sorPoint.x, sorPoint.y);
					m_ani.setEndPos(destPoint.x, destPoint.y);
					m_ani.duration = 0.6;
					m_ani.begin();
					bFly = true;
					hideFrame();
				}				
			}
			if (!focusCom.parent.contains(this))
			{
				focusCom.parent.addChild(this);
			}
			
			if (bFly == false)
			{
				//直接在指定地方显示出来
				m_halfing.setText(text);
				m_halfing.showText(false);
				this.setPos(destPoint.x, destPoint.y);
				showFrame();
			}
		}
		
		private function onFlyEnd():void
		{
			m_halfing.setText(m_text);
			m_halfing.showText();
			showFrame();
		}
		
		private function showFrame():void
		{
			if (m_bShowFrame == false)
			{
				return;
			}
			
			if (m_frameType)
			{
				if (m_circleEffect.parent)
				{
					m_circleEffect.parent.removeChild(m_circleEffect);
				}
				m_circleEffect.end();
				
				m_flickerEffect.setRectangle(m_rectFrame);			
				m_flickerEffect.begin();
				if (null == m_flickerEffect.parent)
				{
					this.addChild(m_flickerEffect);
				}
			}
			else
			{
				if (m_flickerEffect.parent)
				{
					m_flickerEffect.parent.removeChild(m_flickerEffect);
				}
				m_flickerEffect.end();
				
				m_circleEffect.setRectangle(m_rectFrame);			
				m_circleEffect.begin();
				if (null == m_circleEffect.parent)
				{
					this.addChild(m_circleEffect);
				}
			}
		}
		private function hideFrame():void
		{
			if (m_flickerEffect.parent)
			{
				m_flickerEffect.parent.removeChild(m_flickerEffect);
			}
			m_flickerEffect.end();
			
			if (m_circleEffect.parent)
			{
				m_circleEffect.parent.removeChild(m_circleEffect);
			}
			m_circleEffect.end();
		}
	}

}