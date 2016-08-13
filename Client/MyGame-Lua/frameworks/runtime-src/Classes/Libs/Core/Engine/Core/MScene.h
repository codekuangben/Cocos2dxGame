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
	// This counter is used to generate unique scene Ids
	private static var count : Number = 0;

	// This flag is set by the editor so every object is created as a character and can be moved ( so ugly I know but It does work )
	/** @private */
	public static var allCharacters : Boolean = false;

	// Private properties

	// 1. References
	private var _controller : fEngineSceneController = null;
	/** @private */
	//public var prof:fProfiler = null; // Profiler
	private var initializer : fSceneInitializer; // This scene's initializer
												 /** @private */
	public var renderEngine : fEngineRenderEngine; // The render engine
												   /** @private */
	public var renderManager : fSceneRenderManager; // The render manager
													/** @private */
	public var engine : fEngine;
	/** @private */
	public var _orig_container : Sprite; // Backup reference

										 // 2. Geometry and sizes

										 /** @private */
	public var viewWidth : Number; // Viewport size
								   /** @private */
	public var viewHeight : Number; // Viewport size
									/** @private */
	public var top : Number; // Highest Z in the scene
							 /** @private */
	public var gridWidth : int; // Grid size in cells
								/** @private */
	public var gridDepth : int;
	/** @private */
	public var gridHeight : int;
	/** @private */
	public var gridSize : int; // Grid size ( in pixels )
	public var gridSizeHalf : int; //half of grid size
								   /** @private */
	public var levelSize : int; // Vertical grid size ( along Z axis, in pixels )
								/** @private */
	public var sortCubeSize : int = fEngine.SORTCUBESIZE; // Sorting cube size

														  // 3. zSort

														  /** @private */
	public var grid : Array; // The grid
							 /** @private */
	public var allUsedCells : Array;
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
	public var IAmBeingRendered : Boolean = false; // If this scene is actually being rendered
	private var _enabled : Boolean; // Is the scene enabled ?

									// Public properties

									/**
									* Every Scene is automatically assigned and ID
									*/
	public var id : String;

	/**
	* The camera currently in use, if any
	*/
	public var currentCamera : fCamera;

	/**
	* Were this scene is drawn
	*/
	public var container : Sprite;

	/**
	* An string indicating the scene's current status
	*/
	public var stat : String;

	/**
	* Indicates if the scene is loaded and ready
	*/
	public var ready : Boolean;

	/**
	* Scene width in pixels.
	*/
	public var width : Number;

	/**
	* Scene depth in pixels
	*/
	public var depth : Number;

	/**
	* Scene height in pixels
	*/
	public var height : Number;

	/**
	* An array of all floors for fast loop access. For "id" access use the .all array
	*/
	// KBEN: ����Ǵ�ŵ��εģ�ʹ�������вü�    
	public var floors : Array;

	/**
	* An array of all walls for fast loop access. For "id" access use the .all array
	*/
	// KBEN: ����Ǵ��ǽ�ģ���ʱ������  
	//public var walls:Array;

	/**
	* An array of all objects for fast loop access. For "id" access use the .all array
	*/
	// KBEN: ��������ŵ��ǳ����в��ܱ��ƶ���ɾ����ʵ�壬������ʹ�������вü�      
	public var objects : Array;

	// KBEN: ���ƶ����߿��Զ�̬ɾ���ķ��������Ч�������npc ��ֱ��ʹ�����ĵ���вü�       
	public var m_dynamicObjects : Vector.<fObject>;

	/**
	* An array of all characters for fast loop access. For "id" access use the .all array
	*/
	// KBEN: ����Ǵ�������߶��ģ���ң�ֱ��ʹ�����ĵ���вü�     
	public var characters : Array;

	/**
	* An array of all empty sprites for fast loop access. For "id" access use the .all array
	*/
	// KBEN: �վ��飬��ʹ��       
	public var emptySprites : Array;

	/**
	* An array of all lights for fast loop access. For "id" access use the .all array
	*/
	public var lights : Array;

	/**
	* An array of all elements for fast loop access. For "id" access use the .all array. Bullets are not here
	*/
	public var everything : Array;

	/**
	* The global light for this scene. Use this property to change light properties such as intensity and color
	*/
	public var environmentLight : fGlobalLight;

	/**
	* An array of all elements in this scene, use it with ID Strings. Bullets are not here
	*/
	public var all : Array;

	/**
	* ���� UI bottom �㣬��ʾ�ڵ����ϣ�����Ҫ����Ͳü����Լ�������ʾ���أ���������
	* */
	public var m_sceneUIBtmEffVec : Vector.<fObject>;

	/**
	* ���� UI top �㣬��ʾ������ϣ�����Ҫ����Ͳü����Լ�������ʾ���أ���������
	* */
	public var m_sceneUITopEffVec : Vector.<fObject>;
	/**
	* ����������Ч�����㣬��ʾ������£����ε����棬����Ҫ����Ͳü����Լ�������ʾ���أ���������
	* */
	public var m_sceneJinNangEffVec : Vector.<fObject>;

	/**
	* The AI-related method are grouped inside this object, for easier access
	*/
	public var AI : fAiContainer;

	/**
	* All the bullets currently active in the scene are here
	*/
	//public var bullets:Array;

	// Bullets go here instead of being deleted, so they can be reused
	//private var bulletPool:Array;

	// Al events
	/** @private */
	public var events : Array;

	// KBEN: �������� 
	public var m_sceneConfig : fSceneConfig;

	// KBEN:
	public var m_floorWidth : Number; // ���� Floor �����ȣ���λ����  
	public var m_floorDepth : Number; // ���� Floor ����߶ȣ���λ����  

	public var m_floorXCnt : uint; // X ���������� 
	public var m_floorYCnt : uint; // Y ���������� 

	public var m_scenePixelXOff : int = 0; // ���� X ����ƫ�ƣ���Ҫ����ս����������Ҫƫ��һ������
	public var m_scenePixelYOff : int = 0; // ���� Y ����ƫ�ƣ���Ҫ����ս����������Ҫƫ��һ������

	public var m_scenePixelWidth : int = 0; // ����ͼ����ʵ�����ؿ�ȣ����ܱ� scene �ĸ��ӵĿ��ҪС
	public var m_scenePixelHeight : int = 0; // ����ͼ����ʵ�����ظ߶ȣ����ܱ� scene �ĸ��ӵĸ߶�ҪС

	public var m_thumbnails : BitmapData; // ���泡������ͼ����Ϊ����ͼ��Դ������ɵ�ʱ�򣬳��������ǻ�û����ɣ�����е����ݲ���ʹ��
										  //public var m_thumbnailsExtend:BitmapData;

	public var m_depthDirty : Boolean = false; // ��Ҫ��������һ֡��ֻ����һ�� depthSort �������
	public var m_depthDirtySingle : Boolean = false; // ÿһ���ƶ���ʱ����Ҫ�������
	public var m_singleDirtyArr : Vector.<fRenderableElement>; // ÿһ����ȸı��ʱ�򶼴��������б�һ�θ���

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