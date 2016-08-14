#pragma once
#ifndef __MEngineSceneRetriever_H__
#define __MEngineSceneRetriever_H__

/**
* This interface defines methods that any class that is to be used to retrieve an scene XML must implement.
* I'm using this interface definition rather that simply loading an XML because this allows to create custom classes
* that generate random maps, for example.
*/
class MEngineSceneRetriever
{
public:
	MEngineSceneRetriever();
	~MEngineSceneRetriever();

	/**
	* The scene will call this when it is ready to receive an scene. Then the engine will listen for a COMPLETE event
	* of the returned object before retrieving the final xml
	*/
	//function start():EventDispatcher;
	SWFResource start(Context context, MScene scene);

	/**
	* The scene will use this method to retrieve the XML definition once when a COMPLETE event is triggered
	*/
	XML getXML();

	/**
	* The scene will use this method to retrieve the basepath for this XML. This basepath will be used to resolve paths inside this XML
	*/
	String getBasePath();
	void dispose();

	// 获取服务器场景 id
	uint getServerSceneID();
};

#endif