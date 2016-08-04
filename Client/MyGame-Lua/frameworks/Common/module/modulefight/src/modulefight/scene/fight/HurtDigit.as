package modulefight.scene.fight
{
	import com.pblabs.engine.entity.EntityCValue;
	import common.Context;
	/**
	 * ...
	 * @author 
	 * @brief 所有的掉血数据，目前仅仅是向上飞数字，旋转之类的不支持      
	 */
	public class HurtDigit 
	{
		public var m_hurtDigitVec:Vector.<HurtDigitItem>;
		
		public function HurtDigit() 
		{
			m_hurtDigitVec = new Vector.<HurtDigitItem>();
		}
		
		// 每一帧更新数据   
		public function onTick(deltaTime:Number, context:Context):void
		{
			var idx:int = m_hurtDigitVec.length - 1;
			while(idx >= 0)
			{
				if (m_hurtDigitVec[idx].m_delay <= 0)
				{
					m_hurtDigitVec.splice(idx, 1);
				}
				else
				{
					m_hurtDigitVec[idx].m_delay -= deltaTime;
				}
				
				--idx;
			}
		}
		
		// 添加一个伤血或者回血数字   
		public function addHurtDigit(content:Object, delay:Number, type:uint):void
		{
			m_hurtDigitVec.push(new HurtDigitItem());
			m_hurtDigitVec[m_hurtDigitVec.length - 1].m_type = type;
			m_hurtDigitVec[m_hurtDigitVec.length - 1].m_delay = delay;
			m_hurtDigitVec[m_hurtDigitVec.length - 1].m_variant = content;
		}
	}
}