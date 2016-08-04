package modulefight.scene.fight
{
	//import com.pblabs.engine.debug.Logger;
	//import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.DeferEffect;
	import com.pblabs.engine.entity.EntityCValue;
	//import modulefight.netmsg.stmsg.AttackedInfoGrid;
	//import modulefight.netmsg.stmsg.stValueEffect;
	//import modulefight.scene.battleContrl.BattleControlBase;
	//import modulefight.scene.battleContrl.BattleControlNearAttack;
	//import modulefight.scene.battleContrl.BattleControlFarAttack;
	//import modulefight.scene.battleContrl.BattleControlNoEnemy;
	//import modulefight.scene.fight.rank.RankSelfTeamEffectAction;
	
	//import common.scene.fight.AttackItem;
	//import common.scene.fight.AttackTarget;
	//import common.scene.fight.HurtItem;
	
	//import flash.geom.Point;
	
	//import modulecommon.appcontrol.UIBattleSceneShadow;
	//import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	//import modulecommon.ui.UIFormID;
	
	//import modulefight.FightEn;
	import modulefight.netmsg.stmsg.BattleArray;
	//import modulefight.netmsg.stmsg.DefList;
	//import modulefight.netmsg.stmsg.PkValue;
	//import modulefight.netmsg.stmsg.stEntryState;
	//import modulefight.scene.beings.NpcBattle;
	//import modulefight.scene.fight.rank.HexagonOrder;
	//import modulefight.scene.fight.rank.IRankFightAction;
	//import modulefight.scene.fight.rank.InplaceOrder;
	//import modulefight.scene.fight.rank.PentagonOrder;
	//import modulefight.scene.fight.rank.QuadOrder;
	//import modulefight.scene.fight.rank.RankAttHurtEnd;
	//import modulefight.scene.fight.rank.RankAttackAction;
	//import modulefight.scene.fight.rank.RankAttackEndAction;
	//import modulefight.scene.fight.rank.RankBufEffAction;
	//import modulefight.scene.fight.rank.RankCAttackAction;
	//import modulefight.scene.fight.rank.RankHurtAction;
	//import modulefight.scene.fight.rank.RankHurtEndAction;
	//import modulefight.scene.fight.rank.RankJNEndAction;
	//import modulefight.scene.fight.rank.RankMoveAction;
	//import modulefight.scene.fight.rank.TriangleOrder;
	
	import org.ffilmation.engine.helpers.fObjectDefinition;
	//import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.utils.mathUtils;
	
	/**
	 * @ brief 战斗动作回调
	 * */
	public class FightLogicCB
	{
		protected var m_fightDB:FightDB;
		
		public function FightLogicCB(value:FightDB)
		{
			m_fightDB = value;
		}
		
		/**
		 * @brief 在两边释放锦囊特效
		 * */
		public function playJinNangEffect(ba:BattleArray, side:uint):void
		{
			// 在某一边所有格子释放特效
			var skillitem:TSkillBaseItem;
			skillitem = ba.skillBaseitem;
			//skillitem = this.m_gkcontext.m_skillMgr.skillItem(3001);
			if (!skillitem || skillitem.m_jinnangEff.length == 0)
				return;
			var grid:FightGrid;
			var defer:DeferEffect;
			var xpos:uint;
			var ypos:uint;
			
			// 随机
			var timeList:Vector.<Number> = new Vector.<Number>();
			timeList.push(0);
			timeList.push(0.1);
			timeList.push(0.2);
			timeList.push(0.3);
			timeList.push(0.4);
			timeList.push(0.5);
			timeList.push(0.6);
			timeList.push(0.7);
			timeList.push(0.8);
			
			var totalcnt:uint = 9;
			var curidx:uint = 0;
			
			for each (grid in m_fightDB.m_fightGrids[side])
			{
				defer = new DeferEffect();
				if (side == EntityCValue.RKLeft)
				{
					xpos = grid.xPos - m_fightDB.m_gridWidth / 2;
					ypos = grid.yPos + m_fightDB.m_gridHeight / 2;
				}
				else
				{
					xpos = grid.xPos + m_fightDB.m_gridWidth / 2;
					ypos = grid.yPos + m_fightDB.m_gridHeight / 2;
				}
				
				// 要区分特效是否可以缩放，如果不能缩放，起始点直接放在格子中心，如果可以缩放，需要拉伸
				defer.m_defID = skillitem.m_jinnangEff;
				//defer.m_defID = "e13_e1213";
				
				var bscale:uint = 0;
				var insdef:fObjectDefinition;
				var insID:String;
				var delimit:int = defer.m_defID.indexOf("_");
				if (delimit != -1)
				{
					insID = defer.m_defID.substring(0, delimit);
					insdef = m_fightDB.m_gkcontext.m_context.m_sceneResMgr.getObjectDefinition(insID);
					bscale = insdef.bscaleV;
				}
				
				if (!bscale)
				{
					defer.m_startX = xpos;
					defer.m_startY = ypos;
				}
				else
				{
					defer.m_startX = xpos;
					defer.m_startY = ypos + skillitem.m_offY; // 这个需要在配置文件中
					//defer.m_startY = ypos - 200;	// 这个需要在配置文件中
					
					defer.m_endX = xpos;
					defer.m_endY = ypos;
				}
				defer.m_framerate = 0;
				defer.m_repeat = false;
				
				// 下层
				defer.m_defID1 = skillitem.m_jinnangEff1;
				
				delimit = defer.m_defID1.indexOf("_");
				if (delimit != -1)
				{
					insID = defer.m_defID1.substring(0, delimit);
					insdef = m_fightDB.m_gkcontext.m_context.m_sceneResMgr.getObjectDefinition(insID);
					bscale = insdef.bscaleV;
				}
				
				if (!bscale)
				{
					defer.m_startX1 = xpos;
					defer.m_startY1 = ypos;
				}
				else
				{
					defer.m_startX1 = xpos;
					defer.m_startY1 = ypos + skillitem.m_offY1; // 这个需要在配置文件中
					
					defer.m_endX1 = xpos;
					defer.m_endY1 = ypos;
				}
				defer.m_framerate1 = 0;
				defer.m_repeat1 = false;
				
				curidx = (int)(Math.random() * totalcnt);
				defer.m_delay = timeList[curidx];
				timeList.splice(curidx, 1);
				totalcnt -= 1;
				
				m_fightDB.m_effectMgr.addDeferSceneUIEffect(defer);
			}
		}
		
		// 播放锦囊特效完成后持续的特效
		public function playJinNangPostEffect(ba:BattleArray, side:uint):void
		{
			// 在某一边所有格子释放特效
			var skillitem:TSkillBaseItem;
			skillitem = ba.skillBaseitem;
			if (!skillitem || skillitem.m_jinnangPostEff.length == 0)
				return;
			
			var grid:FightGrid;
			var defer:DeferEffect;
			var xpos:uint;
			var ypos:uint;
			
			for each (grid in m_fightDB.m_fightGrids[side])
			{
				defer = new DeferEffect();
				if (side == EntityCValue.RKLeft)
				{
					xpos = grid.xPos - m_fightDB.m_gridWidth / 2;
					ypos = grid.yPos + m_fightDB.m_gridHeight / 2;
				}
				else
				{
					xpos = grid.xPos + m_fightDB.m_gridWidth / 2;
					ypos = grid.yPos + m_fightDB.m_gridHeight / 2;
				}
				
				// 要区分特效是否可以缩放，如果不能缩放，起始点直接放在格子中心，如果可以缩放，需要拉伸
				defer.m_defID = skillitem.m_jinnangPostEff;
				
				var bscale:uint = 0;
				var insdef:fObjectDefinition;
				var insID:String;
				var delimit:int = defer.m_defID.indexOf("_");
				if (delimit != -1)
				{
					insID = defer.m_defID.substring(0, delimit);
					insdef = m_fightDB.m_gkcontext.m_context.m_sceneResMgr.getObjectDefinition(insID);
					bscale = insdef.bscaleV;
				}
				
				defer.m_startX = xpos;
				defer.m_startY = ypos;
				defer.m_framerate = 0;
				defer.m_repeat = true;
				defer.m_type = EntityCValue.EFFJinNang;
				
				m_fightDB.m_effectMgr.createJinNangPostEff(defer);
				//m_fightDB.m_gkcontext.m_context.m_terrainManager.terrainEntity(EntityCValue.SCFIGHT).addJinNangPostEff(defer);
			}
		}
		
		// 是否可以退出战斗,1 战斗动画播放完成 2 各种界面显示完成
		public function canQuit():Boolean
		{
			return (m_fightDB.m_bOver == 3);
		}
		
		/*
		 * @ brief GI 人物改变，只有人物可能不受 GI 影响，所有特效都受 GI 影响。锦囊释放的时候，只有战斗双方高亮，其它都暗下
		 * */
		public function chCharGI(ba:BattleArray, bch:Boolean):void
		{
			/*
			var defitem:DefList;
			var grid:FightGrid;
			// 攻击方
			m_fightDB.m_fightGrids[ba.aTeamid][ba.aPos].chCharGI(bch);
			// 被击方
			
			var enemyGrids:Vector.<FightGrid> = m_fightDB.m_fightGrids[1 - ba.aTeamid];			
			var attackedList:Vector.<AttackedInfoGrid> = ba.attackedList.list;
			var attackedInfo:AttackedInfoGrid;
			for each(attackedInfo in attackedList)	
			{
				enemyGrids[attackedInfo.pos].chCharGI(bch);
			}
			
			// 如果影响，就是说明恢复 GI 数值
			if (!bch)
			{
				m_fightDB.m_fightscene.environmentLight.intensity = 100;
			}
			else
			{
				m_fightDB.m_intensity = 60;
			}
			
			m_fightDB.m_bchGI = bch;
			*/
			
			// 如果影响，就是说明恢复 GI 数值
			if (!bch)
			{
				m_fightDB.m_fightscene.environmentLight.intensity = 100;
			}
			else
			{
				m_fightDB.m_intensity = 60;
			}
			
			m_fightDB.m_bchGI = bch;
		}		
		
		// 计算从一个格子到另外一个格子的时间
		public function calcTimeBetGrid(ba:BattleArray):Number
		{
			// 计算真正的距离,不近似计算 X 轴的距离
			//return (Math.abs(m_fightDB.m_fightGrids[ba.aTeamid][ba.aPos].xPos - m_fightDB.m_fightGrids[1 - ba.aTeamid][ba.defData[0].bPos].xPos))/EntityCValue.VelMove;
			// 真实的计算距离
			var dist:Number = 0;
			var attgrid:FightGrid = m_fightDB.m_fightGrids[ba.aTeamid][ba.aGridNO];
			if (attgrid.side == EntityCValue.RKLeft)
			{
				dist = mathUtils.distance(attgrid.xlastPos, attgrid.ylastPos, attgrid.xPos, attgrid.yPos);
			}
			else
			{
				dist = mathUtils.distance(attgrid.xPos, attgrid.yPos, attgrid.xlastPos, attgrid.ylastPos);
			}
			
			return dist / m_fightDB.m_moveVel;
		}		
	}
}