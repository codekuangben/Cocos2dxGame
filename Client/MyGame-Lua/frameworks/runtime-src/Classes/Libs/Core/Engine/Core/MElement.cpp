package org.ffilmation.engine.core
{
	// Imports
	import com.pblabs.engine.core.ITickedObject;
	import common.Context;
	//import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.elements.fFloor;
	import org.ffilmation.engine.events.fMoveEvent;
	import org.ffilmation.engine.interfaces.fEngineElementController;
	import org.ffilmation.utils.mathUtils;
	
	/**
	 * <p>The fElement class defines the basic structure of anything in a filmation Scene</p>
	 *
	 * <p>All elements ( walls, floors, lights, cameras, etc ) inherit from fElement.</p>
	 *
	 * <p>The fElement provides basic position and movement functionality</p>
	 *
	 * <p>YOU CAN'T CREATE INSTANCES OF THIS OBJECT</p>
	 */
	// KBEN: 
	public class fElement extends EventDispatcher implements ITickedObject
	{	
		// This counter is used to generate unique element Ids for elements that don't have a specific Id in their XML definition
		/** @private */
		private static var count:Number = 0;
		
		/**
		 * The string identifier of this element. Use it as input parameter to the scene's .all Array
		 */
		public var id:String;
		
		/**
		 * This is the XML node from the scene XML that generated this element. It is useful if you want to add
		 * custom attributes to specific instances of your elements, and access them later from your app. For example,
		 * you could add descriptions to objects, and then display those descriptions when the user rollOvers that object.
		 */
		public var xmlObj:XML;
		
		/**
		 * Unique ID. This is automatically assigned and used internally in hashTables and such
		 * @private
		 */
		public var uniqueId:int;
		
		/**
		 * X coordinate fot this element
		 */
		public var x:Number;
		
		/**
		 * Y coordinate for this element
		 */
		public var y:Number;
		
		/**
		 * Z coordinate for this element
		 */
		public var z:Number;
		
		/**
		 * A reference to the cell where the element currently is
		 * @private
		 */
		public var cell:fCell;
		// KBEN: 元素所在的地形区域
		public var m_district:fFloor;
		
		/**
		 * A reference to the scene where this element belongs
		 * @private
		 */		
		public var m_context:Context;
		
		/**
		 * As elements are not defined as "dynamic", this property can be used to store extra info about this element at run-time.
		 */
		public var customData:Object;
		
		/**
		 * The fElement.MOVE constant defines the value of the
		 * <code>type</code> property of the event object for a <code>elementmove</code> event.
		 * The event is dispatched when the element moves. Allows elements to track and follow other elements
		 *
		 * @eventType elementmove
		 */
		public static const MOVE:String = "elementmove";
		
		/**
		 * The fElement.NEWCELL constant defines the value of the
		 * <code>type</code> property of the event object for a <code>elementnewcell</code> event.
		 * The event is dispatched when the element moves into a new cell.
		 *
		 */
		public static const NEWCELL:String = "elementnewcell";
		
		// KBEN: 元素销毁的时候发送这个事件，主要是为了自己逻辑层清理，这个是在引擎清理完毕后最后发送这个，这个仅仅是索引当前事件发送者，就不单独定义事件了    
		//public static const DISPOSE:String = "elementdispose";
		
		// Private.
		// This is the destination of this element, when following another element
		// KBEN: 这个需要子类访问
		//private var destx:Number;
		//private var desty:Number;
		//private var destz:Number;
		
		protected var destx:Number = 0;
		protected var desty:Number = 0;
		protected var destz:Number = 0;
		
		// This is the offset of this element, when following another element
		// KBEN: 这个需要子类访问
		//private var offx:Number;
		//private var offy:Number;
		//private var offz:Number;
		
		// bug: 防止值为 NaN，结果运算出错
		protected var offx:Number = 0;
		protected var offy:Number = 0;
		protected var offz:Number = 0;
		
		// How fast we fall into the destination point
		// KBEN: 这个需要子类访问
		//private var elasticity:Number;
		
		protected var elasticity:Number = 0;
		
		// Controller
		private var _controller:fEngineElementController = null;
		// KBEN: fFloor 
		
		/*
		 * Contructor for the fElement class.
		 *
		 * @param defObj: XML definition for this element. The XML attributes that will be parsed are ID,X,Y and Z
		 *
		 * @param scene: the scene where this element will be reated
		 */
		function fElement(defObj:XML, con:Context):void
		{
			// Id
			this.xmlObj = defObj;
			var temp:XMLList = defObj.@id;
			
			this.uniqueId = fElement.count++;
			if (temp.length() == 1)
				this.id = temp.toString();
			else
				this.id = "fElement_" + this.uniqueId;
			
			// Reference to container scene
			this.m_context = con;
			
			// Current cell position
			this.cell = null;
			
			// Basic coordinates
			this.x = new Number(defObj.@x[0]);
			this.y = new Number(defObj.@y[0]);
			this.z = new Number(defObj.@z[0]);
			if (isNaN(this.x))
				this.x = 0;
			if (isNaN(this.y))
				this.y = 0;
			if (isNaN(this.z))
				this.z = 0;
			
			this.customData = new Object();
		}
		
		/**
		 * Assigns a controller to this element
		 * @param controller: any controller class that implements the fEngineElementController interface
		 */
		public function set controller(controller:fEngineElementController):void
		{
			if (this._controller != null)
				this._controller.disable();
			this._controller = controller;
			if (this._controller)
				this._controller.assignElement(this);
		}
		
		/**
		 * Retrieves controller from this element
		 * @return controller: the class that is currently controlling the the fElement
		 */
		public function get controller():fEngineElementController
		{
			return this._controller;
		}
		
		/**
		 * Moves the element to a given position
		 *
		 * @param x: New x coordinate
		 *
		 * @param y: New y coordinate
		 *
		 * @param z: New z coordinate
		 *
		 */
		public function moveTo(x:Number, y:Number, z:Number):void
		{			
			// Set new coordinates			   
			this.x = x;
			this.y = y;
			this.z = z;			
		}
		
		/**
		 * Makes element follow target element
		 *
		 * @param target: The filmation element to be followed
		 *
		 * @param elasticity: How strong is the element attached to what is following. 0 Means a solid bind. The bigger the number, the looser the bind.
		 *
		 */
		public function follow(target:fElement, elasticity:Number = 0):void
		{
			this.offx = target.x - this.x;
			this.offy = target.y - this.y;
			this.offz = target.z - this.z;
			
			this.elasticity = 1 + elasticity;
			// KBEN: 如果这个地方跟随者没有移动，moveListener 这个函数就不会被调用
			target.addEventListener(fElement.MOVE, this.moveListener, false, 0, true);
		}
		
		/**
		 * Stops element from following another element
		 *
		 * @param target: The filmation element to be followed
		 *
		 */
		public function stopFollowing(target:fElement):void
		{
			target.removeEventListener(fElement.MOVE, this.moveListener);
		}
		
		// Listens for another element's movements
		/** @private */
		public function moveListener(evt:fMoveEvent):void
		{
			if (this.elasticity == 1)
				this.moveTo(evt.target.x - this.offx, evt.target.y - this.offy, evt.target.z - this.offz);
			else
			{
				this.destx = evt.target.x - this.offx;
				this.desty = evt.target.y - this.offy;
				this.destz = evt.target.z - this.offz;
				fEngine.stage.addEventListener('enterFrame', this.followListener, false, 0, true);
			}
		}
		
		/** Tries to catch up with the followed element
		 * @private
		 */
		public function followListener(evt:Event):void
		{
			var dx:Number = this.destx - this.x;
			var dy:Number = this.desty - this.y;
			var dz:Number = this.destz - this.z;
			try
			{
				this.moveTo(this.x + dx / this.elasticity, this.y + dy / this.elasticity, this.z + dz / this.elasticity);
			}
			catch (e:Error)
			{
			}
			
			// Stop ?
			if (dx < 1 && dx > -1 && dy < 1 && dy > -1 && dz < 1 && dz > -1)
			{
				fEngine.stage.removeEventListener('enterFrame', this.followListener);
			}
		}
		
		/**
		 * Returns the distance of this element to the given coordinate
		 *
		 * @return distance
		 */
		public function distanceTo(x:Number, y:Number, z:Number):Number
		{
			//return mathUtils.distance3d(x, y, z, this.x, this.y, this.z);
			return mathUtils.distance(x, y, this.x, this.y);
		}
		
		// Clean resources
		
		/** @private */
		public function disposeElement():void
		{
			this.xmlObj = null;
			this.cell = null;
			this._controller = null;
			if (fEngine.stage)
				fEngine.stage.removeEventListener('enterFrame', this.followListener);
			
			// KBEN: 上层逻辑销毁自己的时候，不用了，上层直接重载 dispose  
			//dispatchEvent(new Event(fElement.DISPOSE));
			this.m_context = null;
		}
		
		/** @private */
		public function dispose():void
		{
			this.customData.flash9Renderer = null;
			this.disposeElement();
		}
		
		// KBEN:
		public function onTick(deltaTime:Number):void
		{
			
		}
	}
}