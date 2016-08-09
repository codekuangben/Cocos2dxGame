package org.ffilmation.engine.core.sceneInitialization
{
	// Imports
	import com.pblabs.engine.resource.SWFResource;
	import common.Context;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.interfaces.fEngineSceneRetriever;
	
	/**
	 * This is a retriever used to pass an XML object directly as scene constructor
	 * 这个类不再用了，所有资源都是动态加载的    
	 */
	public class fSceneFromXML extends EventDispatcher implements fEngineSceneRetriever
	{
		// Private vars
		private var xml:XML; // Definition data
		private var path:String;
		private var myTimer:Timer;
		
		// Constructor
		public function fSceneFromXML(xml:XML, path:String):void
		{
			this.xml = xml;
			this.path = path;
		}
		
		public function getServerSceneID():uint
		{
			return 0;
		}
		
		/**
		 * @private
		 * The scene will call this when it is ready to receive an scene. Then the engine will listen for a COMPLETE event
		 * before retrieving the final xml
		 */
		//public function start():EventDispatcher
		//{
			//this.myTimer = new Timer(20, 1);
			//this.myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.done);
			//this.myTimer.start();
			//return this;
		//}
		
		// 这个函数被我改的有问题了，这个类不要再用了  
		public function start(context:Context, scene:fScene):SWFResource
		{
			this.myTimer = new Timer(20, 1);
			this.myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.done);
			this.myTimer.start();
			
			return new SWFResource();
		}
		
		private function done(e:Event):void
		{
			this.myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.done);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * @private
		 * When this class dispatches a COMPLETE event, the scene will use this method to retrieve the XML definition
		 */
		public function getXML():XML
		{
			return this.xml;
		}
		
		/**
		 * @private
		 * The scene will use this method to retrieve the basepath for this XML. This basepath will be used to resolve paths inside this XML
		 */
		public function getBasePath():String
		{
			return this.path;
		}
		
		public function dispose():void
		{
			
		}
	}
}