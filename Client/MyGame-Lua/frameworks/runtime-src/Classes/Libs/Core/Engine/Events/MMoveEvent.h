#pragma once
#ifndef __MMoveEvent_H__
#define __MMoveEvent_H__

/**
* <p>The fMoveEvent event class stores information about a move event.</p>
*
* <p>This event is dispatched whenever an element in the engine changes position.
* This allows the engine to track objects and rerender the scene, as well as programming
* reactions such as one element following another</p>
*
*/
class MMoveEvent : public Event
{
public:
	MMoveEvent();
	~MMoveEvent();

	// Public

	/**
	* The increment of the x coordinate that corresponds to this movement. Equals new position - last position
	*/
	public var dx : Number;

	/**
	* The increment of the y coordinate that corresponds to this movement. Equals new position - last position
	*/
	public var dy : Number;

	/**
	* The increment of the z coordinate that corresponds to this movement. Equals new position - last position
	*/
	public var dz : Number;
};

#endif