package game.process
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import common.Context;
	import game.netmsg.sceneUserCmd.practiceVipTimeUserCmd;
	import game.netmsg.sceneUserCmd.updateMainTempidUserCmd;
	import game.netmsg.sceneUserCmd.updateTrialTowerMapNameCmd;
	import game.netmsg.sceneUserCmd.updateUserMoveSpeedUserCmd;
	import game.ui.uiblack.UIBlack;
	import game.ui.uiQAsys.UIQAsys;
	import game.ui.uiRadar.UIRadar;
	import modulecommon.commonfuntion.SysOptions;
	import modulecommon.scene.hero.AttrBufferMgr;
	import modulecommon.uiinterface.IUIGWSkill;
	import modulecommon.uiinterface.IUIVipTiYan;
	//import modulecommon.net.msg.paoshangcmd.stReqBusinessServerDataCmd;
	import modulecommon.net.msg.sgQunYingCmd.stReqCrossServerDataCmd;
	import modulecommon.scene.dazuo.DaZuoMgr;
	import modulecommon.uiinterface.IUITongQueTai;
	import modulecommon.uiinterface.IUITongQueWuHui;
	import modulecommon.uiinterface.IUITreasureHunt;
	import modulecommon.uiinterface.IUIXingMai;
	import modulecommon.uiinterface.IUIYizhelibao;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.ffilmation.utils.mathUtils;
	
	import common.net.msg.basemsg.stNullUserCmd;
	import game.netmsg.sceneUserCmd.minorUserTipUserCmd;
	import game.netmsg.sceneUserCmd.stAddFakeUserAndPosMapScreenUserCmd;
	import game.netmsg.sceneUserCmd.stAddMapNpcMapScreenUserCmd;
	import game.netmsg.sceneUserCmd.stAddUserAndPosMapScreenUserCmd;
	import game.netmsg.sceneUserCmd.stAutoMoveUserCmd;
	import game.netmsg.sceneUserCmd.stBatchRemoveNpcMapScreenUserCmd;
	import game.netmsg.sceneUserCmd.stBatchRemoveUserMapScreenUserCmd;
	import game.netmsg.sceneUserCmd.stChangeMapUserDataCmd;
	import game.netmsg.sceneUserCmd.stMapDataUserCmd;
	import game.netmsg.sceneUserCmd.stPKSrcPreLoadCmd;
	import game.netmsg.sceneUserCmd.stRemoveEntryMapScreenUserCmd;
	import game.netmsg.sceneUserCmd.stReturnUserRegSceneCmd;
	import game.netmsg.sceneUserCmd.stSendNineScreenFakeUserDataUserCmd;
	import game.netmsg.sceneUserCmd.stSendNineScreenNpcDataUserCmd;
	import game.netmsg.sceneUserCmd.stSendNineScreenUserDataUserCmd;
	import game.netmsg.sceneUserCmd.stStopMoveUserCmd;
	import game.netmsg.sceneUserCmd.stUserGotoUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stUserMoveMoveUserCmd;
	import game.netmsg.sceneUserCmd.updateUserCorpsNameCmd;
	import game.netmsg.sceneUserCmd.stmsg.FakeUserDataPos;
	import game.netmsg.sceneUserCmd.stmsg.NpcDataPos;
	import game.netmsg.sceneUserCmd.stmsg.UserDataPos;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.HintMgr;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.commonfuntion.delayloader.DelayLoaderBase;
	import net.ContentBuffer;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.showActivityIconUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stGameTokenUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stMainUserData;
	import modulecommon.net.msg.sceneUserCmd.stMainUserDataUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stNotifyOpenOneFunctionCmd;
	import modulecommon.net.msg.sceneUserCmd.stNpcMoveUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stQuestDialogUserCmd;
	//import modulecommon.net.msg.sceneUserCmd.stReqOtherClientDebugInfoCmd;
	//import modulecommon.net.msg.sceneUserCmd.stRetOtherClientDebugInfoCmd;
	import modulecommon.net.msg.sceneUserCmd.stRetVerifyUseNameUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stSetUserStateCmd;
	import modulecommon.net.msg.sceneUserCmd.updateVipScoreUserCmd;
	import modulecommon.scene.MapInfo;
	import modulecommon.scene.SceneViewer;
	import modulecommon.scene.antiaddiction.AntiAddictionMgr;
	import modulecommon.scene.beings.NpcPlayerFake;
	import modulecommon.scene.beings.NpcVisit;
	import modulecommon.scene.beings.Player;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.beings.PlayerManager;
	import modulecommon.scene.beings.PlayerOther;
	import modulecommon.scene.infotip.InfoTip;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcVisitItem;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import modulecommon.scene.wu.WuMainProperty;
	import com.util.UtilTools;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUICorpsCitySys;
	import modulecommon.uiinterface.IUICreateNameHero;
	import modulecommon.uiinterface.IUIGamble;
	//import modulecommon.uiinterface.IUIGmPlayerAttributes;
	import modulecommon.uiinterface.IUIInfoTip;
	import modulecommon.uiinterface.IUIMapName;
	import modulecommon.uiinterface.IUINpcTalk;
	import modulecommon.uiinterface.IUIRadar;
	
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	import modulecommon.scene.beings.MountsSys;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public final class SceneUserProcess
	{
		private var m_dicFun:Dictionary;
		private var m_gkcontext:GkContext;
		private var m_context:Context;
		public function SceneUserProcess(cont:GkContext):void
		{
			m_gkcontext = cont;
			m_context = m_gkcontext.m_context;
			
			m_dicFun = new Dictionary();
			m_dicFun[SceneUserParam.GAME_TOKEN_USERCMD_PARA] = processGameTokenUserCmd;
			m_dicFun[SceneUserParam.ADD_FAKE_USER_AND_POS_MAPSCREEN_USERCMD_PARA] = processAddFakeUserAndPosMapScreenUserCmd;
			m_dicFun[SceneUserParam.SEND_NINE_SCREEN_FAKE_USERDATA_USERCMD_PARA] = processSendNineScreenFakeUserDataUserCmd;
			m_dicFun[SceneUserParam.REQ_SET_COMMONSET_USERCMD_PARA] = m_gkcontext.m_sysOptions.changeState;
			m_dicFun[SceneUserParam.RET_COMMONSET_USERCMD_PARA] = m_gkcontext.m_sysOptions.init;
			m_dicFun[SceneUserParam.RET_MODIFYNAME_USERCMD_PARA] = processCreateNameModifyNameCmd;
			m_dicFun[SceneUserParam.RET_VERIFY_USE_NAME_USERCMD_PARA] = processCreteNameVerifyUseNameCmd;
			m_dicFun[SceneUserParam.MAIN_USER_DATA_USERCMD_PARA] = processMain_user_data;
			m_dicFun[SceneUserParam.YET_OPEN_NEW_FUNCTION_USERCMD_PARA] = m_gkcontext.m_sysnewfeatures.init;
			m_dicFun[SceneUserParam.OPEN_ONE_FUNCTION_USERCMD_PARA] = processOpenOneFunctionUserCmd;
			m_dicFun[SceneUserParam.PK_SRC_PRELOAD_USERCMD] = processPreLoad;
			m_dicFun[SceneUserParam.SEND_NINE_SCREEN_NPCDATA_USERCMD_PARA] = processSendNineScreenNpcDataUserCmd;
			m_dicFun[SceneUserParam.ADDMAPNPC_MAPSCREEN_USERCMD_PARA] = processAddMapNpcMapScreenUserCmd;
			m_dicFun[SceneUserParam.REQ_OTER_CLIENT_DEBUG_INFO_PARA] = m_gkcontext.m_gmMgr.processReqOtherClientDebugInfoCmd;
			m_dicFun[SceneUserParam.RET_OTHER_CLIENT_DEBUG_INFO_PARA] = m_gkcontext.m_gmMgr.processRetOtherClientDebugInfoCmd;
			m_dicFun[SceneUserParam.UPDATE_USER_VIP_SCORE_USERCMD_PARA] = processUpdateUserVipScoreUserCmd;
			m_dicFun[SceneUserParam.CHANGE_MAP_USERDATA_USERCMD_PARA] = processChangeMapUserDataCmd;
			m_dicFun[SceneUserParam.RET_VIEWED_MAIN_USER_DATA_USERCMD_PARA] = m_gkcontext.m_watchMgr.addMainProperty;
			m_dicFun[SceneUserParam.GM_RET_VIEWED_MAIN_USER_DATA_USERCMD_PARA] = m_gkcontext.m_gmWatchMgr.processgmRetViewedMainUserDataUserCmd;
			m_dicFun[SceneUserParam.PARA_SET_USERSTATE_USERCMD] = processSetUserStateCmd;
			m_dicFun[SceneUserParam.PARA_PER_DAY_VALUE_USERCMD] = m_gkcontext.m_dailyActMgr.processPreDayValueUserCmd;
			m_dicFun[SceneUserParam.PARA_PER_DAY_TO_DO_USERCMD] = m_gkcontext.m_dailyActMgr.processpreDayToDoUserCmd;
			m_dicFun[SceneUserParam.PARA_NOTIFY_FIGHTNUM_LIMIT_USERCMD] = m_gkcontext.m_zhenfaMgr.processNotifyFightnumLimitUserCmd;
			m_dicFun[SceneUserParam.UPDATE_USER_CORPSNAME_USERCMD] = processupdateUserCorpsNameCmd;
			m_dicFun[SceneUserParam.MAP_DATA_USERCMD_PARA] = processstMapDataUserCmd;
			//m_gkcontext.m_fCB = processPreLoad;
			m_dicFun[SceneUserParam.SHOW_ACTIVITY_ICON_USERCMD] = psshowActivityIconUserCmd;
			m_dicFun[SceneUserParam.MINOR_USER_TIP_USERCMD] = processMinorUserTipUsercmd;
			m_dicFun[SceneUserParam.SYN_ONLINE_FIN_DATA_USERCMD] = processSynOnlineFinDataUsercmd;
			m_dicFun[SceneUserParam.UPDATE_MAIN_TEMPID_USERCMD_PARA] = process_updateMainTempidUserCmd;
			m_dicFun[SceneUserParam.UPDATE_USER_MOVE_SPEED_USERCMD_PARA] = process_updateUserMoveSpeedUserCmd;
			m_dicFun[SceneUserParam.PARA_USER_BUFFER_LIST_USERCMD] = m_gkcontext.m_attrBufferMgr.processUserBufferListUserCmd;
			m_dicFun[SceneUserParam.PARA_ADD_BUFFER_TO_USER_USERCMD] = m_gkcontext.m_attrBufferMgr.processAddBufferToUserUserCmd;
			m_dicFun[SceneUserParam.PARA_REMOVE_ONE_BUFFER_USERCMD] = m_gkcontext.m_attrBufferMgr.processRemoveOneBufferUserCmd;
			m_dicFun[SceneUserParam.USERMOVE_MOVE_USERCMD_PARA] = process_stUserMoveMoveUserCmd;
			m_dicFun[SceneUserParam.REMOVE_ENTRY_MAPSCREEN_USERCMD_PARA] = process_stRemoveEntryMapScreenUserCmd;
			m_dicFun[SceneUserParam.BATCHREMOVENPC_MAPSCREEN_USERCMD_PARA] = process_stBatchRemoveNpcMapScreenUserCmd;
			m_dicFun[SceneUserParam.PARA_GODLY_WEAPON_SYS_INFO_USERCMD] = m_gkcontext.m_godlyWeaponMgr.processGodlyWeaponSysInfoUseCmd;
			m_dicFun[SceneUserParam.PARA_ADD_GODLY_WEAPON_USERCMD] = m_gkcontext.m_godlyWeaponMgr.processAddGodlyWeaponUseCmd;
			m_dicFun[SceneUserParam.PARA_WEAR_GODLY_WEAPON_USERCMD] = m_gkcontext.m_godlyWeaponMgr.processWearGodlyWeaponUseCmd;
			m_dicFun[SceneUserParam.PARA_GODLY_WEAPON_SKILL_TRAIN_RESULT_USERCMD] = m_gkcontext.m_godlyWeaponMgr.processGodlyWeaponSkillTrainResultUserCmd;
			m_dicFun[SceneUserParam.PARA_TREASURE_HUNTING_UIINFO_USERCMD] = m_gkcontext.m_treasurehuntMgr.processStTreasureHuntingUIInfoCmd;
			m_dicFun[SceneUserParam.PARA_NOTIFY_TREASURE_HUNTING_SCORE_USERCMD] = m_gkcontext.m_treasurehuntMgr.processstNotifyTreasureHuntingScoreCmd;
			m_dicFun[SceneUserParam.PARA_REFRESH_HUNTING_BIGPRIZE_USERCMD] = m_gkcontext.m_treasurehuntMgr.processStRefreshHuntingBigPrizeCmd;
			m_dicFun[SceneUserParam.PARA_REFRESH_HUNTING_PERSONAL_PRIZE_USERCMD] = m_gkcontext.m_treasurehuntMgr.processStRefreshHuntingPersonalPrizeCmd;
			m_dicFun[SceneUserParam.PARA_HUNTING_RESULT_USERCMD] = processstHuntingResultCmd;
			m_dicFun[SceneUserParam.UPDATE_TRIAL_TOWER_MAP_NAME_USERCMD] = psupdateTrialTowerMapNameCmd;
			m_dicFun[SceneUserParam.PARA_NOTIFY_ANSWER_QUESTION_QUESTNPC_INFO_USERCMD] = psParaNotifyAnswerQuestionQuestnpcInfoUsercmd
			m_dicFun[SceneUserParam.PARA_RET_QUESTION_INFO_USERCMD] = psParaRetQuestionInfoUsercmd;
			m_dicFun[SceneUserParam.PARA_USER_ACT_RELATIONS_USERCMD] = m_gkcontext.m_wuMgr.processUserActRelationsUserCmd;
			m_dicFun[SceneUserParam.PARA_ACTIVE_USER_ACT_RELATION_USERCMD] = m_gkcontext.m_wuMgr.processActiveUserActRelationUserCmd;
			m_dicFun[SceneUserParam.PARA_VIEW_OTHER_USER_GWSYS_INFO_USERCMD] = m_gkcontext.m_watchMgr.processViewOtherUserGWSysInfoUserCmd;
			
			m_dicFun[SceneUserParam.PRACTICE_VIP_TIME_USERCMD_PARA] = pspracticeVipTimeUserCmd;
			
			m_context.m_enterSceneCB = firEnterSceneCB;
		}
		
		public function playerInScene(userdata:UserDataPos):void
		{
			var being:BeingEntity;
			var player:PlayerOther;
			var pt:Point;
			
			being = m_gkcontext.m_playerManager.getBeingByTmpID(userdata.tempid);
			pt = m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(userdata.x, userdata.y));
			
			if (being != null)
			{
				player = being as PlayerOther;
			}
			else
			{
				var playerid:String = m_gkcontext.m_context.m_playerResMgr.modelName(userdata.job, userdata.sex);
				being = m_context.m_sceneView.scene().createCharacter(EntityCValue.TPlayer, playerid, pt.x, pt.y, 0, UtilTools.convS2CDir(userdata.dir));
				if (being == null)
				{
					Logger.info(null, null, "创建角色失败:" + "charID" + userdata.charid);
					return;
				}
				being.vel = MapInfo.s_moveSpeedConvertFromServerToClient(userdata.speed);
				player = being as PlayerOther;
				
				player.tempid = userdata.tempid;
				player.name = userdata.name;
				player.setBaseParam(userdata.charid, userdata.sex, userdata.job, userdata.platform, userdata.zoneID);
				
				player.m_uVipscore = userdata.vipscore;
				player.corpsName = userdata.corpsname;
				player.guanzhiName = userdata.guanzhi;
				
				player.initStates(userdata.states);
				m_gkcontext.m_playerManager.addBeingByTmpID(player.tempid, player);
			}
			m_gkcontext.addLog("其它玩家进入9屏 tempid=" + userdata.tempid + ", name=" + userdata.name);
			if (player)
			{
				//other.vel = revAddUserAndPosMapScreenUserCmd.data.speed;
				player.moveTo(pt.x, pt.y, 0);
				if (userdata.mountid)
				{
					if (!player.horseSys)
					{
						player.horseSys = new MountsSys(player, player.gkcontext);
					}
					player.horseSys.rideHorse(userdata.mountid); // 骑乘
				}
			}
		}
		
		public function playerFakeInScene(userdata:FakeUserDataPos):void
		{
			var being:NpcPlayerFake;
			var pt:Point;
			
			being = m_gkcontext.m_playerFakeMgr.getBeingByTempID(userdata.udp.tempid);
			pt = m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(userdata.udp.x, userdata.udp.y));
			
			if (being == null)
			{
				var playerid:String = m_gkcontext.m_context.m_playerResMgr.modelName(userdata.udp.job, userdata.udp.sex);
				being = m_context.m_sceneView.scene().createCharacter(EntityCValue.TNpcPlayerFake, playerid, pt.x, pt.y, 0, UtilTools.convS2CDir(userdata.udp.dir)) as NpcPlayerFake;
				if (being == null)
				{
					Logger.info(null, null, "创建角色失败:" + "charID" + userdata.udp.charid);
					return;
				}
				
				being.tempid = userdata.udp.tempid;
				being.m_charID = userdata.udp.charid;
				being.level = userdata.udp.level;
				being.m_zhanli = userdata.zhanli;
				being.name = userdata.udp.name; // 这个名字设置放在站立后面,更新头顶名字
				
				m_gkcontext.addLog("藏宝库假人:" + userdata.udp.name + " " + userdata.udp.tempid);
				//player.gender = userdata.sex;
				m_gkcontext.m_playerFakeMgr.addBeingByTmpID(being.tempid, being);
			}
			
			if (being)
			{
				being.moveToPos(pt);
			}
		}
		
		public function processSceneUserCmd(msg:ByteArray, param:uint):void
		{
			if (m_dicFun[param] != undefined)
			{
				m_dicFun[param](msg);
				return
			}
			var cmd:stNullUserCmd;
			var hero:BeingEntity;
			var other:BeingEntity;
			
			var idx:uint = 0;
			var user:UserDataPos;
			var player:Player;
			var pt:Point;
			var playerMgr:PlayerManager;
			
			var npc:NpcVisit;
			var npcData:NpcDataPos;
			var tNpcVisitItem:TNpcVisitItem;
			
			var render:fFlash9ElementRenderer;
			var npclayer:uint = EntityCValue.SLObject; // 有些 npc 走地物层
			
			switch (param)
			{
				case SceneUserParam.USER_DATA_USERCMD_PARA: 
				{
					m_gkcontext.m_wuMgr.updateMainPropery(msg);
					break;
				}
				case SceneUserParam.RETURN_USER_REG_SCENE_PARA: 
				{
					var revReturnUserRegSceneCmd:stReturnUserRegSceneCmd = new stReturnUserRegSceneCmd();
					revReturnUserRegSceneCmd.deserialize(msg);
					if (revReturnUserRegSceneCmd.byResult)
					{
						trace("注册失败");
					}
					else
					{
						trace("注册成功");
					}
					break;
				}
				
				case SceneUserParam.STOP_MOVE_USERCMD_PARA: 
				{
					var revStopMoveUserCmd:stStopMoveUserCmd = new stStopMoveUserCmd();
					revStopMoveUserCmd.deserialize(msg);
					
					var mainUser:PlayerMain = m_gkcontext.m_playerManager.hero;
					
					if (mainUser != null)
					{
						m_gkcontext.addLog("收到stStopMoveUserCmd，禁止玩家移动");
						mainUser.stopMoveFlag = true;
						mainUser.stopMoving();
							//mainUser.stopMoveFlag = true;
					}
					break;
				}
				case SceneUserParam.USER_GOTO_USERCMD_PARA: 
				{
					//将主角直接拉到指定坐标
					var revUserGotoUserCmd:stUserGotoUserCmd = new stUserGotoUserCmd();
					revUserGotoUserCmd.deserialize(msg);
					
					pt = m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(revUserGotoUserCmd.x, revUserGotoUserCmd.y));
					playerMgr = m_gkcontext.m_playerManager;
					if (playerMgr.hero)
					{
						// 移动位置
						playerMgr.hero.moveTo(pt.x, pt.y, 0);
						// 停止移动
						playerMgr.hero.stopMoving(false);
						// 更改方向
						playerMgr.hero.direction = UtilTools.convS2CDir(revUserGotoUserCmd.dir);
					}
					
					break;
				}
				case SceneUserParam.ADD_USER_AND_POS_MAPSCREEN_USERCMD_PARA: 
				{
					var revAddUserAndPosMapScreenUserCmd:stAddUserAndPosMapScreenUserCmd = new stAddUserAndPosMapScreenUserCmd();
					revAddUserAndPosMapScreenUserCmd.deserialize(msg);
					playerInScene(revAddUserAndPosMapScreenUserCmd.data);
					break;
				}
				case SceneUserParam.SEND_NINE_SCREEN_USERDATA_USERCMD_PARA: 
				{
					cmd = new stSendNineScreenUserDataUserCmd();
					cmd.deserialize(msg);
					
					while (idx < (cmd as stSendNineScreenUserDataUserCmd).size)
					{
						user = (cmd as stSendNineScreenUserDataUserCmd).data[idx];
						playerInScene(user);
						
						++idx;
					}
					break;
				}
				
				case SceneUserParam.BATCHREMOVEUSER_MAPSCREEN_USERCMD_PARA: // 批量移除 玩家
				{
					var retBatchRemoveUser:stBatchRemoveUserMapScreenUserCmd = new stBatchRemoveUserMapScreenUserCmd();
					retBatchRemoveUser.deserialize(msg);
					
					idx = 0;
					var id:uint;
					while (idx < retBatchRemoveUser.num)
					{
						id = retBatchRemoveUser.id[idx];
						player = m_gkcontext.m_playerManager.getBeingByTmpID(id) as Player;
						if (player)
						{
							m_gkcontext.addLog("stBatchRemoveUserMapScreenUserCmd 删除玩家tempid=" + id + ", name=" + player.name);
						}
						m_gkcontext.m_playerManager.destroyBeingByTmpID(id);
						++idx;
					}
					break;
				}
				case SceneUserParam.QUEST_DIALOG_USERCMD_PARAMETER: 
				{
					m_gkcontext.m_dazuoMgr.m_inTalkOnline = true;
					
					var revVisitNpcTradeUserCmd:stQuestDialogUserCmd = new stQuestDialogUserCmd();
					revVisitNpcTradeUserCmd.deserialize(msg);
					m_gkcontext.m_strNpcTalkBuffer = revVisitNpcTradeUserCmd.menuTxt;
					
					m_gkcontext.m_contentBuffer.addContent("uiNpcTalk_content", revVisitNpcTradeUserCmd);
					if (m_gkcontext.m_localMgr.isSet(LocalDataMgr.LOCAL_WillIntoBattle))
					{
						break;
					}
					else
					{
						var formRadar:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UINpcTalk);
						if (formRadar)
						{
							//m_gkcontext.m_UIMgr.showForm(UIFormID.UINpcTalk);
							(formRadar as IUINpcTalk).processNpcTalk();
						}
						else
						{
							
							m_gkcontext.m_UIMgr.loadForm(UIFormID.UINpcTalk);
						}
					}
					break;
				}
				
				case SceneUserParam.NPCMOVE_MOVE_USERCMD_PARA: 
				{
					var revAddMapNpcMapScreenUserCmd:stNpcMoveUserCmd = new stNpcMoveUserCmd();
					revAddMapNpcMapScreenUserCmd.deserialize(msg);
					
					npc = m_gkcontext.m_npcManager.getBeingByTmpID(revAddMapNpcMapScreenUserCmd.dwNpcTempID) as NpcVisit;
					if (npc != null)
					{
						pt = m_gkcontext.m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(revAddMapNpcMapScreenUserCmd.x, revAddMapNpcMapScreenUserCmd.y));
						npc.moveToPos(pt);
					}
					break;
				}
				case SceneUserParam.AUTO_MOVE_USERCMD_PARA: 
				{
					// "goto mapid=1001 x=52 y=25 dir=0"
					var revAutoMoveUserCmd:stAutoMoveUserCmd = new stAutoMoveUserCmd();
					revAutoMoveUserCmd.deserialize(msg);
					
					var paraDic:Dictionary = new Dictionary();
					var paraList:Array;
					var key2value:Array;
					paraList = revAutoMoveUserCmd.param.split(" ");
					while (idx < paraList.length)
					{
						key2value = paraList[idx].split("=");
						if (key2value[1])
						{
							paraDic[key2value[0]] = parseInt(key2value[1]);
						}
						++idx;
					}
					
					if (paraDic["x"] && paraDic["y"])
					{
						pt = m_gkcontext.m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(paraDic["x"], paraDic["y"]));
						player = m_gkcontext.m_playerManager.hero as Player;
						if (player)
						{
							(player as PlayerMain).destDir = UtilTools.convS2CDir(paraDic["dir"]);
							player.moveToPos(pt);
						}
					}
					
					break;
				}
			}
		}
		public function processstHuntingResultCmd(msg:ByteArray):void
		{
			var iui:IUITreasureHunt = m_gkcontext.m_UIMgr.getForm(UIFormID.UITreasureHunt) as IUITreasureHunt;
			if (iui)
			{
				iui.processMsg_stHuntingResultCmd(msg);
			}
		}
		public function psParaRetQuestionInfoUsercmd(msg:ByteArray):void
		{
			var form:UIQAsys = m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIQAsys) as UIQAsys;
			form.process_stRetQuestionInfoCmd(msg)
			form.show();
		}
		public function psParaNotifyAnswerQuestionQuestnpcInfoUsercmd(msg:ByteArray):void
		{
			m_gkcontext.m_qasysMgr.process_stNotifyAnswerQuestionQuestNpcInfoCmd(msg);
			var hintParam:Object = new Object();
			hintParam[HintMgr.HINTTYPE] = HintMgr.HINTTYPE_QAsys;
			m_gkcontext.m_hintMgr.hint(hintParam);
		}
		public function processstMapDataUserCmd(msg:ByteArray):void
		{
			var revMapDataUserCmd:stMapDataUserCmd = new stMapDataUserCmd();
			revMapDataUserCmd.deserialize(msg);
			
			// 如果已经选择了角色，第一次进入场景，阶段可能不对
			if (m_gkcontext.m_context.progLoading.isState(EntityCValue.PgNo) || m_gkcontext.m_context.progLoading.isState(EntityCValue.PgHeroSel) || m_gkcontext.m_context.progLoading.isState(EntityCValue.Pg1001FES))
			{
				m_gkcontext.m_context.progLoading.state = EntityCValue.PgFES_LoadingRes;
			}
			
			// 如果是第一次进入场景,就把资源都加在进来,因为需要加载的资源太多了
			if (m_gkcontext.m_context.progLoading.isState(EntityCValue.PgFES_LoadingRes))
			{
				Logger.info(null, null, "第一次收到服务器地图消息: " + "serverID = " + revMapDataUserCmd.servermapconfigID + " clientID = " + revMapDataUserCmd.filename + " fightmapID = " + revMapDataUserCmd.battlemap);
				m_gkcontext.m_context.setMsgBufferFlag(EntityCValue.BufferMsg_forMap);
				m_gkcontext.m_contentBuffer.addContent("stMapDataUserCmd", revMapDataUserCmd);
				// 显示加载进度条
				//m_gkcontext.m_UIs.progLoading.state = EntityCValue.PgFES;
				m_gkcontext.m_context.progLoading.show();
				m_gkcontext.m_context.progLoading.startLoading();
				// 加载地形
				m_gkcontext.m_context.m_terrainManager.loadRes(int(revMapDataUserCmd.filename), revMapDataUserCmd.battlemap);
				
				// 加载模型
				//m_gkcontext.m_playerManager.loadResNUnload();
				m_gkcontext.m_playerManager.loadPlaceholder();
				//m_gkcontext.m_playerManager.loadModelCfg();
				//m_gkcontext.m_playerManager.loadEffCfg();
				
				// 这个放到启动的时候就加载
				//m_gkcontext.m_playerManager.loadModelCfgOnlyOne();
				//m_gkcontext.m_playerManager.loadEffCfgOnlyOne();
				
				// 加载 UI
				m_gkcontext.m_UIMgr.loadAllFormImm();
				m_gkcontext.m_UIMgr.loadAllFormOnlySwf();
			}
			//else
			//{
			
				firEnterSceneCB(revMapDataUserCmd);
			
			//}
		}
		
		public function firEnterSceneCB(cmd:stMapDataUserCmd = null):void
		{
			try
			{
				
			var mapInfo:MapInfo=m_gkcontext.m_mapInfo;
			if (m_context.progLoading.isState(EntityCValue.PgFES_LoadingRes))
			{
				m_context.progLoading.state = EntityCValue.PgFES;
				m_context.clearMsgBufferFlag(EntityCValue.BufferMsg_forMap);
			}
			var revMapDataUserCmd:stMapDataUserCmd;
			if (!cmd)
			{
				revMapDataUserCmd = m_gkcontext.m_contentBuffer.getContent("stMapDataUserCmd", true) as stMapDataUserCmd;
			}
			else
			{
				revMapDataUserCmd = cmd;
			}
			
			// 停止上一个地图的背景音乐
			mapInfo.m_presceneMusic = mapInfo.m_sceneMusic;
			if (!m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_CLIENT_LDSSound))
			{
				if (mapInfo.m_presceneMusic.length)
				{
					this.m_context.m_soundMgr.stop(mapInfo.m_presceneMusic);
				}
			}
			
			if (mapInfo.m_bInSGQYH)
			{
				m_gkcontext.m_heroRallyMgr.exitHeroRally();
			}
			
			m_gkcontext.m_UIMgr.closeAllFormInDesktop(UIFormID.SecondLayer);
			m_gkcontext.m_UIMgr.closeAllFormInDesktop(UIFormID.PlaceLayer); // 这一层也需要释放
			// m_gkcontext.m_context.m_playerManager.preInit(m_gkcontext.m_context.m_sceneView.scene);
			// m_gkcontext.m_context.m_npcManager.preInit(m_gkcontext.m_context.m_sceneView.scene);
			// 记录当前场景 "./terrain/xml/example1.xml"
			//var nameFileName:String = "./asset/scene/xml/" + revMapDataUserCmd.filename;
			var nameFileName:String = m_context.m_path.getPathByName("x" + revMapDataUserCmd.filename + ".swf", EntityCValue.PHXMLTINS);
			mapInfo.m_mapPath = nameFileName;
			
			var str:String = "stMapDataUserCmd " + revMapDataUserCmd.mapname + "(" + revMapDataUserCmd.servermapconfigID + "," + revMapDataUserCmd.filename + ")";
			DebugBox.addLog(str);
			
			}
			catch (e:Error)
			{
				DebugBox.sendToDataBase("firEnterSceneCB  first"+revMapDataUserCmd);
			}
			try
			{
				
			
			var bHasScene:Boolean = m_context.m_sceneView.hasScene(nameFileName);
			if (false == bHasScene)
			{
				m_context.m_gameHandleMsg.cacheMsg();
			}
			
			// 更新主角状态
			var main:PlayerMain = m_gkcontext.m_playerManager.hero;
			if (main)
			{
				main.stopMoving(false);
			}
			
			if (mapInfo.curMapID != 0)
			{
				this.leaveMap(mapInfo.m_servermapconfigID);
			}
			//revMapDataUserCmd.battlemap = 9048;
			
			mapInfo.setBaseParam(revMapDataUserCmd.id, revMapDataUserCmd.servermapconfigID, parseInt(revMapDataUserCmd.filename), revMapDataUserCmd.battlemap, revMapDataUserCmd.mapname);
			
			mapInfo._xWorldmap = revMapDataUserCmd.x;
			mapInfo._yWorldmap = revMapDataUserCmd.y;
			
			Logger.info(null, null, "跳地图: " + "serverID = " + revMapDataUserCmd.servermapconfigID + " clientID = " + revMapDataUserCmd.filename + " fightmapID = " + revMapDataUserCmd.battlemap);
			m_context.m_sceneView.gotoScene(nameFileName, revMapDataUserCmd.servermapconfigID);
			
			//mapInfo.m_presceneMusic = mapInfo.m_sceneMusic;
			if (revMapDataUserCmd.backmusic.length)
			{
				mapInfo.m_sceneMusic = revMapDataUserCmd.backmusic + ".mp3";
			}
			else if (mapInfo.mapType() == MapInfo.MTMain) // 如果是进入场景
			{
				mapInfo.m_sceneMusic = EntityCValue.DSMusic;
			}
			else
			{
				mapInfo.m_sceneMusic = EntityCValue.DNMusic;
			}
			
			if (revMapDataUserCmd.x > 0)
			{
				mapInfo._npcIDSkip = EntityCValue.NPCID_SKIPInCity;
			}
			else
			{
				mapInfo._npcIDSkip = 0;
			}
			var form:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIRadar);
			if (form != null)
			{
				(form as IUIRadar).updateMapName();
				(form as IUIRadar).updateBtnRadar();
			}
			}
			catch (e:Error)
			{
				DebugBox.sendToDataBase("firEnterSceneCB  second"+e.getStackTrace());
			}
			try
			{
			this.enterMap(mapInfo.m_servermapconfigID);
			}
			catch (e:Error)
			{
				DebugBox.sendToDataBase("firEnterSceneCB  3"+e.getStackTrace());
			}
			//if (bHasScene)
			//{
			//	m_gkcontext.m_context.m_playerManager.postInit(m_gkcontext.m_context.m_sceneView.scene);
			//}
			
			// 延迟加载战斗地图资源，战斗地图在延迟加载中立即加载吧
			//var item:DelayLoaderMap = new DelayLoaderMap();
			//item.m_gkcontext = m_gkcontext;
			//item.m_path = m_gkcontext.m_context.m_path.getPathByName("x" + this.mapInfo.fightMapName + ".swf", EntityCValue.PHXMLTINS);
			//item.m_loadInterval = 1;
			//m_gkcontext.m_delayLoader.addDelayLoadItem(item);
			
			// 过场景的时候释放之前的内容
			try
			{
			if (mapInfo.lastfightMapName != revMapDataUserCmd.battlemap)
			{
				this.m_context.m_sceneResMgr.disposeScene(mapInfo.lastfightMapName);
			}
			if (mapInfo.lastservermapconfigID != revMapDataUserCmd.servermapconfigID)
			{
				this.m_context.m_sceneResMgr.disposeScene(mapInfo.lastservermapconfigID);
			}
			
			// 播放当前背景音乐
			if (!m_gkcontext.m_sysOptions.isSet(SysOptions.COMMONSET_CLIENT_LDSSound))
			{
				if (mapInfo.m_sceneMusic.length)
				{
					this.m_context.m_soundMgr.play(mapInfo.m_sceneMusic, EntityCValue.FXDft, 0.0, int.MAX_VALUE);
				}
			}
			
			// 显示地图名字
			var uimapname:IUIMapName = this.m_gkcontext.m_UIMgr.getForm(UIFormID.UIMapName) as IUIMapName;
			if (mapInfo.clientMapID != 1000) // 出生地图不需要这个地图名字
			{
				if (!uimapname)
				{
					this.m_gkcontext.m_UIMgr.loadForm(UIFormID.UIMapName);
				}
				else
				{
					uimapname.enterMap(mapInfo.m_servermapconfigID);
				}
			}
			
			if (mapInfo.m_servermapconfigID == MapInfo.MAPID_CORPSCITY) // 如果是军团城市争夺战，就显示一个界面
			{
				var ui:IUICorpsCitySys = m_gkcontext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
				if (!ui)
				{
					m_gkcontext.m_UIMgr.loadForm(UIFormID.UICorpsCitySys);
				}
			}
			else if (mapInfo.mapType() == MapInfo.CorpsCitySys) // 如果进入军团副本不是场景 8 ，就是进入真正的场景
			{
				m_gkcontext.m_corpsCitySys.inScene = true;
			}
			
			}
			catch (e:Error)
			{
				DebugBox.sendToDataBase("firEnterSceneCB  4"+e.getStackTrace());
			}
		}
		
		public function processMain_user_data(msg:ByteArray):void
		{
			var playerMgr:PlayerManager;
			playerMgr = m_gkcontext.m_playerManager;
			var playerMain:PlayerMain;
			var pt:Point;
			
			var revCmd:stMainUserDataUserCmd = new stMainUserDataUserCmd();
			
			revCmd.deserialize(msg);
			var rev:stMainUserData = revCmd.m_mainData;
			if (playerMgr.hero && playerMgr.hero.tempid != rev.tempid)
			{
				playerMgr.destroyBeingByTmpID(playerMgr.hero.tempid, false);
				playerMgr.hero.tempid = rev.tempid;
				playerMgr.addBeingByTmpID(playerMgr.hero.tempid, playerMgr.hero);
			}
			Logger.info(null, null, "server主角出生点 x: " + rev.x + " y: " + rev.y);
			playerMain = playerMgr.getBeingByTmpID(rev.tempid) as PlayerMain;
			pt = m_gkcontext.m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(rev.x, rev.y));
			Logger.info(null, null, "client主角出生点 x: " + pt.x + " y: " + pt.y);
			if (playerMain == null)
			{
				var playerid:String = m_gkcontext.m_context.m_playerResMgr.modelName(rev.job, rev.sex);
				playerMain = m_gkcontext.m_context.m_sceneView.scene().createCharacter(EntityCValue.TPlayerMain, playerid, pt.x, pt.y, 0, UtilTools.convS2CDir(0)) as PlayerMain;
				if (playerMain == null)
				{
					return;
				}
				
				playerMain.prop = m_gkcontext.m_beingProp;
				playerMain.setBaseParam(rev.charid, rev.sex, rev.job, m_gkcontext.m_context.m_LoginData.m_platform_Qianduan, m_gkcontext.m_context.m_LoginData.m_ZoneID_Qianduan);
				
				playerMain.level = rev.level;
				playerMain.name = rev.name;
				playerMain.tempid = rev.tempid;
				playerMain.vel = MapInfo.s_moveSpeedConvertFromServerToClient(rev.moveSpeed);
				playerMain.initStates(rev.states);
				playerMgr.addBeingByTmpID(playerMain.tempid, playerMain);
				playerMgr.hero = playerMain;
				
				m_gkcontext.m_wuMgr.addMainProperty(rev);
				playerMain.setWuProperty(m_gkcontext.m_wuMgr.getMainWu());
				m_gkcontext.m_mainPro.wu = playerMain.wuProperty;
				m_gkcontext.m_beingProp.m_vipscore = rev.vipscore;
				//m_gkcontext.m_beingProp.m_gmMode = playerMain.isGM;
				// 加载模型,需要等到主角数据过来再加载
				if (m_gkcontext.m_context.progLoading.isState(EntityCValue.PgFES))
				{
					m_gkcontext.m_playerManager.loadResNUnload();
					//m_gkcontext.m_playerManager.onloadedPlaceholderSWF();
				}
			}
			else
			{			
				playerMain.direction = UtilTools.convS2CDir(rev.dir);
			}
			playerMain.toPosDirectly_ServerPos(rev.x, rev.y);
			
			playerMain.updateNameDesc();
			(m_gkcontext.m_context.m_sceneView as SceneViewer).followHero(playerMain);
			
			m_gkcontext.m_objMgr.setOpenedSizeForCommonPackage(rev.packageOpendSize1, rev.packageOpendSize2, rev.packageOpendSize3);
			
			if (m_gkcontext.m_mapInfo.clientMapID != 1000)
			{
				playerMain.show();
			}
		}
		
		public function processChangeMapUserDataCmd(msg:ByteArray):void
		{
			var playerMain:PlayerMain = m_gkcontext.playerMain;
			if (playerMain == null)
			{
				Logger.error(null, null, "上线时收到stChangeMapUserDataCmd，且早于stMainUserDataUserCmd");
				return;
			}
			
			if (m_gkcontext.m_mapInfo.clientMapID != 1000)
			{
				playerMain.show();
			}
			
			var rev:stChangeMapUserDataCmd = new stChangeMapUserDataCmd();
			rev.deserialize(msg);
			
			m_gkcontext.addLog("stChangeMapUserDataCmd:位置(" + rev.x + " ," + rev.y + ")");			
			playerMain.toPosDirectly_ServerPos(rev.x, rev.y);
			playerMain.direction = UtilTools.convS2CDir(rev.dir);
			(m_gkcontext.m_context.m_sceneView as SceneViewer).followHero(playerMain);
			
			var gotoParam:Object = m_gkcontext.m_contentBuffer.getContent(ContentBuffer.KEY_GOTO, true);
			if (gotoParam)
			{
				var destX:int = gotoParam["x"];
				var destY:int = gotoParam["y"];
				var npcID:int = gotoParam["npcid"] as int;
				var pt:Point = m_gkcontext.m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(destX, destY));
				if (npcID)
				{
					playerMain.moveToNpcVisitByNpcID(pt.x, pt.y, npcID);
				}
				else
				{
					playerMain.moveToPos(new Point(pt.x, pt.y));
				}
				
			}
		}
		
		public function processGameTokenUserCmd(msg:ByteArray):void
		{
			var rev:stGameTokenUserCmd = new stGameTokenUserCmd();
			rev.deserialize(msg);
			
			var bp:BeingProp = m_gkcontext.m_beingProp;
			var bHasJianghun:Boolean = rev.m_list[BeingProp.JIANG_HUN] != undefined;
			var oldJianghun:int;
			
			if (bHasJianghun)
			{
				oldJianghun = bp.getMoney(BeingProp.JIANG_HUN);
			}
			
			var key:String;
			var value:uint;
			for (key in rev.m_list)
			{
				value = rev.m_list[key];
				bp.setMoney(parseInt(key), value);
				
				DebugBox.addLog("GameToken: type=" + key + "   value=" + value.toString());
			}
			
			var uiGamble:IUIGamble = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGamble) as IUIGamble
			if (uiGamble != null)
			{
				uiGamble.updateMoney(rev.m_list);
			}
			
			var uiGwskill:IUIGWSkill = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGWSkill) as IUIGWSkill;
			if (uiGwskill != null)
			{
				uiGwskill.updateMoney(rev.m_list);
			}
			
			if (rev.m_list[BeingProp.SILVER_COIN] != undefined)
			{
				if (this.m_gkcontext.m_UIs.hero)
				{
					this.m_gkcontext.m_UIs.hero.updateGamemoney();
				}
			}
			
			if (rev.m_list[BeingProp.LING_PAI] != undefined)
			{
				if (m_gkcontext.m_UIs.hero)
				{
					m_gkcontext.m_UIs.hero.updateLingpai();
				}
			}
			
			if (rev.m_list[BeingProp.YUAN_BAO] != undefined)
			{
				if (m_gkcontext.m_UIs.hero)
				{
					m_gkcontext.m_UIs.hero.updateRMB();
				}
				
				if (m_gkcontext.m_marketMgr.m_uiMarketForm)
				{
					m_gkcontext.m_marketMgr.m_uiMarketForm.updateYuanbao();
				}
				
				var uiYizhlibao:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIYizhelibao);
				if (uiYizhlibao && uiYizhlibao.isVisible())
				{
					(uiYizhlibao as IUIYizhelibao).updateYuanbao();
				}
			}
			
			if (rev.m_list[BeingProp.GREEN_SHENHUN] != undefined || rev.m_list[BeingProp.BLUE_SHENHUN] != undefined || rev.m_list[BeingProp.PURPLE_SHENHUN] != undefined)
			{
				DebugBox.addLog("神魂值刷新 绿魂=" + bp.getMoney(BeingProp.GREEN_SHENHUN).toString() + " 蓝魂=" + bp.getMoney(BeingProp.BLUE_SHENHUN).toString());
				if (this.m_gkcontext.m_UIs.jiuguan)
				{
					this.m_gkcontext.m_UIs.jiuguan.updateShenhun();
				}
				if (this.m_gkcontext.m_UIs.backPack)
				{
					this.m_gkcontext.m_UIs.backPack.updateFastZhuanshengForm();
				}
			}
			
			if (rev.m_list[BeingProp.MONEY_WUNV] != undefined)
			{
				var uiTongquetai:IUITongQueTai = m_gkcontext.m_UIMgr.getForm(UIFormID.UITongQueTai) as IUITongQueTai;
				if (uiTongquetai)
				{
					uiTongquetai.updateHaogan();
				}
				var uiTongquewuhui:IUITongQueWuHui = m_gkcontext.m_UIMgr.getForm(UIFormID.UITongQueWuHui) as IUITongQueWuHui;
				if(uiTongquewuhui)
				{
					uiTongquewuhui.updateHaogan();
					
				}
			}
			
			if (bHasJianghun)
			{
				var newJianghun:int = bp.getMoney(BeingProp.JIANG_HUN);
				if (newJianghun > oldJianghun && oldJianghun > 0)
				{
					var param:Object = new Object();
					param["funtype"] = "jianghun";
					param["num"] = newJianghun - oldJianghun;
					if (m_gkcontext.bInBattleIScene)
					{
						m_gkcontext.m_contentBuffer.addContent(ContentBuffer.JIANGHUN_GetAni, param);
					}
					else
					{
						m_gkcontext.m_hintMgr.addToUIZhanliAddAni(param);
					}
				}
				
				DebugBox.addLog("将魂值刷新 将魂=" + newJianghun);
				if (this.m_gkcontext.m_UIs.hero)
				{
					this.m_gkcontext.m_UIs.hero.updateJianghun();
				}
				
				var iuixingmai:IUIXingMai = m_gkcontext.m_UIMgr.getForm(UIFormID.UIXingMai) as IUIXingMai;
				if (iuixingmai)
				{
					iuixingmai.updateJiangHun();
				}
			}
		
		}
		
		public function processAddFakeUserAndPosMapScreenUserCmd(msg:ByteArray):void
		{
			var rev:stAddFakeUserAndPosMapScreenUserCmd = new stAddFakeUserAndPosMapScreenUserCmd();
			rev.deserialize(msg);
			playerFakeInScene(rev.data);
		
		}
		
		public function processSendNineScreenFakeUserDataUserCmd(msg:ByteArray):void
		{
			var rev:stSendNineScreenFakeUserDataUserCmd = new stSendNineScreenFakeUserDataUserCmd();
			rev.deserialize(msg);
			var idx:int = 0;
			while (idx < rev.size)
			{
				playerFakeInScene(rev.data[idx]);
				++idx;
			}
		}
		
		private function addNpc(npcData:NpcDataPos):void
		{
			var pt:Point;
			var npc:NpcVisit;
			var tNpcVisitItem:TNpcVisitItem;
			var npclayer:uint = EntityCValue.SLObject; // 有些 npc 走地物层
			
			npc = m_gkcontext.m_npcManager.getBeingByTmpID(npcData.tempid) as NpcVisit;
			pt = m_gkcontext.m_context.m_sceneView.scene().ServerPointToClientPoint(new Point(npcData.x, npcData.y));
			
			var str:String;
			str = "addNpc-" + npcData.name;
			DebugBox.addLog(str + "(tempid=" + npcData.tempid + ", " + npcData.npcid + ")");
			if (npc == null)
			{
				tNpcVisitItem = (this.m_gkcontext.m_dataTable.getItem(DataTable.TABLE_NPCVISIT, npcData.npcid)) as TNpcVisitItem;
				if (tNpcVisitItem == null)
				{
					Logger.info(null, "processSceneUserCmd", "处理stSendNineScreenNpcDataUserCmd" + "VisitNpcTable中没有编号" + npcData.npcid);
					return;
				}
				npclayer = fUtil.getNpcLayer(tNpcVisitItem.m_uID);
				npc = this.m_gkcontext.m_context.m_sceneView.scene().createCharacter(EntityCValue.TVistNpc, tNpcVisitItem.m_strModel, pt.x, pt.y, 0, UtilTools.convS2CDir(npcData.dir), npclayer) as NpcVisit;
				if (npc == null)
				{
					return;
				}
				
				npc.npcBase = tNpcVisitItem;
				npc.tempid = npcData.tempid;
				npc.isArmy = npcData.isArmy;
				npc.name = npcData.name;
				
				m_gkcontext.m_npcManager.addBeingByTmpID(npc.tempid, npc);
				if (npc.npcBase.m_uID == EntityCValue.NPCID_SKIP && m_gkcontext.m_mapInfo._xWorldmap == 0)
				{
					m_gkcontext.m_mapInfo._xWorldmap = npcData.x;
					m_gkcontext.m_mapInfo._yWorldmap = npcData.y;
					m_gkcontext.m_mapInfo._npcIDSkip = EntityCValue.NPCID_SKIP;
				}
			}
		}
		
		public function processSendNineScreenNpcDataUserCmd(msg:ByteArray):void
		{
			var rev:stSendNineScreenNpcDataUserCmd = new stSendNineScreenNpcDataUserCmd();
			rev.deserialize(msg);
			var idx:int;
			while (idx < rev.size)
			{
				addNpc(rev.data[idx]);
				++idx;
			}
		}
		
		public function processAddMapNpcMapScreenUserCmd(msg:ByteArray):void
		{
			var rev:stAddMapNpcMapScreenUserCmd = new stAddMapNpcMapScreenUserCmd();
			rev.deserialize(msg);
			addNpc(rev.data);
		}
		
		public function enterMap(mapID:int):void
		{
			if (mapID >= 3011 && mapID <= 30070 && mapID != MapInfo.MAPID_TeamChuanGuan && MapInfo.MAPID_JYBOSS != mapID)	// 9998 是一个组队闯关地图 id 
			{
				//进入过关斩将地图
				m_gkcontext.m_ggzjMgr.enterIn();
			}
			else if (MapInfo.MTTeamFB == m_gkcontext.m_mapInfo.mapType() || mapID == MapInfo.MAPID_TeamChuanGuan) // 如果是组队副本或者组队闯关
			{
				m_gkcontext.m_teamFBSys.enterIn();
			}
			else if (MapInfo.MAPID_SanguoZhanchang == mapID)
			{
				m_gkcontext.m_sanguozhanchangMgr.comeIn();
			}
			else if (MapInfo.MAPID_WORLDBOSS == mapID) //世界BOSS
			{
				m_gkcontext.m_worldBossMgr.enterWBoss();
			}
			else if (MapInfo.MAPID_JYBOSS == mapID) //精英BOSS
			{
				m_gkcontext.m_elitebarrierMgr.enterJBoss();
			}
		}
		
		public function leaveMap(mapID:int):void
		{
			if (mapID >= 3011 && mapID <= 30070 && mapID != MapInfo.MAPID_TeamChuanGuan && MapInfo.MAPID_JYBOSS != mapID)
			{
				//离开过关斩将地图
				m_gkcontext.m_ggzjMgr.leave();
			}
			else if (MapInfo.MTTeamFB == m_gkcontext.m_mapInfo.mapType() || mapID == MapInfo.MAPID_TeamChuanGuan) // 如果是组队副本或者组队闯关
			{
				m_gkcontext.m_teamFBSys.leave();
			}
			else if (MapInfo.MAPID_SanguoZhanchang == mapID)
			{
				m_gkcontext.m_sanguozhanchangMgr.leave();
			}
			else if (MapInfo.MAPID_WORLDBOSS == mapID) //世界BOSS
			{
				m_gkcontext.m_worldBossMgr.leaveWBoss();
			}
			else if (MapInfo.MAPID_JYBOSS == mapID) //精英BOSS
			{
				m_gkcontext.m_elitebarrierMgr.leaveJBoss();
			}
		}
		
		public function processCreateNameModifyNameCmd(msg:ByteArray):void
		{
			m_gkcontext.m_contentBuffer.addContent("uiCreateNameHero_name", msg);
			
			var ui:IUICreateNameHero = m_gkcontext.m_UIMgr.getForm(UIFormID.UICreateNameHero) as IUICreateNameHero;
			if (ui)
			{
				ui.processCreateNameModifyNameCmd();
			}
			else
			{
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UICreateNameHero);
			}
		}
		
		public function processCreteNameVerifyUseNameCmd(msg:ByteArray):void
		{
			var rev:stRetVerifyUseNameUserCmd = new stRetVerifyUseNameUserCmd();
			rev.deserialize(msg);
			
			var ui:IUICreateNameHero = m_gkcontext.m_UIMgr.getForm(UIFormID.UICreateNameHero) as IUICreateNameHero;
			if (ui)
			{
				ui.createNameSucceed(rev.m_name, rev.m_bvalid);
			}
		}
		
		public function processOpenOneFunctionUserCmd(msg:ByteArray):void
		{
			var rev:stNotifyOpenOneFunctionCmd = new stNotifyOpenOneFunctionCmd();
			rev.deserialize(msg);
			
			DebugBox.addLog("开启新功能 funcType=" + rev.funcType.toString());
			m_gkcontext.m_sysnewfeatures.setType(rev.funcType);
			
			if (SysNewFeatures.NFT_SGQUNYINGHUI == rev.funcType)
			{
				var send:stReqCrossServerDataCmd = new stReqCrossServerDataCmd();
				m_gkcontext.sendMsg(send);
			}
			
			//if (SysNewFeatures.NFT_PAOSHANG == rev.funcType)
			//{
			//	var cmdpaoshang:stReqBusinessServerDataCmd = new stReqBusinessServerDataCmd();
			//	m_gkcontext.sendMsg(cmdpaoshang);
			//}
			
			if (SysNewFeatures.NFT_NONE == m_gkcontext.m_sysnewfeatures.m_nft)
			{
				m_gkcontext.m_sysnewfeatures.m_nft = rev.funcType;
			}
			else
			{
				if (SysNewFeatures.NFT_CANBAOKU == rev.funcType || SysNewFeatures.NFT_ZHANYITIAOZHAN == rev.funcType || SysNewFeatures.NFT_JIUGUAN == rev.funcType 
					|| SysNewFeatures.NFT_JINGJICHANG == rev.funcType || SysNewFeatures.NFT_TRIALTOWER == rev.funcType || SysNewFeatures.NFT_XUANSHANG == rev.funcType 
					|| SysNewFeatures.NFT_CAISHENDAO == rev.funcType || SysNewFeatures.NFT_TEAMCOPY == rev.funcType || SysNewFeatures.NFT_MEIRIBIZUO == rev.funcType 
					|| SysNewFeatures.NFT_SANGUOZHANCHANG == rev.funcType || SysNewFeatures.NFT_FIRSTCHARGEGIFTBOX == rev.funcType || SysNewFeatures.NFT_TENPERCENTGIFTBOX == rev.funcType 
					|| SysNewFeatures.NFT_WORLDBOSS == rev.funcType || SysNewFeatures.NFT_BAOWUROB == rev.funcType || SysNewFeatures.NFT_CITYBATTLE == rev.funcType
					|| SysNewFeatures.NFT_TREASUREHUNTING == rev.funcType || SysNewFeatures.NFT_WELFAREHALL == rev.funcType || SysNewFeatures.NFT_COLLECTGIFT == rev.funcType
					|| SysNewFeatures.NFT_SGQUNYINGHUI == rev.funcType || SysNewFeatures.NFT_SECRETSTORE == rev.funcType || SysNewFeatures.NFT_PAOSHANG == rev.funcType
					|| SysNewFeatures.NFT_VIPPRACTICE == rev.funcType || SysNewFeatures.NFT_CORPSTREASURE == rev.funcType)
				{
					if (m_gkcontext.m_UIs.screenBtn)
					{
						m_gkcontext.m_UIs.screenBtn.addNewFeature(rev.funcType);
					}
				}
				else if (SysNewFeatures.NFT_DAZAO == rev.funcType || SysNewFeatures.NFT_ZHENFA == rev.funcType || SysNewFeatures.NFT_DAZUO == rev.funcType || SysNewFeatures.NFT_HEROXIAYE == rev.funcType || SysNewFeatures.NFT_JUNTUAN == rev.funcType || SysNewFeatures.NFT_ZHANXING == rev.funcType || SysNewFeatures.NFT_TONGQUETAI == rev.funcType || SysNewFeatures.NFT_MOUNT == rev.funcType)
				{
					if (m_gkcontext.m_UIs.sysBtn)
					{
						m_gkcontext.m_UIs.sysBtn.addNewOneSysBtn(rev.funcType);
					}
				}
				else if (SysNewFeatures.NFT_FRIENDSYS == rev.funcType || SysNewFeatures.NFT_RANK == rev.funcType)
				{
					if (m_gkcontext.m_UIs.radar)
					{
						m_gkcontext.m_UIs.radar.addNewFeatureBtn(rev.funcType);
					}
				}
				else if (SysNewFeatures.NFT_GODLYWEAPON == rev.funcType)
				{
					if (m_gkcontext.m_UIs.hero)
					{
						m_gkcontext.m_UIs.hero.showGodlyWeapon();
					}
				}
				return;
			}
			
			if (SysNewFeatures.NFT_FHLIMIT5 == rev.funcType)
			{
				var hintParam:Object = new Object();
				hintParam[HintMgr.HINTTYPE] = HintMgr.HINTTYPE_ZhenfaAddGrid;
				hintParam["zfgridlimit"] = rev.funcType;
				m_gkcontext.m_hintMgr.hint(hintParam);
				m_gkcontext.m_sysnewfeatures.m_nft = SysNewFeatures.NFT_NONE;
			}
			else if (SysNewFeatures.NFT_RANK == rev.funcType)
			{
				if (m_gkcontext.m_UIs.radar)
				{
					m_gkcontext.m_UIs.radar.addNewFeatureBtn(rev.funcType);
				}
				m_gkcontext.m_sysnewfeatures.m_nft = SysNewFeatures.NFT_NONE;
			}
			else if (SysNewFeatures.NFT_COLLECTGIFT == rev.funcType)
			{
				if (m_gkcontext.m_UIs.screenBtn)
				{
					m_gkcontext.m_UIs.screenBtn.addNewFeature(rev.funcType);
				}
				m_gkcontext.m_sysnewfeatures.m_nft = SysNewFeatures.NFT_NONE;
			}
			else if (SysNewFeatures.NFT_FIRSTCHARGEGIFTBOX == rev.funcType)
			{
				if (m_gkcontext.m_UIs.screenBtn)
				{
					m_gkcontext.m_UIs.screenBtn.firstRechargeVisible(true);
				}
				m_gkcontext.m_sysnewfeatures.m_nft = SysNewFeatures.NFT_NONE;
			}
			else if (SysNewFeatures.NFT_CHARGEREBACK == rev.funcType)
			{
				//该类型定义错误，客户端不做处理
				m_gkcontext.m_sysnewfeatures.m_nft = SysNewFeatures.NFT_NONE;
			}
			else
			{
				if (false == m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIOpenNewFeature))
				{
					var form:Form = m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIOpenNewFeature);
					form.updateData(rev.funcType);
				}
			}
		}
		
		// 处理预加载资源
		/*
		   // 类型 0 ,如果是角色模型，加载待机\攻击\受伤 动作,只加载 第一个方向，如果是特效就加载这个特效，主要是战斗中的资源
		   例如:
		   <pkpreload type="0" srcname="c204,c17,e1711,e1724"/>
		   // 类型 1: 就是加载角色模型，加载 待机/死亡 动作,但是可以指定加载的方向,方向一定要指定，主要是场景中的一些特殊角色
		   例如:
		   <pkpreload type="1" srcname="c201:2-3-4,c17:1"/>
		   c201:2-3-4     c201 是模型名字 2-3-4 是方向 2 、3、4
		 * */
		public function processPreLoad(msg:ByteArray):void
		{
			var cmd:stPKSrcPreLoadCmd = new stPKSrcPreLoadCmd();
			cmd.deserialize(msg);
			//cmd.type = 1;
			//cmd.names = "c201:9|2-3-4&8|0-1,c101:8|2-3";
			var namelist:Array;
			var idx:int = 0;
			var len:uint = 0;
			var type:uint = 0;
			var path:String = "";
			var curVec:Vector.<String> = new Vector.<String>(); // 记录当前加载的资源
			
			var moduleactdirArr:Array;
			var moduleactArr:Array;
			var modeldirArr:Array;
			var dirlst:Array;
			var idxdir:int = 0;
			var idxact:int = 0;
			// 资源不释放了，直到跳地图的时候才释放
			var item:DelayLoaderBase;
			namelist = cmd.names.split(",");
			len = namelist.length;
			if (0 == cmd.type) // 类型 0 ,加载 待机\攻击\受伤 动作
			{
				while (idx < len)
				{
					if (namelist[idx].length)
					{
						type = fUtil.picResType(namelist[idx]);
						if (EntityCValue.PHBEINGTEX == type) // 如果是人物模型资源就需要加载动作
						{
							// 加载图片资源
							// 待机
							path = namelist[idx] + "_0_1" + ".swf";
							path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
							curVec.push(path);
							if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
							{
								item = new DelayLoaderBase();
								item.m_path = path;
								item.m_loadInterval = 1;
								m_gkcontext.m_delayLoader.addDelayLoadItem(item);
							}
							// 攻击
							path = namelist[idx] + "_7_1" + ".swf";
							path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
							curVec.push(path);
							if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
							{
								item = new DelayLoaderBase();
								item.m_path = path;
								item.m_loadInterval = 1;
								m_gkcontext.m_delayLoader.addDelayLoadItem(item);
							}
							// 受伤
							path = namelist[idx] + "_8_1" + ".swf";
							path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
							curVec.push(path);
							if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
							{
								item = new DelayLoaderBase();
								item.m_path = path;
								item.m_loadInterval = 1;
								m_gkcontext.m_delayLoader.addDelayLoadItem(item);
							}
							// 加载配置文件
							path = "x" + namelist[idx] + ".swf";
							path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);
							curVec.push(path);
							if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
							{
								item = new DelayLoaderBase();
								item.m_path = path;
								item.m_loadInterval = 1;
								m_gkcontext.m_delayLoader.addDelayLoadItem(item);
							}
						}
						else if (EntityCValue.PHEFFTEX == type) // 如果是特效资源
						{
							// 受伤
							path = namelist[idx] + "_0_0_0" + ".swf";
							path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHEFFTEX);
							curVec.push(path);
							if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
							{
								item = new DelayLoaderBase();
								item.m_path = path;
								item.m_loadInterval = 1;
								m_gkcontext.m_delayLoader.addDelayLoadItem(item);
							}
							// 加载配置文件
							path = "x" + namelist[idx] + ".swf";
							path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLEINS);
							curVec.push(path);
							if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
							{
								item = new DelayLoaderBase();
								item.m_path = path;
								item.m_loadInterval = 1;
								m_gkcontext.m_delayLoader.addDelayLoadItem(item);
							}
						}
					}
					
					++idx;
				}
				
					// 主角资源全部提前加载了
				/*
				   // 加载主角的动作
				   if (!m_gkcontext.m_delayLoader.m_heroLoaded) // 如果主角的数据没有被加载过，就加载
				   {
				   m_gkcontext.m_delayLoader.m_heroLoaded = true;
				   var mainUser:PlayerMain = m_gkcontext.m_playerManager.hero;
				   var modelstr:String = fUtil.insStrFromModelStr(mainUser.modelName());
				   // 加载图片资源
				   // 待机
				   path = modelstr + "_0_1" + ".swf";
				   path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
				   curVec.push(path);
				   if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
				   {
				   item = new DelayLoaderBase();
				   item.m_path = path;
				   item.m_loadInterval = 1;
				   m_gkcontext.m_delayLoader.addDelayLoadItem(item);
				   }
				   // 攻击
				   path = modelstr + "_7_1" + ".swf";
				   path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
				   curVec.push(path);
				   if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
				   {
				   item = new DelayLoaderBase();
				   item.m_path = path;
				   item.m_loadInterval = 1;
				   m_gkcontext.m_delayLoader.addDelayLoadItem(item);
				   }
				   // 受伤
				   path = modelstr + "_8_1" + ".swf";
				   path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
				   curVec.push(path);
				   if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
				   {
				   item = new DelayLoaderBase();
				   item.m_path = path;
				   item.m_loadInterval = 1;
				   m_gkcontext.m_delayLoader.addDelayLoadItem(item);
				   }
				   // 加载配置文件
				   path = "x" + modelstr + ".swf";
				   path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);
				   curVec.push(path);
				   if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
				   {
				   item = new DelayLoaderBase();
				   item.m_path = path;
				   item.m_loadInterval = 1;
				   m_gkcontext.m_delayLoader.addDelayLoadItem(item);
				   }
				   }
				 */
			}
			else if (1 == cmd.type) // type = 1: 就是加载 任意的方向
			{
				// 这个配置是这样的 c201:9|2-3-4&8|0-1,c101:8|2-3  c201 模型   9 是动作  2-3-4 是方向  & 是动作分割  8 动作 0-1 方向
				while (idx < len)
				{
					// 加载图片资源
					// 待机
					moduleactdirArr = namelist[idx].split(":");
					moduleactArr = moduleactdirArr[1].split("&");
					idxact = 0;
					while (idxact < moduleactArr.length)
					{
						modeldirArr = moduleactArr[idxact].split("|"); // 分离出模型和方向两个
						dirlst = modeldirArr[1].split("-");
						idxdir = 0;
						while (idxdir < dirlst.length)
						{
							path = moduleactdirArr[0] + "_" + modeldirArr[0] + "_" + (int(dirlst[idxdir]) + 1) + ".swf";
							path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHBEINGTEX);
							curVec.push(path);
							if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
							{
								item = new DelayLoaderBase();
								item.m_path = path;
								item.m_loadInterval = 1;
								m_gkcontext.m_delayLoader.addDelayLoadItem(item);
							}
							
							++idxdir;
						}
						
						++idxact;
					}
					
					// 加载配置文件
					path = "x" + moduleactdirArr[0] + ".swf";
					path = m_gkcontext.m_context.m_path.getPathByName(path, EntityCValue.PHXMLCINS);
					curVec.push(path);
					if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
					{
						item = new DelayLoaderBase();
						item.m_path = path;
						item.m_loadInterval = 1;
						m_gkcontext.m_delayLoader.addDelayLoadItem(item);
					}
					
					++idx;
				}
			}
			else if (2 == cmd.type) // type = 2: 就是 UI 资源都是在 asset\ui 目录下
			{
				while (idx < len)
				{
					path = "asset/ui/" + namelist[idx] + ".swf";
					curVec.push(path);
					if (!m_gkcontext.m_context.m_resMgr.getResource(path, SWFResource)) // 如果资源没有加载
					{
						item = new DelayLoaderBase();
						item.m_path = path;
						item.m_loadInterval = 1;
						m_gkcontext.m_delayLoader.addDelayLoadItem(item);
					}
					
					++idx;
				}
			}
			
			// 释放上一次加载这一次不需要的需要卸载的资源
			var filename:String;
			//for each(filename in curVec)
			//{
			//	idx = m_gkcontext.m_delayLoader.m_curFileVec.indexOf(filename);
			//	if(-1 != idx)	// 如果资源之前已经加载
			//	{
			//		m_gkcontext.m_delayLoader.m_curFileVec.splice(idx, 1);	// 删除这个资源
			//	}
			//}
			// 感觉还是遍历已经加载的资源列表
			var idxvec:int = m_gkcontext.m_delayLoader.m_curFileVec.length - 1;
			while (idxvec >= 0)
			{
				filename = m_gkcontext.m_delayLoader.m_curFileVec[idxvec];
				idx = curVec.indexOf(filename);
				if (-1 != idx)
				{
					m_gkcontext.m_delayLoader.m_curFileVec.splice(idxvec, 1); // 删除这个资源
				}
				
				--idxvec;
			}
			
			// 卸载已经加载的资源
			var res:SWFResource;
			for each (filename in m_gkcontext.m_delayLoader.m_curFileVec)
			{
				res = m_gkcontext.m_context.m_resMgr.getResource(filename, SWFResource) as SWFResource;
				if (res && (1 == res.referenceCount)) // 如果没有其它资源引用,就卸载
				{
					m_gkcontext.m_context.m_resMgr.unload(filename, SWFResource);
				}
			}
			
			m_gkcontext.m_delayLoader.m_curFileVec.length = 0;
			m_gkcontext.m_delayLoader.m_curFileVec = curVec;
		}
		
		//被调试的客户端会收到stReqOtherClientDebugInfoCmd
		/*public function processReqOtherClientDebugInfoCmd(msg:ByteArray):void
		   {
		   var rev:stReqOtherClientDebugInfoCmd = new stReqOtherClientDebugInfoCmd();
		   rev.deserialize(msg);
		
		   if (rev.type == stReqOtherClientDebugInfoCmd.TYPE_getLog)
		   {
		   var send:stRetOtherClientDebugInfoCmd = new stRetOtherClientDebugInfoCmd();
		   send.dstcharid = rev.srccharid;
		   send.dstusername = rev.srcusername;
		   send.srccharid = m_gkcontext.playerMain.charID;
		   send.srcusername = m_gkcontext.playerMain.name;
		   send.type = stRetOtherClientDebugInfoCmd.TYPE_ShowLog;
		   var str:String = m_gkcontext.m_logContent;
		   if (str.length > 8000)
		   {
		   str = str.slice(str.length - 8000);
		   }
		   send.text = str;
		   m_gkcontext.sendMsg(send);
		   }
		   else if (rev.type == stReqOtherClientDebugInfoCmd.TYPE_execCode)
		   {
		   var debugForm:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIDebug);
		   var bLoad:Boolean;
		   m_gkcontext.m_contentBuffer.addContent("uiDebug_ReqInfo", rev);
		   if (m_gkcontext.m_UIPath.getPath(UIFormID.UIDebug) == rev.text)
		   {
		   if (debugForm)
		   {
		   debugForm.updateData();
		   }
		   else
		   {
		   bLoad = true;
		   }
		   }
		   else
		   {
		   m_gkcontext.m_UIMgr.destroyForm(UIFormID.UIDebug);
		   m_gkcontext.m_UIPath.setPath(UIFormID.UIDebug, rev.text);
		   bLoad = true;
		   }
		
		   if (bLoad)
		   {
		   m_gkcontext.m_UIMgr.loadForm(UIFormID.UIDebug);
		   }
		   }
		 }*/
		
		//只有GM客户端会收到stRetOtherClientDebugInfoCmd，然后调用此函数处理这个数据
		/*public function processRetOtherClientDebugInfoCmd(msg:ByteArray):void
		   {
		   var rev:stRetOtherClientDebugInfoCmd = new stRetOtherClientDebugInfoCmd();
		   rev.deserialize(msg);
		
		   switch (rev.type)
		   {
		   case stRetOtherClientDebugInfoCmd.TYPE_ShowLog:
		   {
		   var iFormGM:IUIGmPlayerAttributes = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGmPlayerAttributes) as IUIGmPlayerAttributes;
		   if (iFormGM)
		   {
		   var headText:String = rev.srcusername + "(" + rev.srccharid + ")的日志\n";
		   iFormGM.setOtherPlayerLog(headText + rev.text);
		   }
		   break;
		   }
		   case stRetOtherClientDebugInfoCmd.TYPE_ShowMsgInChat:
		   {
		   m_gkcontext.m_uiChat.appendMsg(rev.text);
		   m_gkcontext.m_systemPrompt.prompt(rev.text);
		   break;
		   }
		   }
		
		 }*/
		
		//vip分值变化
		private function processUpdateUserVipScoreUserCmd(msg:ByteArray):void
		{
			//m_gkcontext.m_elitebarrierMgr.m_hasPkCounts = m_gkcontext.m_elitebarrierMgr.pkMaxCounts - m_gkcontext.m_elitebarrierMgr.m_lefttimes;
			
			var oldviplevel:int = m_gkcontext.m_beingProp.vipLevel;
			var rev:updateVipScoreUserCmd = new updateVipScoreUserCmd();
			rev.deserialize(msg);
			m_gkcontext.m_beingProp.m_vipscore = rev.m_vipscore;
			
			if (m_gkcontext.m_UIs.hero)
			{
				m_gkcontext.m_UIs.hero.updateVipLevel();
			}
			
			if (oldviplevel < m_gkcontext.m_beingProp.vipLevel)
			{
				m_gkcontext.m_vipPrivilegeMgr.showVipPrivilegeForm();
			}
			
			if (m_gkcontext.m_UIs.taskPrompt)
			{
				m_gkcontext.m_taskpromptMgr.updateDatas();
				m_gkcontext.m_UIs.taskPrompt.updatePrompt();
			}
			
			var form:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIDaZuo);
			if (form)
			{
				form.updateData();
			}
			
			//成为vip1，清除竞技场、藏宝库冷却时间
			if ((m_gkcontext.m_arenaMgr.leftTimes > 0 || m_gkcontext.m_cangbaokuMgr.coldTime > 0) && m_gkcontext.m_beingProp.vipLevel >= BeingProp.VIP_Level_1)
			{
				m_gkcontext.m_cangbaokuMgr.processssCangBaoKuPkCoolingTimeUserCmd(0);
				m_gkcontext.m_arenaMgr.updateColdTimeDaojishi(0);
			}
			
			//成为vip3，清除强化装备冷却时间
			if ((m_gkcontext.m_equipSysMgr.leftsec > 0) && m_gkcontext.m_beingProp.vipLevel >= BeingProp.VIP_Level_3)
			{
				m_gkcontext.m_equipSysMgr.stopDaoJiShi();
				m_gkcontext.m_equipSysMgr.uiUpdateEquipEnchanceCold();
			}
		}
		
		private function processSetUserStateCmd(msg:ByteArray):void
		{
			var rev:stSetUserStateCmd = new stSetUserStateCmd();
			rev.deserialize(msg);
			var player:Player = m_gkcontext.m_playerManager.getBeingByTmpID(rev.m_tempID) as Player;
			if (player == null)
			{
				return;
			}
			if (rev.m_bSet)
			{
				player.setUserState(rev.m_state);
			}
			else
			{
				player.clearUserState(rev.m_state);
			}
		}
		
		private function processupdateUserCorpsNameCmd(msg:ByteArray):void
		{
			var rev:updateUserCorpsNameCmd = new updateUserCorpsNameCmd();
			rev.deserialize(msg);
			var player:PlayerOther;
			
			player = m_gkcontext.m_playerManager.getBeingByTmpID(rev.tempID) as PlayerOther;
			if (player)
			{
				player.corpsName = rev.corpsname;
			}
		}
		
		private function psshowActivityIconUserCmd(msg:ByteArray):void
		{
			var cmd:showActivityIconUserCmd = new showActivityIconUserCmd();
			cmd.deserialize(msg);
			
			// 这个消息到达的时候 m_gkcontext.m_UIs.screenBtn 这个 UI 还没有实力华
			if (m_gkcontext.m_UIs.screenBtn)
			{
				var bShow:Boolean = false;
				if (cmd.show)
				{
					bShow = true;
				}
				
				if (ScreenBtnMgr.ICON_CORPSFIGHT == cmd.type)
				{ //王城争霸
					updateBtnEffectAniOfCorpsCitySys(bShow);
				}
				else if (ScreenBtnMgr.ICON_ROB_RESOURCE_COPY == cmd.type)
				{ //三国战场
					m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_Sanguozhanchang, bShow);
				}
				else if (ScreenBtnMgr.ICON_RECHARGE_BACK == cmd.type)
				{
					updateBtnOfRacharge(bShow);
				}
				else if (ScreenBtnMgr.ICON_VIP_PRACTICE == cmd.type)
				{
					updateBtnOfVipTY(bShow);
				}
				else if (ScreenBtnMgr.ICON_DT_RECHARGE_BACK == cmd.type)
				{
					updateBtnOfDTRacharge(bShow);
				}
				else if (ScreenBtnMgr.ICON_CORPSTREASURE == cmd.type)
				{ //军团夺宝
					m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_CorpsTreasure, bShow);
				}
			}
			else
			{
				m_gkcontext.m_screenbtnMgr.m_showActIconList.push(cmd);
			}
			
			//活动开始，右下角显示提示
			if (cmd.show)
			{
				if (ScreenBtnMgr.ICON_RECHARGE_BACK == cmd.type)
				{
					return;
				}
				if (ScreenBtnMgr.ICON_DT_RECHARGE_BACK == cmd.type)
				{
					return;
				}
				var hintParam:Object = new Object();
				hintParam[HintMgr.HINTTYPE] = HintMgr.HINTTYPE_ActFeature;
				
				if (ScreenBtnMgr.ICON_CORPSFIGHT == cmd.type)
				{
					hintParam["featuretype"] = HintMgr.ACTFUNC_CITYBATTLE;
				}
				else if (ScreenBtnMgr.ICON_ROB_RESOURCE_COPY == cmd.type)
				{
					hintParam["featuretype"] = HintMgr.ACTFUNC_SANGUOZHANCHANG;
				}
				else if (ScreenBtnMgr.ICON_CORPSTREASURE == cmd.type)
				{
					hintParam["featuretype"] = HintMgr.ACTFUNC_CORPSTREASURE;
				}
				
				m_gkcontext.m_hintMgr.hint(hintParam);
			}
		}
		
		//更新王城争霸数据
		private function updateBtnEffectAniOfCorpsCitySys(bshow:Boolean):void
		{
			if (bshow) // 活动开始
			{
				m_gkcontext.m_UIs.screenBtn.addBtnByID(ScreenBtnMgr.Btn_CorpsCitySys);
				m_gkcontext.m_corpsCitySys.inActive = true;
				
				// 显示对话框
				if (m_gkcontext.m_corpsMgr.m_reg)		// 如果已经报名了
				{
					// 只有开启的时候才会弹出来
					if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_CITYBATTLE))
					{
						// 界面存在更新
						var uicorps:IUICorpsCitySys = m_gkcontext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
						if (uicorps && uicorps.bReady)
						{
							uicorps.psnotifyRegCorpsFightUserCmd(null);
						}
						else
						{
							m_gkcontext.m_contentBuffer.addContent("notifyRegCorpsFightUserCmd", m_gkcontext.m_context.m_SObjectMgr.m_nullByteArray);
							m_gkcontext.m_UIMgr.loadForm(UIFormID.UICorpsCitySys);
						}
					}
				}
			}
			else // 活动结束
			{
				//m_gkcontext.m_UIs.screenBtn.toggleBtnVisible(ScreenBtnMgr.Btn_CorpsCitySys, false);
				m_gkcontext.m_corpsCitySys.inActive = false;
				m_gkcontext.m_corpsMgr.m_reg = 0; // 设置未报名
				// 这个数据一直存在,直到活动结束
				m_gkcontext.m_contentBuffer.delContent("notifyCorpsNpcIDUserCmd");
				// 删除被击信息
				m_gkcontext.m_contentBuffer.delContent("notifyBeAttackUserCmd");
				// 删除军团战斗列表
				var ui:IUIInfoTip = m_gkcontext.m_UIMgr.getForm(UIFormID.UIInfoTip) as IUIInfoTip;
				if (ui)
				{
					ui.delBtn(InfoTip.ENCorpsAttLst);
				}
				// 关闭界面
				//var uicorpssys:IUICorpsCitySys = m_gkcontext.m_UIMgr.getForm(UIFormID.UICorpsCitySys) as IUICorpsCitySys;
				//if(uicorpssys)
				//{
				//	uicorpssys.exit();
				//}
			}
			
			m_gkcontext.m_UIs.screenBtn.updateBtnEffectAni(ScreenBtnMgr.Btn_CorpsCitySys, m_gkcontext.m_corpsCitySys.inActive);
		}
		
		//更新充值返利数据
		private function updateBtnOfRacharge(bshow:Boolean):void
		{
			if (bshow) // 活动开始
			{
				m_gkcontext.m_UIs.screenBtn.addBtnByID(ScreenBtnMgr.Btn_RechargeRebate);
			}
			else // 活动结束
			{
				m_gkcontext.m_UIs.screenBtn.removeBtn(ScreenBtnMgr.Btn_RechargeRebate);
			}
		}
		/**
		 * 定时(即新的)充值返利 按钮显示更新
		 */
		private function updateBtnOfDTRacharge(bshow:Boolean):void
		{
			if (bshow) // 活动开始
			{
				m_gkcontext.m_UIs.screenBtn.addBtnByID(ScreenBtnMgr.Btn_DTRechargeRebate);
			}
			else // 活动结束
			{
				m_gkcontext.m_UIs.screenBtn.removeBtn(ScreenBtnMgr.Btn_DTRechargeRebate);
			}
		}
		
		// vip 体验
		private function updateBtnOfVipTY(bshow:Boolean):void
		{
			m_gkcontext.m_vipTY.binit = true;
			if (bshow) // 活动开始
			{
				m_gkcontext.m_UIs.screenBtn.addBtnByID(ScreenBtnMgr.Btn_VipTiYan);
			}
			else // 活动结束
			{
				m_gkcontext.m_vipTY.clearDJS();
				m_gkcontext.m_vipTY.clearActiveIcon();
				//m_gkcontext.m_UIs.screenBtn.toggleBtnVisible(ScreenBtnMgr.Btn_VipTiYan, false);
				var vipty:IUIVipTiYan = m_gkcontext.m_UIMgr.getForm(UIFormID.UIVipTiYan) as IUIVipTiYan;
				if (vipty)
				{
					vipty.exit();
				}
			}
		}
		
		private function processMinorUserTipUsercmd(msg:ByteArray):void
		{
			var cmd:minorUserTipUserCmd = new minorUserTipUserCmd();
			cmd.deserialize(msg);
			
			m_gkcontext.m_beingProp.m_timeOnLine = cmd.m_hour;
			if (null == m_gkcontext.m_antiAddictionMgr)
			{
				m_gkcontext.m_antiAddictionMgr = new AntiAddictionMgr(m_gkcontext);
			}
			m_gkcontext.m_antiAddictionMgr.showAntiAddictionPrompt();
		}
		
		//服务器已发送所有上线所需数据
		private function processSynOnlineFinDataUsercmd(msg:ByteArray):void
		{
			if (m_context.m_LoginMgr.m_receivesynOnlineFinDataUserCmd > 0)
			{
				m_gkcontext.addLog("多收了synOnlineFinDataUserCmd");
				return;
			}
			m_gkcontext.m_context.m_preLoad = null;
			m_gkcontext.m_context.m_LoginMgr.m_receivesynOnlineFinDataUserCmd++;
			
			var mainwu:WuMainProperty = m_gkcontext.m_wuMgr.getMainWu();
			if (mainwu == null)
			{
				DebugBox.sendToDataBase("processSynOnlineFinDataUsercmd:: mainwu == null");
			}
			//读取Vip特权数据
			m_gkcontext.m_vipPrivilegeMgr.loadConfigCommonXmlData();
			
			var formRadar:Form = m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIRadar);
			if (m_gkcontext.playerMain && m_gkcontext.playerMain.level >= 4)
			{
				formRadar.show();
			}
			
			var formSysBtn:Form = m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UiSysBtn);
			formSysBtn.show();
			
			var formHero:Form = m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIHero);
			formHero.show();
			
			//显示每日任务推荐
			if (m_gkcontext.m_taskpromptMgr.isShowUITaskPrompt())
			{
				if (false == m_gkcontext.m_taskpromptMgr.m_bLoadConfig)
				{
					m_gkcontext.m_taskpromptMgr.initData();
				}
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UITaskPrompt);
			}
			
			//显示防沉迷提示
			if (mainwu && mainwu.m_minor)
			{
				m_gkcontext.m_antiAddictionMgr = new AntiAddictionMgr(m_gkcontext);
				m_gkcontext.m_antiAddictionMgr.showAntiAddictionPrompt();
			}
			
			m_gkcontext.m_benefitHallMgr.initFlag();
			
			var formScreenBtn:Form = m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIScreenBtn);
			if (m_gkcontext.m_screenbtnMgr.isShowUIScreenBtn)
			{
				formScreenBtn.show();
			}
			
			if (m_gkcontext.m_ggzjMgr.inMap)
			{
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UIGgzjWuList);
			}
			if (m_gkcontext.m_elitebarrierMgr.m_bInJBoss&&m_gkcontext.m_UIs.hero && m_gkcontext.m_beingProp.vipLevel == 0)
			{
				m_gkcontext.m_UIs.hero.addBufferIcon(AttrBufferMgr.TYPE_WORLDBOSS, AttrBufferMgr.BufferID_Woxinchangdan);
			}		
			
			m_gkcontext.m_taskMgr.showUITaskTrace();
			m_gkcontext.m_context.m_processManager.setUseIdleTime(true);
		}
		
		private function process_updateMainTempidUserCmd(msg:ByteArray):void
		{
			var rev:updateMainTempidUserCmd = new updateMainTempidUserCmd();
			rev.deserialize(msg);
			m_gkcontext.m_playerManager.setPlayerMainNewTempID(rev.tempid);
		}
		
		private function process_updateUserMoveSpeedUserCmd(msg:ByteArray):void
		{
			var rev:updateUserMoveSpeedUserCmd = new updateUserMoveSpeedUserCmd();
			rev.deserialize(msg);
			var str:String = " 速度改变为：" + rev.m_moveSpeed + "，tempid= " + rev.tempid;
			
			var player:Player = m_gkcontext.m_playerManager.getBeingByTmpID(rev.tempid) as Player;
			if (player)
			{
				player.vel = MapInfo.s_moveSpeedConvertFromServerToClient(rev.m_moveSpeed);
				str = player.name + str;
			}
			m_gkcontext.addLog(str);
		}
		
		private function process_stUserMoveMoveUserCmd(msg:ByteArray):void
		{
			var rev:stUserMoveMoveUserCmd = new stUserMoveMoveUserCmd();
			rev.deserialize(msg);
			var player:Player = m_gkcontext.m_playerManager.getBeingByTmpID(rev.dwUserTempID) as Player;
			if (player)
			{
				if (player.isHero)
				{
					m_gkcontext.addLog("stUserMoveMoveUserCmd: 将" + player.name + "拉到(" + rev.x + "," + rev.y + ")");
				}
				if (mathUtils.distanceSquare(player.x, player.y, rev.x, rev.y) > 600 * 600)
				{
					player.moveTo(rev.x, rev.y, 0);
				}
				else
				{
					player.moveToPos(new Point(rev.x, rev.y));
				}
			}
		}
		
		private function process_stRemoveEntryMapScreenUserCmd(msg:ByteArray):void
		{
			
			var rev:stRemoveEntryMapScreenUserCmd = new stRemoveEntryMapScreenUserCmd();
			rev.deserialize(msg);
			
			var str:String;
			if (rev.type == 0)
			{
				try
				{
					m_gkcontext.m_playerManager.destroyBeingByTmpID(rev.tempid);
				}
				catch (e:Error)
				{
					str = "process_stRemoveEntryMapScreenUserCmd type=" + rev.type + " " + m_gkcontext.m_playerManager + " " + m_gkcontext.m_npcManager + " " + m_gkcontext.m_playerFakeMgr;
					str += e.errorID;
					DebugBox.sendToDataBase(str);
				}
			}
			else if (rev.type == 1)
			{				
				m_gkcontext.m_npcManager.destroyBeingByTmpID(rev.tempid);
			}
			else if (rev.type == 2)
			{				
				m_gkcontext.m_playerFakeMgr.destroyBeingByTmpID(rev.tempid);
			}			
		}
		
		private function process_stBatchRemoveNpcMapScreenUserCmd(msg:ByteArray):void
		{
			var rev:stBatchRemoveNpcMapScreenUserCmd = new stBatchRemoveNpcMapScreenUserCmd();
			rev.deserialize(msg);
			
			
			var idx:int = 0;
			var tempID:uint;
			var str:String;
			while (idx < rev.num)
			{
				tempID = rev.id[idx];
				try
				{
					m_gkcontext.m_npcManager.destroyBeingByTmpID(tempID);
				}
				catch (e:Error)
				{
					str = "process_stBatchRemoveNpcMapScreenUserCmd";
					DebugBox.sendToDataBase(str+e.getStackTrace());
				}
				
				++idx;
			}			
		}
		
		private function psupdateTrialTowerMapNameCmd(msg:ByteArray):void
		{
			var cmd:updateTrialTowerMapNameCmd = new updateTrialTowerMapNameCmd();
			cmd.deserialize(msg);
			
			// 修改地图名字
			m_gkcontext.m_mapInfo.m_ggzjMapID = cmd.mapid;
			this.m_gkcontext.m_mapInfo.mapName = this.m_gkcontext.m_mapInfo.getGGZJMapName();
			
			// 显示地图名字
			var uimapname:IUIMapName = this.m_gkcontext.m_UIMgr.getForm(UIFormID.UIMapName) as IUIMapName;
			if (!uimapname)
			{
				this.m_gkcontext.m_UIMgr.loadForm(UIFormID.UIMapName);
			}
			else
			{
				uimapname.enterMap(cmd.mapid);
				m_gkcontext.m_mapInfo.m_ggzjMapID = 0;
			}
			
			var formExpReward:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIGgzjExpReward);
			if (formExpReward)
			{
				formExpReward.updateData();
			}
			
			// 修改 UIRadar 名字
			var uiradar:UIRadar = this.m_gkcontext.m_UIMgr.getForm(UIFormID.UIRadar) as UIRadar;
			if (uiradar)
			{
				uiradar.updateMapName();
			}
			
			// 显示过场景黑屏
			var uiblack:UIBlack = this.m_gkcontext.m_UIMgr.getForm(UIFormID.UIBlack) as UIBlack;
			if (!uiblack)
			{
				this.m_gkcontext.m_UIMgr.createFormInGame(UIFormID.UIBlack);
			}
			else
			{
				uiblack.show();
			}
		}
		
		protected function pspracticeVipTimeUserCmd(msg:ByteArray):void
		{
			// 只有功能开启才处理
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_VIPPRACTICE))
			{
				this.m_gkcontext.m_vipTY.pspracticeVipTimeUserCmd(msg);
			}
		}
	}
}