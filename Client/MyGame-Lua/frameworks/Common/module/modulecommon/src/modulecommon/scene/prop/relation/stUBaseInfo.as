package modulecommon.scene.prop.relation
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	
	import common.net.endata.EnNet;
	import com.util.UtilTools;

	/**
	 * @brief 这个是新的好友信息,不用 FndItem 了
	 * */
	public class stUBaseInfo
	{		
		public static var s_gkContext:GkContext;
		
		public var charid:uint;
		public var sex:uint;
		public var job:uint;
		public var level:uint;
		public var online:uint;
		public var focus:uint;
		public var extra:uint;
		public var name:String;
		
		public var m_bNeedHelpForBaowu:Boolean;	//true-需要帮助抢回宝物
		
		private var m_mooddiary:String;
		private var m_bMoodDirty:Boolean;
		
		public var m_bsendedAddFnd:Boolean = false;		// 如果不是好友，并且在线的时候，点击互相加好友按钮，点击一次就行了，这个就是记录这个的		
		
		public function deserialize(byte:ByteArray):void
		{			
			charid = byte.readUnsignedInt();
			sex = byte.readUnsignedByte();
			job = byte.readUnsignedByte();
			level = byte.readUnsignedShort();
			online = byte.readUnsignedByte();
			focus = byte.readUnsignedByte();
			extra = byte.readUnsignedByte();
			
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			m_mooddiary = byte.readMultiByte(EnNet.MAX_MOODDIARY_LEN, EnNet.UTF8);
			m_bMoodDirty = true;
		}
		public function get mooddiary():String
		{
			if (m_bMoodDirty)
			{
				m_mooddiary = s_gkContext.m_SWMgr.filter(m_mooddiary);
				m_bMoodDirty = false;
			}
			return m_mooddiary;
		}
		public function set mooddiary(str:String):void
		{
			m_mooddiary = str;
			m_bMoodDirty = true;
		}
	}
}

//好友基本信息
//struct stUBaseInfo
//{
//	DWORD charid;
//	BYTE sex;
//	BYTE job;
//	WORD level;
//	BYTE online;	//1-在线
//	BYTE focus;		//1-互相关注
//	BYTE extra; //附加信息//第0位表示此好友今天是否帮我打过井
//	char name[MAX_NAMESIZE];
//	char mooddiary[MAX_MOODDIARY_LEN];
//	stUBaseInfo()
//	{
//		sex = job = 0;
//		level = 0;
//		online = focus = 0;;
//		bzero(name,sizeof(name));
//		bzero(mooddiary,sizeof(mooddiary));
//	}
//};