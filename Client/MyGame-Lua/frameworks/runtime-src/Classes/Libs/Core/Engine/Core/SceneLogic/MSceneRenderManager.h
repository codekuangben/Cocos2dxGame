#pragma once
#ifndef __MSceneRenderManager_H__
#define __MSceneRenderManager_H__

class MSceneRenderManager
{
private:
	MScene scene; // ��ǰ����
	public var range : Number; // ��ǰ�ӿڿ��ӻ�Ԫ�ش�С
	private var depthSortArr : Array; // Array of elements for depth sorting

	// KBEN: ���Σ��Լ�һЩ��̬������ӻ�Ԫ�ط����������Ҫ������򣬿��ӻ������ڲ����ʵ�   
	//public var _staticElementV:Array;
	// KBEN: ���˵��κ�����������ӻ���������������Ҫ�������� 
	public var elementsV : Array; // An array of the elements currently visible
								  // KBEN: ��������Ҫ�������        
	public var charactersV : Array; // An array of the characters currently visible,������Ҫ,��ѡʹ��
									//public var emptySpritesV:Array; // An array of emptySprites currently visible
	private var cell : fCell; // The cell where the camera is
	protected var m_preCell : fCell; // �����ǰһ����������ڵĸ���
	public var renderEngine : fEngineRenderEngine; // A reference to the render engine

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