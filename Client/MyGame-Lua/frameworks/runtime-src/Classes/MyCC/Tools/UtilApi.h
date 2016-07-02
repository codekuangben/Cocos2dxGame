#ifndef __UtilApi_H__
#define __UtilApi_H__

#include "cocos2d.h"

USING_NS_CC;

class UtilApi
{
public:
	static Size getStageVisibleSize();
	static Vec2 getStageVisibleOrigin();
};

#endif