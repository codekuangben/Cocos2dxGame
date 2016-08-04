package game.ui.uipaoshangsys.msg 
{
	import com.pblabs.engine.entity.EntityCValue;
	import flash.utils.ByteArray;
	import modulecommon.net.msg.paoshangcmd.stBusinessCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class retBeginBusinessUserCmd extends stBusinessCmd
	{
		public var time:uint;
		public var value:uint;
		public var shop:Vector.<uint>;
		
		public function retBeginBusinessUserCmd()
		{
			super();
			byParam = stBusinessCmd.RET_BEGIN_BUSINESS_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			time = byte.readUnsignedInt();
			value = byte.readUnsignedInt();
			
			shop = new Vector.<uint>();
			var idx:uint = 0;
			while (idx < EntityCValue.MAX_BUSINESS_SHOP_NUM)
			{
				shop.push(byte.readUnsignedInt());
				++idx;
			}
		}
	}
}

//返回请求跑商
//const BYTE RET_BEGIN_BUSINESS_USERCMD = 6;
//struct retBeginBusinessUserCmd : public stBusinessCmd
//{
	//retBeginBusinessUserCmd()
	//{
		//byParam = RET_BEGIN_BUSINESS_USERCMD;
	//}
	//DWORD time; //跑商所需时间
	//DWORD value; //总价值
	//DWORD shop[MAX_BUSINESS_SHOP_NUM];
//};