package game.ui.uiTeamFBSys.iteamzx
{
	//import com.bit101.components.Label;
	//import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import com.dnd.DragListener;
	import com.dnd.DragManager;
	import com.dnd.DraggingImage;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.SWFResource;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import common.event.DragAndDropEvent;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.copyUserCmd.DispatchHero;
	import modulecommon.net.msg.copyUserCmd.UserDispatch;
	import modulecommon.net.msg.teamUserCmd.TeamUser;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiObject.UIMBeing;
	import modulecommon.uiinterface.IUITeamFBZX;
	
	import org.ffilmation.engine.helpers.fUtil;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragData;
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragEvent;
	import game.ui.uiTeamFBSys.iteamzx.tip.TipSlave;
	import game.ui.uiTeamFBSys.msg.HeroData;
	import game.ui.uiTeamFBSys.msg.reqChangeAssginHeroUserCmd;

	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class zhenfaGrid extends PanelContainer implements DragListener, DraggingImage
	{
		public static const WIDTH:int = 90;
		public static const HEIGHT:int = 90;
		
		public static var BEINGTYPE_Player:int = 0; //玩家
		public static var BEINGTYPE_Wu:int = 1; //玩家的武将

		private var m_gkContext:GkContext;
		private var m_wuBeing:UIMBeing;
		private var m_gridNO:int;
		private var m_zhenwei:int;
		private var m_parent:Panel;
		private var m_gridEV:ZhenfaGridEV;
		private var m_bGray:Boolean;	//true - 当前处于灰色状态
		private var m_lockPanel:Panel;		
		private var m_hightLightPanel:Panel;
		public var m_uizhenfa:IUITeamFBZX;
		
		public var m_serverRowNO:uint;	// 服务器的行编号
		public var m_serverGridNO:uint;	// 服务器的格子号(就是一行中的格子编号),就是列编号
		
		public var m_TFBSysData:UITFBSysData;
		public var m_pnlFlag:Panel;		// 一把小旗帜，第一个人放上去就全去掉
		//public var m_lblDesc:Label;		// 描述
			
		public function zhenfaGrid(data:UITFBSysData, parent:DisplayObjectContainer, xPos:int, yPos:int, gk:GkContext, zhenwei:int, gridNO:int)
		{
			super(parent, xPos, yPos);
			this.setSize(WIDTH, HEIGHT);
			m_TFBSysData = data;
			m_gkContext = m_TFBSysData.m_gkcontext;
			m_uizhenfa = m_TFBSysData.m_gkcontext.m_UIMgr.getForm(UIFormID.UITeamFBZX) as IUITeamFBZX;
			
			m_zhenwei = zhenwei;
			m_gridNO = gridNO;			
			
			this.setSize(64, 40);
			m_hightLightPanel = new Panel(this, -3, -4);
			m_hightLightPanel.setSize(70, 48);		
			m_hightLightPanel.visible = false;
			m_parent = new Panel(this);
			
			m_pnlFlag = new Panel(this, 0, -60);
			m_pnlFlag.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsyszx.ani");
			m_pnlFlag.visible = false;
			
			//m_lblDesc = new Label(this, -20, -20, "", UtilColor.GREEN);
			//m_lblDesc.text = "等待队友拖入武将";
			//m_lblDesc.visible = false;
			
			//addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		public function clearHero():void
		{			
			if (m_wuBeing)
			{
				//m_wuBeing.offawayContainerParent();
				m_gkContext.m_context.m_uiObjMgr.releaseUIObject(m_wuBeing);
				m_wuBeing = null;
			}
			m_gridEV.invalidate();
		}
		
		// 直接取数据
		public function setHero():void
		{
			if (!m_TFBSysData.checkDataCorrect(m_serverRowNO, m_serverGridNO))
			{
				var extrainfo:String = "m_serverRowNO=" + m_serverRowNO + ", m_serverGridNO=" + m_serverGridNO + " \n ";
				m_TFBSysData.logInfo(extrainfo);
				return;
			}
			
			var modelName:String = "";
			modelName = getModelName();

			if (m_wuBeing != null)
			{
				//m_wuBeing.offawayContainerParent();
				m_gkContext.m_context.m_uiObjMgr.releaseUIObject(m_wuBeing);
			}
			m_wuBeing = m_gkContext.m_context.m_uiObjMgr.createUIObject(fUtil.elementID(m_gkContext.m_context, EntityCValue.TUIObject), modelName, UIMBeing) as UIMBeing;
			m_wuBeing.changeContainerParent(m_gridEV);
			m_wuBeing.moveTo(this.width / 2, this.height / 2, 0);
			
			// 显示武将出手循序和激活数量
			m_wuBeing.showOrderActive = true;
			// 设置武将的名字
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			var itemTU:TeamUser;
			
			var herodata:HeroData;
			var npcBase:TNpcBattleItem;
			
			itemUD = m_TFBSysData.ud[m_serverRowNO];
			itemDH = itemUD.dh[m_serverGridNO];
			
			var isMain:Boolean;
			var idorcharid:uint;	// 如果是武将就是武将 id，如果是主角就是 charid
			isMain = !!(itemDH.ds & 0x1);
			idorcharid = itemDH.id;
			
			if(isMain)
			{
				itemTU = m_TFBSysData.getUserInfo(itemUD.charid);
				m_wuBeing.name = itemTU.name;
			}
			else
			{
				npcBase = m_TFBSysData.m_gkcontext.m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, idorcharid/10) as TNpcBattleItem;
				if(npcBase)
				{
					m_wuBeing.name = npcBase.m_name;
				}
			}
			
			m_gridEV.invalidate();
			
			// 更新一下头顶的名字的颜色
			updateActived();
		}
		
		// 是否是主角，可能是自己的主角，也可能是队友的主角
		public function isMain():Boolean
		{
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			var isMain:Boolean = false;
			
			if (!m_TFBSysData.ud || m_serverRowNO >= m_TFBSysData.ud.length)
			{
				return isMain;
			}
			
			if (!m_TFBSysData.checkDataCorrect(m_serverRowNO, m_serverGridNO))
			{
				var extrainfo:String = "m_serverRowNO=" + m_serverRowNO + ", m_serverGridNO=" + m_serverGridNO + " \n ";
				m_TFBSysData.logInfo(extrainfo);
				return isMain;
			}

			itemUD = m_TFBSysData.ud[m_serverRowNO];
			itemDH = itemUD.dh[m_serverGridNO];
			isMain = !!(itemDH.ds & 0x1);
			
			if (!itemUD.dh || m_serverGridNO >= itemUD.dh.length)
			{
				return isMain;
			}
			
			return isMain;
		}
		
		public function isSelfMain():Boolean
		{
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			var isMain:Boolean = false;
			
			if (!m_TFBSysData.checkDataCorrect(m_serverRowNO, m_serverGridNO))
			{
				var extrainfo:String = "m_serverRowNO=" + m_serverRowNO + ", m_serverGridNO=" + m_serverGridNO + " \n ";
				m_TFBSysData.logInfo(extrainfo);
				return isMain;
			}
			
			itemUD = m_TFBSysData.ud[m_serverRowNO];
			itemDH = itemUD.dh[m_serverGridNO];
			isMain = !!(itemDH.ds & 0x1);
			
			if(isMain)
			{
				if(!m_TFBSysData.isSelfRow(m_serverRowNO))
				{
					isMain = false;
				}
			}
			
			return isMain;
		}
		
		public function getModelName():String
		{	
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			var itemTU:TeamUser;
			var modelName:String = "c2_c111";
			
			if (!m_TFBSysData.checkDataCorrect(m_serverRowNO, m_serverGridNO))
			{
				var extrainfo:String = "m_serverRowNO=" + m_serverRowNO + ", m_serverGridNO=" + m_serverGridNO + " \n ";
				m_TFBSysData.logInfo(extrainfo);
				return modelName;
			}
			
			if (!m_TFBSysData.ud || m_serverRowNO >= m_TFBSysData.ud.length)
			{
				return modelName;
			}
			
			itemUD = m_TFBSysData.ud[m_serverRowNO];
			if (!itemUD || !itemUD.dh || m_serverGridNO >= itemUD.dh.length)
			{
				return modelName;
			}
			
			itemDH = itemUD.dh[m_serverGridNO];
			
			if (!itemDH)
			{
				return modelName;
			}
			
			var isMain:Boolean;
			var idorcharid:uint;	// 如果是武将就是武将 id，如果是主角就是 charid
			isMain = !!(itemDH.ds & 0x1);
			idorcharid = itemDH.id;
			var npcBase:TNpcBattleItem;
			//var modelName:String = "";

			if (isMain)
			{	
				itemTU = m_TFBSysData.getUserInfo(itemUD.charid);
				if(itemTU)
				{
					modelName = m_TFBSysData.m_gkcontext.m_context.m_playerResMgr.modelName(itemTU.job, itemTU.sex);
				}
			}
			else
			{
				npcBase = m_gkContext.m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, idorcharid/10) as TNpcBattleItem;
				if(npcBase)
				{
					modelName = npcBase.npcBattleModel.m_strModel;
				}
			}
			
			return modelName;
		}
		
		// 获取当前武将完全的名字
		public function fullName():String
		{
			var name:String = "";
			
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			var itemTU:TeamUser;
			
			if (!m_TFBSysData.checkDataCorrect(m_serverRowNO, m_serverGridNO))
			{
				var extrainfo:String = "m_serverRowNO=" + m_serverRowNO + ", m_serverGridNO=" + m_serverGridNO + " \n ";
				m_TFBSysData.logInfo(extrainfo);
				return name;
			}
			
			if (!m_TFBSysData.ud || m_serverRowNO >= m_TFBSysData.ud.length)
			{
				return name;
			}
			itemUD = m_TFBSysData.ud[m_serverRowNO];
			
			if (!itemUD || !itemUD.dh || m_serverGridNO >= itemUD.dh.length)
			{
				return name;
			}
			itemDH = itemUD.dh[m_serverGridNO];
			
			if (!itemDH)
			{
				return name;
			}
			
			var isMain:Boolean;
			var idorcharid:uint;	// 如果是武将就是武将 id，如果是主角就是 charid
			isMain = !!(itemDH.ds & 0x1);
			idorcharid = itemDH.id;
			var npcBase:TNpcBattleItem;
			
			if(isMain)
			{
				itemTU = m_TFBSysData.getUserInfo(itemUD.charid);
				if (itemTU)
				{
					name = itemTU.name;
				}
			}
			else
			{
				npcBase = m_gkContext.m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, idorcharid/10) as TNpcBattleItem;
				if(npcBase)
				{
					name = npcBase.m_name;
				}
			}
			
			return name;
		}
		
		public function get wu():DispatchHero
		{
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			
			// 调用太频繁了,这个地方不加了
			//if (!m_TFBSysData.checkDataCorrect(m_serverRowNO, m_serverGridNO))
			//{
			//	m_TFBSysData.logInfo();
			//	return itemDH;
			//}
			
			if(m_TFBSysData.ud)
			{
				itemUD = m_TFBSysData.ud[m_serverRowNO];
				if(itemUD)
				{
					itemDH = itemUD.dh[m_serverGridNO];
				}
			}
		
			return itemDH;
		}
		
		// 获取 m_npcBase 表项
		public function npcBase():TNpcBattleItem
		{
			var name:String = "";
			
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			var itemTU:TeamUser;
			
			if (!m_TFBSysData.checkDataCorrect(m_serverRowNO, m_serverGridNO))
			{
				var extrainfo:String = "m_serverRowNO=" + m_serverRowNO + ", m_serverGridNO=" + m_serverGridNO + " \n ";
				m_TFBSysData.logInfo(extrainfo);
				return npcBase;
			}
			
			itemUD = m_TFBSysData.ud[m_serverRowNO];
			itemDH = itemUD.dh[m_serverGridNO];
			
			var isMain:Boolean;
			var idorcharid:uint;	// 如果是武将就是武将 id，如果是主角就是 charid
			isMain = !!(itemDH.ds & 0x1);
			idorcharid = itemDH.id;
			var npcBase:TNpcBattleItem;
			
			if(!isMain)	// 不管是自己的主角还是队友的主角都没有 npc 表,只有武将有 npc 表
			{
				npcBase = m_gkContext.m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, idorcharid/10) as TNpcBattleItem;
			}
			
			return npcBase;
		}
		
		public function colorValue():uint
		{
			return UtilColor.YELLOW;
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
			if (m_gkContext.m_teamFBSys.isGridOpen(m_gridNO))
			{
				if (m_lockPanel != null)
				{
					this.removeChild(m_lockPanel);
					m_lockPanel.dispose();
					m_lockPanel = null;
				}
				m_gridEV.buttonMode = true;
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

		// 注意 wu 现在不是表示武将，而是表示拖放时候的数据，仅包括一部分武将数据
		public function onDragWu(wu:TeamDragData):void
		{
			// 如果是主角或者阵位是应该放的位置
			if (!(wu.isMain() || (wu.m_npcBase.m_iZhenwei == m_zhenwei && m_TFBSysData.isSelfRow(m_serverRowNO))))	// 变成灰色的
			{
				this.becomeGray();
				m_bGray = true;
			}
		}

		public function onDropWu(wu:TeamDragData):void
		{
			if (m_bGray == true && m_TFBSysData.isSelfRow(m_serverRowNO))	// 只有自己一行的变成非灰色
			{
				this.becomeUnGray();
				m_bGray = false;
			}
		}
		
		public function updateGridGray():void
		{
			if(m_TFBSysData.isSelfRow(m_serverRowNO))
			{
				this.becomeUnGray();
				m_bGray = false;
			}
			else
			{
				this.becomeGray();
				m_bGray = true;
			}
		}

		public function switchToRejectImage () : void
		{			
			getDisplayEx(false);
		}
		
		public function getDisplayEx(bAccept:Boolean):Bitmap
		{
			var defbmd:Bitmap = new Bitmap();	// 这个是默认的资源，放置返回空值

			var model:String;
			model = getModelName();
			var origin:Point = new Point();
			var sordata:BitmapData = m_gkContext.m_context.m_uiObjMgr.getStaticFrame(model, 0, 1, origin);
			
			if (sordata == null)
			{
				return defbmd;
			}
			if (m_wuBeing == null)
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
		
		public function get gridEV():ZhenfaGridEV
		{
			return m_gridEV;
		}

		public function get zhenwei():int
		{
			return m_zhenwei;
		}

		public function get gridNO():int
		{
			return m_gridNO;
		}

		public function get isGray():Boolean
		{
			return m_bGray;
		}
		
		//此格子是否已经开放
		public function isOpen():Boolean
		{
			return m_gkContext.m_teamFBSys.isGridOpen(m_gridNO);
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
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;

			if (e.getTargetComponent() is ZhenfaGridEV == false)	// 不是拖放的目的地，阵法格子上
			{
				/*
				if (isSelfMain())	// 主角也可以替换
				{
					DragManager.drop();
					return;
				}
				*/
				// 非主角需要提示是否下阵
				UtilHtml.beginCompose();
				UtilHtml.add("您是否确认将武将 ", UtilColor.WHITE_Yellow, 14);
				UtilHtml.add(fullName(), UtilColor.GREEN, 14);
				UtilHtml.add(" 下阵，您的队伍战力将会降低。  如果确认，那么撤掉该武将。", UtilColor.WHITE_Yellow, 14);
				m_gkContext.m_confirmDlgMgr.showMode1(m_uizhenfa.id, UtilHtml.getComposedContent(), ConfirmFn, null, "确认", "取消");
				DragManager.drop();
				return;
			}
			else	// 拖放在阵法格子上
			{
				// 拖放目标
				var grid:zhenfaGrid = (e.getTargetComponent() as ZhenfaGridEV).grid;
				//if(m_TFBSysData.isSelfRow(m_serverRowNO))		// 如果可以拖放
				if(m_TFBSysData.isSelfRow(grid.m_serverRowNO))		// 如果可以拖放
				{
					if (grid==this)	// 如果是拖放的目标就是自己的位置
					{
						DragManager.drop();
						return;
					}
					if (isSelfMain() || npcBase().m_iZhenwei == grid.zhenwei)
					{
						//var send:stSetHeroPositionCmd = new stSetHeroPositionCmd();
						//send.heroid = m_wu.m_uHeroID;
						//send.pos = grid.gridNO;
						//m_gkContext.sendMsg(send);
						if(isSelfMain() && (m_TFBSysData.getDispatchHeroByNo(grid.m_serverRowNO, grid.m_serverGridNO)))	// 如果拖动的是主角，并且拖动的目标位置有武将
						{
							m_gkContext.m_systemPrompt.prompt("该阵位已经有武将，该武将不能交换到主角的位置");
						}
						else
						{
							// 添加\移动
							var send:reqChangeAssginHeroUserCmd = new reqChangeAssginHeroUserCmd();
							if(e.getDragInitiator() as WuIconItem)	// 从武将列表拖放的,说明是添加
							{
								send.type = 0;
							}
							else
							{
								send.type = 1;
							}
							if(isMain())
							{
								send.dh.ds = 1 | (grid.serverGridNO << 1);
							}
							else
							{
								send.dh.ds = 0 | (grid.serverGridNO << 1);
							}

							itemUD = m_TFBSysData.ud[m_serverRowNO];
							itemDH = itemUD.dh[m_serverGridNO];
		
							send.dh.id = itemDH.id;
							m_gkContext.sendMsg(send);
						}
						
						// 释放拖放
						DragManager.drop();
					}
					else
					{
						var arr:Array = ["前", "中", "后"];
						m_gkContext.m_systemPrompt.prompt("该阵位只能放置" + arr[grid.zhenwei - 1] + "军");
					}
				}
				else	// 拖放到别人的格子上去
				{
					DragManager.drop();
					m_gkContext.m_systemPrompt.prompt("不能摆放在别人的位置上");	
				}
			}
		}
		
		private function ConfirmFn():Boolean
		{
			//var sendTakeDown:stTakeDownFromMatrixCmd = new stTakeDownFromMatrixCmd();
			//sendTakeDown.heroid = m_wu.m_uHeroID;
			//m_gkContext.sendMsg(sendTakeDown);
			// 删除
			var sendTakeDown:reqChangeAssginHeroUserCmd = new reqChangeAssginHeroUserCmd();
			sendTakeDown.type = 2;
			if(isMain())
			{
				sendTakeDown.dh.ds = 1 | (serverGridNO << 1);
			}
			else
			{
				sendTakeDown.dh.ds = 0 | (serverGridNO << 1);
			}
			
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			itemUD = m_TFBSysData.ud[m_serverRowNO];
			itemDH = itemUD.dh[m_serverGridNO];
			
			sendTakeDown.dh.id = itemDH.id;
			m_gkContext.sendMsg(sendTakeDown);

			m_gkContext.m_teamFBSys.bShowTip = true;
			return true;
		}
		
		public function onDragDrop (e:DragAndDropEvent) : void
		{
			// 注意这个地方传进去的是  null ，因此不要用这个值，整个流程好像并没有使用这个值
			var data:TeamDragData = new TeamDragData();
			data.m_isMain = isMain();
			data.m_npcBase = npcBase();
			
			this.dispatchEvent(new TeamDragEvent(TeamDragEvent.DROP_WU, null));
		}

		public function onDragEnter (e:DragAndDropEvent) : void{}

		public function onDragExit (e:DragAndDropEvent) : void{}

		public function onDragOverring (e:DragAndDropEvent) : void{}

		public function onDragStart (e:DragAndDropEvent) : void{}
		
		public function set serverGridNO(value:uint):void
		{
			m_serverGridNO = value;
		}
		
		public function get serverGridNO():uint
		{
			return m_serverGridNO;
		}
		
		public function set serverRowNO(value:uint):void
		{
			m_serverRowNO = value;
		}
		
		public function get serverRowNO():uint
		{
			return m_serverRowNO;
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			m_hightLightPanel.visible = true;
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			if (m_wuBeing)
			{
				var pt:Point = this.localToScreen(new Point(-60, -220));
				
				var tip:TipSlave = m_uizhenfa.tip as TipSlave;
				tip.showTip(m_serverRowNO, m_serverGridNO);
				m_gkContext.m_uiTip.hintComponent(pt, tip);				
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			m_hightLightPanel.visible = false;
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			if (m_wuBeing)
			{
				m_gkContext.m_uiTip.hideTip();
			}
		}
		
		// 激活必然显示
		public function updateActived():void
		{
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			
			var isMain:Boolean;		// 是否是主角自己
			var idorcharid:uint;	// 如果是武将就是武将 id，如果是主角就是 charid
			var npcBase:TNpcBattleItem;
			
			if(m_wuBeing)
			{
				if(m_TFBSysData.ud)
				{
					itemUD = m_TFBSysData.ud[m_serverRowNO];
					if(itemUD)
					{
						itemDH = itemUD.dh[m_serverGridNO];
						
						if(itemDH)
						{
							var item:HeroData = m_TFBSysData.getHeroData(itemUD.charid, itemDH.id);
							if(item)
							{
								//m_wuBeing.wjActived = item.active;
								// 绿，蓝，紫武将的颜色鬼，仙，神武将
								isMain = !!(itemDH.ds & 0x1);
								idorcharid = itemDH.id;
								
								if(isMain)
								{
									m_wuBeing.setColorAndTypeName(getTypeName(BEINGTYPE_Player, idorcharid), getNameColor(BEINGTYPE_Player, null));
								}
								else
								{
									npcBase = m_TFBSysData.m_gkcontext.m_dataTable.getItem(DataTable.TABLE_NPCBATTLE, idorcharid/10) as TNpcBattleItem;
									if(npcBase)
									{
										m_wuBeing.setColorAndTypeName(getTypeName(BEINGTYPE_Wu, idorcharid), getNameColor(BEINGTYPE_Wu, npcBase));
									}
								}
							}
						}
					}
				}
			}
		}
		
		// 获取绿，蓝，紫武将的颜色以及鬼，仙，神武将,格式例如(绿色鬼武将)
		// type: 指定是 player 还是 wu。
		public function getTypeName(type:uint, tempid:uint):String
		{
			var ret:String;
			if (type == BEINGTYPE_Player)
			{
				ret = "";
			}
			else if (type == BEINGTYPE_Wu)
			{
				ret = WuHeroProperty.s_wuPrefix(tempid % 10);
			}
			else
			{
				ret = "";
			}
			return ret;
		}

		public function getNameColor(type:uint, npcBase:TNpcBattleItem):uint
		{
			if (type == BEINGTYPE_Wu)
			{
				return NpcBattleBaseMgr.colorValue(npcBase.m_uColor);
			}
			else
			{
				return UtilColor.WHITE;
			}
		}
		
		public function getNameColorStr(type:uint, npcBase:TNpcBattleItem):String
		{
			var ret:String = "";
			if (type == BEINGTYPE_Wu)
			{
				switch(npcBase.m_uColor)
				{
					case WuProperty.COLOR_WHITE:	ret = "白";	break;
					case WuProperty.COLOR_GREEN:	ret = "绿";	break;
					case WuProperty.COLOR_BLUE:	ret = "蓝";	break;
					case WuProperty.COLOR_PURPLE:	ret = "紫";	break;
					case WuProperty.COLOR_GOLD:	ret = "金";	break;
				}
			}
			else
			{
				return "白";
			}
			
			return ret;
		}
		
		public function updateOrder():void
		{
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			if(m_wuBeing)
			{
				if(m_TFBSysData.ud)
				{
					itemUD = m_TFBSysData.ud[m_serverRowNO];
					if(itemUD)
					{
						itemDH = itemUD.dh[m_serverGridNO];
				
						if(itemDH)
						{
							var item:HeroData = m_TFBSysData.getHeroData(itemUD.charid, itemDH.id);
							if(item)
							{
								//m_wuBeing.setBubble(item.m_sortID + "");
								m_wuBeing.order = item.m_sortID;
							}
						}
					}
				}
			}
		}
		
		public function clearOrder():void
		{
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			if(m_wuBeing)
			{
				if(m_TFBSysData.ud)
				{
					itemUD = m_TFBSysData.ud[m_serverRowNO];
					if(itemUD)
					{
						itemDH = itemUD.dh[m_serverGridNO];
						
						if(itemDH)
						{
							var item:HeroData = m_TFBSysData.getHeroData(itemUD.charid, itemDH.id);
							if(item)
							{
								m_wuBeing.order = -1;	// -1 表示不显示出手顺序
							}
						}
					}
				}
			}
		}
		
		public function get pnlFlag():Panel
		{
			return m_pnlFlag;
		}
		
		//public function get lblDesc():Label
		//{
		//	return m_lblDesc;
		//}
	}
}