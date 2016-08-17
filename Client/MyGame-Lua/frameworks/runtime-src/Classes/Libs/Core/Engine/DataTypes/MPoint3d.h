#pragma once
#ifndef __MPoint3d_H__
#define __MPoint3d_H__

/**
* This object stores a tridimensional point
*/
class MPoint3d
{
public:
	MPoint3d();
	~MPoint3d();

	/** X coordinate */
	public var x : Number;

	/** Scene Y coordinate */
	public var y : Number;

	/** Scene Z coordinate */
	public var z : Number;
};

#endif