#pragma once

#ifndef __EngineLoop_H__
#define __EngineLoop_H__

#include "cocos2d.h"

USING_NS_CC;

class EngineLoop
{
protected:
	EventListenerCustom*       _event;
	bool mIsFirstEnterScene;

public:
	EngineLoop();
	void init();

	void onDirectorEvent(EventCustom* evt);
	void onFirstEnterScene();
};

#endif