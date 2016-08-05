package common.scene.fight
{
	import adobe.utils.CustomActions;
	/**
	 * ...
	 * @author 
	 * @brief 攻击指令  
	 */
	public class AttackItem 
	{
		//protected var m_hurtIDVec:Vector.<String>;	// 受伤害者 ID 
		//protected var m_hurtTypeVec:Vector.<uint>;	// 受伤害者类型，例如 npc 人物等  
		//protected var m_dam:Vector.<uint>;			// 攻击伤害值  
		protected var m_targetList:Vector.<AttackTarget>;	// 被击列表   
		protected var m_attackAct:uint;			// 攻击动作   
		protected var m_hurtAct:uint;			// 受伤动作   
		protected var m_attackEffectID:String;	// 攻击特效 ID 
		protected var m_hurtEffectID:String;	// 受伤特效 ID 
		protected var m_delay:Number;			// 延迟时间，这个是动作延迟是时间
		protected var m_delayEff:Number;			// 延迟帧数，这个是特效延迟是时间
		protected var m_isPlayed:Boolean;		// 是否播放了  
		
		protected var m_attackType:uint;	// 0: 单攻， 1 群攻  2: 反击		
		public var m_skillBaseitem:Object;
		protected var m_callback:Function;		// 这个是回调函数，飞行特效用来通知其它进行相关的处理
		
		public function AttackItem() 
		{
			//m_hurtIDVec = new Vector.<String>();
			//m_hurtTypeVec = new Vector.<uint>();
			m_targetList = new Vector.<AttackTarget>();
			m_attackAct = 0;
			m_hurtAct = 0;
			m_attackEffectID = "";
			m_hurtEffectID = "";
			m_delay = 0;
			m_delayEff = 0;
			m_isPlayed = false;
			m_attackType = 0;
			m_skillBaseitem = null;
		}
		
		public function get attackAct():uint 
		{
			return m_attackAct;
		}
		
		public function set hurtAct(value:uint):void 
		{
			m_hurtAct = value;
		}
		
		public function get hurtAct():uint 
		{
			return m_hurtAct;
		}
		
		public function set attackAct(value:uint):void 
		{
			m_attackAct = value;
		}
		
		public function get attackEffectID():String 
		{
			return m_attackEffectID;
		}
		
		public function set attackEffectID(value:String):void 
		{
			m_attackEffectID = value;
		}
		
		public function get hurtEffectID():String 
		{
			return m_hurtEffectID;
		}
		
		public function set hurtEffectID(value:String):void 
		{
			m_hurtEffectID = value;
		}
		
		public function get delay():Number 
		{
			return m_delay;
		}
		
		// 默认是相同的
		public function set delay(value:Number):void 
		{
			m_delay = value;
		}
		
		public function get delayEff():Number
		{
			return m_delayEff;
		}
		
		// 单独设置特效时间，就和动作时间不一样了
		public function set delayEff(value:Number):void 
		{
			m_delayEff = value;
		}
		
		
		//public function get hurtIDVec():Vector.<String> 
		//{
			//return m_hurtIDVec;
		//}
	
		//public function pushHurtID(id:String, type:uint):void
		//{
			//m_hurtIDVec.push(id);
			//m_hurtTypeVec.push(type);
		//}
		
		public function get isPlayed():Boolean 
		{
			return m_isPlayed;
		}
		
		public function set isPlayed(value:Boolean):void 
		{
			m_isPlayed = value;
		}
		
		public function get attackType():uint 
		{
			return m_attackType;
		}
		
		public function set attackType(value:uint):void 
		{
			m_attackType = value;
		}
		
		public function get targetList():Vector.<AttackTarget> 
		{
			return m_targetList;
		}
		
		/*public function set targetList(value:Vector.<AttackTarget>):void 
		{
			m_targetList = value;
		}*/
				
		
		public function addTarget(target:AttackTarget):void
		{
			m_targetList.push(target);
		}
		
		//public function get hurtTypeVec():Vector.<uint> 
		//{
			//return m_hurtTypeVec;
		//}
		
		//public function set hurtTypeVec(value:Vector.<uint>):void 
		//{
			//m_hurtTypeVec = value;
		//}
		
		//public function get dam():uint 
		//{
			//return m_dam;
		//}
		//
		//public function set dam(value:uint):void 
		//{
			//m_dam = value;
		//}
		
		public function set callback(value:Function):void
		{
			m_callback = value;
		}
		
		public function get callback():Function
		{
			return m_callback;
		}
	}
}