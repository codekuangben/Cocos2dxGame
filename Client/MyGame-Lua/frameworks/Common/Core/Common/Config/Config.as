package common.config
{
	//import com.gskinner.motion.easing.Back;

	/**
	 * @brief 基本的配置信息     
	 */
	public class Config
	{
		// m_versiontype 定义
		public static const RELEASE:uint = 0;		// 正常版本
		public static const DEBUG:uint = 1;		// 调试版本
		
		public var m_ip:String = "";
		public var m_port:int = 0;
		public var m_ip2:String = "";	//登陆
		public var m_port2:int = 0;
		
		public var m_bManual:Boolean = false;	// 是否是手工输入 IP ，如果是手工输入 IP ，全部用这个 IP 
		
		public var m_single:Boolean = false;	// 是否是单机，不连接服务器   
		
		// 这个定义要和 Start.as 中的大小一致   
		public var m_stageWidth:uint = 800;	// 当前舞台的宽度  
		public var m_stageHeight:uint = 600;// 当前舞台的宽度  
		
		public var m_curWidth:uint = 800;	// 当前窗口宽度    
		public var m_curHeight:uint = 600;	// 当前窗口高度   
		
		public var m_showWidth:uint = 800;	// 当前显示窗口宽度（即，游戏窗口大小）
		public var m_showHeight:uint = 600;	// 当前显示窗口高度   （即，游戏窗口大小）
		
		public var m_maxWidth:uint = 800;	// 最大窗口宽度 
		public var m_maxHidth:uint = 600;	// 最大窗口宽度 
		
		public var m_minWidth:uint = 800;	// 最小窗口宽度    
		public var m_minHeight:uint = 600;  // 最小窗口高度   
		
		public var m_viewOff:uint = 0;	// view 默认偏移
		public var m_bLimitMaximum:Boolean = false;		// 显示窗口最大宽度和高度，战斗场景中限制，普通场景中不限制
		public var m_bLimitMinimum:Boolean = true;		// 显示窗口最下宽度和高度，战斗场景和普通场景中都限制
		
		// 是否是从浏览器启动  
		public var m_browser:Boolean = true;	 
		// KBEN: 是否是全屏状态，暂时不用，浏览器 F11 自动切换 
		public var m_fullScreen:Boolean = false;
		// 是否调试模式   
		public var m_bDebug:Boolean = true;
		// 版本 
		public var m_version:String = "201212081508";
		// 版本类型
		public var m_versiontype:uint = 0;
		
		public var m_versionForOutNet:Boolean = false;	//用于区分内外网
		
		// 各种路径定义    
		public var m_rootPath:String;		// 整个资源的根目录   
		public var m_beingTexPath:String;	// 生物贴图路径    
		public var m_terTexPath:String;		// 地形贴图路径    
		public var m_effTexPath:String;		// 特效贴图位置  
		public var m_fobjTexPath:String;	// 掉落物贴图位置  
		//public var m_scenePath:String;		// 场景配置文件目录  
		//public var m_sceneDefPath:String;	// 场景定义文件目录   
		public var m_xmlcins:String;		// 人物实例目录
		public var m_xmlctpl:String;		// 人物模板目录
		public var m_xmleins:String;		// 特效实例目录
		public var m_xmletpl:String;		// 特效模板目录
		public var m_xmltins:String;		// 地形实例目录
		public var m_xmlttpl:String;		// 地形模板目录
		
		public var m_bufficon:String;		// buff 图片资源目录 
		public var m_stoppt:String;		// 阻挡点路径
		public var m_ttb:String;		// 地形缩略图资源
		
		public var m_bShowShiQiHp:Boolean = true;		// 是否在透顶显示士气血量
		public var m_bShowFightGrid:Boolean = false;	// 战斗格子
		public var m_webIP:String = '124.238.233.51';						// 向 web 服务器存储消息
	}
}