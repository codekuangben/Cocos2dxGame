package modulecommon.net.msg.mountscmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.mountscmd.stMountCmd;
	import modulecommon.net.msg.mountscmd.stMountData;
	/**
	 * ...
	 * @author 
	 */
	public class stGmViewOtherUserMountCmd extends stMountCmd 
	{
		public var mountnum:uint;
		public var mountlist:Vector.<stMountData>;
		public var tpnum:uint;
		public var trainprops:Vector.<TypeValue>;
		public function stGmViewOtherUserMountCmd() 
		{
			super();
			byParam = stMountCmd.GM_PARA_VIEW_OTHER_USER_MOUNT_CMD;	
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
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
			
			trainprops = new Vector.<TypeValue>();
			tpnum = byte.readUnsignedShort();
			var tpdata:TypeValue;
			idx = 0;
			while (idx < tpnum)
			{
				tpdata = new TypeValue();
				trainprops.push(tpdata);
				tpdata.deserialize(byte);
				++idx;
			}
		}
	}

}/*//坐骑观察
    const BYTE GM_PARA_VIEW_OTHER_USER_MOUNT_CMD = 14;
    struct stGmViewOtherUserMountCmd : public stMountCmd
    {
        stGmViewOtherUserMountCmd()
        {
            byParam = GM_PARA_VIEW_OTHER_USER_MOUNT_CMD;
            mountnum = 0;
            tpnum = 0;
        }
        WORD mountnum;
        stMountData mountlist[0];
        WORD tpnum;
        TypeValue trainprops[0];
    };*/