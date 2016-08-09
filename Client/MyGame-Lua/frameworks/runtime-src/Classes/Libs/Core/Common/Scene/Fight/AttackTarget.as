package common.scene.fight
{
	/**
	 * ...
	 * @author 
	 * @brief 攻击目标   
	 */
	public class AttackTarget 
	{
		protected var m_hurtID:String;		// 受伤害者 ID 
		protected var m_hurtType:uint;		// 受伤害者类型，例如 npc 人物等  
		protected var m_dam:uint;			// 攻击伤害值  
		
		public function get hurtID():String 
		{
			return m_hurtID;
		}
		
		public function set hurtID(value:String):void 
		{
			m_hurtID = value;
		}
		
		public function get hurtType():uint 
		{
			return m_hurtType;
		}
		
		public function set hurtType(value:uint):void 
		{
			m_hurtType = value;
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