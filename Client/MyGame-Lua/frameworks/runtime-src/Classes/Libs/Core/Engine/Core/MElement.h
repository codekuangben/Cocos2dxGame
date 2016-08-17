#pragma once
#ifndef __MElement_H__
#define __MElement_H__

#include "EventDispatcher.h"
#include "ITickedObject.h"

class fElement : public EventDispatcher, public ITickedObject
{
	// This counter is used to generate unique element Ids for elements that don't have a specific Id in their XML definition
	/** @private */
	private static var count : Number = 0;

	/**
	* The string identifier of this element. Use it as input parameter to the scene's .all Array
	*/
	public var id : String;

	/**
	* This is the XML node from the scene XML that generated this element. It is useful if you want to add
	* custom attributes to specific instances of your elements, and access them later from your app. For example,
	* you could add descriptions to objects, and then display those descriptions when the user rollOvers that object.
	*/
	public var xmlObj : XML;

	/**
	* Unique ID. This is automatically assigned and used internally in hashTables and such
	* @private
	*/
	public var uniqueId : int;

	/**
	* X coordinate fot this element
	*/
	public var x : Number;

	/**
	* Y coordinate for this element
	*/
	public var y : Number;

	/**
	* Z coordinate for this element
	*/
	public var z : Number;

	/**
	* A reference to the cell where the element currently is
	* @private
	*/
	public var cell : fCell;
	// KBEN: 元素所在的地形区域
	public var m_district : fFloor;

	/**
	* A reference to the scene where this element belongs
	* @private
	*/
	public var m_context : Context;

	/**
	* As elements are not defined as "dynamic", this property can be used to store extra info about this element at run-time.
	*/
	public var customData : Object;

	/**
	* The fElement.MOVE constant defines the value of the
	* <code>type</code> property of the event object for a <code>elementmove</code> event.
	* The event is dispatched when the element moves. Allows elements to track and follow other elements
	*
	* @eventType elementmove
	*/
	public static const MOVE : String = "elementmove";

	/**
	* The fElement.NEWCELL constant defines the value of the
	* <code>type</code> property of the event object for a <code>elementnewcell</code> event.
	* The event is dispatched when the element moves into a new cell.
	*
	*/
	public static const NEWCELL : String = "elementnewcell";

	// KBEN: 元素销毁的时候发送这个事件，主要是为了自己逻辑层清理，这个是在引擎清理完毕后最后发送这个，这个仅仅是索引当前事件发送者，就不单独定义事件了    
	//public static const DISPOSE:String = "elementdispose";

	// Private.
	// This is the destination of this element, when following another element
	// KBEN: 这个需要子类访问
	//private var destx:Number;
	//private var desty:Number;
	//private var destz:Number;

	protected var destx : Number = 0;
	protected var desty : Number = 0;
	protected var destz : Number = 0;

	// This is the offset of this element, when following another element
	// KBEN: 这个需要子类访问
	//private var offx:Number;
	//private var offy:Number;
	//private var offz:Number;

	// bug: 防止值为 NaN，结果运算出错
	protected var offx : Number = 0;
	protected var offy : Number = 0;
	protected var offz : Number = 0;

	// How fast we fall into the destination point
	// KBEN: 这个需要子类访问
	//private var elasticity:Number;

	protected var elasticity : Number = 0;

	// Controller
	private var _controller : fEngineElementController = null;
	// KBEN: fFloor 

};

#endif