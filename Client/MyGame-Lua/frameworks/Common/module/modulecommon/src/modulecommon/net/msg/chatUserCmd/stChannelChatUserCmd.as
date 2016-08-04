package modulecommon.net.msg.chatUserCmd
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import modulecommon.scene.prop.object.T_Object;
	import com.util.UtilTools;
	import modulecommon.net.msg.chatUserCmd.stChatUserCmd;
	
	public class stChannelChatUserCmd extends stChatUserCmd
	{
		//stChannelChatUserCmd::chatType
		public static const CHAT_SYS:uint = 1; //系统[系统]
		public static const CHAT_ACTVIETIP:uint = 2; //活动[系统]
		public static const CHAT_TOOLTIP:uint = 3; //系统[系统]; 也在屏幕中间显示
		public static const CHAT_CORPSTIP:uint = 4; //军团[系统]
		public static const CHAT_BROAD:uint = 5; //公告[系统]
		
		public static const CHAT_CORPS:uint = 6; //军团聊天
		public static const CHAT_ALL:uint = 7; //世界		
		public static const CHAT_VIP:uint = 8; //Vip
		public static const CHAT_AREA:uint = 9; //区域
		public static const CHAT_OFFICIAL:uint = 10; //官方
		public static const CHAT_GM:uint = 11; //GM聊天
		
		
		public static const CHAT_PRIVATE:uint = 16; //私聊
		public static const CHAT_SCREEN:uint = 17; //主屏幕跑马灯公告
		public static const CHAT_MOUSETIP:uint = 18; //文字内容出现在鼠标上方
		public static const CHAT_SCREENBLOW:uint = 19; //主屏幕下方公告
		public static const CHAT_YELLOWTIP:uint = 20; //只在屏幕中间飘黄字
		public static const CHAT_DIALOG:uint = 21; //确认对话框
		
		
		public var m_bBuf:Boolean;	//true - 等待战斗播放完后，再处理此消息
		public var chatType:uint;
		public var name:String;
		public var data:String;
		public var m_objectList:Vector.<T_Object>;
		public var m_spritesData:String;
		public var m_viplevel:uint;
		
		public function stChannelChatUserCmd()
		{
			byParam = CHANNEL_CHAT_USERCMD_PARAMETER;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeBoolean(m_bBuf);
			byte.writeByte(chatType);
			byte.writeByte(m_viplevel);
			
			UtilTools.writeStrUnfixed(byte, name, 1);			
			UtilTools.writeStrUnfixed(byte, data, 2);
			byte.writeByte(m_objectList?m_objectList.length:0);
			if (m_objectList)
			{
				var i:uint = 0;
				for (i = 0; i < m_objectList.length; i++)
				{
					m_objectList[i].serialize(byte);
				}		
			}
			UtilTools.writeStrUnfixed(byte, m_spritesData, 2);
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			m_bBuf = byte.readBoolean();
			chatType = byte.readUnsignedByte();
			m_viplevel = byte.readUnsignedByte();
			name=UtilTools.readStrUnfixed(byte, 1);
			data = UtilTools.readStrUnfixed(byte, 2);			
			var objectSize:int = byte.readUnsignedByte();			
			
			if (objectSize > 0)
			{
				var i:uint = 0;
				var tobject:T_Object;
				m_objectList = new Vector.<T_Object>();
				while (i < objectSize)
				{
					tobject = new T_Object();
					tobject.deserialize(byte);
					m_objectList.push(tobject);
					i++;
				}
			}			
			m_spritesData = UtilTools.readStrUnfixed(byte, 2);		
		
		}
	}
} /*
 * //描述消息来源， 玩家或系统
   const BYTE CHAT_SYS = 1;        //系统消息
   const BYTE CHAT_ACTVIETIP = 2;       //活动提示
   const BYTE CHAT_TOOLTIP = 3;    //屏幕提示信息(一般用于错误提示)
   const BYTE CHAT_CORPSTIP = 4;   //军团系统提示
   const BYTE CHAT_BROAD = 5;  //公告[系统]


   const BYTE CHAT_CORPS = 6;  //军团聊天
   const BYTE CHAT_ALL = 7;
   const BYTE CHAT_VIP = 8;
   const BYTE CHAT_AREA = 9;   //区域聊天(玩家所在地图)
   const BYTE CHAT_OFFICIAL = 10;    //公告
   const BYTE CHAT_GM = 11;    //GM

   const BYTE CHAT_PRIVATE = 16;   //私聊
   const BYTE CHAT_SCREEN = 17;    //主屏幕公告
   const BYTE CHAT_MOUSETIP = 18;  //鼠标提示
   const BYTE CHAT_SCREENBLOW = 19;    //主屏幕下方公告
   const BYTE CHAT_YELLOWTIP = 20; //只在屏幕中间飘黄字
   const BYTE CHAT_DIALOG = 21;    //确认对话框

	const BYTE  CHANNEL_CHAT_USERCMD_PARAMETER= 1;
    struct  stChannelChatUserCmd: public stChatUserCmd
    {   
        BYTE isBuf; //1：缓存播放完后显示， 0：直接显示
        BYTE type;    
        BYTE viplevel;
        BYTE nameSize;
        char name[0];
        WORD chatSize;
        char data[0];  // 对话
        BYTE objectSize;    //道具数量      
        t_ObjData objectData[0];      
        WORD spriteSize;    //  
        char spriteData[0];
        stChannelChatUserCmd()
        {   
            byParam = CHANNEL_CHAT_USERCMD_PARAMETER;
            type = viplevel = nameSize = objectSize = 0;
            spriteSize = chatSize = 0;
            isBuf = 0;
        }   
    };  


 };*/