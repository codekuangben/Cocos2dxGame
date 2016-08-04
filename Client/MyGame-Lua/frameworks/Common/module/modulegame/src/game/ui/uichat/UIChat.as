package game.ui.uichat
{
	import com.bit101.components.Component;
	import com.pblabs.engine.debug.Logger;
	import flash.events.MouseEvent;
	import game.ui.uichat.input.ChatInputPanel;
	//import com.util.UtilXML;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	//import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIChat;
	
	//import flash.display.Bitmap;
	//import flash.display.Shape;
	//import flash.display.Sprite;
	import flash.events.Event;
	//import flash.events.KeyboardEvent;
	//import flash.events.MouseEvent;
	//import flash.events.TimerEvent;
	//import flash.text.TextField;
	//import flash.text.TextFormat;
	//import flash.ui.Keyboard;
	//import flash.utils.getDefinitionByName;
	//import flash.utils.getQualifiedClassName;
	//import modulecommon.net.msg.chatUserCmd.stChatUserCmd;
	//import flash.utils.ByteArray;
	import game.ui.uichat.ChatOutputPanel;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import com.dgrigg.image.CommonImageManager;
	/**
	 * ...
	 * @author 
	 */
	public class UIChat extends Form implements IUIChat
	{			
		private var _output:ChatOutputPanel;
		private var _input:ChatInputPanel;
		
		public function UIChat():void 
		{
			
		}
		public static function IMAGESWF():String
		{
			return CommonImageManager.toPathString("module/imageuichat.swf");
		}
		override public function onReady():void
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			
			this.m_gkcontext.m_uiChat = this;
			initChat();
			this.setSize(200, _input.y + _input.height);
			this.marginBottom = 1;
			this.marginLeft = 3;
			this.alignHorizontal = Component.LEFT;
			this.alignVertial = Component.BOTTOM;
			this.adjustPosWithAlign();	
			
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				
			m_gkcontext.m_context.m_resMgr.load(IMAGESWF(), SWFResource, onImageSwfLoaded, onImageSwfFailed);
			
		}
		private function initChat(e:Event = null):void 
		{
			_output = new ChatOutputPanel(m_gkcontext,this);
			addChild(_output);			
			_input = new ChatInputPanel(m_gkcontext, this);
			addChild(_input);
			_input.y = _output.height;
		}
		
		public function exhibitZObject(obj:ZObject):void
		{
			_input.exhibitZObject(obj);
		}
		public function addExpression(id:int):void
		{
			_input.addExpression(id);
		}
		public function appendMsg(str:String):void
		{
			_output.addMessage(str);
		}
		public function debugMsg(str:String):void
		{
			if (m_gkcontext.versonForOut == false )
			{
				appendMsg(str);
			}
			Logger.debug(null, "", str);
		}
		public function processChatCmd(cmd:stChannelChatUserCmd):void
		{				
			_output.processstChannelChatUserCmd(cmd);
			if (cmd.chatType == stChannelChatUserCmd.CHAT_TOOLTIP)
			{
				m_gkcontext.m_systemPromptMulti.addMsg(cmd.data);
			}
			
		}
		
		private function onImageSwfLoaded(event:ResourceEvent):void
		{			
			var resource:SWFResource = event.resourceObject as SWFResource;
			_input.createImage(resource);
			m_gkcontext.m_context.m_resMgr.unload(IMAGESWF(), SWFResource);
		}		
		public function updateOnCorps():void
		{
			_output.updateTableBtn();
		}
		
		public function moveToLayer(layerID:uint):void
		{
			m_gkcontext.m_UIMgr.switchFormToLayer(this, layerID);
		}
		
		public function moveBackFirstLayer():void
		{
			m_gkcontext.m_UIMgr.switchFormToLayer(this, UIFormID.FirstLayer); 
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			_output.setMouse(true);
		}
		
		protected function onMouseLeave(event:MouseEvent):void
		{
			_output.setMouse(false);
		}
		
		public function execGMCmd(param:String):void
		{
			_input.execGMCmd(param);
		}
		
		public static function getColorOfChat(chatType:int):uint
		{
			var color:uint = 0xffffff;
			switch (chatType)
			{
				case stChannelChatUserCmd.CHAT_CORPS:
					{
						color = 0x2dfdff;	
						break;
					}
				case stChannelChatUserCmd.CHAT_ALL:
					{
						color = 0x66ff00;
						break;
					}
				case stChannelChatUserCmd.CHAT_AREA:
					{
						color = UtilColor.WHITE_Yellow;
						break;
					}
				case stChannelChatUserCmd.CHAT_BROAD:
					{
						color = 0xea02ff;
						break;
					}
				case stChannelChatUserCmd.CHAT_SYS: 
				case stChannelChatUserCmd.CHAT_TOOLTIP:
				{
					color = 0xffea00;
					break;
				}
				case stChannelChatUserCmd.CHAT_ACTVIETIP: 
				{
					color = 0xff4800;
					break;
				}
				case stChannelChatUserCmd.CHAT_CORPSTIP: 
				{
					color = 0x2dfdff;
					break;
				}
				case stChannelChatUserCmd.CHAT_VIP: 
				{
					color = UtilColor.GREEN;
					break;
				}
			}
			
			return color;
		}
	}
}