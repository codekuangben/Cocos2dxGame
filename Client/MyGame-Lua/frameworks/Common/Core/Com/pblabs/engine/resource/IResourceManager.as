package com.pblabs.engine.resource 
{
	import com.pblabs.engine.resource.provider.IResourceProvider;
	import flash.system.LoaderContext;
	/**
	 * @brief 资源接口 
	 */
	public interface IResourceManager 
	{
        /**
         * Loads a resource from a file. If the resource has already been loaded or is embedded, a
         * reference to the existing resource will be given. The resource is not returned directly
         * since loading is asynchronous. Instead, it will be passed to the function specified in
         * the onLoaded parameter. Even if the resource has already been loaded, it cannot be
         * assumed that the callback will happen synchronously.
         * 
         * <p>This will not attempt to load resources that have previously failed to load. Instead,
         * the load will fail instantly.</p>
         * 
         * @param filename The url of the file to load.
         * @param resourceType The Resource subclass specifying the type of resource that is being
         * requested.
         * @param onLoaded A function that will be called on successful load of the resource. The
         * function should take a single parameter of the type specified in the resourceType
         * parameter.
         * @param onFailed A function that will be called if loading of the resource fails. The
         * function should take a single parameter of the type specified in the resourceType
         * parameter. The resource passed to the function will be invalid, but the filename
         * property will be correct.
         * @param forceReload Always reload the resource, even if it has already been loaded.
         * 
         * @see Resource
         */
        function load(filename:String, resourceType:Class, onLoaded:Function = null, onFailed:Function = null, onProgress:Function = null, onStarted:Function = null, forceReload:Boolean = false, context:LoaderContext=null):Resource;
        
        /**
         * Unloads a previously loaded resource. This does not necessarily mean the resource
         * will be available for garbage collection. Resources are reference counted so if
         * the specified resource has been loaded multiple times, its reference count will
         * only decrease as a result of this.
         * 
         * @param filename The url of the resource to unload.
         * @param resourceType The type of the resource to unload.
         */
        function unload(filename:String, resourceType:Class):void;
        
        /**
         * Provide a source for resources to the ResourceManager. Once added,
         * the ResourceManager will use this IResourceProvider to try to fulfill
         * resource load requests.
         *  
         * @param resourceProvider Provider to add.
         * @see IResourceProvider
         */
        function registerResourceProvider(resourceProvider:IResourceProvider):void;
        
        /**
         * Check if a resource is loaded and ready to go. 
         * @param filename Same as request to load()
         * @param resourceType Same as request to load().
         * @return True if resource is loaded.
         */
		function isLoaded(filename:String, resourceType:Class):Boolean;
		
		/**
		 * Provides a resource if it is known. could be that it is not loaded yet.  
		 * @param filename Same as request to load()
		 * @param resourceType Same as request to load().
		 * @return resource
		 */
		function getResource(filename:String, resourceType:Class):Resource;
	}
}