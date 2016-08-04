package modulefight.digitani
{
	import com.util.DebugBox;
	import common.Context;
	import flash.display.DisplayObjectContainer;	
	import flash.utils.Dictionary;
	import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.FightEn;
	import modulecommon.GkContext;

	/**
	 * @brief 头顶冒一些文字,目前用于 TASK #104 人物状态战斗美术字表现
	 * */
	public class BBNameMgr
	{
		private var m_context:Context;
		private var m_nameInFly:Vector.<BBNameItem>;	// 对象池
		private var m_dicBuffer:Dictionary;		
		
		public function BBNameMgr(con:Context)
		{
			m_nameInFly = new Vector.<BBNameItem>();
			m_dicBuffer = new Dictionary();
			m_context = con;
		}
		
		public function emitNamePic(value:stEntryState, xPos:Number, yPos:Number, parent:DisplayObjectContainer):void
		{
			var type:uint = 0;
			if (value.base.mode == 1)	//增益
			{
				type = FightEn.NTUp;
			}
			else
			{
				type = FightEn.NTDn;
			}
			emitNamePicEx(type, value.base.m_picname,xPos,yPos,parent);			
		}
		
		public function emitNamePicEx(type:int, iPicname:int, xPos:Number, yPos:Number, parent:DisplayObjectContainer):void
		{
			try
			{
			var sw:BBNameItem = getDigit(type);			
			m_nameInFly.push(sw);
			
			parent.addChild(sw);
			sw.x = xPos;
			sw.y = yPos;
			sw.setStateEn(iPicname.toString());		// 设置 buff  
			}
			catch (e:Error)
			{
				DebugBox.sendToDataBase("BBNameMgr::emitNamePicEx"+" sw="+sw+", m_nameInFly="+m_nameInFly+",parent="+parent);
			}
		}
		
		public function getDigit(type:int):BBNameItem
		{
			var list:Vector.<BBNameItem> = m_dicBuffer[type];
			if (list&&list.length)
			{
				return list.pop();
			}
			
			return new BBNameItem(m_context.m_gkcontext as GkContext,type,this);
		}
		
		public function collectDigit(sw:BBNameItem):void
		{	
			if (sw.parent)
			{
				sw.parent.removeChild(sw);
			}
			var i:int = m_nameInFly.indexOf(sw);
			if (i != -1)
			{
				m_nameInFly.splice(i, 1);
			}
			var list:Vector.<BBNameItem> = m_dicBuffer[sw.type];
			if (list == null)
			{				
				list = new Vector.<BBNameItem>();
				m_dicBuffer[sw.type] = list;
			}
			list.push(sw);			
		}
		
		public function dispose():void
		{
			var i:int;
			var ds:BBNameItem;
			for (i = 0; i < m_nameInFly.length; i++)
			{
				ds = m_nameInFly[i];
				if (ds.parent)
				{
					ds.parent.removeChild(ds);
				}
				ds.dispose();
			}
			var list:Vector.<BBNameItem>;
			for each(list in m_dicBuffer)
			{
				for (i = 0; i < list.length; i++)
				{
					list[i].dispose();
				}
			}
			m_nameInFly = null;
			m_dicBuffer = null;
		}
	}
}