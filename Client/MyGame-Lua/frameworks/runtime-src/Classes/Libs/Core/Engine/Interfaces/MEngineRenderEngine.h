#pragma once

#ifndef __MEngineRenderEngine_H__
#define __MEngineRenderEngine_H__

class MEngineRenderEngine
{
public:
	MEngineRenderEngine();
	~MEngineRenderEngine();

	virtual void initialize() = 0;
	virtual fElementContainer initRenderFor(MRenderableElement element);
	virtual void stopRenderFor(MRenderableElement element);
	virtual MovieClip getAssetFor(MRenderableElement element);

	virtual void updateCharacterPosition(MCharacter character);
	virtual void updateEmptySpritePosition(MEmptySprite spr);
	virtual void updateEffectPosition(EffectEntity effect);
	virtual void updateFogPosition(MFogPlane fog);
	virtual void updateFObjectPosition(MObject fobj);

	virtual void showElement(MRenderableElement element);
	virtual void hideElement(MRenderableElement element);
	virtual void enableElement(MRenderableElement element);
	virtual void disableElement(MRenderableElement element);

	virtual void setCameraPosition(MCamera camera);
	virtual void setViewportSize(float width, float height);

	virtual void startOcclusion(MRenderableElement element, MCharacter character);
	virtual void updateOcclusion(MRenderableElement element, MCharacter character);
	virtual void stopOcclusion(MRenderableElement element, MCharacter character);

	virtual Array translateStageCoordsToElements(float x, float y);
	virtual void dispose();
	virtual void setSceneLayer(value:Vector.<Sprite>);
	virtual Rectangle getScrollRect();
};

#endif