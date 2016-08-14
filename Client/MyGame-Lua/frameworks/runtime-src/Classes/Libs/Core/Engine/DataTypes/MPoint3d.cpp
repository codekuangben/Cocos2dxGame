#include "MPoint3d.h"

MPoint3d::MPoint3d()
{

}

MPoint3d::~MPoint3d()
{

}

/**
	* Constructor for the fPoint3d class
	*/
function fPoint3d(x:Number, y:Number, z:Number):void
{
	this.x = x;
	this.y = y;
	this.z = z;
}
		
/**
	* Return distance to another 3dPoint
	*
	* @param other Point to be comapred
	*
	* @return Distance betwenn points
	*/
public function distanceTo(other:fPoint3d):Number
{
	//return mathUtils.distance3d(this.x, this.y, this.z, other.x, other.y, other.z);
	return mathUtils.distance(this.x, this.y, other.x, other.y);
}
		
/** @private */
public function toString():String
{
	return ("fPoint3d: " + x + ", " + y + ", " + z);
}