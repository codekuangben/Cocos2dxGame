package org.ffilmation.engine.logicSolvers.collisionSolver
{
	import org.ffilmation.engine.core.fRenderableElement;
	
	/**
	 * This a candidate to collide with a character, with its distance to that character
	 * @private
	 */
	public class fCollisionCandidate
	{
		public var element:fRenderableElement;
		public var distance:Number;
	}
}