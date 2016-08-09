package modulecommon.net.msg.trialTowerCmd 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class stRefreshTrialTowerDataCmd extends stTrialTowerCmd 
	{
		public var type:int;	//数据类型
		public var value:int;	//数据数值
		public function stRefreshTrialTowerDataCmd() 
		{
			byParam = REFRESH_TRIAL_TOWER_DATA_PARA;
		}
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			type = byte.readUnsignedByte();
			value = byte.readUnsignedShort();
		}
		
	}

}


///刷新试练塔数据
///试练塔数据
/*enum eTrialTowerDataType
{
    TTDT_CURLAYER = 1,  //当前层数
    TTDT_HISTORYLAYER = 2,  //历史最高层
    TTDT_FREETIMES = 3, //免费次数
	TTDT_CHALLENGETIMES = 4,    //当前可挑战次数
    TTDT_MAX,
};*/
	/*const BYTE REFRESH_TRIAL_TOWER_DATA_PARA = 1;
	struct stRefreshTrialTowerDataCmd : public stTrialTowerCmd
	{
		stRefreshTrialTowerDataCmd()
		{
			byParam = REFRESH_TRIAL_TOWER_DATA_PARA;
			type = 0;
			value = 0;
		}
		BYTE type;	//数据类型
		WORD value;	//数据数值
	};*/