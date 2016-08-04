package modulefight.digitani 
{
	import com.util.DebugBox;
	import common.Context;
	import flash.display.DisplayObjectContainer;	
	import flash.utils.Dictionary;
	import org.ffilmation.engine.helpers.fUtil;
	/**
	 * ...
	 * @author 
	 */
	public class HPDigitMgr 
	{		
		private var m_context:Context;
		private var m_digitInFly:Vector.<DigitSprite>;	//缓冲中的DigitSprite
		private var m_dicBuffer:Dictionary;		
		
		public function HPDigitMgr(con:Context)
		{
			m_digitInFly = new Vector.<DigitSprite>();
			m_dicBuffer = new Dictionary();
			m_context = con;
		}
		
		public function emitDigit(type:int, v:int, damType2:int, xPos:Number, yPos:Number, parent:DisplayObjectContainer):void
		{
			try
			{
			var sw:DigitSprite = getDigit(type);			
			m_digitInFly.push(sw);
			
			parent.addChild(sw);
			sw.x = xPos;
			sw.y = yPos;
			sw.setDigit(v,damType2);		
			}
			catch (e:Error)
			{
				var strLog:String = fUtil.keyValueToString("type", type, "sw", sw, "parent", parent);
				DebugBox.sendToDataBase(strLog);
			}
		}
		
		public function  getDigit(type:int):DigitSprite
		{
			var list:Vector.<DigitSprite> = m_dicBuffer[type];
			if (list&&list.length)
			{
				return list.pop();
			}
			
			return new DigitSprite(m_context,type,this);
		}
		
		public function collectDigit(sw:DigitSprite):void
		{	
			if (sw.parent)
			{
				sw.parent.removeChild(sw);
			}
			var i:int = m_digitInFly.indexOf(sw);
			if (i != -1)
			{
				m_digitInFly.splice(i, 1);
			}
			var list:Vector.<DigitSprite> = m_dicBuffer[sw.type];
			if (list == null)
			{				
				list = new Vector.<DigitSprite>();
				m_dicBuffer[sw.type] = list;
			}
			list.push(sw);			
		}

		public function dispose():void
		{
			var i:int;
			var ds:DigitSprite;
			for (i = 0; i < m_digitInFly.length; i++)
			{
				ds = m_digitInFly[i];
				if (ds.parent)
				{
					ds.parent.removeChild(ds);
				}
				ds.dispose();
			}
			var list:Vector.<DigitSprite>;
			for each(list in m_dicBuffer)
			{
				for (i = 0; i < list.length; i++)
				{
					list[i].dispose();
				}
			}
			m_digitInFly = null;
			m_dicBuffer = null;
			m_context = null;
		}
	}
}