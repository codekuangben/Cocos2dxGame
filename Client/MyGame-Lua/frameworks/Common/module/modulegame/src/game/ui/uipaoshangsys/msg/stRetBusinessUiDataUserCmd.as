package game.ui.uipaoshangsys.msg 
{
	import com.pblabs.engine.entity.EntityCValue;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.net.msg.paoshangcmd.stBusinessCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stRetBusinessUiDataUserCmd extends stBusinessCmd
	{
		public var times:uint;
		public var free:uint;
		public var time:uint;
		public var bTime:uint;
		public var value:uint;
		
		public var shop:Vector.<uint>;
		public var rob:Vector.<BusinessRober>;
		
		public var m_goodsLst:Vector.<GoodsInfo>;			// 客户端自己使用
		
		public var size:uint;
		public var data:Vector.<BusinessUser>;
		
		public var brun:Boolean;							// 记录当 bTime 为 0 时，是否开始跑商， bTime 可能刚开始发送过来的是 0 ，但是后来某些消息导致进入正式跑商，很多数据就要更新了
		
		public function stRetBusinessUiDataUserCmd()
		{
			super();
			byParam = stBusinessCmd.RET_BUSINESS_UI_DATA_USERCMD;
			m_goodsLst = new Vector.<GoodsInfo>(EntityCValue.MAX_BUSINESS_SHOP_NUM, true);
			
			var idx:uint = 0;
			while (idx < EntityCValue.MAX_BUSINESS_SHOP_NUM)
			{
				m_goodsLst[idx] = new GoodsInfo();
				++idx;
			}
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			
			times = byte.readUnsignedByte();
			free = byte.readUnsignedByte();
			time = byte.readUnsignedInt();
			bTime = byte.readUnsignedInt();
			value = byte.readUnsignedInt();
			
			shop = new Vector.<uint>();
			var idx:uint = 0;
			while (idx < EntityCValue.MAX_BUSINESS_SHOP_NUM)
			{
				shop.push(byte.readUnsignedInt());
				++idx;
			}
			
			rob = new Vector.<BusinessRober>();
			var itemrober:BusinessRober;
			idx = 0;
			while (idx < 2)
			{
				itemrober = new BusinessRober();
				itemrober.deserialize(byte);
				rob.push(itemrober);
				++idx;
			}
			
			size = byte.readUnsignedShort();
			
			data = new Vector.<BusinessUser>();
			var item:BusinessUser;
			idx = 0;
			while (idx < size)
			{
				item = new BusinessUser();
				item.deserialize(byte);
				data.push(item);
				++idx;
			}
		}
		
		// 同步数据
		public function syncData(dic:Dictionary):void
		{
			var idx:uint = 0;
			if (!m_goodsLst)
			{
				m_goodsLst = new Vector.<GoodsInfo>();
				
				while (idx < EntityCValue.MAX_BUSINESS_SHOP_NUM)
				{
					m_goodsLst.push(new GoodsInfo());
					++idx;
				}
			}
			
			idx = 0;
			while (idx < EntityCValue.MAX_BUSINESS_SHOP_NUM)
			{
				if (dic[shop[idx]])
				{
					m_goodsLst[idx].m_goodsID = dic[shop[idx]];	// 服务器类型到客户端 id 转换
				}
				else
				{
					m_goodsLst[idx].m_goodsID = 0;
				}
				++idx;
			}
		}
		
		public function adjustValue():void
		{
			// 如果被打劫，需要自己减去被打劫的值，服务器没有减去
			for each(var item:BusinessRober in rob)
			{
				if (item.time)
				{
					this.value -= item.lost;
				}
			}
		}
		
		// 获取跑商剩余时间
		public function getLeftTime():uint
		{
			return (time - bTime);
			//return 30;
		}
		
		// 根据 id 删除并返回
		public function delAndRetUser(id:uint):BusinessUser
		{
			var idx:int = data.length - 1;
			var item:BusinessUser;
			while (idx >= 0)
			{
				if (data[idx].id == id)
				{
					item = data[idx];
					break;
				}
				--idx;
			}
			
			if (idx >= 0)
			{
				data.splice(idx, 1);
			}
			
			return item;
		}
		
		public function clearInfo():void
		{
			// 清除打劫信息
			var itemrober:BusinessRober;
			var idx:uint = 0;
			while (idx < 2)
			{
				itemrober = rob[idx];
				itemrober.time = 0;
				++idx;
			}
		}
	}
}

//const BYTE RET_BUSINESS_UI_DATA_USERCMD = 2;
//struct stRetBusinessUiDataUserCmd : public stBusinessCmd
//{
	//stRetBusinessUiDataUserCmd()
	//{
		//byParam = RET_BUSINESS_UI_DATA_USERCMD;
		//times = 0;
		//time = bTime = value =0;
		//int i=0;
		//do { shop[i++]=0; } while( i <MAX_BUSINESS_SHOP_NUM);
//
		//size = 0;
	//}
	//BYTE times; //今日已发车次数
	//BYTE free; //1:没有免费换货次数， 0：有免费换货次数
	//DWORD time; //跑商所需时间
	//DWORD bTime; //发车时间
	//DWORD value; //总价值
	//DWORD shop[MAX_BUSINESS_SHOP_NUM]; //货物信息
	//BusinessRober rob[MAX_BUSINESS_ROB_NUM]; //被抢信息
//
	//WORD size;
	//BusinessUserData data[0];
	//WORD getSize( void ) const { return sizeof(*this) + sizeof(BusinessUserData)*size; }
//};