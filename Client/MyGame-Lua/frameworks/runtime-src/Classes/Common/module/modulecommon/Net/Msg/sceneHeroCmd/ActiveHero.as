package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang	 * 
	 * 一个武将有1到4个激活武将。其每个激活武将用ActiveHero结构来描述
	 * “激活武将”表示用于激活另一个武将的武将
	 */
	public class ActiveHero 
	{
		public var id:uint;			//激活武将的ID(合成)
		public var bOwned:Boolean;	//是否拥有该武将
		public function get tableID():uint
		{
			return id / 10;
		}
		
	}

}