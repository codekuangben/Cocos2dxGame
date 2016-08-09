package modulecommon.net.msg.sgQunYingCmd 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author 
	 */
	public class UserZhanJi 
	{
		public var m_zhanjiNo:uint;
		public var m_time:uint;
		public var m_name:String;
		public var m_result:uint;//为3是客户端定义未比赛情况
		public var m_rewardflag:uint;
		
		public function deserialize(byte:ByteArray):void
		{
			m_zhanjiNo = byte.readUnsignedInt();
			m_time = byte.readUnsignedInt();
			m_name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			m_result = byte.readUnsignedByte();
			m_rewardflag = byte.readUnsignedByte();
			
		}
		
	}

}/*//战绩
	struct UserZhanJi
	{
		DWORD zhanjino;	//战绩编号
		DWORD time;	//时间
		char name[MAX_NAMESIZE]; //pk对象名字
		BYTE vicflag;	//胜负标记 1-胜利 0:负	3-轮空 2-客户端自己赋值
		BYTE rewardflag;    //领奖标记  1-已领取
		UserZhanJi()
		{
			zhanjino = time = 0;
			bzero(name,sizeof(name));
			vicflag = 0;
			rewardflag = 0;
		}
	};*/