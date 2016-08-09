package com.pblabs.engine.resource.provider
{
    import com.pblabs.engine.resource.Resource;
	import flash.system.LoaderContext;
    
    /**
     * This interface should be implemented by objects that can provide resources
     * to the resourceManager
     */
    public interface IResourceProvider
    {
        /**
         * This method is called when the ResourceManager gets a load request
         * for a resource and will check all known ResourceProviders if it has
         * the specific resource
         */
        function isResourceKnown(uri:String, type:Class):Boolean;

        /**
         * This method is called when the ResourceManager requests a known
         * resource from a ResourceProvider
         */
        function getResource(uri:String, type:Class, forceReload:Boolean = false, ver:String = "", context:LoaderContext=null):Resource;
		
		/**
		 * This method is called when the ResourceManager has no references to a specific resource
		 * and wants to unload the resource.
		 */
		function unloadResource(uri:String, type:Class):void;
		function registerResource(filename:String, resourceType:Class, data:*):void;
    }
}