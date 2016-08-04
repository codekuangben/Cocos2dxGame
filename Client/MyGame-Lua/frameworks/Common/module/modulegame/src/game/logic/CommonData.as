package game.logic
{
	/**
	 * @brief 全局数据共享的地方.
	 */
	public class CommonData
	{
		public var m_bNoQuery:Boolean;		// 是否询问花 5 元宝
		public var m_objlist:Array;			//万位:标签编号 千百十:物品编号 个位:是否购买
		
		// 跑商
		public var m_bOpenPaoShang:Boolean;	// 是否打开跑商界面
	}
}