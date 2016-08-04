package modulefight.tianfu 
{
	import modulefight.FightEn;
	import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.netmsg.stmsg.stMatrixInfo;
	import modulefight.scene.fight.FightGrid;
	/**
	 * ...
	 * @author ...在多人副本之中，如何找到自己的主公？
	 * 缔盟:每回合开始时恢复主公(主角)10%兵力与25点士气
	 */
	public class Tianfu_DiMeng extends TianfuBase 
	{
		
		public function Tianfu_DiMeng() 
		{
			super();
			m_type = TYPE_ServerTrigger;
		}		
	}

}