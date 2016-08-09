package com.dgrigg.skins
{
	//import com.dgrigg.minimalcomps.skins.Skin;
	import com.bit101.components.Panel;
	import common.event.UIEvent;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author
	 * 按钮的标题是一张图片
	 */
	public class SkinButtonImageCaption extends ButtonImageSkin
	{
		private var m_captionContainer:Sprite;
		protected var m_captionPanel:Panel;
		protected var m_captionPanelPosX:Number;
		protected var m_captionPanelPosY:Number;
		
		override public function init():void
		{
			hostComponent.addBackgroundChild(_bitmap);
			m_captionContainer = new Sprite();
			hostComponent.addBackgroundChild(m_captionContainer);
			
			m_captionPanel = new Panel(m_captionContainer);
			hostComponent.addEventListener(UIEvent.IMAGELOADED, onCheckImageLoaded);
			hostComponent.addEventListener(UIEvent.IMAGEFAILED, onCheckImageLoaded);
		}
		
		override public function unInstall():void
		{
			hostComponent.removeBackgroundChild(m_captionContainer);
			hostComponent.removeEventListener(UIEvent.IMAGELOADED, onCheckImageLoaded);
			hostComponent.removeEventListener(UIEvent.IMAGEFAILED, onCheckImageLoaded);
			m_captionPanel.dispose();
			super.unInstall();
		}
		
		public function set captionImageName(name:String):void
		{
			m_captionPanel.setPanelImageSkin(name);
		}
		
		public function onCheckImageLoaded(e:UIEvent):void
		{
			if (e.m_skin == m_captionPanel.skin)
			{
				m_captionPanelPosX = (_hostComponent.width - m_captionPanel.width) / 2;
				m_captionPanelPosY = (_hostComponent.height - m_captionPanel.height) / 2;
				m_captionPanel.setPos(m_captionPanelPosX, m_captionPanelPosY);
				
				hostComponent.removeEventListener(UIEvent.IMAGELOADED, onCheckImageLoaded);
				hostComponent.removeEventListener(UIEvent.IMAGEFAILED, onCheckImageLoaded);
			}
		}
	
	}

}