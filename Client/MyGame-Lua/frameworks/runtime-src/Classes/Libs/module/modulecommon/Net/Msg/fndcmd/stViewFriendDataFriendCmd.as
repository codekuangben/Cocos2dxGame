package modulecommon.net.msg.fndcmd
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	
	import modulecommon.net.msg.fndcmd.stFriendCmd;

	public class stViewFriendDataFriendCmd extends stFriendCmd
	{
		public static const VIEWTYPE_NONE:int = 0;
		public static const VIEWTYPE_FRIEND:int = 1;
		public static const VIEWTYPE_BLACKLIST:int = 2;
		public static const VIEWTYPE_CORPS:int = 3;
		public static const VIEWTYPE_RANK:int = 4;
		public var friendName:String;
		public var type:uint;

		public function stViewFriendDataFriendCmd()
		{
			super();
			byParam = stFriendCmd.PARA_VIEW_FRIEND_DATA_FRIENDCMD;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			UtilTools.writeStr(byte, friendName, EnNet.MAX_NAMESIZE);			
			byte.writeByte(type);
		}
	}
}

//查看好友资料
/*enum eViewType
    {   
        VIEWTYPE_NONE = 0,		//默认值
        VIEWTYPE_FRIEND = 1,    //好友查看
        VIEWTYPE_BLACKLIST = 2, //黑名单查看
        VIEWTYPE_CORPS = 3, 	//兵团人员信息查看
		VIEWTYPE_RANK = 4,  	//排行榜(竞技场、过关斩将)
    };  */
//const BYTE PARA_VIEW_FRIEND_DATA_FRIENDCMD = 17; 
//struct stViewFriendDataFriendCmd : public stFriendCmd
//{   
//	stViewFriendDataFriendCmd()
//	{   
//		byParam = PARA_VIEW_FRIEND_DATA_FRIENDCMD;
//		friendid = 0;
//	}   
//	char friendName;
//	BYTE type;	//eViewType值
//};