package modulefight.scene.fight
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;
	import flash.display.DisplayObject;
	import modulecommon.scene.prop.table.TWuPropertyItem;
	import modulefight.netmsg.stmsg.AttackedInfoGrid;
	import modulefight.netmsg.stmsg.DefList;
	import modulefight.netmsg.stmsg.SelfInfoGrid;
	import modulefight.netmsg.stmsg.stStrikeBack;
	import modulefight.netmsg.stmsg.stValueEffect;
	import modulefight.scene.fEmptySpriteForFight;
	import modulefight.skillani.JuqiSkillAni;
	import modulefight.tianfu.Tianfu_LianYing;
	import modulefight.tianfu.TianfuBase;
	import modulefight.ui.hpstrip.HPStripBase;
	import modulefight.ui.hpstrip.HPStripLeft;
	import modulefight.ui.hpstrip.HPStripRight;
	
	//import flash.display.Shape;
	import flash.display.Sprite;
	//import flash.geom.Point;
	//import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TModelEffItem;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	//import modulecommon.ui.UIFormID;
	
	import modulefight.FightEn;
	//import modulefight.digitani.DigitSprite;
	import modulefight.netmsg.stmsg.BattleArray;
	//import modulefight.netmsg.stmsg.DefList;
	import modulefight.netmsg.stmsg.PkValue;
	import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.netmsg.stmsg.stMatrixInfo;
	//import modulefight.netmsg.stmsg.stUserInfo;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.rank.OneOrder;
	import modulefight.scene.fight.rank.OrderBase;
	import modulefight.scene.fight.rank.PentagonOrder;
	import modulefight.scene.fight.rank.QuadOrder;
	import modulefight.scene.fight.rank.TriangleOrder;
	import modulefight.skillani.SkillAni;
	//import modulefight.ui.UIFightBuff;
	
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.elements.fEmptySprite;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9EmptySpriteRenderer;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	
	/**
	 * ...
	 * @author
	 * @brief 场景中的格子
	 */
	public class FightGrid
	{
		protected var m_gkContext:GkContext;
		protected var m_gameFightController:GameFightController;
		
		protected var m_gridNO:uint; //格子号
		protected var m_side:uint; //
		protected var m_xPos:Number; // 左边队伍是右上角顶点，右边队伍是左上角顶点  
		protected var m_yPos:Number; // 左边队伍是右上角顶点，右边队伍是左上角顶点  
		
		protected var m_xlastPos:Number; // 上一次停留的位置，左边是右上角顶点，右边是左上角顶点  
		protected var m_ylastPos:Number; // 上一次停留的位置，左边是右上角顶点，右边是左上角顶点  
		
		protected var m_beingList:Vector.<NpcBattle>; // 当前格子攻击人物列表
		protected var m_beingLiveList:Vector.<NpcBattle>; // 活着的Npc列表
		protected var m_beingRemovedList:Vector.<NpcBattle>; // 因死去，而去掉的npc列表
		
		protected var m_totalCnt:uint; // 当前格子总共人数   
		protected var m_attBattle:BattleArray;
		//protected var m_hurtBattle:Dictionary;	//BattleArray;	// 被击可能会前一个被击还没有播放,后面一个被击先播放
		
		protected var m_topEmptySprite:fEmptySpriteForFight; // 很多显示都在这里面显示   
		protected var m_botEmptySprite:fEmptySpriteForFight; // 很多显示都在这里面显示   
		
		//protected var m_buffform:UIFightBuff;
		protected var m_HPStrip:HPStripBase;
		protected var m_state:uint; // 格子当前状态   
		protected var m_shiqi:int; //士气值
		
		protected var m_curHp:uint;
		protected var m_curRoundIndex:uint; //表示当前是第m_curRoundIndex回合, 这是zero-based。例如m_curRoundIndex == 0时，表示第一回合
		protected var m_matrixInfo:stMatrixInfo;
		protected var m_bufferList:Vector.<stEntryState>;
		
		protected var m_attType:int; // 记录攻击类型，近攻，远攻等		
		protected var m_bindType:uint; // 受伤特效绑定到格子上还是人身上
		protected var m_onEntered:Function;
		public var m_fightDB:FightDB; // 战斗全局数据
		protected var m_tianfu:TianfuBase;
		
		public function FightGrid(gk:GkContext, gameFightController:GameFightController)
		{
			m_gkContext = gk;
			m_gameFightController = gameFightController;
			
			m_beingList = new Vector.<NpcBattle>();
			m_beingLiveList = new Vector.<NpcBattle>();
			m_beingRemovedList = new Vector.<NpcBattle>();
			m_totalCnt = 5;
			
			m_state = EntityCValue.GSNormal;
			
			m_attType = -1; // -1 表示没有设置过，需要设置			
			m_bindType = 0;
			//m_hurtBattle = new Dictionary();
		}
		
		public function get xPos():Number
		{
			return m_xPos;
		}
		
		
		
		public function get yPos():Number
		{
			return m_yPos;
		}		
			
		public function get xCenter():Number
		{
			if (m_side == 0)
			{
				return m_xPos - m_fightDB.m_gridWidthHalf;
			}
			else
			{
				return m_xPos + m_fightDB.m_gridWidthHalf;
			}
		}
		
		public function get yCenter():Number
		{
			return m_xPos + m_fightDB.m_gridHeightHalf;
		}
		
		public function get xCenterLast():Number
		{
			if (m_side == 0)
			{
				return m_xlastPos - m_fightDB.m_gridWidthHalf;
			}
			else
			{
				return m_xlastPos + m_fightDB.m_gridWidthHalf;
			}
		}
		
		public function get yCenterLast():Number
		{
			return m_ylastPos + m_fightDB.m_gridHeightHalf;
		}
		
		public function get totalCnt():uint
		{
			return m_totalCnt;
		}
		
		public function get beingList():Vector.<NpcBattle>
		{
			return m_beingList;
		}
	
		public function get xlastPos():Number
		{
			return m_xlastPos;
		}
		
		public function set xlastPos(value:Number):void
		{
			m_xlastPos = value;
		}
		
		public function get ylastPos():Number
		{
			return m_ylastPos;
		}
		
		public function set ylastPos(value:Number):void
		{
			m_ylastPos = value;
		}
		
		public function get topEmptySprite():fEmptySpriteForFight
		{
			return m_topEmptySprite;
		}
		
		public function get botEmptySprite():fEmptySpriteForFight
		{
			return m_botEmptySprite;
		}	
		
		public function get gridNO():uint
		{
			return m_gridNO;
		}
		
		/*public function set gridNO(value:uint):void
		{
			m_gridNO = value;
		}*/
		
		public function get side():uint
		{
			return m_side;
		}
		
		//返回格子的位置，十位数是队伍编号，个位格子编号
		public function get pos():int
		{
			return m_side * 10 + m_gridNO;
		}
		
		public function get state():uint
		{
			return m_state;
		}
		
		public function set state(value:uint):void
		{
			m_state = value;
		}
		
		public function setParam(side:int, gridNO:int, xPos:int, yPos:int):void
		{
			m_side = side;
			m_gridNO = gridNO;
			m_xPos = xPos;
			m_yPos = yPos;
		}
		
		//此格子上是否有部队
		public function get hasBuDui():Boolean
		{
			return m_matrixInfo != null;
		}
		public function setMatrixInfo(matrixInfo:stMatrixInfo):void
		{
			clearBudui();			
			m_matrixInfo = matrixInfo;
			if (m_matrixInfo.tempid == 0)
			{
				return;
			}
			m_curHp = m_matrixInfo.initHP;
			
			
			if (m_topEmptySprite == null)
			{
				this.createAsset();
			}
			else // 如果存在就是隐藏掉了，需要显示出来
			{
				m_topEmptySprite.show();
				m_botEmptySprite.show();
			}
			
			var item:TNpcBattleItem;
			var total:uint;
			var dir:uint;
		
			item = m_matrixInfo.m_npcBase;
			total = item.m_memCnt;
			m_attType = computeAttType();
			if (m_matrixInfo.actnum == 4 || (m_matrixInfo.isWu&&m_matrixInfo.add>0))
			{
				m_tianfu = m_fightDB.m_tianfuMgr.createTianfu(this);
			}
			if (EntityCValue.RKLeft == side)
			{
				dir = 0;
			}
			else
			{
				dir = 180;
			}
			var being:NpcBattle;
			var k:int = 0;
			var lScene:fScene = this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT);
			while (k < total)
			{
				being = lScene.createCharacter(EntityCValue.TBattleNpc, item.npcBattleModel.m_strModel, 0, 0, 0, dir) as NpcBattle;
				being.m_fightDB = m_fightDB;
				// 强制创建显示内容
				var r:fFlash9ElementRenderer = being.customData.flash9Renderer;
				if (!r.assetsCreated)
				{
					r.createAssets();
				}
				// 人物和武将的战斗动作是在战斗 npc 表中配置的，直接初始化一边就行了   
				being.act2FrameRate = item.npcBattleModel.m_act2FrameRate;
				
				// 设置移动速度 
				being.vel = m_fightDB.moveVel;
				being.m_effectSpeed = m_fightDB.effVel;
				being.tempid = item.m_uID;
				being.setNpcBaseItem(item);
				being.hp = m_matrixInfo.maxhp;
				being.shiqi = 0;
				being.side = side;
				being.fightGrid = this;
				being.m_index = k;
				being.updateName();
				m_gameFightController.npcBattleMgr.addBeing(being);
				
				m_beingList.push(being);
				++k;
			}
			m_totalCnt = total;
			
			// 生成队形 
			var order:OrderBase;
			
			var beingidx:uint = 0; // 获取的玩家索引    
			var beingorigidx:uint = 0; // 获取的坐标点偏移的时候的索引 
			if (1 == total)
			{
				order = new OneOrder();
				beingidx = 0;
				beingorigidx = 0;
				
				m_beingLiveList.push(m_beingList[0]);
			}
			else if (3 == total)
			{
				order = new TriangleOrder();
				beingidx = 2;
				beingorigidx = beingidx;
				
				m_beingLiveList.push(m_beingList[2]);
				m_beingLiveList.push(m_beingList[1]);
				m_beingLiveList.push(m_beingList[0]);
			}
			else if (4 == total)
			{
				order = new QuadOrder();
				beingidx = 3;
				beingorigidx = beingidx;
				
				m_beingLiveList.push(m_beingList[3]);
				m_beingLiveList.push(m_beingList[2]);
				m_beingLiveList.push(m_beingList[1]);
				m_beingLiveList.push(m_beingList[0]);
			}
			else if (5 == total)
			{
				order = new PentagonOrder();
				beingidx = 2;
				beingorigidx = beingidx;
				
				m_beingLiveList.push(m_beingList[2]);
				m_beingLiveList.push(m_beingList[4]);
				m_beingLiveList.push(m_beingList[3]);
				m_beingLiveList.push(m_beingList[1]);
				m_beingLiveList.push(m_beingList[0]);
				
			}
			order.gkcontext = m_gkContext;
			order.vertX = m_xPos;
			order.vertY = m_yPos;
			order.totalCnt = total;
			order.side = side;
			order.direction = 1 - side; // 向右的三角形 
			
			// 设置位置 
			var beingFollow:NpcBattle = m_beingList[beingidx];
			m_topEmptySprite.followBeing = beingFollow;
			m_botEmptySprite.followBeing = beingFollow;
			beingFollow.topEmptySprite = topEmptySprite;
			beingFollow.botEmptySprite = botEmptySprite;
			
			m_topEmptySprite.xFollowOff = order.getXOff2Center(beingorigidx);
			m_topEmptySprite.yFollowOff = m_topEmptySprite.yOff + order.getYOff2Center(beingorigidx);
			
			m_botEmptySprite.xFollowOff = order.getXOff2Center(beingorigidx);
			m_botEmptySprite.yFollowOff = m_botEmptySprite.yOff + order.getYOff2Center(beingorigidx);
			
			order.addGrid(this);
			order.bend = true;
			order.buildOrder();			
			
			for each( being in m_beingList)
			{
				being.needDepthSort = false;
			}
			
			setShiqi(m_matrixInfo.initshiqi);
			
			
			if (m_curHp == 0)
			{
				die();
			}
			else
			{
				var pnt:fFlash9EmptySpriteRenderer = m_topEmptySprite.customData.flash9Renderer as fFlash9EmptySpriteRenderer;
				//pnt.uiLayer.addChild(buffform);
				if (pnt.uiLayer.contains(m_HPStrip) == false)
				{
					pnt.uiLayer.addChild(m_HPStrip);
				}
				
				m_HPStrip.initData();
			}
		}
		
		//从场景外面走进来
		public function enter(onEntered:Function):void
		{
			if (m_matrixInfo.tempid == 0)
			{
				return;
			}
			
			m_onEntered = onEntered;
			
			var xOffset:int = (side == 0 ? -700 : 700);
			var i:int;
			var xDest:Number;
			var yDest:Number;
			var being:NpcBattle;
			for (i = 0; i < m_beingList.length; i++)
			{
				being = m_beingList[i];
				being.vel = 600;
				xDest = being.x;
				yDest = being.y;
				being.moveTo(xDest + xOffset, yDest, 0);
				if (being == m_topEmptySprite.followBeing)
				{
					being.moveToPosCB(xDest, yDest, onNpcEnter);
				}
				else
				{
					being.moveToPosCB(xDest, yDest, null);
				}
			}
			
			if (m_topEmptySprite.followBeing)
			{				
				m_topEmptySprite.updatePos();
				m_botEmptySprite.updatePos();				
			}
		
		}
		
		private function onNpcEnter():void
		{
			if (m_onEntered != null)
			{
				m_onEntered(this);
				m_onEntered = null;
			}
		}
		
	
		
		public function get matrixInfo():stMatrixInfo
		{
			return m_matrixInfo;
		}
		
		public function get maxHp():uint
		{
			return m_matrixInfo.maxhp;
		}
		
		public function get curHp():uint
		{
			return m_curHp;
		}
		
		//public function updateHp(pk:PkValue):void
		public function updateHp(hpType:uint, hpValue:uint, attackType:uint):void
		{
			//pk = pk as PkValue;
			if (hpValue == 0)
			{
				return;
			}
			
			if (hpType==FightEn.DAMTYPE_VEADDSHIQI || hpType==FightEn.DAMTYPE_VEREDUCESHIQI )
			{
				return;
			}
			var scene:fScene = m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT);
			if (scene == null)
			{
				return;
			}
			//var pnt:fFlash9EmptySpriteRenderer = topEmptySprite.customData.flash9Renderer as fFlash9EmptySpriteRenderer;
			var fogSprite:Sprite = scene.m_SceneLayer[EntityCValue.SLFog];
			if (fogSprite)
			{
				m_gameFightController.m_HPDigitMgr.emitDigit(hpType, hpValue, attackType, topEmptySprite.x, topEmptySprite.y - 220, fogSprite);
			}
			else
			{
				var strLog:String = "FightGrid::updateHp fogSprite== null" + fUtil.keyValueToString("IAmBeingRendered", scene.IAmBeingRendered, "step", m_gkContext.m_battleMgr.moduleFight.step);
				DebugBox.sendToDataBase(strLog);
			}
			
			if (hpType == FightEn.DAMTYPE_VEADDHP)
			{				
				if (m_fightDB.m_tianfuMgr.isNotifyRestoreHP())
				{
					m_fightDB.m_tianfuMgr.onFightGridRestoreHP(this);
				}				
			}
			else
			{
				
			}
		}
		
		
		//设置格子的最新血量
		public function setHP(newHP:int):void
		{
			if (m_curHp == newHP)
			{
				return;
			}
			m_curHp = newHP;
			m_HPStrip.updateHP();
			updateNumOfNpc();			
			if (m_curHp == 0)
			{				
				die();
				onDie();
			}
		}
		
		public function get isDie():Boolean
		{
			return m_curHp == 0;
		}
		
		private function updateNumOfNpc():void
		{
			var nNpc:int = computeNumOfBeings();
			if (m_beingLiveList.length == nNpc)
			{
				return;
			}
			var npc:NpcBattle;
			var i:int;
			var n:int;
			if (nNpc < m_beingLiveList.length)
			{
				n = m_beingLiveList.length - nNpc;
				for (i = 0; i < n; i++)
				{
					npc = m_beingLiveList.pop();					
					m_beingRemovedList.push(npc);					
					npc.setHideOnHP(true);
				}
			}
			else
			{
				n = nNpc - m_beingLiveList.length;
				for (i = 0; i < n; i++)
				{
					npc = m_beingRemovedList.pop();
					m_beingLiveList.push(npc);
					npc.setHideOnHP(false);			
				}
			}
			
		}
		private function computeNumOfBeings():int
		{			
			if (m_curHp == 0)
			{
				return 0;
			}
			if (m_matrixInfo.m_npcBase.m_memCnt == 1)
			{
				return 1;
			}
			var nNpc:int;
			var nTotal:int = m_matrixInfo.m_npcBase.m_memCnt;
			var n:int = Math.floor(m_matrixInfo.maxhp / nTotal);
			nNpc = Math.floor(m_curHp / n) + 1;
			if (nNpc > nTotal)
			{
				nNpc = nTotal;
			}			
			return nNpc;			
		}
		
		//被反击后，立即调用此函数
		public function onStrikeBackList(bat:BattleArray):void
		{
			var dam:uint =0;
			var stStrikeBackItem:stStrikeBack;
			for each (stStrikeBackItem in bat.strikeBackList)
			{
				dam += stStrikeBackItem.dam;
			}			
		
			this.updateHp(FightEn.DAM_TYPE_FANJI, dam, FightEn.DAM_None);
			
			/*if (isDie==false)
			{
				var grid:FightGrid
				var enemyGrids:Vector.<FightGrid> = m_fightDB.m_fightGrids[1 - bat.aTeamid];
				for each (stStrikeBackItem in bat.strikeBackList)
				{
					grid = enemyGrids[stStrikeBackItem.pos];
					var tianfu_FeiJiang:Tianfu_LianYing = grid.tianfu as Tianfu_LianYing;
					if (tianfu_FeiJiang)
					{
						tianfu_FeiJiang.subtractShiqi_Attack(grid);
					}
				}				
			}*/
			
			if (m_fightDB.m_UIBattleTip != null && m_fightDB.m_UIBattleTip.isVisible())
			{
				m_fightDB.m_UIBattleTip.update(this);
			}
		}
		
		//直接攻击后，立即调用此函数
		public function onAttacked(bat:BattleArray, attackType:uint, byJinNang:Boolean=false):void
		{
			var attackedInfo:AttackedInfoGrid = bat.attackedList.getAttackedInfoGridByPos(this.m_gridNO);
			if (attackedInfo.buffer)
			{
				addBuff(attackedInfo.buffer);	
			}
			if (attackedInfo.bufferID)
			{
				deleteBuff(attackedInfo.bufferID);
			}
		
			setShiqi(attackedInfo.curShiqi);
			setHP(attackedInfo.curHP);
			
			var pv:PkValue;
			for each(pv in attackedInfo.hpList)
			{
				updateHp(pv.type, pv.value, attackType);				
			}			
			
			var tianBase:TianfuBase = this.tianfu;
			if (tianBase&&tianBase.type==TianfuBase.TYPE_Attacked)
			{
				var param:Object = new Object();
				param["BattleArray"] = bat;
				param["Jinnang"] = byJinNang;
				if (tianBase.isTriger(param))
				{
					tianBase.exec();
				}
			}
			/*if (isDie==false&&byJinNang == false)
			{
				var grid:FightGrid = m_fightDB.m_fightGrids[bat.aTeamid][bat.aPos];
				var tianfu_FeiJiang:Tianfu_LianYing = grid.tianfu as Tianfu_LianYing;
				if (tianfu_FeiJiang)
				{
					tianfu_FeiJiang.subtractShiqi_Attack(this);
				}				
			}*/
			
			if (m_fightDB.m_UIBattleTip != null && m_fightDB.m_UIBattleTip.isVisible())
			{
				m_fightDB.m_UIBattleTip.update(this);
			}
		}
		
		public function onZengyiByBattleArray(bat:BattleArray):void
		{
			var info:SelfInfoGrid = bat.selfList.getInfoGridByPos(this.m_gridNO);
			if (info.buffer)
			{
				addBuff(info.buffer);	
			}
			setHP(info.curHP);
			setShiqi(info.curShiqi);
			
			if (info.hpList)
			{
				var pv:PkValue;
				for each(pv in info.hpList)
				{
					updateHp(pv.type, pv.value, FightEn.DAM_None);
				}
			}
			
			if (m_fightDB.m_UIBattleTip != null && m_fightDB.m_UIBattleTip.isVisible())
			{
				m_fightDB.m_UIBattleTip.update(this);
			}
		}		
		
		protected function die():void
		{			
			setShiqi(0);
			clearAllBuffer();
			var npc:NpcBattle;
			for each (npc in m_beingList)
			{
				npc.state = EntityCValue.TDie;
			}
			
			if (m_HPStrip != null)
			{
				if (m_HPStrip.parent)
				{
					m_HPStrip.parent.removeChild(m_HPStrip);
				}
			}
			if (m_tianfu)
			{
				m_fightDB.m_tianfuMgr.releaseTianfu(m_tianfu);
			}		
			
			
		}
		public function onDie():void
		{
			//如果存在由武将死亡来触发的天赋，调用onFightGridDie
			if (m_fightDB.m_tianfuMgr.isNotifyFightGridDie())
			{
				m_fightDB.m_tianfuMgr.onFightGridDie(this); 
			}
		}
		
		public function setattBattle(battle:Object):void
		{
			m_attBattle = battle as BattleArray;
			
		}
		
		public function showSkillName():void
		{
			if (m_attBattle && m_attBattle.type == 1)
			{			
				
				if (m_topEmptySprite.followBeing == null)
				{
					return;
				}
				
				var ani:SkillAni = m_gameFightController.skillAni;
				var name:String = m_attBattle.skillBaseitem.m_fazhaoPic + ".png";
				ani.begin(m_side, name);
				
				var base:Sprite = m_topEmptySprite.followBeing.baseObj;
				if (base.contains(ani) == false)
				{
					base.addChild(ani);
				}
				
				ani.y = -m_topEmptySprite.followBeing.getTagHeight() - 40;	
		
			}
		}
		
		public function showJuqiSkillAni():void
		{
			if (m_topEmptySprite.followBeing == null)
				{
					return;
				}
				
				var ani:JuqiSkillAni = m_fightDB.juqiSkillAni;
				
				ani.begin();
				
				var base:Sprite = m_topEmptySprite.followBeing.baseObj;
				if (base.contains(ani) == false)
				{
					base.addChild(ani);
				}
				
				ani.y = -m_topEmptySprite.followBeing.getTagHeight() +40;	
		}
		
		public function get attBattle():BattleArray
		{
			return m_attBattle;
		}
		
		//public function sethurtBattle(battle:Object, fightidx:int):void
		//{
		// bug: 如果连续攻击,本来已经在受伤中,这个值设置了,但是由于不等受伤播放完,直接进入下一次攻击,可能下一次攻击把这个格子的数据直接替换掉了,就更改了上一次受伤的数据了,因此受伤的播放一定要按照顺序播放
		// m_hurtBattle = battle as BattleArray;
		//m_hurtBattle[fightidx] = battle;		// 这个就不清理了,一直保留到战斗结束
		//}
		
		//public function set hurtBattle(battle:BattleArray, fightidx:int):void
		//{
		// bug: 如果连续攻击,本来已经在受伤中,这个值设置了,但是由于不等受伤播放完,直接进入下一次攻击,可能下一次攻击把这个格子的数据直接替换掉了,就更改了上一次受伤的数据了,因此受伤的播放一定要按照顺序播放
		//m_hurtBattle[fightidx] = battle;
		//}
		
		/*public function hurtBattle(fightidx:int):BattleArray
		   {
		   return m_hurtBattle[fightidx];
		 }*/
		
		public function get npcBaseItem():TNpcBattleItem
		{
			return m_matrixInfo.m_npcBase;
		}
		
		public function get wuPropertyBase():TWuPropertyItem
		{
			return m_matrixInfo.getWuPropertyBase();
		}
		
		//public function defList(fightidx:int):DefList
		//{
		//if (m_hurtBattle[fightidx])
		//{
		//	return m_hurtBattle[fightidx].getDefDataByPos(m_side, m_gridNO);
		//}
		//	return null;
		//}
		
		public function onTick(deltaTime:Number):void
		{
			// 更新玩家列表,不在管理器中更新
			var npc:NpcBattle;
			for each(npc in m_beingList)
			{
				npc.onTick(deltaTime);
			}			
			/*var idx:int = m_beingList.length - 1;
			while (idx >= 0)
			{
				if(m_beingList[idx]._visible)
				{
					m_beingList[idx].onTick(deltaTime);
					if (m_beingList[idx].bemove)
					{
						// 从人物拖尾中删除
						m_fightDB.m_bitmapRenderer.clearBeing(m_beingList[idx]);
						m_gameFightController.npcBattleMgr.destroyBeingByID(m_beingList[idx].id);
						m_beingList.splice(idx, 1);
					}
				}
				--idx;
			}*/
			
			/*if (m_beingList.length == 0 && m_topEmptySprite && m_topEmptySprite._visible) // 如果这个格子人全部删除,就清理这个格子
			{
				disposeAllNpcBattle();
				return;
			}*/
			// 存在并且可视才更新
			if (m_topEmptySprite)
			{
				if (m_topEmptySprite.followBeing)
				{
					if (m_topEmptySprite._visible)
					{
						m_topEmptySprite.onTick(deltaTime);
						m_botEmptySprite.onTick(deltaTime);
					}
				}
			}
		}
		
		public function createAsset():void
		{
			var id:String;
			var xSpritePos:int = m_xPos + m_gameFightController.gridWidth / 2;
			var ySpritePos:int = m_yPos + m_gameFightController.gridHeight / 2;
			var lScene:fScene = this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT);
			id = fUtil.elementID(this.m_gkContext.m_context, EntityCValue.TEmptySprite);
			m_topEmptySprite = lScene.createEmptySprite(fEmptySpriteForFight, id, xSpritePos, ySpritePos + m_gameFightController.topEmptySpriteYOff, 0) as fEmptySpriteForFight;
			m_topEmptySprite.m_fightDB = m_fightDB;
			// bug 每一个对象都要有一个唯一的 id
			id = fUtil.elementID(this.m_gkContext.m_context, EntityCValue.TEmptySprite);
			m_botEmptySprite = lScene.createEmptySprite(fEmptySpriteForFight, id, xSpritePos, ySpritePos - m_gameFightController.botEmptySpriteYOff, 0) as fEmptySpriteForFight;
			m_botEmptySprite.m_fightDB = m_fightDB;
			m_botEmptySprite.type = EntityCValue.EMPTBot;
			m_topEmptySprite.yOff = -m_gameFightController.topEmptySpriteYOff;
			m_botEmptySprite.yOff = m_gameFightController.botEmptySpriteYOff;
			m_gameFightController.npcBattleMgr.addEmptySprite(m_topEmptySprite);
			m_gameFightController.npcBattleMgr.addEmptySprite(m_botEmptySprite);
			
			m_topEmptySprite.needDepthSort = false;
			m_botEmptySprite.needDepthSort = false;
			/*var buffform:UIFightBuff = new UIFightBuff();
			
			   buffform.id = UIFormID.UIFightBuff + m_gridNO + 10 * m_gridNO;
			
			   buffform.x = 0;
			   buffform.y = -50;
			   m_buffform = buffform;
			   // 如果屏幕很小的时候，这个地方会有问题，因为不能看到的都裁剪掉了，因此有些格子被裁剪掉了，资源
			   var pnt:fFlash9EmptySpriteRenderer = m_topEmptySprite.customData.flash9Renderer as fFlash9EmptySpriteRenderer;
			   pnt.uiLayer.addChild(buffform);
			   buffform.gkcontext = m_gkContext;
			   buffform.onReady();
			 buffform.show();*/
			
			if (m_side == 0)
			{
				m_HPStrip = new HPStripLeft(this, m_gkContext);
			}
			else
			{
				m_HPStrip = new HPStripRight(this, m_gkContext);
			}			
			addToTopEmptySprite(m_HPStrip);
			m_HPStrip.y = -50;
		}
		
		public function addToTopEmptySprite(display:DisplayObject):void
		{
			var pnt:fFlash9EmptySpriteRenderer = m_topEmptySprite.customData.flash9Renderer as fFlash9EmptySpriteRenderer;			
			if (!pnt.assetsCreated)
			{
				pnt.createAssets();
			}			
			if (display.parent != pnt.uiLayer)
			{
				pnt.uiLayer.addChild(display);		
			}
		}
		public function disposeAllNpcBattle():void
		{
			m_state = EntityCValue.GSNormal;		// bug: 这个状态有时候不对,释放的时候需要重新设置这个状态
			m_attType = -1; // -1 表示没有设置过，需要设置			
			m_bindType = 0;
			
			m_xlastPos = 0;
			m_ylastPos = 0;

			if (m_HPStrip)
			{
				if (m_HPStrip.parent)
				{
					m_HPStrip.parent.removeChild(m_HPStrip);
				}
			}
			
			var being:NpcBattle;
			for each (being in m_beingList)
			{
				m_fightDB.m_bitmapRenderer.clearBeing(being);
				m_gameFightController.npcBattleMgr.destroyBeingByID(being.id);
			}
			m_beingList.length = 0;
			m_beingLiveList.length=0			
			m_beingRemovedList.length = 0;
			if (m_topEmptySprite)
			{
				//m_topEmptySprite.followBeing = null;
				//m_botEmptySprite.followBeing = null;
				// 紧紧清理里面的数据，以便更换部队或者回放的时候继续使用
				m_topEmptySprite.clearAll();
				m_botEmptySprite.clearAll();
				
				// 隐藏场景中显示
				m_topEmptySprite.hide();
				m_botEmptySprite.hide();
			}
			
			// 清理 UI 内容， UI 保存
			if (m_HPStrip != null)
			{
				m_HPStrip.disposeAllBuffer();
			}
		}
		
		public function dispose():void
		{
			if (m_topEmptySprite != null)
			{
				disposeAllNpcBattle();
				
				//m_buffform.exit();
				//m_buffform = null;
				
				(m_topEmptySprite.customData.flash9Renderer as fFlash9EmptySpriteRenderer).removeUI();
				//m_topEmptySprite.dispose();
				this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).removeEmptySprite(m_topEmptySprite);
				m_topEmptySprite.followBeing = null;
				m_topEmptySprite = null;
				
				(m_botEmptySprite.customData.flash9Renderer as fFlash9EmptySpriteRenderer).removeUI();
				//m_botEmptySprite.dispose();
				this.m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT).removeEmptySprite(m_botEmptySprite);
				m_botEmptySprite.followBeing = null;
				m_botEmptySprite = null;
			}
			
			if (m_HPStrip)
			{
				if (m_HPStrip.parent)
				{
					m_HPStrip.parent.removeChild(m_HPStrip);
				}
				m_HPStrip.dispose();
				m_HPStrip = null;
			}
			
			if (m_bufferList)
			{
				m_bufferList.length = 0;
				m_bufferList = null;
			}
			m_onEntered = null;
			m_matrixInfo = null;		
			m_gameFightController = null;
			m_fightDB = null;
			m_gkContext = null;
		}
		
		public function processValueEffect(eff:stValueEffect):void
		{
			if (eff.type >= FightEn.DAM && eff.type <= FightEn.DAMTYPE_VEREDUCEHP)
			{
				updateHp(eff.type, eff.value, 0);
			}
			else
			{
				if (eff.type == FightEn.DAMTYPE_VEADDSHIQI)
				{
					emitNamePicForShiqi(true);
				}
				else if (eff.type == FightEn.DAMTYPE_VEREDUCESHIQI)
				{
					emitNamePicForShiqi(false);				
				}
			}
			
			
			setHP(eff.curhp);
			setShiqi(eff.curshiqi);
		}
		// 更新 buff 相关的显示    grid : 更新的格子    battle : 战斗信息    stateidx : 这个格子状态索引    
		//public function updateBuff(battle:BattleArray, stateidx:int):void
		
		//public function addBuff(state:stEntryState):void
		
		public function emitNamePicForShiqi(up:Boolean):void
		{
			var type:int;
			var iPicName:int;
			if (up)
			{
				type = FightEn.NTUp;
				iPicName = stEntryState.PICName_ShiqiTisheng;
			}
			else
			{
				type = FightEn.NTDn;
				iPicName = stEntryState.PICName_Xiajiang;
			}
			emitNamePic(type, iPicName);
		}
		/*
		 * 部队身上显示增加（或减溢）效果图片
		 * type:FightEn.NTUp 增益
		 * 		FightEn.NTDn 减益
		 */
		public function emitNamePic(type:int, iPicName:int):void
		{
			var scene:fScene = m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT);
			m_fightDB.bbNameMgr.emitNamePicEx(type, iPicName, topEmptySprite.x, topEmptySprite.y - 220, scene.m_SceneLayer[EntityCValue.SLFog]);
		}
		public function addBuff(state:Object):void
		{
			var buffer:stEntryState = state as stEntryState;
			
			// 添加 buff 的时候还需头顶显示字
			var scene:fScene = m_gkContext.m_context.m_sceneView.scene(EntityCValue.SCFIGHT);
			m_fightDB.bbNameMgr.emitNamePic(buffer, topEmptySprite.x, topEmptySprite.y - 220, scene.m_SceneLayer[EntityCValue.SLFog]);
			
			processBufferValue(buffer);
			if (buffer.time == 0)
			{				
				return;
			}
			
			if (m_bufferList == null)
			{
				m_bufferList = new Vector.<stEntryState>();
			}
			var i:uint;
			var bAdd:Boolean = true;
			state.roundIndexOfAdd = m_curRoundIndex;
			
			for (i = 0; i < m_bufferList.length; i++)
			{
				if (m_bufferList[i].bufferID == state.bufferID)
				{
					m_bufferList[i] = state as stEntryState;
					bAdd = false;
					break;
				}
			}
			
			if (bAdd == true)
			{
				m_bufferList.push(state);
				m_HPStrip.addBuffer(state as stEntryState);
			}
		
		}
		
		//处理buffer的数值效果
		private function processBufferValue(buffer:stEntryState):void
		{
			switch (buffer.bufferID)
			{
				case FightEn.USTATE_SHIQIPROPMOT: 
				case FightEn.USTATE_SHIQIREDUCE: 
				{
					var add:int;
					var bUp:Boolean;
					if (buffer.bufferID == FightEn.USTATE_SHIQIPROPMOT)
					{
						add = buffer.value;
						bUp = true;
					}
					else
					{
						bUp = false;
						add = -buffer.value;
					}
					//this.emitNamePicForShiqi(bUp);
					//shiqi = shiqi + add;
					break;
				}
				case FightEn.BUFFERID_Methysis:					
				{
					/*var pv:PkValue = new PkValue();
					pv.type = FightEn.DAM_TYPE_Buffer_Methysis;
					pv.value = buffer.value;*/
					//updateHp(FightEn.DAM_TYPE_Buffer_Methysis, buffer.value, 0);
				}
			}
		}
		
		public function deleteBuff(buffID:uint):void
		{
			if (m_bufferList == null)
			{
				return;
			}
			var i:int;
			for (i = 0; i < m_bufferList.length; i++)
			{
				if (m_bufferList[i].bufferID == buffID)
				{
					m_HPStrip.deleteBuffer(m_bufferList[i]);
					m_bufferList.splice(i, 1);
					break;
				}
			}
		}
		
		// buff 只显示一个,或者增益或者减益
		public function getEntryStates():Vector.<stEntryState>
		{
			return m_bufferList;
		}
		
		public function beginNewRound(index:uint):void
		{
			m_curRoundIndex = index;
		}
		
		public function clearAllBuffer():void
		{
			if (m_bufferList == null)
			{
				return;
			}
			var i:uint;
			for (i = 0; i < m_bufferList.length; i++)
			{
				m_HPStrip.deleteBuffer(m_bufferList[i]);
			}
			if (m_bufferList)
			{
				m_bufferList.length = 0;
					// bug: 这个地方如果删除,如果是在 endRound -- updateHp -- die -- clearAllBuffer 这个函数遍历中删除,就会有问题
					//m_bufferList = null;
			}
		}
		
		public function endRound():void
		{
			if (m_bufferList == null)
			{
				return;
			}
			var i:uint;
			var state:stEntryState;
			var delList:Vector.<stEntryState>;
			for (i = 0; i < m_bufferList.length; i++)
			{
				state = m_bufferList[i];
				processBufferValue(state);
				if (m_curRoundIndex >= state.roundIndexOfAdd + state.time - 1)
				{
					if (delList == null)
					{
						delList = new Vector.<stEntryState>();
					}
					delList.push(state);
				}
			}
			
			if (delList != null)
			{
				var index:int;
				for (i = 0; i < delList.length; i++)
				{
					m_HPStrip.deleteBuffer(delList[i]);
					
					index = m_bufferList.indexOf(delList[i]);
					m_bufferList.splice(index, 1);
				}
				delList = null;
			}
		}
		
		public function get attType():int
		{
			return m_attType;
		}
		
		public function get bMoveWhenAttack():Boolean
		{
			return (attType != EntityCValue.ATTFar && (m_attBattle.attackedList.isEmpty==false))
		}
		
		public function get isPlayer():Boolean
		{
			return m_matrixInfo.isPlayer;
		}
		
		public function get bindType():uint
		{
			return m_bindType;
		}
		
		public function set bindType(value:uint):void
		{
			m_bindType = value;
		}
		
		public function setShiqi(v:int):void
		{			
			m_shiqi = v;
			if (m_shiqi < 0)
			{
				m_shiqi = 0;
			}
			var npcbattle:NpcBattle;
			for each (npcbattle in m_beingList)
			{
				npcbattle.shiqi = m_shiqi;				
			}
			for each (npcbattle in m_beingRemovedList)
			{
				npcbattle.shiqi = m_shiqi;				
			}
			if (m_fightDB.m_UIBattleTip != null && m_fightDB.m_UIBattleTip.isVisible())
			{
				m_fightDB.m_UIBattleTip.update(this);
			}
		
		}
		
		public function get shiqi():int
		{
			return m_shiqi;
		}
		
		public function chCharGI(bch:Boolean):void
		{
			var being:BeingEntity;
			for each (being in m_beingList)
			{
				being.m_affectByGI = !bch;
			}
		}
		
		/*
		 * 清除格子上关于部队的所有数据
		 * 
		 */ 
		public function clearBudui():void
		{
			clearAllBuffer();
			disposeAllNpcBattle();
			if (m_tianfu)
			{
				m_fightDB.m_tianfuMgr.releaseTianfu(m_tianfu);
			}
			m_matrixInfo = null;
		}
		protected function computeAttType():int
		{
			var ret:int = EntityCValue.ATTNear;
			
			if (isPlayer)
			{
				if (m_matrixInfo.m_npcBase.m_iType == 1)
				{
					// 如果是近攻，需要继续查找模型表中，近攻需要差距几个格子
					var modelItem:TModelEffItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_MODELEFF, fUtil.modelInsNum(m_matrixInfo.m_npcBase.npcBattleModel.m_strModel)) as TModelEffItem;
					if (modelItem)
					{
						ret = modelItem.m_attType;
					}
					else
					{
						ret = EntityCValue.ATTNear;
					}
				}
				else
				{
					ret = EntityCValue.ATTFar;
				}
			}
			else
			{
				if (m_matrixInfo.m_npcBase.m_iBingZhong < 2000)
				{
					modelItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_MODELEFF, fUtil.modelInsNum(m_matrixInfo.m_npcBase.npcBattleModel.m_strModel)) as TModelEffItem;
					if (modelItem)
					{
						ret = modelItem.m_attType;
					}
					else
					{
						ret = EntityCValue.ATTNear;
					}
				}
				else
				{
					ret = EntityCValue.ATTFar;
				}
			}
			
			return ret;
		}
		
		public function get tianfu():TianfuBase
		{
			return m_tianfu;
		}
		
		public function set tianfu(tianfu:TianfuBase):void
		{
			m_tianfu = tianfu;
		}
		
		public function getStateLog():String
		{
			var retLog:String="team="+m_side+" gridNO="+m_gridNO+"--";
			var npc:NpcBattle;
			for each(npc in m_beingList)
			{				
				retLog += npc.state + ", ";
			}	
			return retLog;
		}
		
		
		// 音效全部改成格子为单位,不是武将为单位
		// 播放攻击音效 skill : 是否是既能攻击
		public function playAttMsc(skill:Boolean):void
		{
			var jobstr:String;
			var mscid:uint;
			if (skill) // 如果是技能攻击
			{
				if (isPlayer) // 如果是玩家
				{
					if (m_matrixInfo.m_npcBase.m_uID == 1) // 男猛
					{
						mscid = 15;
						jobstr = "男猛";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 2) // 女猛
					{
						mscid = 17;
						jobstr = "女猛";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 3) // 男军
					{
						mscid = 19;
						jobstr = "男军";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 4) // 女军
					{
						mscid = 21;
						jobstr = "女军";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 5) // 男弓
					{
						mscid = 23;
						jobstr = "男弓";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 6) // 女弓
					{
						mscid = 25;
						jobstr = "女弓";
					}
					
					//Logger.info(null, null, "技能攻击-玩家-" + m_matrixInfo.m_npcBase.m_name + "-职业-" + jobstr + "-音乐" + "-" + mscid);
				}
				else // 如果是怪
				{
					switch (m_matrixInfo.m_npcBase.job)
					{
						case PlayerResMgr.JOB_MENGJIANG: 
						{
							mscid = 39;
							jobstr = "猛将";
							break;
						}
						case PlayerResMgr.JOB_JUNSHI: 
						{
							mscid = 41;
							jobstr = "军师";
							break;
						}
						case PlayerResMgr.JOB_GONGJIANG: 
						{
							mscid = 43;
							jobstr = "弓将";
							break;
						}
					}
					
					//Logger.info(null, null, "技能攻击-怪物-" + m_matrixInfo.m_npcBase.m_name + "-职业-" + jobstr + "-音乐" + "-" + mscid);
				}
			}
			else // 如果是普通攻击
			{
				if (isPlayer) // 如果是玩家
				{
					if (m_matrixInfo.m_npcBase.m_uID == 1) // 男猛
					{
						mscid = 27;
						jobstr = "男猛";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 2) // 女猛
					{
						mscid = 29;
						jobstr = "女猛";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 3) // 男军
					{
						mscid = 31;
						jobstr = "男军";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 4) // 女军
					{
						mscid = 33;
						jobstr = "女军";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 5) // 男弓
					{
						mscid = 35;
						jobstr = "男弓";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 6) // 女弓
					{
						mscid = 37;
						jobstr = "女弓";
					}
					
					//Logger.info(null, null, "普通攻击-玩家-" + m_matrixInfo.m_npcBase.m_name + "-职业-" + jobstr + "-音乐" + "-" + mscid);
				}
				else // 如果是怪
				{
					switch (m_matrixInfo.m_npcBase.job)
					{
						case PlayerResMgr.JOB_MENGJIANG: 
						{
							mscid = 45;
							jobstr = "猛将";
							break;
						}
						case PlayerResMgr.JOB_JUNSHI: 
						{
							mscid = 47;
							jobstr = "军师";
							break;
						}
						case PlayerResMgr.JOB_GONGJIANG: 
						{
							mscid = 49;
							jobstr = "弓将";
							break;
						}
					}
					
					//Logger.info(null, null, "普通攻击-怪物-" + m_matrixInfo.m_npcBase.m_name + "-职业-" + jobstr + "-音乐" + "-" + mscid);
				}
			}
			
			//Logger.info(null, null, "攻击音效" + mscid);
			m_gkContext.m_commonProc.playMsc(mscid);
		}
		
		// 播放攻击音效 skill : 是否是技能导致的受伤
		public function playHurtMsc(skill:Boolean):void
		{
			var mscid:uint;
			var jobstr:String;
			if (skill) // 如果是技能受伤
			{
				if (isPlayer) // 如果是玩家
				{
					if (m_matrixInfo.m_npcBase.m_uID == 1) // 男猛
					{
						mscid = 16;
						jobstr = "男猛";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 2) // 女猛
					{
						mscid = 18;
						jobstr = "女猛";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 3) // 男军
					{
						mscid = 20;
						jobstr = "男军";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 4) // 女军
					{
						mscid = 22;
						jobstr = "女军";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 5) // 男弓
					{
						mscid = 24;
						jobstr = "男弓";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 6) // 女弓
					{
						mscid = 26;
						jobstr = "女弓";
					}
					
					//Logger.info(null, null, "技能被击-玩家-" + m_matrixInfo.m_npcBase.m_name + "-职业-" + jobstr + "-音乐" + "-" + mscid);
				}
				else // 如果是怪
				{
					switch (m_matrixInfo.m_npcBase.job)
					{
						case PlayerResMgr.JOB_MENGJIANG: 
						{
							mscid = 40;
							jobstr = "猛将";
							break;
						}
						case PlayerResMgr.JOB_JUNSHI: 
						{
							mscid = 42;
							jobstr = "军师";
							break;
						}
						case PlayerResMgr.JOB_GONGJIANG: 
						{
							mscid = 44;
							jobstr = "弓将";
							break;
						}
					}
					
					//Logger.info(null, null, "技能被击-怪物-" + m_matrixInfo.m_npcBase.m_name + "-职业-" + jobstr + "-音乐" + "-" + mscid);
				}
			}
			else // 如果是普通受伤或者反击
			{
				if (isPlayer) // 如果是玩家
				{
					if (m_matrixInfo.m_npcBase.m_uID == 1) // 男猛
					{
						mscid = 28;
						jobstr = "男猛";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 2) // 女猛
					{
						mscid = 30;
						jobstr = "女猛";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 3) // 男军
					{
						mscid = 32;
						jobstr = "男军";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 4) // 女军
					{
						mscid = 34;
						jobstr = "女军";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 5) // 男弓
					{
						mscid = 36;
						jobstr = "男弓";
					}
					else if (m_matrixInfo.m_npcBase.m_uID == 6) // 女弓
					{
						mscid = 38;
						jobstr = "女弓";
					}
					
					//Logger.info(null, null, "普通被击-玩家-" + m_matrixInfo.m_npcBase.m_name + "-职业-" + jobstr + "-音乐" + "-" + mscid);
				}
				else // 如果是怪
				{
					switch (m_matrixInfo.m_npcBase.job)
					{
						case PlayerResMgr.JOB_MENGJIANG: 
						{
							mscid = 46;
							jobstr = "猛将";
							break;
						}
						case PlayerResMgr.JOB_JUNSHI: 
						{
							mscid = 48;
							jobstr = "军师";
							break;
						}
						case PlayerResMgr.JOB_GONGJIANG: 
						{
							mscid = 50;
							jobstr = "弓将";
							break;
						}
					}
					
					//Logger.info(null, null, "普通被击-怪物-" + m_matrixInfo.m_npcBase.m_name + "-职业-" + jobstr + "-音乐" + "-" + mscid);
				}
			}
			
			//Logger.info(null, null, "被击音效" + mscid);
			m_gkContext.m_commonProc.playMsc(mscid);
		}
	}
}