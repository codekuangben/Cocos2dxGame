package modulecommon.scene.prop
{
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.XMLResource;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.ITbl;
	import flash.utils.Dictionary;
	import com.pblabs.engine.debug.Logger;
	//import modulecommon.scene.prop.table.NpcTable;
	import modulecommon.scene.prop.table.UICfgTable;
	/**
	 * ...
	 * @author 
	 */
	public class TableManager implements ITableManager
	{
		public var m_gkcontext:GkContext;
		public var m_id2Tbl:Dictionary;		// 表 ID 到表的映射    
		public var m_path2Tbl:Dictionary;	// 表路径到表映射    
		
		public function TableManager(context:GkContext) 
		{
			m_gkcontext = context;
			m_id2Tbl = new Dictionary();
			m_path2Tbl = new Dictionary();
		}
		
		// 获取一个表，自己转换成自己的表使用   
		public function getTable(id:uint):ITbl
		{
			return m_id2Tbl[id];
		}
		
		// 初始化表的内容     
		public function initTbl():void
		{
			// test: 加载 npc 表    
			//m_id2Tbl[EntityCValue.TBLNpc] = new NpcTable();
			//var path:String = m_gkcontext.m_context.m_pathFunc(EntityCValue.TBLNpcBase, EntityCValue.RESPXML);
			//m_path2Tbl[path] = m_id2Tbl[EntityCValue.TBLNpc];
			//loadTbl(EntityCValue.TBLNpcBase);
			
			// test: 加载 UI 配置表 
			//var uicfg:UICfgTable = new UICfgTable();
		}
		
		// 卸载所有表格   
		public function disposeTbl():void
		{
			
		}
		
		public function loadTbl(id:uint):void
		{
			var path:String = m_gkcontext.m_context.m_path.getPathByID(id, EntityCValue.RESPXML);
			m_gkcontext.m_context.m_resMgr.load(path, XMLResource, onTblLoaded, onTblFailed);
		}
		
		// 表加载成功   
		public function onTblLoaded(event:ResourceEvent):void
		{
			var res:XMLResource = (event.resourceObject as XMLResource);
			var path:String = res.filename;
			m_path2Tbl[path].initXML(res.XMLData, EntityCValue.RESTXML);
			
			m_path2Tbl[path] = null;
			delete m_path2Tbl[path];
		}
		
		// 表加载失败   
		public function onTblFailed(event:ResourceEvent):void
		{
			// 日志输出
			Logger.error(null, null, "table: " + event.resourceObject.filename + "load failed");
			// 清除其它内容    
		}
	}
}