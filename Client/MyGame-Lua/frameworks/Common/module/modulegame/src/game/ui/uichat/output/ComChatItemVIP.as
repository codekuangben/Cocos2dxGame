package game.ui.uichat.output 
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import modulecommon.GkContext;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	
	/**
	 * ...
	 * @author 
	 */
	public class ComChatItemVIP extends ComChatItem 
	{
		
		public function ComChatItemVIP(gk:GkContext, linkProcess:LinkProcess, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(gk, linkProcess, parent, xpos, ypos);
			_rtf.setSize(WIDTH-25, 50);
		}
		override public function setData(cmd:stChannelChatUserCmd):void
		{
			_rtf.clear();
			m_type = cmd.chatType;
			processChatCmd(cmd);
			var tf:TextField = _rtf.textfield;			
			_rtf.setSize(WIDTH - 25, tf.textHeight + 4);			
			this.height = tf.textHeight + 2;
		}
	}

}