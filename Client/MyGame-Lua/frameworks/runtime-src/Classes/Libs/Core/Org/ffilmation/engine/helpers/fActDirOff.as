package org.ffilmation.engine.helpers
{
	import flash.utils.Dictionary;

	/**
	 * @brief 动作方向偏移信息，本应该配置在配置文件中，但是...，现在配置在 tbl 表中了，从表中读取
	 * */
	public class fActDirOff
	{
		public var m_ModelOffDic:Dictionary;
		
		public function fActDirOff()
		{
			m_ModelOffDic = new Dictionary();
		}
		
		// 拷贝一个完整的数据
		public function copyFrom(rh:fActDirOff):void
		{
			var key:String;
			for (key in rh.m_ModelOffDic)
			{
				m_ModelOffDic[key] = new fOffList();
				m_ModelOffDic[key].copyFrom(rh.m_ModelOffDic[key]);
			}
		}
		
		// 根据帧数生成列表
		public function buildLstByFrameCnt(key:String, framecnt:uint):void
		{
			if (m_ModelOffDic[key])
			{
				m_ModelOffDic[key] = null;	// 清空之前的内容
			}
			
			m_ModelOffDic[key] = new fOffList();
			m_ModelOffDic[key].buildLstByFrameCnt(framecnt);
		}
	}
}