package modulecommon.scene.prop.table
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.DataResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import modulecommon.GkContext;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIEquipSys;
	//import flash.utils.getTimer;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import org.ffilmation.engine.helpers.fUtil;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class DataTable
	{
		public static const TABLENAME_TABLE:String = "asset/config/table.swf";
		
		public static const TABLE_NPCVISIT:uint = 1; //访问型NPC
		public static const TABLE_NPCBATTLE:uint = 2; //战斗型NPC
		public static const TABLE_OBJECT:uint = 3; //道具表
		public static const TABLE_EFFBASE:uint = 4; //特效基本表    
		
		public static const TABLE_SKILL:uint = 5; //技能基本表    
		public static const TABLE_FObj:uint = 6; //掉落物表
		public static const TABLE_MODELEFF:uint = 7; //模型特效表
		public static const TABLE_COMMON:uint = 8; //通用配置，key - value形式
		public static const TABLE_EFFECT:uint = 9; //特效表
		public static const TABLE_ROLESTATE:uint = 10; //特效表
		public static const TABLE_WUPROPERTY:uint = 11; //武将属性表
		public static const TABLE_WORLDMAP:uint = 12; //世界地图表
		public static const TABLE_EQUIPQH:uint = 13; //装备强化表
		public static const TABLE_EQUIPQHUPPER:uint = 14; //装备强化表上限表
		public static const TABLE_GUOGUANZHANJIANG:uint = 15; //过关斩将表
		public static const TABLE_WJZHANLILIMIT:uint = 16; //武将（包括玩家）战力上限表
		public static const TABLE_MUSIC:uint = 17; //音效表
		public static const TABLE_EQUIPADVANCE:uint = 18; //装备颜色提升表
		public static const TABLE_SENSITIVEWORD:uint = 19; //敏感词汇表
		
		public static const TABLE_MAP:uint = 20; //地图配置文件
		public static const TABLE_GROUNDOBJECT:uint = 21; //地上物配置
		public static const TABLE_HEROGROWUP:uint = 22; //武将成长表
		public static const TABLE_ZHANXING:uint = 23; //占星表，记录每个神兵的信息
		public static const TABLE_ZHANXING_Number:uint = 24; //占星数值表
		public static const TABLE_ATTRBUFFER:uint = 25; //人物属性加成Buffer
		public static const TABLE_EQUIP_LEVEL_ADVANCE:uint = 26; //装备等级提升表
		public static const TABLE_EQUIP_XILIAN:uint = 27; //装备洗炼表
		public static const TABLE_Tianfu_Xiaoguo:uint = 28; //天赋效果
		public static const TABLE_NPCBATTLE_MODEL:uint = 30; //战斗npc模型表
		
		public static const TABLE_MOUNTS:uint = 31; // 坐骑
		public static const TABLE_EXPRESSION:uint = 32; // 表情表
		
		private var m_gkContext:GkContext;
		
		private var m_dicTable:Dictionary;
		private var m_dicTableName:Dictionary;		
		
		private var m_res:SWFResource;
		
		public function DataTable(gk:GkContext)
		{
			m_gkContext = gk;
			
			m_dicTable = new Dictionary();
			
			m_dicTableName = new Dictionary();
			var dic:Dictionary = m_dicTableName;
			
			dic[TABLE_NPCVISIT] = new TableConfigItem("NpcVisitTable", TNpcVisitItem, "任务地图NPC表.xlsx");
			dic[TABLE_NPCBATTLE] = new TableConfigItem("NpcBattleTable", TNpcBattleItem, "战斗武将npc表.xlsx");
			dic[TABLE_OBJECT] = new TableConfigItem("ObjectTable", TObjectBaseItem, "道具表.xlsx");
			dic[TABLE_EFFBASE] = new TableConfigItem("EffBaseTable", TEffBaseItem, "技能特效表.xlsx");
			
			dic[TABLE_SKILL] = new TableConfigItem("SkBaseTable", TSkillBaseItem, "战术天赋锦囊表.xlsx");
			dic[TABLE_FObj] = new TableConfigItem("FOjectTable", TFObjectItem, "掉落物表.xlsx");
			dic[TABLE_MODELEFF] = new TableConfigItem("FModeleffTable", TModelEffItem, "模型特效配置表.xlsx");
			dic[TABLE_COMMON] = new TableConfigItem("CommonTable", TCommonBaseItem, "通用配置.xlsx");
			dic[TABLE_EFFECT] = new TableConfigItem("FEffectTable", TEffectItem, "特效偏移配置表.xlsx");
			dic[TABLE_ROLESTATE] = new TableConfigItem("RoleStateTable", TRoleStateItem, "人物状态表.xlsx");
			dic[TABLE_WUPROPERTY] = new TableConfigItem("WuPropertyTable", TWuPropertyItem, "战斗武将属性表.xlsx");
			dic[TABLE_WORLDMAP] = new TableConfigItem("WorldmapTable", TWorldmapItem, "世界地图.xlsx");
			dic[TABLE_EQUIPQHUPPER] = new TableConfigItem("equipenchanceupper", TEnchUpperItem, "强化表.xlsx(强化等级上限)");
			dic[TABLE_WJZHANLILIMIT] = new TableConfigItem("wjzhanliTable", TWJZhanliItem, "武将战力上限.xlsx(武将战力上限)");
			dic[TABLE_MUSIC] = new TableConfigItem("musicTable", TMusicItem, "音效配置表.xlsx");
			dic[TABLE_EQUIPADVANCE] = new TableConfigItem("equipadvanceTable", TEquipColorAdvanceItem, "强化表.xlsx - 装备进阶表");
			dic[TABLE_SENSITIVEWORD] = new TableConfigItem("sensitivewordTable", TSensitiveWordItem, "敏感词库.xlsx - 敏感词库");
			
			dic[TABLE_MAP] = new TableConfigItem("mappropclientTable", TMapItem, "地图属性表.xlsx - 地图属性表");
			dic[TABLE_GROUNDOBJECT] = new TableConfigItem("thingclientTable", TGroundObjectItem, "地物表.xlsx - 地物表");
			dic[TABLE_HEROGROWUP] = new TableConfigItem("herogrowupTable", THeroGrowupItem, "战斗武将属性表.xlsx(武将成长表)");
			dic[TABLE_ZHANXING] = new TableConfigItem("zhanxingTable", TZhanxingItem, "占星表.xlsx - 神兵表");
			dic[TABLE_ZHANXING_Number] = new TableConfigItem("zhanxingnumberTable", TZhanxingNumberItem, "占星表.xlsx - 数值表");
			dic[TABLE_ATTRBUFFER] = new TableConfigItem("attrbufferTable", TAttrBufferItem, "buffer表.xlsx");
			dic[TABLE_EQUIP_LEVEL_ADVANCE] = new TableConfigItem("equip_leveladvance_clientTable", TEquipLevelAdvanceItem, "强化表.xlsx - 装备等级提升表");
			dic[TABLE_EQUIP_XILIAN] = new TableConfigItem("equipxilianTable", TEquipXilianItem, "洗练属性表.xlsx - 洗练属性");
			dic[TABLE_Tianfu_Xiaoguo] = new TableConfigItem("tianfu_xiaoguoTable", TTianfuXiaoguoItem, "战术天赋锦囊表.xlsx - 客户端天赋效果");
			dic[TABLE_NPCBATTLE_MODEL] = new TableConfigItem("battlenpc_modelTable", TNpcBattleModel, "战斗武将npc表.xlsx - 模型表");
			dic[TABLE_EXPRESSION] = new TableConfigItem("expression_Table", TExpressionItem, "表情表.xlsx - 表情表");
			dic[TABLE_GUOGUANZHANJIANG] = new TableConfigItem("guoguanzhanjiangTable", TGuoguanzhanjiangBase, "过关斩将表.xlsx");
			dic[TABLE_EQUIPQH] = new TableConfigItem("equipenchanceTable", TEquipEnchance, "强化表.xlsx");
			dic[TABLE_MOUNTS] = new TableConfigItem("mounts_Table", TMouseItem, "坐骑表.xlsx - 坐骑"); // 坐骑
			TNpcBattleItem.m_sDataTable = this;
		}
		
		/*protected function loadTable(res:SWFResource, fconfig:FileConfigItem):void
		{
			var key:String;
			var vec:Vector.<TDataItem>;
			var bytes:ByteArray;
			var configItem:TableConfigItem;
			var dic:Dictionary = fconfig.m_dic;
			
			//m_gkContext.addLog("loadTabel" + getTimer());
			for (key in dic)
			{
				configItem = dic[key];
				bytes = res.getExportedAsset(configItem.m_tableName) as ByteArray;
				if (bytes == null)
				{
					Logger.info(null, "loadTable", "table.swf中没有：" + configItem.m_tableName);
					continue;
				}
				
				m_dicTable[key] = readNpcTable(configItem.m_tableClass, bytes);
				
			}
			
			//m_gkContext.addLog("loadTabelEnd" + getTimer());
		}*/
		
		private function readNpcTable(tableClass:Class, bytes:ByteArray):Vector.<TDataItem>
		{
			bytes.endian = Endian.LITTLE_ENDIAN;
			var len:uint = bytes.readUnsignedInt();
			var i:uint = 0;
			var item:TDataItem;
			
			var table:Vector.<TDataItem> = new Vector.<TDataItem>(len, true);
			for (i = 0; i < len; i++)
			{
				item = new tableClass();
				item.parseByteArray(bytes);
				table[i] = item;
			}
			return table;
		}
		
		public function getTable(tableID:uint):Vector.<TDataItem>
		{
			var table:Vector.<TDataItem> = m_dicTable[tableID];
			if (table == null)
			{
				loadOneTable(tableID);
				table = m_dicTable[tableID];
			}
			return table;
		}
		
		public function getItem(tableID:uint, itemID:uint):TDataItem
		{
			var table:Vector.<TDataItem> = m_dicTable[tableID];
			if (table == null)
			{
				loadOneTable(tableID);
				table = m_dicTable[tableID];
			}
			var ret:TDataItem = DataTable.findDataItem(table, itemID);
			if (!ret && m_dicTable[tableID]) // 音效可能还没加载表格的时候就查找音效表,因此加 m_dicTable[tableID] 判断
			{
				// 特效表中 402 是士气特效，这个特效就放在格子中央，不用配表
				if (tableID != TABLE_EFFECT && itemID != 402)
				{
					var str:String = "tbl表(" + getTableName(tableID) + ")缺少编号为" + itemID + "的记录";
					str = fUtil.getStackInfo(str);
					DebugBox.info(str);
				}
			}
			return ret;
		}
		
		private function loadOneTable(tableID:uint):void
		{			
			var configItem:TableConfigItem = m_dicTableName[tableID];
			
			var bytes:ByteArray = m_res.getExportedAsset(configItem.m_tableName) as ByteArray;
			if (bytes == null)
			{
				Logger.info(null, "loadTable", "table.swf中没有：" + configItem.m_tableName);
			}
			
			m_dicTable[tableID] = readNpcTable(configItem.m_tableClass, bytes);
		}
		
		//与getItem不同的方面在于：如果找到对应的项，不报错
		public function getItemEx(tableID:uint, itemID:uint):TDataItem
		{
			var table:Vector.<TDataItem> = m_dicTable[tableID];
			if (table == null)
			{
				loadOneTable(tableID);
				table = m_dicTable[tableID];
			}
			
			var ret:TDataItem = DataTable.findDataItem(table, itemID);
			return ret;
		}
		
		public function getTableName(tableID:uint):String
		{
			var fConfig:TableConfigItem = m_dicTableName[tableID];
			if (fConfig)
			{
				return fConfig.m_excelName;
			}			
			return "";
		}
		
		public function loadInitTable(res:SWFResource):void
		{			
			m_res = res;
			//loadTable(res, m_dicTableName[res.filename]);
			//loadOneTable(TABLE_SENSITIVEWORD);
			var configItem:TableConfigItem = m_dicTableName[TABLE_SENSITIVEWORD];
			var bytes:ByteArray = m_res.getExportedAsset(configItem.m_tableName) as ByteArray;
			bytes.endian = Endian.LITTLE_ENDIAN;
			m_gkContext.m_SWMgr.init(bytes);			
		}
		public static function findDataItem(table:Vector.<TDataItem>, id:uint):TDataItem
		{
			// bug: 登陆模块的时候表是不加载的,因此这个时候获取表的数据就会有问题
			if (!table)
			{
				return null;
			}
			
			var size:int = table.length;
			var low:int = 0;
			var high:int = size - 1;
			var middle:int = 0;
			var idCur:uint;
			
			while (low <= high)
			{
				middle = (low + high) / 2;
				idCur = table[middle].m_uID;
				if (idCur == id)
				{
					break;
				}
				if (id < idCur)
				{
					high = middle - 1;
				}
				else
				{
					low = middle + 1;
				}
			}
			
			if (low <= high)
			{
				return table[middle];
			}
			return null;
		}
	}
}