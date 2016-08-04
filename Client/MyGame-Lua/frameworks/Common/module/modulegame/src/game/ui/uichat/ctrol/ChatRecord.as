package game.ui.uichat.ctrol 
{
	import flash.utils.Dictionary;
	import modulecommon.scene.prop.object.T_Object;
	/**
	 * ...
	 * @author ...
	 */
	public class ChatRecord 
	{
		private var m_dicZObject:Dictionary;
		public var m_data:XML;
		public function ChatRecord() 
		{
			m_dicZObject = new Dictionary();
		}
		public function setDicObject(data:Dictionary):void
		{
			var key:*;
			for (key in data)
			{
				m_dicZObject[key] = data[key];
			}
		}
		public function get dicObject():Dictionary
		{
			return m_dicZObject;
		}
		
		public function getObjectList():Vector.<T_Object>
		{
			var tObject:T_Object;
			var retList:Vector.<T_Object>;
			for each(tObject in m_dicZObject)
			{
				if (retList == null)
				{
					retList = new Vector.<T_Object>();
				}
				retList.push(tObject);
			}
			return retList;
		}
		
		
	}

}