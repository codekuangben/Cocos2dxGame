package org.ffilmation.engine.datatypes
{
	// Imports
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.ffilmation.engine.elements.fFloor;
	
	import org.ffilmation.engine.core.fScene;
	
	/**
	 * @private
	 * Every scene is fit into a grid that allows to simplify visiblity and projection calculations.
	 * This grid is formed of fCells, a container that keeps information necessary to perform all the public
	 * rendering calculations
	 */
	public class fCell
	{
		/**
		 * The zIndex of a cell indicates the display order. Elements in cells with higher zIndexes cover
		 * elements in cells with lower zIndexes
		 */
		public var zIndex:Number;
		
		/**
		 * The x coordinate of this cell in the grid. The measure is array position, not pixels.
		 */
		public var i:Number;
		
		/**
		 * The y coordinate of this cell in the grid. The measure is array position, not pixels.
		 */
		public var j:Number;
		
		/**
		 * The z coordinate of this cell in the grid. The measure is array position, not pixels.
		 */
		public var k:Number;
		
		/**
		 * The x coordinate in pixels of the center of this cell grid. 格子中心点的位置
		 */
		public var x:Number;
		
		/**
		 * The y coordinate in pixels of the center of this cell grid.
		 */
		public var y:Number;
		
		/**
		 * The z coordinate in pixels of the center of this cell grid.
		 */
		public var z:Number;
		
		/**
		 * If this cell "touches" any wall or floor, it is stored in this object. This information is used when
		 * moving objects throught the scene, in order to detect colisions. When an element moves from one cell
		 * to another, walls are cheched to see if any was inbetween
		 */
		//public var walls:fCellWalls;
		
		/**
		 * The cell caches an array of elements affected by lights. This array contains a list of all walls and floors "affected"
		 * from this cells' center point, along with coverage info. This speeds up light and shadow calculations, as only
		 * the fist time a cell is activated the algorythm builds the visibility info
		 */
		//public var lightAffectedElements:Array;
		
		/**
		 * The max distance from which the light info has been calculated
		 */
		//public var lightRange:Number = 0;
		
		/**
		 * The cell caches an array of elements sorted by distance to this cell
		 */
		public var visibleElements:Array;		// 这个存放的是 fVisibilityInfo 这个数据结构
		
		/**
		 * The cell caches an array of elements sorted by distance to this cell
		 */
		public var m_visibleFloor:Vector.<fFloor>;		// 这个存放的是 fFloor 这个数据结构，但是可视化的内容与 visibleElements 都是一样的
		
		/**
		 * The max distance from which the visibility info has been calculated
		 */
		public var visibleRange:Number = 0;
		
		/**
		 * This is the character Shadow cache for this cell
		 */
		//public var characterShadowCache:Array;
		
		/**
		 * This the list of events (type: fCellEvent) associated to this cell
		 */
		public var events:Array;
		
		/**
		 * This is the list of elements that "cover" ( once translated and placed onscreen ) this cell
		 * It is used to apply camera occlusion
		 */
		public var elementsInFront:Array;
		
		/**
		 * This is the list of characters that occupy this cell
		 */
		public var charactersOccupying:Array;
		
		/**
		 * The following are temporal properties that are used by pathFinding algorythms
		 */
		public var g:Number = 0;
		public var heuristic:Number = 0; // Heuristic score
		public var cost:Number = 0; // Movement cost 
		public var parent:fCell; // Needed to return a solution (trackback)
		// KBEN: 阻挡点，本来没有必要在这里再存储一个阻挡点信息了，但是为了找到 fCell 直接找到阻挡点。其实可以从 fScene 中查找的      
		private var m_stoppoint:stopPoint;
		public var m_scrollRect:Rectangle;		// 这个是这个单元格子最大可见的范围，注意是格子左上角和右下角两个可见范围的并集
		public var m_updateDistrict:Dictionary;	// 当从 另外一个格子进入当前格子时，记录需要更新的内容区域(fFloor对象)列表，其实就是在前一次基础上迭代更新
		public var m_hideDistrict:Dictionary;	// 这个是进入当前格子需要隐藏的区域
		public var m_scene:fScene;
		
		public function get totalScore():Number
		{
			return g + heuristic
		}
		
		public function get stoppoint():stopPoint 
		{
			return m_stoppoint;
		}
		
		public function set stoppoint(value:stopPoint):void 
		{
			m_stoppoint = value;
		}
		
		// End pathfinding
		
		/**
		 * Constructor
		 */
		public function fCell(scene:fScene)
		{
			m_scene = scene;
			//this.characterShadowCache = new Array;
			//this.walls = new fCellWalls;
			this.events = new Array;
			this.elementsInFront = new Array;
			this.charactersOccupying = new Array;
		
			// KBEN: 从 fScene 中获取    
			// stoppoint = new stopPoint();
			// 
			//m_scrollRect = new Rectangle(this.x, this.y, this.m_scene.engine.m_context.m_config.m_curWidth, this.m_scene.engine.m_context.m_config.m_curHeight);
			m_scrollRect = new Rectangle();
			m_updateDistrict = new Dictionary();
			m_hideDistrict = new Dictionary();
		}
		
		public function updateScrollRect():void
		{
			var w:uint = this.m_scene.engine.m_context.m_config.m_curWidth;
			var h:uint = this.m_scene.engine.m_context.m_config.m_curHeight;
			
			m_scrollRect.x = int(this.x - (w >> 1) - this.m_scene.gridSizeHalf);
			m_scrollRect.y = int(this.y - (h >> 1) - this.m_scene.gridSizeHalf);
			
			m_scrollRect.width = w + this.m_scene.gridSize;
			m_scrollRect.height = h + this.m_scene.gridSize;;
			
			// 越界判断
			if(m_scrollRect.x < 0)
			{
				m_scrollRect.x = 0;
			}
			if(m_scrollRect.y < 0)
			{
				m_scrollRect.y = 0;
			}
			if(m_scrollRect.x + m_scrollRect.width > this.m_scene.m_scenePixelXOff + this.m_scene.widthpx())
			{
				m_scrollRect.width = this.m_scene.m_scenePixelXOff + this.m_scene.widthpx() - m_scrollRect.x;
			}
			if(m_scrollRect.y + m_scrollRect.height > this.m_scene.heightpx())
			{
				m_scrollRect.height = this.m_scene.heightpx() - m_scrollRect.y;
			}
		}
		
		/**
		 * Frees memory allocated by this cell
		 */
		public function dispose():void
		{
			var il:int =0;
			//this.walls.dispose();
			//if (this.lightAffectedElements)
			//{
			//	var il:int = this.lightAffectedElements.length;
			//	for (var i:int = 0; i < il; i++)
			//		delete this.lightAffectedElements[i];
			//	this.lightAffectedElements = null;
			//}
			if (this.visibleElements)
			{
				il = this.visibleElements.length;
				for (i = 0; i < il; i++)
					delete this.visibleElements[i];
				this.visibleElements = null;
			}
			//if (this.characterShadowCache)
			//{
			//	il = this.characterShadowCache.length;
			//	for (i = 0; i < il; i++)
			//		delete this.characterShadowCache[i];
			//	this.characterShadowCache = null;
			//}
			if (this.elementsInFront)
			{
				il = this.elementsInFront.length;
				for (i = 0; i < il; i++)
					delete this.elementsInFront[i];
				this.elementsInFront = null;
			}
			if (this.charactersOccupying)
			{
				il = this.charactersOccupying.length;
				for (i = 0; i < il; i++)
					delete this.charactersOccupying[i];
				this.charactersOccupying = null;
			}
			if (this.events)
			{
				il = this.events.length;
				for (i = 0; i < il; i++)
					delete this.events[i];
				this.events = null;
			}
			
			clearClip();
			m_updateDistrict = null;
			m_hideDistrict = null;
		}
		
		// 由于相机从之前的格子进入当前的格子，需要更新当前格子的显示区域列表
		public function updateByPreInCur(pregrid:fCell):void
		{
			if(!m_updateDistrict[pregrid])
			{
				if(pregrid)
				{
					m_updateDistrict[pregrid] = new Vector.<fFloor>();	// 兼容代码，用 Array
				}
				m_hideDistrict[pregrid] = new Vector.<fFloor>();
			}
			
			// 如果前一个格子存在
			if(pregrid)
			{
				// 更新更新列表
				var floor:fFloor;
				var updateDistrictList:Vector.<fFloor> = m_updateDistrict[pregrid];
				var pregridRect:Rectangle = pregrid.m_scrollRect;
				for each(floor in m_visibleFloor)
				{
					// 如果包含在前一个格子中，肯定不用更新了					
					if(!pregridRect.containsRect(floor.screenArea))
					{
						updateDistrictList.push(floor);
					}
				}
				var hideDistrict:Vector.<fFloor> = m_hideDistrict[pregrid];
				// 更新隐藏列表
				for each(floor in pregrid.m_visibleFloor)
				{
					// 如果上一个格子可见，这个格子不可见，必然是隐藏的区域
					if(m_visibleFloor.indexOf(floor) == -1)
					{
						hideDistrict.push(floor);
					}
				}
			}
			else
			{
				m_updateDistrict[pregrid] = m_visibleFloor;
			}
		}
		
		// 清理裁剪数据，以便重新生成
		public function clearClip():void
		{
			if(visibleElements)
			{
				visibleElements.length = 0;
				visibleElements = null;
			}
			if(m_visibleFloor)
			{
				m_visibleFloor.length = 0;
				m_visibleFloor = null;
			}
			
			var key:Object;
			if(m_updateDistrict)
			{
				for(key in m_updateDistrict)
				{
					if(m_updateDistrict[key])
					{
						m_updateDistrict[key].length = 0;
					}
					m_updateDistrict[key] = null;
				}
			}
			if(m_hideDistrict)
			{
				for(key in m_hideDistrict)
				{
					if(m_hideDistrict[key])
					{
						m_hideDistrict[key].length = 0;
					}
					m_hideDistrict[key] = null;
				}
			}
		}
	}
}