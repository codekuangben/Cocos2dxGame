package game.process
{
	import flash.utils.ByteArray;
	import modulecommon.scene.dazuo.DaZuoMgr;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	import modulecommon.scene.watch.WuMainProperty_Watch;
	import modulecommon.scene.wu.WuProperty;
	
	import game.netmsg.mountcmd.stAddMountToUserCmd;
	import game.netmsg.mountcmd.stRefreshFreeMountTrainTimesCmd;
	import game.netmsg.mountcmd.stRefreshTrainPropCmd;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.mountscmd.stChangeUserMountCmd;
	import modulecommon.net.msg.mountscmd.stMountCmd;
	import modulecommon.net.msg.mountscmd.stMountSysInfoCmd;
	import modulecommon.net.msg.mountscmd.stNotifyChangeMountCmd;
	import modulecommon.net.msg.mountscmd.stNotifyTrainPropsCmd;
	import modulecommon.net.msg.mountscmd.stSetRideMountStateCmd;
	import modulecommon.scene.beings.MountsSys;
	import modulecommon.scene.beings.Player;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.beings.UserState;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIMountsSys;
	import modulecommon.net.msg.mountscmd.stViewOtherUserMountCmd;

	/**
	 * ...
	 * @author ...
	 */
	public class MountsProcess extends ProcessBase
	{
		public function MountsProcess(gk:GkContext)
		{
			super(gk);

			dicFun[stMountCmd.PARA_MOUNT_SYS_INFO_CMD] = psstMountSysInfoCmd;
			dicFun[stMountCmd.PARA_NOTIFY_TRAINPROPS_CMD] = psstNotifyTrainPropsCmd;

			dicFun[stMountCmd.PARA_ADD_MOUNT_TO_USER_CMD] = psstAddMountToUserCmd;
			dicFun[stMountCmd.PARA_REFRESH_TRAIN_PROP_CMD] = psstRefreshTrainPropCmd;
			dicFun[stMountCmd.PARA_CHANGE_USERMOUNT_CMD] = psstChangeUserMountCmd;
			dicFun[stMountCmd.PARA_NOTIFY_CHANGE_MOUNT_CMD] = psstNotifyChangeMountCmd;
			
			dicFun[stMountCmd.PARA_REFRESH_FREE_MOUNT_TRAINTIMES_CMD] = psstRefreshFreeMountTrainTimesCmd
			dicFun[stMountCmd.PARA_VIEW_OTHER_USER_MOUNT_CMD] = psstViewOtherUserMountCmd;
			dicFun[stMountCmd.GM_PARA_VIEW_OTHER_USER_MOUNT_CMD ] = gk.m_gmWatchMgr.processstGmViewOtherUserMountCmd;
		}
		
		// test
		//override public function process(msg:ByteArray, param:uint):void
		//{
		//	if (dicFun[param] != undefined)
		//	{
		//		dicFun[param](msg);
		//	}
		//}

		// 保存主角自己的坐骑数据
		public function psstMountSysInfoCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stMountSysInfoCmd = new stMountSysInfoCmd(this.m_gkContext);
			cmd.deserialize(msg);
			
			var playermain:PlayerMain = this.m_gkContext.m_playerManager.hero;
			if (playermain)
			{
				(playermain.horseSys as MountsSys).mountsAttr.baseAttr = cmd;
			}
			
			if(cmd.ride)
			{
				// 取消打坐
				if(this.m_gkContext.m_playerManager.hero.isUserSet(UserState.USERSTATE_DAZUO))
				{
					m_gkContext.m_dazuoMgr.setStateOfDaZuo(DaZuoMgr.STATE_NODAZUO);
				}
				// 骑乘
				(playermain.horseSys as MountsSys).rideHorse((playermain.horseSys as MountsSys).mountsAttr.baseAttr.findCurMountTblID());
			}
		}
		
		// 坐骑培养属性
		public function psstNotifyTrainPropsCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stNotifyTrainPropsCmd = new stNotifyTrainPropsCmd();
			cmd.deserialize(msg);
			
			var playermain:PlayerMain = this.m_gkContext.m_playerManager.hero;
			if (playermain)
			{
				(playermain.horseSys as MountsSys).mountsAttr.trainAttr = cmd;
			}
			
			// 刷新界面
			var mountsui:IUIMountsSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIMountsSys) as IUIMountsSys;
			if(mountsui)
			{
				mountsui.psstNotifyTrainPropsCmd();
			}
		}
		
		// 加入一个坐骑
		public function psstAddMountToUserCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stAddMountToUserCmd = new stAddMountToUserCmd();
			cmd.deserialize(msg);
			
			// 加入或者刷新都直接替换掉
			var playermain:PlayerMain = this.m_gkContext.m_playerManager.hero;
			if (playermain)
			{
				(playermain.horseSys as MountsSys).mountsAttr.addorRefreshMounts(cmd.action, cmd.mount);
			}
			
			// 刷新界面
			var mountsui:IUIMountsSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIMountsSys) as IUIMountsSys;
			if(mountsui)
			{
				mountsui.psstAddMountToUserCmd();
			}
			
			// 获取第一匹坐骑的时候，直接将这批坐骑放到随身的坐骑栏中，并且骑乘上去
			if(cmd.action == 0)			// 如果是加入新的坐骑
			{
				if((playermain.horseSys as MountsSys).mountsAttr.baseAttr.mountlist.length == 1)	// 获得第一批坐骑
				{
					// 直接放到最深坐骑中去，并且骑乘上去
					// 放大随身的坐骑栏中
					var sendcmd:stChangeUserMountCmd = new stChangeUserMountCmd();
					sendcmd.mountid = cmd.mount.mountid;
					m_gkContext.sendMsg(sendcmd);
					
					// 骑乘上去
					var ridecmd:stSetRideMountStateCmd = new stSetRideMountStateCmd();
					ridecmd.isset = 1;
					m_gkContext.sendMsg(ridecmd);
				}
			}
		}
		
		public function psstRefreshTrainPropCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stRefreshTrainPropCmd = new stRefreshTrainPropCmd();
			cmd.deserialize(msg);
			
			var playermain:PlayerMain = this.m_gkContext.m_playerManager.hero;
			if (playermain)
			{
				(playermain.horseSys as MountsSys).mountsAttr.baseAttr.addOrUpdateTrainProp(cmd.prop);
			}
			
			// 刷新界面
			var mountsui:IUIMountsSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIMountsSys) as IUIMountsSys;
			if(mountsui)
			{
				mountsui.psstRefreshTrainPropCmd();
			}
		}
		
		public function psstChangeUserMountCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stChangeUserMountCmd = new stChangeUserMountCmd();
			cmd.deserialize(msg);
			
			var playermain:PlayerMain = this.m_gkContext.m_playerManager.hero;
			if (playermain)
			{
				//(playermain.horseSys as MountsSys).curHorseID = cmd.mountid;
				(playermain.horseSys as MountsSys).mountsAttr.baseAttr.ridemount = cmd.mountid;
			}
			
			// 刷新界面
			var mountsui:IUIMountsSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIMountsSys) as IUIMountsSys;
			if(mountsui)
			{
				mountsui.psstChangeUserMountCmd();
			}
		}
		
		public function psstNotifyChangeMountCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stNotifyChangeMountCmd = new stNotifyChangeMountCmd();
			cmd.deserialize(msg);
			
			// 骑乘
			var player:Player = this.m_gkContext.m_playerManager.getBeingByTmpID(cmd.utempid) as Player;
			if(player)
			{
				if (cmd.mountid)
				{
					if (!player.horseSys)
					{
						player.horseSys = new MountsSys(player, player.gkcontext);
					}
					player.horseSys.rideHorse(cmd.mountid);
				}
				else
				{
					player.horseSys.unRideHorse();
				}
			}
		}
		
		public function psstRefreshFreeMountTrainTimesCmd(msg:ByteArray, param:uint):void
		{
			var cmd:stRefreshFreeMountTrainTimesCmd = new stRefreshFreeMountTrainTimesCmd();
			cmd.deserialize(msg);
			
			var playermain:PlayerMain = this.m_gkContext.m_playerManager.hero;
			if (playermain)
			{
				(playermain.horseSys as MountsSys).mountsAttr.times = cmd.times;
			}
			
			// 刷新界面
			var mountsui:IUIMountsSys = m_gkContext.m_UIMgr.getForm(UIFormID.UIMountsSys) as IUIMountsSys;
			if(mountsui)
			{
				mountsui.psstRefreshFreeMountTrainTimesCmd();
			}
			
			if (m_gkContext.m_UIs.sysBtn)
			{
				if (cmd.times < 3)
				{
					m_gkContext.m_UIs.sysBtn.showEffectAni(SysbtnMgr.SYSBTN_Mounts);
				}
				else
				{
					m_gkContext.m_UIs.sysBtn.hideEffectAni(SysbtnMgr.SYSBTN_Mounts);
				}
			}
		}
		
		public function psstViewOtherUserMountCmd(msg:ByteArray, param:uint):void
		{
			var wu:WuMainProperty_Watch = m_gkContext.m_watchMgr.getWuByHeroID(WuProperty.MAINHERO_ID) as WuMainProperty_Watch;
			if (wu)
			{
				m_gkContext.m_mountsSysLogic.otherTmpID = wu.m_uHeroID;
			}
			m_gkContext.m_contentBuffer.addContent("stViewOtherUserMountCmd", msg);
			
			var cmd:stViewOtherUserMountCmd = new stViewOtherUserMountCmd();
			cmd.deserialize(msg);
			
			m_gkContext.m_mountsSysLogic.psstViewOtherUserMountCmd(cmd.mountlist, cmd.trainprops);
		}
	}
}