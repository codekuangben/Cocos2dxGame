#pragma once
#ifndef __MAiContainer_H__
#define __MAiContainer_H__

/**
 * <p>This object provides access to the AI methods of the engine.</p>
 */
class MAiContainer
{
	// Private properties
private:
	MScene scene;

public:
	MAiContainer();
	~MAiContainer();

	/**
	* This is the maximum depth pathfinding will reach before failing.
	*/
	public static const MAXSEARCHDEPTH : Number = 2000;	// 1000;

	/**
	* Constructor for the fAiContainer class
	*
	* @param scene The scene associated to this AI
	*
	* @private
	*/
	void MAiContainer(MScene scene);
	/**
	* <p>This methods returns an array of all the elements that cross an imaginary line between two points, sorted by distance to origin.
	* This is a CPU-intensive calculation: Try to use it sparingly.</p>
	*
	* @param fromx X coordinate for the origin
	* @param fromy Y coordinate for the origin
	* @param fromz Z coordinate for the origin
	* @param tox X coordinate for the destiny
	* @param toy Y coordinate for the destiny
	* @param toz Z coordinate for the destiny
	* @return An array of fCoordinateOccupant elements. If the array is null or empty there's nothing between the origin point and the end point.
	* If the origin point is outside the scene's limits, the method will return null.
	*/
	MArray calculateLineOfSight(float fromx, float fromy, float fromz, float tox, float toy, float toz);
	/**
	* <p>Finds a path between 2 points, using an AStar search algorythm. It works in 3d. This is a CPU-intensive calculation: If you have
	* several elements trying to find its way around at the same time, it will impact your performance: try to use it sparingly. If you
	* want an example of how to make a character walk around your scene using this, download the mynameisponcho sources from the download area.</p>
	*
	* <p>I took it from <a href="http://blog.baseoneonline.com/?p=87" target="_blank">here</a>. Thank you!</p>
	*
	* <p>TODO:
	* <ul>
	* <li>Accept a character as optional parameter and take its dimensions into account.</li>
	* <li>Include objects and try to find ways around them.</li>
	* <li>More precise hole calculations. Now it will try to search through any open hole.</li>
	* </ul></p>
	*
	* @param originx Origin point
	* @param destinyx Destination point
	* @param withDiagonals Is diagonal movement allowed for this calculation ?
	*
	* @return	An array of 3dPoints describing the resulting path. Null if it fails
	*/
	MArray findPath(MPoint3d origin, MPoint3d destiny, bool withDiagonals = true);
	/**
	* <p>Finds a path between 2 points, using an AStar search algorythm and a custom find criteria. It works in 3d. This is a CPU-intensive calculation: If you have
	* several elements trying to find its way around at the same time, it will impact your performance: try to use it sparingly.</p>
	*
	* @param criteria An object implementing the fEnginePathfindCriteria interface that contains the find criteria.
	*
	* @return	An array of 3dPoints describing the resulting path. Null if it fails
	*/
	MArray findPathCustomCriteria(MEnginePathfindCriteria criteria);

	//判断2点之间是否含有阻挡点
	bool hasStopBewteenPoint(float fromx, float fromy, float tox, float toy);
};

#endif