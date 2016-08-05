// Character class
package org.ffilmation.engine.logicSolvers.visibilitySolver
{
	// Imports
	import flash.geom.Point;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.elements.fFloor;
	import org.ffilmation.engine.elements.fObject;
	
	/**
	 * This class calculates visibilities: what is visible from a certain point, is element A visible from object B...
	 * @private
	 */
	public class fVisibilitySolver
	{
		/**
		 * Calculates elements visible given coordinates, sorted by distance.
		 *
		 * @param scene The scene we are calculating for
		 * @param x X coordinate from where we are "looking"
		 * @param y Y coordinate from where we are "looking"
		 * @param z Z coordinate from where we are "looking"
		 * @param range Elements further away than this distance are not taken into account. This optimizes the process
		 *
		 * @return An Array of fVisibilityInfo objects
		 */
		//public static function calcVisibles(scene:fScene, x:Number, y:Number, z:Number, range:Number = Infinity):Array
		//public static function calcVisibles(scene:fScene, x:Number, y:Number, z:Number, range:Number = Infinity, floorlist:Array = null):Array
		public static function calcVisibles(scene:fScene, cell:fCell, range:Number = Infinity, floorlist:Vector.<fFloor> = null):Array
		{
			// Init
			var rcell:Array = new Array, candidates:Array = new Array, floorc:fFloor, dist:Number, w:int, len:int, objc:fObject;
			//var p2d:Point = fScene.translateCoords(x, y, z);
			var p2d:Point = fScene.translateCoords(cell.x, cell.y, cell.z);
			
			// Use rTree to search for all eleemnts within range
			//var e=getTimer()
			
			// KBEN: 属性裁剪查查找
			//var t:Array = scene.allStatic2DRTree.intersects(new fCube(p2d.x - range, p2d.y - range, 0, p2d.x + range, p2d.y + range, 0));
			//len = t.length;
			
			//trace("Tree range:"+range+" "+len+" "+((getTimer()-e)/1000)+" de "+scene.allStatic2D.length)
			//var e=getTimer()
			
			// KBEN: 树形裁剪具体判断
			//for (w = 0; w < len; w++)
			//{
			//	var el:fRenderableElement = scene.allStatic2D[t[w]];
			//	dist = el.distance2dScreen(p2d.x, p2d.y);
			//	if (dist < range)
			//		candidates[candidates.length] = new fVisibilityInfo(el, dist);
			//}
			
			//trace("Distance "+((getTimer()-e)/1000))
			
			// This is the old method. I leave it here because the RTree has not yet been fully tested
			
			// Add floors
			/*
			   len = scene.floors.length
			   for(w=0;w<len;w++) {
			   floorc = scene.floors[w];
			   dist = floorc.distance2dScreen(p2d.x,p2d.y);
			   if(dist<range) candidates[candidates.length] = new fVisibilityInfo(floorc,dist);
			   }
			
			   // Add walls
			   len = scene.walls.length
			   for(w=0;w<len;w++) {
			   wallc = scene.walls[w];
			   dist = wallc.distance2dScreen(p2d.x,p2d.y);
			   if(dist<range) candidates[candidates.length] = new fVisibilityInfo(wallc,dist);
			   }
			
			   // Add objects
			   len = scene.objects.length
			   for(w=0;w<len;w++) {
			   objc = scene.objects[w];
			   dist = objc.distance2dScreen(p2d.x,p2d.y);
			   if(dist<range) candidates[candidates.length] = new fVisibilityInfo(objc,dist);
			   }
			 */
			
			// KBEN: 不用树裁剪了，好像有点问题，没有时间查啊，先用矩形裁剪吧
			// bug: 显示的裁剪矩形和场景裁剪矩形不一样
			//var left:int = int(scene.currentCamera.m_rect.x/scene.m_floorWidth);
			//var top:int = int(scene.currentCamera.m_rect.y/scene.m_floorDepth);			
			//var right:int = (scene.currentCamera.m_rect.x + scene.currentCamera.m_rect.width - 1) / scene.m_floorWidth;			
			//var bottom:int = (scene.currentCamera.m_rect.y + scene.currentCamera.m_rect.height - 1) / scene.m_floorDepth;
			
			//var left:int = int(scene.currentCamera.m_scrollRect.x/scene.m_floorWidth);
			//var top:int = int(scene.currentCamera.m_scrollRect.y/scene.m_floorDepth);			
			//var right:int = (scene.currentCamera.m_scrollRect.x + scene.currentCamera.m_scrollRect.width - 1) / scene.m_floorWidth;			
			//var bottom:int = (scene.currentCamera.m_scrollRect.y + scene.currentCamera.m_scrollRect.height - 1) / scene.m_floorDepth;
			
			var left:int = int(cell.m_scrollRect.x/scene.m_floorWidth);
			var top:int = int(cell.m_scrollRect.y/scene.m_floorDepth);			
			var right:int = (cell.m_scrollRect.x + cell.m_scrollRect.width - 1) / scene.m_floorWidth;			
			var bottom:int = (cell.m_scrollRect.y + cell.m_scrollRect.height - 1) / scene.m_floorDepth;
			
			// 获取格子
			var yidx:int = top;
			var xidx:int = 0;
			var floor:fFloor;
			while(yidx <= bottom)	// 从顶端到低端
			{
				xidx = left;
				while(xidx <= right)	// 从左边到右边
				{
					floor = scene.getFloorAt(xidx, yidx);
					candidates[candidates.length] = new fVisibilityInfo(floor, range);
					if(floorlist)
					{
						floorlist.push(floor);
					}
					// 这个本来应该在外面判断的，现在直接放在里面了
					//floor.willBeVisible = true;
					++xidx;
				}
				
				++yidx;
			}
			
			// 不用排序了，这里面就是地形
			// Sort results by distance to coords 
			//candidates.sortOn("distance", Array.NUMERIC);
			return candidates;
		}
		
		/**
		 * Calculates elements affected by lights at given coordinates, sorted by distance. For each element visible, elements casting shadows into it are
		 * also returned
		 *
		 * @param scene The scene we are calculating for
		 * @param x X coordinate from where we are "looking"
		 * @param y Y coordinate from where we are "looking"
		 * @param z Z coordinate from where we are "looking"
		 * @param range Elements further away than scene distance are not taken into account. This optimizes the process
		 *
		 * @return An Array of fShadowedVisibilityInfo objects
		 */
//		public static function calcAffectedByLight(scene:fScene, x:Number, y:Number, z:Number, range:Number = Infinity):Array
//		{
//			// Init
//			var rcell:Array = new Array, candidates:Array = new Array, allElements:Array = new Array, floorc:fFloor, dist:Number, w:Number, len:Number, wallc:fWall, objc:fObject;
//			var withObjects:Boolean = fEngine.objectShadows;
//			
//			// Use rTree to search for all elements within range
//			var t:Array = scene.allStatic3DRTree.intersects(new fCube(x - range, y - range, z - range, x + range, y + range, z + range));
//			len = t.length;
//			for (w = 0; w < len; w++)
//			{
//				var el:fRenderableElement = scene.allStatic3D[t[w]];
//				dist = el.distanceTo(x, y, z);
//				if (dist < range)
//				{
//					if (el is fFloor)
//					{
//						floorc = el as fFloor;
//						if (floorc.receiveLights)
//							if (floorc.z < z)
//								candidates[candidates.length] = (new fShadowedVisibilityInfo(floorc, dist));
//						if (floorc.castShadows)
//							allElements[allElements.length] = (new fShadowedVisibilityInfo(floorc, dist));
//					}
//					else if (el is fWall)
//					{
//						wallc = el as fWall;
//						if (wallc.receiveLights)
//							if ((wallc.vertical && wallc.x > x) || (!wallc.vertical && wallc.y < y))
//								candidates[candidates.length] = (new fShadowedVisibilityInfo(wallc, dist));
//						if (wallc.castShadows)
//							allElements[allElements.length] = (new fShadowedVisibilityInfo(wallc, dist));
//					}
//					else if (el is fObject)
//					{
//						objc = el as fObject;
//						if (objc.receiveLights)
//							candidates[candidates.length] = (new fShadowedVisibilityInfo(objc, dist));
//						if (withObjects)
//							if (objc.castShadows)
//								allElements[allElements.length] = (new fShadowedVisibilityInfo(objc, dist));
//					}
//				}
//			}
//			
//			// This is the old method. I leave it here because the RTree has not yet been fully tested
//			
//			/*
//			
//			   // Add possible floors
//			   len = scene.floors.length
//			   for(w=0;w<len;w++) {
//			   floorc = scene.floors[w]
//			   dist = floorc.distanceTo(x,y,z)
//			   if(dist<range) {
//			   if(floorc.receiveLights) if(floorc.z<z) candidates[candidates.length] = (new fShadowedVisibilityInfo(floorc,dist))
//			   if(floorc.castShadows) allElements[allElements.length] = (new fShadowedVisibilityInfo(floorc,dist))
//			   }
//			   }
//			
//			   // Add possible walls
//			   len = scene.walls.length
//			   for(w=0;w<len;w++) {
//			   wallc = scene.walls[w]
//			   dist = wallc.distanceTo(x,y,z)
//			   if(dist<range) {
//			   if(wallc.receiveLights) if((wallc.vertical && wallc.x>x) || (!wallc.vertical && wallc.y<y)) candidates[candidates.length] = (new fShadowedVisibilityInfo(wallc,dist))
//			   if(wallc.castShadows) allElements[allElements.length] = (new fShadowedVisibilityInfo(wallc,dist))
//			   }
//			   }
//			
//			   // Add possible objects
//			   len = scene.objects.length
//			   for(w=0;w<len;w++) {
//			   objc = scene.objects[w]
//			   dist = objc.distanceTo(x,y,z)
//			   if(dist<range) {
//			   if(objc.receiveLights) candidates[candidates.length] = (new fShadowedVisibilityInfo(objc,dist))
//			   if(withObjects) if(objc.castShadows) allElements[allElements.length] = (new fShadowedVisibilityInfo(objc,dist))
//			   }
//			   }
//			
//			 */
//			
//			// For each candidate, calculate possible shadows
//			var candidate:fShadowedVisibilityInfo, covered:Boolean, other:fShadowedVisibilityInfo, result:int, len2:Number
//			
//			len = candidates.length;
//			for (w = 0; w < len; w++)
//			{
//				candidate = candidates[w];
//				covered = false;
//				len2 = allElements.length;
//				
//				// Shadows from other elements
//				if (candidate.obj.receiveShadows)
//				{
//					for (var k:Number = 0; covered == false && k < len2; k++)
//					{
//						other = allElements[k];
//						if (candidate.obj != other.obj)
//						{
//							result = fCoverageSolver.calculateCoverage(other.obj, candidate.obj, x, y, z);
//							//trace("Test "+candidate.obj.id+" "+other.obj.id+" "+result)
//							switch (result)
//							{
//								case fCoverage.COVERED: 
//									covered = true;
//								case fCoverage.SHADOWED: 
//									candidate.addShadow(new fVisibilityInfo(other.obj, other.distance));
//							}
//						}
//					}
//				}
//				
//				// If not covered, sort shadows by distance to coords and add candidate to result list
//				if (!covered)
//				{
//					candidate.shadows.sortOn("distance", Array.NUMERIC);
//					rcell[rcell.length] = candidate;
//				}
//			}
//			
//			// Sort results by distance to coords 
//			rcell.sortOn("distance", Array.NUMERIC);
//			return rcell;
//		}
	}
}