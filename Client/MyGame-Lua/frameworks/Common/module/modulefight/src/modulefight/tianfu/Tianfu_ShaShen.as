package modulefight.tianfu 
{
	import modulefight.FightEn;
	import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.scene.fight.FightGrid;
	/**
	 * ...
	 * @author ...
	 * 张飞
	 * 杀神:场上每死亡一人,自身士气增加25点
	 */
	public class Tianfu_ShaShen extends TianfuBase 
	{			
		public function Tianfu_ShaShen() 
		{
			super();
			m_type = TYPE_ServerTrigger;
		}
	}

}