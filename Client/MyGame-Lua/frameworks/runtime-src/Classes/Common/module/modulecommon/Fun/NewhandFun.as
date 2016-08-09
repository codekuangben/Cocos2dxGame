package modulecommon.fun 
{
	import modulecommon.GkContext;
	import flash.geom.Point;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class NewhandFun 
	{
		private var m_gkContext:GkContext;
		public var m_pos:Point;
		public var m_rotation:Number;
		public function NewhandFun(gk:GkContext) 
		{
			m_gkContext = gk;
		}
		
		public function flyTo(pos:Point, rotation:Number):void
		{
			if (m_gkContext.m_UIs.newhandPro != null)
			{
				m_gkContext.m_UIs.newhandPro.flyTo(pos, rotation);
			}
			else
			{				
				m_pos = pos;
				m_rotation = rotation;
				m_gkContext.m_UIMgr.loadForm(UIFormID.UINewhandPrompt);
			}			
		}
		public function moveTo(pos:Point, rotation:Number):void
		{
			if (m_gkContext.m_UIs.newhandPro != null)
			{
				m_gkContext.m_UIs.newhandPro.moveTo(pos, rotation);
			}
			else
			{
				m_pos = pos;
				m_rotation = rotation;
				m_gkContext.m_UIMgr.loadForm(UIFormID.UINewhandPrompt);
			}
		}
		
	}

}