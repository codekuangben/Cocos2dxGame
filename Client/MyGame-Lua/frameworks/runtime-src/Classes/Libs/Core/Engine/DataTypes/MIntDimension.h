#pragma once
#ifndef __MIntDimension_H__
#define __MIntDimension_H__

/**
* The Dimension class encapsulates the width and height of a componentin a single object.<br>
* Note this Class use <b>int</b> as its parameters on purpose to avoid problems that happended in aswing before.
* @author iiley
*/
class MIntDimension
{
public:
	MIntDimension();
	~MIntDimension();

	public var width : int = 0;
	public var height : int = 0;
};

#endif