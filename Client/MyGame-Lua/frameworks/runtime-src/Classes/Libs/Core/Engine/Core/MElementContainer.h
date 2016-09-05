#pragma once
#ifndef __MElementContainer_H__
#define __MElementContainer_H__

/**
* <p>The fElementContainer is the root displayObject for a renderable Element while the scene is being rendered.</p>
*/
class MElementContainer : public Sprite
{
public:
	/**
	* The ID for this element.
	* Using this, you will be able to access the element from an Event listener attached to the container.
	*/
	MString fElementId;

	/**
	* A pointer to the fElement this container represents.
	* Using this, you will be able to access the element from an Event listener attached to the container.
	*/
	MRenderableElement fElement;

public:
	MElementContainer();
	~MElementContainer();
};

#endif