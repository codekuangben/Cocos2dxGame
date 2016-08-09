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

public:
	MOpenGLRenderEngine::MOpenGLRenderEngine(MScene scene, Sprite container, sceneLayer:Vector.<Sprite> = null);
	MOpenGLRenderEngine::~MOpenGLRenderEngine();
	MElementContainer MOpenGLRenderEngine::initRenderFor(MRenderableElement element);
	void MOpenGLRenderEngine::stopRenderFor(MRenderableElement element);
	MovieClip MOpenGLRenderEngine::getAssetFor(MRenderableElement element);

	void MOpenGLRenderEngine::updateCharacterPosition(MCharacter character);
	void MOpenGLRenderEngine::updateEmptySpritePosition(MEmptySprite spr);
	void MOpenGLRenderEngine::updateEffectPosition(EffectEntity effect);

	void MOpenGLRenderEngine::updateFObjectPosition(MObject fobj);
	void MOpenGLRenderEngine::updateFogPosition(MFogPlane fog);

	void MOpenGLRenderEngine::showElement(MRenderableElement element);
	void MOpenGLRenderEngine::hideElement(MRenderableElement element);
	void MOpenGLRenderEngine::enableElement(MRenderableElement element);
	void MOpenGLRenderEngine::disableElement(MRenderableElement element);	

	void MOpenGLRenderEngine::setCameraPosition(MCamera camera);
	void MOpenGLRenderEngine::setViewportSize(float width, float height);

	void MOpenGLRenderEngine::startOcclusion(MRenderableElement element, MCharacter character);
	void MOpenGLRenderEngine::updateOcclusion(MRenderableElement element, MCharacter character);
	void MOpenGLRenderEngine::stopOcclusion(MRenderableElement element, MCharacter character);

	Array MOpenGLRenderEngine::translateStageCoordsToElements(float x, float y);
	MElementContainer MOpenGLRenderEngine::getRenderContainer(DisplayObject obj, DisplayObject parent, MElementContainer eleCon);
	void MOpenGLRenderEngine::dispose();
	void MOpenGLRenderEngine::processGlobalIntensityChange(Event evt);
	void MOpenGLRenderEngine::processGlobalColorChange(Event evt);

	fFlash9ElementRenderer MOpenGLRenderEngine::createRendererFor(MRenderableElement element);
};

#endif