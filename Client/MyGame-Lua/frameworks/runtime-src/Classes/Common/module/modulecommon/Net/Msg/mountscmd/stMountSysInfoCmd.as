package modulecommon.net.msg.mountscmd
{
	import flash.utils.ByteArray;
	
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TMouseItem;
	
	import org.ffilmation.engine.helpers.fUtil;

	/**
	 * @brief 只有激活的坐骑才会在这里
	 */
	public class stMountSysInfoCmd extends stMountCmd
	{
		public var m_gkContext:GkContext;

		public var ridemount:uint;	// 这个数据指定 UI 坐骑栏中显示的是哪一匹
		public var ride:uint;		// 是否骑在马上，主要是上线的时候设置骑乘状态
		public var mountnum:uint;
		public var mountlist:Vector.<stMountData>;	// 当前激活的坐骑
		public var propnum:uint;
		public var proplist:Vector.<stTrainProp>;	// 培养属性是所有坐骑共同的培养属性

		public function stMountSysInfoCmd(gk:GkContext) 
		{
			m_gkContext = gk;
			super();
			byParam = stMountCmd.PARA_MOUNT_SYS_INFO_CMD;
			mountlist = new Vector.<stMountData>();
			proplist = new Vector.<stTrainProp>();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			ridemount = byte.readUnsignedInt();
			ride = byte.readUnsignedByte();
			mountnum = byte.readUnsignedShort();
			mountlist = new Vector.<stMountData>();
			
			var mountdata:stMountData;
			var idx:uint = 0;
			while (idx < mountnum)
			{
				mountdata = new stMountData();
				mountlist.push(mountdata);
				mountdata.deserialize(byte);
				++idx;
			}
			
			propnum = byte.readUnsignedShort();
			
			proplist = new Vector.<stTrainProp>();
			var trainprop:stTrainProp;
			idx = 0;
			while (idx < propnum)
			{
				trainprop = new stTrainProp();
				proplist.push(trainprop);
				trainprop.deserialize(byte);
				++idx;
			}
		}
		
		// 根据当前坐骑的 id 获取坐骑数据
		public function findCurMounts():stMountData
		{
			return findMountsData(ridemount);
		}
		
		public function addOrUpdateTrainProp(item:stTrainProp):void
		{
			var finded:Boolean = false;
			var finditem:stTrainProp;
			for each(finditem in proplist)
			{
				if(finditem.proptype == item.proptype)
				{
					finditem.copyFrom(item);
					finded = true;
					break;
				}
			}
			
			if(!finded)		// 如果没有发现就添加进入
			{
				proplist.push(item);
			}
		}
		
		public function findMountsData(servermountid:uint):stMountData
		{
			var item:stMountData;
			for each(item in mountlist)
			{
				if(item.mountid == ridemount)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function findCurMountTblID():uint
		{
			var mountdata:stMountData =  findCurMounts();
			if(mountdata)
			{
				return fUtil.mountsTblID(mountdata.mountid, mountdata.level);
			}
			
			return 0;
		}
		
		public function findTrainProp(type:uint):stTrainProp
		{
			for each(var item:stTrainProp in proplist)
			{
				if(item.proptype == type)
				{
					return item;
				}
			}
			
			return null;
		}
		
		// 查找培养属性等级
		// 当前属性等级上限就是当前所有激活坐骑的等级和，当前属性的等级是 ( stTrainProp.explimt/25 - 1)
		public function findTrainPropLvl(type:uint):uint
		{
			var prop:stTrainProp = findTrainProp(type);
			if(prop)
			{
				return prop.explimt/25 - 1
			}
			
			return 0;
		}
		
		// 最大等级就是 tbl 表中等级的上限总和
		public function findTrainPropMaxLvl():uint
		{
			var mountdata:stMountData;
			var mountsItem:TMouseItem;
			var total:uint;

			for each(mountdata in mountlist)
			{
				mountsItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_MOUNTS, fUtil.mountsTblID(mountdata.mountid, mountdata.level)) as TMouseItem;
				total += mountsItem.m_lvlMax
			}
			
			return total;
		} 
	}
}

//坐骑系统信息(上线发送)
//const BYTE PARA_MOUNT_SYS_INFO_CMD = 1;
//struct stMountSysInfoCmd : public stMountCmd
//{
	//stMountSysInfoCmd()
	//{
		//byParam = PARA_MOUNT_SYS_INFO_CMD;
		//ridemount = 0;
		//mountnum = propnum = 0;
	//}
	//DWORD ridemount;	//当前骑乘坐骑id
	//BYTE ride;		//0 下马状态 1 骑乘状态
	//WORD mountnum;
	//stMountData mountlist[0];
	//WORD propnum;
	//stTrainProp proplist[0];
//};