package modulecommon.fun.aniObjectMgr 
{
	//import com.bit101.components.Component;
	/**
	 * ...
	 * @author 
	 */
	public class AniObjectMgr 
	{
		private var m_comInFly:Vector.<IAniObject>;	//缓冲中的DigitSprite
		private var m_comInBuffer:Vector.<IAniObject>;
		private var m_funCreate:Function;
		public function AniObjectMgr() 
		{
			m_comInFly = new Vector.<IAniObject>();
			m_comInBuffer = new Vector.<IAniObject>();
		}
		
		public function  createAniObject():IAniObject
		{			
			var ret:IAniObject;
			if (m_comInBuffer && m_comInBuffer.length)
			{
				ret = m_comInBuffer.pop();				
			}
			else
			{
				ret = m_funCreate();
				ret.mgr = this;
			}			
			m_comInFly.push(ret);
			return ret;
		}
		public function collectAniObjec(com:IAniObject):void
		{
			var i:int = m_comInFly.indexOf(com);
			if (i != -1)
			{
				m_comInFly.splice(i, 1);
			}
			m_comInBuffer.push(com);
		}
		
		public function dispose():void
		{
			var i:int;
			var ds:IAniObject;
			for (i = 0; i < m_comInFly.length; i++)
			{
				ds = m_comInFly[i];
				if (ds.hasParent)
				{
					ds.hide();
				}
				ds.dispose();
			}
			
			for (i = 0; i < m_comInBuffer.length; i++)
			{
				m_comInBuffer[i].dispose();
			}			
		}
		
		public function set createFun(fun:Function):void
		{
			m_funCreate = fun;
		}
		
	}

}