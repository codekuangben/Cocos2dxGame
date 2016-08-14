#pragma once
#ifndef __MBox_H__
#define __MBox_H__

/**
* @private
* Every scene is fit into a grid that allows to simplify visiblity and projection calculations.
* This grid is formed of fCells, a container that keeps information necessary to perform all the public
* rendering calculations
*/
class MCell
{
public:
	MCell();
	~MCell();

	/**
	* The zIndex of a cell indicates the display order. Elements in cells with higher zIndexes cover
	* elements in cells with lower zIndexes
	*/
	public var zIndex : Number;

	/**
	* The x coordinate of this cell in the grid. The measure is array position, not pixels.
	*/
	public var i : Number;

	/**
	* The y coordinate of this cell in the grid. The measure is array position, not pixels.
	*/
	public var j : Number;

	/**
	* The z coordinate of this cell in the grid. The measure is array position, not pixels.
	*/
	public var k : Number;

	/**
	* The x coordinate in pixels of the center of this cell grid. 格子中心点的位置
	*/
	public var x : Number;

	/**
	* The y coordinate in pixels of the center of this cell grid.
	*/
	public var y : Number;

	/**
	* The z coordinate in pixels of the center of this cell grid.
	*/
	public var z : Number;

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
	public var visibleElements : Array;		// 这个存放的是 fVisibilityInfo 这个数据结构

											/**
											* The cell caches an array of elements sorted by distance to this cell
											*/
	public var m_visibleFloor : Vector.<fFloor>;		// 这个存放的是 fFloor 这个数据结构，但是可视化的内容与 visibleElements 都是一样的

														/**
														* The max distance from which the visibility info has been calculated
														*/
	public var visibleRange : Number = 0;

	/**
	* This is the character Shadow cache for this cell
	*/
	//public var characterShadowCache:Array;

	/**
	* This the list of events (type: fCellEvent) associated to this cell
	*/
	public var events : Array;

	/**
	* This is the list of elements that "cover" ( once translated and placed onscreen ) this cell
	* It is used to apply camera occlusion
	*/
	public var elementsInFront : Array;

	/**
	* This is the list of characters that occupy this cell
	*/
	public var charactersOccupying : Array;

	/**
	* The following are temporal properties that are used by pathFinding algorythms
	*/
	public var g : Number = 0;
	public var heuristic : Number = 0; // Heuristic score
	public var cost : Number = 0; // Movement cost 
	public var parent : fCell; // Needed to return a solution (trackback)
							   // KBEN: 阻挡点，本来没有必要在这里再存储一个阻挡点信息了，但是为了找到 fCell 直接找到阻挡点。其实可以从 fScene 中查找的      
	private var m_stoppoint : stopPoint;
	public var m_scrollRect : Rectangle;		// 这个是这个单元格子最大可见的范围，注意是格子左上角和右下角两个可见范围的并集
	public var m_updateDistrict : Dictionary;	// 当从 另外一个格子进入当前格子时，记录需要更新的内容区域(fFloor对象)列表，其实就是在前一次基础上迭代更新
	public var m_hideDistrict : Dictionary;	// 这个是进入当前格子需要隐藏的区域
	public var m_scene : fScene;
};

#endif