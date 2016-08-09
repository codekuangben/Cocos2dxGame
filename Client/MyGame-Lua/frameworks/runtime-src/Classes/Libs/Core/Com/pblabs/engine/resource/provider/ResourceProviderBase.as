package com.pblabs.engine.resource.provider
{
    import com.pblabs.engine.resource.Resource;
	import flash.system.LoaderContext;
    //import com.pblabs.engine.resource.ResourceManager;
	import common.Context;
    
    import flash.utils.Dictionary;
    
    /**
     * The ResourceProviderBase class can be extended to create a ResourceProvider 
     * that will auto register with the ResourceManager
     */
    public class ResourceProviderBase implements IResourceProvider
    {
        public function ResourceProviderBase(registerProvider:Boolean = true, context:Context = null)
        {
			m_context = context;
            // Make sure PBE is initialized - no resource manager, no love.
            if(!m_context.m_resMgr)
            {
                throw new Error("not init");
            }
            
            // register this ResourceProvider with the ResourceManager
            if (registerProvider)
                m_context.m_resMgr.registerResourceProvider(this);
            
            // create the Dictionary object that will keep all resources 			
            resources = new Dictionary();
        }
        
        /**
         * This method will check if this provider has access to a specific Resource
         */
        public function isResourceKnown(uri:String, type:Class):Boolean
        {
            var resourceIdentifier:String = uri.toLowerCase() + type;
            return (resources[resourceIdentifier]!=null)
        }
        
        /**
         * This method will request a resource from this ResourceProvider
         */
        public function getResource(uri:String, type:Class, forceReload:Boolean = false, ver:String = "", context:LoaderContext=null):Resource
        {
            var resourceIdentifier:String = uri.toLowerCase() + type;
            return resources[resourceIdentifier];
        }

		/**
		 * This method will unload a resource from the resources Dictionary
		 */
		public function unloadResource(uri:String, type:Class):void
		{
			var resourceIdentifier:String = uri.toLowerCase() + type;			
			if (resources[resourceIdentifier]!=null)
			{
				resources[resourceIdentifier].dispose();
				resources[resourceIdentifier] = null;
			}
		}
				
        /**
         * This method will add a resource to the resources Dictionary
         */
        protected function addResource(uri:String, type:Class, resource:Resource):void
        {
            var resourceIdentifier:String = uri.toLowerCase() + type;
            resources[resourceIdentifier] = resource;        	
        }
		
		public function registerResource(filename:String, resourceType:Class, data:*):void
		{
			
		}
        // ------------------------------------------------------------
        // private and protected variables
        // ------------------------------------------------------------
        protected var resources:Dictionary;
        
		// KBEN: 
		protected var m_context:Context;
    }
}