package game.ui.uiTeamFBSys
{	
	import com.dgrigg.image.CommonImageManager;
	import com.pblabs.engine.resource.SWFResource;
	import game.ui.uiTeamFBSys.bossmoney.UIBossMoney;
	import modulecommon.scene.MapInfo;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import modulecommon.commonfuntion.imloader.ModuleResLoader;
	import modulecommon.commonfuntion.imloader.ModuleResLoadingItem;
	import modulecommon.net.msg.copyUserCmd.UserDispatch;
	import modulecommon.net.msg.teamUserCmd.stNotifyTeamMemberListUserCmd;
	import modulecommon.net.msg.teamUserCmd.synUserTeamStateCmd;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.ui.UISubSys;
	import modulecommon.uiinterface.IUITeamFBSys;
	
	import game.ui.uiTeamFBSys.iteamzx.UITeamFBZX;
	import game.ui.uiTeamFBSys.msg.UserHeroData;
	import game.ui.uiTeamFBSys.msg.openMultiCopyUiUserCmd;
	import game.ui.uiTeamFBSys.msg.reqOpenAssginHeroUiCopyUserCmd;
	import game.ui.uiTeamFBSys.msg.retChangeAssginHeroUserCmd;
	import game.ui.uiTeamFBSys.msg.retChangeUserPosUserCmd;
	import game.ui.uiTeamFBSys.msg.retClickMultiCopyUiUserCmd;
	import game.ui.uiTeamFBSys.msg.retFightHeroDataUserCmd;
	import game.ui.uiTeamFBSys.msg.retInviteAddMultiCopyUiUserCmd;
	import game.ui.uiTeamFBSys.msg.retOpenAssginHeroUiCopyUserCmd;
	import game.ui.uiTeamFBSys.msg.retOpenMultiCopyUiUserCmd;
	import game.ui.uiTeamFBSys.msg.retTeamBossRankUserCmd;
	import game.ui.uiTeamFBSys.msg.synCopyRewardExpUserCmd;
	import game.ui.uiTeamFBSys.teamfbsel.UITeamFBSel;
	import game.ui.uiTeamFBSys.teamhall.UITeamFBHall;
	import game.ui.uiTeamFBSys.teaminvite.UITeamFBInvite;
	import game.ui.uiTeamFBSys.teammeminfo.UITeamFBMemInfo;
	import game.ui.uiTeamFBSys.teammger.UITeamFBMger;
	import game.ui.uiTeamFBSys.teamreward.UITeamFBReward;
	import game.ui.uiTeamFBSys.xmldata.XmlParse;
	import game.ui.uiTeamFBSys.teamrank.UITeamFBCGRank;

	/**
	 * @brief 组队副本系统,主界面不能显示
	 */
	public class UITeamFBSys extends UISubSys implements IUITeamFBSys
	{
		/*
		art.uiteamfbsys.join.down;
		art.uiteamfbsys.join.over;
		art.uiteamfbsys.join.normal;
		art.uiteamfbsys.rightback1;
		art.uiteamfbsys.rightbackimage;
		art.uiteamfbsys.rightbackobj;
		
		art.uiteamfbsys.rightback2;
		art.uiteamfbsys.createfb;
		art.uiteamfbsys.slzt;
		art.uiteamfbsys.title_word;
		art.uiteamfbsys.wkq;
		art.uiteamfbsys.xyfb;
		
		art.uiteamfbsyszx.dwbz;
		art.uiteamfbsyszx.dzbz;
		art.uiteamfbsyszx.kaizhan;
		art.uiteamfbsyszx.kwct;
		art.uiteamfbsyszx.kwdbzjt;
		
		art.uiteamfbsyszx.redbtn;
		art.uiteamfbsyszx.bgduiwuguanli;
		art.uiteamfbsyszx.bgduiwuxinxi;
		art.uiteamfbsyszx.btnkuaijieyaoqing;
		art.uiteamfbsyszx.btnrenmingduizhang;
		art.uiteamfbsyszx.btntichuduiwu;
		art.uiteamfbsyszx.btntianjiachengyuan;
		art.uiteamfbsyszx.btnzhaohuanduiyou;
		
		art.uiteamfbsysinvite.ok;
		art.uiteamfbsysinvite.icon;
		art.uiteamfbsysinvite.head;
		
		art.uiteamfbsysinvite.search.down;
		art.uiteamfbsysinvite.search.over;
		art.uiteamfbsysinvite.search.normal;
		art.uiteamfbsysinvite.itemback;
		
		art.uiteamfbsysinvite.decorationbottom;
		art.uiteamfbsyszx.ani;
		
		art.uiteamfbsysrd.btn;
		art.uiteamfbsysrd.rolegold;
		art.uiteamfbsysrd.tongguan;
		art.uiteamfbsysrd.wordgold;
		art.uiteamfbsysrd.notopenbg;
		*/

		protected var m_TFBSysData:UITFBSysData;

		public function UITeamFBSys()
		{

		}
		
		override public function onReady():void
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			m_TFBSysData = new UITFBSysData();
			m_TFBSysData.m_gkcontext = m_gkcontext;
			m_TFBSysData.m_form = this;
			m_TFBSysData.m_xmlParseEndCB = endXmlParse;
			m_TFBSysData.m_onUIClose = onUIClose;
			
			m_TFBSysData.m_resLoader = new ModuleResLoader(m_gkcontext);
			var item:ModuleResLoadingItem = new ModuleResLoadingItem();
			item.m_path = CommonImageManager.toPathString("module/uiteamfbsys.swf");
			item.m_classType = SWFResource;
			
			m_TFBSysData.m_resLoader.addResName(item);
			m_TFBSysData.m_resLoader.addEventListener(ModuleResLoader.EventLoadEnd, onResReady);
			m_TFBSysData.m_resLoader.loadRes();
		}
		
		public function onResReady(event:Event):void
		{
			this.swfRes = m_TFBSysData.m_resLoader.m_resLoadedDic["asset/uiimage/module/uiteamfbsys.swf"];
			// 读取配置文件
			var xmlparse:XmlParse = new XmlParse(m_TFBSysData);
			xmlparse.loadConfig();
		}
		
		override public function dispose():void
		{
			m_TFBSysData.m_gkcontext.m_teamFBSys.clearData();
			m_TFBSysData.m_resLoader.removeEventListener(ModuleResLoader.EventLoadEnd, onResReady);
			m_TFBSysData.dispose();		// 这个要放在最后，因为上面的语句需要用到里面的内容
			super.dispose();
		}
		
		public function openUI(formid:uint):void
		{
			// 如果已经打开了
			if(!addOpenFlag(formid))
			{
				return;
			}
			
			var form:Form;

			if(UIFormID.UITeamFBSel == formid)
			{
				form = new UITeamFBSel();
				(form as UITeamFBSel).m_TFBSysData = m_TFBSysData;
				m_TFBSysData.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UITeamFBZX == formid)
			{
				form = new UITeamFBZX();
				(form as UITeamFBZX).m_TFBSysData = m_TFBSysData;
				m_TFBSysData.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UITeamFBInvite == formid)
			{
				form = new UITeamFBInvite();
				(form as UITeamFBInvite).m_TFBSysData = m_TFBSysData;
				m_TFBSysData.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UITeamFBMemInfo == formid)
			{
				form = new UITeamFBMemInfo();
				(form as UITeamFBMemInfo).m_TFBSysData = m_TFBSysData;
				m_TFBSysData.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UITeamFBMger == formid)
			{
				form = new UITeamFBMger();
				(form as UITeamFBMger).m_TFBSysData = m_TFBSysData;
				m_TFBSysData.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UITeamFBReward == formid)
			{
				form = new UITeamFBReward();
				(form as UITeamFBReward).m_TFBSysData = m_TFBSysData;
				m_TFBSysData.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UITeamFBHall == formid)
			{
				form = new UITeamFBHall();
				(form as UITeamFBHall).m_TFBSysData = m_TFBSysData;
				m_TFBSysData.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UITeamFBCGRank == formid)
			{
				form = new UITeamFBCGRank();
				(form as UITeamFBCGRank).m_TFBSysData = m_TFBSysData;
				m_TFBSysData.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
			else if(UIFormID.UIBossMoney == formid)
			{
				form = new UIBossMoney();
				(form as UIBossMoney).m_TFBSysData = m_TFBSysData;
				m_TFBSysData.m_gkcontext.m_UIMgr.addForm(form);
				form.show();
			}
		}
		
		// xml 解析完成回调函数
		protected function endXmlParse():void
		{
			//openUI(UIFormID.UITeamFBZX);
			//openUI(UIFormID.UITeamFBSel);
			//openUI(UIFormID.UITeamFBInvite);
			//openUI(UIFormID.UITeamFBMemInfo);
			//openUI(UIFormID.UITeamFBMger);
			//openUI(UIFormID.UITeamFBReward);
			
			// 请求界面
			if(m_TFBSysData.m_gkcontext.m_teamFBSys.clkBtn)
			{
				//var cmd:openMultiCopyUiUserCmd = new openMultiCopyUiUserCmd();
				//m_TFBSysData.m_gkcontext.sendMsg(cmd);
				//m_TFBSysData.m_gkcontext.m_teamFBSys.clkBtn = false;

				openUI(UIFormID.UITeamFBHall);	// 直接打开这个界面
			}
			
			//var msg:ByteArray = m_gkcontext.m_contentBuffer.addContent("stNotifyTeamMemberListUserCmd", msg) as ByteArray;
			//if(msg)
			//{
			//	psstNotifyTeamMemberListUserCmd(msg);
			//}
			
			var msg:synUserTeamStateCmd = m_gkcontext.m_contentBuffer.getContent("synUserTeamStateCmd", true) as synUserTeamStateCmd;
			if(msg)
			{
				pssynUserTeamStateCmd(msg);
			}
			
			if(m_gkcontext.m_contentBuffer.getContent("stNotifyTeamMemberListUserCmd", true))
			{
				psstNotifyTeamMemberListUserCmd();
			}
			
			var byte:ByteArray;
			byte = m_gkcontext.m_contentBuffer.getContent("retFightHeroDataUserCmd", true) as  ByteArray;
			if(byte)
			{
				psretFightHeroDataUserCmd(byte);
			}
			
			byte = m_gkcontext.m_contentBuffer.getContent("synCopyRewardExpUserCmd", true) as  ByteArray;
			if(byte)
			{
				pssynCopyRewardExpUserCmd(byte);
			}
			
			byte = m_gkcontext.m_contentBuffer.getContent("retTeamBossRankUserCmd", true) as  ByteArray;
			if(byte)
			{
				psretTeamBossRankUserCmd(byte);
			}
			
			// 组队 bos 显示这个界面
			if (MapInfo.MAPID_TeamChuanGuan == m_gkcontext.m_mapInfo.m_servermapconfigID)
			{
				openUI(UIFormID.UIBossMoney);
			}
		}
		
		public function psretOpenMultiCopyUiUserCmd(msg:ByteArray):void
		{
			var cmd:retOpenMultiCopyUiUserCmd = new retOpenMultiCopyUiUserCmd();
			cmd.deserialize(msg);
			var formhall:UITeamFBHall;
			// 先确保打开这个界面
			if (!m_TFBSysData.m_gkcontext.m_teamFBSys.openHallMulMsg)
			{
				openUI(UIFormID.UITeamFBSel);
			}
			else
			{
				m_TFBSysData.m_gkcontext.m_teamFBSys.openHallMulMsg = false;
			}
			
			var form:UITeamFBSel = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSel) as UITeamFBSel;
			if(form)
			{
				var idx:uint = 0;
				while(idx < 3)
				{
					form.m_pageLst[idx].psretOpenMultiCopyUiUserCmd(cmd);
					++idx;
				}
				
				// 关闭之前副本大厅的界面
				formhall = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBHall) as UITeamFBHall;
				if(formhall)
				{
					formhall.exit();
				}
			}
			else
			{
				formhall = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBHall) as UITeamFBHall;
				if (formhall)
				{
					formhall.psretOpenMultiCopyUiUserCmd(cmd);
				}
			}
		}
		
		public function psretClickMultiCopyUiUserCmd(msg:ByteArray):void
		{
			var cmd:retClickMultiCopyUiUserCmd = new retClickMultiCopyUiUserCmd();
			cmd.deserialize(msg);
			m_TFBSysData.m_openedFBLst = cmd.data;
			var form:UITeamFBSel = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSel) as UITeamFBSel;
			if(form)
			{
				form.m_pageOpened.psretClickMultiCopyUiUserCmd(cmd);
			}
		}
		
		public function psstNotifyTeamMemberListUserCmd():void
		{
			// 先确保打开这个界面
			//openUI(UIFormID.UITeamFBMemInfo);
			
			m_TFBSysData.m_teamMemInfo = m_TFBSysData.m_gkcontext.m_teamFBSys.teamMemInfo as stNotifyTeamMemberListUserCmd;

			var form:UITeamFBMemInfo = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBMemInfo) as UITeamFBMemInfo;
			if(form)
			{
				form.psstNotifyTeamMemberListUserCmd();
			}
			var formmger:UITeamFBMger = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBMger) as UITeamFBMger;
			if(formmger)
			{
				formmger.psstNotifyTeamMemberListUserCmd();
			}
			
			var formZX:UITeamFBZX = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBZX) as UITeamFBZX;
			if(formZX)
			{
				//  如果这个界面存在，就需要重新请求打开阵法界面，因为添加了新成员了
				var cmd:reqOpenAssginHeroUiCopyUserCmd = new reqOpenAssginHeroUiCopyUserCmd();
				m_TFBSysData.m_gkcontext.sendMsg(cmd);
				
				//formZX.psstNotifyTeamMemberListUserCmd();
			}
		}
		
		public function pssynUserTeamStateCmd(msg:synUserTeamStateCmd):void
		{
			// 打开队伍界面
			openUI(UIFormID.UITeamFBMemInfo);
		}
		
		// 更新界面
		public function psnotifyTeamMemberLeaderChangeUserCmd():void
		{
			var formInfo:UITeamFBMemInfo;
			formInfo = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBMemInfo) as UITeamFBMemInfo;
			if(formInfo)
			{
				formInfo.psnotifyTeamMemberLeaderChangeUserCmd();
			}
			
			var formMger:UITeamFBMger = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBMger) as UITeamFBMger;
			if(formMger)
			{
				formMger.psnotifyTeamMemberLeaderChangeUserCmd();
			}
			
			var formZX:UITeamFBZX = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBZX) as UITeamFBZX;
			if(formZX)
			{
				formZX.psnotifyTeamMemberLeaderChangeUserCmd();
			}
		}
		
		public function psretInviteAddMultiCopyUiUserCmd(msg:ByteArray):void
		{
			var cmd:retInviteAddMultiCopyUiUserCmd = new retInviteAddMultiCopyUiUserCmd();
			cmd.deserialize(msg);
			
			var formInvite:UITeamFBInvite;
			formInvite = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBInvite) as UITeamFBInvite;
			if(formInvite)
			{
				formInvite.psretInviteAddMultiCopyUiUserCmd(cmd);
			}
		}
		
		public function pstakeOffTeamMemberUserCmd():void
		{
			// 删除用户对应的出战武将的数据
			if(m_TFBSysData.m_gkcontext.m_teamFBSys.delMemID)
			{
				var idx:uint = 0;
				var itemUD:UserDispatch;
				while(m_TFBSysData.m_ud && (idx < m_TFBSysData.m_ud.length))
				{
					itemUD = m_TFBSysData.m_ud[idx];
					if(itemUD && m_TFBSysData.m_gkcontext.m_teamFBSys.delMemID == itemUD.charid)
					{
						m_TFBSysData.m_ud[idx] = null;
						break;
					}
					++idx;
				}
				
				idx = 0;
				var itemUserHeroData:UserHeroData;
				while( m_TFBSysData.m_heroData && (idx < m_TFBSysData.m_heroData.data.length))
				{
					itemUserHeroData = m_TFBSysData.m_heroData.data[idx];
					if(itemUserHeroData && m_TFBSysData.m_gkcontext.m_teamFBSys.delMemID == itemUserHeroData.dwUserID)
					{
						m_TFBSysData.m_heroData.data.splice(idx, 1);
						m_TFBSysData.m_heroData.size -= 1;
						break;
					}
					++idx;
				}
				
				m_TFBSysData.m_gkcontext.m_teamFBSys.delMemID = 0;
			}
			
			var formInfo:UITeamFBMemInfo;
			formInfo = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBMemInfo) as UITeamFBMemInfo;
			if(formInfo)
			{
				formInfo.pstakeOffTeamMemberUserCmd();
			}
			
			var formMger:UITeamFBMger = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBMger) as UITeamFBMger;
			if(formMger)
			{
				formMger.pstakeOffTeamMemberUserCmd();
			}
			
			var formZX:UITeamFBZX = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBZX) as UITeamFBZX;
			if(formZX)
			{
				formZX.pstakeOffTeamMemberUserCmd();
			}
		}
		
		//返回请求打开队伍布阵界面 s->c
		public function psretOpenAssginHeroUiCopyUserCmd(msg:ByteArray):void
		{
		 	var cmd:retOpenAssginHeroUiCopyUserCmd = new retOpenAssginHeroUiCopyUserCmd();
			cmd.deserialize(msg);
			
			// 保存数据
			// test 先注释掉，否则会将初始化的数据给清理掉的
			m_TFBSysData.ud = cmd.ud;
			// 确认自己所在的哪一行
			m_TFBSysData.m_selfRow = getSelfRow();
			
			var formZX:UITeamFBZX;
			formZX = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBZX) as UITeamFBZX;
			if(formZX)
			{
				formZX.psretOpenAssginHeroUiCopyUserCmd(cmd);
			}
			
			//m_TFBSysData.logInfo();
		}
		
		protected function getSelfRow():int
		{
			// 根据 charid 查找自己的位置
			if(m_TFBSysData.ud)
			{
				var item:UserDispatch;
				var idx:int = 0;
				while(idx < 3)
				{
					item = m_TFBSysData.ud[idx];
					if(item)
					{
						if(item.charid == m_TFBSysData.m_gkcontext.m_playerManager.hero.charID)
						{
							return item.pos;
						}
					}
					
					++idx;
				}
			}
			return 0;
		}
		
		public function psretChangeAssginHeroUserCmd(msg:ByteArray):void
		{
			if(!m_TFBSysData.ud)		// 如果客户端从来没有请求过阵法数据，就直接返回吧，因为跟们客户端还没有数据
			{
				return;
			}
			var cmd:retChangeAssginHeroUserCmd = new retChangeAssginHeroUserCmd();
			cmd.deserialize(msg);
			// 调整保存的数据
			cmd.srcpos = m_TFBSysData.psretChangeAssginHeroUserCmd(cmd.pos, cmd.type, cmd.dh);
			if(cmd.srcpos >= 0)	// 如果是 -1 就是错误
			{
				// 更新界面
				var formZX:UITeamFBZX;
				formZX = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBZX) as UITeamFBZX;
				if(formZX)
				{
					formZX.psretChangeAssginHeroUserCmd(cmd);
					formZX.psretFightHeroDataUserCmd(null);		// 改变上阵武将必然要更新一次标题信息
				}
			}
		}
		
		// 返回请求调整队伍布阵 s->c (队长调整后，队伍所有 人都会收到此消息)
		public function psretChangeUserPosUserCmd(msg:ByteArray):void
		{
			var cmd:retChangeUserPosUserCmd = new retChangeUserPosUserCmd();
			cmd.deserialize(msg);
			
			// 主要是修改 bug 
			if (!m_TFBSysData.ud)
			{
				return;
			}
			
			var item:UserDispatch;
			var idx:int = 0;
			while(idx < 3)
			{
				if(m_TFBSysData.ud[idx] && m_TFBSysData.ud[idx].charid == cmd.id)
				{
					break;
				}
				++idx;
			}
			
			if(idx < 3)
			{
				cmd.src = idx;
				item = m_TFBSysData.ud[cmd.pos];
				if(item)
				{
					item.pos = idx;
				}
				m_TFBSysData.ud[cmd.pos] = m_TFBSysData.ud[idx];
				if(m_TFBSysData.ud[cmd.pos])
				{
					m_TFBSysData.ud[cmd.pos].pos = cmd.pos;
				}
				m_TFBSysData.ud[idx] = item;
			}
			// 确认自己所在的哪一行
			m_TFBSysData.m_selfRow = getSelfRow();

			var formZX:UITeamFBZX;
			formZX = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBZX) as UITeamFBZX;
			if(formZX)
			{
				formZX.psretChangeUserPosUserCmd(cmd);
			}
		}
		
		public function addParam(strEventID:String, questID:uint, embranchmentId:uint):void
		{
			m_TFBSysData.m_strEventID = strEventID;
			m_TFBSysData.m_questID = questID;
			m_TFBSysData.m_embranchmentId = embranchmentId;
		}
		
		public function psretFightHeroDataUserCmd(msg:ByteArray):void
		{
			var cmd:retFightHeroDataUserCmd = new retFightHeroDataUserCmd();
			cmd.deserialize(msg);
			if(!m_TFBSysData.m_heroData)	// 替换，这一次发送自己所有的出战武将，不是自己布阵界面上面的武将，是所有的出战武将
			{
				m_TFBSysData.m_heroData = cmd;
			}
			else	// 追加
			{
				m_TFBSysData.m_heroData.mergeOther(cmd);
			}
			
			var formZX:UITeamFBZX;
			formZX = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBZX) as UITeamFBZX;
			if(formZX)
			{
				formZX.psretFightHeroDataUserCmd(cmd);
			}
		}
		
		public function psretUserProfitInCopyUserCmd(type:int):void
		{
			var formSel:UITeamFBSel;
			formSel = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBSel) as UITeamFBSel;
			if(formSel)
			{
				formSel.psretUserProfitInCopyUserCmd(type);
			}
		}
		
		public function pssynCopyRewardExpUserCmd(msg:ByteArray):void
		{
			var cmd:synCopyRewardExpUserCmd = new synCopyRewardExpUserCmd();
			cmd.deserialize(msg);
			
			m_TFBSysData.m_exp = cmd.exp;
		}
		
		public function psretTeamBossRankUserCmd(msg:ByteArray):void
		{
			var formrank:UITeamFBCGRank;
			formrank = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBCGRank) as UITeamFBCGRank;
			if(!formrank)
			{
				openUI(UIFormID.UITeamFBCGRank);
				formrank = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBCGRank) as UITeamFBCGRank;
			}
			
			var cmd:retTeamBossRankUserCmd = new retTeamBossRankUserCmd();
			cmd.deserialize(msg);
			m_TFBSysData.m_rankLst = cmd.m_lst;
			
			formrank.psretTeamBossRankUserCmd(cmd);
		}
		
		// 界面是否 ready ，主要是资源
		public function isUIReady():Boolean
		{
			return m_TFBSysData.m_resLoader.m_resLoaded;
		}
		
		public function psstRetTeamAssistInfoUserCmd(msg:ByteArray):void
		{
			var formhall:UITeamFBHall = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBHall) as UITeamFBHall;
			if(formhall)
			{
				formhall.psstRetTeamAssistInfoUserCmd(msg);
			}
		}
		
		public function psstGainTeamAssistGiftUserCmd(msg:ByteArray):void
		{
			var formhall:UITeamFBHall = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBHall) as UITeamFBHall;
			if(formhall)
			{
				formhall.psstGainTeamAssistGiftUserCmd(msg);
			}
		}
	}
}