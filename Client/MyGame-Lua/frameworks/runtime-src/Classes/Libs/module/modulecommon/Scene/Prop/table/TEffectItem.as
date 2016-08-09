package modulecommon.scene.prop.table
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * ... 
	 * @brief 特效配置表    
	 */
	public class TEffectItem extends TDataItem
	{
		public var m_effOff:Point;
		public var m_strScale:String;		// 每一帧模型缩放
		
		// 变换后的字符串
		public var m_frame:int;			// 总共帧数
		public var m_frame2scale:Dictionary;	// 帧数到缩放的映射
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			var streffoff:String;
			var effoffArr:Array;
			streffoff = TDataItem.readString(bytes);
			effoffArr = streffoff.split(",");
			
			m_effOff = new Point();
			m_effOff.x = parseInt(effoffArr[0]);
			m_effOff.y = parseInt(effoffArr[1]);
			
			m_strScale = TDataItem.readString(bytes);
			
			// 解析模型缩放字符串
			var strlist:Array;
			var onelist:Array;
			var idx:uint = 0;
			var key:int;
			if(m_strScale && m_strScale.length)
			{
				m_frame2scale ||= new Dictionary();
				strlist = m_strScale.split(";");
				
				while(idx < strlist.length)
				{
					// 第一个是帧数
					if(!idx)
					{
						m_frame = parseInt(strlist[idx]);
					}
					else
					{
						onelist = strlist[idx].split(":");
						key = parseInt(onelist[0]);
						onelist = onelist[1].split(",");
						m_frame2scale[key - 1] = new Point(parseInt(onelist[0]), parseInt(onelist[1]));
					}
					
					++idx;
				}
			}
		}
	}
}