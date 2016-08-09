package com.ani.uiAni 
{
	import com.ani.AniPropertys;
	import com.bit101.components.Component;
	import common.event.UIEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author 
	 */
	public class AniScrollRect
	{
		private var m_host:Component;
		private var m_ani:AniPropertys;
		private var m_initWidth:Number;
		private var m_initHeight:Number;
		private var m_speed:Number;
		
		private var m_rect:Rectangle;
		public function AniScrollRect() 
		{
			m_ani = new AniPropertys();
			m_ani.sprite = this;
			m_ani.onEnd = onEnd;
			m_rect = new Rectangle();
		}
		public function setParam(initWidth:Number, initHeight:Number, speed:Number):void
		{
			m_initWidth = initWidth;
			m_initHeight = initHeight;
			m_speed = speed;			
		}
		
		public function begin():void
		{
			m_rect.width = m_initWidth;
			m_rect.height = m_initHeight;
			
			var param:Object = new Object();
			var distance:Number = 0;
			if (m_initWidth != m_host.width)
			{
				width = m_initWidth;
				param["width"] = m_host.width;
				distance = Math.abs(m_initWidth - m_host.width);
			}
			if (m_initHeight != m_host.height)
			{
				height = m_initHeight;
				param["height"] = m_host.height;
				distance = Math.abs(m_initHeight - m_host.height);
			}
			
			m_ani.resetValues(param);
			m_ani.duration = distance / m_speed;
			m_ani.begin();
		}
		private function onEnd():void
		{
			m_host.dispatchEvent(new UIEvent(UIEvent.ANI_END));
		}
		public function dispose():void
		{
			m_host = null;
			m_ani.dispose();
		}
		public function set width(v:Number):void
		{
			m_rect.width = v;
			m_host.scrollRect = m_rect;
		}
		public function get width():Number
		{
			return m_rect.width;
		}
		public function set height(v:Number):void
		{
			m_rect.height = v;
			m_host.scrollRect = m_rect;
		}
		public function get height():Number
		{
			return m_rect.height;
		}
		
		public function set host(host:Component):void
		{
			m_host = host;
		}
	}

}