package com.dgrigg.skins
{
	//import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import com.dgrigg.minimalcomps.skins.Skin;
	//import com.dgrigg.utils.BitmapScale9Grid;
	import com.dgrigg.utils.UIConst;
	import flash.display.Bitmap;
	//import flash.display.BitmapData;
	
	// 通用按钮类图标  
	public class Button9ImageSkin extends Skin
	{
		protected var _up:Bitmap;
		protected var _over:Bitmap;
		
		//[Embed(source = "../../../assets/images/button-up.png")]
		//protected var _upClas:Class;
		
		//[Embed(source = "../../../assets/images/button-over.png")]
		//protected var _overClas:Class;
		
		public function Button9ImageSkin()
		{
			super();
		}
		
		override public function init():void
		{
			/*var host:PushButton = hostComponent as PushButton;
			_up = new Bitmap();
			_over = new Bitmap();
			// 初始化自己使用的资源     
			var bitmap9grid:BitmapScale9Grid;
			var bitdata:BitmapData;
			bitdata  = new BitmapData(host.width, host.height);
			bitmap9grid = new BitmapScale9Grid(new _upClas(), 5, 25, 5, 65);
			bitmap9grid.width = host._width;
			bitmap9grid.height = host._height;
			bitmap9grid.refurbishSize();

			bitdata.draw(bitmap9grid);
			_up.bitmapData = bitdata;
			_up.cacheAsBitmap = true;
			//bitdata.dispose();
			
			bitdata = new BitmapData(host.width, host.height);
			bitmap9grid = new BitmapScale9Grid(new _overClas(), 5, 25, 5, 65);
			bitmap9grid.width = host.width;
			bitmap9grid.height = host.height;
			bitmap9grid.refurbishSize();
			
			bitdata.draw(bitmap9grid);
			_over.bitmapData = bitdata;
			_over.cacheAsBitmap = true;
			//bitdata.dispose();
			
			host._back.addChild(_up);
			host._back.addChild(_over);
			_over.visible = false;*/

		}
		
		override public function draw():void 
		{
			/*super.draw();
			var host:PushButton = hostComponent as PushButton;
			
			host._label.text = host._labelText;
			host._label.autoSize = true;
			host._label.draw();
			if(host._label.width > host._width - 4)
			{
				host._label.autoSize = false;
				host._label.width = host._width - 4;
			}
			else
			{
				host._label.autoSize = true;
			}
			host._label.draw();
			host._label.move(host._width / 2 - host._label.width / 2, host.height / 2 - host._label.height / 2);*/
		}
		
		override public function btnStateChange(state:uint):void
		{
			var pb:PushButton = hostComponent as PushButton;
			switch(state)
			{
				case UIConst.EtBtnNormal:
					{
						_up.visible = true;
						_over.visible = false;
					}
					break;
				case UIConst.EtBtnDown:
					{
						_up.visible = false;
						_over.visible = true;
					}
					break;
				case UIConst.EtBtnOver:
					{
						_up.visible = true;
						_over.visible = false;
					}
					break;
				default:
					break;
			}
		}
	}
}
