package modulecommon.net.msg.mountscmd
{
	import flash.utils.ByteArray;
	/**
	 * @brief 
	 */
	public class stMountData 
	{
		public var mountid:uint;		// 坐骑表的 id/100
		public var level:uint;			// 坐骑表的 id%100，和服务器通信都使用这个，就是坐骑表的 id%100
		
		public function deserialize(byte:ByteArray):void
		{
			mountid = byte.readUnsignedInt();
			level = byte.readUnsignedShort();
		}
		
		public function copyFrom(mount:stMountData):void
		{
			this.mountid = mount.mountid;
			this.level = mount.level;
		}
	}
}

//坐骑信息
//struct stMountData
//{
	//DWORD mountid;
	//WORD  level;
//};