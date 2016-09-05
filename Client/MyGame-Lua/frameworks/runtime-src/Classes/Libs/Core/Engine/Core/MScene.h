#pragma once
#ifndef __MScene_H__
#define __MScene_H__

/**
* <p>The fScene class provides control over a scene in your application. The API for this object is used to add and remove
* elements from the scene after it has been loaded, and managing cameras.</p>
*
* <p>Moreover, you can get information on topology, visibility from one point to another, search for paths and other useful
* methods that will help, for example, in programming AIs that move inside the scene.</p>
*
* <p>The data structures contained within this object are populated during initialization by the fSceneInitializer class (which you don't need to understand).</p>
*
*/
class MScene : public EventDispatcher
{
private:
	// This counter is used to generate unique scene Ids
	unsigned int count;

public:
	// This flag is set by the editor so every object is created as a character and can be moved ( so ugly I know but It does work )
	/** @private */
	bool allCharacters;

private:
	// Private properties

	// 1. References
	MEngineSceneController _controller;
	/** @private */
	//public var prof:fProfiler = null; // Profiler
	MSceneInitializer initializer; // This scene's initializer
	/** @private */
	MEngineRenderEngine renderEngine; // The render engine
	/** @private */

public:
	MSceneRenderManager renderManager; // The render manager
													/** @private */
	MEngine engine;
	/** @private */
	Sprite _orig_container; // Backup reference

	// 2. Geometry and sizes

	/** @private */
	float viewWidth; // Viewport size
								   /** @private */
	float viewHeight; // Viewport size
									/** @private */
	float top; // Highest Z in the scene
							 /** @private */
	int gridWidth; // Grid size in cells
								/** @private */
	int gridDepth;
	/** @private */
	int gridHeight;
	/** @private */
	int gridSize; // Grid size ( in pixels )
	int gridSizeHalf; //half of grid size
								   /** @private */
	int levelSize; // Vertical grid size ( along Z axis, in pixels )
								/** @private */
	int sortCubeSize; // Sorting cube size

	// 3. zSort

	/** @private */
	MArray grid; // The grid
							 /** @private */
	MArray allUsedCells;
	/** @private */
	//public var sortAreas:Array; // zSorting generates this. This array points to contiguous spaces sharing the same zIndex
	// It is used to find the proper zIndex for a cell
	/** @private */
	//public var sortAreasRTree:fRTree; // This tree is used to search sortAreas efficiently

	/** @private */
	//public var allStatic2D:Array; // This provides fast 2D searches in the static elements
	/** @private */
	//public var allStatic2DRTree:fRTree;

	/** @private */
	//public var allStatic3D:Array; // This provides fast 3D searches in the static elements
	/** @private */
	//public var allStatic3DRTree:fRTree;

	// 4. Resources

	/** @private */
	//public var resourceManager:fSceneResourceManager; // The resource manager stores all definitions loaded for this scene

	// 5.Status			

	/** @private */
public:
	bool IAmBeingRendered; // If this scene is actually being rendered
private:
	bool _enabled; // Is the scene enabled ?

	// Public properties

	/**
	* Every Scene is automatically assigned and ID
	*/
public:
	MString id;

	/**
	* The camera currently in use, if any
	*/
	MCamera currentCamera;

	/**
	* Were this scene is drawn
	*/
	Sprite container;

	/**
	* An string indicating the scene's current status
	*/
	MString stat;

	/**
	* Indicates if the scene is loaded and ready
	*/
	bool ready;

	/**
	* Scene width in pixels.
	*/
	float width;

	/**
	* Scene depth in pixels
	*/
	float depth;

	/**
	* Scene height in pixels
	*/
	float height;

	/**
	* An array of all floors for fast loop access. For "id" access use the .all array
	*/
	// KBEN: ����Ǵ�ŵ��εģ�ʹ�������вü�    
	MArray floors;

	/**
	* An array of all walls for fast loop access. For "id" access use the .all array
	*/
	// KBEN: ����Ǵ��ǽ�ģ���ʱ������  
	//public var walls:Array;

	/**
	* An array of all objects for fast loop access. For "id" access use the .all array
	*/
	// KBEN: ��������ŵ��ǳ����в��ܱ��ƶ���ɾ����ʵ�壬������ʹ�������вü�      
	MArray objects;

	// KBEN: ���ƶ����߿��Զ�̬ɾ���ķ��������Ч�������npc ��ֱ��ʹ�����ĵ���вü�       
	MVector<MObject> m_dynamicObjects;

	/**
	* An array of all characters for fast loop access. For "id" access use the .all array
	*/
	// KBEN: ����Ǵ�������߶��ģ���ң�ֱ��ʹ�����ĵ���вü�     
	MArray characters;

	/**
	* An array of all empty sprites for fast loop access. For "id" access use the .all array
	*/
	// KBEN: �վ��飬��ʹ��       
	MArray emptySprites;

	/**
	* An array of all lights for fast loop access. For "id" access use the .all array
	*/
	MArray lights;

	/**
	* An array of all elements for fast loop access. For "id" access use the .all array. Bullets are not here
	*/
	MArray everything;

	/**
	* The global light for this scene. Use this property to change light properties such as intensity and color
	*/
	MGlobalLight environmentLight;

	/**
	* An array of all elements in this scene, use it with ID Strings. Bullets are not here
	*/
	MArray all;

	/**
	* ���� UI bottom �㣬��ʾ�ڵ����ϣ�����Ҫ����Ͳü����Լ�������ʾ���أ���������
	* */
	MVector<MObject> m_sceneUIBtmEffVec;

