#include "MEventOut.h"

MEventOut::MEventOut()
{

}

MEventOut::~MEventOut()
{

}
		
// Constructor
		
/**
	* Constructor for the fEventOut class.
	*
	* @param type The type of the event. Event listeners can access this information through the inherited type property.
	*
	* @param name Name that was given to this event in its XML definition
	*
	* @param XML node associated tot he event in the XMl file
	*
	*/
function fEventOut(type:String, name:String, xml:XML):void
{
	super(type);
	this.name = name;
	this.xml = xml;
}