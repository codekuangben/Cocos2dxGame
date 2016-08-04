package game.ui.uichat.output 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelShowAndHide;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import modulecommon.res.ResGrid9;
	
	/**
	 * ...
	 * @author 
	 */
	public class VipPart extends PanelShowAndHide 
	{
		private var m_gkContext:GkContext;
		private var m_linkProcess:LinkProcess;
		private var m_ChatItem:ComChatItemVIP;
		
		public function VipPart(gk:GkContext, linkProcess:LinkProcess, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			
			var panel:Panel = new Panel(this, 5, 9);
			panel.setPanelImageSkin("commoncontrol/panel/word_vip.png");
			m_ChatItem = new ComChatItemVIP(gk, linkProcess, this, 40, 7);
			m_ChatItem.show();
			this.setSize(310, 75);
			this.setSkinGrid9Image9(ResGrid9.Stype11);
		}
		
		public function processstChannelChatUserCmd(cmd:stChannelChatUserCmd):void
		{
			m_ChatItem.setData(cmd);
			this.setSize(310, m_ChatItem.height + 17);
			this.y = -this.height;
		}
		
	}

}