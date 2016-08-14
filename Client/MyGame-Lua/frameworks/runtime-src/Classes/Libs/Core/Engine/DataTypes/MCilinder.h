#pragma once
#ifndef __MCilinder_H__
#define __MCilinder_H__

/**
* Geometric representation of a cilinder. It is used as base for collisionModels and shadowModels
* @private
*/
class MCilinder
{
public:
	MCilinder();
	~MCilinder();

	// Public vars

	/**
	* Radius of this cilinder
	*/
	public var _radius : Number;

	/**
	* Height of this cilinder
	*/
	public var _height : Number;

};

#endif