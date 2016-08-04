package game.ui.uiZhenfa
{
	//import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import flash.display.DisplayObjectContainer;
	//import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.wu.WuHeroProperty;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	//import org.ffilmation.engine.datatypes.fPoint3d;
	import game.ui.uiZhenfa.event.DragWuEvent;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneHeroCmd.stSetHeroPositionCmd;
	import modulecommon.net.msg.sceneHeroCmd.stTakeDownFromMatrixCmd;
	//import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.uiObject.UIMBeing;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import com.dnd.DraggingImage;
	//import com.bit101.components.Component;
	import com.dnd.DragListener;
	import common.event.DragAndDropEvent;
	import com.dnd.DragManager;	
	import com.pblabs.engine.debug.Logger;
	//import ui.player.PlayerResMgr;
	import com.pblabs.engine.resource.SWFResource;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class zhenfaGrid extends PanelContainer implements DragListener, DraggingImage
	{
		public static const WIDTH:int = 90;
		public static const HEIGHT:int = 90;
				
		private var m_gkContext:GkContext;
		private var m_wuBeing:UIMBeing;
		private var m_gridNO:int;
		private var m_zhenwei:int;
		private var m_parent:Panel;
		private var m_wu:WuProperty;
		private var m_gridEV:ZhenfaGridEV;
		private var m_bGray:Boolean;	//true - 当前处于灰色状态
		private var m_lockPanel:Panel;		
		private var m_hightLightPanel:Panel;
		private var m_uizhenfa:UIZhenfa;
		private var m_wuAniPanel:WuAniPanel;
			
		public function zhenfaGrid(ui:UIZhenfa, parent:DisplayObjectContainer, xPos:int, yPos:int, gk:GkContext, zhenwei:int, gridNO:int)
		{
			super(parent, xPos, yPos);
			this.setSize(WIDTH, HEIGHT);
			m_gkContext = gk;
			m_uizhenfa = ui;
			
			m_zhenwei = zhenwei;
			m_gridNO = gridNO;			
			
			this.setSize(64, 40);
			m_hightLightPanel = new Panel(this, -3, -4);
			m_hightLightPanel.setSize(70, 48);		
			m_hightLightPanel.visible = false;
			m_parent = new Panel(this);			
		}
		
		public function clearHero():void
		{			
			m_wu = null;
			if (m_wuBeing)
			{				
				m_wuBeing.offawayContainerParent();
				m_wuBeing = null;
				
				if (m_wuAniPanel)
				{
					m_wuAniPanel.clearWu();
				}
			}
			m_gridEV.invalidate();
		}
		
		public function setHero(id:uint):void
		{			
			m_wu = m_gkContext.m_wuMgr.getWuByHeroID(id);
			if (m_wu == null)
			{
				return;
			}
			var modelName:String;
			if (m_wu.isMain)
			{
				modelName = (m_gkContext.m_playerManager.hero as PlayerMain).modelName();
			}
			else
			{
				modelName = (m_wu as WuHeroProperty).m_npcBase.npcBattleModel.m_strModel;
			}
			if (m_wuBeing != null)
			{
				m_wuBeing.offawayContainerParent();
			}
			m_wuBeing = m_gkContext.m_context.m_uiObjMgr.createUIObject(m_wu.m_uHeroID.toString(), modelName, UIMBeing) as UIMBeing;
			m_wuAniPanel.setWu(m_wu, m_wuBeing);
			m_wuBeing.moveTo(this.width / 2, this.height / 2, 0);
			m_gridEV.invalidate();
		}
		public function toHightLight(bFlag:Boolean):void
		{
			m_hightLightPanel.visible = bFlag;
		}
		
		public function getDisplay () : DisplayObject
		{
			return getDisplayEx(true);			
		}
		
		public function updateLock(res:SWFResource=null):void
		{
			if (m_gkContext.m_zhenfaMgr.isGridOpen(m_gridNO))
			{
				if (m_lockPanel != null)
				{
					this.removeChild(m_lockPanel);
					m_lockPanel.dispose();
					m_lockPanel = null;
				}
				m_gridEV.buttonMode = true;
				
				if (m_wuAniPanel == null)
				{
					m_wuAniPanel = new WuAniPanel(m_gkContext, this);
				}
			}
			else
			{
				if (m_lockPanel==null)
				{
					m_lockPanel = new Panel(this);
					m_lockPanel.setPanelImageSkinBySWF(res, "zhenfa.lock");
				}
			}
		}
		public function switchToAcceptImage () : void
		{		
			getDisplayEx(true);
		}

		public function onDragWu(wu:WuProperty):void
		{
			if (!(wu.isMain || (wu as WuHeroProperty).m_npcBase.m_iZhenwei == m_zhenwei))
			{
				this.becomeGray();
				m_bGray = true;
			}
			
		}
		public function onDropWu(wu:WuProperty):void
		{
			if (m_bGray == true)
			{
				this.becomeUnGray();
				m_bGray = false;
			}
			
		}
		
		public function switchToRejectImage () : void
		{			
			getDisplayEx(false);
		}
		
		public function getDisplayEx(bAccept:Boolean):Bitmap
		{
			var model:String;
			if (m_wu.isMain)
			{
				//model = m_gkContext.m_context.m_playerResMgr.modelName(1, PlayerResMgr.GENDER_male);
				model = m_gkContext.m_playerManager.hero.modelName();
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
			if (m_wuBeing == null)
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
				
				if (destPoint.x + 20 > bitmapData.width)
				{
					destPoint.x = bitmapData.width - 20;
				}
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
		public function set gridEV(ev:ZhenfaGridEV):void
		{
			m_gridEV = ev;
		}
		public function get zhenwei():int
		{
			return m_zhenwei;
		}
		public function get gridNO():int
		{
			return m_gridNO;
		}
		public function get wu():WuProperty
		{
			return m_wu;
		}
		public function get isGray():Boolean
		{
			return m_bGray;
		}
		
		//此格子是否已经开放
		public function isOpen():Boolean
		{
			return m_gkContext.m_zhenfaMgr.isGridOpen(m_gridNO);
		}
		public function unAttachTickMgr():void
		{
			if (m_wuBeing)
			{
				m_gkContext.m_context.m_uiObjMgr.unAttachFromTickMgr(m_wuBeing);
			}
		}
		
		public function atachTickMgr():void
		{
			if (m_wuBeing)
			{
				m_gkContext.m_context.m_uiObjMgr.attachToTickMgr(m_wuBeing);
			}
		}
		
		public function createImage(res:SWFResource):void
		{
			var bgName:String;
			var hlName:String;
			switch(m_zhenwei)
			{
				case 1:
					{
						bgName = "gridFront";
						hlName = "gridFronHL";
						break;
					}
				case 2:
					{
						bgName = "gridMiddle";
						hlName = "gridMiddleHL";
						break;
					}
				case 3:
					{
						bgName = "gridBack";
						hlName = "gridBackHL";
						break;
					}
			}
			this.setPanelImageSkinBySWF(res, "zhenfa." + bgName);
			updateLock(res);
			m_hightLightPanel.setPanelImageSkinBySWF(res, "zhenfa." + hlName);
		}
		public function onReadyDrop (e:DragAndDropEvent) : void
		{		
			if (e.getTargetComponent() is ZhenfaGridEV == false)
			{
				if (m_wu.isMain)
				{
					DragManager.drop();
					return;
				}
				UtilHtml.beginCompose();
				UtilHtml.add("您是否确认将武将 ", UtilColor.WHITE_Yellow, 14);
				UtilHtml.add(m_wu.fullName, UtilColor.GREEN, 14);
				UtilHtml.add(" 下阵，您的队伍战力将会降低。  如果确认，那么撤掉该武将。", UtilColor.WHITE_Yellow, 14);
				m_gkContext.m_confirmDlgMgr.showMode1(m_uizhenfa.id, UtilHtml.getComposedContent(), ConfirmFn, null, "确认", "取消");
				DragManager.drop();
				return;
			}
			
			
			var grid:zhenfaGrid = (e.getTargetComponent() as ZhenfaGridEV).grid;
			if (grid==this)
			{
				DragManager.drop();
				return;
			}
			if (m_wu.isMain || (m_wu as WuHeroProperty).m_npcBase.m_iZhenwei == grid.zhenwei)
			{
				var send:stSetHeroPositionCmd = new stSetHeroPositionCmd();
				send.heroid = m_wu.m_uHeroID;
				send.pos = grid.gridNO;
				m_gkContext.sendMsg(send);
				Logger.info(null, null, "send - " + "将" + m_wu.m_name + "(" +send.heroid +")"+ "移到格子" + "(" + grid.gridNO + ")");
			}
			else
			{
				var arr:Array = ["前", "中", "后"];
				m_gkContext.m_systemPrompt.prompt("该阵位只能放置" + arr[grid.zhenwei - 1] + "军");
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