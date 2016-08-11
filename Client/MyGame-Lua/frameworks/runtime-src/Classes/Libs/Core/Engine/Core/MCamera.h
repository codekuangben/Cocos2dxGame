#pragma once
#ifndef __MCamera_H__
#define __MCamera_H__

#include "MElement.h"

class MCamera : public MElement
{
protected:
	// Constants
	private static var count : Number = 0;

	/**
	* Constructor for the fCamera class
	*
	* @param scene The scene associated to this camera
	*
	* @private
	*/
	private var m_scene : fScene;
	private var m_rect : Rectangle;			// 不用经常申请释放资源
											//public var m_scrollRect:Rectangle;		// 用来裁剪矩形，与 m_rect 不一样，有一点误差
											//public var m_logicPosX:Number = 0;		// 逻辑位置，就是完全和玩家的位置一样的
											//public var m_logicPosY:Number = 0;		// 逻辑位置，就是完全和玩家的位置一样的
	public var m_bInit : Boolean = false;

public:
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