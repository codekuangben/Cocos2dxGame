package modulecommon.net.msg.xingMaiCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class stSkillActive 
	{
		public var m_skillBaseID:uint;			//技能id
		public var m_herosVec:Vector.<uint>;//激活武将列表  最多5个武将
		
		public function stSkillActive() 
		{
			m_skillBaseID = 0;
			m_herosVec = new Vector.<uint>(5);
		}
		
		public function deserialize(byte:ByteArray):void
		{
			m_skillBaseID = byte.readUnsignedInt();
			
			for (var i:int = 0; i < 5; i++)
			{
				m_herosVec[i] = byte.readUnsignedInt();
			}
		}
		
		//return 技能当前等级id
		public function get skillLevelID():uint
		{
			var level:uint = 0;
			var i:int;
			for (i = 0; i < 5; i++)
			{
				if (m_herosVec[i])
				{
					level += (m_herosVec[i] % 10) + 1;
				}
			}
			
			return (m_skillBaseID + level)
		}
	}

}

/*
	struct stSkillActive
	{
		DWORD skillid;
		DWORD heros[5];
		stSkillActive()
		{
			skillid = 0;
			bzero(heros,sizeof(heros));
		}
	};
*/