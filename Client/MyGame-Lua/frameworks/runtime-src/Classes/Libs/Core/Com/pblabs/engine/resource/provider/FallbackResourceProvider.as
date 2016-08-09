package com.pblabs.engine.resource.provider
{
	//import br.com.stimuli.loading.BulkLoader;
	//import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.SWFResource;
	
	import common.Context;
	
    /**
     * The LoadedResourceProvider is used by the ResourceManager to request resources
     * that no other resource provider can provide.
     * 
     * A requested resource will be loaded by BulkLoader as it is requested. 
     * 
     * This class works using a singleton pattern
     */
	public class FallbackResourceProvider extends BulkLoaderResourceProvider
	{
		// ------------------------------------------------------------
		// public getter/setter property functions
		// ------------------------------------------------------------
        
		// ------------------------------------------------------------
		// public methods
		// ------------------------------------------------------------
		
        /**
        * Contructor
        */ 
		public function FallbackResourceProvider(context:Context)
		{
			// call the BulkLoaderResourceProvider parent constructor where we
			// specify that this Provider should not be registered as a normal provider.
			super("PBEFallbackProvider",12,false, context);
		}
		
		//public function FallbackResourceProvider(context:Context, name:String)
		//{
			// call the BulkLoaderResourceProvider parent constructor where we
			// specify that this Provider should not be registered as a normal provider.
		//	super(name,12,false, context);
		//}
        
        /**
        * This method will check if this provider has access to a specific Resource
        */
		public override function isResourceKnown(uri:String, type:Class):Boolean
		{
			// always return true, because this resource provider will load the 
			// resource on the fly, using BulkLoader when it is requested.
			return true;
		}
		
		public override function unloadResource(uri:String, type:Class):void
		{
			// because this resource was dynamicly loaded 'On The Fly'
			// we have to unload it and clean memory
			var resourceIdentifier:String = uri.toLowerCase() + type;			
			if (resources[resourceIdentifier]!=null)
			{
				if (resources[resourceIdentifier] is ImageResource)
					(resources[resourceIdentifier] as ImageResource).dispose();
				else if(resources[resourceIdentifier] is SWFResource)
				{
					// 需要卸载 loadingitem
					loader.disposeDisplayObjectLoader(resourceIdentifier);
					(resources[resourceIdentifier] as SWFResource).dispose();	// swf 仍然需要卸载
				}
				resources[resourceIdentifier] = null;
				delete resources[resourceIdentifier]; 
			}
		}        
	}
}