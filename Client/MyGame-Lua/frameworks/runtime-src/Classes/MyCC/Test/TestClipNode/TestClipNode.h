#ifndef __TestClipNode_H__
#define __TestClipNode_H__

#include "cocos2d.h"

class TestClipNode : public cocos2d::Layer
{
protected:
	cocos2d::ClippingNode* holesClipper; //裁剪节点
	Node* holesStencil;         //模板节点
	Node* holes;                //底板节点

public:
	virtual bool init() override;
	//触摸回调
	void onTouchesBegan(const std::vector<cocos2d::Touch*>& touches, cocos2d::Event *unused_event);
	//添加小洞  
	void pokeHoleAtPoint(cocos2d::Vec2 point);

	// implement the "static create()" method manually
	CREATE_FUNC(TestClipNode);
};

#endif