package modulecommon.scene.beings
{
	/**
	 * ...
	 * @author ...
	 */
	public class MountsSkillTipData 
	{
		public var m_skillid:uint;
		public var m_hasNextSkill:Boolean;	// 是否拥有下一等级
		public var m_idxDesc:uint;			// 描述索引 0 就是 m_curSkillDesc 1 就是 m_nextSkillDesc
		
		public var m_curSkillDesc:String = "";		// 当前技能描述
		public var m_nextSkillDesc:String = "";		// 下一个技能描述
	}
}