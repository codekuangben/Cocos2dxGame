package com.ani 
{
	/**
	 * ...
	 * @author 
	 * 并行执行的动画,所有动画结束后,才算结束
	 */
	public class AniComposeParallel extends DigitAniBase 
	{
		private var m_aniList:Array;
		public function AniComposeParallel() 
		{
			m_aniList = new Array();
		}
		override public function begin():void 
		{			
			if (m_aniList.length ==0 )
			{
				if (m_onEnd != null)
				{
					m_onEnd();				
				}
				return;
			}
			var i:int = 0;
			var n:int = m_aniList.length;
			var ani:DigitAniBase
			for (; i < n; i++)
			{
				ani = m_aniList[i];
				ani.sprite = this.m_sp;
				ani.onEnd = onAniComposeEnd;
				ani.begin();
			}
			super.begin();
		}
		
		override public function stop():void
		{
			super.stop();
			var ani:DigitAniBase;
			for each(ani in m_aniList)
			{
				ani.stop();
			}
		}
		
		private function onAniComposeEnd():void
		{
			var i:int = 0;
			var n:int = m_aniList.length;
			var ani:DigitAniBase
			for (; i < n; i++)
			{
				if (m_aniList[i].bRun)
				{
					return;
				}				
			}
			if (m_onEnd != null)
			{
				m_onEnd();				
			}
		}
		override public function dispose():void 
		{
			var i:int = 0;
			var n:int = m_aniList.length;
			for (; i < n; i++)
			{
				m_aniList[i].dispose();
			}
			m_aniList.length = 0;
			super.dispose();
		}
		public function setAniList(list:Array):void
		{
			m_aniList = list;
		}
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			var itemXML:XML;
			var localName:String;
			var aniClass:Class;
			var aniBase:DigitAniBase;
			var list:Array = new Array();
			for each(itemXML in xml.elements())
			{
				localName = itemXML.localName();
				aniClass = AniDef.s_nameToClass(localName);
				if (aniClass)
				{
					aniBase = new aniClass();
					aniBase.parseXML(itemXML);
					list.push(aniBase);
				}				
			}
			
			setAniList(list);
		}
		
		override public function getAniByID(id:int):DigitAniBase
		{
			var aniBase:DigitAniBase;
			var retBase:DigitAniBase;
			for each(aniBase in m_aniList)
			{
				retBase = aniBase.getAniByID(id);
				if (retBase)
				{
					return retBase;
				}
			}
			return retBase;
		}
	}

}