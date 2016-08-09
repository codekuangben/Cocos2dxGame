package modulecommon.scene.zhanxing 
{
	import modulecommon.net.msg.zhanXingCmd.stLocation;
	/**
	 * ...
	 * @author ...
	 */
	public class PackageStar 
	{		
		private var m_location:uint;
		private var m_iWidth:int;	//横轴方向，格子的数量
		private var m_iHeight:int;	//竖轴方向，格子的数量
		private var m_iSize:int;
		private var m_OpenedSize:int;	//已经开启的格子数量
		private var m_datas:Vector.<ZStar>;
		public function PackageStar(location:uint, width:int, height:int) 
		{			
			m_location = location;
			
			m_iWidth = width;
			m_iHeight = height;
			m_iSize = m_iWidth * m_iHeight;
			m_OpenedSize = m_iSize;
			m_datas = new Vector.<ZStar>(m_iSize);						
		}
		
		public function addStar(obj:ZStar):void
		{
			var location:stLocation = obj.m_tStar.m_location;
			setStar(location.x, location.y, obj);			
		}
		public function removeStar(obj:ZStar):void
		{
			var location:stLocation = obj.m_tStar.m_location;
			setStar(location.x, location.y, null);		
		}
		public function getStar(x:int, y:int):ZStar
		{
			return m_datas[x + y * m_iWidth];
		}		
		public function isLock(x:int, y:int):Boolean
		{
			var i:int = x + y * m_iWidth;
			return i >= m_OpenedSize;
		}
		public function getStarByThisID(thisID:uint):ZStar
		{
			var i:int;
			var star:ZStar;
			for (i = 0; i < m_OpenedSize; i++)
			{
				star = m_datas[i];
				if (star != null)
				{
					if (star.m_tStar.thisid == thisID)
					{
						return star;
					}
				}
			}
			return null;
		}
		private function setStar(x:int, y:int, obj:ZStar):void
		{
			m_datas[x + y * m_iWidth] = obj;
		}
		
		public function xyToIndex(x:int, y:int):int
		{
			return x + y * m_iWidth;
		}
		
		public function get datas():Array
		{
			var i:int;
			var ret:Array = new Array();
			for (i = 0; i < m_OpenedSize; i++)
			{
				if (m_datas[i] != null)
				{
					ret.push(m_datas[i]);
				}
			}
			return ret;
		}
		
		public function execFun(fun:Function, param:Object = null):void
		{
			var i:int;
			var obj:ZStar;			
			
			for (i = 0; i < m_OpenedSize; i++)
			{
				obj = m_datas[i];
				if (obj != null)
				{
					fun(obj, param);				
				}
			}
		}
		public function clear():void
		{
			var i:int;
			for (i = 0; i < m_OpenedSize; i++)
			{
				m_datas[i] = null;
			}
		}
		
		
		/*再向包裹中放入道具时，判断包裹是否已经满了
		 * 判断流程：
		 * 1. 如果有空格，则未满
		 * 2. 如果没有空格，但，存在id为objID的道具，且其未达到最大数量
		 */ 
		
		public function hasObject():Boolean
		{
			var i:int;			
			for (i = 0; i < m_OpenedSize; i++)
			{
				if (m_datas[i] != null)
				{
					return true;				
				}
						
			}
			return false;
		}
		public function get numOfObjects():int
		{
			var ret:int=0;
			var i:int;			
			for (i = 0; i < m_OpenedSize; i++)
			{
				if (m_datas[i] != null)
				{
					ret++;			
				}
			}
			return ret;
		}		
		
		public function get numOfFreeGrids():int
		{
			return m_OpenedSize-numOfObjects;
		}
		
		

		public function get iWidth():int 
		{
			return m_iWidth;
		}
		
		public function get iHeight():int 
		{
			return m_iHeight;
		}
		
		public function get size():int
		{
			return m_iSize;
		}
		
		public function set openedSize(n:int):void
		{
			m_OpenedSize = n;
		}
		
		public function get openedSize():int
		{
			return m_OpenedSize;
		}
		
	}

}