// Character class
package org.ffilmation.engine.logicSolvers.lineOfSightSolver
{
	// Imports
	//import com.bit101.components.Panel;
	import flash.geom.Point;
	import org.ffilmation.engine.core.fRenderableElement;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.datatypes.fCoordinateOccupant;
	import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.datatypes.IntPoint;
	import org.ffilmation.engine.elements.fCharacter;
	
	/**
	 * This class constains all methods related to line Of sight: what is visible from where
	 * @private
	 */
	public class fLineOfSightSolver
	{
		protected static var m_sPt2Vec:Vector.<Point>;
		/**
		 * This methods returns an array of all the elements that cross an imaginary line between two points, sorted by distance to origin.
		 *
		 * @return An array of fCoordinateOccupant elements. If the array is null or empty there's nothing between the origin point and the end point.
		 * If the origin point is outside the scene's limits, the method will return null.
		 */
		public static function calculateLineOfSight(scene:fScene, fromx:Number, fromy:Number, fromz:Number, tox:Number, toy:Number, toz:Number):Array
		{
			var ret:Array = new Array;
			
			// Normalize vector from origin to destiny
			var dx:Number = tox - fromx;
			var dy:Number = toy - fromy;
			var dz:Number = toz - fromz;
			var increment:Number = (scene.gridSize < scene.levelSize) ? scene.gridSize : scene.levelSize;
			
			var normal:Number = (dx > 0) ? dx : -dx;
			if (dy > 0)
				normal += dy;
			else
				normal -= dy;
			if (dz > 0)
				normal += dz;
			else
				normal -= dz;
			dx /= normal;
			dy /= normal;
			dz /= normal;
			
			// Retrieve elements from cells in the way
			var cx:Number = fromx;
			var cy:Number = fromy;
			var cz:Number = fromz;
			var destiny:fCell = scene.translateToCell(tox, toy, toz);
			var last:fCell = null;
			var candidates:Array = new Array;
			
			do
			{
				var cell:fCell = scene.translateToCell(cx, cy, cz);
				if (cell && cell != last)
				{
					//if (cell.walls.top && cell.walls.top._visible && candidates.indexOf(cell.walls.top) < 0)
					//	candidates[candidates.length] = (cell.walls.top);
					//if (cell.walls.bottom && cell.walls.bottom._visible && candidates.indexOf(cell.walls.bottom) < 0)
					//	candidates[candidates.length] = (cell.walls.bottom);
					//if (cell.walls.up && cell.walls.up._visible && candidates.indexOf(cell.walls.up) < 0)
					//	candidates[candidates.length] = (cell.walls.up);
					//if (cell.walls.down && cell.walls.down._visible && candidates.indexOf(cell.walls.down) < 0)
					//	candidates[candidates.length] = (cell.walls.down);
					//if (cell.walls.left && cell.walls.left._visible && candidates.indexOf(cell.walls.left) < 0)
					//	candidates[candidates.length] = (cell.walls.left);
					//if (cell.walls.right && cell.walls.right._visible && candidates.indexOf(cell.walls.right) < 0)
					//	candidates[candidates.length] = (cell.walls.right);
					
					//var n:Number = cell.walls.objects.length;
					//for (var i:Number = 0; i < n; i++)
					//{
					//	var o:fObject = cell.walls.objects[i];
					//	if (o && o._visible && candidates.indexOf(o) < 0)
					//		candidates[candidates.length] = (o);
					//}
					var n:Number = 0;
					var i:Number = 0;
					n = cell.charactersOccupying.length;
					for (i = 0; i < n; i++)
					{
						var c:fCharacter = cell.charactersOccupying[i];
						if (c && c._visible && candidates.indexOf(c) < 0)
							candidates[candidates.length] = (c);
					}
					
				}
				last = cell;
				cx += increment * dx;
				cy += increment * dy;
				cz += increment * dz;
				
			} while (cell && cell != destiny);
			
			// Check every element
			var nElements:uint = candidates.length;
			for (var i2:Number = 0; i2 < nElements; i2++)
			{
				var r:fCoordinateOccupant = fLineOfSightSolver.elementInLineOfSight(candidates[i2], fromx, fromy, fromz, tox, toy, toz);
				if (r)
					ret[ret.length] = r;
			}
			
			// Return
			return ret;
		}
		
		/**
		 * This method checks if the line between two points intersect a given element, and returns the intersection coordinate if any. Note that
		 * this method does not take into account other elements that might block the way between the origin point and the tested element
		 *
		 * @return An fCoordinate occupant object with the intersection point, or null if there is no intersection
		 */
		public static function elementInLineOfSight(ele:fRenderableElement, fromx:Number, fromy:Number, fromz:Number, tox:Number, toy:Number, toz:Number):fCoordinateOccupant
		{
			/*
			// Check floors
			if (ele is fFloor)
			{
				var f:fFloor = ele as fFloor;
				var inter1:Point = mathUtils.segmentsIntersect(fromx, fromz, tox, toz, f.x, f.z, f.x + f.width, f.z);
				if (inter1)
				{
					var inter2:Point = mathUtils.segmentsIntersect(fromy, fromz, toy, toz, f.y, f.z, f.y + f.depth, f.z);
					if (inter2)
					{
						// Confirm collision against holes
						if (fCollisionSolver.testFloorPointCollision(inter1.x, inter2.x, f.z, f))
							return new fCoordinateOccupant(ele, inter1.x, inter2.x, f.z);
					}
				}
			}
			
			// Check walls
			if (ele is fWall)
			{
				var w:fWall = ele as fWall;
				if (w.vertical)
				{
					inter1 = mathUtils.segmentsIntersect(fromx, fromy, tox, toy, w.x, w.y0, w.x, w.y1);
					if (inter1)
					{
						inter2 = mathUtils.segmentsIntersect(fromx, fromz, tox, toz, w.x, w.z, w.x, w.z + w.pixelHeight);
						if (inter2)
						{
							// Confirm collision against holes
							if (fCollisionSolver.testWallPointCollision(w.x, inter1.y, inter2.y, w))
								return new fCoordinateOccupant(ele, w.x, inter1.y, inter2.y);
						}
					}
				}
				else
				{
					inter1 = mathUtils.segmentsIntersect(fromx, fromy, tox, toy, w.x0, w.y, w.x1, w.y);
					if (inter1)
					{
						inter2 = mathUtils.segmentsIntersect(fromy, fromz, toy, toz, w.y, w.z, w.y, w.z + w.pixelHeight);
						if (inter2)
						{
							// Confirm collision against holes
							if (fCollisionSolver.testWallPointCollision(inter1.x, w.y, inter2.y, w))
								return new fCoordinateOccupant(ele, inter1.x, w.y, inter2.y);
						}
					}
				}
			}
			
			// Check objects
			if (ele is fObject)
			{
				var o:fObject = ele as fObject;
				// Notice that collision models always work with local coordinates, therefore all coordinates must be translated
				var test:fPoint3d = o.collisionModel.testSegment(fromx - o.x, fromy - o.y, fromz - o.z, tox - o.x, toy - o.y, toz - o.z);
				if (test)
					return new fCoordinateOccupant(ele, test.x + o.x, test.y + o.y, test.z + o.z);
			}
			*/
			
			return null;
		}
		
		// KBEN: 这个方法返回在两个点之间的格子是否有阻挡点，这个算法不准确  
/*		public static function calculatePt2PtVisible(scene:fScene, fromx:Number, fromy:Number, fromz:Number, tox:Number, toy:Number, toz:Number):Boolean
		{			
			// Normalize vector from origin to destiny
			var dx:Number = tox - fromx;
			var dy:Number = toy - fromy;
			var dz:Number = toz - fromz;
			var increment:Number = scene.gridSize;
			
			var normal:Number = (dx > 0) ? dx : -dx;
			if (dy > 0)
				normal += dy;
			else
				normal -= dy;
			if (dz > 0)
				normal += dz;
			else
				normal -= dz;
			dx /= normal;
			dy /= normal;
			dz /= normal;
			
			// Retrieve elements from cells in the way
			var cx:Number = fromx;
			var cy:Number = fromy;
			var cz:Number = fromz;
			var destiny:fCell = scene.translateToCell(tox, toy, toz);
			var last:fCell = null;
			
			do
			{
				var cell:fCell = scene.translateToCell(cx, cy, cz);
				if (cell && cell != last)
				{
					if (cell.stoppoint.isStop)
					{
						return false;
					}
				}
				last = cell;
				cx += increment * dx;
				cy += increment * dy;
				cz += increment * dz;
				
			} while (cell && cell != destiny);
			
			return true;
		}*/
		
		// KBEN: 这个方法返回在两个点之间的格子是否有阻挡点，这个算法准确  true - 没有阻挡点
		public static function calculatePt2PtVisible(scene:fScene, fromx:Number, fromy:Number, tox:Number, toy:Number):Boolean
		{
			// 格子索引都是从 0 开始的，例如，如果格子大小是 32 ，那么 [0, 31] 是第一个格子，[32, 63] 是第二个格子
			var startGridPos:IntPoint = new IntPoint();	// 起始格子索引
			startGridPos.x = (int)(fromx / scene.gridSize);
			startGridPos.y = (int)(fromy / scene.gridSize);
			var endGridPos:IntPoint = new IntPoint();	// 结束格子索引
			endGridPos.x = (int)(tox / scene.gridSize);
			endGridPos.y = (int)(toy / scene.gridSize);
			
			var minGrid:IntPoint = new IntPoint();
			var maxGrid:IntPoint = new IntPoint();
			
			minGrid.x = Math.min(startGridPos.x, endGridPos.x);
			minGrid.y = Math.min(startGridPos.y, endGridPos.y);
			maxGrid.x = Math.max(startGridPos.x, endGridPos.x);
			maxGrid.y = Math.max(startGridPos.y, endGridPos.y);
			
			
			var a:Number = toy - fromy;
			var b:Number = (fromx - tox);
			var c:Number = (tox - fromx) * toy - (toy - fromy) * tox;
			
			var i:int;
			var j:int;
			var k:int;
			var cell:fCell;
			
			if (m_sPt2Vec == null)
			{
				m_sPt2Vec = new Vector.<Point>(4);
			
				for (i = 0; i < 4; i++)
				{
					m_sPt2Vec[i] = new Point();
				}
			}
			var halfSize:Number = scene.gridSize / 2;
			var flag:Boolean;
			var flag2:Boolean;
			var data:Number;
			for (i = minGrid.x; i <= maxGrid.x; i++ )
			{
				for (j = minGrid.y; j <= maxGrid.y; j++)
				{
					cell = scene.getCellAt(i, j, 0);
					if (cell.stoppoint.isStop)
					{
						//顺时针方向
						m_sPt2Vec[0].x = cell.x - halfSize;
						m_sPt2Vec[0].y = cell.y - halfSize;
						
						m_sPt2Vec[1].x = cell.x + halfSize;
						m_sPt2Vec[1].y = m_sPt2Vec[0].y;
						
						m_sPt2Vec[2].x = m_sPt2Vec[1].x;
						m_sPt2Vec[2].y = cell.y + halfSize;
						
						m_sPt2Vec[3].x = m_sPt2Vec[0].x;
						m_sPt2Vec[3].y = m_sPt2Vec[2].y;
						
						data = a * m_sPt2Vec[0].x + b * m_sPt2Vec[0].y + c ;
						if (data == 0)
						{
							return false;
						}
						flag = data > 0;
						for (k = 1; k < 4; k++)
						{
							data = a * m_sPt2Vec[k].x + b * m_sPt2Vec[k].y + c ;
							if (data == 0)
							{
								return false;
							}
							flag2 = data > 0;
							if (flag != flag2)
							{
								return false;
							}
						}
					}
				}
			}
			return true;		
		}
	
		// KBEN: 路径平滑 
		public static function smoothPath(path:Array, scene:fScene):Array
		{
			var ptfir:fPoint3d;		// 平滑的第一个点    
			var ptsnd:fPoint3d;		// 平滑的第二个点  
			var curIdx:uint = 0;	// 指向 ptsnd 位置索引 
			
			if (path.length >= 3)
			{
				// 读取最前面两个值 
				ptfir = path[curIdx];
				//++curIdx;
				//++curIdx;
				curIdx += 2;
				ptsnd = path[curIdx];
				
				while (curIdx < path.length)
				{					
					// 平滑路径  
					if (calculatePt2PtVisible(scene, ptfir.x, ptfir.y, ptsnd.x, ptsnd.y))
					{
						path.splice(curIdx - 1, 1);
						if (curIdx < path.length)
						{
							ptsnd = path[curIdx];
						}
						else 
						{
							break;
						}
					}
					else 
					{
						ptfir = path[curIdx - 1];
						++curIdx;
						if (curIdx < path.length)
						{
							ptsnd = path[curIdx];
						}
						else
						{
							break;
						}
					}
				}
			}
			
			return path;
		}
	}
}