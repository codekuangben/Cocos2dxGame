#pragma once
#ifndef __MCamera_H__
#define __MCamera_H__

#include "MElement.h"

class MCamera : public MElement
{
private:
	// Constants
	static unsigned int count;

	/**
	* Constructor for the fCamera class
	*
	* @param scene The scene associated to this camera
	*
	* @private
	*/
	MScene m_scene;
	Rectangle m_rect;			// ���þ��������ͷ���Դ
	//public var m_scrollRect:Rectangle;		// �����ü����Σ��� m_rect ��һ������һ�����
	//public var m_logicPosX:Number = 0;		// �߼�λ�ã�������ȫ����ҵ�λ��һ����
	//public var m_logicPosY:Number = 0;		// �߼�λ�ã�������ȫ����ҵ�λ��һ����

public:
	bool m_bInit;

public:
	MCamera();
	~MCamera();
	MCamera(MScene* scene);

	virtual void follow(MElement target, float elasticity = 0);
	virtual void MCamera::moveListener(MMoveEvent evt);
	virtual void MCamera::followListener(Event evt);
	virtual void MCamera::moveTo(float x, float y, float z);
	void MCamera::gotoPos(float xtarget, float ytarget, float ztarget);
	void MCamera::setViewportSize(float width, float height);

protected:
	bool MCamera::adjustPos(float targetx, float targety, float targetz);
};

#endif