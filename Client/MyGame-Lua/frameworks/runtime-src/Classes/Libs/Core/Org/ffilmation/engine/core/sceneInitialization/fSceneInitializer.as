// SCENE INITIALIZER
package org.ffilmation.engine.core.sceneInitialization
{
	// Imports
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import org.ffilmation.engine.core.fElement;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.events.fProcessEvent;
	import org.ffilmation.engine.interfaces.fEngineSceneRetriever;
	
	/**
	 * <p>The fSceneInitializer class does all the job of creating an scene from an XML file.
	 * It uses all the classes in this package</p>
	 *
	 * @private
	 */
	public class fSceneInitializer
	{
		// Private properties
		private var scene:fScene;
		private var retriever:fEngineSceneRetriever;
		private var xmlObj:XML;
		//private var waitFor:EventDispatcher;
		private var waitFor:SWFResource;
		private var myTimer:Timer;
		private var sceneGridSorter:fSceneGridSorter;
		
		// Constructor
		public function fSceneInitializer(scene:fScene, retriever:*)
		{
			this.scene = scene;
			this.retriever = retriever;
		}
		
		// Start initialization process
		//public function start():void
		//{
			//if (this.retriever)
			//{
				//this.waitFor = this.retriever.start();
				//this.waitFor.addEventListener(Event.COMPLETE, this.loadListener);
				//this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fScene.LOADINGDESCRIPTION, 0, this.scene.stat));
			//}
		//}
		
		public function start():void
		{
			this.scene.m_dicDebugInfo["fSceneInitializer::start()"] = true;
			if (this.retriever)
			{
				this.scene.m_dicDebugInfo["fSceneInitializer::start() =1"] = true;
				this.waitFor = this.retriever.start(this.scene.engine.m_context, this.scene);
				if(!this.waitFor)	// 说明资源已经加载
				{
					this.scene.m_dicDebugInfo["fSceneInitializer::start() =10"] = true;
					this.xmlObj = this.retriever.getXML();
					this.initialization_Part1();
				}
				else
				{
					this.scene.m_dicDebugInfo["fSceneInitializer::start() =20"] = true;
					if((this.retriever as fSceneLoader).m_terFileLoaded)
					{
						this.scene.m_dicDebugInfo["fSceneInitializer::start() =21"] = true;
						(this.retriever as fSceneLoader).m_terFileLoaded = false;
						loadListener(new ResourceEvent(ResourceEvent.LOADED_EVENT, this.waitFor));
					}
					else
					{
						this.scene.m_dicDebugInfo["fSceneInitializer::start() =22"] = true;
						// 添加引用计数
						//this.waitFor.incrementReferenceCount();
						this.waitFor.addEventListener(ResourceEvent.LOADED_EVENT, loadListener);
					}
					// bug: 如果资源有的话，才能有进度消息，不发送加载进度
					//this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fScene.LOADINGDESCRIPTION, 0, this.scene.stat));
				}
				//this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 0, fScene.LOADINGDESCRIPTION, 0, this.scene.stat));
			}
		}
		
		// LOAD: Scene xml load event
		//private function loadListener(evt:Event):void
		//{
			//this.waitFor.removeEventListener(Event.COMPLETE, this.loadListener);
			//this.waitFor = null;
			//this.xmlObj = this.retriever.getXML();
			//this.initialization_Part1();
		//}
		
		private function loadListener(event:ResourceEvent):void
		{
			this.waitFor.removeEventListener(ResourceEvent.LOADED_EVENT, this.loadListener);
			// 卸载资源，地图资源在过场景的时候同意卸载
			//this.scene.engine.m_context.m_resMgrNoProg.unload(this.waitFor.filename, SWFResource);
			this.scene.engine.m_context.m_resMgr.unload(this.waitFor.filename, SWFResource);
			this.waitFor = null;
			this.xmlObj = this.retriever.getXML();
			// 保存到资源管理器中
			this.scene.engine.m_context.m_sceneResMgr.m_sceneFileDict[this.scene.m_serverSceneID] = this.xmlObj;
			
			this.initialization_Part1();
			
			// 保存到资源管理器中
			//this.scene.engine.m_context.m_sceneResMgr.m_sceneFileDict[this.scene.m_serverSceneID] = this.xmlObj;
		}
		
		// Part 1 of scene initialization is loading definitions
		private function initialization_Part1():void
		{
			//this.scene.resourceManager = new fSceneResourceManager(this.scene);
			// 记录当前加载的场景
			this.scene.engine.m_context.m_sceneResMgr.m_curLoadingScene = this.scene;
			//this.scene.engine.m_context.m_sceneResMgr.addEventListener(fScene.LOADPROGRESS, this.part1Progress);
			this.scene.engine.m_context.m_sceneResMgr.addEventListener(Event.COMPLETE, this.part1Complete);
			this.scene.engine.m_context.m_sceneResMgr.addEventListener(ErrorEvent.ERROR, this.part1Error);
			
			this.scene.m_dicDebugInfo["fSceneInitializer::initialization_Part1()"] = true;
			if (this.retriever)
			{
				this.scene.m_dicDebugInfo["fSceneInitializer::initialization_Part1() path= "+this.retriever.getBasePath()] = true;
				this.scene.engine.m_context.m_sceneResMgr.addResourcesFrom(this.xmlObj.head[0], this.retriever.getBasePath());
			}
			else
				this.scene.engine.m_context.m_sceneResMgr.addResourcesFrom(this.xmlObj.head[0], "");
		}
		
		private function part1Error(evt:ErrorEvent):void
		{
			//this.scene.engine.m_context.m_sceneResMgr.removeEventListener(fScene.LOADPROGRESS, this.part1Progress);
			this.scene.engine.m_context.m_sceneResMgr.removeEventListener(Event.COMPLETE, this.part1Complete);
			this.scene.engine.m_context.m_sceneResMgr.removeEventListener(ErrorEvent.ERROR, this.part1Error);
			
			this.scene.dispatchEvent(evt);
		}
		
		private function part1Progress(evt:fProcessEvent):void
		{
			this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, evt.overall / 2, fScene.LOADINGDESCRIPTION, evt.overall, evt.currentDescription));
		}
		
		// KBEN: 这个完成后说明资源文件解析完了，但是 swf 资源文件没有加载 
		private function part1Complete(evt:Event):void
		{
			this.scene.m_dicDebugInfo["fSceneInitializer::part1Complete()"] = true;
			// 清理加载中产生的临时内容
			this.scene.engine.m_context.m_sceneResMgr.clearTmp();
			
			//this.scene.engine.m_context.m_sceneResMgr.removeEventListener(fScene.LOADPROGRESS, this.part1Progress);
			this.scene.engine.m_context.m_sceneResMgr.removeEventListener(Event.COMPLETE, this.part1Complete);
			this.scene.engine.m_context.m_sceneResMgr.removeEventListener(ErrorEvent.ERROR, this.part1Error);
			this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 50, fScene.LOADINGDESCRIPTION, 50, "Parsing XML"));
			
			// Next step
			//this.myTimer = new Timer(200, 1);
			//this.myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part2);
			//this.myTimer.start();
			
			this.initScene();
		}
		
		/*
		// Part 2 of scene initialization is parsing the global parameters and geometry of the scene
		private function initialization_Part2(e:Event):void
		{
			this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part2);
			
			try
			{
				fSceneXMLParser.parseSceneGeometryFromXML(this.scene, this.xmlObj);
				// 阻挡点
				this.scene.engine.m_context.m_sceneResMgr.initStoppt();
				// 缩略图
				this.scene.engine.m_context.m_sceneResMgr.initthumbnail();
			}
			catch (e:Error)
			{
				this.scene.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Scene error in geometry: " + e));
			}
			this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 50, fScene.LOADINGDESCRIPTION, 0, "Parsing XML. Done."));
			
			// Next step
			this.myTimer = new Timer(200, 1);
			//this.myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part3);
			this.myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part5);
			this.myTimer.start();
		}
		
		// Part 3 of scene initialization is zSorting
		private function initialization_Part3(e:Event):void
		{
			this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part3);
			
			// Build RTrees
			// KBEN: 树形裁剪有 bug ，没时间查，改成矩形裁剪
			//fSceneRTreeBuilder.buildTrees(this.scene);
			
			// Start zSort
			this.sceneGridSorter = new fSceneGridSorter(this.scene);
			this.sceneGridSorter.addEventListener(fScene.LOADPROGRESS, this.part3Progress);
			this.sceneGridSorter.addEventListener(Event.COMPLETE, this.part3Complete);
			this.sceneGridSorter.createGrid();
			//this.sceneGridSorter.start();
		}
		
		private function part3Progress(evt:fProcessEvent):void
		{
			this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 50 + 30 * evt.overall / 100, fScene.LOADINGDESCRIPTION, evt.overall, evt.overallDescription));
		}
		
		private function part3Complete(evt:Event):void
		{
			this.sceneGridSorter.removeEventListener(fScene.LOADPROGRESS, this.part3Progress);
			this.sceneGridSorter.removeEventListener(Event.COMPLETE, this.part3Complete);
			this.sceneGridSorter = null;
			this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 80, fScene.LOADINGDESCRIPTION, 100, "Z sorting done."));
			
			// Next step
			this.myTimer = new Timer(200, 1);
			//this.myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part4);
			this.myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part5);
			this.myTimer.start();
		}
		
		// Collision and occlusion
		// KBEN: 这个碰撞不需要了
		private function initialization_Part4(event:TimerEvent):void
		{
			this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part4);
			this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 90, fScene.LOADINGDESCRIPTION, 100, "Calculating collision and occlusion grid."));
			
			//fSceneCollisionParser.calculate(this.scene);
			// KBEN: 这里重复两次，注释掉   
			// fSceneOcclusionParser.calculate(this.scene);
			
			// Next step
			this.myTimer = new Timer(200, 1);
			this.myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part5);
			this.myTimer.start();
		}
		
		// Setup initial lights, render everything
		private function initialization_Part5(event:TimerEvent):void
		{
			this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part5);
			
			// Environment and lights
			try
			{
				this.sceneGridSorter = new fSceneGridSorter(this.scene);
				this.sceneGridSorter.createGrid();
				
				fSceneXMLParser.parseSceneEnvironmentFromXML(this.scene, this.xmlObj);
			}
			catch (e:Error)
			{
				this.scene.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Scene error in environment: " + e));
			}
			
			// KBEN: 事件就不解析了
			// Events
			//try
			//{
			//	fSceneXMLParser.parseSceneEventsFromXML(this.scene, this.xmlObj);
			//}
			//catch (e:Error)
			//{
			//	this.scene.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Scene error in event definition: " + e));
			//}
			
			// Prepare characters
			var cl:int = this.scene.characters.length;
			for (var j:Number = 0; j < cl; j++)
			{
				this.scene.characters[j].cell = this.scene.translateToCell(this.scene.characters[j].x, this.scene.characters[j].y, this.scene.characters[j].z);
				this.scene.characters[j].addEventListener(fElement.NEWCELL, this.scene.processNewCell);
				this.scene.characters[j].addEventListener(fElement.MOVE, this.scene.renderElement);
			}
			
			//KBEN: 控制器也不需要了
			// Create controller for this scene, if any was specified in the XML
			//try
			//{
			//	fSceneXMLParser.parseSceneControllerFromXML(this.scene, this.xmlObj);
			//}
			//catch (e:Error)
			//{
			//	//this.scene.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Scene contains an invalid controller definition. "+e))
			//	trace("Scene contains an invalid controller definition. " + e);
			//}
			
			this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 95, fScene.LOADINGDESCRIPTION, 100, "Rendering..."))
			
			// Next step
			this.myTimer = new Timer(200, 1);
			this.myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Complete);
			this.myTimer.start();
		}
		
		// Complete process, mark scene as ready. We are done !
		private function initialization_Complete(event:TimerEvent):void
		{
			this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Complete);
			
			// KBEN:
			this.sceneGridSorter = null;
			
			// Update status
			this.scene.stat = "Ready";
			this.scene.ready = true;
			
			// Dispatch completion event
			this.scene.dispatchEvent(new fProcessEvent(fScene.LOADCOMPLETE, 100, fScene.LOADINGDESCRIPTION, 100, this.scene.stat));
			
			// Free all resources allocated by this Object, to help the Garbage collector
			this.dispose();
		}
		*/
		
		// 单步运行改成一次完成
		private function initScene():void
		{
			this.scene.m_dicDebugInfo["fSceneInitializer::initScene()Begin"] = true;
			try
			{
				fSceneXMLParser.parseSceneGeometryFromXML(this.scene, this.xmlObj);
				// 阻挡点
				this.scene.engine.m_context.m_sceneResMgr.initStoppt();
				// 缩略图
				this.scene.engine.m_context.m_sceneResMgr.initthumbnail();
			}
			catch (e:Error)
			{
				this.scene.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Scene error in geometry: " + e));
			}
			this.scene.dispatchEvent(new fProcessEvent(fScene.LOADPROGRESS, 50, fScene.LOADINGDESCRIPTION, 0, "Parsing XML. Done."));
			
			this.scene.m_dicDebugInfo["fSceneInitializer::initScene() new"] = true;
			// Environment and lights
			try
			{
				this.sceneGridSorter = new fSceneGridSorter(this.scene);
				this.sceneGridSorter.createGrid();
				
				fSceneXMLParser.parseSceneEnvironmentFromXML(this.scene, this.xmlObj);
			}
			catch (e:Error)
			{
				this.scene.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Scene error in environment: " + e));
			}
			
			// Prepare characters
			var cl:int = this.scene.characters.length;
			for (var j:Number = 0; j < cl; j++)
			{
				this.scene.characters[j].cell = this.scene.translateToCell(this.scene.characters[j].x, this.scene.characters[j].y, this.scene.characters[j].z);
				this.scene.characters[j].addEventListener(fElement.NEWCELL, this.scene.processNewCell);
				this.scene.characters[j].addEventListener(fElement.MOVE, this.scene.renderElement);
			}
			
			// KBEN:
			this.sceneGridSorter = null;
			
			// Update status
			this.scene.stat = "Ready";
			// 在这里设置 ready 信号，硕菁场景已经可以进入了
			this.scene.ready = true;
			
			// Dispatch completion event
			this.scene.dispatchEvent(new fProcessEvent(fScene.LOADCOMPLETE, 100, fScene.LOADINGDESCRIPTION, 100, this.scene.stat));
			
			// Free all resources allocated by this Object, to help the Garbage collector
			this.dispose();
		}
		
		// Stops all processes and frees resources
		public function dispose():void
		{
			if (this.waitFor)
			{
				this.waitFor.removeEventListener(Event.COMPLETE, this.loadListener);
				this.waitFor = null;
			}
			
			if (this.scene)
			{
				this.scene.engine.m_context.m_sceneResMgr.removeEventListener(fScene.LOADPROGRESS, this.part1Progress);
				this.scene.engine.m_context.m_sceneResMgr.removeEventListener(Event.COMPLETE, this.part1Complete);
				this.scene.engine.m_context.m_sceneResMgr.removeEventListener(ErrorEvent.ERROR, this.part1Error);
			}
			
			if (this.myTimer)
			{
				//this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part2);
				//this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part3);
				//this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part4);
				//this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Part5);
				//this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.initialization_Complete);
				this.myTimer = null;
			}
			
			if (this.sceneGridSorter)
			{
				//this.sceneGridSorter.removeEventListener(fScene.LOADPROGRESS, this.part3Progress);
				//this.sceneGridSorter.removeEventListener(Event.COMPLETE, this.part3Complete);
				this.sceneGridSorter = null;
			}
			
			if(this.scene)
			{
				this.scene.engine.m_context.m_sceneResMgr.m_curLoadingScene = null;
				this.scene = null;
			}
			if (this.retriever)
			{
				this.retriever.dispose();
				this.retriever = null;
			}
			if(this.xmlObj)
			{
				this.xmlObj = null;
			}
		}
	}
}