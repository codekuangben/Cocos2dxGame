package modulecommon.scene.hero 
{
	import modulecommon.scene.prop.table.TAttrBufferItem;
	/**
	 * ...
	 * @author ...
	 * buffer信息
	 */
	public class ItemBuffer 
	{
		public var m_name:String;
		public var m_leftTime:uint;
		public var m_coef:uint;
		public var m_objID:uint;		//buffer对应道具id(如果有)
		public var m_vecEffect:Vector.<EffectBuffer>;	//效果列表
		public var m_bufferBase:TAttrBufferItem;
		public var m_level:int;			//buffer等级(无等级=0)
		
		public function ItemBuffer() 
		{
			m_vecEffect = new Vector.<EffectBuffer>();
			m_level = 0;
		}
		
		public function get bufferID():uint
		{
			return m_bufferBase.m_uID;
		}
		
		public function get leftTime():uint
		{
			return m_leftTime;
		}
		
		public function get type():int
		{
			return m_bufferBase.m_type;
		}
		
		public function get name():String
		{
			if (null == m_name)
			{
				return m_bufferBase.m_name;
			}
			else
			{
				return m_name;
			}
		}
		
		public function get iconName():String
		{
			var ret:String;
			
			if (0 == m_level)
			{
				return m_bufferBase.m_icon;
			}
			
			if (AttrBufferMgr.TYPE_YAOSHUI == m_bufferBase.m_type)
			{
				ret = m_bufferBase.m_icon.substr(0, m_bufferBase.m_icon.length - 1);
				ret += m_level.toString();
			}
			else
			{
				ret = m_bufferBase.m_icon;
			}
			
			return ret;
		}
	}

}