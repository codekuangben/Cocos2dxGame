package app.login.netmsg.loginmsg 
{
	import net.loginUserCmd.stLoginUserCmd;
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	public class stReturnReleaseVerCmd extends stLoginUserCmd
	{		
		public function stReturnReleaseVerCmd() 
		{
			byParam = RETURN_RELEASE_VER_PARA;
		}
		override public function deserialize (byte:ByteArray) : void
		{
			super.deserialize(byte);			
		}
		
	}

}

// // 返回客户端外网版本
    /*const BYTE RETURN_RELEASE_VER_PARA = 9;
    struct stReturnReleaseVerCmd  : public stLogonUserCmd
    {   
        stReturnReleaseVerCmd()
        {   
            byParam = RETURN_RELEASE_VER_PARA;
            version = type = 0;
        }          
    };  
  */
