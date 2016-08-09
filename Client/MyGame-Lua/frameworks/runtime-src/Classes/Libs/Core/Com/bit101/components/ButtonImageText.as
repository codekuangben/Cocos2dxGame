package com.bit101.components 
{
	/**
	 * ...
	 * @author 
	 * 按钮上的文字由图片来表示
	 */
	import com.dgrigg.utils.UIConst;
	import com.pblabs.engine.resource.SWFResource;
	import common.event.UIEvent;
	import flash.display.DisplayObjectContainer;

	
	
	public class ButtonImageText extends PushButton 
	{		
		protected var m_imageText:Panel;		
		protected var m_normalPosY:Number;
		protected var m_overOffsetY:int;
		public function ButtonImageText(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null) 
		{
			super(parent, xpos, ypos, defaultHandler);
			m_imageText = new Panel(this);
			m_imageText.mouseEnabled = false; 
			m_imageText.visible = false;
			m_overOffsetY = -1;
			m_imageText.addEventListener(UIEvent.IMAGELOADED, onImageTextLoad);
			
		}
		
		public function setImageText(srcName:String):void
		{
			m_imageText.setPanelImageSkin(srcName);
		}
		
		public function setImageTextBySWF(swf:SWFResource, srcName:String):void
		{
			m_imageText.setPanelImageSkinBySWF(swf, srcName);
		}
		
		//m_imageText中的图片加载完成后，调用此函数
		public function onImageTextLoad(e:UIEvent):void
		{
			updateImageTextPos()
		}
		
		protected function updateImageTextPos():void
		{
			if (this.width > 0)
			{
				m_imageText.visible = true;
				m_imageText.x = (this.width - m_imageText.width) / 2;
				m_normalPosY = m_imageText.y = (this.height - m_imageText.height) / 2; 
			}
		}
		
		override public function draw():void 
		{
			super.draw();
			if (m_imageText)
			{
				updateImageTextPos();
			}
		}	
		
		override protected function updateSkin(state:uint):void 
		{
			super.updateSkin(state);
			if (state == UIConst.EtBtnOver)
			{
				m_imageText.y = m_normalPosY + m_overOffsetY;
			}
			else if(state == UIConst.EtBtnNormal)
			{
				m_imageText.y = m_normalPosY;
			}
			else if (state == UIConst.EtBtnDown)
			{
				m_imageText.y = m_normalPosY + 1;
			}
			m_imageText.filters = s_funGetFilters(state);
		}
		
		public function set overOffsetY(offset:int):void
		{
			m_overOffsetY = offset;
		}
		public function get imageText():Panel
		{
			return m_imageText;
		}
	}

}