#pragma once
#ifndef __MSceneRenderManager_H__
#define __MSceneRenderManager_H__

#include "MArray.h"

class MScene;
class MObject;
class MEngineRenderEngine;
class MCell;

class MSceneRenderManager
{
protected:
	MScene* scene; // 当前场景
	float range; // 当前视口可视化元素大小
	MVector<MObject*> depthSortArr; // Array of elements for depth sorting

	// KBEN: 地形，以及一些静态地物可视化元素放在这里，不需要深度排序，可视化都是内部访问的   
	//public var _staticElementV:Array;
	// KBEN: 除了地形和人物，其它可视化都放在这里，存放需要深度排序的 
	MVector<MObject*> elementsV; // An array of the elements currently visible
								  // KBEN: 存放人物，需要深度排序        
	MVector<MObject*> charactersV; // An array of the characters currently visible,继续需要,点选使用
									//public var emptySpritesV:Array; // An array of emptySprites currently visible
	MCell* cell; // The cell where the camera is
	MCell* m_preCell; // 这个是前一个摄像机所在的格子
	MEngineRenderEngine* renderEngine; // A reference to the render engine

public:
	MSceneRenderManager();
	~MSceneRenderManager();

	void fSceneRenderManager(MScene scene);
	void MSceneRenderManager::setViewportSize(float width, float height);
	void MSceneRenderManager::initialize();

	void MSceneRenderManager::processNewCellCamera(MCamera cam);
	void MSceneRenderManager::processNewCellCharacter(MCharacter character, bool needDepthsort = true);
	void MSceneRenderManager::processNewCellEmptySprite(MEmptySprite spr, bool needDepthsort = true);
	void MSceneRenderManager::processNewCellEffect(EffectEntity effect);
	void MSceneRenderManager::processNewCellFObject(fSceneObject fobject);

	void MSceneRenderManager::showListener(Event evt);
	void MSceneRenderManager::addedItem(fRenderableElement ele);
	void MSceneRenderManager::hideListener(Event evt);
	void MSceneRenderManager::removedItem(fRenderableElement ele, bool destroyingScene = false);

	void MSceneRenderManager::addToDepthSort(fRenderableElement item);
	void MSceneRenderManager::removeFromDepthSort(fRenderableElement item);
	void MSceneRenderManager::depthChangeListener(Event evt);
	void MSceneRenderManager::depthSortSingle();
	void MSceneRenderManager::depthSort();

	void MSceneRenderManager::dispose();
	void MSceneRenderManager::setCurCell(MCell value);
	MCell MSceneRenderManager::getCurCell();
	void MSceneRenderManager::setPreCell(MCell value);
};

#endif