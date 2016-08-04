package modulecommon.net.msg.eliteBarrierCmd
{
	import flash.utils.ByteArray;
	import modulecommon.scene.prop.object.ObjectDataVirtual;
	import com.util.UtilTools;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class stBarrier
	{
		public var m_id:uint;
		public var bossid:uint;
		public var m_name:String;
		public var m_srcname:String;
		public var m_rewardList:Array;
		public var m_size:uint;
		public var m_rewarddesc:String;
		
		public var m_allData:stRetBarrierDataCmd;
		public var m_uindex:uint;
		
		public function stBarrier(all:stRetBarrierDataCmd, index:uint)
		{
			m_allData = all;
			m_uindex = index;
		}
		
		public function deserialize(byte:ByteArray):void
		{
			m_id = byte.readUnsignedShort();
			bossid = byte.readUnsignedInt();
			m_name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			m_srcname = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			m_rewardList = new Array;
			var i:int;
			var objectData:ObjectDataVirtual;
			
			//objlist是定长数组，当数据不足8个时，后面的数据是0
			for (i = 0; i < 8; i++)
			{
				if (objectData == null)
				{
					objectData = new ObjectDataVirtual();
				}
				objectData.deserialize(byte);
				if (objectData.m_objID)
				{
					m_rewardList.push(objectData);
					objectData = null;
				}
			}
			
			var uDescLen:uint = byte.readUnsignedShort();
			m_rewarddesc = UtilTools.readStr(byte, uDescLen);
		}
	
	}

}

/*
	///关卡数据
	struct stBarrier
    {
        WORD id;    //关卡id
        DWORD bossid;   //boss外形
        char name[MAX_NAMESIZE];    //关卡名字
        char srcname[MAX_NAMESIZE]; //资源名
        stRewardObj objlist[8]; //奖励物品列表
        WORD size;
        char rewarddesc[0]; //奖励描述

        stBarrier()
        {
            id = 0;
            bossid = 0;
            size = 0;
            bzero(name,sizeof(name));
            bzero(srcname,sizeof(srcname));
        }
};
*/