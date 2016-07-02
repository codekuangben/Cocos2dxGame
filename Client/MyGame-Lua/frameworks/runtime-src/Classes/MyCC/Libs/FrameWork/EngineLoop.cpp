#include "EngineLoop.h"
#include "MyCC/Test/TestMain.h"

void EngineLoop::init()
{
	TestMain* pTestMain = new TestMain();
	//pTestMain->run();

	_event = Director::getInstance()->getEventDispatcher()->addCustomEventListener(Director::EVENT_AFTER_DRAW, std::bind(&EngineLoop::onDirectorEvent, this, std::placeholders::_1));
	_event->retain();
}

void EngineLoop::onDirectorEvent(EventCustom* evt)
{
	std::string eventName = evt->getEventName();
}