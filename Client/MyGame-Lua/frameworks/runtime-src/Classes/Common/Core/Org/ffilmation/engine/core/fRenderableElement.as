package org.ffilmation.engine.core
{
	// Imports
	//import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.SWFResource;
	import common.Context;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.ffilmation.engine.interfaces.fMovingElement;
	import org.ffilmation.utils.mathUtils;
	
	/**
	 * <p>The fRenderableElement class defines the basic interface for visible elements in your scene.</p>
	 *
	 * <p>Lights are NOT considered visible elements, therefore don't inherit from fRenderableElement</p>
	 *
	 * <p>YOU CAN'T CREATE INSTANCES OF THIS OBJECT</p>
	 */
	public class fRenderableElement extends fElement
	{
		// Public properties
		
		/**
		 * Boolean value indicating if this object receives lighting. You can change this value dynamically.
		 * Any element in your XML can be given a receiveLights="false|true" attribute in its XML definition
		 */
		public var receiveLights:Boolean = true;
		
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
		public var flashClip:MovieClip;
		
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
		public var container:fElementContainer;
		
		/** @private */
		public var _visible:Boolean = true;
		/** @private */
		public var x0:Number;
		/** @private */
		public var y0:Number;
		/** @private */
		public var x1:Number;
		/** @private */
		public var y1:Number;
		/** @private */
		public var top:Number;
		
		private var pendingDestiny:* = null;
		
		// These properties are used by the renderManager
		/////////////////////////////////////////////////
		
		/** @private */
		public var _depth:Number = 0;
		
		/** @private */
		public var depthOrder:int;
		
		/** @private */
		public var isVisibleNow:Boolean = false;
		
		/** @private */
		public var willBeVisible:Boolean = false;
		
		/** @private */
		public var bounds2d:Rectangle = new Rectangle(0, 0, 1, 1);
		
		/** @private */
		public var screenArea:Rectangle = new Rectangle();
		
		// KBEN: 名字标签包围盒子，也用来做点击裁剪，要足够小        
		public var m_tagBounds2d:Rectangle = new Rectangle(0, 0, 1, 1);
		
		// KBEN: 可渲染元素，必然有资源，字典中存放一个数组，里面存放是的每一个方向的资源      
		public var _resDic:Dictionary;	//[act,Dictionary]的集合。其中Dictionary的是[direction, SWFResource]
		// fObjectDefinition 是否初始化  
		public var m_ObjDefRes:SWFResource;
		
		// KBEN: 可绘制的元素属于的 fFloor 索引 
		//public var m_floorIdx:int = -1;	// -1 表示没有 floor ，按一行一行
		// KBEN: 资源类型，决定资源加载的目录  
		public var m_resType:uint = 0;
		protected var m_bDisposed:Boolean = false;
		protected var m_needDepthSort:Boolean=true;

		// Events
		/** @private */
		public static const DEPTHCHANGE:String = "renderableElementDepthChange";
		
		/**
		 * The fRenderableElement.SHOW constant defines the value of the
		 * <code>type</code> property of the event object for a <code>renderableElementShow</code> event.
		 * The event is dispatched when the elements is shown via the show() method
		 *
		 * @eventType renderableElementShow
		 */
		public static const SHOW:String = "renderableElementShow";
		
		/**
		 * The fRenderableElement.HIDE constant defines the value of the
		 * <code>type</code> property of the event object for a <code>renderableElementHide</code> event.
		 * The event is dispatched when the elements is hidden via the hide() method
		 *
		 * @eventType renderableElementHide
		 */
		public static const HIDE:String = "renderableElementHide";
		
		/**
		 * @private
		 * The fRenderableElement.ENABLE constant defines the value of the
		 * <code>type</code> property of the event object for a <code>renderableElementEnable</code> event.
		 * The event is dispatched when the elements's Mouse events are enabled
		 *
		 * @eventType renderableElementEnable
		 */
		public static const ENABLE:String = "renderableElementEnable";
		
		/**
		 * @private
		 * The fRenderableElement.DISABLE constant defines the value of the
		 * <code>type</code> property of the event object for a <code>renderableElementDisable</code> event.
		 * The event is dispatched when the elements's Mouse events are disabled
		 *
		 * @eventType renderableElementDisable
		 */
		public static const DISABLE:String = "renderableElementDisable";
		
		/**
		 * The fRenderableElement.ASSETS_CREATED constant defines the value of the
		 * <code>type</code> property of the event object for a <code>renderableElementAssetsCreated</code> event.
		 * The event is dispatched when the element scrolls into view for the first time and its graphic assets are created.
		 * It is used to know when the flashClip property exists.
		 *
		 * @eventType renderableElementAssetsCreated
		 */
		public static const ASSETS_CREATED:String = "renderableElementAssetsCreated";
		
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
		public static const ASSETS_DESTROYED:String = "renderableElementAssetsDestroyed";
		
		// Constructor
		/** @private */
		function fRenderableElement(defObj:XML, con:Context, noDepthSort:Boolean = false):void
		{
			// Previous
			super(defObj, con);
			
			// Lights enabled ?
			//var temp:XMLList = defObj.@receiveLights;
			//if (temp.length() == 1)
			//	this.receiveLights = (temp.toString() == "true");
			
			// Shadows enabled ?
			//temp = defObj.@receiveShadows;
			//if (temp.length() == 1)
			//	this.receiveShadows = (temp.toString() == "true");
			
			// Projects shadow ?
			//temp = defObj.@castShadows;
			//if (temp.length() == 1)
			//	this.castShadows = (temp.toString() == "true");
			
			// Solid ?
			//temp = defObj.@solid;
			//if (temp.length() == 1)
			//	this.solid = (temp.toString() == "true");
				
			// KBEN: 关闭所有灯光影响    
			this.receiveLights = false;
			
			// Screen area
			this.screenArea = this.bounds2d.clone();
			this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
			
			_resDic = new Dictionary();
		}
		
		/**
		 * Mouse management
		 */
		public function disableMouseEvents():void
		{
			dispatchEvent(new Event(fRenderableElement.DISABLE));
		}
		
		/**
		 * Mouse management
		 */
		public function enableMouseEvents():void
		{
			dispatchEvent(new Event(fRenderableElement.ENABLE));
		}
		
		/**
		 * Makes element visible
		 */
		public function show():void
		{
			if (!this._visible)
			{
				this._visible = true
				dispatchEvent(new Event(fRenderableElement.SHOW))
			}
		}
		
		/**
		 * Makes element invisible
		 */
		public function hide():void
		{
			if (this._visible)
			{
				this._visible = false;
				dispatchEvent(new Event(fRenderableElement.HIDE));
			}
		}
		
		/**
		 * Passes the stardard gotoAndPlay command to the base clip of this element
		 *
		 * @param where A frame number or frame label
		 */
		public function gotoAndPlay(where:*):void
		{
			if (this.flashClip)
				this.flashClip.gotoAndPlay(where);
			else
			{
				this.pendingDestiny = where;
				this.removeEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndStop);
				this.addEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndPlay);
			}
		}
		
		private function delayedGotoAndPlay(e:Event):void
		{
			this.removeEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndPlay);
			if (this.flashClip && this.pendingDestiny)
				this.flashClip.gotoAndPlay(this.pendingDestiny);
		}
		
		/**
		 * Passes the stardard gotoAndStop command to the base clip of this element
		 *
		 * @param where A frame number or frame label
		 */
		public function gotoAndStop(where:*):void
		{
			if (this.flashClip)
				this.flashClip.gotoAndStop(where);
			else
			{
				this.pendingDestiny = where;
				this.removeEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndPlay);
				this.addEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndStop);
			}
		}
		
		private function delayedGotoAndStop(e:Event):void
		{
			this.removeEventListener(fRenderableElement.ASSETS_CREATED, this.delayedGotoAndStop);
			if (this.flashClip && this.pendingDestiny)
				this.flashClip.gotoAndStop(this.pendingDestiny);
		}
		
		/**
		 * Calls a function of the base clip
		 *
		 * @param what Name of the function to call
		 *
		 * @param param An optional extra parameter to pass to the function
		 */
		public function call(what:String, param:* = null):void
		{
			if (this.flashClip)
				this.flashClip[what](param);
		}
		
		// Depth management
		// dispatchmsg:Boolean = true 是否分发消息
		/** @private */
		public final function setDepth(d:Number, dispatchmsg:Boolean = true):void
		{
			this._depth = d;
			
			// Reorder all objects
			if(dispatchmsg)
			{
				this.dispatchEvent(new Event(fRenderableElement.DEPTHCHANGE));
			}
		}
		
		/**
		 * Return the 2D distance from this element to any world coordinate
		 */
		public function distance2d(x:Number, y:Number, z:Number):Number
		{
			var p2d:Point = fScene.translateCoords(x, y, z);
			return this.distance2dScreen(p2d.x, p2d.y);
		}
		
		/**
		 * Return the 2D distance from this element to any screen coordinate
		 */
		public function distance2dScreen(x:Number, y:Number):Number
		{
			// Characters move. Update their screen Area
			if (this is fMovingElement)
			{
				this.screenArea = this.bounds2d.clone();
				this.screenArea.offsetPoint(fScene.translateCoords(this.x, this.y, this.z));
			}
			
			// Test bounds
			var bounds:Rectangle = this.screenArea;
			var pos2D:Point = new Point(x, y);
			var dist:Number = Infinity;
			if (bounds.contains(pos2D.x, pos2D.y))
				return 0;
			
			var corner1:Point = new Point(bounds.left, bounds.top);
			var corner2:Point = new Point(bounds.left, bounds.bottom);
			var corner3:Point = new Point(bounds.right, bounds.bottom);
			var corner4:Point = new Point(bounds.right, bounds.top);
			
			var d:Number = mathUtils.distancePointToSegment(corner1, corner2, pos2D);
			if (d < dist)
				dist = d;
			d = mathUtils.distancePointToSegment(corner2, corner3, pos2D);
			if (d < dist)
				dist = d;
			d = mathUtils.distancePointToSegment(corner3, corner4, pos2D);
			if (d < dist)
				dist = d;
			d = mathUtils.distancePointToSegment(corner4, corner1, pos2D);
			if (d < dist)
				dist = d;
			
			return dist;
		}
		
		/** @private */
		public function disposeRenderable():void
		{
			this.flashClip = null;
			this.container = null;			
		}
		
		/** @private */
		public override function dispose():void
		{
			m_bDisposed = true;
			super.dispose();
			this.disposeRenderable();
		}
		
		public function loadRes(act:uint, direction:uint):void
		{
			
		}
		
		public function loadObjDefRes():void
		{
			
		}
		
		// KBEN: 渲染显示会回调这个函数     
		public function showRender():void
		{
			
		}
		
		// KBEN: 渲染隐藏会回调这个函数     
		public function hideRender():void
		{
			
		}	
		
		// 判断某个资源的动作是否加载 
		public function actLoaded(act:uint, direction:uint):Boolean
		{
			// bug: 性能
			//return (this._resDic[act] && this._resDic[act][direction] && this._resDic[act][direction].isLoaded && !this._resDic[act][direction].didFail)
			// 分开写提高性能
			//var resact:Vector.<SWFResource>;
			var resact:Dictionary;
			resact = this._resDic[act];
			if (resact)
			{
				if (resact[direction])
				{
					if (resact[direction].isLoaded)
					{
						if (!resact[direction].didFail)
						{
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		public function actByRes(res:SWFResource):uint
		{
			for (var key:String in _resDic)
			{
				if (_resDic[key] == res)
				{
					return parseInt(key);
				}
			}
			
			return 0;
		}
		
		public function get resDic():Dictionary 
		{
			return _resDic;
		}
		
		public function onMouseEnter():void
		{
			
		}
		public function onMouseLeave():void
		{
			
		}
		
		// 这个主要用在有些 npc 需要放在的地物层，永远放在人物层下面，不排序
		public function get layer():uint
		{
			return 0;
		}
		
		public function set layer(value:uint):void
		{
			
		}
		public function get isDisposed():Boolean
		{
			return m_bDisposed;
		}
		
		// KBEN:
		override public function onTick(deltaTime:Number):void
		{
			// KBEN: 可视化判断，需要添加
			if (this._visible && this.isVisibleNow)
			{
				if (customData.flash9Renderer)
				{
					customData.flash9Renderer.onTick(deltaTime);
				}
			}
		}
		
		public function set needDepthSort(bNeed:Boolean):void
		{
			m_needDepthSort = bNeed;
		}
	}
}