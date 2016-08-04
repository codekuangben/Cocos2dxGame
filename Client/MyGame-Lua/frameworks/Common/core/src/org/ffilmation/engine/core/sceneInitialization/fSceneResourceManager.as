// RESOURCE MANAGER
package org.ffilmation.engine.core.sceneInitialization
{
	// Imports
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.ffilmation.engine.core.fEngine;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.core.fStopPointImport;
	import org.ffilmation.engine.events.fProcessEvent;
	import org.ffilmation.engine.helpers.fMaterialDefinition;
	import org.ffilmation.engine.helpers.fObjectDefinition;
	import org.ffilmation.engine.helpers.fUtil;
	
	/**
	 * The resource manager loads and stores all resources (material and objects definitions, media, etc) available to this scene
	 * IMPORTANT: All paths are relative to the path of the XML where the path is defined. This is mandatory because the standalone editor
	 * does not have a valid basepath
	 * @private
	 */
	public class fSceneResourceManager extends EventDispatcher
	{
		// Static properties
		
		/**
		 * An string describing the process of loading and processing scene resources.
		 * Events dispatched by the resource manager contain this String as a description of what is happening
		 */
		public static const LOADINGDESCRIPTION:String = "Loading resources";
		
		// Gets the absolute path for a path relative to a base XML file
		// KBEN:将相对于当前文件的路径转换成绝对路径，暂时还这样用，以后直接写绝对目录   
		public static function mergePaths(base:String, path:String):String
		{
			// Path is already absolute
			if (path.indexOf(":") >= 0)
				return path;
			
			// Path is relative
			base = base.split("\\").join("/");
			base = base.substr(0, base.lastIndexOf("/"));
			var p1:Array = base.split("/");
			var p2:Array = path.split("/");
			for (var i:int = 0; i < p2.length; i++)
			{
				if (p2[i] == ".")
				{
				}
				else if (p2[i] == "..")
				{
					if (p1.length > 0)
						p1.pop();
					else
						p1.push(p2[i]);
				}
				else
					p1.push(p2[i]);
			}
			
			var ret:String = p1.join("/");
			return ret;
		}
		
		// Private vars
		private var engine:fEngine;
		private var objectDefinitions:Object;
		// 地形模板文件就配置在这里
		private var materialDefinitions:Object;		// 现在这个是存放每一个场景的每一个材质，例如 materialDefinitions[sceneid][materialid]
		// KBEN: 实例化定义，相当于重载 objectDefinitions 中的一些属性，实现自定义   
		private var m_insDefinitions:Object;
		private var loadedFiles:Array;
		
		// Temporal
		private var mediaSrcs:Array;
		private var srcs:Array;
		private var src:String;
		private var queuePointer:Number;
		
		// 当前正在解析的场景
		public var m_curLoadingScene:fScene;
		
		// 加载的缩略图资源
		public var m_thumbnailsDict:Dictionary;
		// 阻挡点信息
		public var m_stopptDict:Dictionary;
		// 场景配置文件，不是魔板文件
		public var m_sceneFileDict:Dictionary;
		
		// Constructor
		public function fSceneResourceManager(e:fEngine):void
		{
			this.engine = e;
			this.objectDefinitions = new Object();
			this.materialDefinitions = new Object();
			this.m_insDefinitions = new Object();
			this.loadedFiles = new Array;
			m_thumbnailsDict = new Dictionary();
			m_stopptDict = new Dictionary();
			m_sceneFileDict = new Dictionary();
			
			// Media SWFs pending load are stored here
			this.mediaSrcs = new Array;
			
			// Definition files pending load are stored here
			this.srcs = new Array;
		}
		
		/**
		 * Retrieves a list of all material definition ids
		 */
		// 现在需要场景 id
		//public function getMaterials():Array
		public function getMaterials(sceneid:uint):Array
		{
			var ret:Array = new Array;
			//for (var i:String in this.materialDefinitions)
			for (var i:String in this.materialDefinitions[sceneid])
				ret.push(i);
			return ret;
		}
		
		/**
		 * Retrieves a list of all object definition ids
		 */
		public function getObjects():Array
		{
			var ret:Array = new Array;
			for (var i:String in this.objectDefinitions)
				ret.push(i);
			return ret;
		}
		
		/**
		 * This method is called to retrieve a material definition
		 */
		//public function getMaterialDefinition(id:String):fMaterialDefinition
		//{
		//	return this.materialDefinitions[id];
		//}
		public function getMaterialDefinition(sceneid:uint, id:String):fMaterialDefinition
		{
			return this.materialDefinitions[sceneid][id];
		}
		
		/**
		 * This method is called to retrieve an object definition
		 */
		public function getObjectDefinition(id:String):fObjectDefinition
		{
			return this.objectDefinitions[id];
		}
		
		// KBEN: 获取实例属性定义值   
		public function getInsDefinition(id:String):fObjectDefinition
		{
			return this.m_insDefinitions[id];
		}
		
		// KBEN: 添加实例化定义    
		public function addInsDefinition(def:fObjectDefinition):void
		{
			this.m_insDefinitions[def.name] = def;
		}
		
		/**
		 * This method adds resources from a given xml to the manager
		 *
		 * @param xmlObj Where to search for resource definitions
		 * @param basepath Path of the XML we are processing, so relative paths can be resolved
		 */
		public function addResourcesFrom(xmlObj:XML, basePath:String):void
		{
			// Only if this XML is not already loaded
			if (this.loadedFiles.indexOf(basePath) < 0)
			{
				this.loadedFiles.push(basePath);
				
				// Retrieve media files
				// KBEN: 感觉 materialDefinition 或者 objectDefinition 标签中应该加一个 media 属性，这样每一个 materialDefinition 或者 objectDefinition  都可以直接定义资源  
				var relativePath:String;
				var temp:XMLList = xmlObj.child("media");
				for (var i:Number = 0; i < temp.length(); i++)
				{
					relativePath = temp[i].@src;
					// 不用相对路径了，直接使用绝对目录 
					//var absolulePath:String = fSceneResourceManager.mergePaths(basePath, relativePath);
					//if (this.mediaSrcs.indexOf(absolulePath) < 0)
					//	this.mediaSrcs.push(absolulePath);
					if (this.mediaSrcs.indexOf(relativePath) < 0)
						this.mediaSrcs.push(relativePath);
				}
				
				// Retrieve Object definitions
				var defs:XMLList = xmlObj.child("objectDefinition");
				for (i = 0; i < defs.length(); i++)
				{
					// bug: copy() 可能导致的内存泄露
					//this.objectDefinitions[defs[i].@name] = new fObjectDefinition(defs[i].copy(), basePath);
					this.objectDefinitions[defs[i].@name] = new fObjectDefinition(defs[i], basePath);
					// KBEN: 材质对应的资源文件目录记录，材质不记录在这里了 
					// this.objectDefinitions[defs[i].@name].mediaPath = absolulePath;
				}
				
				// KBEN: 实例定义  
				defs = xmlObj.child("insDef");
				for (i = 0; i < defs.length(); i++)
				{
					// bug: copy() 可能导致的内存泄露
					//this.m_insDefinitions[defs[i].@name] = new fObjectDefinition(defs[i].copy(), basePath);
					this.m_insDefinitions[defs[i].@name] = new fObjectDefinition(defs[i], basePath);
				}
				
				// Retrieve Material definitions
				defs = xmlObj.child("materialDefinition");
				for (i = 0; i < defs.length(); i++)
				{
					//this.materialDefinitions[defs[i].@name] = new fMaterialDefinition(defs[i].copy(), basePath);
					if(!this.materialDefinitions[m_curLoadingScene.m_serverSceneID])
					{
						this.materialDefinitions[m_curLoadingScene.m_serverSceneID] = new Object();
					}
					//this.materialDefinitions[m_curLoadingScene.m_serverSceneID][defs[i].@name] = new fMaterialDefinition(defs[i].copy(), basePath);
					this.materialDefinitions[m_curLoadingScene.m_serverSceneID][defs[i].@name] = new fMaterialDefinition(defs[i], basePath);
					// KBEN: 材质对应的资源文件目录记录 
					//this.materialDefinitions[defs[i].@name].mediaPath = absolulePath;
				}
				
				// Retrieve nested definition files
				for (i = 0; i < xmlObj.child("definitions").length(); i++)
				{
					relativePath = xmlObj.child("definitions")[i].@src;
					// KBEN: 不是用相对目录，直接使用绝对目录    
					//absolulePath = fSceneResourceManager.mergePaths(basePath, relativePath);
					//if (this.srcs.indexOf(absolulePath) < 0)
					//	this.srcs.push(absolulePath);
					if (this.srcs.indexOf(relativePath) < 0)
						this.srcs.push(relativePath);
				}
			}
			
			this.loadDefinitionFiles();
		}
		
		// 增加阻挡点文件
		public function addStopPtFrom(bytes:ByteArray, basePath:String):void
		{
			// Only if this XML is not already loaded
			if (this.loadedFiles.indexOf(basePath) < 0)
			{
				this.loadedFiles.push(basePath);
				// 解析阻挡点文件
				//var impt:fStopPointImport = new fStopPointImport();
				//impt.importStopPoint(bytes, m_curLoadingScene);
			}
			
			this.loadDefinitionFiles();
		}
		
		// 增加地形缩略图
		public function addTerThumbnails(bmd:BitmapData, basePath:String):void
		{
			// Only if this XML is not already loaded
			if (this.loadedFiles.indexOf(basePath) < 0)
			{
				this.loadedFiles.push(basePath);
				// 处理地形缩略图文件
				//m_curLoadingScene.addTerThumbnails(bmd);
				//m_curLoadingScene.m_thumbnails = bmd;
			}
			
			this.loadDefinitionFiles();
		}
		
		// PRIVATE METHODS. NO NEED TO USE THEM EXTERNALLY
		
		private function loadDefinitionFiles():void
		{
			// If there are pending definition files, process them
			if (this.srcs.length > 0)
			{
				// Load
				//this.src = this.srcs.shift();
				//var url:URLRequest = new URLRequest(this.src);
				//var loadUrl:URLLoader = new URLLoader(url)
				//loadUrl.load(url);
				//loadUrl.addEventListener(ProgressEvent.PROGRESS, this.XMLloadProgress);
				//loadUrl.addEventListener(Event.COMPLETE, this.XMLloadComplete);
				//loadUrl.addEventListener(IOErrorEvent.IO_ERROR, this.XMLloadError);
				//this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, 0, "Loading definition file: " + this.src));
				var filename:String = this.srcs.shift();
				var type:int = fUtil.xmlResType(filename);
				this.src = this.engine.m_context.m_path.getPathByName(filename + ".swf", type);
				// 判断公用资源是否加载过，例如模型魔板，特效魔板
				if(type == EntityCValue.PHXMLCTPL)		// 人物模板
				{
					if(this.objectDefinitions['c1'])
					{
						if (this.loadedFiles.indexOf(this.src) < 0)
						{
							this.loadedFiles.push(this.src);
						}
						
						this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, 0, "Loading definition file: " + this.src));
						this.loadDefinitionFiles();
						return;
					}
				}
				else if(type == EntityCValue.PHXMLETPL)		// 特效模板
				{
					if(this.objectDefinitions['e0'])
					{
						if (this.loadedFiles.indexOf(this.src) < 0)
						{
							this.loadedFiles.push(this.src);
						}
						
						this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, 0, "Loading definition file: " + this.src));
						this.loadDefinitionFiles();
						return;
					}
				}
				else if(type == EntityCValue.PHXMLTTPL)		// 地形模板
				{
					if(this.materialDefinitions[this.m_curLoadingScene.m_serverSceneID])
					{
						if (this.loadedFiles.indexOf(this.src) < 0)
						{
							this.loadedFiles.push(this.src);
						}
						
						this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, 0, "Loading definition file: " + this.src));
						this.loadDefinitionFiles();
						return;
					}
				}
				else if(type == EntityCValue.PHSTOPPT)		// 阻挡点
				{
					if(this.m_stopptDict[this.m_curLoadingScene.m_serverSceneID])
					{
						if (this.loadedFiles.indexOf(this.src) < 0)
						{
							this.loadedFiles.push(this.src);
						}
						
						this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, 0, "Loading definition file: " + this.src));
						this.loadDefinitionFiles();
						return;
					}
				}
				else if(type == EntityCValue.PHTTB)		// 缩略图
				{
					if(this.m_thumbnailsDict[this.m_curLoadingScene.m_serverSceneID])
					{
						if (this.loadedFiles.indexOf(this.src) < 0)
						{
							this.loadedFiles.push(this.src);
						}
						
						this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, 0, "Loading definition file: " + this.src));
						this.loadDefinitionFiles();
						return;
					}
				}
				
				// 现在提前加载资源,肯定资源要不就加载了,要不就没有加载,还是全面考虑吧
				//var res:SWFResource = this.engine.m_context.m_resMgrNoProg.getResource(this.src, SWFResource) as SWFResource;
				var res:SWFResource = this.engine.m_context.m_resMgr.getResource(this.src, SWFResource) as SWFResource;
				if(!res)
				{
					//this.engine.m_context.m_resMgrNoProg.load(this.src, SWFResource, this.XMLloadCompleteNew, this.XMLloadErrorNew);
					this.engine.m_context.m_resMgr.load(this.src, SWFResource, this.XMLloadCompleteNew, this.XMLloadErrorNew);
				}
				else if(!res.isLoaded)
				{
					res.incrementReferenceCount();
					res.addEventListener(ResourceEvent.LOADED_EVENT, this.XMLloadCompleteNew);
					res.addEventListener(ResourceEvent.FAILED_EVENT, this.XMLloadErrorNew);
				}
				else if(!res.didFail)
				{
					res.incrementReferenceCount();
					XMLloadCompleteNewBySwf(res);
				}
				//this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, 0, "Loading definition file: " + this.src));
			}
			// KBEN: 资源文件启动的时候不加载了，直接发送加载完成消息      
			//else
			//{
				// If there are no definition files left, start loading media files
				//this.loadMediaFiles();
			//}
			else
			{
				//this.scene.m_dicDebugInfo["fSceneResourceManager::loadDefinitionFiles() dispatchEvent, Event.COMPLETE"] = true;
				//this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 100, fSceneResourceManager.LOADINGDESCRIPTION, 100, "All media files loaded"));
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		// Error loading current definition file
		//private function XMLloadError(event:IOErrorEvent):void
		//{
			//event.target.removeEventListener(ProgressEvent.PROGRESS, this.XMLloadProgress);
			//event.target.removeEventListener(Event.COMPLETE, this.XMLloadComplete);
			//event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.XMLloadError);
			//this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error loading file: " + this.src));
		//}
		
		private function XMLloadErrorNew(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, this.XMLloadCompleteNew);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, this.XMLloadErrorNew);
			this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error loading file: " + this.src));
			
			// 继续加载下一个资源
			//this.loadDefinitionFiles();
		}
		
		// Update status of current definition file
		//private function XMLloadProgress(event:ProgressEvent):void
		//{
			//var percent:Number = (event.bytesLoaded / event.bytesTotal);
			//this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, percent, "Loading definition file: " + this.src));
		//}
		
		// Definition file complete
		//private function XMLloadComplete(event:Event):void
		//{
			//this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, 100, "Loading definition file: " + this.src));
			//event.target.removeEventListener(ProgressEvent.PROGRESS, this.XMLloadProgress);
			//event.target.removeEventListener(Event.COMPLETE, this.XMLloadComplete);
			//event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.XMLloadError);
			//
			// Add resources (will continue loads if necessary)
			//this.addResourcesFrom(new XML(event.target.data), this.src);
		//}
		
		private function XMLloadCompleteNew(event:ResourceEvent):void
		{
			//this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, 100, "Loading definition file: " + this.src));
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, this.XMLloadCompleteNew);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, this.XMLloadErrorNew);
			
			XMLloadCompleteNewBySwf(event.resourceObject as SWFResource);
		}
		
		private function XMLloadCompleteNewBySwf(resourceObject:SWFResource):void
		{
			// Add resources (will continue loads if necessary)
			var bytes:ByteArray;
			var bmd:BitmapData;
			var clase:String = fUtil.xmlResClase(resourceObject.filename);
			var res:SWFResource = resourceObject as SWFResource;
			try
			{
			if(clase.substr(0, 9) == "art.cfg.s")	// 非阻挡点都是 XML ，阻挡点是二进制文件
			{
				bytes = res.getExportedAsset(clase) as ByteArray;
				m_stopptDict[m_curLoadingScene.m_serverSceneID] = bytes;
				this.addStopPtFrom(bytes, this.src);
			}
			else if (clase.substr(0, 9) == "art.ttb.t")	// 地形缩略图
			{
				bmd = res.getExportedAsset(clase) as BitmapData;
				m_thumbnailsDict[m_curLoadingScene.m_serverSceneID] = bmd;
				this.addTerThumbnails(bmd, this.src);
			}
			else
			{
				bytes = res.getExportedAsset(clase) as ByteArray;
				// bug: 可能 XML 资源释放不了
				//this.addResourcesFrom(new XML(bytes.readUTFBytes(bytes.length)), this.src);
				var xml:XML = new XML(bytes.readUTFBytes(bytes.length));
				this.addResourcesFrom(xml, this.src);
				xml = null;
			}
			}
			catch (e:Error)
			{
				var strLog:String = "fSceneResourceManager::XMLloadCompleteNewBySwf"+resourceObject.filename;
				if (clase)
				{
					strLog += " clase="+clase;
				}
				
				strLog += e.getStackTrace();
				DebugBox.sendToDataBase(strLog);
				
			}
			// 释放这个资源
			//this.engine.m_context.m_resMgrNoProg.unload(resourceObject.filename, SWFResource);
			this.engine.m_context.m_resMgr.unload(resourceObject.filename, SWFResource);
		}
		
		// Start loading media files
		private function loadMediaFiles():void
		{
			// Read media files
			this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fSceneResourceManager.LOADINGDESCRIPTION, 0, "Loading media files"));
			
			// Listen to media load events
			this.queuePointer = -1;
			this.engine.addEventListener(fEngine.MEDIALOADCOMPLETE, this.loadComplete);
			this.engine.addEventListener(fEngine.MEDIALOADPROGRESS, this.loadProgress);
			this.engine.addEventListener(fEngine.MEDIALOADERROR, this.loadError);
			this.loadComplete(new Event("Dummy"));
		}
		
		// Error loading current definition file
		private function loadError(event:Event):void
		{
			this.engine.removeEventListener(fEngine.MEDIALOADCOMPLETE, this.loadComplete);
			this.engine.removeEventListener(fEngine.MEDIALOADPROGRESS, this.loadProgress);
			this.engine.removeEventListener(fEngine.MEDIALOADERROR, this.loadError);
			this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error loading " + this.src));
		}
		
		// Process loaded media file and load next one
		private function loadComplete(event:Event):void
		{
			this.queuePointer++;
			if (this.queuePointer < this.mediaSrcs.length)
			{
				// Load
				this.src = this.mediaSrcs[this.queuePointer]
				var current:Number = 100 * (this.queuePointer) / this.mediaSrcs.length;
				this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, current, fSceneResourceManager.LOADINGDESCRIPTION, current, "Loading media files ( current: " + this.src + "  ) "));
				
				this.engine.loadMedia(this.src);
			}
			else
			{
				// All loaded
				this.mediaSrcs = new Array;
				this.engine.removeEventListener(fEngine.MEDIALOADCOMPLETE, this.loadComplete);
				this.engine.removeEventListener(fEngine.MEDIALOADPROGRESS, this.loadProgress);
				this.engine.removeEventListener(fEngine.MEDIALOADERROR, this.loadError);
				this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 100, fSceneResourceManager.LOADINGDESCRIPTION, 100, "All media files loaded"));
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		// Update status of current media file
		private function loadProgress(event:ProgressEvent):void
		{
			var percent:Number = (event.bytesLoaded / event.bytesTotal);
			var current:Number = 100 * (this.queuePointer + percent) / this.mediaSrcs.length;
			this.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, current, fSceneResourceManager.LOADINGDESCRIPTION, 100 * percent, "Loading media files ( current: " + this.src + "  ) "));
		}
		
		// 初始化阻挡点信息
		public function initStoppt():void
		{
			// 解析阻挡点文件
			if(m_stopptDict[m_curLoadingScene.m_serverSceneID])
			{
				var impt:fStopPointImport = new fStopPointImport();
				impt.importStopPoint(m_stopptDict[m_curLoadingScene.m_serverSceneID], m_curLoadingScene);
			}
		}
		
		// 初始化缩略图
		public function initthumbnail():void
		{
			if(m_thumbnailsDict[m_curLoadingScene.m_serverSceneID])
			{
				m_curLoadingScene.m_thumbnails = m_thumbnailsDict[m_curLoadingScene.m_serverSceneID];
			}
		}
		
		// 清理加载一个地形过程中的内存
		public function clearTmp():void
		{
			this.loadedFiles.length = 0;
			this.mediaSrcs.length = 0;
			this.srcs.length = 0;
		}
		
		// 释放给场景有关的资源
		public function disposeScene(sceneid:uint):void
		{
			// 地形材质
			var keylist:Vector.<String> = new Vector.<String>();
			var key:String;
			var idx:uint = 0;
			
			if(materialDefinitions[sceneid])
			{
				for(key in materialDefinitions[sceneid])
				{
					keylist.push(key);
				}
				
				while(idx < keylist.length)
				{
					materialDefinitions[sceneid][keylist[idx]] = null;
					delete materialDefinitions[sceneid][keylist[idx]];
					
					++idx;
				}
				
				keylist.length = 0;
				
				// 删除这个场景的 object
				materialDefinitions[sceneid] = null;
				delete materialDefinitions[sceneid];
			}			
			// 地形场景配置文件
			if(m_sceneFileDict[sceneid])
			{
				m_sceneFileDict[sceneid] = null;
				delete m_sceneFileDict[sceneid];
			}
			
			// 阻挡点文件
			if(m_stopptDict[sceneid])
			{
				m_stopptDict[sceneid] = null;
				delete m_stopptDict[sceneid];
			}
			
			// 缩略图文件
			if(m_thumbnailsDict[sceneid])
			{
				m_thumbnailsDict[sceneid].dispose();
				m_thumbnailsDict[sceneid] = null;
				delete m_thumbnailsDict[sceneid];
			}
		}
	}
}