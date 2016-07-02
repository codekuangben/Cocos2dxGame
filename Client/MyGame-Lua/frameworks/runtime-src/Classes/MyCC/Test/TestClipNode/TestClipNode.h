#ifndef __TestClipNode_H__
#define __TestClipNode_H__

#include "cocos2d.h"

class TestClipNode : public cocos2d::Layer
{
protected:
	cocos2d::ClippingNode* holesClipper; //�ü��ڵ�
	Node* holesStencil;         //ģ��ڵ�
	Node* holes;                //�װ�ڵ�

public:
	virtual bool init() override;
	//�����ص�
	void onTouchesBegan(const std::vector<cocos2d::Touch*>& touches, cocos2d::Event *unused_event);
	//���С��  
	void pokeHoleAtPoint(cocos2d::Vec2 point);

	// implement the "static create()" method manually
	CREATE_FUNC(TestClipNode);
};

#endif