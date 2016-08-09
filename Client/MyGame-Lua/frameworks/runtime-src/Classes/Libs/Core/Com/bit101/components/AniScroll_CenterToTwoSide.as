package com.bit101.components
{
	import com.ani.AniPropertys;
	import common.event.UIEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 * 动画:显示内容从中间向2边出现
	 * AniScroll_CenterToTwoSide对象在图像的中间位置
	 */
	public class AniScroll_CenterToTwoSide extends Component
	{
		public static const MODE_static:int = 0;
		public static const MODE_aniFold:int = 1;
		public static const MODE_aniUnFold:int = 2;
		
		private var m_imagePanel:Panel;
		private var m_imageW:Number = 0;
		private var m_imageH:Number = 0;
		
		private var m_ani:AniPropertys;
		private var m_aniMode:int;
		
		private var m_mask:Sprite;
		private var m_shapeLeft:Shape;
		private var m_shapeRight:Shape;
		private var m_curW:Number;
		
		public function AniScroll_CenterToTwoSide(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_imagePanel = new Panel(this);
			m_imagePanel.addEventListener(UIEvent.AllIMAGELOADED, onImageLoaded);
			
			m_ani = new AniPropertys();
			m_ani.useFrames = true;
			m_ani.sprite = this;
			m_ani.onEnd = onEnd;
			
			m_mask = new Sprite();
			this.mask = m_mask;
			this.addChild(m_mask);
			
			m_shapeLeft = new Shape();
			m_mask.addChild(m_shapeLeft);
			m_shapeRight = new Shape();
			m_mask.addChild(m_shapeRight);
			
			m_aniMode = MODE_static;
		}
		
		//此函数只能调用一次
		public function setParam(imageW:Number, imageH:Number, duration:Number, display:Component):void
		{
			m_imageW = imageW;
			m_imageH = imageH;
			
			m_imagePanel.addChild(display);
			m_imagePanel.x = -imageW / 2;
			m_ani.duration = duration;
		}
		
		
		//折叠（合上）动画
		public function beginFold():void
		{
			m_aniMode = MODE_aniFold;
			if (m_imagePanel.isAllImagesLoaded())
			{
				beginEx();
			}
			else
			{
				beginCheckImageLoaded();
			}
		}
		
		//展开动画
		public function beginUnfold():void
		{
			m_aniMode = MODE_aniUnFold;
			if (m_imagePanel.isAllImagesLoaded())
			{
				beginEx();
			}
			else
			{
				m_imagePanel.beginCheckImageLoaded();
			}
		}
		
		private function beginEx():void
		{
			if (m_aniMode == MODE_aniUnFold)
			{
				wScroll = 0;
				m_ani.resetValues({wScroll: m_imageW});
				m_ani.begin();
			}
			else if (m_aniMode == MODE_aniFold)
			{
				wScroll = m_imageW;
				m_ani.resetValues({wScroll: 0});
				m_ani.begin();
			}
		}
		
		public function set wScroll(w:Number):void
		{
			m_curW = w;
			var halfW:Number = w / 2;
			m_shapeRight.graphics.clear();
			m_shapeRight.graphics.beginFill(0);
			m_shapeRight.graphics.drawRect(0, 0, halfW, m_imageH);
			m_shapeRight.graphics.endFill();
			
			m_shapeLeft.graphics.clear();
			m_shapeLeft.graphics.beginFill(0);
			m_shapeLeft.graphics.drawRect(0, 0, halfW, m_imageH);
			m_shapeLeft.graphics.endFill();
			m_shapeLeft.x = -halfW;
		}
		
		public function get wScroll():Number
		{
			return m_curW;
		}
		
		private function onImageLoaded(e:UIEvent):void
		{
			if (m_aniMode)
			{
				beginEx();
			}
		}
		
		private function onEnd():void
		{
			m_aniMode = MODE_static;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override public function dispose():void
		{
			m_ani.dispose();
			m_imagePanel.removeEventListener(UIEvent.AllIMAGELOADED, onImageLoaded);
			super.dispose();
		}
		
		public function get imagePanel():Panel
		{
			return m_imagePanel;
		}
		
		
	}

}