package game.process
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.util.DebugBox;
	import common.net.msg.basemsg.stNullUserCmd;
	import modulecommon.commonfuntion.LocalDataMgr;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import modulecommon.net.msg.chatUserCmd.stChatUserCmd;
	import modulecommon.net.msg.chatUserCmd.stNpcAiChatUserCmd;
	import modulecommon.net.msg.chatUserCmd.stWORDPromptUserCmd;
	import modulecommon.scene.beings.NpcVisit;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	//import modulecommon.uiinterface.IUIChat;
	import modulecommon.uiinterface.IUIPropmtOne;
	import modulecommon.uiinterface.IUIUprightPrompt;
	import modulecommon.scene.infotip.InfoTip;
	import modulecommon.net.msg.chatUserCmd.stUserChatBaseInfoCmd;
	
	import modulecommon.net.msg.chatUserCmd.stRetChatUserInfoCmd;
	
	public class ChatProcess
	{
		private var m_gkcontext:GkContext;
		private var m_dicFun:Dictionary;
		
		public function ChatProcess(gk:GkContext)
		{
			m_gkcontext = gk;
			m_dicFun = new Dictionary();
			m_dicFun[stChatUserCmd.CHANNEL_CHAT_USERCMD_PARAMETER] = processChannelChat;
			m_dicFun[stChatUserCmd.WORDPROMPT_USERCMD_PARAMETER] = processWORDPrompt;
			m_dicFun[stChatUserCmd.NPC_AI_CHAT_USERCMD] = processNpcAiChatUserCmd;
			m_dicFun[stChatUserCmd.PARA_USER_CHAT_BASEINFO_USERCMD] = psstUserChatBaseInfoCmd;
			m_dicFun[stChatUserCmd.PARA_RET_CHAT_USERINFO_USERCMD] = psstRetChatUserInfoCmd;
		}
		
		public function process(msg:ByteArray, param:uint):void
		{
			if (m_dicFun[param] != undefined)
			{
				m_dicFun[param](msg);
			}
		}
		
		public function processChannelChat(msg:ByteArray):void
		{
			//return;
			var cmd:stChannelChatUserCmd = new stChannelChatUserCmd();
			cmd.deserialize(msg);
			
			if ((cmd.m_bBuf || cmd.chatType == stChannelChatUserCmd.CHAT_SYS || cmd.chatType == stChannelChatUserCmd.CHAT_TOOLTIP || cmd.chatType == stChannelChatUserCmd.CHAT_SCREENBLOW)&&m_gkcontext.m_localMgr.isSet(LocalDataMgr.LOCAL_WillIntoBattle))
			{
				msg.position = 0;
				m_gkcontext.m_battleMgr.addMsgForBuffer(msg, stNullUserCmd.CHAT_USERCMD, stChatUserCmd.CHANNEL_CHAT_USERCMD_PARAMETER);
				return;
			}
			
			// 处理消息
			var form:Form;
			if(cmd.chatType == stChannelChatUserCmd.CHAT_PRIVATE)		// 如果是私聊
			{
				//if(m_gkcontext.m_UIs.chatSystem)
				if(m_gkcontext.m_UIs.chatSystem && m_gkcontext.m_UIs.chatSystem.isUIReady())
				{
					m_gkcontext.m_UIs.chatSystem.psnChat.openIFPChat(cmd);
				}
				else
				{
					//m_gkcontext.m_UIMgr.loadForm(UIFormID.UIChatSystem);
					m_gkcontext.m_beingProp.m_chatSystem.m_pChat.openAndAddPChatByCmd(cmd);
					m_gkcontext.m_commonProc.addInfoTip(InfoTip.ENPrivChat, m_gkcontext.m_beingProp.m_chatSystem.m_pChat.getPsChatCnt());
				}
			}
			else if (cmd.chatType == stChannelChatUserCmd.CHAT_SCREEN)
			{
				m_gkcontext.m_systemPrompt.announce(cmd.data);
			}
			else if (cmd.chatType == stChannelChatUserCmd.CHAT_MOUSETIP)
			{
				m_gkcontext.m_systemPrompt.promptOnTopOfMousePos(cmd.data);
			}
			else if (cmd.chatType == stChannelChatUserCmd.CHAT_SCREENBLOW)
			{
				m_gkcontext.m_systemPromptBottom.addMsg(cmd.data);
			}
			else if (cmd.chatType == stChannelChatUserCmd.CHAT_YELLOWTIP)
			{
				m_gkcontext.m_systemPromptMulti.addMsg(cmd.data);				
			}
			else if (cmd.chatType == stChannelChatUserCmd.CHAT_DIALOG)
			{
				m_gkcontext.m_confirmDlgMgr.showMode2(0, cmd.data, null);	
			}
			else
			{
				if (m_gkcontext.m_uiChat)
				{
					m_gkcontext.m_uiChat.processChatCmd(cmd);
				}				
			}
		}
		public function processNpcAiChatUserCmd(msg:ByteArray):void
		{
			var rev:stNpcAiChatUserCmd = new stNpcAiChatUserCmd();
			rev.deserialize(msg);
			var npc:NpcVisit = m_gkcontext.m_npcManager.getBeingByTmpID(rev.tempid) as NpcVisit;
			if (npc)
			{
				npc.setBubble(rev.text);
			}
		}
		public function processWORDPrompt(msg:ByteArray):void
		{
			var rev:stWORDPromptUserCmd = new stWORDPromptUserCmd();
			rev.deserialize(msg);
			var obj:Object;
			
			if (rev.m_type == 0)
			{
				var iui:IUIPropmtOne = m_gkcontext.m_UIMgr.getForm(UIFormID.UIPropmtOne) as IUIPropmtOne;
				if (iui)
				{
					iui.showPrompt(rev.m_content, rev.m_lastTime);
				}
				else
				{
					obj = new Object();
					obj["content"] = rev.m_content;
					obj["delay"] = rev.m_lastTime;
					
					m_gkcontext.m_contentBuffer.addContent("UIPropmtOne_prompt", obj);
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UIPropmtOne);
				}
			}
			else if (rev.m_type == 1)
			{
				var iuUP:IUIUprightPrompt = m_gkcontext.m_UIMgr.getForm(UIFormID.UIUprightPrompt) as IUIUprightPrompt;
				if (iuUP)
				{
					iuUP.showPrompt(rev.m_content);
				}
				else
				{
					obj = new Object();
					obj["content"] = rev.m_content;
					
					m_gkcontext.m_contentBuffer.addContent("UIUprightPrompt_prompt", obj);
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UIUprightPrompt);
				}
			}
		}
	
		// 在私聊的时候，这条消息在 stChannelChatUserCmd 之前发送过来，表示发送者具体信息
		public function psstUserChatBaseInfoCmd(msg:ByteArray):void
		{
			var cmd:stUserChatBaseInfoCmd = new stUserChatBaseInfoCmd();
			cmd.deserialize(msg);
			
			try
			{
			// 检查对应这个名字的私聊聊天室是否存在,如果存在就不处理了,如果不存在就显示信息提示
			// m_gkcontext.m_UIs.chatSystem.psnChat 这个是聊天资源加载完成后才初始化的,如果消息在资源加载完成前就发送过来了,就会有问题
			//if(m_gkcontext.m_UIs.chatSystem == null || !m_gkcontext.m_UIs.chatSystem.psnChat.existPChat(cmd.name))
			if ((m_gkcontext.m_UIs.chatSystem == null || !m_gkcontext.m_UIs.chatSystem.isUIReady()) ||
			    !m_gkcontext.m_UIs.chatSystem.psnChat.existPChat(cmd.name))	// 如果代码没有加载或者资源没有加载,或者代码资源都加载完成,但是聊天室没有当前的聊天人员
			{
				m_gkcontext.m_beingProp.m_chatSystem.m_pChat.openAndAddPChatByBaseInfo(cmd);
				m_gkcontext.m_commonProc.addInfoTip(InfoTip.ENPrivChat, m_gkcontext.m_beingProp.m_chatSystem.m_pChat.getPsChatCnt());
			}
			else	// 代码加载并且资源加载并且聊天室有当前聊天人员
			{
				m_gkcontext.m_UIs.chatSystem.psnChat.updateBaseInfo(cmd);
			}
			}
			catch (e:Error)
			{
				var str:String = "psstUserChatBaseInfoCmd ";
				if (m_gkcontext.m_UIs.chatSystem)
				{
					str += "m_gkcontext.m_UIs.chatSystem ";
					if (m_gkcontext.m_UIs.chatSystem.psnChat)
					{
						str += "m_gkcontext.m_UIs.chatSystem.psnChat";
					}
				}
				DebugBox.sendToDataBase(str);
			}
		}
		
		// 私聊返回的饲料对象的基本信息
		public function psstRetChatUserInfoCmd(msg:ByteArray):void
		{
			var cmd:stRetChatUserInfoCmd = new stRetChatUserInfoCmd();
			cmd.deserialize(msg);
			
			m_gkcontext.m_commonProc.pChatTo(cmd.getBaseInfo());
		}
	}
}