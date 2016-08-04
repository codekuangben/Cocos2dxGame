package game.ui.uipaoshangsys.msg 
{
	import flash.utils.ByteArray;
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author ...
	 */
	public class BusinessUser 
	{
		public var id:uint;
		public var job:uint;
		public var sex:uint;
		public var name:String;
		
		public var bTime:uint;
		public var time:uint;
		public var sum:uint;
		public var robValue:uint;
		
		public var vel:Number;		// 客户端自己使用，跑的速度
		public var brun:Boolean;	// 客户端自己使用，如果 bTime 是 0 的情况下，是否强制移动，morning bTime 是 0 ，就说明刚进入跑商，还没有发车
		
		public function deserialize(byte:ByteArray):void 
		{
			id = byte.readUnsignedInt();
			job = byte.readUnsignedByte();
			sex = byte.readUnsignedByte();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			
			bTime = byte.readUnsignedInt();
			time = byte.readUnsignedInt();
			sum = byte.readUnsignedInt();
			robValue = byte.readUnsignedInt();
		}
		
		// 计算速度
		public function calcVel(len:uint):void
		{
			vel = len / time;
		}
	}
}

//struct BusinessUser {
	//DWORD id;
	//BYTE job;
	//BYTE sex;
	//char name[MAX_NAMESIZE];
	//DWORD bTime; //发车时间
	//DWORD time; //跑商总时间
	//DWORD sum; //获取总价值
	//DWORD robValue; //抢劫后可获得的银币数量
//};