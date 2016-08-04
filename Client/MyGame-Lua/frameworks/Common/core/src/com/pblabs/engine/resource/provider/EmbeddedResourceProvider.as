package com.pblabs.engine.resource.provider
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.Resource;
	import common.Context;
	
	//import flash.utils.Dictionary;
	
    /**
     * The EmbeddedResourceProvider provides the ResourceManager with the embedded
     * resources that were loaded from ResourceBundle and ResourceBinding classes
     * 
     * This class works using a singleton pattern so when resource bundles and/or
     * resource bindings are initialized they will register the resources with
     * the EmbeddedResourceProvider.instance
     */
	public class EmbeddedResourceProvider extends ResourceProviderBase
	{
		// ------------------------------------------------------------
		// public getter/setter property functions
		// ------------------------------------------------------------

		// ------------------------------------------------------------
		// public methods
		// ------------------------------------------------------------

        /**
        * Contructor
        * 
        * Calls the ResourceProvideBase constructor  - super();
        * to auto-register this provider with the ResourceManager
        */
		public function EmbeddedResourceProvider(context:Context)
		{
			super(true, context);
		}        
		
        /**
        * This method is used by the ResourceBundle and ResourceBinding Class to
        * register the existance of a specific embedded resource
        */
		public override function registerResource(filename:String, resourceType:Class, data:*):void
        {
        	// create a unique identifier for this resource
            var resourceIdentifier:String = filename.toLowerCase() + resourceType;

			// check if the resource has already been registered            
            if (resources[resourceIdentifier])
            {
                Logger.warn(this, "registerEmbeddedResource", "A resource from file " + filename + " has already been embedded.");
                return;
            }
            
            // Set up the resource
            try
            {
                var resource:Resource = new resourceType();
                resource.filename = filename;
                resource.initialize(data);
                
                // keep the resource in the lookup dictionary                
                resources[resourceIdentifier] = resource;
            }
            catch(e:Error)
            {
                Logger.error(this, "registerEmbeddedResources", "Could not instantiate resource " + filename + " due to error:\n" + e.toString());
                return;
            }
        }
		
		public override function unloadResource(uri:String, type:Class):void
		{
			// no unloading of embedded resource
		}		
	}
}