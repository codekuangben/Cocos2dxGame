#include "MCoordinateOccupant.h"

MCoordinateOccupant::MCoordinateOccupant()
{

}

MCoordinateOccupant::~MCoordinateOccupant()
{

}

/**
	* Constructor for the fCoordinateOccupant class
	*/
function fCoordinateOccupant(element:fRenderableElement, x:Number, y:Number, z:Number):void
{
	this.element = element;
	this.coordinate = new fPoint3d(x, y, z);
}