	/**
	* ���� UI top �㣬��ʾ������ϣ�����Ҫ����Ͳü����Լ�������ʾ���أ���������
	* */
	MVector<MObject> m_sceneUITopEffVec;
	/**
	* ����������Ч�����㣬��ʾ������£����ε����棬����Ҫ����Ͳü����Լ�������ʾ���أ���������
	* */
	MVector<MObject> m_sceneJinNangEffVec;

	/**
	* The AI-related method are grouped inside this object, for easier access
	*/
	MAiContainer AI;

	/**
	* All the bullets currently active in the scene are here
	*/
	//public var bullets:Array;

	// Bullets go here instead of being deleted, so they can be reused
	//private var bulletPool:Array;

	// Al events
	/** @private */
	MArray events;

	// KBEN: �������� 
	MSceneConfig m_sceneConfig;

	// KBEN:
	float m_floorWidth; // ���� Floor �����ȣ���λ����  
	float m_floorDepth; // ���� Floor ����߶ȣ���λ����  

	unsigned int m_floorXCnt; // X ���������� 
	unsigned int m_floorYCnt; // Y ���������� 

	int m_scenePixelXOff; // ���� X ����ƫ�ƣ���Ҫ����ս����������Ҫƫ��һ������
	int m_scenePixelYOff; // ���� Y ����ƫ�ƣ���Ҫ����ս����������Ҫƫ��һ������

	int m_scenePixelWidth; // ����ͼ����ʵ�����ؿ�ȣ����ܱ� scene �ĸ��ӵĿ��ҪС
	int m_scenePixelHeight; // ����ͼ����ʵ�����ظ߶ȣ����ܱ� scene �ĸ��ӵĸ߶�ҪС

	BitmapData m_thumbnails; // ���泡������ͼ����Ϊ����ͼ��Դ������ɵ�ʱ�򣬳��������ǻ�û����ɣ�����е����ݲ���ʹ��
	//public var m_thumbnailsExtend:BitmapData;

	bool m_depthDirty; // ��Ҫ��������һ֡��ֻ����һ�� depthSort �������
	bool m_depthDirtySingle; // ÿһ���ƶ���ʱ����Ҫ�������
	MVector<MRenderableElement> m_singleDirtyArr; // ÿһ����ȸı��ʱ�򶼴��������б�һ�θ���

	// Events

	/**
	* An string describing the process of loading and processing and scene XML definition file.
	* Events dispatched by the scene while loading containg this String as a description of what is happening
	*/
	public static const LOADINGDESCRIPTION : String = "Creating scene";

	/**
	* The fScene.LOADPROGRESS constant defines the value of the
	* <code>type</code> property of the event object for a <code>scenecloadprogress</code> event.
	* The event is dispatched when the status of the scene changes during scene loading and processing.
	* A listener to this event can then check the scene's status property to update a progress dialog
	*
	*/
	public static const LOADPROGRESS : String = "scenecloadprogress";

	/**
	* The fScene.LOADCOMPLETE constant defines the value of the
	* <code>type</code> property of the event object for a <code>sceneloadcomplete</code> event.
	* The event is dispatched when the scene finishes loading and processing and is ready to be used
	*
	*/
	public static const LOADCOMPLETE : String = "sceneloadcomplete";

	// KBEN: ��Ⱦ����㣬��������ǳ����� UI ����һ�� 
	public var m_SceneLayer : Vector.<Sprite>;
	//public static const SLTerrainThumbnails:uint = 0;		// ��������ͼ�㣬�����������
	//public static const SLTerrain:uint = 0;		// ���β㣬�����������
	//public static const SLSceneUIBtm:uint = SLTerrain + 1;	// 1 ���� UI �ײ㣬�ڵ����ϣ������򣬲��ü�����������
	//public static const SLBlur:uint = SLSceneUIBtm + 1;		// 2 ������β��ս����������
	//public static const SLShadow:uint = SLBlur + 1;		// 3 ��Ӱ�㣬���������еĲ�������Ӱ�����˵���
	//public static const SLShadow1:uint = 4;		// 4 ���Բü���ʱ����ӵģ����Ե�ʱ����Ҫ�����
	//public static const SLBuild:uint= SLShadow + 1;		// ����,�������������
	//public static const SLObject:uint = SLBuild + 1;		// �����NPC����������Ҫ�����  
	//public static const SLEffect:uint = SLObject + 1;		// ��Ч
	//public static const SLSceneUITop:uint = SLEffect + 1;	// ���� UI ���㣬�������ϣ������򣬲��ü�����������
	//public static const SLFog:uint = SLSceneUITop + 1;			// ��������Ч���Ĳ�    
	//public static const SLCnt:uint = SLFog + 1;			// �ܹ�������� 
	// KBEN:�赲����Ϣ��ÿһ�� fScene �洢����������ã���һ����λ���飬��һά���У��ڶ�λ���У���С�ڴ棬ʹ��   Dictionary ��ʹ�� Vector      
	//public var m_stopPointList:Vector.<Vector.<stopPoint>>;
	public var m_stopPointList : Dictionary;
	public var m_defaultStopPoint : stopPoint; // Ĭ�ϵ��赲�㣬Ϊ��ͳһ������������ if else �ж�    

	private var m_fogPlane : fFogPlane; // �洢�����Ϣ
	public var m_sceneType : uint; // �������ͣ���ͨ��������ս��������ս��������ʹ��
	public var m_serverSceneID : uint; // ���������� id
	public var m_filename : uint; // �ͻ��˵�ͼ�ļ����֣�û����չ����

	public var m_sortByBeingMove : Boolean = true; // ���� being �ƶ��Ƿ���Ҫ��������ս����������Ҫ�ˣ�̫���ƶ���
	public var m_path : String;

	public var m_timesOfShow : int = 0;
	public var m_disposed : Boolean = false;
	public var m_dicDebugInfo : Dictionary;
};

#endif