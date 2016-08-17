#pragma once
#ifndef __MWalkoverEvent_H__
#define __MWalkoverEvent_H__

/**
* <p>The fWalkoverEvent event class stores information about a Walkover event.</p>
*
* <p>This event is dispatched when a character in the engine walks over a non-solid object in the scene. This is useful to collect items, for example.
* </p>
*
*/
class MWalkoverEvent : public Event
{
public:
	MWalkoverEvent();
	~MWalkoverEvent();

	// Public

	/**
	* The element of the scene we walk over
	*/
	public var victim : fRenderableElement;
};

#endif