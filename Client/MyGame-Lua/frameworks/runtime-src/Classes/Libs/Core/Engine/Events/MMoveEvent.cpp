#include "MMoveEvent.h"

MMoveEvent::MMoveEvent()
{

}

MMoveEvent::~MMoveEvent()
{

}

// Constructor
		
/**
	* Constructor for the fMoveEvent class.
	*
	* @param type The type of the event. Event listeners can access this information through the inherited type property.
	*
	* @param dx The increment of the x coordinate that corresponds to this movement
	*
	* @param dy The increment of the y coordinate that corresponds to this movement
	*
	* @param dz The increment of the z coordinate that corresponds to this movement
	*
	*
	*/
function fMoveEvent(type:String, dx:Number, dy:Number, dz:Number):void
{
	super(type);
	this.dx = dx;
	this.dy = dy;
	this.dz = dz;
}