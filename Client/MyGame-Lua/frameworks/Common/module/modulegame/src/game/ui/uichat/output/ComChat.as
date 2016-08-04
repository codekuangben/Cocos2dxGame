package game.ui.uichat.output
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.VScrollBar;
	import datast.QueueVec;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import modulecommon.GkContext;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import game.ui.uichat.UIChat;
	
	/**
	 * ...
	 * @author
	 */
	public class ComChat extends PanelContainer
	{
		public static const MAX_NUM_ITEM:int = 40;
		private var m_topMargin:Number = 0;
		private var m_bottomMargin:Number = 0;
		private var m_intervalV:Number = 0;
		private var m_leftMargin:Number = 20;
		
		private var m_gkContext:GkContext;
		private var m_linkProcess:LinkProcess;
		private var m_uiChat:UIChat;
		private var m_container:Panel;
		protected var m_controlBuffer:Vector.<ComChatItem>;
		
		protected var m_controls:Vector.<ComChatItem>;
		protected var m_displayList:Vector.<ComChatItem>;
		
		protected var m_dataHeight:int;
		protected var m_scrollPos:int;
		protected var m_scrollbar:VScrollBar;
		
		public function ComChat(gk:GkContext, uichat:UIChat, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			m_gkContext = gk;
			m_uiChat = uichat;
			super(parent, xpos, ypos);
			m_container = new Panel(this);
			m_linkProcess = new LinkProcess(m_gkContext, m_uiChat);
			
			m_controls = new Vector.<ComChatItem>;
			m_controlBuffer = new Vector.<ComChatItem>;
			m_displayList = new Vector.<ComChatItem>;
			
			m_scrollbar = new VScrollBar(this, 0, 0, onScroll);
			m_scrollbar.visible = false;
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			super.dispose();
		}
		
		protected function allocateComChatItem():ComChatItem
		{
			var popItem:ComChatItem;
			
			if (m_controlBuffer.length)
			{
				popItem = m_controlBuffer.pop();
			}
			else
			{
				popItem = new ComChatItem(m_gkContext, m_linkProcess, m_container);
				popItem.x = m_leftMargin;
			}
			
			return popItem;
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			m_scrollbar.height = h;
			m_scrollbar.pageSize = h;
			m_scrollbar.lineSize = 10;
			var rect:Rectangle = new Rectangle(0, 0, w, h);
			this.scrollRect = rect;
			m_scrollbar._hideSlider = true;
			m_scrollbar.numTotalData = 0;
		}
		
		protected function adjustAllPos():void
		{
			var i:int = 0;
			var count:int = m_displayList.length;
			var top:Number = m_topMargin;
			if (m_displayList.length > 0)
			{
				m_displayList[0].y = top;
				top += m_displayList[0].height;
			}
			for (i = 1; i < count; i++)
			{
				top += m_intervalV;
				m_displayList[i].y = top;
				top += m_displayList[i].height;
			}
			
			this.m_dataHeight = top + m_bottomMargin;
			m_scrollbar.numTotalData = m_dataHeight;
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			m_scrollbar.value -= event.delta * 20;
			scrollPos = m_scrollbar.value;
		}
		
		protected function onScroll(event:Event):void
		{
			scrollPos = m_scrollbar.value;
		}
		
		protected function set scrollPos(pos:Number):void
		{
			m_container.y = -pos;
		}
		
		public function get maxScrollPos():Number
		{
			if (this.m_dataHeight > this.height)
			{
				return this.m_dataHeight - this.height;
			}
			else
			{
				return 0;
			}
		}
		
		public function get linkProcess():LinkProcess
		{
			return m_linkProcess;
		}
	}

}