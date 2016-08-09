#pragma once
#ifndef __MSceneRenderManager_H__
#define __MSceneRenderManager_H__

class MSceneRenderManager
{
private:
	fScene scene : ; // 当前场景
	public var range : Number; // 当前视口可视化元素大小
	private var depthSortArr : Array; // Array of elements for depth sorting

	// KBEN: 地形，以及一些静态地物可视化元素放在这里，不需要深度排序，可视化都是内部访问的   
	//public var _staticElementV:Array;
	// KBEN: 除了地形和人物，其它可视化都放在这里，存放需要深度排序的 
	public var elementsV : Array; // An array of the elements currently visible
								  // KBEN: 存放人物，需要深度排序        
	public var charactersV : Array; // An array of the characters currently visible,继续需要,点选使用
									//public var emptySpritesV:Array; // An array of emptySprites currently visible
	private var cell : fCell; // The cell where the camera is
	protected var m_preCell : fCell; // 这个是前一个摄像机所在的格子
	public var renderEngine : fEngineRenderEngine; // A reference to the render engine

public:
	MSceneRenderManager();
	~MSceneRenderManager();
};

#endif