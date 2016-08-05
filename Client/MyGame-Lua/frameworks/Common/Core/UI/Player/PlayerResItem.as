package ui.player 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class PlayerResItem
	{
		public var modelName:String;
		public var uiName:String;
		public var classname:String;		// 很大的半身像的类名字
		public function PlayerResItem(model:String, name:String, clsname:String)
		{
			modelName = model;
			uiName = name;
			classname = clsname;
		}
	}
}