// This is the pathfind solver
package org.ffilmation.engine.logicSolvers.pathfindSolver
{
	// Imports
	import org.ffilmation.engine.core.fAiContainer;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.interfaces.fEnginePathfindCriteria;
	import org.ffilmation.engine.logicSolvers.lineOfSightSolver.fLineOfSightSolver;
	
	/**
	 * This is the pathfind solver. At this moment, only A* algorythm is supported, but I'd like to have a Dijkstra impementation as well
	 * @private
	 */
	public class fPathfindSolver
	{
		/**
		 * <p>Finds a path between 2 points, using an AStar search algorythm. It works in 3d.</p>
		 *
		 * @param criteria An object implementing the fEnginePathfindCriteria interface that contains the find criteria.
		 *
		 * @return	An array of 3dPoints describing the resulting path. Null if it fails
		 */
		public static function findPathAStar(criteria:fEnginePathfindCriteria):Array
		{
			var open:Array = new Array();
			var closed:Array = new Array();
			
			// Start coordinates
			var start:fCell = criteria.getOriginCell();
			if (start == null)
			{
				return null;
			}
			
			// Get final coordinates
			var goal:fCell = criteria.getDestinyCell();
			if (!goal || goal == start)
				return null;
			
			// Start at first node
			var node:fCell = start;
			node.g = 0;
			node.heuristic = criteria.getHeuristic(node);
			open[open.length] = node;
			
			var solved:Boolean = false;
			var i:int = 0;
			
			// Ok let's start
			while (!solved)
			{
				// This line can actually be removed
				if (i++ > fAiContainer.MAXSEARCHDEPTH)
				{
					trace("FindPath reached its depth limit without a solution");
					return null;
				}
				
				// Sort open list by cost
				open.sortOn("totalScore", Array.NUMERIC);
				if (open.length <= 0)
					break;
				node = open.shift();
				closed[closed.length] = node;
				
				// Could it be true, are we there?
				if (node == goal)
				{
					solved = true;
					break;
				}
				
				// Add neighbours to search list
				for each (var n:fCell in criteria.getAccessibleFrom(node))
				{
					if (closed.indexOf(n) >= 0)
					{
						continue;
					}
					if (open.indexOf(n) < 0)
					{
						open[open.length] = n;
						n.parent = node;
						n.heuristic = criteria.getHeuristic(n);
						n.g = node.g + n.cost;
					}					
					else
					{
						var newf:Number = n.cost + node.g + n.heuristic;
						if (newf < n.totalScore)
						{
							n.parent = node;
							n.g = n.cost + node.g;
						}
					}
					//if (closed.indexOf(n) < 0)
					//{
					//	trace("这是在close中");
					//}
				}
				
			}
			
			// The loop was broken,
			// see if we found the solution
			if (solved)
			{
				// We did! Format the data for use.
				var solution:Array = new Array();
				
				// Path uses the center point of the involved cells, we need to apply the offset from the real origin coordinate
				var origin:fPoint3d = criteria.getOrigin();
				var destiny:fPoint3d = criteria.getDestiny();
				var dx:Number = origin.x - start.x;
				var dy:Number = origin.y - start.y;
				//var dz:Number = origin.z - start.z;
				var dz:Number = 0;
				
				// Start at the end...
				solution[solution.length] = new fPoint3d(destiny.x, destiny.y, destiny.z);
				// ...walk all the way to the start to record where we've been...
				while (node.parent && node.parent != start)
				{
					node = node.parent;
					solution[solution.length] = new fPoint3d(node.x + dx, node.y + dy, node.z + dz);
				}
				// Uncomment this if you want the initial position to be part of the path
				//solution.push(new fPoint3d(origin.x, origin.y, origin.z))
				// 暂时去掉平滑
				// KBEN: 加入第一个点，主要是为了对路线进行平滑    
				solution.push(new fPoint3d(origin.x, origin.y, origin.z))
				solution.reverse();
				solution = fLineOfSightSolver.smoothPath(solution, (criteria as fDefaultPathfindCriteria).fscene);
				solution.shift();	// 将起始点移除 
				
				return solution;
			}
			else
			{
				// No solution found... :(
				return null;
			}
		}
	}
}