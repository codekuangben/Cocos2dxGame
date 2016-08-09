package modulecommon.net.msg.sceneUserCmd
{
	import flash.utils.ByteArray;
	
	//import common.net.endata.EnNet;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	public final class stMainUserDataUserCmd extends stSceneUserCmd 
	{
		public var m_mainData:stMainUserData;
		
		
		public function stMainUserDataUserCmd() 
		{
			byParam = SceneUserParam.MAIN_USER_DATA_USERCMD_PARA;
		}
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);
			
			m_mainData = new stMainUserData();
			m_mainData.deserialize(byte);
		}
	}
}

/*
 * struct MainData
		{
			DWORD charid;
			DWORD tempid;
			DWORD accID;
			DWORD zoneID;
			BYTE  job;
			char  name[MAX_NAMESIZE];
			BYTE sex;
			DWORD level;
			DWORD mapID;
			DWORD x;
			DWORD y;
			DWORD hp;
			DWORD force;	//武力
			DWORD iq;		//智力
			double exp;		//经验值
			DWORD chief;	//统帅
			DWORD soldier_type;	//兵种
			DWORD shiqi;	//士气
			DWORD speed;	//攻击速度
			DWORD baoji;	//暴击
			DWORD bjdef;	//防暴击
			DWORD gedang;		//格挡
			DWORD poji;	//破击
			DWORD strike_back;	//反击
			DWORD impress;		//好感度
			WORD  matrixid;	//阵型id
			BYTE  matrixpos;//九宫格中的位置
			DWORD soldierlimit;	//带兵上限
			BYTE dir;      //面向
			DWORD vipscore;	//vip分值
			BYTE  mpopennum[3]; //三个主包裹花钱开启的格子数
			WORD trainlevel;	//当前培养等级
			DWORD trainpower;	//当前培养能量
			BYTE minor; //0:成年人 1：未成年人
		}
*/