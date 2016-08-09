package modulecommon.net.msg.godlyweaponCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.SceneUserParam;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class stGodlyWeaponSysInfoCmd extends stSceneUserCmd
	{
		public var loginDay:uint;
		public var onlineTime:uint;
		public var weargwid:uint;
		public var gwsmaxtraintimes:uint;	//最大培养次数
		public var leftgwstraintimes:uint;	//剩余培养次数
		public var ybtraintimes:uint;		//元宝培养次数
		public var gwslevel:uint;		//神兵技能等级
		public var gwsexp:uint;		//当前神兵技能经验
		public var gwList:Vector.<uint>;
		
		public function stGodlyWeaponSysInfoCmd() 
		{
			byParam = SceneUserParam.PARA_GODLY_WEAPON_SYS_INFO_USERCMD;
			gwList = new Vector.<uint>();
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			
			loginDay = byte.readUnsignedShort();
			onlineTime = byte.readUnsignedInt();
			weargwid = byte.readUnsignedInt();
			gwsmaxtraintimes = byte.readUnsignedShort();
			leftgwstraintimes = byte.readUnsignedShort();
			ybtraintimes = byte.readUnsignedShort();
			gwslevel = byte.readUnsignedShort();
			gwsexp = byte.readUnsignedInt();
			
			var num:int = byte.readUnsignedShort();
			var i:int;
			var gwid:uint;
			
			for (i = 0; i < num; i++)
			{
				gwid = byte.readUnsignedInt();
				
				gwList.push(gwid);
			}
		}
	}

}

/*
	//上线发送神兵数据
	const BYTE PARA_GODLY_WEAPON_SYS_INFO_USERCMD = 66;
    struct stGodlyWeaponSysInfoCmd : public stSceneUserCmd
    {    
        stGodlyWeaponSysInfoCmd()
        {    
            byParam = PARA_GODLY_WEAPON_SYS_INFO_USERCMD;
            loginday = 0; 
            onlinetime = 0; 
            weargwid = 0; 
			gwsmaxtraintimes = leftgwstraintimes = 0;
			ybtraintimes = gwslevel = 0;
			gwsexp = 0;
            num = 0; 
        }    
        WORD loginday;  //登陆天数
        DWORD onlinetime;   //今日累计在线时间(秒)
        DWORD weargwid; //当前佩戴神兵
		WORD gwsmaxtraintimes;  //最大培养次数
		WORD leftgwstraintimes; //剩余培养次数
		WORD ybtraintimes;  //元宝培养次数
		WORD gwslevel;  //神兵技能等级
		DWORD gwsexp;   //当前神兵技能经验
        WORD num; 
        DWORD gwlist[0];    //神兵列表
    };  
*/