package modulefight.scene.fight
{
	import com.pblabs.engine.entity.EntityCValue;	

	/**
	 * ...
	 * @author 
	 * @brief 技能数据    
	 */
	public class SkillData 
	{
		protected var m_skillBaseitem:Object;		
		protected var m_skillState:uint;	// 技能状态，两个状态，准备-攻击
		protected var m_curFrame:int;		// 当前帧数，好在某一帧释放特效
		protected var m_firCycle:Boolean;	// 是否是某一帧的第一次循环中，一帧中坑内有几次大循进入，以第一次为准
		
		public function SkillData()
		{
			reset();
		}
		
		public function get skillBaseItem():Object 
		{
			return m_skillBaseitem;
		}
		
		public function set skillBaseItem(item:Object):void 
		{
			reset();
			
			m_skillBaseitem = item;			
			
			// 更改技能 ID 时候，更改状态  
			//m_skillState = EntityCValue.SSPRE;
			// 如果是技能在这里设置这个值
			//m_curFrame = -1;
			//m_firCycle = true;	// 真个设置为 true，因为第 0 帧第一次进入肯定是第一次循环，程序是先执行，然后再改变这个 m_curFrame
		}
		
		public function get skillState():uint 
		{
			return m_skillState;
		}
		
		public function set skillState(value:uint):void 
		{
			m_skillState = value;
			m_curFrame = -1;
		}
		
		public function get curFrame():uint 
		{
			return m_curFrame;
		}
		
		public function set curFrame(value:uint):void 
		{
			// 如果是第一次帧改变，就是第一次进入这一帧
			if(m_curFrame != value)
			{
				m_firCycle = true;
			}
			else
			{
				m_firCycle = false;
			}
			
			m_curFrame = value;
		}
		
		// 复位所有的状态，如果设置 curFrame = 0 ，应该通过 reset 这个函数
		public function reset():void
		{
			m_skillBaseitem = null;
			m_skillState = EntityCValue.SSPRE;
			m_curFrame = -1;
			m_firCycle = true;	// 真个设置为 true，因为第 0 帧第一次进入肯定是第一次循环，程序是先执行，然后再改变这个 m_curFrame
		}
		
		// 判断 frame 当前帧是不是当前的帧数 
		public function equal(frame:int):Boolean
		{
			if(m_curFrame == frame && m_firCycle)
			{
				return true;
			}
			
			return false;
		}
		
		// 递增帧计数，不能手工增加帧数，需要按照动画的帧数走，正常来说是按照技能或者普通攻击的的攻击动作帧数走
		public function incFrame():void
		{
			++m_curFrame;
		}
		
		public function get firCycle():Boolean
		{
			return m_firCycle;
		}
	}
}