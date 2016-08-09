package modulecommon.scene.sysbtn 
{
	import modulecommon.commonfuntion.SysNewFeatures;
	/**
	 * ...
	 * @author ...
	 */
	public class SysbtnMgr 
	{
		//显示顺序(左->右)：8、7、6、5、4、3、2、1、0
		public static const SYSBTN_Marekt:int = 0;		//商城
		public static const SYSBTN_DaZuo:int = 1;		//打坐
		public static const SYSBTN_JunTuan:int = 2;		//军团
		public static const SYSBTN_Mounts:int = 3;		//坐骑
		public static const SYSBTN_ZhenXing:int = 4;	//阵法
		public static const SYSBTN_DuanZao:int = 5;		//锻造系统
		public static const SYSBTN_ZhanXing:int = 6;	//占星
		public static const SYSBTN_TongqueTai:int = 7;	//铜雀台
		public static const SYSBTN_WuXiaye:int = 8;		//武将库
		public static const SYSBTN_BeiBao:int = 9;		//背包
		public static const SYSBTN_WuJiang:int = 10;	//人物
		public static const SYSBTN_Count:int = 11;
		
		public var m_bShowPackage:Boolean;				//是否显示包裹界面
		
		public function SysbtnMgr() 
		{
			m_bShowPackage = false;
		}
		
		public static function getBtnId(type:uint):int
		{
			var id:int = -1;
			
			switch (type)
			{
				case SysNewFeatures.NFT_GEMEMBED:		//装备镶嵌
				case SysNewFeatures.NFT_EQUIPXILIAN:	//装备洗炼
				case SysNewFeatures.NFT_EQUIPDECOMPOSE:	//装备分解
				case SysNewFeatures.NFT_EQUIPCOMPOSE:	//装备合成
				case SysNewFeatures.NFT_EQUIPADVANCE:	//进阶
				case SysNewFeatures.NFT_EQUIPLEVELUP:	//装备升级
				case SysNewFeatures.NFT_DAZAO:			//强化
					id = SYSBTN_DuanZao;
					break;
				case SysNewFeatures.NFT_ZHENFA: 
				case SysNewFeatures.NFT_JINNANG: 
				case SysNewFeatures.NFT_FHLIMIT4:
				case SysNewFeatures.NFT_FHLIMIT5:
					id = SYSBTN_ZhenXing;
					break;
				case SysNewFeatures.NFT_HEROREBIRTH:	//武将转身
				case SysNewFeatures.NFT_WUJIANGJIHUO:	//武将激活
				case SysNewFeatures.NFT_HEROTRAIN:		//武将培养
				case SysNewFeatures.NFT_USERACTRELAIONS://"我的三国关系"(主角关系)
					id = SYSBTN_WuJiang;
					break;
				case SysNewFeatures.NFT_DAZUO: 
					id = SYSBTN_DaZuo;
					break;
				case SysNewFeatures.NFT_HEROXIAYE:
					id = SYSBTN_WuXiaye;
					break;
				case SysNewFeatures.NFT_JUNTUAN:
					id = SYSBTN_JunTuan;
					break;
				case SysNewFeatures.NFT_ZHANXING:
					id = SYSBTN_ZhanXing;
					break;
				case SysNewFeatures.NFT_TONGQUETAI:
					id = SYSBTN_TongqueTai;
					break;
				case SysNewFeatures.NFT_MOUNT:
					id = SYSBTN_Mounts;
					break;
			}
			
			return id;
		}
		
		
	}

}