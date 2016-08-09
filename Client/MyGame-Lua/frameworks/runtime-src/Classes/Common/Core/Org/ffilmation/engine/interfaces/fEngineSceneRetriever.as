package org.ffilmation.engine.interfaces
{
	// Imports
	import com.pblabs.engine.resource.SWFResource;
	import common.Context;
	import org.ffilmation.engine.core.fScene;
	
	/**
	 * This interface defines methods that any class that is to be used to retrieve an scene XML must implement.
	 * I'm using this interface definition rather that simply loading an XML because this allows to create custom classes
	 * that generate random maps, for example.
	 */
	public interface fEngineSceneRetriever
	{
		/**
		 * The scene will call this when it is ready to receive an scene. Then the engine will listen for a COMPLETE event
		 * of the returned object before retrieving the final xml
		 */
		//function start():EventDispatcher;
		function start(context:Context, scene:fScene):SWFResource;
		
		/**
		 * The scene will use this method to retrieve the XML definition once when a COMPLETE event is triggered
		 */
		function getXML():XML;
		
		/**
		 * The scene will use this method to retrieve the basepath for this XML. This basepath will be used to resolve paths inside this XML
		 */
		function getBasePath():String;
		function dispose():void;
		
		// 获取服务器场景 id
		function getServerSceneID():uint;
	}
}