package modulecommon.headtop
{
	import modulecommon.GkContext;
	import modulecommon.scene.beings.Player;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import modulecommon.net.msg.fndcmd.stViewFriendDataFriendCmd;
	import modulecommon.scene.beings.PlayerArena;
	/**
	 * ...
	 * @author
	 */
	public class HeadTopPlayerArena extends HeadTopPlayerStateBase
	{
		private var m_watchBtn:PushButton;
		
		public function HeadTopPlayerArena(gk:GkContext, player:Player)
		{
			super(gk, player);
			
		}
		
		override protected function showNormal():void
		{
			var str:String;
			var namecolor:uint = 0x00ff0c;
			var guanzhinamecolor:uint = 0xffde00;
			var areannamecolor:uint = 0x00ff0c;
			
			addName(namecolor);
			//addGuanzhiNameInArena(guanzhinamecolor);
			
			var rank:uint = (m_player as PlayerArena).m_rank;
			if (rank > 0 && rank < 65535)
			{
				str = "排名 " + rank;
				addAutoData(str, areannamecolor, 18);
			}
			
			//竞技场中，模型头上查看玩家信息按钮
			if (null == m_watchBtn && m_player.name != m_gkContext.playerMain.name)
			{
				m_watchBtn = new PushButton(this, -(this.nameStrW / 2) - 18, -20, onWatchBtnClick);
				m_watchBtn.setSkinButton1Image("commoncontrol/menuicon/watch.png");
			}
		}
		
		private function onWatchBtnClick(event:MouseEvent):void
		{
			var msg:stViewFriendDataFriendCmd = new stViewFriendDataFriendCmd();
			msg.friendName = m_player.name;
			msg.type = stViewFriendDataFriendCmd.VIEWTYPE_RANK;
			m_gkContext.sendMsg(msg);
		}
	}

}