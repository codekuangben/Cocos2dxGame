#pragma 
#ifndef __MRenderableElement_H__
#define __MRenderableElement_H__

#include "MElement.h"

/**
* <p>The fRenderableElement class defines the basic interface for visible elements in your scene.</p>
*
* <p>Lights are NOT considered visible elements, therefore don't inherit from fRenderableElement</p>
*
* <p>YOU CAN'T CREATE INSTANCES OF THIS OBJECT</p>
*/
class MRenderableElement : public MElement
{
	// Public properties

	/**
	* Boolean value indicating if this object receives lighting. You can change this value dynamically.
	* Any element in your XML can be given a receiveLights="false|true" attribute in its XML definition
	*/
	public var receiveLights : Boolean = true;

	/**
	* Boolean value indicating if this object receives shadows. You can change this value dynamically
	* Any element in your XML can be given a receiveShadows="false|true" attribute in its XML definition
	*/
	//public var receiveShadows:Boolean = true;

	/**
	* Boolean value indicating if this object casts shadows. You can change this value dynamically
	* Any element in your XML can be given a castShadows="false|true" attribute in its XML definition
	*/
	//public var castShadows:Boolean = true;

	/**
	* Boolean value indicating if this object collides with others.
	* Any element in your XML can be given a solid="false|true" attribute in its XML definition. When a character moves to
	* a position that overlaps another element, if will trigger either the fCollide or the fWalkover Events, depending
	* on the solid property for that element.
	*
	* @see org.ffilmation.engine.events.fCollideEvent
	* @see org.ffilmation.engine.events.fWalkoverEvent
	*/
	//public var solid:Boolean = true;

	/**
	* A reference to the library movieclip that was attached to create the element, so you
	* can acces methods inside, nested clips or whatever.
	*
	* This property is null until the element's graphics have been created. This happens the first time the element scrolls into the viewport.
	* Listen to the <b>fRenderableElement.ASSETS_CREATED</b> event to know when this property exist.
	*
	*/
	public var flashClip : MovieClip;

	/**
	* <p><b>WARNING!!!: </b> This property only exists when the scene is being rendered and the graphic elements have been created. This
	* happens when you call fEngine.showScene(). Trying to access this property before the scene is shown ( to attach a Mouse Event for example )
	* will throw an error.</p>
	*
	* <p>The container is the base DisplayObject that contains everything. If you want to add Mouse Events to your elements, use this
	* property. Camera occlusion will be applied: this means that if this element was occluded to show the camera position,
	* its events are disabled as well so you can click on items behind this element.</p>
	*
	* <p>The container for each element will have two properties:</p>
	* <p>
	* <b>fElementId</b>: The ID for this element<br>
	* <b>fElement</b>: A pointer to the fElement this MovieClip represents<br>
	* </p>
	* <p>These properties will be useful when programming MouseEvents. Using them, you will be able to access the class from an Event
	* listener attached to the container
	*/
	public var container : fElementContainer;

	/** @private */
	public var _visible : Boolean = true;
	/** @private */
	public var x0 : Number;
	/** @private */
	public var y0 : Number;
	/** @private */
	public var x1 : Number;
	/** @private */
	public var y1 : Number;
	/** @private */
	public var top : Number;

	private var pendingDestiny : *= null;

	// These properties are used by the renderManager
	/////////////////////////////////////////////////

	/** @private */
	public var _depth : Number = 0;

	/** @private */
	public var depthOrder : int;

	/** @private */
	public var isVisibleNow : Boolean = false;

	/** @private */
	public var willBeVisible : Boolean = false;

	/** @private */
	public var bounds2d : Rectangle = new Rectangle(0, 0, 1, 1);

	/** @private */
	public var screenArea : Rectangle = new Rectangle();

	// KBEN: 名字标签包围盒子，也用来做点击裁剪，要足够小        
	public var m_tagBounds2d : Rectangle = new Rectangle(0, 0, 1, 1);

	// KBEN: 可渲染元素，必然有资源，字典中存放一个数组，里面存放是的每一个方向的资源      
	public var _resDic : Dictionary;	//[act,Dictionary]的集合。其中Dictionary的是[direction, SWFResource]
										// fObjectDefinition 是否初始化  
	public var m_ObjDefRes : SWFResource;

	// KBEN: 可绘制的元素属于的 fFloor 索引 
	//public var m_floorIdx:int = -1;	// -1 表示没有 floor ，按一行一行
	// KBEN: 资源类型，决定资源加载的目录  
	public var m_resType : uint = 0;
	protected var m_bDisposed : Boolean = false;
	protected var m_needDepthSort : Boolean = true;

	// Events
	/** @private */
	public static const DEPTHCHANGE : String = "renderableElementDepthChange";

	/**
	* The fRenderableElement.SHOW constant defines the value of the
	* <code>type</code> property of the event object for a <code>renderableElementShow</code> event.
	* The event is dispatched when the elements is shown via the show() method
	*
	* @eventType renderableElementShow
	*/
	public static const SHOW : String = "renderableElementShow";

	/**
	* The fRenderableElement.HIDE constant defines the value of the
	* <code>type</code> property of the event object for a <code>renderableElementHide</code> event.
	* The event is dispatched when the elements is hidden via the hide() method
	*
	* @eventType renderableElementHide
	*/
	public static const HIDE : String = "renderableElementHide";

	/**
	* @private
	* The fRenderableElement.ENABLE constant defines the value of the
	* <code>type</code> property of the event object for a <code>renderableElementEnable</code> event.
	* The event is dispatched when the elements's Mouse events are enabled
	*
	* @eventType renderableElementEnable
	*/
	public static const ENABLE : String = "renderableElementEnable";

	/**
	* @private
	* The fRenderableElement.DISABLE constant defines the value of the
	* <code>type</code> property of the event object for a <code>renderableElementDisable</code> event.
	* The event is dispatched when the elements's Mouse events are disabled
	*
	* @eventType renderableElementDisable
	*/
	public static const DISABLE : String = "renderableElementDisable";

	/**
	* The fRenderableElement.ASSETS_CREATED constant defines the value of the
	* <code>type</code> property of the event object for a <code>renderableElementAssetsCreated</code> event.
	* The event is dispatched when the element scrolls into view for the first time and its graphic assets are created.
	* It is used to know when the flashClip property exists.
	*
	* @eventType renderableElementAssetsCreated
	*/
	public static const ASSETS_CREATED : String = "renderableElementAssetsCreated";

	/**
	* The fRenderableElement.ASSETS_DESTROYED constant defines the value of the
	* <code>type</code> property of the event object for a <code>renderableElementAssetsDestroyed</code> event.
	* The event is dispatched when the element scrolls out of view and fEngine.conserveMemory is set to true. When this shappens all assets are
	* destroyed and the flashClip property is nullified.
	*
	* @eventType renderableElementAssetsCreated
	* Still WIP. Don't use yet !!
	* @private
	*/
	public static const ASSETS_DESTROYED : String = "renderableElementAssetsDestroyed";

};

#endif