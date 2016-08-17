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
	// KBEN: 这个是存放地形的，使用树进行裁剪    
	public var floors : Array;

	/**
	* An array of all walls for fast loop access. For "id" access use the .all array
	*/
	// KBEN: 这个是存放墙的，暂时不用了  
	//public var walls:Array;

	/**
	* An array of all objects for fast loop access. For "id" access use the .all array
	*/
	// KBEN: 这个里面存放的是场景中不能被移动和删除的实体，例如地物，使用树进行裁剪      
	public var objects : Array;

	// KBEN: 可移动或者可以动态删除的放在这里，特效，掉落物，npc ，直接使用中心点进行裁剪       
	public var m_dynamicObjects : Vector.<fObject>;

	/**
	* An array of all characters for fast loop access. For "id" access use the .all array
	*/
	// KBEN: 这个是存放总是走动的，玩家，直接使用中心点进行裁剪     
	public var characters : Array;

	/**
	* An array of all empty sprites for fast loop access. For "id" access use the .all array
	*/
	// KBEN: 空精灵，在使用       
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
	* 场景 UI bottom 层，显示在地形上，不需要排序和裁剪，自己控制显示隐藏，场景不管
	* */
	public var m_sceneUIBtmEffVec : Vector.<fObject>;

	/**
	* 场景 UI top 层，显示在玩家上，不需要排序和裁剪，自己控制显示隐藏，场景不管
	* */
	public var m_sceneUITopEffVec : Vector.<fObject>;
	/**
	* 场景锦囊特效持续层，显示在玩家下，地形的上面，不需要排序和裁剪，自己控制显示隐藏，场景不管
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

	// KBEN: 场景配置 
	public var m_sceneConfig : fSceneConfig;

	// KBEN:
	public var m_floorWidth : Number; // 单个 Floor 区域宽度，单位像素  
	public var m_floorDepth : Number; // 单个 Floor 区域高度，单位像素  

	public var m_floorXCnt : uint; // X 方向面板个数 
	public var m_floorYCnt : uint; // Y 方向面板个数 

	public var m_scenePixelXOff : int = 0; // 场景 X 方向偏移，主要用在战斗场景，需要偏移一定距离
	public var m_scenePixelYOff : int = 0; // 场景 Y 方向偏移，主要用在战斗场景，需要偏移一定距离

	public var m_scenePixelWidth : int = 0; // 场景图像真实的像素宽度，可能比 scene 的格子的宽度要小
	public var m_scenePixelHeight : int = 0; // 场景图像真实的像素高度，可能比 scene 的格子的高度要小

	public var m_thumbnails : BitmapData; // 保存场景缩略图，因为缩略图资源加载完成的时候，场景西那是还没有完成，因此有的数据不能使用
										  //public var m_thumbnailsExtend:BitmapData;

	public var m_depthDirty : Boolean = false; // 主要用来进行一帧中只调用一次 depthSort 这个函数
	public var m_depthDirtySingle : Boolean = false; // 每一个移动的时候需要深度排序
	public var m_singleDirtyArr : Vector.<fRenderableElement>; // 每一个深度改变的时候都存放在这个列表，一次更新

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

	// KBEN: 渲染引擎层，这个仅仅是场景， UI 单独一层 
	public var m_SceneLayer : Vector.<Sprite>;
	//public static const SLTerrainThumbnails:uint = 0;		// 地形缩略图层，不参与排序的
	//public static const SLTerrain:uint = 0;		// 地形层，不参与排序的
	//public static const SLSceneUIBtm:uint = SLTerrain + 1;	// 1 场景 UI 底层，在地形上，不排序，不裁剪，场景不管
	//public static const SLBlur:uint = SLSceneUIBtm + 1;		// 2 运行拖尾，战斗场景中用
	//public static const SLShadow:uint = SLBlur + 1;		// 3 阴影层，场景中所有的不接收阴影，除了地形
	//public static const SLShadow1:uint = 4;		// 4 测试裁剪的时候添加的，测试的时候需要添加上
	//public static const SLBuild:uint= SLShadow + 1;		// 地物,这个不用排序了
	//public static const SLObject:uint = SLBuild + 1;		// 掉落物，NPC，怪物，人物，需要排序的  
	//public static const SLEffect:uint = SLObject + 1;		// 特效
	//public static const SLSceneUITop:uint = SLEffect + 1;	// 场景 UI 顶层，在人物上，不排序，不裁剪，场景不管
	//public static const SLFog:uint = SLSceneUITop + 1;			// 场景中雾效果的层    
	//public static const SLCnt:uint = SLFog + 1;			// 总共层的数量 
	// KBEN:阻挡点信息，每一个 fScene 存储对这个的引用，是一个二位数组，第一维是行，第二位是列，减小内存，使用   Dictionary 不使用 Vector      
	//public var m_stopPointList:Vector.<Vector.<stopPoint>>;
	public var m_stopPointList : Dictionary;
	public var m_defaultStopPoint : stopPoint; // 默认的阻挡点，为了统一处理，不用总是 if else 判断    

	private var m_fogPlane : fFogPlane; // 存储雾的信息
	public var m_sceneType : uint; // 场景类型，普通场景还是战斗场景，战斗场景震动使用
	public var m_serverSceneID : uint; // 服务器场景 id
	public var m_filename : uint; // 客户端地图文件名字，没有扩展名字

	public var m_sortByBeingMove : Boolean = true; // 由于 being 移动是否需要重新排序，战斗场景不需要了，太多移动了
	public var m_path : String;

	public var m_timesOfShow : int = 0;
	public var m_disposed : Boolean = false;
	public var m_dicDebugInfo : Dictionary;

};

#endif