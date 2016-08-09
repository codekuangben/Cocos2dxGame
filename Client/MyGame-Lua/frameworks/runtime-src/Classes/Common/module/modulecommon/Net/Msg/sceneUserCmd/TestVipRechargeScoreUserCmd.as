package modulecommon.net.msg.sceneUserCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.stSceneUserCmd;
	/**
	 * ...
	 * @author ...
	 */
	public class TestVipRechargeScoreUserCmd extends stSceneUserCmd
	{
		public var rmb:uint;
		
		public function TestVipRechargeScoreUserCmd() 
		{
			byParam = SceneUserParam.TEST_VIP_RECHARGE_USERCMD_PARA;
		}
		
		override public function serialize(byte:ByteArray):void
		{
			super.serialize(byte);
			byte.writeUnsignedInt(rmb);
		}
	}

}

/*
//模拟玩家充值
    const BYTE TEST_VIP_RECHARGE_USERCMD_PARA = 40; 
    struct TestVipRechargeScoreUserCmd : public stSceneUserCmd 
    {   
        TestVipRechargeScoreUserCmd()
        {   
            byParam = TEST_VIP_RECHARGE_USERCMD_PARA;
        }   
        DWORD rmb;//人民币（元)
    }; 
*/