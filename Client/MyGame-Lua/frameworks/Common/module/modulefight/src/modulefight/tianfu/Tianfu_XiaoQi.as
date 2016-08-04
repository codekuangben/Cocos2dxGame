package modulefight.tianfu 
{
	import modulefight.FightEn;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.DefList;
	import modulefight.netmsg.stmsg.stEntryState;
	/**
	 * ...
	 * @author ...
	 * 周俞4激活修改
小气:对敌人造成的伤害提升10%
客户端表现：周瑜每次攻击时时周瑜身上出现
	 */
	public class Tianfu_XiaoQi extends TianfuBase 
	{
		
		public function Tianfu_XiaoQi() 
		{
			super();
			m_type = TYPE_AttackBegin;
		}
		override public function isTriger(param:Object = null):Boolean 
		{
			return true;
			/*var bat:BattleArray = param as BattleArray;
			if (bat.aTeamid == m_fightGrid.side)
			{
				return false;
			}
			
			if (bat.attackedList.isAttacked(m_fightGrid.gridNO))
			{
				return true;
			}	
		
			return false;*/
		}
		override public function exec(param:Object = null):void 
		{
			super.exec();
			//m_fightGrid.shiqi += 50;
			//m_fightGrid.emitNamePic(FightEn.NTUp, stEntryState.PICName_ShiqiTisheng);
		}
		
	}

}