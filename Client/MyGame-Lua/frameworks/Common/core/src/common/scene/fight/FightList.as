package common.scene.fight
{
	import com.pblabs.engine.entity.IFightObject;
	/**
	 * ...
	 * @author 
	 * @brief 战斗列表 
	 */
	public class FightList 
	{
		public var m_attackVec:Vector.<AttackItem>;
		public var m_hurtVec:Vector.<HurtItem>;
		protected var m_fight:IFightObject;
		
		public function FightList(fight:IFightObject) 
		{
			m_attackVec = new Vector.<AttackItem>();
			m_hurtVec = new Vector.<HurtItem>();
			m_fight = fight;
		}
		
		public function addAttackItem(item:AttackItem):void
		{
			m_attackVec.push(item);
		}
		
		public function addHurtItem(item:HurtItem):void
		{
			m_hurtVec.push(item);
		}
		
		// 进行攻击和受伤消息的处理，然后分发给承受者    
		public function onTick(deltaTime:Number):void
		{
			// 攻击
			var attItem:AttackItem;
			for each(attItem in m_attackVec)
			{
				if (!attItem.isPlayed)
				{
					attItem.delay -= deltaTime;
					if (attItem.delay <= 0)
					{
						m_fight.playAttack(attItem);
						attItem.isPlayed = true;
					}
				}
			}
			
			// 受伤   
			var hurtItem:HurtItem;
			for each(hurtItem in m_hurtVec)
			{
				if (!hurtItem.isPlayed)
				{
					hurtItem.delay -= deltaTime;
					if (hurtItem.delay <= 0)
					{
						m_fight.playHurt(hurtItem);
						hurtItem.isPlayed = true;
					}
				}
			}
		}
	}
}