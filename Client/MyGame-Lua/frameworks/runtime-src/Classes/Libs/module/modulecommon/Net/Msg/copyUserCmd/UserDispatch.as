package modulecommon.net.msg.copyUserCmd
{
	import flash.utils.ByteArray;

	public class UserDispatch
	{
		public var pos:uint;
		public var charid:uint;
		public var dh:Vector.<DispatchHero>;	// 客户端保存成三个位置,每一个位置表示一个格子
		
		public function deserialize(byte:ByteArray):void
		{
			pos = byte.readUnsignedByte();
			charid = byte.readUnsignedInt();
			dh = new Vector.<DispatchHero>(3, true);
			var idx:int = 0;
			var item:DispatchHero;
			while(idx < 2)	// 服务器发过来总共是两个，自己存放在 3 个中的正确的位置
			{
				item = new DispatchHero();
				item.deserialize(byte);
				if(item.id)		// 只有 id 存在的时候，才是有值的，如果是 0 就说明这个位置没有值
				{
					if(0 <= (item.ds >> 1) && (item.ds >> 1) < 3)
					{
						dh[item.ds >> 1] = item;
					}
				}
				
				++idx;
			}
		}
		
		public function copyFrom(rh:UserDispatch):void
		{
			if(rh)
			{
				pos = rh.pos;
				charid = rh.charid;
				dh = new Vector.<DispatchHero>(3, true);
				var idx:int = 0;
				var item:DispatchHero;
	
				if(rh.dh)
				{
					while(idx < 3)	// 服务器发过来总共是两个，自己存放在 3 个中的正确的位置
					{
						if(rh.dh[idx] && rh.dh[idx].id)		// 只有 id 存在的时候，才是有值的，如果是 0 就说明这个位置没有值
						{
							if(0 <= (rh.dh[idx].ds >> 1) && (rh.dh[idx].ds >> 1) < 3)
							{
								item = new DispatchHero();
								item.copyFrom(rh.dh[idx]);
								dh[item.ds >> 1] = item;
							}
						}
						
						++idx;
					}
				}
			}
		}
		
		public function logInfo():String
		{
			var str:String = "";
			str += ("pos:" + pos + "; charid:" + charid + " \n ");
			var idx:int = 0;
			var item:DispatchHero;
			while(idx < dh.length)	// 服务器发过来总共是两个，自己存放在 3 个中的正确的位置
			{
				item = dh[idx];
				if(item)		// 只有 id 存在的时候，才是有值的，如果是 0 就说明这个位置没有值
				{
					str += item.logInfo();
					str += " \n "
				}
				
				++idx;
			}
			
			return str;
		}
	}
}

//一个玩家上阵信息
//struct UserDispatch {
//	BYTE pos; // 0 , 1, 2,
//	DWORD charid;
//	DispatchHero dh[2];
//};