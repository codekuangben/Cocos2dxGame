package com.pblabs.engine.resource
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 * @brief swf 图片序列辅助类   
	 */
	public class SWFAid 
	{
		// BitmapData 类优化，只保存一个 BitmapData ，公用这个 BitmapData 。
		public var m_class2BitmapDataDic:Dictionary;
		public var m_picCnt:uint;		// 资源包中总共的图片数量   
		public var m_width:uint;		// 图片的宽度   
		public var m_height:uint;		// 图片的高度  
		public var m_binit:Boolean;		// 基本信息是否初始化    
		
		public function SWFAid() 
		{
			m_binit = false;
			m_class2BitmapDataDic = new Dictionary();
		}
		
		public function dispose():void
		{
			var key:String;
			for(key in m_class2BitmapDataDic)
			{
				m_class2BitmapDataDic[key].dispose();
				m_class2BitmapDataDic[key] = null;
			}
			
			m_class2BitmapDataDic = null;
		}
	}
}