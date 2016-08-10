#pragma once
#ifndef __MVector_H__
#define __MVector_H__

#include <vector>

template<class T>
class MVector
{
protected:
	std::vector<T> mData;

public:
	MVector();
	~MVector();
};

#endif