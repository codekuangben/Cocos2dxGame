package modulefight.netmsg.stmsg
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.scene.beings.PlayerMain;
	
	import common.net.endata.EnNet;
	import com.util.UtilTools;

	/**
	 * ...
	 * @author 
	 */
	public class stUserInfo 
	{
		public var sex:uint;
		public var job:uint;
		public var pos:uint;
		public var level:uint;
		public var zhanli:uint;
		public var zhanshuID:uint;
		public var charID:uint;
		public var name:String;
		public var jinnang:stJinnang;
		
		public function deserialize(byte:ByteArray):void
		{
			sex = byte.readUnsignedByte();
			job = byte.readUnsignedByte();
			pos = byte.readUnsignedByte();
			level = byte.readUnsignedShort();
			zhanli = byte.readUnsignedInt();
			zhanshuID = byte.readUnsignedInt();
			charID = byte.readUnsignedInt();
			name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			jinnang = new stJinnang();
			jinnang.deserialize(byte);
		}
		
		public static function s_CreateUserInfoForMainPlayer(gk:GkContext):stUserInfo
		{
			var ret:stUserInfo = new stUserInfo();
			var playerMain:PlayerMain = gk.playerMain;
			ret.sex = playerMain.gender;
			ret.job = playerMain.job;
			ret.level = playerMain.level;
			ret.zhanli = playerMain.wuProperty.m_uZongZhanli;
			ret.charID = playerMain.charID;
			ret.name = playerMain.name;
			ret.jinnang = new stJinnang();
			return ret;
		}
	}
	
	
}

/*struct stUserInfo
{
	BYTE sex;	//主角性别
	BYTE job;	//主角职业
	BYTE pos;	//主角在九宫中的位置
	WORD level;
	DWORD zhanli;	// 玩家战力,只有玩家显示
	DWORD zhanshuID;	// 玩家当前的技能
	DWORD charID;	//玩家的charID
	char name[];
	stJinnang kit;	锦囊数据
};*/