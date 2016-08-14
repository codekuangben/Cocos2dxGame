#pragma once
#ifndef __MBox_H__
#define __MBox_H__

/**
* Geometric representation of a box. It is used as base for collisionModels and shadowModels
* @private
*/
class MBox
{
public:
	MBox();
	MBox(float width, float depth, float height);
	~MBox();

	// Public vars

	/**
	* size along x-axis
	*/
	public var _width : Number;

	/**
	* size along y-axis
	*/
	public var _depth : Number;

	/**
	* size along z-axis
	*/
	public var _height : Number;
};

#endif