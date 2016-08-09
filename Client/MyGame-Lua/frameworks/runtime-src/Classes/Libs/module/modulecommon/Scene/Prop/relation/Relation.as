package modulecommon.scene.prop.relation
{
	public class Relation
	{
		public var m_relFnd:RelFriend;		// 好友关系		
		
		public function Relation()
		{
			m_relFnd = new RelFriend();			
		}
		
		public function dispose():void
		{
			
		}
	}
}