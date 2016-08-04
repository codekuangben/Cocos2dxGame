package game.ui.uiRadar
{
	import com.bit101.components.ButtonImageText;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import game.ui.uiRadar.SubBtn.SystemBtn;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.radar.RadarMgr;
	import game.ui.uiRadar.SubBtn.BtnBase;
	import game.ui.uiRadar.SubBtn.FightBtn;
	import game.ui.uiRadar.SubBtn.FriendBtn;
	import game.ui.uiRadar.SubBtn.MailBtn;
	import game.ui.uiRadar.SubBtn.RanksBtn;
	import game.ui.uiRadar.SubBtn.TalkBtn;
	
	import modulecommon.ui.Form;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import modulecommon.uiinterface.IUIRadar;
	import com.dgrigg.image.CommonImageManager;
	import com.pblabs.engine.entity.EntityCValue;
	
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	
	public class UIRadar extends Form implements IUIRadar
	{
		private var m_btnRadar:ButtonImageText;
		private var m_labelMapname:Label;		
		private var m_vecBtn:Vector.<BtnBase>;
		private var m_vecPos:Vector.<int>;
		private var m_config:Dictionary;
		private var m_curResSwf:SWFResource;
		private var m_gmBtn:ButtonText;
		
		public function UIRadar():void
		{
			m_config = new Dictionary();
		}
		
		public static function IMAGESWF():String
		{
			return CommonImageManager.toPathString("module/imageuiradar.swf");
		}
		
		override public function onReady():void
		{
			super.onReady();
			this.setSize(230, 86);
			this.alignHorizontal = Component.RIGHT;
			this.alignVertial = Component.TOP;
			this.adjustPosWithAlign();
			this.m_gkcontext.m_UIs.radar = this;
			this.draggable = false;
			
			m_labelMapname = new Label(this, 40, 5);
			m_btnRadar = new ButtonImageText(this, 156, 14, onBtnClick);
			m_btnRadar.imageText.recycleSkins = true;
			
			if (!m_gkcontext.m_context.m_config.m_versionForOutNet)
			{
				m_gmBtn = new ButtonText(this, -60, 0,"Gm面板", onGmBtnClick);
				m_gmBtn.setPanelImageSkin("commoncontrol/button/button5_mirror.swf");
			}
			
			m_vecBtn = new Vector.<BtnBase>(RadarMgr.RADARBTN_Count);
			m_config[RadarMgr.RADARBTN_Mail] = [MailBtn, "mailBtn"];
			m_config[RadarMgr.RADARBTN_Fight] = [FightBtn, "fightBtn"];
			m_config[RadarMgr.RADARBTN_Talk] = [TalkBtn, "talkBtn"];
			m_config[RadarMgr.RADARBTN_System] = [SystemBtn, "systemBtn"];
			
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_FRIENDSYS))
			{
				m_config[RadarMgr.RADARBTN_Friend] = [FriendBtn, "friendBtn"];
			}
			if (m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_RANK))
			{
				m_config[RadarMgr.RADARBTN_Ranks] = [RanksBtn, "ranksBtn"];
			}
			
			m_vecPos = new Vector.<int>(RadarMgr.RADARBTN_Count * 2);
			m_vecPos[0] = 194;	m_vecPos[1] = 77;
			m_vecPos[2] = 159;	m_vecPos[3] = 81;
			m_vecPos[4] = 128;	m_vecPos[5] = 63;
			m_vecPos[6] = 116;	m_vecPos[7] = 30;
			m_vecPos[8] = 83;	m_vecPos[9] = 30;
			m_vecPos[10] = 50;	m_vecPos[11] = 30;
			
			m_gkcontext.m_context.m_resMgr.load(UIRadar.IMAGESWF(), SWFResource, onImageSwfLoaded, onImageSwfFailed);
			updateMapName();
			updateBtnRadar();
			
		}
		private function onGmBtnClick(e:MouseEvent):void
		{
			m_gkcontext.m_UIMgr.loadForm(UIFormID.UIGmPlayerAttributes);
		}
		
		private function onImageSwfLoaded(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			createImage(resource);
			m_gkcontext.m_context.m_resMgr.unload(UIRadar.IMAGESWF(), SWFResource);
		}
		
		private function createImage(resource:SWFResource):void
		{
			m_curResSwf = resource;
			this.setImageSkinBySWF(resource, "uiRadar.radarbg");
			m_btnRadar.setSize(60, 60);
			m_btnRadar.setPanelImageSkinBySWF(resource, "radarbutton");
			
			updateCreateBtn();
		}
		
		public function updateMapName():void
		{
			m_labelMapname.text = this.m_gkcontext.m_mapInfo.mapName;
		}
		
		public function updateBtnRadar():void
		{
			var curMapID:int = this.m_gkcontext.m_mapInfo.curMapID;
			var caption:String;
			if (m_gkcontext.m_mapInfo.m_bInArean)
			{
				caption = "word_leave";
				m_labelMapname.text = "竞技场";
			}
			else if (m_gkcontext.m_mapInfo.m_bInSGQYH)
			{
				caption = "word_leave";
				m_labelMapname.text = "英雄会";
			}
			else if ((1000 <= curMapID) && (2000 >= curMapID)) //主城区地图ID段
			{
				caption = "word_outoftown";
			}
			else
			{
				caption = "word_leave";
			}
			
			m_btnRadar.setImageText("commoncontrol/panel/" + caption + ".png");
			
			//新手地图-常山小道，不显示离开按钮
			if (1001 == m_gkcontext.m_mapInfo.clientMapID)
			{
				m_btnRadar.imageText.visible = false;
				m_btnRadar.mouseEnabled = false;
			}
			else
			{
				m_btnRadar.imageText.visible = true;
				m_btnRadar.mouseEnabled = true;
			}
		}
		
		private function onBtnClick(event:MouseEvent):void
		{
			var curMapID:int = this.m_gkcontext.m_mapInfo.curMapID;
			var nameFileName:String;
			
			if(m_gkcontext.m_mapInfo.m_servermapconfigID == 1001)	// TASK #562 【优化】地图ID1001点击离开，不允许
			{
				m_gkcontext.m_systemPrompt.prompt("此地图不允许离开");
			}
			else if (m_gkcontext.m_mapInfo.m_bInArean)
			{
				if(m_gkcontext.m_arenaMgr.exitArena())
				{
					nameFileName = m_gkcontext.m_context.m_path.getPathByName("x" + this.m_gkcontext.m_mapInfo.clientMapID + ".swf", EntityCValue.PHXMLTINS);
					updateBtnRadar();
					updateMapName();
				}
			}
			else if (m_gkcontext.m_mapInfo.m_bInSGQYH)
			{
				if(m_gkcontext.m_heroRallyMgr.exitHeroRally())
				{
					nameFileName = m_gkcontext.m_context.m_path.getPathByName("x" + this.m_gkcontext.m_mapInfo.clientMapID + ".swf", EntityCValue.PHXMLTINS);
					updateBtnRadar();
					updateMapName();
				}
			}
			else if (m_gkcontext.m_worldBossMgr.m_bInWBoss)
			{
				m_gkcontext.m_worldBossMgr.reqLeaveWorldBoss();
			}
			else if ((1000 <= curMapID) && (2000 >= curMapID)) //主城区地图ID段
			{
				var hero:PlayerMain = this.m_gkcontext.m_playerManager.hero;
				if (hero == null)
				{
					return;
				}
				var pt:Point = this.m_gkcontext.m_mapInfo.getWorldmapPoint();
				hero.moveToNpcVisitByNpcID(pt.x, pt.y, 50);
			}
			else
			{
				m_gkcontext.m_radarMgr.reqLeaveCopy();
			}
		}
		
		private function updateCreateBtn():void
		{
			var i:int;
			for (i = 0; i < RadarMgr.RADARBTN_Count; i++)
			{
				if (m_config[i] && (null == m_vecBtn[i]))
				{
					createBtn(i);
				}
			}
		}
		
		private function createBtn(id:int):BtnBase
		{
			var config:Array = m_config[id];
			var cs:Class;
			var ret:BtnBase;
			
			ret = new (config[0])(this);
			ret.setGKUI(m_gkcontext, this, config[1]);
			m_vecBtn[id] = ret;
			addjustPos();
			
			return ret;
		}
		
		private function addjustPos():void
		{
			var i:int;
			var j:int = 0;
			for (i = 0; i < m_vecBtn.length; i++)
			{
				if (m_vecBtn[i])
				{
					m_vecBtn[i].setPos(m_vecPos[j * 2], m_vecPos[j * 2 + 1]);
					j++;
				}
			}
		}
		
		//增加一个新按钮 type:为SysNewFeatures.as中对应功能定义类型
		public function addNewFeatureBtn(type:uint):void
		{
			var btnid:int = RadarMgr.getBtnId(type);
			
			if (m_gkcontext.m_sysnewfeatures.isSet(type))
			{
				if (SysNewFeatures.NFT_FRIENDSYS == type)
				{
					m_config[btnid] = [FriendBtn, "friendBtn"];
				}
				else if (SysNewFeatures.NFT_RANK == type)
				{
					m_config[btnid] = [RanksBtn, "ranksBtn"];
				}
			}
			
			if (m_config[btnid] && (null == m_vecBtn[btnid]))
			{
				createBtn(btnid);
			}
		}
		
		//获得按钮在屏幕中位置
		public function getBtnPosInRadarByIdx(id:int):Point
		{
			var btn:BtnBase = m_vecBtn[id];
			if (null == btn)
			{
				return null;
			}
			return btn.localToScreen(new Point(0, -32));
		}
		
		public function showEffectAni(btnid:int):void
		{
			if (m_vecBtn[btnid])
			{
				m_vecBtn[btnid].showEffectAni();
			}
		}
		
		public function hideEffectAni(btnid:int):void
		{
			if (m_vecBtn[btnid])
			{
				m_vecBtn[btnid].hideEffectAni();
			}
		}
		
		public function showNewHand():void
		{
			if (m_gkcontext.m_newHandMgr.isVisible() && (SysNewFeatures.NFT_FRIENDSYS == m_gkcontext.m_sysnewfeatures.m_nft))
			{
				if (m_vecBtn[RadarMgr.RADARBTN_Friend])
				{
					m_gkcontext.m_newHandMgr.setFocusFrame(-10, -10, 52, 52, 1);
					m_gkcontext.m_newHandMgr.prompt(true, 0, 40, "点击打开好友界面。", m_vecBtn[RadarMgr.RADARBTN_Friend]);
				}
				else
				{
					m_gkcontext.m_newHandMgr.hide();
				}
			}
		}
		
		override public function dispose():void
		{
			this.m_gkcontext.m_UIs.radar = null;
			
			super.dispose();
		}
	}
}