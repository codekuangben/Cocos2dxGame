package net 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ContentBuffer 
	{
		//这里定义专用的key,
		public static const KEY_GOTO:String = "goto";	//自动寻路到某个地点
		public static const OBJECT_Chaifen:String = "object_chaifen";	//道具拆分信息缓存
		public static const JIANGHUN_GetAni:String = "jianghun_GetAniAfterScene";	//得到将魂动画			
		
		private var m_dicContent:Dictionary;
		public function ContentBuffer() 
		{
			m_dicContent = new Dictionary;
		}
		
		public function addContent(key:String, obj:Object):void
		{
			m_dicContent[key] = obj;
		}
		
		public function getContent(key:String, bDelete:Boolean):Object
		{
			if (m_dicContent[key] == undefined)
			{
				return null;
			}
			var obj:Object = m_dicContent[key];
			if (bDelete)
			{				
				m_dicContent[key] = null;
				delete m_dicContent[key];				
			}
			return obj;
		}
		
		public function delContent(key:String):void
		{
			if (m_dicContent[key] == undefined)
			{
				return;
			}
			delete m_dicContent[key];
		}
		
	}

}