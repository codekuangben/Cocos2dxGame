package modulecommon.scene.prop.relation
{
	import flash.utils.Dictionary;
	
	import modulecommon.net.msg.chatUserCmd.stChannelChatUserCmd;
	import modulecommon.net.msg.chatUserCmd.stUserChatBaseInfoCmd;

	/**
	 * @brief 私人聊天相关
	 * */
	public class PersonChatData
	{
		public var m_dicPsChat:Dictionary;		// 私人聊天,对方 name 到 PersonChat 的映射
		public var m_dicOpenIngPsChat:Dictionary;	// 这个是客户端主动打开私聊的时候，记录打开的窗口
		public var m_openBuff:Boolean			// 打开缓冲区内容

		public function PersonChatData()
		{
			m_dicPsChat = new Dictionary();
			m_dicOpenIngPsChat = new Dictionary();
		}
		
		// 服务器需要打开的列表
		public function openAndAddPChatByCmd(msg:stChannelChatUserCmd):void
		{
			var baseinfo:stUserChatBaseInfoCmd;
			var lst:Array;
			//lst = m_dicPsChat[msg.name];
			//if(!lst)
			//{
			//	lst = [];
			//	m_dicPsChat[msg.name] = lst;
			//}
			baseinfo = m_dicPsChat[msg.name];
			if(baseinfo)
			{
				lst = baseinfo.chatlst;
				if(lst)
				{
					lst.push(msg);
				}
			}
		}
		
		public function openAndAddPChatByBaseInfo(msg:stUserChatBaseInfoCmd):void
		{
			var baseinfo:stUserChatBaseInfoCmd;
			var lst:Array;
			baseinfo = m_dicPsChat[msg.name];
			if(!baseinfo)
			{
				baseinfo = msg;
				baseinfo.chatlst = [];
				
				m_dicPsChat[msg.name] = baseinfo;
			}
			else
			{
				baseinfo.charid = msg.charid;
				baseinfo.sex = msg.sex;
				baseinfo.job = msg.job;
				baseinfo.level = msg.level;
			}
		}
		
		// 这个是本地需要打开的列表
		public function openAndAddOpeningPChatByCmd(msg:stUserChatBaseInfoCmd):void
		{
			var baseinfo:stUserChatBaseInfoCmd;
			//var lst:Array;
			baseinfo = m_dicOpenIngPsChat[msg.name];
			if(!baseinfo)
			{
				baseinfo = msg;
				m_dicOpenIngPsChat[msg.name] = baseinfo;
			}
			
			baseinfo.charid = msg.charid;
			baseinfo.sex = msg.sex;
			baseinfo.job = msg.job;
			baseinfo.level = msg.level;	
		}
		
		public function getPsChatCnt():uint
		{
			var cnt:uint = 0;
			for each(var key:String in m_dicPsChat)
			{
				++cnt;
			}
			
			return cnt;
		}
		
		public function clearOpeningPChat():void
		{
			var arr:Array = [];
			var key:String;
			for(key in m_dicOpenIngPsChat)
			{
				arr.push(key);
				if((m_dicOpenIngPsChat[key] as stUserChatBaseInfoCmd).chatlst)
				{
					(m_dicOpenIngPsChat[key] as stUserChatBaseInfoCmd).chatlst.length = 0;
				}
			}
			
			for each(key in arr)
			{
				m_dicOpenIngPsChat[key] = null;
				delete m_dicOpenIngPsChat[key];
			}
			
			arr.length = 0;
		}
		
		public function clearPChat():void
		{
			var arr:Array = [];
			var key:String;
			for(key in m_dicPsChat)
			{
				arr.push(key);
				if((m_dicPsChat[key] as stUserChatBaseInfoCmd).chatlst)
				{
					(m_dicPsChat[key] as stUserChatBaseInfoCmd).chatlst.length = 0;
				}
			}
			
			for each(key in arr)
			{
				m_dicPsChat[key] = null;
				delete m_dicPsChat[key];
			}
			
			arr.length = 0;
		}
	}
}