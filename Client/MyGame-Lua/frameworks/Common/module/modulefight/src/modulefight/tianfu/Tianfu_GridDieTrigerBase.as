package modulefight.tianfu 
{
	//import adobe.utils.CustomActions;
	import modulefight.scene.fight.FightGrid;
	/**
	 * ...
	 * @author ...
	 */
	public class Tianfu_GridDieTrigerBase extends TianfuBase 
	{
		protected var m_listFightDie:Vector.<FightGrid>;
		public function Tianfu_GridDieTrigerBase() 
		{
			super();
			m_type = TYPE_BuDuDie;
			m_listFightDie = new Vector.<FightGrid>();
		}
		
		public function onFightGridDie(fightGrid:FightGrid):void
		{
			
		}
	}

}