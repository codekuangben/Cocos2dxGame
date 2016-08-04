package game.ui.uiTeamFBSys.iteamzx 
{
	import com.bit101.components.Component;
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.display.DisplayObjectContainer;
	
	import modulecommon.GkContext;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.copyUserCmd.DispatchHero;
	import modulecommon.net.msg.copyUserCmd.UserDispatch;
	import modulecommon.scene.beings.NpcVisit;
	import modulecommon.scene.beings.PlayerMain;
	import modulecommon.scene.fight.ZhenfaMgr;
	import modulecommon.uiinterface.IUITeamFBZX;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	import game.ui.uiTeamFBSys.iteamzx.EnemyGrid;
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragData;
	import game.ui.uiTeamFBSys.iteamzx.event.TeamDragEvent;
	import game.ui.uiTeamFBSys.msg.retChangeUserPosUserCmd;
	import game.ui.uiTeamFBSys.msg.retOpenAssginHeroUiCopyUserCmd;

	/**
	 * ...
	 * @author zouzhiqiang
	 * 代表阵法中的一个格子，负责显示具体内容
	 */
	public class ZhenfaPanel extends Component 
	{
		private var m_vecPanel:Vector.<zhenfaGrid>;
		private var m_vecPanelEV:Vector.<ZhenfaGridEV>;
		private var m_gkContext:GkContext;
		private var m_uiZhenfa:IUITeamFBZX;
		private var m_enemyGrid:EnemyGrid;
		protected var m_TFBSysData:UITFBSysData;
		
		public function ZhenfaPanel(data:UITFBSysData, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_TFBSysData = data;
			m_uiZhenfa = m_TFBSysData.m_form as IUITeamFBZX;
			m_gkContext = m_TFBSysData.m_gkcontext;
			m_vecPanel = new Vector.<zhenfaGrid>(9);
			var grid:zhenfaGrid;

			var iColum:int = 2;
			var iRow:int = 0;
			//var left:int = 300;
			//var top:int;
			var intervalH:int = 90 + 15;
			var intervalV:int = 90 + 10;
			var k:int = 0;
			var vecPos:Vector.<uint> = new Vector.<uint>(18);
			{
				vecPos[0] = 223;	vecPos[1] = 0;		// 前顶
				vecPos[2] = 223;	vecPos[3] = 104;	// 前中
				vecPos[4] = 223;	vecPos[5] = 208;	// 前下
				
				vecPos[6] = 112;	vecPos[7] = 0;		// 中顶
				vecPos[8] = 112;	vecPos[9] = 104;	// 中中
				vecPos[10] = 112;	vecPos[11] = 208;	// 中下
				
				vecPos[12] = 0;	vecPos[13] = 0;		// 后顶
				vecPos[14] = 0;	vecPos[15] = 104;	// 后中
				vecPos[16] = 0;	vecPos[17] = 208;	// 后下
			}
			for (; iColum >= 0; iColum--)
			{
				//top = 100;
				for (iRow = 0; iRow < 3; iRow++)
				{
					m_vecPanel[k] = new zhenfaGrid(m_TFBSysData, this, vecPos[2*k], vecPos[2*k+1], m_gkContext, 3 - iColum, k);
					m_vecPanel[k].addEventListener(TeamDragEvent.DROP_WU, onDropWu);
					k++;
					//top += intervalV;
				}
				//left -= intervalH;
			}
			
			m_vecPanel[0].serverGridNO = 2;
			m_vecPanel[1].serverGridNO = 2;
			m_vecPanel[2].serverGridNO = 2;
			
			m_vecPanel[3].serverGridNO = 1;
			m_vecPanel[4].serverGridNO = 1;
			m_vecPanel[5].serverGridNO = 1;
			
			m_vecPanel[6].serverGridNO = 0;
			m_vecPanel[7].serverGridNO = 0;
			m_vecPanel[8].serverGridNO = 0;
			
			m_vecPanel[0].serverRowNO = 0;
			m_vecPanel[1].serverRowNO = 1;
			m_vecPanel[2].serverRowNO = 2;
			
			m_vecPanel[3].serverRowNO = 0;
			m_vecPanel[4].serverRowNO = 1;
			m_vecPanel[5].serverRowNO = 2;
			
			m_vecPanel[6].serverRowNO = 0;
			m_vecPanel[7].serverRowNO = 1;
			m_vecPanel[8].serverRowNO = 2;
			
			m_vecPanelEV = new Vector.<ZhenfaGridEV>(9);
			for (k = 0; k < 9 ; k++)
			{
				m_vecPanelEV[k] = new ZhenfaGridEV(m_gkContext, this, m_vecPanel[k].x, m_vecPanel[k].y, m_vecPanel[k]);	
				m_vecPanelEV[k].addEventListener(TeamDragEvent.DRAG_WU, onDragWu);
			}
			initData();
			updateGridGray();
			
			m_enemyGrid = new EnemyGrid(this, 510, 40, m_TFBSysData);
			
			toggleFlagAni();
		}
		
		override public function dispose():void
		{
			var k:int = 0;
			var iColum:int = 2;
			var iRow:int = 0;
			for (; iColum >= 0; iColum--)
			{
				for (iRow = 0; iRow < 3; iRow++)
				{
					if(m_vecPanel[k])
					{
						m_vecPanel[k].removeEventListener(TeamDragEvent.DROP_WU, onDropWu);
					}
					k++;
				}
			}
			
			for (k = 0; k < 9 ; k++)
			{
				if(m_vecPanelEV[k])
				{
					m_vecPanelEV[k].removeEventListener(TeamDragEvent.DRAG_WU, onDragWu);
				}
			}
			super.dispose();
		}

		public function unAttachTickMgr():void
		{
			for (var i:int; i < m_vecPanel.length; i++)
			{
				m_vecPanel[i].unAttachTickMgr();
			}
		}

		public function atachTickMgr():void
		{
			for (var i:int; i < m_vecPanel.length; i++)
			{
				m_vecPanel[i].atachTickMgr();
			}
		}

		public function initData():void
		{			
			var gridID:uint = ZhenfaMgr.ZHENFAGRID_NO1;
			var heroID:uint;
			for (; gridID <= ZhenfaMgr.ZHENFAGRID_NO9; gridID++)
			{
				heroID = m_gkContext.m_teamFBSys.getGrids(gridID);
				if (heroID)
				{
					setWuPos(gridID);
				}
			}
		}
		
		public function openGrid(gridNo:int):void
		{
			m_vecPanel[gridNo].updateLock();
		}
		
		public function setWuPos(gridNO:int):void
		{
			m_vecPanel[gridNO].setHero();
			
			// 是否需要显示出手顺序
			//if(m_TFBSysData.m_showOrder)
			//{
			//	m_vecPanel[gridNO].updateOrder();
			//}
		}

		public function clearWuByPos(gridNO:int):void
		{
			m_vecPanel[gridNO].clearHero();
		}

		public function onDragWu(e:TeamDragEvent):void
		{
			var dragdata:TeamDragData = e.data as TeamDragData;
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].onDragWu(dragdata);
			}
		}

		public function onDropWu(e:TeamDragEvent):void
		{
			var dragdata:TeamDragData = e.data as TeamDragData;
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].onDropWu(dragdata);
			}
			
			if (m_gkContext.m_newHandMgr.isVisible() && m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_ZHENFA)
			{
				m_gkContext.m_sysnewfeatures.m_nft = SysNewFeatures.NFT_NONE;
				//m_gkContext.m_newHandMgr.promptOver();
				//m_uiZhenfa.newHandMoveToExitBtn();
				m_gkContext.m_newHandMgr.hide();
				m_vecPanelEV[1].grid.toHightLight(false);
			}
		}

		public function createImage(res:SWFResource):void
		{
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].createImage(res);
			}
		}

		public function showNewHand():void
		{
			if (m_gkContext.m_newHandMgr.isVisible())
			{
				if (m_gkContext.m_sysnewfeatures.m_nft == SysNewFeatures.NFT_ZHENFA)
				{
					m_gkContext.m_newHandMgr.setFocusFrame(-12, -14, 92, 72, 1);
					m_gkContext.m_newHandMgr.prompt(false, 70, 48, "左键点击放入这里。", m_vecPanelEV[1]);//前中位置
					m_vecPanelEV[1].grid.toHightLight(true);
				}
			}
		}
		
		public function conv2to1(row:uint, col:uint):uint
		{
			var grid:uint = 0;
			switch(row)
			{
				case 0:
				{
					switch(col)
					{
						case 0:
						{
							grid = 6;
							break;
						}
						case 1:
						{
							grid = 3;
							break;
						}
						case 2:
						{
							grid = 0;
							break;
						}
					}
					break;
				}
				case 1:
				{
					switch(col)
					{
						case 0:
						{
							grid = 7;
							break;
						}
						case 1:
						{
							grid = 4;
							break;
						}
						case 2:
						{
							grid = 1;
							break;
						}
					}
					break;
				}
				case 2:
				{
					switch(col)
					{
						case 0:
						{
							grid = 8;
							break;
						}
						case 1:
						{
							grid = 5;
							break;
						}
						case 2:
						{
							grid = 2;
							break;
						}
					}
					break;
				}
			}
			
			return grid;
		}
		
		// 显示所有武将
		public function psretOpenAssginHeroUiCopyUserCmd(msg:retOpenAssginHeroUiCopyUserCmd):void
		{
			var item:UserDispatch;
			var idx:int;
			var col:int = 0;
			var colData:DispatchHero;
			var gridno:uint = 0;
			
			while(idx < 3)
			{
				if (m_TFBSysData.ud && idx < m_TFBSysData.ud.length)
				{
					item = m_TFBSysData.ud[idx];
					if(item)
					{
						col = 0;
						gridno = 0;
						while(col < 3)
						{
							if (item.dh && col < item.dh.length)
							{
								colData = item.dh[col];
								if(colData)
								{
									gridno = conv2to1(item.pos, colData.ds >> 1);
									setWuPos(gridno);
								}
								else
								{
									gridno = conv2to1(idx, col);
									clearWuByPos(gridno);
								}
							}
							
							++col;
						}
					}
					else
					{
						col = 0;
						gridno = 0;
						while(col < 3)
						{
							gridno = conv2to1(idx, col);
							clearWuByPos(gridno);
							
							++col;
						}
					}
				}
				
				++idx;
			}
			
			updateGridGray();
		}
		
		// 初始化格子是否是灰色的
		public function updateGridGray():void
		{
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].updateGridGray();
			}
		}
		
		// 队长调整阵型后调整武将的显示
		public function psretChangeUserPosUserCmd(msg:retChangeUserPosUserCmd):void
		{
			// 更新 数据
			var row:int = 0;
			var col:int = 0;
			var rowidx:int = 0;
			var gridno:uint = 0;
			var itemUD:UserDispatch;
			var itemDH:DispatchHero;
			var findwj:Boolean;
			var lst:Vector.<int> = new Vector.<int>();
			lst.push(msg.src);
			lst.push(msg.pos);
			
			while(rowidx < 2)
			{
				row = lst[rowidx];
				col = 0;
				
				while(col < 3)
				{
					findwj = false;
					
					itemUD = m_TFBSysData.ud[row];
					if(itemUD)
					{
						itemDH = itemUD.dh[col];
						if(itemDH)
						{
							findwj = true;
						}
					}
					
					gridno = conv2to1(row, col);
					if(findwj)
					{
						setWuPos(gridno);
					}
					else
					{
						clearWuByPos(gridno);
					}
					++col;
				}
				
				++rowidx;
			}
		}
		
		public function setBossNpcID(npcID:uint):void
		{
			m_enemyGrid.setNpcID(npcID);
		}
		
		public function updateNpc():void
		{
			var hero:PlayerMain = m_TFBSysData.m_gkcontext.m_playerManager.hero;
			var npc:NpcVisit = hero.getClkNpc();
			if (npc)
			{
				setBossNpcID(npc.npcBase.m_uID);
			}
		}
		
		public function updateActived():void
		{
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].updateActived();
			}
		}
		
		public function updateOrder():void
		{
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].updateOrder();
			}
		}
		
		public function clearOrder():void
		{
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].clearOrder();
			}
		}
		
		// 切换主角自己的位置指示符的动画
		public function toggleFlagAni():void
		{
			// 首先隐藏所有的
			var k:int = 0;
			for (k = 0; k < m_vecPanel.length; k++)
			{
				m_vecPanel[k].pnlFlag.visible = false;
				m_vecPanel[k].gridEV.lblDesc.visible = false;
			}
			
			var row:int = 0;
			var col:int = 0;
			var gridno:uint = 0;
			while(row < 3)
			{
				// 检查自己所在的行是否有武将
				col = 0;
				if(m_TFBSysData.m_selfRow == row)
				{
					while(col < 3)
					{
						if(m_TFBSysData.getDispatchHeroByNo(row, col))
						{
							break;
						}
						++col;
					}
					
					if(col == 3)	// 说明没有拖出武将
					{
						col = 0;
						while(col < 3)
						{
							gridno = conv2to1(row, col);
							m_vecPanel[gridno].pnlFlag.visible = true;
							
							++col;
						}
					}
				}
				else
				{
					if(m_TFBSysData.getUserDispatchByNo(row))	// 如果存在队员
					{
						while(col < 3)
						{
							if(m_TFBSysData.getDispatchHeroByNo(row, col))
							{
								break;
							}
							++col;
						}
						
						if(col == 3)	// 说明没有拖出武将
						{
							col = 0;
							while(col < 3)
							{
								gridno = conv2to1(row, col);
								m_vecPanel[gridno].gridEV.lblDesc.visible = true;
								
								++col;
							}
						}
					}
				}
				
				++row;
			}
		}
	}
}