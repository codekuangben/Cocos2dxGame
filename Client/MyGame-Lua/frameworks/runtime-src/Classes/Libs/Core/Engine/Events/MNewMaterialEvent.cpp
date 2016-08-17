#include "MNewMaterialEvent.h"

MNewMaterialEvent::MNewMaterialEvent()
{

}

MNewMaterialEvent::`MNewMaterialEvent()
{

}
		
// Constructor
		
/**
	* Constructor for the fNewMaterial class.
	*
	* @param type The type of the event. Event listeners can access this information through the inherited type property.
	*
	* @param id Id for the new material
	*
	* @param width Width of the plane where the material was assigned
	*
	* @param height Height of the plane where the material was assigned
	*
	*/
function fNewMaterialEvent(type:String, id:String, width:Number = 1, height:Number = -1):void
{
	super(type);
	this.id = id;
	this.width = width;
	this.height = height;
}