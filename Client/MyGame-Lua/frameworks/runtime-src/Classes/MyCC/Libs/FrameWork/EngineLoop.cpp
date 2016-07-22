#include "EngineLoop.h"
#include "MyCC/Test/TestMain.h"

EngineLoop::EngineLoop()
{
	mIsFirstEnterScene = true;
}

void EngineLoop::init()
{
	_event = Director::getInstance()->getEventDispatcher()->addCustomEventListener(Director::EVENT_AFTER_DRAW, std::bind(&EngineLoop::onDirectorEvent, this, std::placeholders::_1));
	_event->retain();
}

void EngineLoop::onDirectorEvent(EventCustom* evt)
{
	std::string eventName = evt->getEventName();
	if (eventName == Director::EVENT_AFTER_DRAW)
	{
		if (mIsFirstEnterScene)
		{
			mIsFirstEnterScene = false;

			//onFirstEnterScene();
		}
	}
}

void EngineLoop::onFirstEnterScene()
{
	TestMain* pTestMain = new TestMain();
	pTestMain->run();
}