package modulecommon.scene 
{
	import com.pblabs.engine.entity.EntityCValue;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.GkContext;
	import modulecommon.net.msg.chatUserCmd.stReqChatUserInfoCmd;
	import modulecommon.net.msg.chatUserCmd.stUserChatBaseInfoCmd;
	import modulecommon.net.msg.corpscmd.reqInviteUserJoinCorpsUserCmd;
	import modulecommon.net.msg.fndcmd.stDeleteFriendFriendCmd;
	import modulecommon.net.msg.fndcmd.stMoveFriendToBlackListFriendCmd;
	import modulecommon.net.msg.fndcmd.stReqAddFriendByCharIDFriendCmd;
	import modulecommon.net.msg.fndcmd.stReqAddFriendByNameFriendCmd;
	import modulecommon.net.msg.fndcmd.stViewFriendDataFriendCmd;
	import modulecommon.scene.infotip.InfoTip;
	import modulecommon.scene.infotip.ItemDataFndFly;
	import modulecommon.scene.prop.relation.RelFriend;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TMusicItem;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIFndFlyAni;
	import modulecommon.uiinterface.IUIInfoTip;
	import com.pblabs.engine.debug.Logger;

	/**
	 * ...
	 * @author 
	 * 在这里，可以添加一些与具体功能无关的处理
	 */
	public class CommonProcess 
	{
		public var m_gkContext:GkContext;
		
		public function CommonProcess(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		
		// bshoweff : 是否显示特效
		public function addInfoTip(type:uint, num:uint, bshoweff:Boolean = true):void
		{
			var list:Vector.<InfoTip>;
			var item:InfoTip;
			item = new InfoTip();
			item.m_type = type;
			item.m_num = num;
			item.m_bshowEff = bshoweff;
				
			var uiinfotip:IUIInfoTip = m_gkContext.m_UIMgr.getForm(UIFormID.UIInfoTip) as IUIInfoTip;
			if(!uiinfotip || !uiinfotip.isVisible())	// 如果不可见
			{
				list = m_gkContext.m_contentBuffer.getContent("uiInfoTip", false) as Vector.<InfoTip>;
				if(!list)
				{
					list = new Vector.<InfoTip>();
					m_gkContext.m_contentBuffer.addContent("uiInfoTip", list);
				}
				
				list.push(item);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIInfoTip);
			}
			else	// 可见
			{
				uiinfotip.addBtn(item);
			}
		}
		
		// 添加好友飞行动画
		public function addFndFlyAni(xpos:uint, ypos:uint):void
		{
			var list:Vector.<ItemDataFndFly>;
			var item:ItemDataFndFly;
			item = new ItemDataFndFly();
			item.m_xspos = xpos;
			item.m_yspos = ypos;
			
			var uifndflyani:IUIFndFlyAni = m_gkContext.m_UIMgr.getForm(UIFormID.UIFndFlyAni) as IUIFndFlyAni;
			if(!uifndflyani || !uifndflyani.isVisible())	// 如果不可见
			{
				list = m_gkContext.m_contentBuffer.getContent("uifndflyani", false) as Vector.<ItemDataFndFly>;
				if(!list)
				{
					list = new Vector.<ItemDataFndFly>();
					m_gkContext.m_contentBuffer.addContent("uifndflyani", list);
				}
				
				list.push(item);
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIFndFlyAni);
			}
			else	// 可见
			{				
				uifndflyani.addFnd(item);
			}
		}
		
		// 播放音效接口  mscid : 就是 音效配置表.xlsx 表中的 id
		public function playMsc(mscid:uint, loopCount:int=1):void
		{
			// 只有音效开的情况下才播放
			if(!m_gkContext.m_sysOptions.isSet(SysOptions.COMMONSET_CLIENT_LDSSound))
			{
				var item:TMusicItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_MUSIC, mscid) as TMusicItem;
				if(item)
				{
					this.m_gkContext.m_context.m_soundMgr.play(item.m_name + ".mp3", EntityCValue.FXDft, 0.0, loopCount);
					Logger.info(null, null, "播放音效" + item.m_name + ".mp3");
				}
			}
		}
		
		// 停止播放某一种音乐
		public function stopMsc(mscid:uint):void
		{
			var item:TMusicItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_MUSIC, mscid) as TMusicItem;
			if(item)
			{
				this.m_gkContext.m_context.m_soundMgr.stop(item.m_name);
			}
		}
		
		// 和某人私聊,如果客户端没有基本信息
		public function pChatToByCharid(name:String):void
		{
			var cmd:stReqChatUserInfoCmd = new stReqChatUserInfoCmd();
			cmd.name = name;
			m_gkContext.sendMsg(cmd);
		}

		// 和某人私聊,如果客户端有自己的信息
		public function pChatTo(baseinfo:stUserChatBaseInfoCmd):void
		{
			//if(m_gkContext.m_UIs.chatSystem && m_gkContext.m_UIs.chatSystem)
			if(m_gkContext.m_UIs.chatSystem)
			{
				m_gkContext.m_UIs.chatSystem.psnChat.openAndAddPChatByBaseInfo(baseinfo);
			}
			else
			{
				m_gkContext.m_UIMgr.loadForm(UIFormID.UIChatSystem);
				m_gkContext.m_beingProp.m_chatSystem.m_pChat.openAndAddOpeningPChatByCmd(baseinfo);
			}
		}
		
		// 将好友拉黑
		//public function fnd2Black(charid:uint):void
		//{
		//	var cmdblack:stMoveFriendToBlackListFriendCmd = new stMoveFriendToBlackListFriendCmd();
		//	cmdblack.charid = charid;
		//	m_gkContext.sendMsg(cmdblack);
		//}
		
		// 删除好友或者黑名单
		public function delFndOrBlack(charid:uint, type:uint):void
		{
			var cmddel:stDeleteFriendFriendCmd = new stDeleteFriendFriendCmd();
			cmddel.charid = charid;
			if(type == RelFriend.eFndLst)
			{
				cmddel.type = 0;
			}
			else if(type == RelFriend.eBlackLst)
			{
				cmddel.type = 1;
			}
			m_gkContext.sendMsg(cmddel);
		}
		
		// 察看好友或者黑名单资料
		public function watchFnd(name:String, type:uint):void
		{
			var viewCmd:stViewFriendDataFriendCmd = new stViewFriendDataFriendCmd();
			viewCmd.friendName = name;
			if(type == RelFriend.eFndLst)
			{
				viewCmd.type = stViewFriendDataFriendCmd.VIEWTYPE_FRIEND;
			}
			else if(type == RelFriend.eBlackLst)
			{
				viewCmd.type = stViewFriendDataFriendCmd.VIEWTYPE_BLACKLIST;
			}
			m_gkContext.sendMsg(viewCmd);
		}
		
		// 邀请加入军团
		public function inviteJoinCorps(charid:uint):void
		{
			var cmd:reqInviteUserJoinCorpsUserCmd = new reqInviteUserJoinCorpsUserCmd();
			cmd.dwUserID = charid;
			m_gkContext.sendMsg(cmd);
		}
		
		// 通过 charid 添加好友
		public function addFndByCharid(charid:uint):void
		{
			var cmd:stReqAddFriendByCharIDFriendCmd = new stReqAddFriendByCharIDFriendCmd();
			cmd.charid = charid;
			m_gkContext.sendMsg(cmd);
		}
		
		// 通过名字添加好友
		public function addFndByName(lst:Vector.<String>):void
		{
			var cmd:stReqAddFriendByNameFriendCmd = new stReqAddFriendByNameFriendCmd();
			cmd.num = lst.length;
			cmd.name = lst;
			m_gkContext.sendMsg(cmd);
		}
		
		// 通过名字添加好友
		public function addFndByNameEx(name:String):void
		{
			var lst:Vector.<String> = new Vector.<String>();
			lst.push(name);
			addFndByName(lst);			
		}
		
		// 通过 charid 添加黑名单
		public function addBlackByCharid(charid:uint):void
		{
			var cmdblack:stMoveFriendToBlackListFriendCmd = new stMoveFriendToBlackListFriendCmd();
			cmdblack.charid = charid;
			m_gkContext.sendMsg(cmdblack);
		}
		
		// 通过 charid 添加黑名单
		public function addBlackByName(name:String):void
		{
			
		}
	}
}