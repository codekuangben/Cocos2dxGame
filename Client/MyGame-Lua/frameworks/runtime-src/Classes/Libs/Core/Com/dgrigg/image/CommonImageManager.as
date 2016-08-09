package com.dgrigg.image
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	//import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import com.dgrigg.image.*;
	import com.dgrigg.image.ImageButtonVertical;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	import common.Context;

	
	//import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceProgressEvent;
	
	public class CommonImageManager extends EventDispatcher
	{
		// 自动以事件
		public static const CICEVENT:String = "CommonImageManagerEvent";
		
		//[Embed(source = "../../../../../../../bin/table/uicfg.xml", mimeType = "application/octet-stream")]
		[Embed(source="commonimage.xml",mimeType="application/octet-stream")]
		protected var m_asset:Class;
		
		private var m_context:Context;
		private var m_resource:SWFResource;
		private var m_ImageDic:Dictionary;
		private var m_dicLoadParam:Dictionary;
		
		public function CommonImageManager(context:Context)
		{
			m_context = context;
			m_ImageDic = new Dictionary();
			m_dicLoadParam = new Dictionary();
			//m_context.m_resMgr.load(toPathString("commonswf/commonimage.swf"), SWFResource, onLoaded, onFailed);
		}
		
		public function load():void
		{
			m_context.m_resMgr.load(toPathString("commonswf/commonimage.swf"), SWFResource, onLoaded, onFailed, onProgress, onStarted);
		}
		
		//---玩家登陆，集体下载一批图片
		//加载commonswf/commonimage.swf完成后，调用此函数
		private function onLoaded(event:ResourceEvent):void
		{
			var res:SWFResource = event.resourceObject as SWFResource;
			res.removeEventListener(ResourceEvent.LOADED_EVENT, onLoaded);
			res.removeEventListener(ResourceEvent.FAILED_EVENT, onFailed);
			res.removeEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgress);
			res.removeEventListener(ResourceEvent.STARTED_EVENT, onStarted);

			var byteDataXml:ByteArray = new m_asset();
			var xml:XML = new XML(byteDataXml.readUTFBytes(byteDataXml.bytesAvailable));
			var images:XMLList;
			var imageXml:XML;
			images = xml.child("image");
			var type:String;
			var image:Image;
			var imageClass:Class;
			for each (imageXml in images)
			{
				type = imageXml.@type;
				if (type == "button")
				{
					imageClass = ButtonImage;					
				}
				else if (type == "buttonvertical")
				{
					imageClass = ImageButtonVertical;	
				}
				else if (type == "verticalimage")
				{
					imageClass = ImageVertical;	
				}
				else if (type == "panelimage")
				{
					imageClass = PanelImage;					
				}
				image = loadSWFDirect(res, imageClass, imageXml.@name)
				image.increase();
				m_ImageDic[image.name] = image;
			}
			
			
			m_context.setLoad(EntityCValue.PreloadRES_COMMONIMAGES);
			
			//this.dispatchEvent(new Event(CICEVENT));
			
			// 加载进度条
			//m_context.m_gkcontext.progResLoaded(res.filename);
			//m_context.m_gkcontext.startprogResLoaded(res.filename);
		}
		
		private function onFailed(event:ResourceEvent):void
		{
			var res:SWFResource = event.resourceObject as SWFResource;
			res.removeEventListener(ResourceEvent.LOADED_EVENT, onLoaded);
			res.removeEventListener(ResourceEvent.FAILED_EVENT, onFailed);
			res.removeEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgress);
			res.removeEventListener(ResourceEvent.STARTED_EVENT, onStarted);

			Logger.error(null, null, res.filename + " failed");
			
			// 加载进度条
			//m_context.m_gkcontext.progResFailed(res.filename);
			//m_context.m_gkcontext.startprogResFailed(res.filename);
		}
		
		private function onProgress(event:ResourceProgressEvent):void
		{
			//m_context.m_gkcontext.progResProgress(event.resourceObject.filename, event._percentLoaded);
		}
		
		private function onStarted(event:ResourceEvent):void
		{	
			// 加载进度条
			//m_context.m_gkcontext.progResStarted(event.resourceObject.filename);
		}
		
		//--------------------------------------------------
		public function getImage(name:String):Image
		{
			var image:Image = m_ImageDic[name] as Image;
			return image;
		}
		
		public function hasImage(name:String):Boolean
		{
			var image:Image = m_ImageDic[name] as Image;
			if (image != null)
			{
				if (image.loadState == Image.Loaded)
				{
					return true;
				}
			}
			return false;
		}
		
		//加载独立美术图片------------
		public function loadImage(resName:String, imageClass:Class, onLoaded:Function, onFailed:Function):void
		{
			var resImage:Image = m_ImageDic[resName]
			if (resImage)
			{
				if (onLoaded != null)
				{
					resImage.increase();
					onLoaded(resImage);
				}
				return;
			}
			
			var strPath:String = CommonImageManager.toPathString(resName);
			var set:LoadCommonSet = m_dicLoadParam[strPath];
			if (set != null)
			{
				set.add(null, onLoaded, onFailed);
				return;
			}
			//判断资源的类型(swf文件，或原始图片
			var resClass:Class;
			var loadedFun:Function;
			var failedFun:Function;
			if (resName.substr(resName.length - 4, 4) == ".swf")
			//if (imageClass == ButtonImage || imageClass == ImageForm || imageClass == ImageGrid9 || imageClass == ImageButtonGrid9 ||imageClass == ImageAni || imageClass == ImageList|| imageClass == ImageButtonHorizontal|| imageClass == ImageHorizontalRepeat)
			{
				resClass = SWFResource;
				loadedFun = onLoadedSWF;
				failedFun = onFailedSWFImage
			}
			else
			{
				resClass = ImageResource;
				loadedFun = onLoadedImage;
				failedFun = onFailedSWFImage;
			}
			
			set = new LoadCommonSet();
			set.m_resName = resName;
			set.m_imageClass = imageClass;
			m_dicLoadParam[strPath] = set;
			set.add(null, onLoaded, onFailed);
			
			m_context.m_resMgr.load(strPath, resClass, loadedFun, failedFun);
		}
		
		//加载独立美术图片，可以进行图片的镜像------------
		public function loadModeImage(resName:String, mode:String, imageClass:Class, onLoaded:Function, onFailed:Function):void
		{
			var newName:String = resName + mode;
			var resImage:Image = m_ImageDic[newName];
			if (resImage)
			{
				if (onLoaded != null)
				{
					resImage.increase();
					onLoaded(resImage);
				}
				return;
			} 
			resImage = m_ImageDic[resName];
			if (resImage)
			{
				resImage = resImage.mirrorImage(mode);
				if (onLoaded != null)
				{
					resImage.increase();
					onLoaded(resImage);
					m_ImageDic[resImage.name] = resImage;
				}
				return;
			}
			
			var strPath:String = CommonImageManager.toPathString(resName);
			var set:LoadCommonSet = m_dicLoadParam[strPath];
			if (set != null)
			{
				set.add(mode, onLoaded, onFailed);
				return;
			}
			
			set = new LoadCommonSet();
			set.m_resName = resName;
			set.m_imageClass = imageClass;
			m_dicLoadParam[strPath] = set;
			set.add(mode, onLoaded, onFailed);
			
			//判断资源的类型(swf文件，或原始图片
			var resClass:Class;
			var loadedFun:Function;
			var failedFun:Function;
			if (imageClass == ButtonImage || imageClass == ImageForm || imageClass == ImageGrid9 || imageClass == ImageButtonGrid9|| imageClass == ImageAni || imageClass == ImageList|| imageClass == ImageButtonHorizontal|| imageClass == ImageHorizontalRepeat)
			{
				resClass = SWFResource;
				loadedFun = onLoadedSWF;
				failedFun = onFailedSWFImage;
			}
			else
			{
				resClass = ImageResource;
				loadedFun = onLoadedImage;
				failedFun = onFailedSWFImage;
			}
			
			m_context.m_resMgr.load(strPath, resClass, loadedFun, failedFun);
		}
		public function removeFun(resName:String, onLoaded:Function, onFailed:Function):void
		{
			var strPath:String = CommonImageManager.toPathString(resName);
			var set:LoadCommonSet = m_dicLoadParam[strPath];
			if (set != null)
			{
				set.remove(onLoaded, onFailed);
			}
		}
		
		private function onLoadedImage(event:ResourceEvent):void
		{
			var resource:ImageResource = event.resourceObject as ImageResource;
			resource.removeEventListener(ResourceEvent.LOADED_EVENT, onLoadedImage);
			resource.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWFImage);
			var set:LoadCommonSet = m_dicLoadParam[resource.filename];
			if (set == null)
			{
				//这里没有m_context.m_resMgr中的资源
				return;
			}
			var resImage:Image = new set.m_imageClass();
			resImage.name = set.m_resName;
			resImage.parseBitmapData(resource.bitmapData);			
			
			delete m_dicLoadParam[resource.filename];
			onSingeImageLoaded(resImage, set);		
			
			m_context.m_resMgr.unload(resource.filename, ImageResource);
		}
						
		private function onLoadedSWF(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			resource.removeEventListener(ResourceEvent.LOADED_EVENT, onLoadedSWF);
			resource.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWFImage);
			var set:LoadCommonSet = m_dicLoadParam[resource.filename];
			if (set == null)
			{
				//这里没有m_context.m_resMgr中的资源
				return;
			}
			delete m_dicLoadParam[resource.filename];
			
			var resImage:Image = loadSWFDirect(resource, set.m_imageClass, set.m_resName);			
			onSingeImageLoaded(resImage, set);
			
			m_context.m_resMgr.unload(resource.filename, SWFResource);
		}
		
		private function onSingeImageLoaded(image:Image,set:LoadCommonSet):void
		{
			var i:int;
			var item:LoadCommonItem;
			var list:Vector.<LoadCommonItem> = set.m_vecItem;
			var count:int = list.length;
			var modeImage:Image;
			for (i = 0; i < count; i++)
			{
				item = list[i];
				if (item.m_mode == null)
				{
					image.increase();
					modeImage = image;
				}
				else
				{
					modeImage = image.mirrorImage(item.m_mode);
				}
				m_ImageDic[modeImage.name] = modeImage;
				
				if (item.m_LoadedFun != null)
				{
					item.m_LoadedFun(modeImage);
				}	
		
			}
			set.m_vecItem.length = 0;
		}
		private function onFailedSWFImage(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onLoadedImage);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onFailedSWFImage);

			var set:LoadCommonSet = m_dicLoadParam[event.resourceObject.filename];
			if (set == null)
			{
				return;
			}
			
			var i:int;
			
			var count:int = set.m_vecItem.length;
			if (count > 0)
			{
				var item:LoadCommonItem;
				var ar:Vector.<LoadCommonItem> = set.m_vecItem.slice();
				for each(item in ar)
				{
					if (set.m_vecItem.indexOf(item) != -1)
					{
						item.m_FailedFun(set.m_resName);
					}					
				}
			}			
			
			delete m_dicLoadParam[event.resourceObject.filename];
		}
		//------------------------			
		public function loadSWF(resource:SWFResource, imageClass:Class, name:String):Image
		{
			var image:Image = m_ImageDic[name] as Image;
			if (image == null)
			{
				image = loadSWFDirect(resource, imageClass, name);
				m_ImageDic[name] = image;	
			}
			image.increase();	
			return image;
		}
		
		public function loadModeSWF(resource:SWFResource, imageClass:Class, name:String, mode:String):Image
		{
			var newName:String = name + mode;
			var image:Image = m_ImageDic[newName] as Image;
			if (image != null)
			{
				image.increase();	
				return image;
			}
			image = m_ImageDic[name] as Image;
			if (image == null)
			{
				image = loadSWFDirect(resource, imageClass, name);							
			}
				
			image = image.mirrorImage(mode);
			m_ImageDic[image.name] = image;				
			image.increase();
			return image;
		}
		
		//创建一个Image对象，并添加数据。引用计数增加1
		protected function loadSWFDirect(resource:SWFResource, imageClass:Class, name:String):Image
		{
			var resImage:Image = new imageClass();
			resImage.name = name;
			resImage.parseSWF(resource);			
			return resImage;
		}	
		
		public function unLoad(name:String):void
		{
			var image:Image = m_ImageDic[name] as Image;
			if (image != null)
			{
				image.decrease();
				if (image.useCount == 0)
				{
					delete m_ImageDic[name];
				}
			}
		}
		public function addImage(swf:SWFResource, resName:String, imageClass:Class, mode:String=null):Image
		{
			var newName:String
			if (mode)
			{
				newName = resName + mode;
			}
			else
			{
				newName = resName;
			}
			
			var image:Image = m_ImageDic[resName] as Image;
			if (image)
			{
				image.increase();
				return image;				
			}
			
			image = new imageClass();
			image.name = resName;
			image.parseSWF(swf);
			
			if (mode)
			{
				image = image.mirrorImage(mode);
			}
			image.increase();
			m_ImageDic[resName] = image;
			return image;
		}
		
		public static function toPathString(resName:String):String
		{			
			return ("asset/uiimage/" + resName);
		}
	
	}

}