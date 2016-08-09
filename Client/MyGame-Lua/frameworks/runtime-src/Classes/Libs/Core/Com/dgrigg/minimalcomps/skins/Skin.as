package com.dgrigg.minimalcomps.skins
{
	import com.bit101.components.Component;
	
	import com.dgrigg.image.Image;
	import com.pblabs.engine.resource.SWFResource;
	import common.event.UIEvent;
	
	//import flash.display.DisplayObject;
	//import flash.display.Sprite;
	//import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import common.Context;
	
	[DefaultProperty("children")]
	
	public class Skin
	{
		/* component associated to skin */
		protected var _imageName:String; //作用：仅是暂时记录图片名称
		protected var _imageNameAsKey:String; //作为CommonImageManager中的key值
		protected var _imageClass:Class;
		protected var _image:Image;
		protected var _hostComponent:Component;
		protected var _loadState:int;
		protected static var m_cont:Context;
		
		public function Skin()
		{
			_loadState = Image.None;
		}
		
		public static function setCont(cont:Context):void
		{
			m_cont = cont;
		}
		
		// 初始化    
		public function init():void
		{
		
		}
		
		// 绘制  
		public function draw():void
		{
		
		}
		
		public function setCommonImageByName(imageName:String):void
		{
			_imageNameAsKey = imageName;
			_imageName = imageName;
			_loadState = Image.Loading;
			Skin.m_cont.m_commonImageMgr.loadImage(imageName, _imageClass, onLoaded, onFailed);
		}
		
		public function setImageBySWF(swf:SWFResource, imageName:String):void
		{
			_imageNameAsKey = imageName;
			_imageName = imageName;
			this._image = Skin.m_cont.m_commonImageMgr.loadSWF(swf, _imageClass, imageName);
			onLoaded(_image);			
		}
		
		public function setImageMirror(imageName:String, mode:String):void
		{
			_imageNameAsKey = imageName + mode;
			_imageName = imageName;
			Skin.m_cont.m_commonImageMgr.loadModeImage(imageName, mode, _imageClass, onLoaded, onFailed)
		}
		
		public function setImageModeBySWF(swf:SWFResource, imageName:String, mode:String):Boolean
		{
			_imageNameAsKey = imageName + mode;
			_imageName = imageName;
			this._image = Skin.m_cont.m_commonImageMgr.loadModeSWF(swf, _imageClass, imageName, mode);
			onLoaded(_image);	
			return true;
		}
		
		//只有先得到image对象的情况下，才调用这个方法
		public function setImage(image:Image):void
		{
			_image = image;
			updateBitmapdata();
			onLoaded(_image);
		}
		
		public function get imageNoOR():Image	// protected function get image():ButtonImage 冲突
		{
			return _image;
		}
		
		public function dispose():void
		{
			if (_image != null)
			{
				Skin.m_cont.m_commonImageMgr.unLoad(_image.name);
				_image = null;
			}
			else if (_imageName != null)
			{
				Skin.m_cont.m_commonImageMgr.removeFun(_imageName, onLoaded, onFailed);
			}
		}
		
		// 卸载，负责清理自己的皮肤，包括自己添加的额外的内容        
		public function unInstall():void
		{
			if (_hostComponent.recycleSkins == false)
			{
				dispose();
			}
			_hostComponent = null;
		}
		
		public function set hostComponent(value:Component):void
		{
			_hostComponent = value;
			if (_image)
			{
				updateBitmapdata();
			}
		}
		
		public function get hostComponent():Component
		{
			return _hostComponent;
		}
		
		
		public function btnStateChange(state:uint):void
		{
		
		}
		
		protected function updateBitmapdata():void
		{
			
		}
		
		protected function onLoaded(resImage:Image):void
		{
			_imageName = null;
			_image = resImage;
			_loadState = Image.Loaded;
			updateBitmapdata();
			
			if (_hostComponent != null)
			{				
				_hostComponent.dispatchEvent(new UIEvent(UIEvent.IMAGELOADED, true, this));
			}
		}
		
		protected function onFailed(filename:String):void
		{
			_loadState = Image.Failed;
			//_hostComponent.dispatchEvent(new Event(Event.CANCEL));
			if (_hostComponent != null)
			{
				_hostComponent.dispatchEvent(new UIEvent(UIEvent.IMAGEFAILED, true, this));
			}
		}
		
		public function get width():int
		{
			return 0;
		}
		
		public function get height():int
		{
			return 0;
		}
		
		public function get loaded():Boolean
		{
			return _loadState == Image.Loaded;
		}
		
		public function get hasLoadResult():Boolean
		{
			return _loadState > Image.Loading;
		}
		public function get loadState():int
		{
			return _loadState;
		}
		public function get imageName():String
		{
			if (_image)
			{
				return _image.name;
			}
			return _imageNameAsKey;
		}		
	}
}