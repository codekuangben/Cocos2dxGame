package modulecommon.net.msg.mailCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	import com.util.UtilTools;
	import org.ffilmation.engine.helpers.fUtil;
	
	public class MailHead 
	{		
		public var id:uint;
		public var type:int;	
		public var topic:String;
		public var name:String;
		public var timeRemaining:uint;	//剩余时间，单位秒
		public var timeReceive:uint;	//接收时间, 单位秒
		public var readed:Boolean;	//true - 已读
		public var fujian:Boolean;	//true - 有附件
		public var job:int;
		public var sex:int;
		public var state:int;
		public var body:MailBody;
		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			type = byte.readUnsignedByte();
			topic = UtilTools.readStr(byte, 32);
			name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			timeRemaining = byte.readUnsignedInt();
			timeReceive = byte.readUnsignedInt();
			
			readed = byte.readBoolean();
			fujian = byte.readBoolean();
			if (type & 0x1)
			{
				byte.position += 2;
			}
			else
			{
				job = byte.readUnsignedByte();
				sex = byte.readUnsignedByte();
			}			
			state=byte.readUnsignedByte();
		}
		public function get isSystemMail():Boolean
		{
			return (type & 0x1)!=0;
		}
		
		public function get isBaowuLootMail():Boolean
		{
			return (type & 0x8)!=0;
		}
		public static function compare(x:MailHead, y:MailHead):int
		{
			if (x.timeReceive >= y.timeReceive)
			{
				return -1;
			}
			return 1;
		}
	}

}

/*
 * struct MailHead
	{
		DWORD id;//邮件唯一id
		//BYTE type; //0：系统邮件 1：玩家邮件
		BYTE type; //0x1：系统邮件 0x2：玩家邮件 0x4:官职竞技每日奖励邮件;0x8 :宝物抢夺邮件
		char topic[TOPIC];
		char name[MAX_NAMESIZE]; //发件人名字
		DWORD time; //剩余时间
		DWORD time2; //收件时间
		BYTE read; //0:未读 1：已读
		BYTE fujian; //0:没附件 1：有附件
		BYTE job; //职业
		BYTE sex; //1:男 2:女
		BYTE state; 对于宝物抢夺邮件，0，表示宝物已取回，1，表示宝物未取回
	};
*/