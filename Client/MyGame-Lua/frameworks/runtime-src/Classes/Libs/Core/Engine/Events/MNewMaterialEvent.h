#pragma once
#ifndef __MNewMaterialEvent_H__
#define __MNewMaterialEvent_H__

/**
* <p>The fNewMaterial event class stores information about a NEWMATERIAL event.</p>
*
* <p>This event is by a plane when it gets assigned a new material using the assignMaterial() method</p>
* @see org.ffilmation.engine.core.fPlane#assignMaterial()
*/
class MNewMaterialEvent : public Event
{
public:
	MNewMaterialEvent();
	~MNewMaterialEvent();

	// Public

	/** Stores id of the new material
	* @private
	*/
	public var id : String;

	/** Width of the plane where the material was assigned
	* @private */
	public var width : Number;

	/** Height of the plane where the material was assigned
	* @private */
	public var height : Number;
};

#endif