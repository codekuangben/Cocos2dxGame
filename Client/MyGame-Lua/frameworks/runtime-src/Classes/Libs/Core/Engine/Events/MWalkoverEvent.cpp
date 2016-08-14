#include "MWalkoverEvent.h"

MWalkoverEvent::MWalkoverEvent()
{

}

MWalkoverEvent::~MWalkoverEvent()
{

}
		
// Constructor
		
/**
	* Constructor for the fWalkoverEvent class.
	*
	* @param type The type of the event. Event listeners can access this information through the inherited type property.
	*
	* @param victim The element of the scene we collide against
	*
	*/
function fWalkoverEvent(type:String, victim:fRenderableElement):void
{
	super(type);
	this.victim = victim;
}