#pragma once
#ifndef __MSceneRenderManager_H__
#define __MSceneRenderManager_H__

class MSceneRenderManager
{
private:
	fScene scene : ; // ��ǰ����
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
};

#endif