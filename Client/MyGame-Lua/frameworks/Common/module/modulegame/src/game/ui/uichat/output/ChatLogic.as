package game.ui.uichat.output
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import game.ui.uichat.UIChat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChatLogic extends ComChat
	{
		public static const TYPE_All:int = 0; //全部
		public static const TYPE_WORLD:int = 1; // 世界聊天		
		public static const TYPE_AREA:int = 2; // 区域聊天
		public static const TYPE_Corps:int = 3; //军团聊天
		public static const TYPE_System:int = 4; //系统提示
		
		protected var m_curType:int; //当前显示类型，见定义TYPE_All
		private var m_dicList:Dictionary; //[ChatLogic.TYPE_WORLD, Vector.<ComChatItem>]
		
		public function ChatLogic(gk:GkContext, uichat:UIChat, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(gk, uichat, parent, xpos, ypos);
			m_curType = TYPE_All;
			
			m_dicList = new Dictionary();
			m_dicList[TYPE_WORLD] = new Vector.<ComChatItem>();
			m_dicList[TYPE_AREA] = new Vector.<ComChatItem>();
			m_dicList[TYPE_Corps] = new Vector.<ComChatItem>();
			m_dicList[TYPE_System] = new Vector.<ComChatItem>();
		}
		
		private function deleteComChatItemByShowBtnType(type:int):void
		{
			var listType:Vector.<ComChatItem> = m_dicList[type];
			var delItem:ComChatItem = listType.shift();
			
			var i:int;
			i = m_controls.indexOf(delItem);
			if (i != -1)
			{
				m_controls.splice(i, 1);
			}
			
			i = m_displayList.indexOf(delItem);
			if (i != -1)
			{
				m_displayList.splice(i, 1);
				delItem.hide();
			}
			m_controlBuffer.push(delItem);
		}
		
		public function put(cmd:stChannelChatUserCmd):void
		{
			var showBtnType:int = ComChatItem.s_cmdTypeToShowBtnType(cmd.chatType);
			var listType:Vector.<ComChatItem> = m_dicList[showBtnType];
			
			if (listType.length >= MAX_NUM_ITEM)
			{
				deleteComChatItemByShowBtnType(showBtnType);
			}
			
			var chatItem:ComChatItem = allocateComChatItem();
			chatItem.setData(cmd);
			listType.push(chatItem);
			m_controls.push(chatItem);
			
			if (chatItem.isShouldShow(m_curType))
			{
				chatItem.show();
				if (m_displayList.length >= MAX_NUM_ITEM)
				{
					var delItem:ComChatItem = m_displayList.shift();
					delItem.hide();
				}
				m_displayList.push(chatItem);
			}
			else
			{
				chatItem.hide();
			}
			
			adjustAllPos();
			m_scrollbar.value = maxScrollPos;
			scrollPos = m_scrollbar.value;
			
			// 控制进度条是否显示
			if (this.m_dataHeight > this.height)
			{
				if (!m_scrollbar.visible)
				{
					m_scrollbar.visible = true;
				}
			}
		}
		
		public function setCurType(type:int):void
		{
			if (m_curType == type)
			{
				return;
			}
			m_curType = type;
			updateDisplayList();
		}
		
		public function updateDisplayList():void
		{
			
			var i:int;
			var size:int; // = m_controls.length < MAX_NUM_ITEM?m_controls.length:MAX_NUM_ITEM;
			var chatItem:ComChatItem;
			for each (chatItem in m_displayList)
			{
				chatItem.hide();
			}
			
			m_displayList.length = 0;
			
			if (m_controls.length > 0)
			{
				var k:int = 0;
				for (i = m_controls.length - 1; i >= 0 && k<MAX_NUM_ITEM; i--)
				{
					chatItem = m_controls[i];
					if (chatItem.isShouldShow(m_curType))
					{
						chatItem.show();
						m_displayList.push(chatItem);
						k++;
					}
					else
					{
						chatItem.hide();
					}
					
				}
			}			
			
			m_displayList.reverse();
			adjustAllPos();
			m_scrollbar.value = maxScrollPos;
			scrollPos = m_scrollbar.value;
			
			// 控制进度条是否显示
			if (this.m_dataHeight > this.height)
			{
				if (!m_scrollbar.visible)
				{
					m_scrollbar.visible = true;
				}
			}
		}
	}

}