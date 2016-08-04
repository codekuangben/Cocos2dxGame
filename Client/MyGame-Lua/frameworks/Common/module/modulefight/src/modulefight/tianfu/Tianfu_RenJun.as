package modulefight.tianfu 
{
	/**
	 * ...
	 * @author ...
	 * 仁君:本军每死亡一名武将则全军提升士气50点，由服务器触发
	 */
	import modulefight.FightEn;
	import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.scene.fight.FightGrid;
	public class Tianfu_RenJun extends TianfuBase 
	{
				
		public function Tianfu_RenJun() 
		{
			super();
			m_type = TYPE_ServerTrigger;		
		}	
	}

}