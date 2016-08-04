package game.ui.uichat.input
{
	//import adobe.utils.CustomActions;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.ButtonText;
	import com.bit101.components.PushButton;
	//import flash.events.Event;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import game.ui.uichat.input.GmProcess;
	import game.ui.uichat.UIChat;
	//import com.dgrigg.utils.UIConst;
	import com.riaidea.text.RichTextField;
	import com.pblabs.engine.resource.SWFResource;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import modulecommon.appcontrol.menu.UIMenuEx;
	//import modulecommon.net.msg.chatUserCmd.stChatUserCmd;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import modulecommon.GkContext;
	import datast.QueueVec;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	//import uichat.ctrol.ChatObject;
	import game.ui.uichat.ctrol.ChatRecord;
	import game.ui.uichat.ctrol.ChatRichTextField;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ChatInputPanel extends PanelContainer
	{
		private static const QUEUESIZE:uint = 15;
		
		private var m_curType:int;
		private var _inputPanel:PanelContainer;
		private var _rtf:ChatRichTextField;
		private var _enterBtn:PushButton;
		private var _gmProcess:GmProcess;
		private var m_gkContext:GkContext;
		private var _queue:QueueVec; //玩家每次发送一个消息，会把消息内容存在_queue中, 按方向键时，会从里面调出之前发出的消息
		private var _iCurItem:int;
		
		private var m_typeBtn:ButtonText;
		private var m_expressBtn:PushButton;
		
		private var m_preClickTime:Number = 0;
		
		public function ChatInputPanel(gk:GkContext, ui:UIChat)
		{
			m_gkContext = gk;
			_gmProcess = new GmProcess(gk, ui);
			_queue = new QueueVec(QUEUESIZE);
			this.m_gkContext.m_context.m_mainStage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			this.setSize(276, 26);
			super.addChildren();
			_inputPanel = new PanelContainer(this, 0, 0);
			//_inputPanel.setSize(200, 30);
			
			var txtFormat:TextFormat = new TextFormat("Arial", 12, 0xFFFFFF, true);
			_rtf = new ChatRichTextField(m_gkContext, true);
			_rtf.html = false;
			_rtf.defaultTextFormat = txtFormat;
			_rtf.multiline = false;
			_rtf.wordWrap = false;
			_rtf.type = RichTextField.INPUT;
			_rtf.maxChars = 60;
			_rtf.setSize(185, 25);
			_rtf.x = 62;
			_rtf.y = 4;
			_inputPanel.addChild(_rtf);
			
			_enterBtn = new PushButton(_inputPanel, 251, 6);
			_enterBtn.setSize(22, 15);
			_enterBtn.addEventListener(MouseEvent.CLICK, onEnterBtnClick);
			
			m_expressBtn = new PushButton(_inputPanel, this.width, 0, onExpressBtnClick);
			
			m_typeBtn = new ButtonText(this, 3, 3, "", onTypeBtnClick);
			m_typeBtn.setPanelImageSkin("commoncontrol/button/buttonTab7.swf");
			m_typeBtn.autoAdjustLabelPos = false;
			m_typeBtn.labelComponent.setPos(5, 1);
			var panel:Panel = new Panel(m_typeBtn, 40, 7);
			panel.setPanelImageSkin("commoncontrol/panel/arrowup.png");
			setCurType(stChannelChatUserCmd.CHAT_ALL);
		}
		
		private function onTypeBtnClick(e:MouseEvent):void
		{
			var menu:UIMenuEx = m_gkContext.m_uiMenuEx;
			menu.begin(90);
			menu.funOnclick = onSpeakerMenuClik;
			
			var enable:Boolean;
			menu.addText("VIP", stChannelChatUserCmd.CHAT_VIP);
			menu.addText("世界", stChannelChatUserCmd.CHAT_ALL);
			menu.addText("区域", stChannelChatUserCmd.CHAT_AREA);
			
			if (m_gkContext.m_corpsMgr.hasCorps)
			{
				menu.addText("军团", stChannelChatUserCmd.CHAT_CORPS);
			}
			
			menu.end();
			menu.setShowPos(m_typeBtn.x, m_typeBtn.y - menu.height - 10, this);
			menu.resetPos();
		}
		
		private function onSpeakerMenuClik(tag:int):void
		{
			if (tag == m_curType)
			{
				return;
			}
			setCurType(tag);
		}
		
		public function setCurType(type:int):void
		{
			m_curType = type;
			var name:String;
			switch (m_curType)
			{
				case stChannelChatUserCmd.CHAT_VIP: 
				{
					name = "VIP";
					break;
				}
				case stChannelChatUserCmd.CHAT_ALL: 
				{
					name = "世界";
					break;
				}
				case stChannelChatUserCmd.CHAT_CORPS: 
				{
					name = "军团";
					break;
				}
				case stChannelChatUserCmd.CHAT_AREA: 
				{
					name = "区域";
					break;
				}
			}
			
			m_typeBtn.label = name;
			var color:uint = UIChat.getColorOfChat(m_curType);
			
			m_typeBtn.normalColor = color;
			m_typeBtn.overColor = UtilColor.unitScale(color, 1.2);
			m_typeBtn.downColor = UtilColor.unitScale(color, 0.8);
			//m_typeBtn.labelComponent.setFontColor();
		}
		
		public function createImage(resource:SWFResource):void
		{
			this.setSkinGrid9ImageOneBySWF(resource, "uiChat.chatinputbg");
			_enterBtn.setPanelImageSkinBySWF(resource, "uiChat.enterbtn");
			m_expressBtn.setSkinButton1ImageBySWF(resource, "uiChat.expressbtn");
		}
		
		public function onEnterBtnClick(evt:MouseEvent):void
		{
			sendMsg();
		}
		
		public function onExpressBtnClick(evt:MouseEvent):void
		{
			var form:Form = m_gkContext.m_UIMgr.getForm(UIFormID.UIExpression);
			if (form && form.isVisible())
			{
				form.hide();
			}
			else
			{
				form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIExpression);
				form.show();
			}
		}
		
		public function exhibitZObject(obj:ZObject):void
		{
			if (_rtf.contentLength > 90)
			{
				return;
			}
			if (_rtf.getObjectSize() >= 3)
			{
				m_gkContext.m_systemPrompt.prompt("每次最多展示3个道具");
				return;
			}
			_rtf.exhibitZObject(obj);
			focusToInput();
		}
		
		public function addExpression(id:int):void
		{
			if (_rtf.contentLength > 90)
			{
				return;
			}
			_rtf.addExpression(id);
			focusToInput();
		}
		
		private function onVIPSend():Boolean
		{
			sendMsgEx();
			return true;
		}
		
		protected function sendMsg():void
		{
			var xml:XML = _rtf.exportXML();
			var content:String = xml.text;
			var spritesXml:XML = xml.sprites[0];
			var spritesList:XMLList = spritesXml.sprite;
			if (content.length == 0 && spritesList.length() == 0)
			{
				return;
			}
			
			if (content == "//bazhonggm")
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIGmPlayerAttributes);
				return;
			}
			if (content == "//stopinfo")
			{
				m_gkContext.m_battleMgr.m_stopInfo = true;
				return;
			}
			
			if (m_gkContext.playerMain.isGM == false)
			{
				if (m_gkContext.versonForOut && m_curType == stChannelChatUserCmd.CHAT_ALL)
				{
					if (m_gkContext.playerMain.level < 5)
					{
						var pt:Point = this.localToScreen();
						pt.x += 240;
						pt.y -= 100;
						m_gkContext.m_systemPrompt.prompt("5级后才可进行世界喊话！", pt);
						return;
					}
				}
			}
			
			if (m_curType == stChannelChatUserCmd.CHAT_VIP)
			{
				var str:String = "VIP发言需要50元宝, 确认发言吗?";
				m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UIChat, str, onVIPSend, null);
				return;
			}
			sendMsgEx();
		}
		
		public function execGMCmd(param:String):void
		{
			_gmProcess.execute(param);
		}
		
		protected function sendMsgEx():void
		{
			
			var xml:XML = _rtf.exportXML();
			var content:String = xml.text;
			var spritesXml:XML = xml.sprites[0];
			var spritesList:XMLList = spritesXml.sprite;
			
			if (_queue.isFull)
			{
				_queue.pop();
			}
			
			var chatRecord:ChatRecord = _rtf.getRecord();
			
			_queue.push(chatRecord);
			_iCurItem = -1;
			_rtf.clear();
			
			if (m_gkContext.versonForOut == false)
			{
				if (true == _gmProcess.execute(content))
				{
					return;
				}
			}
			
			var uT:Number = 5000 - (m_gkContext.m_context.m_processManager.platformTime - m_preClickTime);
			if (m_preClickTime > 0 && uT > 0 && m_gkContext.versonForOut)
			{
				var pos:Point = this.localToScreen();
				pos.x += 300;
				pos.y -= 100;
				m_gkContext.m_systemPrompt.prompt("每次发言间隔限制为5秒，不能连续发言。", pos); //"请在 " + Math.ceil(uT) + "秒 后再进行整理包裹"
				return;
			}
			else
			{
				//发送消息
				var xmlCopy:XML = xml.copy();
				xmlCopy.text = null;
				var send:stChannelChatUserCmd = new stChannelChatUserCmd();
				send.chatType = m_curType;
				send.name = m_gkContext.playerMain.name;
				send.data = content;
				send.m_spritesData = xmlCopy.toString();
				send.m_objectList = chatRecord.getObjectList();
				this.m_gkContext.sendMsg(send);
				
				m_preClickTime = m_gkContext.m_context.m_processManager.platformTime;
			}
			focusToInput();
			//this.m_gkContext.m_context.m_mainStage.focus = null;
		}
		
		protected function handleKeyDown(evt:KeyboardEvent):void
		{
			if (evt.target == _rtf.textfield)
			{
				if (evt.keyCode == Keyboard.ENTER)
				{
					sendMsg();
					//this.m_gkContext.m_context.m_mainStage.focus = null;
				}
				else if (evt.keyCode == Keyboard.UP || evt.keyCode == Keyboard.DOWN)
				{
					var content:ChatRecord;
					var size:int = _queue.size;
					if (evt.keyCode == Keyboard.UP)
					{
						if (_iCurItem >= size - 1)
						{
							return;
						}
						_iCurItem++;
						content = getQueueContent(_iCurItem);
					}
					else
					{
						if (_iCurItem <= 0)
						{
							return;
						}
						_iCurItem--;
						content = getQueueContent(_iCurItem);
					}
					
					_rtf.setRecord(content);
					_rtf.caretIndex = _rtf.textLength;
				}
				
			}
			else
			{
				if (!(evt.target is TextField) && evt.keyCode == Keyboard.ENTER)
				{
					focusToInput();
				}
			}
		
		}
		
		public function focusToInput():void
		{
			this.m_gkContext.m_context.m_mainStage.focus = _rtf.textfield;
			_rtf.caretIndex = 1000;
		}
		
		private function getQueueContent(index:int):ChatRecord
		{
			var size:int = _queue.size;
			return _queue.getData(size - 1 - index) as ChatRecord;
		}
	
	}

}