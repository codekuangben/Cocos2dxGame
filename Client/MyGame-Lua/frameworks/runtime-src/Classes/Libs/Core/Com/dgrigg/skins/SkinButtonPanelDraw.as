package com.dgrigg.skins
{
	import com.bit101.components.PushButton;
	import com.bit101.utils.PanelDrawCreator;
	import com.dgrigg.image.Image;
	import com.dgrigg.minimalcomps.skins.Skin;
	import com.util.UtilDictionary;
	import flash.display.BitmapData;
	import com.dgrigg.utils.UIConst;
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import common.event.UIEvent;
	
	/**
	 * ...
	 * @author ...
	 * 按钮有3（或4）个状态。每个状态对应一张图片。对于SkinButtonPanelDraw，每张图片是动态生成的。
	 */
	public class SkinButtonPanelDraw extends Skin
	{
		protected var _bitmap:Bitmap;
		private var _panelDrawCreator:ISkinButtonPanelDrawCreator;
		private var m_dicBitmap:Dictionary; //是<UIConst.EtBtnNormal, BitmapData>的集合
		private var m_dicCreator:Dictionary;
		
		public function SkinButtonPanelDraw()
		{
			super();
			_bitmap = new Bitmap();
			m_dicBitmap = new Dictionary();
			m_dicCreator = new Dictionary();
		}
		
		override public function init():void
		{
			_loadState = Image.Loaded;
			hostComponent.addBackgroundChild(_bitmap);
		}
		
		override public function unInstall():void
		{
			hostComponent.removeBackgroundChild(_bitmap);			
			releaseCreators()
			super.unInstall();
		}
		
		private function releaseCreators():void
		{
			var creator:PanelDrawCreator;
			for each (creator in m_dicCreator)
			{
				creator.dispose();
			}
		}
		
		override public function btnStateChange(state:uint):void
		{
			var bit:BitmapData = m_dicBitmap[state] as BitmapData;
			if (bit == null)
			{
				if (_panelDrawCreator)
				{
					if (m_dicCreator[state] == undefined)
					{
						var creator:PanelDrawCreator = _panelDrawCreator.createPanelDrawCreator(state);
						creator.funOnDraw = onPanelDraw;
						m_dicCreator[state] = creator
						creator.endAdd();
					}
				}
				return;
			}
			_bitmap.bitmapData = bit;
		}
		
		public function getNormalBitmapData():BitmapData
		{
			return m_dicBitmap[UIConst.EtBtnNormal] as BitmapData
		}
		
		override protected function updateBitmapdata():void
		{
			var index:int = 0;
			if (hostComponent != null)
			{
				btnStateChange((hostComponent as PushButton).state);
				if (hostComponent.autoSizeByImage)
				{
					if (_bitmap.bitmapData)
					{
						if (hostComponent.width != _bitmap.bitmapData.width || hostComponent.height != _bitmap.bitmapData.height)
						{
							hostComponent.setSize(_bitmap.bitmapData.width, _bitmap.bitmapData.height);
						}
					}
				}
				else
				{
					_bitmap.width = hostComponent.width;
					_bitmap.height = hostComponent.height;
				}
			}
		}
		
		/*调用此函数时，表示已经将内容放入PanelDrawCreator对象中。
		 * dicCreator是<UIConst.EtBtnNormal, PanelDrawCreator>的集合。其中，UIConst.EtBtnNormal代表按钮的状态
		 * 一旦将PanelDrawCreator对象传入这个函数，则外部不应该再对其引用了
		 *
		 * 在实现时，分2部：1.设置funOnDraw。2调用endAdd()。
		 * 建立list对象是必要的. 如果直接在"for each (creator in m_dicCreator)"中调用endAdd()，endAdd()可能会调用SkinButtonPanelDraw::onPanelDraw只需delete操作。循环会出现问题
		 */
		public function setPanelDrawCreator(panelDrawCreator:ISkinButtonPanelDrawCreator):void
		{
			if (_panelDrawCreator)
			{
				m_dicCreator = new Dictionary();
			}
			_panelDrawCreator = panelDrawCreator;			
			btnStateChange((_hostComponent as PushButton).state);
		}
		
		public function refresh():void
		{
			m_dicBitmap = new Dictionary();
			releaseCreators();
			m_dicCreator = new Dictionary();
			btnStateChange((_hostComponent as PushButton).state);
		}
		
		private function onPanelDraw(creator:PanelDrawCreator):void
		{
			var key:Object;
			
			for (key in m_dicCreator)
			{
				if (m_dicCreator[key] == creator)
				{
					m_dicBitmap[key] = creator.bitmapData;
					creator.dispose();
					delete m_dicCreator[key];
					
					if (key == (_hostComponent as PushButton).state)
					{
						_bitmap.bitmapData = m_dicBitmap[key];
					}
					
					break;
				}
			}
		}
	}

}