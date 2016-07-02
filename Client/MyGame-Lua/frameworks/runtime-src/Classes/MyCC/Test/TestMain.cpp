#include "TestMain.h"
#include "TestClipNode/TestClipNode.h"

#include "cocos2d.h"

USING_NS_CC;

TestMain::TestMain()
{
	mTestClipNode = TestClipNode::create();
}

void TestMain::run()
{
	Scene* pScene = Director::getInstance()->getRunningScene();
	pScene->addChild(mTestClipNode);
	mTestClipNode->init();
}