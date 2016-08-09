package com.dgrigg.skins
{
	//import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.dgrigg.minimalcomps.skins.Skin;
	//import com.dgrigg.utils.SkinManager;
	//import com.dgrigg.utils.UIConst;
	import flash.display.Bitmap;
	import flash.text.TextFieldType;
	
	public class TextImageSkin extends Skin
	{
		protected var _backgroundImage:Bitmap;
		
		//[Embed(source="/assets/images/text-input-background.png", scaleGridLeft="1", scaleGridTop="10", scaleGridRight="277", scaleGridBottom="20")]
		//protected var _backgroundImageClas:Class;
		
		public function TextImageSkin()
		{
			super();
		}
		
		override public function init():void
		{
			var host:Text = hostComponent as Text;
			//host._panel.skin = SkinManager.getUISkin(UIConst.UISPanelImage);
		}
		
		override public function draw():void 
		{			
			var host:Text = hostComponent as Text;
			super.draw();
			
			//host._panel.setSize(host._width, host._height);
			//host._panel.draw();
			
			host._tf.width = host._width - 4;
			host._tf.height = host._height - 4;
			if(host._html)
			{
				host._tf.htmlText = host._text;
			}
			else
			{
				host._tf.text = host._text;
			}
			if(host._editable)
			{
				host._tf.mouseEnabled = true;
				host._tf.selectable = true;
				host._tf.type = TextFieldType.INPUT;
			}
			else
			{
				host._tf.mouseEnabled = host._selectable;
				host._tf.selectable = host._selectable;
				host._tf.type = TextFieldType.DYNAMIC;
			}
			host._tf.setTextFormat(host._format);
		}
	}
}