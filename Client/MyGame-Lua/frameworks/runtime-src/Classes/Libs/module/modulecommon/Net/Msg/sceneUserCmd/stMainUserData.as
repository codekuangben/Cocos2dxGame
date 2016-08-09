package modulecommon.net.msg.sceneUserCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import modulecommon.scene.beings.UserState;
	
	import common.net.endata.EnNet;
	public class stMainUserData 
	{
		public var charid:uint;
		public var tempid:uint;	
		public var job:uint;
		public var name:String;
		public var sex:uint;
		public var level:uint;
		public var mapID:uint;		
		public var x:uint;
		public var y:uint;
		public var hp:uint;
		public var force:uint;
		public var iq:uint;
		public var exp:Number;
		
		public var chief:uint;	//统帅
		public var soldier_type:uint;	//兵种
		//public var shiqi:uint;	//士气
		public var speed:uint;	//攻击速度
		//public var baoji:uint;	//暴击
		//public var bjdef:uint;	//防暴击
		//public var gedang:uint;		//格挡
		//public var poji:uint;	//破击
		//public var strike_back:uint;	//反击
		//public var impress:uint;		//好感度
		public var matrixid:uint;	//阵型id
		public var matrixpos:uint;//九宫格中的位置
		public var soldierlimit:uint;	//带兵上限			
		public var dir:uint;		// 面向 [0, 7]
		public var vipscore:uint;	//vip分值
		public var packageOpendSize1:int;
		public var packageOpendSize2:int;
		public var packageOpendSize3:int;
		public var trainlevel:uint;	//当前培养等级
		public var trainpower:uint;	//当前培养能量
		public var minor:uint;		//是否成年
		public var moveSpeed:uint;	//移动速度
		public var states:Vector.<uint>; 
		public function deserialize (byte:ByteArray) : void
		{
		
			charid = byte.readUnsignedInt();
			tempid = byte.readUnsignedInt();			
			job = byte.readUnsignedByte();
			name = byte.readMultiByte(EnNet.MAX_NAMESIZE, EnNet.UTF8);
			sex = byte.readByte();
			level = byte.readUnsignedShort();
			mapID = byte.readUnsignedInt();			
			x = byte.readUnsignedShort();
			y = byte.readUnsignedShort();
			hp = byte.readUnsignedInt();
			force = byte.readUnsignedInt();
			iq = byte.readUnsignedInt();
			exp = byte.readDouble();
			
			chief = byte.readUnsignedInt();
			soldier_type = byte.readUnsignedInt();
			//shiqi = byte.readUnsignedInt();
			speed = byte.readUnsignedInt();
			//baoji = byte.readUnsignedInt();
			//bjdef = byte.readUnsignedInt();
			//gedang = byte.readUnsignedInt();
			//poji = byte.readUnsignedInt();
			//strike_back = byte.readUnsignedInt();
			//impress = byte.readUnsignedInt();
			
			matrixid = byte.readUnsignedShort();
			matrixpos = byte.readUnsignedByte();
			soldierlimit = byte.readUnsignedInt();			
			dir = byte.readUnsignedByte();
			vipscore = byte.readUnsignedInt();
			
			packageOpendSize1 = byte.readUnsignedByte();
			packageOpendSize2 = byte.readUnsignedByte();
			packageOpendSize3 = byte.readUnsignedByte();
			
			trainlevel = byte.readUnsignedShort();
			trainpower = byte.readUnsignedInt();
			minor = byte.readUnsignedByte();
			moveSpeed = byte.readUnsignedByte();
			
			states = UserState.createStates();
			states[0] = byte.readUnsignedInt();
		}
		
	}

}

/*struct MainData
		{
			DWORD charid;
			DWORD tempid;		
			BYTE  job;
			char  name[MAX_NAMESIZE];
			BYTE sex;
			WORD level;
			DWORD mapID;
			WORD x;
			WORD y;
			DWORD hp;
			DWORD force;	//武力
			DWORD iq;		//智力
			double exp;		//经验值
			DWORD chief;	//统帅
			DWORD soldier_type;	//兵种
			//DWORD shiqi;	//士气
			DWORD speed;	//攻击速度
			//DWORD baoji;	//暴击
			//DWORD bjdef;	//防暴击
			//DWORD gedang;		//格挡
			//DWORD poji;	//破击
			//DWORD strike_back;	//反击
			//DWORD impress;		//好感度
			WORD  matrixid;	//阵型id
			BYTE  matrixpos;//九宫格中的位置
			DWORD soldierlimit;	//带兵上限
			BYTE dir;      //面向
			DWORD vipscore; //vip分值
			BYTE  mpopennum[3];	//三个主包裹开启的格子数
			WORD trainlevel;	//当前培养等级
			DWORD trainpower;	//当前培养能量
			BYTE minor; //0:成年人 1：未成年人
			BYTE moveSpeed; //移动速度
			DWORD states;
}*/