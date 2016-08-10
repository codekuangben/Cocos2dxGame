#pragma once
#ifndef __MArray_H__
#define __MArray_H__

template<class T>
class MArray
{
protected:
	T mData[10];

public:
	MArray();
	~MArray();
};

#endif