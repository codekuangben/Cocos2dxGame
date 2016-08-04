package game.ui.uiTeamFBSys.iteamzx
{
	import com.bit101.components.ButtonRadio;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.CommonImageManager;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.events.MouseEvent;
	
	import modulecommon.net.msg.copyUserCmd.DispatchHero;
	import modulecommon.net.msg.copyUserCmd.UserDispatch;
	import modulecommon.net.msg.questUserCmd.stRequestQuestUserCmd;
	import modulecommon.scene.wu.WuMainProperty;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITeamFBZX;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.iteamzx.WuIconList;
	import game.ui.uiTeamFBSys.iteamzx.ZhenfaPanel;
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragEvent;
	import game.ui.uiTeamFBSys.iteamzx.tip.TipSlave;
	import game.ui.uiTeamFBSys.msg.reqOpenAssginHeroUiCopyUserCmd;
	import game.ui.uiTeamFBSys.msg.retChangeAssginHeroUserCmd;
	import game.ui.uiTeamFBSys.msg.retChangeUserPosUserCmd;
	import game.ui.uiTeamFBSys.msg.retFightHeroDataUserCmd;
	import game.ui.uiTeamFBSys.msg.retOpenAssginHeroUiCopyUserCmd;

	/**
	 * @brief 组队阵型
	 * */
	public class UITeamFBZX extends Form implements IUITeamFBZX
	{
		public var m_TFBSysData:UITFBSysData;
		
		protected var m_radioBtnF:ButtonRadio;		// 第一个单选按钮
		protected var m_lblNameF:Label;			// 名字1
		
		private var m_imageRes:SWFResource;
		public var m_bgPanel:Panel;
		protected var m_exitBtn:PushButton;
		protected var m_btnKaiZhan:PushButton;
		protected var m_btnZX:PushButton;
		
		private var m_wuList:WuIconList;		
		private var m_zhenfa:ZhenfaPanel;
		
		private var m_teamMemLst:TeamMemIconList;
		private var m_tip:TipSlave;

		public function UITeamFBZX()
		{
			this.id = UIFormID.UITeamFBZX;
		}
		
		public static function IMAGESWF():String
		{
			return CommonImageManager.toPathString("module/imageZhenfa.swf");
		}
		
		override public function onReady():void
		{
			m_gkcontext.m_UIs.teamFBZX = this;
			super.onReady();
			m_bCloseOnSwitchMap = false;
			
			this._hitYMax = 100;

			//m_gkcontext.m_context.m_resMgr.load(IMAGESWF(), SWFResource, onImageSwfLoaded, onImageSwfFailed);
			
			m_exitBtn = new PushButton(this);
			m_exitBtn.m_musicType = PushButton.BNMClose;
			m_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			
			this.setSize(996, 616);
			m_exitBtn.setPos(this.width - 29, 64);
			
			m_bgPanel = new Panel(null);
			this.addBackgroundChild(m_bgPanel);
			m_bgPanel.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.dwbz");

			m_radioBtnF = new ButtonRadio(this, 120, 110, onBtnClkF);
			m_radioBtnF.setPanelImageSkin("commoncontrol/button/bb_buttoncheck.swf");
			m_lblNameF = new Label(this, 150, 110, "显示出手顺序", UtilColor.WHITE_Yellow);
			
			m_wuList = new WuIconList(this, m_TFBSysData);
			m_wuList.setPos(26, 140);
			
			m_teamMemLst = new TeamMemIconList(m_TFBSysData, this, 102, 270);
			
			m_btnKaiZhan = new ButtonText(this, 800, 500, "", onBtnClickKaiZhan);
			m_btnKaiZhan.setSkinButton1ImageBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.kaizhan");
			
			m_btnZX = new ButtonText(this, 700, 500, "上次出阵", onBtnClickZX);
			m_btnZX.setSize(90, 40);
			m_btnZX.setGrid9ImageSkin("commoncontrol/button/button2.swf");
			
			// 更新一下数据，默认不显示
			m_radioBtnF.selected = false;
			m_TFBSysData.m_showOrder = false;
			psretFightHeroDataUserCmd(m_TFBSysData.m_heroData);
			
			m_gkcontext.m_context.m_resMgr.load(IMAGESWF(), SWFResource, onImageSwfLoaded, onImageSwfFailed);
		}
		
		override public function onShow():void
		{
			super.onShow();
			//m_wuList.onUIZhenfaShow();
			
			if (m_zhenfa)
			{
				m_zhenfa.atachTickMgr();
			}
			
			//var cmd:reqOpenAssginHeroUiCopyUserCmd = new reqOpenAssginHeroUiCopyUserCmd();
			//m_TFBSysData.m_gkcontext.sendMsg(cmd);
		}
		
		override public function onHide():void
		{
			if (m_zhenfa)
			{
				m_zhenfa.unAttachTickMgr();
			}
		}
		
		override public function exit():void
		{
			// 保存数据
			m_TFBSysData.saveSelfLastWu();
			m_TFBSysData.m_onUIClose(this.id);
			super.exit();
		}
		
		//override public function dispose():void
		//{
			//if (m_tip != null)
			//{
			//	m_tip.dispose();
			//	m_tip = null;
			//}
			
			//m_gkcontext.m_context.m_uiObjMgr.releaseAllObjectByPartialName("uiTeamFBZX");
			
			//if(m_wuList)
			//{
			//	m_wuList.removeEventListener(TeamDragEvent.DRAG_WU, m_zhenfa.onDragWu);
			//	m_wuList.removeEventListener(TeamDragEvent.DROP_WU, m_zhenfa.onDropWu);
			//}
			
		//	super.dispose();
		//}
		
		override public function onDestroy():void 
		{
			m_gkcontext.m_UIs.teamFBZX = null;
			super.onDestroy();
		}
		
		private function createImage(res:SWFResource):void
		{
			var comMGr:CommonImageManager = m_gkcontext.m_context.m_commonImageMgr;
			m_wuList.initData(res);	
			
			m_zhenfa = new ZhenfaPanel(m_TFBSysData, m_bgPanel, 268, 279);			
			m_zhenfa.createImage(res);
			
			m_wuList.addEventListener(TeamDragEvent.DRAG_WU, m_zhenfa.onDragWu);
			m_wuList.addEventListener(TeamDragEvent.DROP_WU, m_zhenfa.onDropWu);
			//show();
			
			// m_zhenfa  创建后再请求资源，必然请求数据
			//if(!m_TFBSysData.m_breqZXData)
			//{
				var cmd:reqOpenAssginHeroUiCopyUserCmd = new reqOpenAssginHeroUiCopyUserCmd();
				m_TFBSysData.m_gkcontext.sendMsg(cmd);
				
				m_TFBSysData.m_breqZXData = true;
			//}
			//else
			//{
			//	psretOpenAssginHeroUiCopyUserCmd(null);
			//}
			
			// 显示武将激活
			psretFightHeroDataUserCmd(null);
			updateNpc();
		}
		
		public function onLoadAllWuPropty():void
		{
			if (m_imageRes != null && m_gkcontext.m_zhenfaMgr.dataLoaded)
			{
				createImage(m_imageRes);
				m_gkcontext.m_context.m_resMgr.unload(IMAGESWF(), SWFResource);
				m_imageRes = null;
			}
		}
		public function onLoadZhenfaData():void
		{
			if (m_imageRes != null && m_gkcontext.m_wuMgr.loaded)
			{
				createImage(m_imageRes);
				m_gkcontext.m_context.m_resMgr.unload(IMAGESWF(), SWFResource);
				m_imageRes = null;
			}
		}
		private function onImageSwfLoaded(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			if (m_gkcontext.m_wuMgr.loaded == true && m_gkcontext.m_zhenfaMgr.dataLoaded)
			{
				createImage(resource);
				m_gkcontext.m_context.m_resMgr.unload(IMAGESWF(), SWFResource);
			}
			else
			{
				m_imageRes = resource;
			}
		}
		
		public function buildList():void
		{
			m_wuList.generate();
		}
		
		public function addWu(heroID:uint):void
		{
			m_wuList.generate();
		}
		
		public function setWuPos(gridNO:int):void
		{
			m_zhenfa.setWuPos(gridNO);
		}
		
		public function clearWuByPos(gridNO:int):void
		{
			m_zhenfa.clearWuByPos(gridNO);			
		}
		
		public function openGrid(gridNo:int):void
		{
			m_zhenfa.openGrid(gridNo);
		}
		
		public function updateAllWuZhanli():void
		{
			var wu:WuMainProperty = this.m_gkcontext.m_wuMgr.getMainWu();
			if(wu == null)
			{
				return;
			}
		}
		
		public function get zhenfa():Component //ZhenfaPanel
		{
			if (m_zhenfa)
			{
				return m_zhenfa;
			}
			else
			{
				return null;
			}
		}
		
		public function psretChangeAssginHeroUserCmd(cmd:retChangeAssginHeroUserCmd):void
		{
			// 有时候宕机，判断一下，可能 createImage 这个函数还没有执行，判断一下
			if (!m_zhenfa)
			{
				return;
			}
			var gridno:uint = 0;
			gridno = m_zhenfa.conv2to1(cmd.pos, cmd.dh.ds >> 1);
			// 删除
			if(cmd.type == 2)
			{
				m_zhenfa.clearWuByPos(gridno);
			}
			else
			{
				m_zhenfa.setWuPos(gridno);
				gridno = m_zhenfa.conv2to1(cmd.pos, cmd.srcpos);
				if(1 == cmd.type)
				{
					var itemUD:UserDispatch;
					var itemDH:DispatchHero;
					itemUD = m_TFBSysData.ud[cmd.pos];
					itemDH = itemUD.dh[cmd.srcpos];
					if(itemDH)	// 如果这个有人就更新
					{
						m_zhenfa.setWuPos(gridno);
					}
					else	// 清理原来已经有的
					{
						m_zhenfa.clearWuByPos(gridno);
					}
				}
			}
		}
		
		public function psretChangeUserPosUserCmd(msg:retChangeUserPosUserCmd):void
		{
			m_teamMemLst.psretChangeUserPosUserCmd(msg);
			m_zhenfa.updateGridGray();
			m_zhenfa.psretChangeUserPosUserCmd(msg);
			m_zhenfa.toggleFlagAni();
		}
		
		public function psretOpenAssginHeroUiCopyUserCmd(msg:retOpenAssginHeroUiCopyUserCmd):void
		{
			// 队员的武将显示 
			if (m_zhenfa)
			{
				m_zhenfa.psretOpenAssginHeroUiCopyUserCmd(msg);
			}
			// 队员显示
			if (m_teamMemLst)
			{
				m_teamMemLst.psretOpenAssginHeroUiCopyUserCmd(msg);
			}
			if (m_zhenfa)
			{
				m_zhenfa.toggleFlagAni();
			}
		}
		
		protected function onBtnClickKaiZhan(e:MouseEvent):void
		{
			if(m_TFBSysData.getAllWJCnt() < 6)
			{
				UtilHtml.beginCompose();
				UtilHtml.add("您的出战成员不足六人，您确定要开战吗? ", UtilColor.WHITE_Yellow, 14);
				m_TFBSysData.m_gkcontext.m_confirmDlgMgr.showMode1(m_TFBSysData.m_form.id, UtilHtml.getComposedContent(), ConfirmFn, null, "开战", " 离开");
			}
			else
			{
				var send:stRequestQuestUserCmd = new stRequestQuestUserCmd();
				send.id = m_TFBSysData.m_questID;
				send.target = m_TFBSysData.m_strEventID;
				send.offset = m_TFBSysData.m_embranchmentId;
				m_TFBSysData.m_gkcontext.sendMsg(send);
				
				exit();		// 关闭界面，因为开战后布阵数据可能会变，如果赢了，服务器会保存这次布阵，如果输了，布阵数据全部清理，因此需要关闭打开的时候需要重新请求
			}
		}
		
		protected function onBtnClickZX(e:MouseEvent):void
		{
			m_TFBSysData.resetLastWu();
		}
		
		private function ConfirmFn():Boolean
		{
			var send:stRequestQuestUserCmd = new stRequestQuestUserCmd();
			send.id = m_TFBSysData.m_questID;
			send.target = m_TFBSysData.m_strEventID;
			send.offset = m_TFBSysData.m_embranchmentId;
			m_TFBSysData.m_gkcontext.sendMsg(send);
			
			exit();	// 关闭界面，因为开战后布阵数据可能会变，如果赢了，服务器会保存这次布阵，如果输了，布阵数据全部清理，因此需要关闭打开的时候需要重新请求
			return true;
		}
		
		public function updateNpc():void
		{
			if (m_zhenfa)
			{
				m_zhenfa.updateNpc();
			}
		}
		
		private function onBtnClkF(event:MouseEvent):void
		{
			m_TFBSysData.m_showOrder = m_radioBtnF.selected;
			if(m_TFBSysData.m_showOrder)
			{
				//m_zhenfa.updateOrder();
				psretFightHeroDataUserCmd(null);
			}
			else
			{
				m_zhenfa.clearOrder();
			}
		}
		
		public function get tip():Object
		{
			if (m_tip == null)
			{
				m_tip = new TipSlave(m_TFBSysData);
			}
			return m_tip;
		}
		
		public function psretFightHeroDataUserCmd(msg:retFightHeroDataUserCmd):void
		{
			// 激活必然更新
			if(m_TFBSysData.m_showOrder)
			{
				m_TFBSysData.sortZXWJ();
				if (m_zhenfa)
				{
					m_zhenfa.updateOrder();
				}
			}
			
			if(m_zhenfa)
			{
				m_zhenfa.updateActived();
				m_zhenfa.toggleFlagAni();
			}
		}
		
		public function clearOrder():void
		{
			m_zhenfa.clearOrder();
		}
		
		public function pstakeOffTeamMemberUserCmd():void
		{
			psretOpenAssginHeroUiCopyUserCmd(null);
		}
		
		public function psnotifyTeamMemberLeaderChangeUserCmd():void
		{
			if (m_teamMemLst)
			{
				m_teamMemLst.psretOpenAssginHeroUiCopyUserCmd(null);
			}
		}
		
		public function psstNotifyTeamMemberListUserCmd():void
		{
			m_teamMemLst.psretOpenAssginHeroUiCopyUserCmd(null);
		}
	}
}