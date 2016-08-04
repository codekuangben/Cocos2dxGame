package org.ffilmation.engine.core 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class fSceneRenderableElement extends fRenderableElement 
	{
		public var scene:fScene;
		public function fSceneRenderableElement(defObj:XML, scene:fScene):void
		{
			this.scene = scene;
			super(defObj, scene.engine.m_context);
		}
		
	}

}