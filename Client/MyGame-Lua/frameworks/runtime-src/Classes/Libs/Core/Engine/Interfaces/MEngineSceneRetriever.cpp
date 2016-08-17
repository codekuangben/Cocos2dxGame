#include "MEngineSceneRetriever.h"

MEngineSceneRetriever::MEngineSceneRetriever()
{

}

MEngineSceneRetriever::~MEngineSceneRetriever()
{

}

/**
	* The scene will call this when it is ready to receive an scene. Then the engine will listen for a COMPLETE event
	* of the returned object before retrieving the final xml
	*/
//function start():EventDispatcher;
SWFResource MEngineSceneRetriever::start(Context context, MScene scene)
{

}
		
/**
	* The scene will use this method to retrieve the XML definition once when a COMPLETE event is triggered
	*/
XML MEngineSceneRetriever::getXML();
{

}
		
/**
	* The scene will use this method to retrieve the basepath for this XML. This basepath will be used to resolve paths inside this XML
	*/
String MEngineSceneRetriever::getBasePath()
{

}

void MEngineSceneRetriever::dispose()
{

}
		
// 获取服务器场景 id
uint MEngineSceneRetriever::getServerSceneID()
{

}