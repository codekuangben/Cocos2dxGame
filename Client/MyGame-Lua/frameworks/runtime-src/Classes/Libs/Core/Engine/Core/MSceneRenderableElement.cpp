public function fSceneRenderableElement(defObj:XML, scene:fScene):void
{
	this.scene = scene;
	super(defObj, scene.engine.m_context);
}