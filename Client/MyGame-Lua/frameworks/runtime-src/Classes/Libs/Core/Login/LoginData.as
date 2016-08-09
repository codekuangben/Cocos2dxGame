package login 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class LoginData
	{
		public static const LOGINTYPE_Login:int = 0;	//玩家登陆
		public static const LOGINTYPE_CrossZone:int = 1;	//玩家跨区
		
	
		public var m_accid:uint;
		public var m_userID:UserID;	//由平台定义的用户ID
		public var m_charIDInPlatform:uint = 23;	//网站平台唯一标识一个玩家身份的id
		
		public var m_platform_Qianduan:int = 2;	//角色所属的平台
		public var m_ZoneID_Qianduan:int = 1000;	//角色所属的前端区
		
		public var m_bLogin_byPlatform:Boolean;//true - 通过平台（例如新浪，360等）登陆游戏
		public function LoginData()
		{
			
		}
		
	}

}