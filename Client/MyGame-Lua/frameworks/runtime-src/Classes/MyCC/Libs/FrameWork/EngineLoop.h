#pragma once

#ifndef __EngineLoop_H__
#define __EngineLoop_H__

#include "cocos2d.h"

USING_NS_CC;

class EngineLoop
{
protected:
	EventListenerCustom*       _event;

public:
	void init();

	void onDirectorEvent(EventCustom* evt);
};

#endif