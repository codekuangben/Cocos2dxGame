package modulecommon.net.msg.propertyUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import modulecommon.scene.prop.object.T_Object;
	import flash.utils.ByteArray;
	public class stAddUserObjListPropertyUserCmd extends stPropertyUserCmd 
	{
		public var list:Array;
		public function stAddUserObjListPropertyUserCmd() 
		{
			byParam = ADDUSEROBJECT_LIST_PROPERTY_USERCMD;
			list = new Array();
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			var dataSize:uint = byte.readUnsignedInt();
			var num:uint = byte.readUnsignedShort();
			
			var i:uint = 0;
			var tobject:T_Object;
			while (i < num)
			{
				tobject = new T_Object();
				tobject.deserialize(byte);
				list.push(tobject);
				i++;
			}			
		}
	}

}

/*
 * //玩家上线打包发送玩家身上所有道具
	const BYTE ADDUSEROBJECT_LIST_PROPERTY_USERCMD = 7;
	struct stAddUserObjListPropertyUserCmd : public stPropertyUserCmd
	{
		stAddUserObjListPropertyUserCmd()
		{
			byParam = ADDUSEROBJECT_LIST_PROPERTY_USERCMD;
			num = 0;
		}
		WORD num;		
		t_ObjData list[0];
	};
*/