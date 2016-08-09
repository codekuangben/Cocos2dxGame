package modulecommon.net.msg.propertyUserCmd 
{
	import flash.utils.ByteArray;
	
	import modulecommon.scene.prop.object.T_Object;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stAddObjectPropertyUserCmd extends stPropertyUserCmd 
	{
		public static const OBJACTION_OPTAIN:int = 0;	//获取道具
		public static const OBJACTION_DROP:int = 1;	
		public static const OBJACTION_REFRESH:int = 2;	//刷新道具
		
		public var actionType:uint;
		public var isani:uint;
		public var tobject:T_Object;
		public function stAddObjectPropertyUserCmd() 
		{
			byParam = ADDUSEROBJ_PROPERTY_USRECMD;
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			actionType = byte.readUnsignedByte();
			isani = byte.readUnsignedByte();
			tobject = new T_Object;
			tobject.deserialize(byte);
		}
		
	}

}

/*
 * //定义道具动作
	enum
	{
		OBJACTION_OPTAIN = 0,	//获取道具
		OBJACTION_DROP,	//丢弃道具
		OBJACTION_REFRESH,	//刷新道具
	};

	const BYTE ADDUSEROBJ_PROPERTY_USRECMD = 1;
	struct stAddObjectPropertyUserCmd : public stPropertyUserCmd
	{
		stAddObjectPropertyUserCmd()
		{
			byParam = ADDUSEROBJ_PROPERTY_USRECMD;
			actionType = 0;
            isani = 0;
		}
		BYTE actionType;	//道具动作
		BYTE isani;     //是否播放动画 0-播放动画 1-不播放动画 2-战斗结束之后播放动画
		t_ObjData data;	
	};
*/