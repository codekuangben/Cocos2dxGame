#pragma once
#ifndef __MOpenGLRenderEngine_H__
#define __MOpenGLRenderEngine_H__

#include "MEngineRenderEngine.h"

class MOpenGLRenderEngine : public MEngineRenderEngine
{
protected:

	// Private properties

	/** The scene rendered by this renderer */
	private var scene : fScene;

	/** The Sprite where this scene will be drawn  */
	private var container : Sprite;

	/** An array of all elementRenderers in this scene. An elementRenderer is a class that renders an specific element, for example a wallRenderer is associated to a fWall	*/
	private var renderers : Array;

	/** Viewport width */
	private var viewWidth : Number = 0;

	/** Viewport height */
	private var viewHeight : Number = 0;

	// KBEN: 渲染引擎层，这个仅仅是场景， UI 单独一层 
	private var m_SceneLayer : Vector.<Sprite>;
	// 保存的裁剪矩形
	public var m_scrollRect : Rectangle;
};

#endif