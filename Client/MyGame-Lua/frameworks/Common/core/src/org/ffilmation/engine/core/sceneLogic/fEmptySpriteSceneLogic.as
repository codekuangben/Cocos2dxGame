// EMPTY SPRITE LOGIC
package org.ffilmation.engine.core.sceneLogic
{
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.elements.fEmptySprite;
	
	/**
	 * This class stores static methods related to emptySprites in the scene
	 * @private
	 */
	public class fEmptySpriteSceneLogic
	{
		// Process New cell for EmptySprites
		public static function processNewCellEmptySprite(scene:fScene, spr:fEmptySprite, forceReset:Boolean = false):void
		{
			//spr.updateFloorInfo(EntityCValue.TEfffect);
		}
		
		// Main render method for EmptySprites
		public static function renderEmptySprite(scene:fScene, spr:fEmptySprite):void
		{
			// Move EmptySprites to its new position
			scene.renderEngine.updateEmptySpritePosition(spr);
		}
	}
}