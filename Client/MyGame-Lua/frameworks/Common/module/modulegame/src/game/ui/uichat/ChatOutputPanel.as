package game.ui.uichat
{
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.VScrollBar;
	import com.riaidea.text.RichTextField;
	import datast.QueueVec;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import game.ui.uichat.ChatItem;
	import com.util.UtilHtml;
	import game.ui.uichat.output.ChatLogic;
	import game.ui.uichat.output.ComChat;
	import game.ui.uichat.output.VipPart;

	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ChatOutputPanel extends Component
	{
		//private static const QUEUESIZE:uint = 52;	//聊天框内所能放的聊天消息的最大数量
		private var m_h:uint = 180;
		private var m_w:uint = 310;
		private var m_bottomHeight:uint = 25;
		private var m_tabBtnTop:uint = m_h - 20;
		
		private var m_gkContext:GkContext;
		private var m_uiChat:UIChat;
		private var m_chatWindow:ChatLogic;
		private var m_vipPart:VipPart;
		
		private var m_dicTabBtn:Dictionary;		
		private var m_bMouse:Boolean;
		
		public function ChatOutputPanel(gk:GkContext, uichat:UIChat) 
		{						
			m_gkContext = gk;
			m_uiChat = uichat;
			this.setSize(m_w, m_h);
			m_chatWindow = new ChatLogic(m_gkContext, m_uiChat, this, 0, 4);
			m_chatWindow.setSize(m_w, m_h - 26);
			
			m_dicTabBtn = new Dictionary();
			
			m_dicTabBtn[ChatLogic.TYPE_All] = createTabBtn("全部", ChatLogic.TYPE_All);
			m_dicTabBtn[ChatLogic.TYPE_WORLD] = createTabBtn("世界", ChatLogic.TYPE_WORLD);
			m_dicTabBtn[ChatLogic.TYPE_AREA] = createTabBtn("区域", ChatLogic.TYPE_AREA);
			m_dicTabBtn[ChatLogic.TYPE_System] = createTabBtn("系统",ChatLogic.TYPE_System);
			updateTableBtn();
			(m_dicTabBtn[ChatLogic.TYPE_All] as ButtonTabText).selected = true;
			updateTableBtnPos();
		}
	
		public function addMessage(msg:String, type:int = 0):void
		{			
			var cmd:stChannelChatUserCmd = new stChannelChatUserCmd();
			cmd.chatType = stChannelChatUserCmd.CHAT_SYS;
			cmd.data = msg;			
			
			processstChannelChatUserCmd(cmd);
		}
		
		public function updateTableBtn():void
		{
			var btn:ButtonTabText;
			if (m_gkContext.m_corpsMgr.hasCorps)
			{
				if (m_dicTabBtn[ChatLogic.TYPE_Corps] == undefined)
				{
					m_dicTabBtn[ChatLogic.TYPE_Corps] = createTabBtn("军团",ChatLogic.TYPE_Corps);
				}				
			}
			else
			{
				if (m_dicTabBtn[ChatLogic.TYPE_Corps] != undefined)
				{
					btn = m_dicTabBtn[ChatLogic.TYPE_Corps];
					if (btn.parent)
					{
						btn.parent.removeChild(btn);
					}
					btn.removeEventListener(MouseEvent.CLICK, onTabBtnClick);
					btn.dispose();
					delete m_dicTabBtn[ChatLogic.TYPE_Corps];
				}
			}
			updateTableBtnPos();
		}
		
		private function createTabBtn(name:String, tag:int):ButtonTabText
		{
			var btn:ButtonTabText = new ButtonTabText(this, 0, m_tabBtnTop, name, onTabBtnClick);
			btn.setPanelImageSkin("commoncontrol/button/buttonTab7.swf");
			btn.tag = tag;
			return btn;
		}
		
		private function updateTableBtnPos():void
		{
			var i:int;
			var btn:ButtonTabText;
			var left:Number = 2;
			for (i = 0; i <= ChatLogic.TYPE_System; i++)
			{
				btn = m_dicTabBtn[i];
				if (btn)
				{
					btn.x = left;
					left += 58;
				}
			}
		}
		
		private function onTabBtnClick(e:MouseEvent):void
		{
			m_chatWindow.setCurType((e.currentTarget as ButtonTabText).tag);
		}
		
		public function processstChannelChatUserCmd(cmd:stChannelChatUserCmd):void
		{
			if (cmd.chatType == stChannelChatUserCmd.CHAT_VIP)
			{
				showVIP(cmd);
			}
			else
			{
				m_chatWindow.put(cmd);
			}
		}
		override public function draw():void
		{
			var a:Number;
			if (m_bMouse)
			{
				a = 0.7;
			}
			else
			{
				a = 0.3;
			}
			
			this.graphics.clear();
			this.graphics.beginFill(0x90301, a);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}	
		private function showVIP(cmd:stChannelChatUserCmd):void
		{
			if (m_vipPart == null)
			{
				m_vipPart = new VipPart(m_gkContext, m_chatWindow.linkProcess, this, 0);
				//m_vipPart.y = -m_vipPart.height;
			}
			m_vipPart.show();
			m_vipPart.processstChannelChatUserCmd(cmd);
		}
		
		public function setMouse(b:Boolean):void
		{
			m_bMouse = b;
			invalidate();
		}
		
	}

}