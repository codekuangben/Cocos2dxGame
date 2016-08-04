package game.ui.uipaoshangsys
{
	import game.ui.uipaoshangsys.mark.IMarkData;
	import game.ui.uipaoshangsys.msg.BusinessUser;
	import game.ui.uipaoshangsys.msg.GoodsInfo;
	//import game.ui.uipaoshangsys.msg.notifyBusinessDataUserCmd;
	import game.ui.uipaoshangsys.msg.stRetBusinessUiDataUserCmd;
	import game.ui.uipaoshangsys.xml.XmlData;
	import modulecommon.GkContext;
	import modulecommon.ui.Form;
	import modulecommon.commonfuntion.imloader.ModuleResLoader;
	
	/**
	 * @brief
	 */
	public class DataPaoShang
	{
		public var m_gkcontext:GkContext;
		public var m_form:Form;
		public var m_onUIClose:Function;
		
		public var m_resLoader:ModuleResLoader;
		public var m_xmlData:XmlData;
		public var m_markData:IMarkData;
		
		//public var m_goodsLst:Vector.<GoodsInfo>;
		
		//public var m_basicInfo:notifyBusinessDataUserCmd;		// 跑商自己的基本信息
		//public var m_markInfo:stRetBusinessUiDataUserCmd;		// 
		public var m_basicInfo:stRetBusinessUiDataUserCmd;
		
		public var m_bChanging:Boolean;						// 改变货物过程中
		
		public function DataPaoShang()
		{
			m_xmlData = new XmlData();
			//m_goodsLst = new Vector.<GoodsInfo>(5, true);
			//m_basicInfo = new notifyBusinessDataUserCmd();
			//m_markInfo = new stRetBusinessUiDataUserCmd();
			m_basicInfo = new stRetBusinessUiDataUserCmd();
		}
		
		public function dispose():void
		{
			m_markData.dispose();
			m_resLoader.unloadRes();
			m_resLoader = null;
		}
		
		// 插入排序，进行深度排序，因为很多时候基本是有序的，因此使用插入排序
		public function insortSort(sortarr:Vector.<GoodsInfo>):void
		{
			var i:int = 0;
			var k:int = 0;
			var val:GoodsInfo = null;
			
			for(i = 1; i < sortarr.length ; i++)
			{
				k = i - 1;
				val = sortarr[i];
				while(k >= 0 && sortarr[k].m_goodsID > val.m_goodsID)
				{
					sortarr[k+1] = sortarr[k];
					k--;
				}
				
				sortarr[k + 1] = val;
			}
		}
		
		// 插入排序，进行深度排序，因为很多时候基本是有序的，因此使用插入排序
		public function insortSortInt(sortarr:Vector.<uint>):void
		{
			var i:int = 0;
			var k:int = 0;
			var val:uint = 0;
			
			for(i = 1; i < sortarr.length ; i++)
			{
				k = i - 1;
				val = sortarr[i];
				while(k >= 0 && sortarr[k] > val)
				{
					sortarr[k+1] = sortarr[k];
					k--;
				}
				
				sortarr[k + 1] = val;
			}
		}
		
		// 根据服务器端的 id ，获取某个跑商信息
		public function getBusinessUser(id:uint):BusinessUser
		{
			for each(var item:BusinessUser in m_basicInfo.data)
			{
				if (item.id == id)
				{
					return item;
				}
			}
			
			return null;
		}
	}
}