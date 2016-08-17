#include "MCollideEvent.h"

MCollideEvent::MCollideEvent()
{

}

MCollideEvent::~MCollideEvent()
{

}
		
// Constructor
		
/**
	* Constructor for the fMoveEvent class.
	*
	* @param type The type of the event. Event listeners can access this information through the inherited type property.
	*
	* @param victim The element of the scene we collide against. If Null the event was triggered by an attemp to move a character autside the scene's limits
	*
	*/
function fCollideEvent(type:String, victim:fRenderableElement):void
{
	super(type);
	this.victim = victim;
}