#include "MEventIn.h"

MEventIn::MEventIn()
{

}

MEventIn::~MEventIn()
{

}

// Constructor
		
/**
	* Constructor for the fEventIn class.
	*
	* @param type The type of the event. Event listeners can access this information through the inherited type property.
	*
	* @param name Name that was given to this event in its XML definition
	*
	* @param XML node associated tot he event in the XMl file
	*
	*/
function fEventIn(type:String, name:String, xml:XML):void
{
	super(type, bubbles, cancelable);
	this.name = name;
	this.xml = xml;
}