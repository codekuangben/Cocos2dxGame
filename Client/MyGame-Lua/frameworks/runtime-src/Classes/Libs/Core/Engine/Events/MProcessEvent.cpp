#include "MProcessEvent.h"

MProcessEvent::MProcessEvent()
{

}

MProcessEvent::~MProcessEvent()
{

}

// Constructor
		
/**
	* Constructor for the fProcessEvent class.
	*
	* @param type The type of the event. Event listeners can access this information through the inherited type property.
	*
	* @param overall Overall process completion status, from 0 to 100
	*
	* @param overallDescription Overall process desccription
	*
	* @param current Cverall process completion status, from 0 to 100
	*
	* @param currentDescription Cverall process desccription
	*
	*/
function fProcessEvent(type:String, overall:Number, overallDescription:String, current:Number, currentDescription:String):void
{
	super(type);
	this.overall = overall;
	this.overallDescription = overallDescription;
	this.current = current;
	this.currentDescription = currentDescription;
	this.complete = overall == 100;
}