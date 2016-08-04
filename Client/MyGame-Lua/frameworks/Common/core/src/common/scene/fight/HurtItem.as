package common.scene.fight
{
	/**
	 * ...
	 * @author 
	 * @brief 伤害指令   
	 */
	public class HurtItem 
	{
		protected var m_attackID:String;	// 攻击者 ID 
		protected var m_hurtAct:uint;		// 受伤动作   
		protected var m_hurtEffectID:String;// 受伤特效 ID，上层
		protected var m_hurtEffectID1:String;// 受伤特效 ID，下层
		protected var m_delay:Number;		// 延迟时间  
		protected var m_isPlayed:Boolean;	// 是否播放了  
		protected var m_dam:uint;			// 伤害值，就是掉血   
		public var m_hurtType:uint;		// 受伤类型，正常受伤还是反击，表现不一样
		
		public function HurtItem() 
		{
			m_attackID = "";
			m_hurtAct = 0;
			m_hurtEffectID = "";
			m_hurtEffectID1 = "";
			m_delay = 0;
			m_isPlayed = false;
		}
		
		public function get hurtAct():uint 
		{
			return m_hurtAct;
		}
		
		public function set hurtAct(value:uint):void 
		{
			m_hurtAct = value;
		}
		
		public function get hurtEffectID():String 
		{
			return m_hurtEffectID;
		}
		
		public function set hurtEffectID(value:String):void 
		{
			m_hurtEffectID = value;
		}
		
		public function get hurtEffectID1():String 
		{
			return m_hurtEffectID1;
		}
		
		public function set hurtEffectID1(value:String):void 
		{
			m_hurtEffectID1 = value;
		}
		
		public function get delay():Number 
		{
			return m_delay;
		}
		
		public function set delay(value:Number):void 
		{
			m_delay = value;
		}
		
		public function get attackID():String 
		{
			return m_attackID;
		}
		
		public function set attackID(value:String):void 
		{
			m_attackID = value;
		}
		
		public function get isPlayed():Boolean 
		{
			return m_isPlayed;
		}
		
		public function set isPlayed(value:Boolean):void 
		{
			m_isPlayed = value;
		}
		
		public function get dam():uint 
		{
			return m_dam;
		}
		
		public function set dam(value:uint):void 
		{
			m_dam = value;
		}
	}
}