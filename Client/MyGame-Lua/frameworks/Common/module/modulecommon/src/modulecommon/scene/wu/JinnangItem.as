package modulecommon.scene.wu 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class JinnangItem 
	{		
		public var idInit:uint;		
		public var num:uint;		
		public function get idLevel():uint
		{
			
			if (num > 10)
			{
				num = 10;
			}
			
			return idInit + num - 1;			
		}
		
		public function set idLevel(id:uint):void
		{
			num = id % 100;
			idInit = ((int)(id / 100))*100 + 1;
		}
	}

}