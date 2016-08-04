package modulefight.scene.fight
{
	import com.pblabs.engine.core.IResizeObject;
	import com.pblabs.engine.core.ITickedObject;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.events.Event;
	import modulecommon.commonfuntion.LocalDataMgr;
	import modulecommon.scene.MapInfo;
	import modulefight.scene.roundcontrol.RoundControl;
	import modulefight.ui.uiFightResult.UIFightResult;
	import modulefight.ui.uireplay.UIReplay;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import modulecommon.GkContext;
	import modulecommon.tools.Earthquake;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IForm;
	import modulecommon.uiinterface.IUILog;
	import modulecommon.uiinterface.IUISceneTran;
	import modulecommon.uiinterface.IUITurnCard;
	
	//import modulefight.control.JinNangEmitCtrol;
	import modulefight.digitani.HPDigitMgr;
	import modulefight.netmsg.fight.stAttackResultUserCmd;
	//import modulefight.netmsg.stmsg.BattleArray;
	//import modulefight.netmsg.stmsg.JinNangProcess;
	import modulefight.netmsg.stmsg.stArmy;
	import modulefight.netmsg.stmsg.stMatrixInfo;
	import modulefight.render.BitmapRenderer;
	//import modulefight.scene.battleContrl.BattleControlBase;
	import modulefight.scene.beings.NpcBattleMgr;
	import modulefight.scene.fight.rank.IRankFightAction;
	import modulefight.skillani.SkillAni;
	import modulefight.ui.battlehead.UIBattleHead;
	import modulefight.ui.tip.UIBattleTip;
	
	import org.ffilmation.engine.core.fScene;
	
	//import org.ffilmation.engine.datatypes.IntPoint;
	import modulecommon.commonfuntion.MsgRoute;
	
	/**
	 * ...
	 * @author
	 */
	public class GameFightController implements ITickedObject, IResizeObject
	{
		public var m_fightDB:FightDB;
		public var m_fightLogicCB:FightLogicCB;
		
		public var m_HPDigitMgr:HPDigitMgr;
		/*
		 * 第几回合出现“立即结束”按钮，
		 * 0 - 永远不会出现立即结束按钮.
		 * 1 - 在开始就出现“立即结束”按钮.
		 * >=2 - 表示在第m_roundForShowJieshuBtn回合显示“立即结束”按钮.
		 *
		 * 在attemptBegin函数中设置m_roundForShowJieshuBtn的值.在endRound在利用此值
		 */
		private var m_roundForShowJieshuBtn:int; //
		
		public function GameFightController(context:GkContext)
		{
			m_fightDB = new FightDB(context, this);
			
			m_fightLogicCB = new FightLogicCB(m_fightDB);
			m_fightDB.m_roundCtrol = new RoundControl(m_fightDB, m_fightLogicCB, this, onRoundEnd);
			//m_jnEmitCtrol = new JinNangEmitCtrol(context, m_fightDB, this);
			m_HPDigitMgr = new HPDigitMgr(context.m_context);
		}
		
		public function onTick(deltaTime:Number):void
		{
			// 如果停止播放，就不更新了
			/**/
			if (m_fightDB.m_gkcontext.m_battleMgr.m_stopInfo)
			{
				m_fightDB.m_gkcontext.addLog("GameFightController::onTick - begin, m_bStopPlayer=" + m_fightDB.m_bStopPlayer);
			}
			
			var act:IRankFightAction;
			// 更新战斗 npc,这个放到格子中更新 
			//m_fightDB.m_npcBattleMgr.onTick(deltaTime);
			// 更新战斗格子
			var i:int;
			var j:int;
			var fightGrid:FightGrid;
			for (i = 0; i < 2; i++)
			{
				var gridsWithBudui:Vector.<FightGrid> = m_fightDB.m_fightGridsWithBudui[i];
				for each (fightGrid in gridsWithBudui)
				{
					fightGrid.onTick(deltaTime);
				}
			}
			
			if (m_fightDB.m_gkcontext.m_battleMgr.m_stopInfo)
			{
				var str:String="每个格子状态\n";
				for (i = 0; i < 2; i++)
				{
					gridsWithBudui = m_fightDB.m_fightGridsWithBudui[i];
					for each (fightGrid in gridsWithBudui)
					{
						str += fightGrid.getStateLog()+"\n";
					}
				}
				
				m_fightDB.m_gkcontext.addLog(str);
			}
			if (m_fightDB.m_bStopPlayer)
			{
				return;
			}
			// 绘制运动拖尾，这个更新一定要放在 act.onTick(deltaTime); 前面，否则会有问题
			m_fightDB.m_bitmapRenderer.renderBeing();
			
			for each (act in m_fightDB.m_actionList)
			{
				act.onTick(deltaTime);
			}
			
			m_fightDB.m_roundCtrol.onTick(deltaTime);
			
			// 更新 GI 
			updateGI(deltaTime);
			// 战斗结束
			updateOver(deltaTime);
			// 更新战斗序列
			updateFightSeq(deltaTime);
			if (m_fightDB.m_gkcontext.m_battleMgr.m_stopInfo)
			{
				m_fightDB.m_gkcontext.addLog("GameFightController::onTick - end");
				m_fightDB.m_gkcontext.m_battleMgr.m_stopInfo = false;
			}
		}
		
		// 大小改变的时候需要更改摄像机的位置，因为摄像机总是需要看见最底下
		public function onResize(viewWidth:int, viewHeight:int):void
		{
			// 现在全部居中显示场景，窗口大小改变的时候，尽量将战斗区域显示全其它区域次要
			var scn:fScene = m_fightDB.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT);
			m_fightDB.m_centerXGrid = int(scn.m_scenePixelXOff + scn.m_scenePixelWidth / 2);
			//m_centerYGrid = int(scn.m_scenePixelHeight - 1.5 * m_gridHeight - 20);			// 距离真实地图下面一定距离，上面如果比窗口小，可以不显示上半部分地形
			m_fightDB.m_centerYGrid = int((scn.m_scenePixelHeight - 60) / 2 + 70); // 战斗地图下面添加了额外的 60 像素
			//m_cameraYOff = int(scn.m_scenePixelHeight - 0.5 * viewHeight);		// 相机在距离地图地下半个窗口的位置
			m_fightDB.m_cameraYOff = int((scn.m_scenePixelHeight - 60) / 2); // 相机在距离地图地下半个窗口的位置
			
			// 进一步检查战斗区域是否看不到
			if (viewHeight < m_fightDB.m_gridHeight * 3 + 70)
			{
				m_fightDB.m_cameraYOff += 70;
			}
			
			initCamera();
		}
		
		/**
		 * @brief 进入战斗场景
		 */
		public function enterFightScene():void
		{
			if (m_fightDB.m_inFightScene)
			{
				return;
			}
			m_fightDB.m_inFightScene = true;
			
			// test: 调试使用
			if (m_fightDB.m_gkcontext.m_context.m_config.m_bDebug)
			{
				var uilog:IUILog = m_fightDB.m_gkcontext.m_UIMgr.getForm(UIFormID.UILog) as IUILog;
				if (uilog)
				{
					m_fightDB.m_fightInterval = uilog.fightInterval;
					m_fightDB.m_moveVel = uilog.moveVel;
					m_fightDB.m_effVel = m_fightDB.m_moveVel;
				}
			}
			
			// test: 输出所有的战斗日志   
			//outputAll();
			//m_fightInfo = new FightInfo();
			// 任意指定坐标作为中心点  
			//m_centerXGrid = 20 * m_gkcontext.m_context.m_sceneView.scene.gridSize + m_gkcontext.m_context.m_sceneView.scene.gridSize/2;
			//m_centerYGrid = 20 * m_gkcontext.m_context.m_sceneView.scene.gridSize + m_gkcontext.m_context.m_sceneView.scene.gridSize / 2;
			// 场景不滚屏，就放在中心点   
			//m_centerXGrid = m_gkcontext.m_context.m_config.m_curWidth/2;
			// X 偏移取地形的中点 
			//m_centerXGrid = this.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).widthpx() / 2;
			//m_centerYGrid = 385;
			
			// 现在全部居中显示场景，改了，现在全部战斗格子都放在地图的下面，就地图的下面必然可见，地图的上面不一定能看到，要看窗口的大小，窗口如果比地图小，那么地图下面必然可见上面就不一定了
			//var scn:fScene = this.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT);
			//m_centerXGrid = scn.m_scenePixelXOff + scn.m_scenePixelWidth / 2;
			//m_centerYGrid = m_gkcontext.m_context.m_config.m_curHeight - m_gridHeight - 100;
			//m_cameraYOff = m_gkcontext.m_context.m_config.m_curHeight / 2;
			// 计算位置
			
			m_fightDB.m_offXGrid = m_fightDB.m_gridWidth / 2;
			m_fightDB.m_offYGrid = m_fightDB.m_gridHeight + m_fightDB.m_gridHeight / 2;
			
			m_fightDB.m_actionList = new Vector.<IRankFightAction>();
			
			m_fightDB.m_camera = m_fightDB.m_gkcontext.m_context.m_sceneView.curCamera((EntityCValue.SCFIGHT));
			
			m_fightDB.m_fightGrids = new Vector.<Vector.<FightGrid>>(2, true);
			m_fightDB.m_fightGrids[EntityCValue.RKLeft] = new Vector.<FightGrid>(9, true);
			m_fightDB.m_fightGrids[EntityCValue.RKRight] = new Vector.<FightGrid>(9, true);
			
			//m_curFightList = new Vector.<Vector.<uint>>(2, true);
			//m_curFightList[EntityCValue.RKLeft] = new Vector.<uint>();
			//m_curFightList[EntityCValue.RKRight] = new Vector.<uint>();
			
			// test: 左边测试 6 ，右边测试 8 。
			//m_curFightList[EntityCValue.RKLeft].push(6);
			//m_curFightList[EntityCValue.RKRight].push(8);
			
			initFight();
			
			// 将战斗拖尾
			m_fightDB.m_fightscene = m_fightDB.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT);
			m_fightDB.m_terEntity = m_fightDB.m_gkcontext.m_context.m_terrainManager.terrainEntityByScene(m_fightDB.m_fightscene);
			
			m_fightDB.m_bitmapRenderer = new BitmapRenderer(new Rectangle(0, 0, m_fightDB.m_fightscene.widthpx(), m_fightDB.m_fightscene.heightpx()));
			m_fightDB.m_fightscene.sceneLayer(EntityCValue.SLBlur).addChild(m_fightDB.m_bitmapRenderer);
			m_fightDB.m_bitmapRenderer.x = m_fightDB.m_fightscene.m_scenePixelXOff; // 调整到正确的位置
			
			m_fightDB.m_quake = new Earthquake(m_fightDB.m_camera);
			
			// 这个时候再播放动画吧
			var uiSceneTran:IUISceneTran = m_fightDB.m_gkcontext.m_UIMgr.getForm(UIFormID.UISceneTran) as IUISceneTran;
			if (uiSceneTran)
			{
				// 添加事件监听
				m_fightDB.m_gkcontext.m_msgRoute.m_enterFightDisp.addEventListener(MsgRoute.EtEnterFight, onEnterFightAniEnd);
				uiSceneTran.startPlay();
			}
		}
		
		// IUISceneTran 动画播放结束
		protected function onEnterFightAniEnd(event:Event):void
		{
			attemptBegin();
		}
		
		// 初始化战斗信息  
		public function initFight():void
		{
			// 最高优先级    
			m_fightDB.m_gkcontext.m_context.m_processManager.addTickedObject(this, EntityCValue.PriorityFight);
			// KBEN: 添加到舞台大小改变处理队列中去，销毁的时候需要移除
			m_fightDB.m_gkcontext.m_context.m_processManager.addResizeObject(this, EntityCValue.ResizeFight);
			
			// 窗口位置以及相机设置
			onResize(m_fightDB.m_gkcontext.m_context.m_config.m_curWidth, m_fightDB.m_gkcontext.m_context.m_config.m_curHeight);
			// 相机初始化在大小改变的时候
			//initCamera();
			initGrid();
			
			loadUIBattleHead();
			initArmy();
		}
		
		public function initArmy():void
		{
			var aFirstArmy:stArmy = m_fightDB.m_fightProcess.aArmylist[0];
			var bFirstArmy:stArmy = m_fightDB.m_fightProcess.bArmylist[0];
			
			this.setArmy(EntityCValue.RKLeft, aFirstArmy);
			this.setArmy(EntityCValue.RKRight, bFirstArmy);
			m_fightDB.m_aArmyIndex = 0;
			m_fightDB.m_bArmyIndex = 0;
			
			m_fightDB.m_UIBattleHead.setCurArmy(EntityCValue.RKLeft, aFirstArmy);
			m_fightDB.m_UIBattleHead.setCurArmy(EntityCValue.RKRight, bFirstArmy);
			
			// 更新兵团后续部队的数量
			m_fightDB.m_UIBattleHead.setLeftArmyCnt(EntityCValue.RKLeft, m_fightDB.m_fightProcess.aArmylist.length - 1);
			m_fightDB.m_UIBattleHead.setLeftArmyCnt(EntityCValue.RKRight, m_fightDB.m_fightProcess.bArmylist.length - 1);
		}
		
		protected function disposeFightGrids():void
		{
			var i:int;
			var j:int;
			for (i = 0; i < 2; i++)
			{
				for (j = 0; j < m_fightDB.m_fightGrids[i].length; j++)
				{
					m_fightDB.m_fightGrids[i][j].dispose();
				}
			}
			
			m_fightDB.m_fightGrids = null;
		}
		
		public function endFight():void
		{
			if (!m_fightDB.m_inFightScene)
			{
				return;
			}
		
			//destroy();
		}
		
		public function destroy():void
		{
			m_fightDB.m_gkcontext.m_msgRoute.m_enterFightDisp.removeEventListener(MsgRoute.EtEnterFight, onEnterFightAniEnd);

			disposeFightGrids();
			endCamera();
			this.unloadUIBattleHead();
			
			m_fightDB.m_effectMgr.onLeaveFight();
			this.m_fightDB.m_gkcontext.m_context.m_processManager.removeTickedObject(this);
			this.m_fightDB.m_gkcontext.m_context.m_processManager.removeResizeObject(this);
			
			m_HPDigitMgr.dispose();
			this.m_fightDB.dispose();
		}
		
		protected function initGrid():void
		{
			// 左边格子初始化，格子编号从里向外，从上向下   
			var startxPos:Number; //中心开始位置 
			var startyPos:Number; //中心开始位置   
			
			startxPos = m_fightDB.m_centerXGrid - m_fightDB.m_offXGrid;
			startyPos = m_fightDB.m_centerYGrid - m_fightDB.m_offYGrid;
			var idx:uint = 0;
			var idy:uint = 0;
			idx = 0;
			idy = 0;
			var grid:FightGrid;
			while (idx < 3)
			{
				idy = 0;
				while (idy < 3)
				{
					grid = new FightGrid(m_fightDB.m_gkcontext, this);
					grid.setParam(EntityCValue.RKLeft, idx * 3 + idy, startxPos - m_fightDB.m_gridWidth * idx, startyPos + m_fightDB.m_gridHeight * idy);
					m_fightDB.m_fightGrids[EntityCValue.RKLeft][grid.gridNO] = grid;
					grid.m_fightDB = m_fightDB;
					
					++idy;
				}
				++idx;
			}
			
			// 右边格子初始化 
			startxPos = m_fightDB.m_centerXGrid + m_fightDB.m_offXGrid;
			startyPos = m_fightDB.m_centerYGrid - m_fightDB.m_offYGrid;
			idx = 0;
			idy = 0;
			while (idx < 3)
			{
				idy = 0;
				while (idy < 3)
				{
					grid = new FightGrid(m_fightDB.m_gkcontext, this);
					grid.setParam(EntityCValue.RKRight, idx * 3 + idy, startxPos + m_fightDB.m_gridWidth * idx, startyPos + m_fightDB.m_gridHeight * idy);
					m_fightDB.m_fightGrids[EntityCValue.RKRight][grid.gridNO] = grid;
					grid.m_fightDB = m_fightDB;
					
					++idy;
				}
				++idx;
			}
		}
		
		protected function initCamera():void
		{
			// 初始化摄像机位置，新的场景一般会是新的摄像机，不用结束跟踪       
			
			//m_camera.moveTo(m_centerXGrid * this.m_gkcontext.m_context.m_sceneView.scene.gridSize, m_centerYGrid * this.m_gkcontext.m_context.m_sceneView.scene.gridSize, 0);
			// bug: 注意摄像机也会移动的  
			//m_camera.moveTo(m_centerXGrid, m_centerYGrid - m_cameraYOff, 0);
			m_fightDB.m_camera.gotoPos(m_fightDB.m_centerXGrid, m_fightDB.m_cameraYOff, 0);
		}
		
		protected function endCamera():void
		{
			// 切换摄像机跟踪，摄像机不再跟踪，如果要跟踪自己退出的时候处理   			
			//m_camera.follow(m_hero, 0);
		}
		
		private function onRoundEnd(round:RoundControl):void
		{
			endRound();
			m_fightDB.m_nextRoundCtrolIndex++;
			if (m_fightDB.m_nextRoundCtrolIndex >= m_fightDB.m_fightProcess.roundlist.length)
			{
				m_fightDB.m_bOver = 1;
			}
			else
			{
				m_fightDB.m_bStart = 1;
			}
		
		}
		
		protected function setArmy(side:int, army:stArmy):void
		{
			var i:int;
			var count:int;
			var gridsWithBudui:Vector.<FightGrid> = m_fightDB.m_fightGridsWithBudui[side];
			gridsWithBudui.length = 0;
			var grids:Vector.<FightGrid> = m_fightDB.m_fightGrids[side];
			count = army.matrixList.length;
			var matrix:stMatrixInfo;
			var grid:FightGrid;
			for each (grid in grids)
			{
				grid.clearBudui();
			}
			for (i = 0; i < count; i++)
			{
				matrix = army.matrixList[i];
				grid = grids[matrix.gridNo];
				grid.setMatrixInfo(matrix);
				gridsWithBudui.push(grid);
			}
		}
		
		public function set fightProcess(value:stAttackResultUserCmd):void
		{
			m_fightDB.m_fightProcess = value;
		}
		
		public function get fightProcess():stAttackResultUserCmd
		{
			return m_fightDB.m_fightProcess;
		}
		
		public function getfightGridsBySide(side:uint):Object
		{
			return m_fightDB.m_fightGrids[side];
		}
		
		public function get gridWidth():int
		{
			return m_fightDB.m_gridWidth;
		}
		
		public function get gridHeight():int
		{
			return m_fightDB.m_gridHeight;
		}
		
		public function get topEmptySpriteYOff():int
		{
			return m_fightDB.m_topEmptySpriteYOff;
		}
		
		public function get botEmptySpriteYOff():int
		{
			return m_fightDB.m_botEmptySpriteYOff;
		}
		
		public function getFightProcess():Object
		{
			return m_fightDB.m_fightProcess;
		}
		
		//计算一个队伍的总血量
		public function getMaxHP(side:uint):uint
		{
			var army:stArmy;
			if (side == EntityCValue.RKLeft)
			{
				army = aArmy;
			}
			else
			{
				army = bArmy;
			}
			
			var ret:uint;
			var i:uint = 0;
			var grids:Vector.<FightGrid> = m_fightDB.m_fightGrids[side];
			for (i = 0; i < army.matrixList.length; i++)
			{
				ret += grids[army.matrixList[i].gridNo].maxHp;
			}
			return ret;
		}
		
		public function get aArmy():stArmy
		{
			return m_fightDB.m_fightProcess.aArmylist[m_fightDB.m_aArmyIndex];
		}
		
		public function get bArmy():stArmy
		{
			return m_fightDB.m_fightProcess.bArmylist[m_fightDB.m_bArmyIndex];
		}
		
		public function getTotalHP(side:uint):uint
		{
			var ret:uint;
			var i:uint = 0;
			for (i = 0; i < m_fightDB.m_fightGrids[side].length; i++)
			{
				ret += m_fightDB.m_fightGrids[side][i].curHp;
			}
			return ret;
		}
		
		public function attemptBegin():void
		{
			// 检查是否可以加载进行战斗了 
			if (breadyInitRes())
			{
				trace("loaded--" + "开始初始化");
				m_fightDB.m_effectMgr.onEnterFight();
				m_fightDB.m_bStart = 1;
				
				if (m_fightDB.m_gkcontext.m_context.m_config.m_bShowFightGrid)
				{
					drawFightGrid();
				}
				
				onPlayBattles();
				m_roundForShowJieshuBtn = 1;
				if (m_fightDB.m_gkcontext.m_battleMgr.m_fastover >= 1)
				{
					m_roundForShowJieshuBtn = m_fightDB.m_gkcontext.m_battleMgr.m_fastover;
				}
				else
				{
					if (isNotShowJieshuBtn())
					{
						m_roundForShowJieshuBtn = 0;
					}
					else if (m_fightDB.m_gkcontext.m_sanguozhanchangMgr.inZhanchang)
					{
						m_roundForShowJieshuBtn = 2;
					}
					else if (m_fightDB.m_gkcontext.m_localMgr.isSet(LocalDataMgr.LOCAL_QiangDuoBaowuBattle))
					{
						m_roundForShowJieshuBtn = 2;
					}
					// 非 vip 才做这个限制
					if (!m_fightDB.m_gkcontext.m_beingProp.vipLevel)
					{
						if (m_fightDB.m_gkcontext.playerMain.level < 6)
						{
							m_roundForShowJieshuBtn = 2;
						}
					}
				}
				
				if (m_roundForShowJieshuBtn == 1)
				{
					showUIReplay(UIReplay.MODE_jieshu);
				}
				else
				{
					hideUIReplay();
				}
			}
		}
		
		public function loadUIBattleHead():void
		{
			m_fightDB.m_UIBattleHead = new UIBattleHead(m_fightDB);
			m_fightDB.m_gkcontext.m_UIMgr.addForm(m_fightDB.m_UIBattleHead);
			m_fightDB.m_UIBattleHead.show();
			
			m_fightDB.m_UIBattleTip = new UIBattleTip();
			m_fightDB.m_gkcontext.m_UIMgr.addForm(m_fightDB.m_UIBattleTip);
		}
		
		public function unloadUIBattleHead():void
		{
			if (m_fightDB.m_UIBattleHead)
			{
				m_fightDB.m_UIBattleHead.exit();
				m_fightDB.m_UIBattleHead = null;
			}
			
			if (m_fightDB.m_UIBattleTip)
			{
				m_fightDB.m_gkcontext.m_UIMgr.destroyForm(m_fightDB.m_UIBattleTip.id);
				m_fightDB.m_UIBattleTip = null;
			}
			m_fightDB.m_gkcontext.m_uiTip.hideTip();
		}
		
		// 检查需要初始化的资源是否加载完成了 
		public function breadyInitRes():Boolean
		{
			//if (!m_fightDB.m_preDB.m_initReady)
			//{
			//	return false;
			//}
			//if (m_fightDB.m_UIBattleHead == null || m_fightDB.m_UIBattleHead.isReady == false)
			if (m_fightDB.m_UIBattleHead == null)
			{
				return false;
			}
			
			return true;
		}		
			
		
		public function get npcBattleMgr():NpcBattleMgr
		{
			return m_fightDB.m_npcBattleMgr;
		}
		
		public function get curRoundIndex():uint
		{
			return m_fightDB.m_curRoundIndex;
		}
		
		public function getUIBattleTip():Object
		{
			return m_fightDB.m_UIBattleTip;
		}
		
		public function get skillAni():SkillAni
		{
			if (m_fightDB.m_skillAni == null)
			{
				m_fightDB.m_skillAni = new SkillAni(m_fightDB.m_gkcontext.m_context);
			}
			return m_fightDB.m_skillAni;
		}
		
		public function drawFightGrid():void
		{
			var startPt:Point = new Point();
			var gridsize:Point = new Point();
			startPt.x = m_fightDB.m_centerXGrid - m_fightDB.m_offXGrid - 3 * m_fightDB.m_gridWidth;
			startPt.y = m_fightDB.m_centerYGrid - m_fightDB.m_offYGrid;
			
			gridsize.x = m_fightDB.m_gridWidth;
			gridsize.y = m_fightDB.m_gridHeight;
			
			m_fightDB.m_gkcontext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).drawFightGrid(startPt, gridsize);
		}
		
		/*开始一个新回合时,调用此函数
		 */
		public function beginNewRound(roundIndex:int):void
		{
			var i:int;
			var j:int;
			for (i = 0; i < 2; i++)
			{
				for (j = 0; j < 9; j++)
				{
					m_fightDB.m_fightGrids[i][j].beginNewRound(roundIndex);
				}
			}
			
			if (m_fightDB.m_UIBattleHead != null)
			{
				m_fightDB.m_UIBattleHead.setRound(roundIndex);
			}
			
			var curRound:int = roundIndex + 1; //当前是第几回合。1-表示第1回合，2-表示第2回合
			if (m_fightDB.m_UIReplay == null || m_fightDB.m_UIReplay.isVisible() == false)
			{
				var bShowUIReplay:Boolean = false;
				if (m_roundForShowJieshuBtn >= 2)
				{
					if (curRound >= m_roundForShowJieshuBtn)
					{
						bShowUIReplay = true;
					}
				}
				
				if (bShowUIReplay)
				{
					showUIReplay(UIReplay.MODE_jieshu);
				}
			}
		}
		
		public function get isUIReplayVisible():Boolean
		{
			return m_fightDB.m_UIReplay && m_fightDB.m_UIReplay.isVisible();
		}
		
		public function endRound():void
		{
			var i:int;
			var j:int;
			for (i = 0; i < 2; i++)
			{
				for (j = 0; j < 9; j++)
				{
					m_fightDB.m_fightGrids[i][j].endRound();
				}
			}
			
			//this.processValueEffectList(
			m_fightDB.m_UIBattleHead.onEndRound();
		}
		
		public function savePic():void
		{
			m_fightDB.m_bitmapRenderer.savePic();
		}
		
		// 战斗回放回放
		public function palyerBack():void
		{
			m_fightDB.m_fightIdx = -1;
			// 释放锦囊持续特效,这个特效是一致持续的，因此需要释放掉
			m_fightDB.m_effectMgr.disposeAllSceneJinNangEff();
			// 释放上一局格子中的数据
			var i:int;
			var j:int;
			for (i = 0; i < 2; i++)
			{
				for (j = 0; j < m_fightDB.m_fightGrids[i].length; j++)
				{
					m_fightDB.m_fightGrids[i][j].disposeAllNpcBattle();
				}
			}
			
			m_fightDB.m_curRoundIndex = -1;
			
			// 初始化数据
			initArmy();
			
			// 条件满足回放
			m_fightDB.m_bOver = 0;
			m_fightDB.m_bStart = 1;
			m_fightDB.m_nextRoundCtrolIndex = 0;
			m_fightDB.m_UIBattleHead.hideTips();
			bStopPlayer = false;
			onPlayBattles();
			m_roundForShowJieshuBtn = 1;
			showUIReplay(UIReplay.MODE_jieshu);
		}
		
		// 点击立即结束按钮,现在重置所有状态到最初状态
		public function resetFight():void
		{
			m_fightDB.m_roundCtrol.clearAction();
			// 显示回放按钮,并且出现点击直接退出界面
			showUIReplay(UIReplay.MODE_huifang);
		
		}
		
		public function set bStopPlayer(value:Boolean):void
		{
			m_fightDB.m_bStopPlayer = value;
			if (m_fightDB.m_bStopPlayer)
			{
				// 停止锦囊运动，但是锦囊停止后不能再运动，没有这个机制
				m_fightDB.m_UIBattleHead.stopJN();
			}
		}
		
		//return -- true - 表示在战斗中，从始至终不显示"立即结束"按钮
		private function isNotShowJieshuBtn():Boolean
		{
			if (m_fightDB.m_gkcontext.m_worldBossMgr.m_bInWBoss || MapInfo.CorpsCitySys == m_fightDB.m_gkcontext.m_mapInfo.mapType() || //军团争霸
				MapInfo.MTTeamFB == m_fightDB.m_gkcontext.m_mapInfo.mapType() || //组队副本中
				MapInfo.MAPID_TeamChuanGuan == m_fightDB.m_gkcontext.m_mapInfo.m_servermapconfigID || //组队闯关地图
				m_fightDB.m_gkcontext.m_worldBossMgr.m_bInWBoss //世界boss
				)
			{
				return true;
			}
			
			return false;
		}
		
		//开始播放战斗时，调用此函数
		private function onPlayBattles():void
		{
			if (m_fightDB.m_uiFightResult)
			{
				m_fightDB.m_uiFightResult.hide();
			}
		}
		
		public function prepInitRes():void
		{
			//m_fightDB.m_preDB.prepInitRes();
		}
		
		// 更新战斗结束
		public function updateOver(deltaTime:Number):void
		{
			if (m_fightDB.m_bOver == 1)
			{
				m_fightDB.m_overTime += deltaTime;
				if (m_fightDB.m_overTime > 0.5) // 显示战斗结果,需要延迟 0.5 秒
				{
					m_fightDB.m_overTime = 0;
					m_fightDB.m_bOver = 2;
				}
			}
			else if (m_fightDB.m_bOver == 2) // 战斗结果显示
			{
				var uiturncard:IUITurnCard;
				var result:IForm;
				var obj:Object = this.fightProcess.m_stAttackVictoryInfoUserCmd;
				if (obj != null)
				{
					showFightResult();
					m_fightDB.m_uiFightResult.updateData();
				}
				else
				{
					// 现在有[立即退出][回放]，因此不立即退出战斗了
					//endFight();
					//this.m_gkcontext.m_quitFight();
					// 没有战斗结果就肯定不显示了,因为判断不出来
					//m_fightDB.m_gkcontext.m_beingProp.m_bShowFailTip = false;
					if (m_fightDB.m_gkcontext.m_mapInfo.m_bInArean) // 如果在竞技场中
					{
						if (m_fightDB.m_gkcontext.m_contentBuffer.getContent("uiCopyTurnCard_reward", false)) // 如果有战斗奖励
						{
							// 先显示战斗奖励
							uiturncard = m_fightDB.m_gkcontext.m_UIMgr.getForm(UIFormID.UIFTurnCard) as IUITurnCard;
							if (uiturncard)
							{
								uiturncard.parseCopyReward(m_fightDB.m_gkcontext.m_contentBuffer.getContent("uiCopyTurnCard_reward", true) as ByteArray);
							}
							else
							{
								m_fightDB.m_gkcontext.m_UIMgr.loadForm(UIFormID.UIFTurnCard);
							}
						}
						else
						{
							//cbAniEnd();
							resetFight();
						}
					}
					else
					{
						//cbAniEnd();
						resetFight();
					}
				}
				m_fightDB.m_bOver = 3; // 整个战斗结束了
			}
		}
		
		// 更新 GI
		public function updateGI(deltaTime:Number):void
		{
			if (m_fightDB.m_bchGI)
			{
				if (m_fightDB.m_intensity > 20)
				{
					m_fightDB.m_intensity -= 200 * deltaTime;
					if (m_fightDB.m_intensity < 20)
					{
						m_fightDB.m_intensity = 20;
					}
					m_fightDB.m_fightscene.environmentLight.intensity = m_fightDB.m_intensity;
				}
			}
		}
		
		// 更新战斗序列
		public function updateFightSeq(deltaTime:Number):void
		{
			
			if (m_fightDB.m_bStart == 1)
			{
				m_fightDB.m_starTime += deltaTime;
				if (m_fightDB.m_starTime > m_fightDB.m_fightInterval) // 延迟一点,让链接特效播放完了
				{
					m_fightDB.m_bStart = 0;
					m_fightDB.m_starTime = 0;
					
					if (m_fightDB.m_nextRoundCtrolIndex >= m_fightDB.m_fightProcess.roundlist.length)
					{
						m_fightDB.m_bOver = 1;
					}
					else
					{
						beginNewRound(m_fightDB.m_nextRoundCtrolIndex);
						m_fightDB.m_roundCtrol.begin(m_fightDB.m_fightProcess.roundlist[m_fightDB.m_nextRoundCtrolIndex]);
					}
					
				}
			}
		}
		
		public function canQuit():Boolean
		{
			return m_fightLogicCB.canQuit();
		}
		
		public function showUIReplay(mode:int):void
		{
			if (m_fightDB.m_UIReplay == null)
			{
				m_fightDB.m_UIReplay = new UIReplay(this);
				m_fightDB.m_gkcontext.m_UIMgr.addForm(m_fightDB.m_UIReplay);
			}
			m_fightDB.m_UIReplay.show();
			m_fightDB.m_UIReplay.btnMode = mode;
		}
		
		public function hideUIReplay():void
		{
			if (m_fightDB.m_UIReplay)
			{
				m_fightDB.m_UIReplay.hide();
			}
		}
		
		public function showFightResult():UIFightResult
		{
			if (m_fightDB.m_uiFightResult == null)
			{
				m_fightDB.m_uiFightResult = new UIFightResult(this);
				m_fightDB.m_gkcontext.m_UIMgr.addForm(m_fightDB.m_uiFightResult);
			}
			m_fightDB.m_uiFightResult.show();
			return m_fightDB.m_uiFightResult;
		}
	}
}