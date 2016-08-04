package game.ui.uiZhenfa 
{
	import com.bit101.components.controlList.CtrolComponent;
	import modulecommon.net.msg.sceneHeroCmd.stSetHeroXiaYeCmd;
	import modulecommon.ui.UIFormID;
	import game.ui.uiZhenfa.xiayewulist.XiayeWuList;
	//import com.bit101.components.Panel;
	import com.dnd.DraggingImage;
	import com.dnd.DragListener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import modulecommon.appcontrol.WuIcon;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneHeroCmd.stSetHeroPositionCmd;
	import ui.player.PlayerResMgr;
	//import modulecommon.scene.beings.NpcBattleBaseMgr;
	//import modulecommon.scene.fight.ZhenfaMgr;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import com.dnd.DragManager;
	import flash.display.DisplayObject;
	import common.event.DragAndDropEvent;
	import flash.geom.Point;
	//import com.bit101.components.Component;
	//import org.ffilmation.engine.datatypes.fPoint3d;
	import com.pblabs.engine.debug.Logger;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import game.ui.uiZhenfa.event.DragWuEvent;
	import modulecommon.net.msg.sceneHeroCmd.stTakeDownFromMatrixCmd;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class WuIconItem extends CtrolComponent implements DragListener, DraggingImage
	{
		private var m_wuIcon:WuIcon;		
		private var m_gkContext:GkContext;
		private var m_wu:WuProperty;	
		private var m_uiZhenfa:UIZhenfa;
		
		public function WuIconItem(param:Object) 
		{
			m_gkContext = param["gk"] as GkContext;
			m_uiZhenfa = param["uizhenfa"] as UIZhenfa;
			m_wuIcon = new WuIcon(m_gkContext, this);	
			m_wuIcon.showZhenwei = true;
			
			
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
			m_wuIcon.setIconNameByWu(m_wu as WuHeroProperty);			
			
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
			
			if (m_gkContext.m_newHandMgr.isVisible() 
				&& (SysNewFeatures.NFT_ZHENFA == m_gkContext.m_sysnewfeatures.m_nft || SysNewFeatures.NFT_FHLIMIT4 == m_gkContext.m_sysnewfeatures.m_nft))
			{
				m_gkContext.m_newHandMgr.promptOver();
				if (m_uiZhenfa.zhenfa)
				{
					m_uiZhenfa.zhenfa.showNewHand();
				}
			}
			
			DragManager.startDrag(this, null, this, this, true);		
			this.dispatchEvent(new DragWuEvent(DragWuEvent.DRAG_WU, m_wu));
			
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
				var pt:Point = this.localToScreen(new Point(this.width, 0));
				if (m_gkContext.m_uiTip)
				{
					m_gkContext.m_uiTip.hintWu(pt, m_wu.m_uHeroID);
				}
			
		}	
		public function getDisplayEx(bAccept:Boolean):Bitmap
		{
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
				return null;
			}			
			
			var bitmap:Bitmap = m_gkContext.m_context.m_dragResPool.getBitmap();
			var bitmapData:BitmapData = m_gkContext.m_context.m_dragResPool.getBitmapData(sordata.width+20, sordata.height+20);
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
		
		public function onReadyDrop (e:DragAndDropEvent): void
		{
			if (true == (e.getTargetComponent() is XiayeWuList))
			{
				var icon:WuIconItem = e.getDragInitiator() as WuIconItem;
				var wu:WuProperty = icon.wu;
				var str:String;
				
				if (wu.chuzhan)
				{
					str="出战武将下野后，将会下阵, 装备自动脱下到包裹中，请问您要继续吗？"
				}
				else
				{					
					if (m_gkContext.m_objMgr.hasEquipForWus(wu.m_uHeroID))
					{
						str="武将下野后，装备自动脱下到包裹中，请问您要继续吗？"
					}
				}
				if (str == null)
				{
					sendXiaye(wu.m_uHeroID);
					return;
				}
				
				m_gkContext.m_confirmDlgMgr.tempData = wu.m_uHeroID;
				m_gkContext.m_confirmDlgMgr.showMode1(UIFormID.UIZhenfa, str, onConfirmFnWuXiaye, onConcelWuXiaye);					
				DragManager.drop();
				return;
			}
			else if (e.getTargetComponent() is ZhenfaGridEV == false)
			{
				if (m_wu.isMain || m_wu.antiChuzhan)
				{
					if (!m_gkContext.m_newHandMgr.isVisible())
					{
						DragManager.drop();
					}
					return;
				}
				
				UtilHtml.beginCompose();
				UtilHtml.add("您是否确认将武将 ", UtilColor.WHITE_Yellow, 14);
				UtilHtml.add(m_wu.fullName, UtilColor.GREEN, 14);
				UtilHtml.add(" 下阵，您的队伍战力将会降低。  如果确认，那么撤掉该武将。", UtilColor.WHITE_Yellow, 14);
				m_gkContext.m_confirmDlgMgr.showMode1(m_uiZhenfa.id, UtilHtml.getComposedContent(), ConfirmFn, null, "确认", "取消");
				DragManager.drop();
				return;
			}
			
			var grid:zhenfaGrid = (e.getTargetComponent() as ZhenfaGridEV).grid;
			if (m_wu.isMain || (m_wu as WuHeroProperty).m_npcBase.m_iZhenwei == grid.zhenwei)
			{
				var send:stSetHeroPositionCmd = new stSetHeroPositionCmd();
				send.heroid = m_wu.m_uHeroID;
				send.pos = grid.gridNO;
				m_gkContext.sendMsg(send);
				
				Logger.info(null, null, "send - " + "将" + m_wu.m_name + "(" +send.heroid +")"+ "移到格子" + "(" + grid.gridNO + ")");
			}			
		}
		
		private function ConfirmFn():Boolean
		{
			var sendTakeDown:stTakeDownFromMatrixCmd = new stTakeDownFromMatrixCmd();
			sendTakeDown.heroid = m_wu.m_uHeroID;
			m_gkContext.sendMsg(sendTakeDown);
			
			m_gkContext.m_zhenfaMgr.m_bShowTip = true;
			return true;
		}
		
		private function sendXiaye(id:uint):void
		{
			var send:stSetHeroXiaYeCmd = new stSetHeroXiaYeCmd();
			send.toXiaye = true;
			send.heroid = id;
			m_gkContext.sendMsg(send);
		}
		
		private function onConfirmFnWuXiaye():Boolean
		{
			var heroID:uint = m_gkContext.m_confirmDlgMgr.tempData as uint;
			
			var hasEquip:Boolean = m_gkContext.m_objMgr.hasEquipForWus(heroID);
			var hasEnougthFreeGrids:Boolean;
			if (hasEquip)
			{
				hasEnougthFreeGrids = m_gkContext.m_objMgr.hasEnoughGridForWus([heroID]);
				if (hasEnougthFreeGrids == false)
				{
					m_gkContext.m_systemPrompt.prompt("您的包裹空间不足，先清理包裹哦!");
					return false;
				}
			}
			
			if (m_gkContext.m_objMgr.hasEquipForWus(heroID))
			{
				m_gkContext.m_objMgr.moveWuEquipsToCommonPackage([heroID]);
			}
			sendXiaye(m_gkContext.m_confirmDlgMgr.tempData as uint);
			return true;
		}
		
		private function onConcelWuXiaye():Boolean
		{
			DragManager.drop();
			return true;
		}
		
		public function onDragDrop (e:DragAndDropEvent) : void
		{
			this.dispatchEvent(new DragWuEvent(DragWuEvent.DROP_WU, wu));
		}

		public function onDragEnter (e:DragAndDropEvent) : void{}

		public function onDragExit (e:DragAndDropEvent) : void{}

		public function onDragOverring (e:DragAndDropEvent) : void{}

		public function onDragStart (e:DragAndDropEvent) : void{}

		
	}

}