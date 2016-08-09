package modulecommon.scene.prop.object 
{
	import org.ffilmation.engine.datatypes.IntPoint;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class Package 
	{
		private var m_heroID:uint;
		private var m_location:uint;
		private var m_iWidth:int;	//横轴方向，格子的数量
		private var m_iHeight:int;	//竖轴方向，格子的数量
		private var m_iSize:int;
		private var m_OpenedSize:int;	//已经开启的格子数量
		private var m_datas:Vector.<ZObject>;
		public function Package(heroID:uint, location:uint, width:int, height:int) 
		{
			m_heroID = heroID;
			m_location = location;
			
			m_iWidth = width;
			m_iHeight = height;
			m_iSize = m_iWidth * m_iHeight;
			m_OpenedSize = m_iSize;
			m_datas = new Vector.<ZObject>(m_iSize);						
		}
		
		public function addObject(obj:ZObject):void
		{
			var location:stObjLocation = obj.m_object.m_loation;
			setObject(location.x, location.y, obj);			
		}
		public function removeObject(obj:ZObject):void
		{
			var location:stObjLocation = obj.m_object.m_loation;
			setObject(location.x, location.y, null);		
		}
		public function getObject(x:int, y:int):ZObject
		{
			return m_datas[x + y * m_iWidth];
		}
		
		//调用此函数时，必须保证此包裹是装备包裹。
		//功能：返回装备包裹指定类型的装备得到
		public function getEquipInEquipPakage(type:int):ZObject
		{
			return m_datas[ZObjectDef.typeToEquipPos(type)];
		}
		
		//调用此函数时，必须保证此包裹是装备包裹。
		//功能：返回装备包裹指定类型的装备得到
		public function getEquipInEquipPakageByPos(y:int):ZObject
		{
			return m_datas[y];
		}
		
		public function getObjectByThisID(thisID:uint):ZObject
		{
			var i:int;
			for (i = 0; i < m_OpenedSize; i++)
			{
				if (m_datas[i] != null)
				{
					if (m_datas[i].thisID == thisID)
					{
						return m_datas[i];
					}
				}
			}
			return null;
		}
		private function setObject(x:int, y:int, obj:ZObject):void
		{
			m_datas[x + y * m_iWidth] = obj;
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
		public function clear():void
		{
			var i:int;
			for (i = 0; i < m_OpenedSize; i++)
			{
				m_datas[i] = null;
			}
		}
		public function execFun(fun:Function, param:Object = null):void
		{
			var i:int;
			var obj:ZObject;			
			
			for (i = 0; i < m_OpenedSize; i++)
			{
				obj = m_datas[i];
				if (obj != null)
				{
					fun(obj, param);				
				}
			}
		}
		
		public function datasByF(fun:Function):Array
		{
			var i:int;
			var obj:ZObject;
			
			var ret:Array = new Array();
			for (i = 0; i < m_OpenedSize; i++)
			{
				obj = m_datas[i];
				if (obj != null)
				{
					if(fun(obj))
					{
						ret.push(obj);
					}
				}
			}
			return ret;
		}
		
		public function findFirstEmptyGrid():IntPoint
		{
			var i:int;
			var ret:IntPoint;
			for (i = 0; i < m_OpenedSize; i++)
			{
				if (m_datas[i] == null)
				{
					ret = indexToPoint(i);
					break;
				}
			}
			return ret;
		}
		
		/*再向包裹中放入道具时，判断包裹是否已经满了
		 * 判断流程：
		 * 1. 如果有空格，则未满
		 * 2. 如果没有空格，但，存在id为objID的道具，且其未达到最大数量
		 */ 
		public function isFullOnPutObject(objID:uint):Boolean
		{
			var i:int;			
			for (i = 0; i < m_OpenedSize; i++)
			{
				if (m_datas[i] == null)
				{
					return false;				
				}
				if (m_datas[i].ObjID == objID && m_datas[i].m_object.num < m_datas[i].maxNum)
				{
					return false;
				}			
			}
			return true;
		}
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
		
		public function copyObjectsToList():Vector.<ZObject>
		{
			var ret:Vector.<ZObject> = new Vector.<ZObject>(m_iSize);
			var i:int;
			for (i = 0; i < m_iSize; i++)
			{
				ret[i] = m_datas[i];
			}
			return ret;
		}
			
		public function copyObjectsFromList(list:Vector.<ZObject>):void
		{
			var i:int;
			for (i = 0; i < m_iSize; i++)
			{
				m_datas[i] = list[i];
			}
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
		public function findFreeGrids(param:Object):void
		{
			var needNum:int = param["num"];
			if (needNum == 0)
			{
				return;
			}
			var list:Vector.<stObjLocation> = param["list"];
			var i:int;			
			var loc:stObjLocation;
			var pos2D:IntPoint;
			for (i = 0; i < m_OpenedSize; i++)
			{
				if (m_datas[i] == null)
				{
					loc = new stObjLocation();
					loc.heroid = m_heroID;
					loc.location = m_location;
					pos2D = indexToPoint(i);
					loc.x = pos2D.x;
					loc.y = pos2D.y;
					list.push(loc);
					needNum--;
					if (needNum == 0)
					{
						param["num"] = needNum;
						return;
					}
				}
			}
			param["num"] = needNum;
			
		}
		public function indexToPoint(index:int):IntPoint
		{
			return new IntPoint(index % m_iWidth, index / m_iWidth);
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