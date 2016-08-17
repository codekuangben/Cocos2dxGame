#pragma once
#ifndef __MEnginePathfindCriteria_H__
#define __MEnginePathfindCriteria_H__

/**
* This interface defines the methods that any class that is to be used as pathFind criteria must implement
*/
class MEnginePathfindCriteria
{
public:
	MEnginePathfindCriteria();
	~MEnginePathfindCriteria();

	/**
	* This method return the origin point for this search
	* @return The origin point
	*/
	fPoint3d getOrigin();

	/**
	* This method return the destiny point for this search
	* @return The destiny point
	*/
	fPoint3d getDestiny();

	/**
	* This method return the origin cell for this search
	* @return The origin cell
	*/
	MCell getOriginCell();

	/**
	* This method return the destiny cell for this search
	* @return The destiny cell
	*/
	MCell getDestinyCell();

	/**
	* Returns a n heuristic value for any cell in the scene. The engine works with cell precision: any point inside the same cell
	* as the destination point has to be considered the destination point.
	*
	*	@param cell The cell for which we must calculate its heuristic
	* @return The heuristic score for this cell. A value of 0 indicates that we reached our objective
	*/
	float getHeuristic(MCell cell);

	/**
	* Returns a weighed list of a cells's accessible neighbours. This method updates each cell in the returned list, setting
	* its "cost" temporal property with the cost associated to move from the input cell into that cell.
	*
	* @return An array of fCells.
	*/
	Array getAccessibleFrom(MCell cell);
};

#endif