package modulecommon.scene.beings 
{
	import modulecommon.headtop.HeadTopPlayerArena;
	import org.ffilmation.engine.core.fScene;
	
	/**
	 * ...
	 * @author 
	 * 竞技场中的人
	 */
	public class PlayerArena extends Player 
	{
		public var m_rank:uint;		//竞技场中排名
		
		public function PlayerArena(defObj:XML, scene:fScene) 
		{
			super(defObj, scene);
			m_headTopBlockBase = new HeadTopPlayerArena(gkcontext, this);
		}
		
	}

}