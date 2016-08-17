#pragma once
#ifndef __MCoordinateOccupant_H__
#define __MCoordinateOccupant_H__

// This object stores an renderable element and a coordinate in this element's local coordinate system
/**
* This object stores a renderable element and a coordinate in thie engine's coordinate system. Several methods in the
* engine return this.
*
* @see org.ffilmation.engine.core.fScene#translateStageCoordsToElements()
*/
class MCoordinateOccupant
{
public:
	MCoordinateOccupant();
	~MCoordinateOccupant();

	/**
	* Element that occupies the coordinate
	*/
	public var element : fRenderableElement;

	/** Coordinate in element local coordinates */
	public var coordinate : fPoint3d;
};

#endif