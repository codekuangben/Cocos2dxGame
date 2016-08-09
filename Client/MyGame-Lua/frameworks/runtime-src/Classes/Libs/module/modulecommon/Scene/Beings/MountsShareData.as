package modulecommon.scene.beings 
{
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	//import modulecommon.net.msg.mountscmd.stMountData;
	import modulecommon.scene.beings.MountsAttr;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TDataItem;
	import modulecommon.scene.prop.table.TMouseItem;
	
	import org.ffilmation.engine.helpers.fUtil;

	/**
	 * @brief 坐骑共享数据
	 */
	public class MountsShareData implements IMountsShareData
	{
		public var m_gkContext:GkContext;
		public var m_itemsLst:Vector.<Vector.<TMouseItem>>;
		public var m_bInit:Boolean;
		
		public var m_mountsTipData:MountsTipData;	// 共享提示数据

		public function MountsShareData(gk:GkContext)
		{
			m_gkContext = gk;
			m_itemsLst = new Vector.<Vector.<TMouseItem>>(MountsAttr.ePageCnt, true);
			var idx:uint = 0;
			while (idx < MountsAttr.ePageCnt)
			{
				m_itemsLst[idx] = new Vector.<TMouseItem>();
				++idx;
			}
			
			m_mountsTipData = new MountsTipData(m_gkContext);
		}
		
		public function buildLst():void
		{
			if (!m_bInit)
			{
				m_bInit = true;

				var lst:Vector.<TDataItem> = m_gkContext.m_dataTable.getTable(DataTable.TABLE_MOUNTS);
				var mounttype:uint = 0;
				var mounttypeandID:uint = 0;
				var dic:Dictionary;
				dic = new Dictionary();
				for each(var item:TDataItem in lst)
				{
					//mounttype = item.m_uID / 100000;
					mounttype = fUtil.mountsTblID2Type(item.m_uID);
					mounttypeandID = fUtil.mountsTblID2TypeAndID(item.m_uID);
					if (!dic[mounttypeandID])
					{
						if (!isInArray(m_itemsLst[0], item))
						{
							m_itemsLst[0].push(item);
						}
						if (!isInArray(m_itemsLst[mounttype], item))
						{
							m_itemsLst[mounttype].push(item);
						}
						dic[mounttypeandID] = 1;
					}
				}
			}
		}
		
		public function get itemsLst():Vector.<Vector.<TMouseItem>>
		{
			return m_itemsLst;
		}
		
		public function set itemsLst(value:Vector.<Vector.<TMouseItem>>):void
		{
			m_itemsLst = value;
		}
		
		// 判断元素是否在数组中
		public function isInArray(lst:Vector.<TMouseItem>, item):Boolean
		{
			if (lst.indexOf(item) != -1)
			{
				return true;
			}
			
			return false;
		}
	}
}