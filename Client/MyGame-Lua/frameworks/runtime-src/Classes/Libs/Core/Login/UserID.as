package login 
{
	/**
	 * ...
	 * @author 
	 * 平台唯一id,网站平台唯一标识一个玩家身份的id
	 * #define MAX_UID_LEN 80
	 */
	import flash.utils.ByteArray;
	import com.util.UtilTools;
	public class UserID 
	{
		public static const MAX_UID_LEN:int = 80;
		private var m_userID:String
		public function UserID() 
		{
			
		}
		
		public function setByString(id:String):void
		{
			m_userID = id;
		}
		public function deserialize(byte:ByteArray):void
		{
			m_userID = UtilTools.readStr(byte, MAX_UID_LEN);
		}
		public function serialize(byte:ByteArray):void
		{
			UtilTools.writeStr(byte, m_userID, MAX_UID_LEN);
		}
		
		public function get content():String
		{
			if (m_userID)
			{
				return m_userID;
			}
			return "";
		}
		
	}

}