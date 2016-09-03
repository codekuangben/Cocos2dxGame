#pragma once
#ifndef __MElement_H__
#define __MElement_H__

#include "EventDispatcher.h"
#include "ITickedObject.h"

class MElement : public EventDispatcher, public ITickedObject
{
private:
	// This counter is used to generate unique element Ids for elements that don't have a specific Id in their XML definition
	/** @private */
	static float count;

public:
	/**
	* The string identifier of this element. Use it as input parameter to the scene's .all Array
	*/
	MString id;

	/**
	* This is the XML node from the scene XML that generated this element. It is useful if you want to add
	* custom attributes to specific instances of your elements, and access them later from your app. For example,
	* you could add descriptions to objects, and then display those descriptions when the user rollOvers that object.
	*/
	XML xmlObj;

	/**
	* Unique ID. This is automatically assigned and used internally in hashTables and such
	* @private
	*/
	int uniqueId;

	/**
	* X coordinate fot this element
	*/
	float x;

	/**
	* Y coordinate for this element
	*/
	float y;

	/**
	* Z coordinate for this element
	*/
	float z;

	/**
	* A reference to the cell where the element currently is
	* @private
	*/
	MCell cell;
	// KBEN: 元素所在的地形区域
	MFloor m_district;

	/**
	* A reference to the scene where this element belongs
	* @private
	*/
	Context m_context;

	/**
	* As elements are not defined as "dynamic", this property can be used to store extra info about this element at run-time.
	*/
	Object customData;

	/**
	* The fElement.MOVE constant defines the value of the
	* <code>type</code> property of the event object for a <code>elementmove</code> event.
	* The event is dispatched when the element moves. Allows elements to track and follow other elements
	*
	* @eventType elementmove
	*/
	static const MString MOVE;

	/**
	* The fElement.NEWCELL constant defines the value of the
	* <code>type</code> property of the event object for a <code>elementnewcell</code> event.
	* The event is dispatched when the element moves into a new cell.
	*
	*/
	static const MString NEWCELL;

	// KBEN: 元素销毁的时候发送这个事件，主要是为了自己逻辑层清理，这个是在引擎清理完毕后最后发送这个，这个仅仅是索引当前事件发送者，就不单独定义事件了    
	//public static const DISPOSE:String = "elementdispose";

	// Private.
	// This is the destination of this element, when following another element
	// KBEN: 这个需要子类访问
	//private var destx:Number;
	//private var desty:Number;
	//private var destz:Number;

protected:
	float destx;
	float desty;
	float destz;

	// This is the offset of this element, when following another element
	// KBEN: 这个需要子类访问
	//private var offx:Number;
	//private var offy:Number;
	//private var offz:Number;

	// bug: 防止值为 NaN，结果运算出错
	float offx;
	float offy;
	float offz;

	// How fast we fall into the destination point
	// KBEN: 这个需要子类访问
	//private var elasticity:Number;
	float elasticity;

private:
	// Controller
	fEngineElementController _controller;
	// KBEN: fFloor 

public:
	MElement();
	~MElement();

	/*
	* Contructor for the fElement class.
	*
	* @param defObj: XML definition for this element. The XML attributes that will be parsed are ID,X,Y and Z
	*
	* @param scene: the scene where this element will be reated
	*/
	void fElement(XML defObj, Context con);
	/**
	* Assigns a controller to this element
	* @param controller: any controller class that implements the fEngineElementController interface
	*/
	void setController(MEngineElementController controller);
	/**
	* Retrieves controller from this element
	* @return controller: the class that is currently controlling the the fElement
	*/
	MEngineElementController getController();
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
	void moveTo(float x, float y, float z);
	/**
	* Makes element follow target element
	*
	* @param target: The filmation element to be followed
	*
	* @param elasticity: How strong is the element attached to what is following. 0 Means a solid bind. The bigger the number, the looser the bind.
	*
	*/
	void follow(MElement target, float elasticity = 0);
	/**
	* Stops element from following another element
	*
	* @param target: The filmation element to be followed
	*
	*/
	void stopFollowing(MElement target);
	// Listens for another element's movements
	/** @private */
	void moveListener(MMoveEvent evt);
	/** Tries to catch up with the followed element
	* @private
	*/
	void followListener(Event evt);
	/**
	* Returns the distance of this element to the given coordinate
	*
	* @return distance
	*/
	float distanceTo(float x, float y, float z);
	// Clean resources
	/** @private */
	void disposeElement();
	/** @private */
	void dispose();
	// KBEN:
	void onTick(float deltaTime);
};

#endif