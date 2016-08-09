package modulecommon.scene.prop.table 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.hero.EffectBuffer;
	/**
	 * ...
	 * @author ...
	 * 人物属性加成 - Buffer表
	 */
	public class TAttrBufferItem extends TDataItem
	{
		public var m_name:String;		//buffer名称
		public var m_type:uint;			//类型
		public var m_desc:String;		//描述
		public var m_effect:String;		//效果
		public var m_icon:String;		//图片
		
		public var m_effectList:Vector.<EffectBuffer>;
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			m_name = TDataItem.readString(bytes);
			m_type = bytes.readByte();
			m_desc = TDataItem.readString(bytes);
			m_effect = TDataItem.readString(bytes);
			m_icon = TDataItem.readString(bytes);
			
			var efflist:Array;
			var fmlist:Array;
			var effect:EffectBuffer;
			var i:int;
			
			m_effectList = new Vector.<EffectBuffer>();
			efflist = m_effect.split(":");
			
			for (i = 0; i < efflist.length; i++)
			{
				if (efflist[i] && ("" != efflist[i]))
				{
					effect = new EffectBuffer();
					fmlist = efflist[i].split("-");
					effect.m_type = parseInt(fmlist[0]);
					if (fmlist.length)
					{
						effect.m_value = parseInt(fmlist[1]);
					}
					
					m_effectList.push(effect);
				}
			}
		}
		
	}

}