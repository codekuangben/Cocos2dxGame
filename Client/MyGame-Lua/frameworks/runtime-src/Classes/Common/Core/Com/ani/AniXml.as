package com.ani 
{
	/**
	 * ...
	 * @author 
	 */
	public class AniXml extends DigitAniBase 
	{
		private var m_ani:DigitAniBase;
		public function AniXml() 
		{
			
		}
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			var itemXML:XML;
			var localName:String;
			var aniClass:Class;
		
			var xmlList:XMLList = xml.elements();
			itemXML = xmlList[0];
			localName = itemXML.localName();
			aniClass = AniDef.s_nameToClass(localName);
			m_ani = new aniClass();
			m_ani.onEnd = onAniEnd;
			m_ani.parseXML(itemXML);		
		}
		override public function begin():void 
		{
			super.begin();
			m_ani.sprite = m_sp;
			m_ani.begin();
			
		}
		override public function dispose():void 
		{
			if (m_ani)
			{
				m_ani.dispose();
			}
			super.dispose();
		}
		override public function getAniByID(id:int):DigitAniBase
		{
			return m_ani.getAniByID(id);
		}
		override public function stop():void
		{
			super.stop();
			m_ani.stop();
		}
	}

}