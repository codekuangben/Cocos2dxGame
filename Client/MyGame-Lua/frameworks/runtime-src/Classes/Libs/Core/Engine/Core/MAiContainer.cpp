#include "MAiContainer.h"

MAiContainer::MAiContainer()
{

}

MAiContainer::~MAiContainer()
{

}

MAiContainer::MAiContainer(MScene scene)
{
	this.scene = scene;
}
		
MArray MAiContainer::calculateLineOfSight(float fromx, float fromy, float fromz, float tox, float toy, float toz)
{
	return fLineOfSightSolver.calculateLineOfSight(this.scene, fromx, fromy, fromz, tox, toy, toz);
}

MArray MAiContainer::findPath(MPoint3d origin, MPoint3d destiny, bool withDiagonals = true);
{
	return fPathfindSolver.findPathAStar(new fDefaultPathfindCriteria(this.scene, origin, destiny, withDiagonals));
}

MArray MAiContainer::findPathCustomCriteria(MEnginePathfindCriteria criteria)
{
	return fPathfindSolver.findPathAStar(criteria);
}
		
//判断2点之间是否含有阻挡点
bool MAiContainer::hasStopBewteenPoint(float fromx, float fromy, float tox, float toy)
{
	return fLineOfSightSolver.calculatePt2PtVisible(this.scene, fromx, fromy, tox, toy);
}