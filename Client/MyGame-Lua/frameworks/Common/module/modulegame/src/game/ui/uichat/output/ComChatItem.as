package game.ui.uichat.output
{
	import com.bit101.components.PanelShowAndHide;
	import com.riaidea.text.RichTextField;
	import com.util.CmdParse;
	import com.util.UtilFont;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.GkContext;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import flash.display.DisplayObjectContainer;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import game.ui.uichat.ctrol.ChatRichTextField;
	
	/**
	 * ...
	 * @author
	 */
	public class ComChatItem extends PanelShowAndHide
	{
		public static const WIDTH:int = 292;
		private var m_gkContext:GkContext;
		private var m_linkProcess:LinkProcess;
		protected var m_type:int; //见ChatLogic.TYPE_Corps等定义,此变量不会等于ChatLogic.TYPE_All
		protected var _rtf:ChatRichTextField;
		private var m_defaultFormat:TextFormat;		
		
		public function ComChatItem(gk:GkContext, linkProcess:LinkProcess, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0)
		{
			m_gkContext = gk;
			m_linkProcess = linkProcess;
			super(parent, xpos, ypos);
			_rtf = new ChatRichTextField(m_gkContext,false);
			_rtf.html = true;
			_rtf.type = RichTextField.DYNAMIC;
			_rtf.setOnLinkClickFun(onLinkClick);
			addChild(_rtf);
			_rtf.setSize(WIDTH, 50);
			m_defaultFormat = new TextFormat();			
			m_defaultFormat.letterSpacing = 1
			m_defaultFormat.leading = 4;
			m_defaultFormat.font = UtilFont.NAME_Songti;
			
			
			var filter:GlowFilter = new GlowFilter(0x101010, 1, 2, 2, 8);
			_rtf.textfield.filters = [filter];
			_rtf.textfield.mouseWheelEnabled = false;
			_rtf.textfield.selectable = false;
		}
		
		public function setData(cmd:stChannelChatUserCmd):void
		{
			_rtf.clear();			
			m_type = cmd.chatType;
			if (cmd.chatType <= stChannelChatUserCmd.CHAT_BROAD)
			{
				//m_type = ChatLogic.TYPE_System;
				processSysCmd(cmd);
			}
			else
			{
				processChatCmd(cmd);
			}
			
			var tf:TextField = _rtf.textfield;
			_rtf.setSize(WIDTH, tf.textHeight + 4);
			var h:Number;
			if (tf.numLines > 1)
			{
				h = tf.textHeight + 6;		
			}
			else
			{
				h = tf.textHeight + 2;				
			}
			this.height = h;	
			//this.scrollRect = new Rectangle(0, 0, WIDTH, _height);
		}
		
		//在显示类型是curType的情况下，此ComChatItem是否该显示
		public function isShouldShow(curType:int):Boolean
		{		
			return s_isShouldShow(curType, m_type);			
		}		
		
		/*
		 * 返回值true - 当现实按钮的类型是showBtnType时，cmdType对于的信息需要显示出来
		 */
		public static function s_isShouldShow(showBtnType:int, cmdType:int):Boolean
		{
			if (cmdType == stChannelChatUserCmd.CHAT_BROAD || cmdType == stChannelChatUserCmd.CHAT_OFFICIAL || cmdType == stChannelChatUserCmd.CHAT_GM)
			{
				return true;
			}
			switch (showBtnType)
			{
				case ChatLogic.TYPE_All: 
					return true;
					break;
				case ChatLogic.TYPE_Corps: 
				{
					if (cmdType == stChannelChatUserCmd.CHAT_CORPS)
					{
						return true;
					}
					break;
				}
				case ChatLogic.TYPE_WORLD: 
				{
					if (cmdType == stChannelChatUserCmd.CHAT_ALL)
					{
						return true;
					}
					break;
				}
				case ChatLogic.TYPE_AREA: 
				{
					if (cmdType == stChannelChatUserCmd.CHAT_AREA)
					{
						return true;
					}
					break;
				}
				case ChatLogic.TYPE_System: 
				{
					if (cmdType <= stChannelChatUserCmd.CHAT_BROAD )
					{
						return true;
					}
					break;
				}
			
			}
			return false;
		}
		
		public static function s_cmdTypeToShowBtnType(cmdType:int):int
		{
			var showBtnType:int;
			switch(cmdType)
			{
				case stChannelChatUserCmd.CHAT_CORPS: showBtnType = ChatLogic.TYPE_Corps;	break;
				case stChannelChatUserCmd.CHAT_ALL: showBtnType = ChatLogic.TYPE_WORLD;	break;
				case stChannelChatUserCmd.CHAT_AREA: showBtnType = ChatLogic.TYPE_AREA;	break;
				default: showBtnType = ChatLogic.TYPE_System;
			}
			return showBtnType;
		}
		
	
		
		private function processSysCmd(cmd:stChannelChatUserCmd):void
		{
			var color:uint = UtilColor.GREEN;
			var str:String;
			switch (cmd.chatType)
			{
				case stChannelChatUserCmd.CHAT_SYS: 
				case stChannelChatUserCmd.CHAT_TOOLTIP:
				{
					color = 0xffea00;
					str = "【系统】";
					break;
				}
				case stChannelChatUserCmd.CHAT_ACTVIETIP: 
				{
					color = 0xff4800;
					str = "【活动】";
					break;
				}
				case stChannelChatUserCmd.CHAT_CORPSTIP: 
				{
					color = 0x2dfdff;
					str = "【军团】";
					break;
				}
				case stChannelChatUserCmd.CHAT_BROAD: 
				{
					color = 0xea02ff;
					str = "【公告】";
					break;
				}
			}
			
			m_defaultFormat.color = color;			
			_rtf.defaultTextFormat = m_defaultFormat;
			
			str += cmd.data;
			str = UtilHtml.formatFont(str, color);
			_rtf.append(str);
		}
		
		protected function processChatCmd(cmd:stChannelChatUserCmd):void
		{
			var color:uint = UtilColor.GREEN;
			var str:String;
			switch (cmd.chatType)
			{
				case stChannelChatUserCmd.CHAT_CORPS:
					{
						color = 0x2dfdff;
						str = "【军团】";
						//m_type = ChatLogic.TYPE_Corps;
						break;
					}
				case stChannelChatUserCmd.CHAT_ALL:
					{
						color = 0x66ff00;
						str = "【世界】";
						//m_type = ChatLogic.TYPE_WORLD;
						break;
					}
				case stChannelChatUserCmd.CHAT_OFFICIAL:
					{
						color = 0x00c6ff;
						str = "【官方】";
						//m_type = ChatLogic.TYPE_WORLD;
						break;
					}
				case stChannelChatUserCmd.CHAT_GM:
					{
						color = 0xff00e4;
						str = "【系统】";
						cmd.name = "GM";
						//m_type = ChatLogic.TYPE_WORLD;
						break;
					}
				case stChannelChatUserCmd.CHAT_AREA:
					{
						color = UtilColor.WHITE_Yellow;
						str = "【区域】";
						//m_type = ChatLogic.TYPE_AREA;
						break;
					}
				case stChannelChatUserCmd.CHAT_VIP:
					{
						//(2,5)电影服务器管理端程序
						var i:int = cmd.data.search(/\)/);	//")"是特殊字符，需要转义
						if (i != -1)
						{
							str = cmd.data.substring(1, i);
							cmd.data = cmd.data.substr(i + 1);
							var dataArray:Array = str.split(",");
							if (dataArray.length == 2)
							{
								var platform:int = parseInt(dataArray[0]);
								var zone:int = parseInt(dataArray[1]);
								str = m_gkContext.m_context.m_platformMgr.getZoneName(platform, zone);
								cmd.name = str + " • " + cmd.name;
							}
						}
						str = "";
						
						color = UtilColor.BLUE;
					}
			}
			
			m_defaultFormat.color = color;			
			_rtf.defaultTextFormat = m_defaultFormat;
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat(str);
			_rtf.append(UtilHtml.getComposedContent());
			
			if (cmd.m_viplevel != 0 && cmd.chatType != stChannelChatUserCmd.CHAT_VIP)
			{
				var vipxml:XML=new XML("<rtf>\n <text></text>\n <sprites>\n <sprite src=\"vippanel vipid="+cmd.m_viplevel+"\" index=\"0\"/>\n </sprites>\n</rtf>")
				UtilHtml.beginCompose();
				UtilHtml.addHypertextLink("[" + cmd.name + "]", LinkProcess.LINK_speaker+" name=" + cmd.name);
				UtilHtml.addStringNoFormat("：");
				var length:int = cmd.name.length+3;
				var str1:String = UtilHtml.getComposedContent();
				var text1:String = cmd.data;
				str1 += m_gkContext.m_SWMgr.filter(text1);
				vipxml.text = str1;
				var xmladd:XML;			
				if (cmd.m_spritesData == "")
				{
					xmladd =<rtf/>;
				}
				else
				{
					xmladd = new XML(cmd.m_spritesData);
					for each(var item:XML in xmladd.sprites.sprite)
					{
						item.@index = (parseInt(item.@index)+length).toString();
						vipxml.sprites.insertChildAfter(vipxml.sprites.sprite[0], item);
					}
				}
				_rtf.setObjectList(cmd.m_objectList);
				_rtf.importXML(vipxml);	
			}
			else
			{
				UtilHtml.beginCompose();
				UtilHtml.addHypertextLink("[" + cmd.name + "]", LinkProcess.LINK_speaker+" name=" + cmd.name);
				UtilHtml.addStringNoFormat("：");
				_rtf.append(UtilHtml.getComposedContent());
				var xml:XML;			
				if (cmd.m_spritesData == "")
				{
					xml =<rtf/>;
				}
				else
				{
					xml = new XML(cmd.m_spritesData);
				}			
				var text:String = cmd.data;
				
				text = m_gkContext.m_SWMgr.filter(text);
				xml.text = text;
				
				_rtf.setObjectList(cmd.m_objectList);
				_rtf.importXML(xml);	
			}
		}
		
		private function onLinkClick(e:TextEvent):void
		{
			m_linkProcess.execute(this, e);
		}
		
		public function get type():int
		{
			return m_type;
		}
	
	}

}