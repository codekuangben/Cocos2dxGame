package game.ui.uiTeamFBSys.iteamzx 
{
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import com.dnd.DragListener;
	import com.dnd.DragManager;
	import com.dnd.DraggingImage;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import common.event.DragAndDropEvent;
	
	import modulecommon.GkContext;
	//import modulecommon.appcontrol.WuIcon;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.sceneHeroCmd.stTakeDownFromMatrixCmd;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITeamFBZX;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragData;
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragEvent;
	import game.ui.uiTeamFBSys.msg.reqChangeAssginHeroUserCmd;
	import modulecommon.scene.wu.WuMainProperty;

	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class WuIconItem extends CtrolVHeightComponent implements DragListener, DraggingImage
	{
		protected var m_TFBSysData:UITFBSysData;
		private var m_wuIcon:WuIconZX;		
		private var m_gkContext:GkContext;
		private var m_wu:WuProperty;	
		private var m_uiZhenfa:IUITeamFBZX;
		
		public function WuIconItem(param:Object) 
		{
			m_TFBSysData = param["data"] as UITFBSysData;
			m_gkContext = m_TFBSysData.m_gkcontext;
			m_uiZhenfa = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBZX) as IUITeamFBZX;
			m_wuIcon = new WuIconZX(m_gkContext, this);	
			//m_wuIcon.showZhenwei = true;

			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);		
			this.buttonMode = true;
			//this.setDropTrigger(true);
		}
		
		override public function dispose():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			super.dispose();
		}
		
		public override function setData(data:Object):void
		{
			super.setData(data);
			m_wu = m_data as WuProperty;
			var iconRes:String;
			if(!m_wu.isMain)	// 非主角
			{
				m_wuIcon.setIconNameByWu(m_wu as WuHeroProperty);
			}
			else
			{
				// 主角一定在阵上，不能脱下来，因此不用这个
				m_wuIcon.setIconNameByMainWu(m_wu as WuMainProperty, m_TFBSysData.m_gkcontext.m_context.m_playerResMgr);
			}
			
			this.setSize(WuProperty.SQUAREHEAD_WIDHT, WuProperty.SQUAREHEAD_HEIGHT);
		}
		
		public function get wu():WuProperty
		{
			return m_wu;
		}
		
		public function onMouseDown(e:MouseEvent):void
		{
			if (DragManager.isDragging() == true)
			{
				return;
			}
			
			if (m_gkContext.m_newHandMgr.isVisible() && m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_ZHENFA)
			{
				m_gkContext.m_newHandMgr.promptOver();
				if (m_uiZhenfa.zhenfa)
				{
					(m_uiZhenfa.zhenfa as ZhenfaPanel).showNewHand();
				}
			}
			
			DragManager.startDrag(this, null, this, this, true);
			var wu:TeamDragData = new TeamDragData();
			wu.m_isMain = m_wu.isMain;
			if(!wu.m_isMain)
			{
				wu.m_npcBase = (m_wu as WuHeroProperty).m_npcBase;
			}
			this.dispatchEvent(new TeamDragEvent(TeamDragEvent.DRAG_WU, wu));
			
			// 播放音效
			m_gkContext.m_commonProc.playMsc(10);
		}

		override public function onOut():void
		{		
			if (m_gkContext.m_uiTip)
			{
				m_gkContext.m_uiTip.hideTip();
			}	
		}
		
		override public function onOver():void
		{
			if (m_wu.isMain)
			{
				return;
			}
			var pt:Point = this.localToScreen(new Point(this.width, 0));
			if (m_gkContext.m_uiTip)
			{
				m_gkContext.m_uiTip.hintWu(pt, m_wu.m_uHeroID);
			}
		}
		
		public function getDisplayEx(bAccept:Boolean):Bitmap
		{
			var defbmd:Bitmap = new Bitmap();	// 这个是默认的资源，放置返回空值
			
			var model:String;
			if (m_wu.isMain)
			{
				model = m_gkContext.m_context.m_playerResMgr.modelName(1, PlayerResMgr.GENDER_male);
			}
			else
			{
				model = (m_wu as WuHeroProperty).m_npcBase.npcBattleModel.m_strModel;
			}
			var origin:Point = new Point();
			var sordata:BitmapData = m_gkContext.m_context.m_uiObjMgr.getStaticFrame(model,0, 1, origin);
			if (sordata == null)
			{
				return defbmd;
			}			
			
			var bitmap:Bitmap = m_gkContext.m_context.m_dragResPool.getBitmap();
			var bitmapData:BitmapData = m_gkContext.m_context.m_dragResPool.getBitmapData(sordata.width, sordata.height);
			var srcRect:Rectangle = new Rectangle(0, 0, sordata.width, sordata.height);
			var destPoint:Point = new Point();
			bitmapData.copyPixels(sordata, srcRect, destPoint);
			
			var acPanel:PanelImage;
			if (bAccept)
			{
				acPanel = m_gkContext.m_context.m_commonImageMgr.getImage("zhenfa.accept") as PanelImage;
			}
			else
			{
				acPanel = m_gkContext.m_context.m_commonImageMgr.getImage("zhenfa.refuse") as PanelImage;
			}
			if (acPanel != null && acPanel.loadState == Image.Loaded)
			{
				destPoint.x = -origin.x + 20;
				destPoint.y = -origin.y + 20;
				srcRect.width = acPanel.data.width;
				srcRect.height = acPanel.data.height;
				bitmapData.copyPixels(acPanel.data, srcRect, destPoint);
			}
			bitmap.x = origin.x;
			
			bitmap.y = origin.y;			
			bitmap.bitmapData = bitmapData;
			bitmap.width = bitmapData.width;
			bitmap.height = bitmapData.height;
			return bitmap;
		}
		
		public function getDisplay () : DisplayObject
		{
			return getDisplayEx(true);			
		}

		//public override function isDragAcceptableInitiator(com:Component):Boolean
		//{
		//	return false;
		//}
		
		public function switchToAcceptImage () : void
		{
			getDisplayEx(true);
		}

		public function switchToRejectImage () : void
		{
			getDisplayEx(false);
		}
		
		public function onReadyDrop (e:DragAndDropEvent) : void
		{			
			if (e.getTargetComponent() is ZhenfaGridEV == false)	// 说明拖放的位置不是阵法格子上
			{
			//	if (m_wu.isMain || m_wu.antiChuzhan)	// 主角是不能下阵的
			//	{
			//		if (!m_gkContext.m_newHandMgr.isVisible())
			//		{
			//			
			//		}
			//	}
			//	else
			//	{
			//		// 说明不是主角，给出提示
			//		UtilHtml.beginCompose();
			//		UtilHtml.add("您是否确认将武将 ", UtilColor.WHITE_Yellow, 14);
			//		UtilHtml.add(m_wu.fullName, UtilColor.GREEN, 14);
			//		UtilHtml.add(" 下阵，您的队伍战力将会降低。  如果确认，那么撤掉该武将。", UtilColor.WHITE_Yellow, 14);
			//		m_gkContext.m_confirmDlgMgr.showMode1(m_uiZhenfa.id, UtilHtml.getComposedContent(), ConfirmFn, null, "确认", "取消");
			//	}
			}
			else	// 说明拖动到阵法格子上
			{
				// 说明拖放的是应该放置的位置
				var grid:zhenfaGrid = (e.getTargetComponent() as ZhenfaGridEV).grid;
				// 如果放的不是自己所在的一行
				if(!m_TFBSysData.isSelfRow(grid.m_serverRowNO))
				{
					// 给出提示
					m_gkContext.m_systemPrompt.prompt("不能摆放在别人的位置上");
				}
				else
				{
					// 真正可以拖放的位置
					if (m_wu.isMain || (m_wu as WuHeroProperty).m_npcBase.m_iZhenwei == grid.zhenwei)	// 如果是主角必然可以移动，或者是应该放的位置
					{
						// 检查是不是已经有两个了
						//if(m_TFBSysData.getRowWJCnt(grid.m_serverGridNO) >= 2)
						//{
						//	m_gkContext.m_systemPrompt.prompt("最多只能上阵两个");
						//}
						//else
						//{
							var send:reqChangeAssginHeroUserCmd = new reqChangeAssginHeroUserCmd();
							send.type = 0;
							if(m_wu.isMain)
							{
								send.dh.ds = 1 | grid.m_serverGridNO << 1;
								send.dh.id = m_TFBSysData.m_gkcontext.m_playerManager.hero.charID;
							}
							else
							{
								send.dh.ds = grid.m_serverGridNO << 1;
								send.dh.id = m_wu.m_uHeroID;
							}
							m_gkContext.sendMsg(send);
						//}
					}
					else if((m_wu as WuHeroProperty).m_npcBase.m_iZhenwei != grid.zhenwei)	// 必然不是主武将
					{
						var arr:Array = ["前", "中", "后"];
						m_gkContext.m_systemPrompt.prompt("该阵位只能放置" + arr[grid.zhenwei - 1] + "军");
					}
				}
			}
			
			DragManager.drop();
		}
		
		private function ConfirmFn():Boolean
		{
			//var sendTakeDown:stTakeDownFromMatrixCmd = new stTakeDownFromMatrixCmd();
			//sendTakeDown.heroid = m_wu.m_uHeroID;
			//m_gkContext.sendMsg(sendTakeDown);
			
			m_gkContext.m_teamFBSys.bShowTip = true;
			return true;
		}
		
		public function onDragDrop (e:DragAndDropEvent) : void
		{
			var data:TeamDragData = new TeamDragData();
			data.m_isMain = wu.isMain;
			if(!data.m_isMain)
			{
				data.m_npcBase = (wu as WuHeroProperty).m_npcBase;
			}
			
			this.dispatchEvent(new TeamDragEvent(TeamDragEvent.DROP_WU, data));
		}

		public function onDragEnter (e:DragAndDropEvent) : void{}

		public function onDragExit (e:DragAndDropEvent) : void{}

		public function onDragOverring (e:DragAndDropEvent) : void{}

		public function onDragStart (e:DragAndDropEvent) : void{}		
	}
}