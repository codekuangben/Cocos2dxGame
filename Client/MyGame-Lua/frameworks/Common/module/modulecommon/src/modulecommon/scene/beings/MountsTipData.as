package modulecommon.scene.beings
{
	import modulecommon.GkContext;

	/**
	 * @brief 坐骑提示显示的时候传入的数据
	 * */
	public class MountsTipData
	{
		public var m_gkContext:GkContext;
		
		public var m_tipsType:int;			// 0 是坐骑图鉴中移动到坐骑上的提示， 1 是移动到玩家头向下，或者坐骑界面中坐骑图标上时候 2 就是移动到培养属性一项上去 3 类似 1 ，但是在最后一行显示[点击查看坐骑]一行
		
		// 移动到坐骑图鉴中的时候需要这两个属性
		public var m_bActived:Boolean;		// 是否激活
		public var m_mountsID:uint;			// 坐骑表中的 id

		public var m_mountsDataSys:MountsSys;		// 坐骑系统
		public var m_trainPropIdx:uint;		// 培养属性从 1 开始

		public function MountsTipData(gk:GkContext)
		{
			m_gkContext = gk;
		}
		
		public function reset():void
		{
			m_tipsType = 0;
			m_bActived = false;
			m_mountsID = 0;
		}
	}
}