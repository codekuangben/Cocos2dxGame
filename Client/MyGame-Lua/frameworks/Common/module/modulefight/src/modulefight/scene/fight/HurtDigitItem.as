package modulefight.scene.fight
{
	import com.pblabs.engine.entity.EntityCValue;
	/**
	 * ...
	 * @author 
	 * @brief 掉血数字 
	 */
	public class HurtDigitItem 
	{		
		public var m_type:uint = EntityCValue.HDHurtDigit;		// 掉血数字的类型  
		public var m_life:Number = 3.0;	// 生存时间，单位秒    
		public var m_elapse:Number = 0.0;	// 已经过去的时间  
		public var m_delay:Number = 0.0;	// 延迟时间    
		
		public var m_xOff:Number = 0;		// X 偏移的绝对值 
		public var m_yOff:Number = 0;		// X 偏移的绝对值 
		
		public var m_variant:Object;		// 变化的内容，根据 HDDigit 常量的内容取出不同的内容    
		public var m_alpha:Number = 1;		// alpha 值    
		//public var m_bAdd:Boolean = false;	// 数字显示 + 还是 -    
	}
}