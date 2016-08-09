package datast.reuse 
{	
	/**
	 * ...
	 * @author ...
	 * 可重复利用的对象,可以用此类来管理
	 */
	public class MgrForReuse 
	{
		protected var m_maxNum:int;
		protected var m_funCreateObject:Function;
		protected var m_listForUse:Vector.<IObjectForReuse>;	//处于使用中状态的列表
		protected var m_listForReserve:Vector.<IObjectForReuse>;	//处于后备状态的列表.Reserve取其后备之意
		public function MgrForReuse() 
		{			
			m_listForUse = new Vector.<IObjectForReuse>();
			m_listForReserve = new Vector.<IObjectForReuse>();
		}
		
		public function setParam(funCreateObject:Function, maxNum:int):void
		{
			m_funCreateObject = funCreateObject;
			m_maxNum = maxNum;
		}
			
		public function allocate(paramForInit:Object=null):IObjectForReuse
		{
			var ret:IObjectForReuse;
			if (m_listForReserve.length > 0)
			{
				ret = m_listForReserve.pop();
			}
			else
			{
				ret = m_funCreateObject();
				ret.funReserveSelf = reserveObject;
			}
			m_listForUse.push(ret);
			ret.initData(paramForInit);
			return ret;
		}
		public function reserveObject(obj:IObjectForReuse):void
		{
			var i:int = m_listForUse.indexOf(obj);
			if (i != -1)
			{
				m_listForUse.splice(i, 1);
			}
			if (m_listForReserve.length >= m_maxNum)
			{
				obj.dispose();
			}
			else
			{
				m_listForReserve.push(obj);
			}
		}
		public function dispose():void 
		{
			var item:IObjectForReuse;
			for each(item in m_listForUse)
			{
				item.dispose();
			}		
			m_listForUse.length = 0;
			for each(item in m_listForReserve)
			{
				item.dispose();
			}		
			m_listForReserve.length = 0;
			m_funCreateObject = null;
		}
	}

}