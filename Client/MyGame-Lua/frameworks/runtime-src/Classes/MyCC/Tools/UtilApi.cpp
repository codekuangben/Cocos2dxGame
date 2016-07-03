#include "UtilApi.h"

Size UtilApi::getStageVisibleSize()
{
	return Director::getInstance()->getVisibleSize();
}

Vec2 UtilApi::getStageVisibleOrigin()
{
	return Director::getInstance()->getVisibleOrigin();
}