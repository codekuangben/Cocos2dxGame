package com.bit101.components 
{		
	import com.ani.AniPropertys;
	import com.pblabs.engine.resource.SWFResource;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author ...
	 * 缩放动画，输入的是一张图片，由程序进行缩放动画
	 */
	public class AniZoom extends Panel 
	{
		private var m_imagePanel:Panel;
		private var m_ani:AniPropertys;
		public function AniZoom(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);	
			
			m_imagePanel = new Panel(this);
			m_ani = new AniPropertys();
			m_ani.sprite = this;
			m_ani.repeatCount = 0;
			m_ani.reflect = true;
		}
		
		public function setImageAni(res:String):void
		{
			m_imagePanel.setPanelImageSkin(res);			
		}
		
		public function setImageAniBySWF(swf:SWFResource, res:String):void
		{
			m_imagePanel.setPanelImageSkinBySWF(swf, res);
		}
		public function setParam(minZoom:Number, maxZoom:Number, duration:Number, zoomCenterX:Number, zommCenterY:Number, useFrames:Boolean=false):void
		{
			this.scaleX = minZoom;
			this.scaleY = minZoom;
			m_ani.resetValues( { scaleX:maxZoom, scaleY:maxZoom } );
			m_ani.duration = duration;		
			m_ani.useFrames = useFrames;
			m_imagePanel.setPos(-zoomCenterX, -zommCenterY);
		}
		public function begin():void
		{
			m_ani.begin();
		}
		public function stop():void
		{
			m_ani.stop();
		}
		override public function dispose():void 
		{
			m_ani.dispose();
			super.dispose();
		}
		
		public function set repeatCount(value:uint):void
		{
			m_ani.repeatCount = value;
		}
		
		public function set onEnd(func:Function):void
		{
			m_ani.onEnd = func;
		}
	}

}