package net.loginUserCmd
{
	import flash.utils.ByteArray;
	public class stClientResourceLoadOverLoginCmd extends stLoginUserCmd
	{
		public var isnew:Boolean;
		public function stClientResourceLoadOverLoginCmd()
		{
			super();
			byParam = CLIENT_RESOURCE_LOADOVER_LOGIN_PARA;
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeBoolean(isnew);
		}
	}
}

//客户端资源加载完毕通知服务器
    /*const BYTE CLIENT_RESOURCE_LOADOVER_LOGIN_PARA = 12; 
    struct stClientResourceLoadOverLoginCmd : public stLogonUserCmd
    {   
        stClientResourceLoadOverLoginCmd()
        {   
            byParam = CLIENT_RESOURCE_LOADOVER_LOGIN_PARA;
            isnew = 0;
        }   
        BYTE isnew; //1:新角色
    };  */