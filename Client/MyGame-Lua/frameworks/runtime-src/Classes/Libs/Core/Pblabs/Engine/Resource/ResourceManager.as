package com.pblabs.engine.resource
{
    import com.pblabs.engine.debug.Logger;
    import com.pblabs.engine.resource.provider.IResourceProvider;
    import com.pblabs.engine.serialization.TypeUtility;
    import com.util.PBUtil;
	import flash.system.LoaderContext;
    
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    
    import common.Context;
    //import common.config.VersionInfo;

    /**
     * The resource manager handles all tasks related to using asset files (images, xml, etc)
     * in a project. This includes loading files, managing embedded resources, and cleaninp up
     * resources no longer in use.
     */
    public class ResourceManager implements IResourceManager
    {
        public static const RESOURCE_KEY_SPLITTER:String = "|*|";

        /**
         * If true, we will never get resources from outside the SWF - only resources
         * that have been properly embedded and registered with the ResourceManager
         * will be used.
         */
        public var onlyLoadEmbeddedResources:Boolean = false;
        
        /**
         * Function that will be called if OnlyLoadEmbeddedResources is set and we
         * fail to find something. Useful for displaying feedback for artists (such
         * as via a dialog box ;). Passed the filename of the requested resource.
         */
        public var onEmbeddedFail:Function;
		
		//public var m_RPType:uint;		// 资源加载器类型
		
		// KBEN: 构造函数，主要传递上下文
		public function ResourceManager(context:Context)
        {
			m_context = context;
        }

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
        public function load(filename:String, resourceType:Class, onLoaded:Function = null, onFailed:Function = null, onProgress:Function = null, onStarted:Function = null, forceReload:Boolean = false, context:LoaderContext=null):Resource
        {
            // Sanity!
            if(filename == null || filename == "")
            {
                Logger.error(this, "load", "Cannot load a " + resourceType + " with empty filename.");
                return null;
            }			
		
			// 暂时改动，修改添加版本
			var version:String = "";
			version = m_context.m_verInfoFun(filename);
			if(version && version.length)
			{
				version = ('v=' + version);
			}
			else
			{
				var idx:int = filename.indexOf('?');
				if(idx != -1)
				{
					version = filename.substring(idx + 1, filename.length);
					filename = filename.substring(0, idx);
				}
			}
			
			if(forceReload)	// 强制从新加载
			{
				version = "v=" + new Date() + Math.random();
			}
            
            // Look up the resource.
            var resourceIdentifier:String = getResourceIdentifier(filename, resourceType);
            var resource:Resource = _resources[resourceIdentifier];
            
            // If it was loaded and we want to force a reload, do that.
            if (resource && forceReload)
            {
                _resources[resourceIdentifier] = null;
                delete _resources[resourceIdentifier];
                resource = null;
            }
            
            // If it wasn't loaded...
            if (!resource)
            {
                // Then it wasn't embedded, so error if we're configured for that. 
                //if(onlyLoadEmbeddedResources && !m_context.m_embeddedResourceProvider[m_RPType].isResourceKnown(filename, resourceType))
				if(onlyLoadEmbeddedResources && !m_context.m_embeddedResourceProvider.isResourceKnown(filename, resourceType))
                {
                    var tmpR:Resource = new Resource();
                    tmpR.filename = filename;
                    tmpR.fail("not embedded in the SWF with type " + resourceType + ".");
                    fail(tmpR, onFailed, "'" + filename + "' was not loaded because it was not embedded in the SWF with type " + resourceType + ".");
                    if(onEmbeddedFail != null)
                        onEmbeddedFail(filename);
                    return null;
                }
                
                // Hack for MP3 and WAV files. TODO: Generalize this for arbitrary formats.
                var fileExtension:String = PBUtil.getFileExtension(filename).toLowerCase();
                if(resourceType == SoundResource && (fileExtension == "mp3" || fileExtension == "wav"))
                    resourceType = MP3Resource;
                
                // check available resource providers and request the resource if it is known
                for (var rp:int = 0; rp < resourceProviders.length; rp++)
                {
                    if ((resourceProviders[rp] as IResourceProvider).isResourceKnown(filename, resourceType))
                        resource  = (resourceProviders[rp] as IResourceProvider).getResource(filename, resourceType, forceReload);
                }
                
                // If we couldn't find a match, fall back to the default provider.
                if (!resource)
                    //resource = m_context.m_fallbackResourceProvider.getResource(filename, resourceType, forceReload);
					//resource = m_context.m_fallbackResourceProvider[m_RPType].getResource(filename, resourceType, forceReload, version);
					resource = m_context.m_fallbackResourceProvider.getResource(filename, resourceType, forceReload, version, context);
                
                // Make sure the filename is set.
                if(!resource.filename)
                    resource.filename = filename;
                
                // Store it in the resource dictionary.
                _resources[resourceIdentifier] = resource;
            }
            else if (!(resource is resourceType))
            {
                fail(resource, onFailed, "The resource " + filename + " is already loaded, but is of type " + TypeUtility.getObjectClassName(resource) + " rather than the specified " + resourceType + ".");
                return null;
            }
            
            // Deal with it if it already failed, already loaded, or if it is still pending.
            if (resource.didFail)
            {
                fail(resource, onFailed, "The resource " + filename + " has previously failed to load");
            }
            else if (resource.isLoaded)
            {
                if (onLoaded != null)
				{
                    //onLoaded(resource);
					onLoaded(new ResourceEvent(ResourceEvent.LOADED_EVENT, resource));
				}
            }
            else
            {
                // Still in process, so just hook up to its events.
                if (onLoaded != null)
				{
                    //resource.addEventListener(ResourceEvent.LOADED_EVENT, function (event:Event):void { onLoaded(resource); } );
					resource.addEventListener(ResourceEvent.LOADED_EVENT, onLoaded);
				}
                
                if (onFailed != null)
				{
                    //resource.addEventListener(ResourceEvent.FAILED_EVENT, function (event:Event):void { onFailed(resource); } );
					resource.addEventListener(ResourceEvent.FAILED_EVENT, onFailed);
				}
				
				if(onProgress != null)
				{
					resource.addEventListener(ResourceProgressEvent.PROGRESS_EVENT, onProgress);
				}
				
				if(onStarted != null)
				{
					resource.addEventListener(ResourceEvent.STARTED_EVENT, onStarted);
				}
            }
            
            // Don't forget to bump its ref count.
            resource.incrementReferenceCount();
            
            return resource;
        }
        
        /**
         * Unloads a previously loaded resource. This does not necessarily mean the resource
         * will be available for garbage collection. Resources are reference counted so if
         * the specified resource has been loaded multiple times, its reference count will
         * only decrease as a result of this.
         * 
         * @param filename The url of the resource to unload.
         * @param resourceType The type of the resource to unload.
         */
        public function unload(filename:String, resourceType:Class):void
        {        
			var resourceIdentifier:String = getResourceIdentifier(filename, resourceType);
			var resource:Resource = _resources[resourceIdentifier];
            if (!resource)
            {
                Logger.warn(this, "Unload", "The resource from file " + filename + " of type " + resourceType + " is not loaded.");
                return;
            }			
            resource.decrementReferenceCount();
			
            if (resource.referenceCount < 1)
            {
				Logger.info(this, "Unload", "The resource from file " + filename + " of type " + resourceType + " unloaded");				
				delete _resources[resourceIdentifier];
				
				// unload with resourceProvider
				for (var rp:int = 0; rp < resourceProviders.length; rp++)
				{
					if ((resourceProviders[rp] as IResourceProvider).isResourceKnown(filename, resourceType))
					{
						(resourceProviders[rp] as IResourceProvider).unloadResource(filename, resourceType);
						return;
					}
				}
				//m_context.m_fallbackResourceProvider[m_RPType].unloadResource(filename, resourceType);
				m_context.m_fallbackResourceProvider.unloadResource(filename, resourceType);
            }						
        }
        
        /**
         * Provide a source for resources to the ResourceManager. Once added,
         * the ResourceManager will use this IResourceProvider to try to fulfill
         * resource load requests.
         *  
         * @param resourceProvider Provider to add.
         * @see IResourceProvider
         */
        public function registerResourceProvider(resourceProvider:IResourceProvider):void
        {
            // check if resourceProvider is already registered
            if (resourceProviders.indexOf(resourceProvider) != -1)
            {
                Logger.warn(ResourceManager, "registerResourceProvider", "Tried to register ResourceProvider '" + resourceProvider + "' twice. Ignoring...");
                return;
            }
            
            // add resourceProvider to list of known resourceProviders
            resourceProviders.push(resourceProvider);
        }
        
        /**
         * Check if a resource is loaded and ready to go. 
         * @param filename Same as request to load()
         * @param resourceType Same as request to load().
         * @return True if resource is loaded.
         */
        public function isLoaded(filename:String, resourceType:Class):Boolean
        {
            var resourceIdentifier:String = getResourceIdentifier(filename, resourceType);
            if(!_resources[resourceIdentifier])
                return false;
            
            var r:Resource = _resources[resourceIdentifier];
            return r.isLoaded;                
        }

		/**
		 * Provides a resource if it is known. could be that it is not loaded yet.  
		 * @param filename Same as request to load()
		 * @param resourceType Same as request to load().
		 * @return resource
		 */
		public function getResource(filename:String, resourceType:Class):Resource
		{
			return _resources[getResourceIdentifier(filename, resourceType)];
		}

        /**
         * Properly mark a resource as failed-to-load.
         */
        private function fail(resource:Resource, onFailed:Function, message:String):void
        {
            if(!resource)
                throw new Error("Tried to fail null resource.");
            
            Logger.error(this, "load", message);
            if (onFailed != null)
			{
				// KBEN: 失败函数更改了 
                //onFailed(resource);
				onFailed(new ResourceEvent(ResourceEvent.FAILED_EVENT, resource));
			}
        }

        private function getResourceIdentifier(filename:String, resourceType:Class):String
        {
            return filename.toLowerCase() + RESOURCE_KEY_SPLITTER + getQualifiedClassName(resourceType);
        }
        
        /**
         * Dictionary of loaded resources indexed by resource name and type. 
         */
        private var _resources:Dictionary = new Dictionary();
        
        /**
         * List of resource providers used to get resources. 
         */        
        private var resourceProviders:Array = new Array();

        /*** Helper methods for PBE not externally exposed ***/
        private function getResources():Dictionary
        {
            return _resources;
        }

        private function getResourceByIdentifier(identifier:String):Resource
        {
            return _resources[identifier];
        }
		
		// KBEN: 
		protected var m_context:Context;
    }
}
