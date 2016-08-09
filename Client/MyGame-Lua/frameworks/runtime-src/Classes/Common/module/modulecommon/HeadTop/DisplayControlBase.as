package modulecommon.headtop 
{
	import modulecommon.GkContext;
	import modulecommon.scene.beings.Player;
	/**
	 * ...
	 * @author ...
	 */
	public class DisplayControlBase 
	{
		protected var m_headTop:HeadTopPlayerStateBase;
		protected var m_gkContext:GkContext;
		protected var m_player:Player;
		public function DisplayControlBase(headTop:HeadTopPlayerStateBase) 
		{
			m_headTop = headTop;
			m_gkContext = m_headTop.gkContext;
			m_player = m_headTop.player;
		}
		public function update():void
		{
			
		}
		public function dispose():void
		{
			
		}
	}

}