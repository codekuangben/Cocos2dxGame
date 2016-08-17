#pragma once
#ifndef __MEventIn_H__
#define __MEventIn_H__

/**
* <p>The fEventIn event class stores information about an IN event.</p>
*
* <p>This event is dispatched whenever a character in the engine moves into a cell
* where an XML even was defined</p>
*
*/
class MEventIn : public Event
{
public:
	MEventIn();
	~MEventIn();

	// Public

	/**
	* Stores name of event
	*/
	public var name : String;

	/**
	* Stores XML of event
	*/
	public var xml : XML;

};

#endif