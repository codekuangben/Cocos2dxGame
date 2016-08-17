#pragma once
#ifndef __MCollideEvent_H__
#define __MCollideEvent_H__

/**
* <p>The fCollideEvent event class stores information about a collision event.</p>
*
* <p>This event is dispatched when a character in the engine collides whith another solid element in the scene
* </p>
*
*/
class MCollideEvent : public Event
{
public:
	MCollideEvent();
	~MCollideEvent();

	// Public

	/**
	* The element of the scene we collide against
	*/
	public var victim : fRenderableElement;
};

#endif