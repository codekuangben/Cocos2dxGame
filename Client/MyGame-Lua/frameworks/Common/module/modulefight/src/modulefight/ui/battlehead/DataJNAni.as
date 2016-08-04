package modulefight.ui.battlehead
{
	import flash.display.DisplayObjectContainer;
	import modulecommon.scene.wu.JinnangItem;
	
	import modulecommon.scene.prop.skill.SkillMgr;
	
	import modulefight.netmsg.stmsg.JinNangProcess;
	
	/**
	 * @brief 锦囊动画特效需要的数据
	 * */
	public class DataJNAni
	{
		public static const RelNo:uint = 0; // 没有关系
		public static const RelKZ:uint = 1; // 克制关系
		public static const RelEqual:uint = 2; // 比较相等
		public static const RelNotEqual:uint = 3; //比较后，有一方被抑制
		
		public var m_jnProcess:JinNangProcess; // 锦囊特效需要的原始数据
		private var m_jinangRel:int;
		private var m_victoryJinnangItem:JinnangItem; //胜出锦囊对象
		public var m_firEndCB:Function; // 锦囊特效第一个阶段播放完成后的回调函数
		
		// 锦囊分阶段播放完成后的回调函数
		public var m_pzCB:Function; // 碰撞完成后的回调
		public var m_bzCB:Function; // 爆炸和锦囊名字显示完成后的回调
		public var m_justbzCB:Function; // 爆炸和锦囊名字显示完成后的回调
		
		public var m_decLvl:int; // 两边减少的等级
		public var m_jnCnter:DisplayObjectContainer; // 飞行的锦囊容器
		public var m_jnFly:Vector.<BatJinnangGridFly> = new Vector.<BatJinnangGridFly>(2, true); // 飞行的锦囊特效
		
		// 释放资源
		public function dispose():void
		{
			m_jnProcess = null;
			m_firEndCB = null;
			m_pzCB = null;
			m_bzCB = null;
			m_jnCnter = null;
			m_jnFly[0] = null;
			m_jnFly[1] = null;
			m_justbzCB = null;
		}
		
		public function setJnProcess(jp:JinNangProcess):void
		{
			m_jnProcess = jp;
			
			var aItem:JinnangItem = m_jnProcess.m_JNCastInfo.aJNItem;
			var bItem:JinnangItem = m_jnProcess.m_JNCastInfo.bJNItem;
			
			if (1 == jnCnt())
			{
				m_jinangRel = RelNo;
			}
			else if (SkillMgr.relBetJN(aItem.idInit, bItem.idInit)) // 克制
			{
				m_jinangRel = RelKZ;
			}
			else if (aItem.num == bItem.num) // 只要等级相等,就是相等比拼.并且 m_battleArray 为 null
			{
				m_jinangRel = RelEqual;
			}
			else
			{
				m_jinangRel = RelNotEqual;
			}
			
			if (m_jnProcess.m_battleArray)
			{
				if (m_jnProcess.m_battleArray.aTeamid == 0)
				{
					m_victoryJinnangItem = aItem;
				}
				else
				{
					m_victoryJinnangItem = bItem;
				}
			}
			else
			{
				m_victoryJinnangItem = null;
			}
			
			if (RelEqual == m_jinangRel) // 相等的时候不会发生战斗,因此 m_battleArray 这个是 null
			{
				m_decLvl = aItem.num; // 如果相等需要完全减到 0 
			}
			else if (RelNotEqual == m_jinangRel)
			{
				// 登记小的就是需要减少的数字
				m_decLvl = aItem.num > bItem.num ? bItem.num : aItem.num;
			}
		}
		
		// 获取锦囊释放的数量
		public function jnCnt():uint
		{
			return m_jnProcess.m_JNCastInfo.jnNum;
		}
		
		// 释放锦囊的一方 0 左边 1 右边
		public function jnSide():uint
		{
			return m_jnProcess.m_battleArray.aTeamid;
		}
		
		public function getJNI(side:uint):uint
		{
			return m_jnProcess.m_JNCastInfo.getJNIdLevelBySide(side);
		}	
		
		// 返回两个锦囊的关系 0 没有关系 1 克制 2 比较掉数字相等 3 攻击方获胜 4 被击方获胜
		public function relBetwJN():uint
		{
			return m_jinangRel;
		}
		
		public function getNumJinnang(side:int):int
		{
			if (side == 0)
			{
				var aItem:JinnangItem = m_jnProcess.m_JNCastInfo.aJNItem;
				if (aItem)
				{
					return aItem.num;
				}
			}
			else
			{
				var bItem:JinnangItem = m_jnProcess.m_JNCastInfo.bJNItem;
				if (bItem)
				{
					return bItem.num;
				}
			}
			return 0;
		}
		
		public function get victoryJinnangItem():JinnangItem
		{
			return m_victoryJinnangItem;
		}
		
		// 判断 side 是不是失败的一方
		public function ifFailSide(side:uint):Boolean
		{
			var aItem:JinnangItem = m_jnProcess.m_JNCastInfo.aJNItem;
			var bItem:JinnangItem = m_jnProcess.m_JNCastInfo.bJNItem;
			if (aItem && bItem)
			{
				if (side == 0)
				{
					return aItem.num < bItem.num;
				}
				else
				{
					return bItem.num < aItem.num;
				}
			}
			return false;
		}
	}
}