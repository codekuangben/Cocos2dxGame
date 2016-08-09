package modulecommon.scene.prop.job 
{
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TCommonBaseItem;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class Soldier 
	{		
		public static const ShenqiangJinWei:int = 1101;	//步兵
		public static const Zhongji:int = 1102;	//重戟兵
		
		public static const Daodun:int = 1201;	//盾兵
		public static const Zhongbu:int = 1202;	//重步兵
		public static const Qiangdao:int = 1203;	//强盗
		public static const Judun:int = 1204;	//巨盾兵
		
		public static const Zhongqi:int = 1301;	//骑兵
		public static const Qingqi:int = 1302;	//轻骑兵
		public static const Fuqi:int = 1303;	//斧骑兵
		
		//------------
		public static const Menke:int = 2501;	//谋士
		public static const Ceshi:int = 2502;	//策士
		public static const Moushi:int = 2503;	//谋士
				
		public static const Yueshi:int = 2601;	//礼官
		public static const Wunniang:int = 2602;	//舞娘 
		
		//-------------
		public static const Changgong:int = 3401;	//弓兵
		public static const gongqi:int = 3402;	//弓骑兵
		public static const Qianggong:int = 3403;	//强弓兵
		
		//-----------------
		//玩家
		public static const MengjiangLong:int = 1701;	//猛将龙兵
		public static const JunshiLong:int = 2701;	//军师龙兵
		public static const GongjiangLong:int = 3701;	//弓将龙兵
		
		
		private	var m_gkContext:GkContext;
		private var m_dicSolderName:Dictionary;
		public function Soldier(gk:GkContext):void
		{
			m_gkContext = gk;
		}
		private function loadName():void
		{
			m_dicSolderName = new Dictionary();
			var data:TCommonBaseItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_COMMON, 1000) as TCommonBaseItem;
			if (data == null)
			{
				return;
			}
			var items:Array = data.m_value.split(";");
			var i:int;
			var ar:Array;
			for (i = 0; i < items.length; i++)
			{
				ar = (items[i] as String).split("-");
				if (ar.length == 2)
				{
					m_dicSolderName[ar[0]] = ar[1];
				}
			}
		}
		//输入:job
		//输出:对于技能
		public function toSoldierName(soldierID:int):String
		{
			var ret:String;
			if (m_dicSolderName == null)
			{
				loadName();
			}
			ret = m_dicSolderName[soldierID] as String;
			if (ret == null)
			{
				ret = soldierID.toString();
			}
			return ret;
		}
		
	}

}