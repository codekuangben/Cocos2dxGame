package modulecommon.headtop
{

	import modulecommon.GkContext;
	import modulecommon.scene.beings.PlayerOther;
	import modulecommon.scene.beings.UserState;
	import org.ffilmation.engine.helpers.fUtil;
	
	/**
	 * ...
	 * @author
	 */
	public class PlayerOtherHeadTopBlock extends HeadTopPlayerStateBase
	{				
		public function PlayerOtherHeadTopBlock(gk:GkContext, player:PlayerOther)
		{
			super(gk, player);
		}

		override protected function showNormal():void
		{
			var namecolor:uint = 0x00ff0c;
			var corpsnamecolor:uint = 0x00deff;
			var guanzhinamecolor:uint = 0xffde00;
			var areannamecolor:uint = 0x00ff0c;

			//addName(0x00ff0c);
			//addCorpsName(0x00deff);
			//addGuanzhiNameInArena(0xffde00);
			
			if(m_gkContext.m_corpsCitySys.inScene)	// 如果在军团城市争夺战中
			{
				if(!fUtil.isSameCorps(m_gkContext.m_corpsMgr.m_corpsName, (m_player as PlayerOther).m_corpsName))
				{
					namecolor = 0xff0000;
					corpsnamecolor = 0xff0000;
					guanzhinamecolor = 0xff0000;
					areannamecolor = 0xff0000;
				}
				else
				{
					namecolor = 0x00ff0c;
					corpsnamecolor = 0x00ff0c;
					guanzhinamecolor = 0x00ff0c;
					areannamecolor = 0x00ff0c;
				}
			}
			
			addName(namecolor);
			addCorpsName(corpsnamecolor);
			addGuanzhiNameInArena(guanzhinamecolor);			
			
			/*if (m_player.isGM)
			{
				showGMName();
			}*/
		}

		public function get playerOther():PlayerOther
		{
			return m_player as PlayerOther;
		}		
	}
}