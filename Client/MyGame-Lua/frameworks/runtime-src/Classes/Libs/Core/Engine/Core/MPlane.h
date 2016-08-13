#pragma once
#ifndef __MPlane_H__
#define __MPlane_H__

#include "MRenderableElement.h"

/**
* <p>fPlanes are the 2d surfaces that provide the main structure for any scene. Once created, planes can't be altered
* as the render engine relies heavily on precalculations that depend on the structure of the scene.</p>
*
* <p>Planes cannot be instantiated directly. Instead, fWall and fFloor are used.</p>
*
* <p>fPlane contains all the lighting, occlusions and shadowcasting code. They also support bump mapping</p>
*
* <p>YOU CAN'T CREATE INSTANCES OF THIS OBJECT</p>
*/
class fPlane : public MRenderableElement
{
	// Static properties

	/**
	* The fPlane.NEWMATERIAL constant defines the value of the
	* <code>type</code> property of the event object for a <code>planenewmaterial</code> event.
	* The event is dispatched when an new material is assigned to a plane
	*
	* @eventType elementmove
	*/
	public static const NEWMATERIAL : String = "planenewmaterial";

	// Public properties

	/**
	* Array of holes in this plane.
	* You can't create holes dynamically, they must be in the plane's material, but you can open and close them
	*
	* @see org.ffilmation.engine.core.fHole
	*/
	public var holes : Array; // Array of holes in this plane

							  /**
							  * Material currently applied to this plane. This object is shared between all planes using the same definition
							  */
	public var material : fMaterial;

	// Private properties

	/**
	* @private
	* This polygon represents 2D shape of the plane. For each plane the irrelevant axis is not taken into account
	*/
	public var shapePolygon : fPolygon;

	/** @private */
	public var zIndex : Number;

	private var planeWidth : Number;
	private var planeHeight : Number;
	public var scene : fScene;
};

#endif