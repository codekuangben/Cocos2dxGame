package org.ffilmation.engine.core.sceneLogic
{
	//import com.pblabs.engine.entity.EffectEntity;
	//import com.pblabs.engine.entity.EntityCValue;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.elements.fSceneObject;
	
	/**
	 * ...
	 * @author 
	 */
	public class fFObjectSceneLogic 
	{		
		// 进入新的单元格子处理   
		public static function processNewCellFObject(scene:fScene, fobj:fSceneObject, forceReset:Boolean = false):void
		{
			// KBEN: 是否更改 Floor 
			//fobj.updateFloorInfo(EntityCValue.TFallObject);
		}
		
		// 移动处理  
		public static function renderFObject(scene:fScene, fobj:fSceneObject):void
		{
			scene.renderEngine.updateFObjectPosition(fobj);
		}
	}
}