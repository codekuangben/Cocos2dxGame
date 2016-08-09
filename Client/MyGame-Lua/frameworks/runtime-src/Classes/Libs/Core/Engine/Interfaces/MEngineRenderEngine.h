#pragma once

#ifndef __MEngineRenderEngine_H__
#define __MEngineRenderEngine_H__

class MEngineRenderEngine
{
public:
	MEngineRenderEngine();
	~MEngineRenderEngine();

	virtual void initialize() = 0;
	virtual fElementContainer initRenderFor(element:fRenderableElement);
	virtual void stopRenderFor(element:fRenderableElement);
	virtual MovieClip getAssetFor(element:fRenderableElement);

	virtual void updateCharacterPosition(char:fCharacter);
	virtual void updateEmptySpritePosition(spr:fEmptySprite);
	virtual void updateEffectPosition(effect:EffectEntity);
	virtual void updateFogPosition(fog:fFogPlane);
	virtual void updateFObjectPosition(fobj:fObject);

	virtual void showElement(element:fRenderableElement);
	virtual void hideElement(element:fRenderableElement);
	virtual void enableElement(element:fRenderableElement);
	virtual void disableElement(element:fRenderableElement);

	virtual void setCameraPosition(camera:fCamera);
	virtual void setViewportSize(width:Number, height : Number);

	virtual void startOcclusion(element:fRenderableElement, character : fCharacter);
	virtual void updateOcclusion(element:fRenderableElement, character : fCharacter);
	virtual void stopOcclusion(element:fRenderableElement, character : fCharacter);

	virtual Array translateStageCoordsToElements(x:Number, y : Number);
	virtual void dispose();
	virtual void setSceneLayer(value:Vector.<Sprite>);
	virtual Rectangle getScrollRect();
};

#endif