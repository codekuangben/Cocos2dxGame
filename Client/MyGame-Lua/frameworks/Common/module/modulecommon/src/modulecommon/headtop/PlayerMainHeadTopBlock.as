package modulecommon.headtop
{
	//import com.bit101.components.Component;
	//import com.bit101.components.Label;
	//import com.bit101.components.PushButton;
	//import flash.events.MouseEvent;
	import modulecommon.GkContext;
	import modulecommon.scene.beings.PlayerMain;
	
	/**
	 * ...
	 * @author
	 */
	public class PlayerMainHeadTopBlock extends HeadTopPlayerStateBase
	{
		public function PlayerMainHeadTopBlock(gk:GkContext, player:PlayerMain)
		{
			super(gk, player);	
		}
		
		override protected function showNormal():void
		{	
			addName(0xffffff);
			addCorpsName(0x00deff);
			addGuanzhiNameInArena(0xffde00);
			
			// 军团城市争夺战
			if(m_gkContext.m_corpsCitySys.inScene)	// 如果在军团城市争夺战中
			{
				addCorpsCoolTime(0x00deff);
			}
			if (m_player.isGM)
			{
				showGMName();
			}
		}
	}
}