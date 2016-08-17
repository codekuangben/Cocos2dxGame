#pragma once
#ifndef __MEventOut_H__
#define __MEventOut_H__

/**
* <p>The fEventIn event class stores information about an OUT event.</p>
*
* <p>This event is dispatched whenever a character in the engine moves outside a cell
* where an XML event was defined</p>
*
*/
class MEventOut : public Event
{
public:
	MEventOut();
	~MEventOut();

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