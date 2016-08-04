package game.ui.uichat.output 
{
	import com.util.CmdParse;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.Dictionary;
	import modulecommon.appcontrol.menu.UIMenuEx;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import modulecommon.net.msg.corpscmd.reqJoinCorpsUserCmd;
	import modulecommon.net.msg.fndcmd.stViewFriendDataFriendCmd;
	import game.ui.uichat.UIChat;
	import modulecommon.net.msg.teamUserCmd.reqAddMultiCopyUserCmd;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.commonfuntion.SysNewFeatures;

	/**
	 * ...
	 * @author ...
	 */
	public class LinkProcess 
	{
		public static const LINK_speaker:String = "speaker";	//speaker name=张飞
		public static const LINK_JoinCorps:String = "JoinCorps";	//JoinCorps corpsid=45
		public static const LINK_JoinMultiCopy:String = "JoinMultiCopy";	//JoinMultiCopy copytempid=1001
		public static const LINK_JoinTeamBoss:String = "JoinTeamBoss";	//JoinTeamBoss copytempid=9998，这个是组队闯关
		public static const LINK_Chongzhi:String = "Chongzhi";	//{ "Chongzhi", "none"}; 打开充值网页
		public static const LINK_OpenHuntFunc:String = "OpenHuntFunc";	//{ "OpenHuntFunc", "none"}; 打开寻宝界面
		
		private var m_gkContext:GkContext;		
		private var m_uiChat:UIChat;
		private var m_dicFun:Dictionary;
		public function LinkProcess(gk:GkContext, uiChat:UIChat) 
		{
			m_dicFun = new Dictionary();
			m_gkContext = gk;
			m_uiChat = uiChat;
			m_dicFun[LINK_speaker] = clickSpeaker;
			m_dicFun[LINK_JoinCorps] = JoinCorps;
			m_dicFun[LINK_JoinMultiCopy] = JoinMultiCopy;
			m_dicFun[LINK_JoinTeamBoss] = JoinTeamBoss;
			m_dicFun[LINK_Chongzhi] = Chongzhi;
			m_dicFun[LINK_OpenHuntFunc] = OpenHuntFunc;
		}
		
		public function execute(chatItem:ComChatItem, e:TextEvent):void
		{
			var parseCmd:CmdParse = new CmdParse();
			parseCmd.parse(e.text);
			
			if (m_dicFun[parseCmd.cmd] != undefined)
			{
				m_dicFun[parseCmd.cmd](parseCmd, chatItem, e);
				return;
			}
		}
		
		//单击发言者的名字
		private function clickSpeaker(parseCmd:CmdParse, chatItem:ComChatItem, e:TextEvent):void
		{
			var name:String = parseCmd.getValue("name");
			
			if (name == m_gkContext.playerMain.name || name == "GM"||chatItem.type==stChannelChatUserCmd.CHAT_VIP)
			{
				return;
			}
			var ptMousePos:Point = new Point(m_gkContext.m_context.m_mainStage.mouseX, m_gkContext.m_context.m_mainStage.mouseY);
			ptMousePos = m_gkContext.m_context.golbalToScreen(ptMousePos);
			
			var menu:UIMenuEx = m_gkContext.m_uiMenuEx;
			menu.begin();
			menu.funOnclick = onSpeakerMenuClik;
			
			var enable:Boolean;			
			menu.addIconAndText("watch", "查看信息", 1);
			menu.addIconAndText("talk", "私聊", 2);
			if (m_gkContext.m_beingProp.m_rela.m_relFnd.isFriend(name))
			{
				enable = false;
			}
			else
			{
				enable = true;
			}
			menu.addIconAndText("addfriend", "加好友", 3, enable);
			menu.addIconAndText("copy", "复制名称", 4);
						
			menu.end();
			menu.setShowPos(m_uiChat.mouseX, m_uiChat.mouseY - menu.height - 15, m_uiChat);
			menu.resetPos();
			menu.m_tempData = name;
		}
		
		private function onSpeakerMenuClik(tag:int):void
		{
			var name:String = m_gkContext.m_uiMenuEx.m_tempData as String;
			switch(tag)
			{
				case 1: //查看信息
					{
						var viewCmd:stViewFriendDataFriendCmd = new stViewFriendDataFriendCmd();
						viewCmd.friendName = name;
						viewCmd.type = stViewFriendDataFriendCmd.VIEWTYPE_CORPS;
						m_gkContext.sendMsg(viewCmd);
						break;
					}
				case 2: //私聊
					{
						m_gkContext.m_commonProc.pChatToByCharid(name);
						break;
					}
				case 3: //添加好友
					{
						m_gkContext.m_commonProc.addFndByNameEx(name);
						break;
					}
				case 4://复制名称
					{
						System.setClipboard(name);
						break;
					}				
					
			}
		}		

		//JoinCorps corpsid=45
		private function JoinCorps(parseCmd:CmdParse, chatItem:ComChatItem, e:TextEvent):void
		{
			var id:uint = parseCmd.getUintValue("corpsid");
			var cmd:reqJoinCorpsUserCmd = new reqJoinCorpsUserCmd();
			cmd.corpsid = id;
			m_gkContext.sendMsg(cmd);
		}

		// 组队邀请
		private function JoinMultiCopy(parseCmd:CmdParse, chatItem:ComChatItem, e:TextEvent):void
		{
			if (m_gkContext.m_mapInfo.m_isInFuben)
			{
				m_gkContext.m_mapInfo.promptInFubenDesc();
				return;
			}
			
			if (!m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_TEAMCOPY))
			{
				m_gkContext.m_systemPrompt.promptOnTopOfMousePos("组队副本 功能还未开启");
				return;
			}
			
			if (m_gkContext.m_mapInfo.m_bInArean)
			{
				m_gkContext.m_systemPrompt.promptOnTopOfMousePos("请先退出竞技场");
				return;
			}
			
			var copyid:uint = int(parseCmd.getValue("copytempid"));
			var cmd:reqAddMultiCopyUserCmd = new reqAddMultiCopyUserCmd();
			cmd.copytempid = copyid;
			cmd.type = 1;
			m_gkContext.sendMsg(cmd);
		}
		
		private function JoinTeamBoss(parseCmd:CmdParse, chatItem:ComChatItem, e:TextEvent):void
		{
			JoinMultiCopy(parseCmd, chatItem, e);
		}
		
		//打开充值网页
		private function Chongzhi(parseCmd:CmdParse, chatItem:ComChatItem, e:TextEvent):void
		{
			m_gkContext.m_context.m_platformMgr.openRechargeWeb();
		}
		
		private function OpenHuntFunc(parseCmd:CmdParse, chatItem:ComChatItem, e:TextEvent):void
		{
			if (m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_TREASUREHUNTING))
			{
				var form:Form=m_gkContext.m_UIMgr.createFormInGame(UIFormID.UITreasureHunt);
				form.show();
			}
			else
			{
				m_gkContext.m_systemPrompt.prompt("寻宝功能尚未开启");
			}
		}
	}
}