#include "MSceneRenderableElement.h"

MSceneRenderableElement::MSceneRenderableElement(XML defObj, MScene scene):void
{
	this.scene = scene;
	super(defObj, scene.engine.m_context);
}