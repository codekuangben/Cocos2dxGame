package com.pblabs.engine.entity
{
	/**
	 * 常量定义 
	 */
	public class EntityCValue 
	{
		// KBEN: 人物状态--对应人物动作  
		// KBEN: 人物状态   
		public static const TStand:uint = 0;		// 站立-待机状态 
		public static const TSStand:String = "Stand";	// 站立-待机状态 
		
		public static const TRun:uint = 2;			// 跑状态 
		public static const TSRun:String = "Run"
		
		public static const TJump:uint = 3;			// 跳跃状态可以和其它状态共存，记录在 substate 中，没有记录在 state 中
		public static const TSJump:String = "Jump"
		
		public static const TAttack:uint = 7;			// 攻击状态 
		public static const TSAttack:String = "Attack";
		
		public static const THurt:uint = 8;				// 受伤状态 
		public static const TSHurt:String = "Hurt";
		
		public static const TDie:uint = 9;				// 死亡状态 
		public static const TSDie:String = "Die";
		
		public static const TCAttack:uint = 10;			// 反击状态 
		public static const TSCAttack:String = "CAttack";
		
		public static const TCHurt:uint = 11;				// 反击受伤状态 
		public static const TSCHurt:String = "CHurt";
		
		public static const TDaZuo:uint = 12;				// 打坐状态
		public static const TSDaZuo:String = "DaZuo";
		 
		public static const TRide:uint = 13;				// 骑马状态可以和其它状态共存，记录在 substate 中，没有记录在 state 中
		public static const TSRide:String = "Ride";
		
		public static const TDance:uint = 14;				// 骑马状态可以和其它状态共存，记录在 substate 中，没有记录在 state 中
		public static const TSDance:String = "Dance";
		
		// KBEN: 人物动作，配置表中的 state 字段 <displayModel state="0"> 要和这里一一对应   
		public static const TActStand:uint = 0;		// 站立动作  		 		
		public static const TActRun:uint = 2;		// 跑动作 		
		public static const TActJump:uint = 3;		// 跳跃动作    
		public static const TActAttack:uint = 7;	// 普通攻击动作  
		
		public static const TActHurt:uint = 8;		// 受伤动作  
		public static const TActDie:uint = 9;		// 死亡动作  
		public static const TActSkill:uint = 7;		// 技能攻击动作，暂时使用普通攻击
		
		public static const TActSkillPre:uint = 7;	// 技能攻击前准备动作，暂时使用普通攻击        
		public static const TActDaZuo:uint = 12;	// 打坐动作
		public static const TActRideStand:uint = 13;// 骑马站立动作
		public static const TActRideRun:uint = 14;	// 骑马跑动作
		// 技能动作从 20 开始   
		public static const TActSkillOne:uint = 20;
		
		// 种类，内部使用类型进行区分
		public static const TThing:uint = 0;			// 地物
		public static const TVistNpc:uint = 1;		// 访问型NPC
		public static const TBattleNpc:uint = 2;		// 战斗行NPC
		public static const TPlayerMain:uint = 3;		// 主角玩家
		public static const TPlayer:uint = 4;			// 其它玩家
		public static const TPlayerArena:uint = 5;		// 竞技场中显示玩家
		public static const TEfffect:uint = 6;		// 特效，场景中特效，需要排序
		public static const TFallObject:uint = 7;		// 掉落物
		public static const TEmptySprite:uint = 8;	// 空精灵
		public static const TNpcPlayerFake:uint = 9;			// 假玩家 NpcPlayerFake
		public static const TRideHorse:uint = 9;			// 玩家骑乘物
		
		public static const TUIObject:uint = 20;		// 在UI上显示的模型
		
		// 特效类型
		public static const EFFTerrain:uint = 0; 		// 地上物特效
		public static const EFFFly:uint = 1; 			// 飞行特效，攻击特效，这中年特效重复播放，不断移动 
		public static const EFFLink:uint = 2; 		// 关联特效，人物身上的特效
		public static const EFFSceneTop:uint = 3;		// 特效放在场景顶层，玩家上面，不需要排序，不需要裁剪
		public static const EFFSceneBtm:uint = 4;		// 特效放在场景底层，地形上面，不需要排序，不需要裁剪
		public static const EFFJinNang:uint = 5;		// 锦囊持续特效，这个是锦囊特效释放完成后，残留在战斗场景中的特效
		
		// 场景状态 
		public static const SSIniting:uint = 0;		// 创景正在初始化 
		public static const SSRead:uint = 1;			// 创景初始化完毕  
		
		// 特效名字 
		// "eff1"
		public static const EFFExplosion:String = "e3_e3";	// 攻击特效
		// "eff0"
		public static const EFFLighting:String = "e3_e2";	// 命中特效
		public static const EFFShiQi:String = "e4_e402";		// 士气特效
		
		// 0 <!-- 0 度对应的是动作索引是 0，右边映射到左边 -->
		// 1 <!-- 0 度对应的是动作索引是 1 ，左边映射到右边 -->
		// 2 <!-- 0 度对应的是动作索引是 1 ，右边映射到左边 -->
		// 3 <!-- 0 度对应的是动作索引是 1 ，左边映射到右边,这个重复了，不用这个了 -->
		// 4 <!-- 0 度对应的是动作索引是 0 ，右边映射到左边,这个重复了，不用这个了 -->
		// 5 <!-- 0 度对应的是动作索引是 0 ，左边映射到右边 -->
		// 玩家 definition 字符串   
		// seqpic2-0-202	seqpic3-1-203 	seqpic4-2-204	seqpic5-3-205	seqpic6-4-206
		//public static const CHARDEF:String = "seqpic5";
		//public static const CHARDEF:String = "1";
		//public static const CHARDEF1:String = "seqpic5";
		public static const CHARDEF1:String = "c2_c1";
		//public static const CHARDEF2:String = "seqpic2";
		//public static const CHARDEF2:String = "seqpic6";
		//public static const CHARDEF2:String = "4";
		public static const CHARDEF2:String = "c2_c111";
		//public static const CHARDEF2:String = "c2-c121";
		// 实例定义   
		//public static const INSDEF:String = "205";	
		//public static const INSDEF1:String = "205";	
		//public static const INSDEF2:String = "1";	
		
		// 阻挡点类型    
		public static const STTLand:uint = 0;	// 陆地阻挡点   
		
		// 队伍标志 
		public static const RKLeft:uint = 0;	// 左边队伍 
		public static const RKRight:uint = 1;	// 右边队伍 
		// 队伍移动方向 
		public static const RKDIRLeft:uint = 0;		// 向左边走 
		public static const RKDIRRight:uint = 1;		// 向右边走 
		public static const RKDIRLeftTop:uint = 2;	// 向左上边走 
		public static const RKDIRLeftBottom:uint = 3;	// 向左下边走 
		public static const RKDIRRightTop:uint = 4;	// 向右上边走 
		public static const RKDIRRightBottom:uint = 5;// 向右下边走 
		
		// 队伍攻击动作 
		public static const RKACTAttack:uint = 0;		// 队伍攻击动作
		public static const RKACTHurt:uint = 1;		// 队伍受伤动作
		public static const RKACTMove:uint = 2;		// 队伍移动动作
		public static const RKACTAttHurtEnd:uint = 3;	// 队伍攻击和受伤结束
		public static const RKACTCAtt:uint = 4;		// 队伍反击动作
		public static const RKACTBufEff:uint = 5;		// buf 特效
		public static const RKACTHurtEnd:uint = 6;	// 受伤动作结束
		public static const RKACTJNEnd:uint = 7;		// 锦囊动作结束
		public static const RKACTAttEnd:uint = 8;		// 队伍攻击动作结束
		public static const RKACTSelfTeamEffect:uint = 9;		// 队伍攻击动作结束
		
		// 队伍移动状态    
		public static const RKMovePrep:uint = 4;		// 队伍等待进入移动状态
		public static const RKMoveNo:uint = 0;		// 队伍原地
		public static const RKMoveing:uint = 1;		// 队伍移动中
		public static const RKMoveEnd:uint = 2;		// 队伍移动结束
		
		// 队伍受伤状态   
		public static const RKHurtNo:uint = 0;		// 队伍原状态
		public static const RKHurting:uint = 2;		// 队伍受伤中
		public static const RKHurtEnd:uint = 3;		// 队伍受伤结束
		
		// 队伍攻击动作  
		public static const RKAttckPrep:uint = 4;	// 队伍准备进入攻击状态 
		public static const RKAttckNo:uint = 0;	// 队伍原状态 
		public static const RKAttacking:uint = 1;	// 队伍攻击中
		public static const RKAttackEnd:uint = 2;	// 队伍攻击结束    
		
		// 队伍队形类型
		public static const RKTriOrder:uint = 0;		// 三角队伍 
		public static const RKQuadOrder:uint = 1;		// 四边队伍
		public static const RKHexaOrder:uint = 2;		// 六边队伍      
		public static const RKInplaceOrder:uint = 3;	// 原地队伍  
		public static const RKOneOrder:uint = 4;		// 一角队伍 
		
		public static const RKPentOrder:uint = 4;		// 五边队伍
		
		// 表的定义  
		public static const TBLNpc:uint = 0;		// Npc 表    
		public static const TBLNpcBase:uint = 1;	// npc 基本属性表  
		
		// 路径
		public static const RESPMODULE:uint = 0;	// UI 资源    
		public static const RESPXML:uint = 1;		// xml 资源  
		public static const RESTBL:uint = 2;		// tbl 资源
		public static const RESHDIGIT:uint = 3;	// 掉血数字 资源
		
		// 资源类型 
		public static const RESTXML:uint = 0;	// XML 资源  
		public static const RESTBIN:uint = 1;	// XML 二进制  
		
		// 绘制方法    
		public static const MTNoReg:uint = 0;	// 不规则图元  
		public static const MTReg:uint = 1;	// 规则图元
		public static const MTCircle:uint = 2;	// 绘制圆形
		
		// 图片翻转方式 
		public static const FLPOrig:uint = 0;		// 不翻转   
		public static const FLPX:uint = 1;		// X 翻转   
		public static const FLPY:uint = 2;		// Y 翻转   
		
		// 掉血数字常量   
		public static const HDHurtDigit:uint = 0; 	// 这个说明是掉血数字     
		public static const HDAddDigit:uint = 1; 		// 这个说明是回血数字    		
		
		// 场景类型 
		public static const SCGAME:uint = 0;		// 游戏场景  
		public static const SCFIGHT:uint = 1;		// 战斗场景   
		public static const SCUI:uint = 2;			// UI场景
		public static const SCCNT:uint = 3;			// 总共场景    
		
		// 路径常量     
		public static const PHBEINGTEX:uint = 0;		// 生物纹理 
		public static const PHTERTEX:uint = 1;		// 地形纹理 
		public static const PHEFFTEX:uint = 2;		// 特效纹理 
		public static const PHFOBJTEX:uint = 3;		// 掉落物纹理 
		//public static const PHSCENE:uint = 3;		// 场景配置文件 
		//public static const PHDEFINE:uint = 4;	// 生物场景定义文件  
		public static const PHXMLCINS:uint = 5;	// 场景人物实例
		public static const PHXMLCTPL:uint = 6;	// 场景人物模板
		
		public static const PHXMLEINS:uint = 7;	// 场景特效实例
		public static const PHXMLETPL:uint = 8;	// 场景特效模板
		
		public static const PHXMLTINS:uint = 9;	// 场景地形实例
		public static const PHXMLTTPL:uint = 10;	// 场景地形模板
		
		public static const PHXMLFOBJINS:uint = 11;	// 掉落物实例 
		public static const PHXMLFOBJTPL:uint = 12;	// 掉落物模板 
		
		public static const PHBUFFICON:uint = 13;	// buff 图片资源目录   
		public static const PHSTOPPT:uint = 14;	// 阻挡点信息
		public static const PHTTB:uint = 15;	// 地形缩略图
		
		// 根据类型加载对应的路径下的资源  
		public static const PHBEING:uint = 0;		// being 种类  
		public static const PHTER:uint = 1;		// terrain 种类  
		public static const PHEFF:uint = 2;		// effect 种类  
		public static const PHFOBJ:uint = 3; 		// 掉落物种类  
		
		// 技能攻击两个状态 
		public static const SSPRE:uint = 0;			// 技能准备状态    
		public static const SSATT:uint = 1;			// 技能攻击状态  
		
		// 检测受伤动作是按照帧数还是按照时间延迟   
		public static const DTFrame:uint = 0;	// 帧数延迟  
		public static const DTTime:uint = 1;	// 时间延迟 
		public static const DTCallBack:uint = 2;	// 函数回调 
		
		// 近攻远攻 
		public static const ATTFar:uint = 0;	// 远程 
		public static const ATTNear:uint = 1;	// 近程 , 1 说明间隔一个格子，如果是 2 就说明是间隔两个格子
		
		// 格子状态 
		public static const GSNormal:uint = 0;	// 在格子原地状态 
		//public static const GSOuting:uint = 1;	// 在向外运动中状态 
		public static const GSOuted:uint = 2;	// 在外部状态 
		//public static const GSIning:uint = 3;	// 在回到状态中 
		
		// 空精灵位置
		public static const EMPTTop:uint = 1;		// 顶端空精灵
		public static const EMPTBot:uint = 2;		// 低端空精灵
		
		// 受伤的两个过程
		public static const STNone:uint = uint.MAX_VALUE;		// 子状态默认状态
		public static const HTBack:uint = 0;		// 受伤向后
		public static const HTForth:uint = 1;		// 受伤向前
		
		// 攻击状态分两个过程，攻击的时候可能要后退，然后恢复正常状态
		public static const ATTBack:uint = 0;		// 攻击后退
		public static const ATTForth:uint = 1;	// 攻击前进
		
		// 特效方向
		public static const EDL2R:uint = 0;		// 从左到右
		public static const EDR2L:uint = 1;		// 从右到左
		
		// 战斗特效绑定类型
		public static const EBGrid:uint = 0;		// 特效绑定在格子上
		public static const EBPlayer:uint = 1;	// 特效绑定在每一个人身上
		
		public static const ATSingleAtt:uint = 0;	// 单攻
		public static const ATFanJi:uint = 2;	// 反击攻击
		
		public static const HTCom:uint = 0;		// 普通受伤
		public static const HTFanJi:uint = 2;		// 反击受伤
		public static const HTSkill:uint = 3;		// 技能导致的受伤
		
		public static const TIPWIDTH:uint = 266;	//Tip界面宽度
		
		// 场景类型
		public static  const SCComon:uint = 0;	// 普通场景
		public static  const SCFight:uint = 1;	// 战斗场景
		
		// 摄像机类型
		public static const CMRandom:uint = 0;	// 随机震动
		public static const CMUBtm:uint = 1;	// 上下震动
		
		// 暴击种类
		public static const BJer:uint = 0;	// 自己发动暴击
		public static const BJee:uint = 1;	// 自己被暴击
		public static const BJNone:uint = 2;	// 没有暴击
		
		// 雾类型
		public static const CenterMain:String = "0";	// 以玩家为中心
		public static const CenterAny:String = "1";	// 以地形上的任意中心为区域
		
		// 过滤器参数
		public static const distance:uint = 0;
		public static const angle:uint = 1;
		public static const colorsa:uint = 2;
		public static const colorsb:uint = 3;
		public static const alphasa:uint = 4;
		public static const alphasb:uint = 5;
		public static const ratiosa:uint = 6;
		public static const ratiosb:uint = 7;
		public static const blurX:uint = 8;
		public static const blurY:uint = 9;
		public static const strength:uint = 10;
		public static const quality:uint = 11;
		public static const type:uint = 12;
		
		// 特效类型
		public static const EffAtt:uint = 0;		// 攻击特效，判断特效镜像使用
		public static const EffHurt:uint = 1;		// 受伤特效，判断特效镜像使用
		
		public static const FIGHTSCENE_SHOW_HEIGHT:uint = 1020;	//战斗场景的显示高度
		public static const FIGHTSCENE_PIC_HEIGHT:uint = 1080;		//战斗场景的地图高度	
		
		//
		public static const NPCID_SKIPInCity:uint = 50;		//主城跳转点npcID
		public static const NPCID_SKIP:uint = 1054;		//主城跳转点npcID
		
		// 场景层
		public static const SLTerrain:uint = 0;					// 0 地形层，不参与排序的
		public static const SLJinNang:uint = 1;		// 1 锦囊特效层，不再场景中，不参与排序，这个是锦囊释放完成后，会在场景中留下一个痕迹，直到战斗结束
		public static const SLSceneUIBtm:uint = 2;	// 2 场景 UI 底层，在地形上，不排序，不裁剪，场景不管，但是这一层是动态变化的特效，特效经常会产生和消失
		public static const SLBlur:uint = 3;		// 3 运行拖尾，战斗场景中用
		public static const SLShadow:uint = 4;			// 4 阴影层，场景中所有的不接收阴影，除了地形
		public static const SLShadow1:uint = 4;					// 5 测试裁剪的时候添加的，测试的时候需要添加上
		public static const SLBuild:uint= 5;			// 5 地物,这个不用排序了
		public static const SLObject:uint = 6;			// 6 掉落物，NPC，怪物，人物，需要排序的  
		public static const SLEffect:uint = 7;			// 7 特效
		public static const SLSceneUITop:uint = 8;		// 8 场景 UI 顶层，在人物上，不排序，不裁剪，场景不管
		public static const SLFog:uint = 9;		// 9 场景中雾效果的层    
		public static const SLCnt:uint = 10;				// 10总共层的数量
		
		// 定时器事件
		public static const TMFrame:uint = 0;		// 通过 onFrame 事件进入
		public static const TMTimer:uint = 1;		// 通过 onTimer 事件进入
		
		// 玩家
		public static const BSLoginSceneFlyEff:uint = 0;	// 登陆场景飞行过程中
		public static const BSCount:uint = 1;	// 总共的数量
		
		//	邻接两个攻击之间的关系
		public static const NRAN2AF:uint = 0;		// 攻击方近攻,攻击方远攻
		public static const NRAN2AN:uint = 1;		// 攻击方近攻,攻击方近攻
		public static const NRAF2AN:uint = 2;		// 攻击方远攻,攻击方近攻
		public static const NRAF2AF:uint = 3;		// 攻击方远攻,攻击方远攻
		
		public static const NRA2DNo:uint = 4;		// 攻击方被击方没有任何关系
		public static const NRATarget2D:uint = 5;	// 攻击方是下一次的被击方
		public static const NRA2DAtt:uint = 6;	// 被击方是下一次的攻击方
		public static const NRArmyReplace:uint = 7;	// 下一场战斗需要动态替换部队,这个优先级比较高
		
		public static const NRCAtt:uint = 8;		// 如果本次共计有反击,就不判断和下一次的攻击,直接反击完成出发,优先级比较高
		public static const NRNextRount:uint = 9;	// 如果下一场战斗是下一个回合的,就需要等待上一回合战斗完全结束,优先级比较高
		public static const NRHNULL:uint = 10;		// 被击列表为空
		
		// 攻击的过程中出发的事件
		public static const ASHurting:uint = 0;	// 跑过去并造成伤害,开始播放受伤动作
		public static const ASOuting:uint = 1;	// 向外跑动某一帧
		public static const ASAttacking:uint = 2;	// 攻击即将开始
		public static const ASAttacked:uint = 3;	// 攻击完成
		
		public static const ASIned:uint = 4;		// 跑回来
		public static const ASHurted:uint = 5;	// 被击动作播放完成
		public static const ASJNEnd:uint = 6;		// 锦囊结束
		public static const ASDefault:uint = 7;	// 默认，受伤结束，受伤动作刚开始播放，这个主要是一个一个序列使用
		
		public static const ASCAttacked:uint = 8;	// 反击事件结束,主要是反击完成触发这个事件
		public static const ASAllActEnd:uint= 9;	// 所有的动作都结束,主要是在换部队或者下一个回合的时候触发这个事件
		public static const ASBattleArrayEnd:uint= 10;		// 一次battleArray处理结束
		
		// 战斗中特效以及玩家移动速度
		//public static const VelMove:uint = 2000;	// 万家移动速度
		//public static const VelEff:uint = 2000;	// 特效移动速度
		
		// 战斗模式
		public static const FMSeq:uint = 0;	// 顺序播放
		public static const FMPar:uint = 1;	// 并行播放,受伤不保证按照顺序,攻击保证按照顺序
		
		//  混音器
		public static const FXDft:String = "sfx";
		
		// 默认音乐名字
		public static const DSMusic:String = "main.mp3";		// 默认场景音乐名字
		public static const DFMusic:String = "fight.mp3";	// 默认战斗音乐名字
		public static const DNMusic:String = "fuben.mp3";	// 默认副本音乐名字
		
		//消息缓冲标识位
		public static const BufferMsg_forGame:uint = 0;	//等待Game模块下载
		public static const BufferMsg_forMap:uint = 1;	//等待地图资源下载
		//public static const BufferMsg_forFight:uint = 2;	//等待地图资源下载
		//public static const BufferMsg_forFight:uint = 3;	//在收到与进入战斗相关的最后一个消息时，设置此位。当玩家看到战斗场景时，清除此位。
		
		// 加载进度条读取的阶段
		public static const PgNo:uint = 0;				// 游戏初始阶段
		public static const PgHeroSel:uint = 1;			// 角色选择加载阶段
		public static const Pg1001FES:uint = 2;			// 1001 场景资源加载
		public static const PgFES_LoadingRes:uint = 3;				// 在第一次进入场景之前，加载一些资源
		public static const PgFES:uint = 4;				// 第一次进入场景
		public static const PgNFES:uint = 5;			// 非第一次进入场景
		
		
		public static const PreloadRES_GAME:uint = 0;
		public static const PreloadRES_TABLE:uint = 1;
		public static const PreloadRES_COMMONIMAGES:uint = 2;	//commonimage.swf		
		public static const PreloadRES_DataXML:uint = 3;	//xml.swf
		public static const PreloadRES_ReplaceResSys:uint = 4;	//ReplaceResSys
		public static const PreloadRES_MAX:uint = 5;
		
		
		// onticket 优先级,数越大越先被调用
		public static const PriorityInput:Number = 900;		// 输入
		public static const PriorityMsg:Number = 800;		// 消息
		public static const PriorityScenePlayer:Number = 790;		// 场景中的玩家
		public static const PrioritySceneNpc:Number = 780;		// 场景中 NPC
		public static const PrioritySceneObj:Number = 770;		// 场景中 Obj
		public static const PrioritySceneFake:Number = 760;		// 场景中 Fake
		public static const PrioritySceneEffect:Number = 750;		// 场景中 Effect
		public static const PrioritySceneTerrain:Number = 740;		// 场景中 Terrain
		public static const PrioritySceneAfter:Number = 730;			// 场景之后更新
		public static const PriorityFight:Number = 720;			// 战斗更新
		public static const PrioritySceneUI:Number = 700;	// 场景 UI 中的
		public static const PriorityUI:Number = 600;		// 界面
		public static const PriorityUIAfter:Number = 590;		// UI 之后更新
		public static const PrioritySound:Number = 500;		// 声音
		
		// onResize 预先级
		public static const ResizeScene:Number = 900;		// 场景
		public static const ResizeSceneAfter:Number = 890;		// 场景之后的更新
		public static const ResizeUI:Number = 800;		// UI
		public static const ResizeFight:Number = 700;		// fight
		public static const ResizeUIAfter:Number = 600;		// UI 更新后的序号
		
		// 模拟玩家的类型
		public static const FakeCBK:uint = 0;		// 藏宝库中的假人
		public static const FakeCCS:uint = 1;		// 军团城市中的假人
		
		public static const UpdateCurrentFrameMode_Increase:int = 0;	//帧的更新方式是增加
		public static const UpdateCurrentFrameMode_Decrease:int = 1;	//帧的更新方式是减少
		
		public static const DISCONNECT_UNKNOWN:uint = 0;				// 未知错误
		public static const DISCONNECT_TAKEOFF:uint = 1;	// 被管理员强制下线
		public static const DISCONNECT_HEART:uint = 2;				// 心跳包检测失败下线
		public static const DISCONNECT_REPEAT:uint = 3;		// 重复登录	
		public static const DISCONNECT_OUTTIME:uint = 4;		// 连接网关超时
		public static const DISCONNECT_MAPERROR:uint = 5;		// 场景地图错误
		public static const DISCONNECT_DBERROR:uint = 6;		// 数据库错误
		public static const DISCONNECT_INZHANCHANG:uint = 7;		// 已在战场中登陆
		public static const DISCONNECT_MAINTAIN:uint = 8;		// 服务器正在维护
		
		public static const DISCONNECT_CLIENT_DETECT:uint = 100;		// 客户端自身检测到掉线
		
		// 资源加载器数量
		//public static const RP_UI:uint = 0;				// ResourceProvider	UI 资源加载器
		//public static const RP_Scene:uint = 1;			// ResourceProvider	Scene 资源加载器
		//public static const RP_CNT:uint = 2;
		
		public static const WUJIANG:uint = 20151;				// 礼包中武将 id ，道具表中的 id 张辽
		public static const NPCBattleWUJIANG:uint = 151;		// 礼包中武将 id ，战斗 npc 表中的 id
		public static const WUJIANG1f:uint = 20150;				// 礼包中武将 id ，道具表中的 id 黄忠
		public static const NPCBattleWUJIANG1f:uint = 150;		// 礼包中武将 id ，战斗 npc 表中的 id
		public static const WUJIANG2f:uint = 20162;				// 礼包中武将 id ，道具表中的 id 关羽
		public static const NPCBattleWUJIANG2f:uint = 162;		// 礼包中武将 id ，战斗 npc 表中的 id
		
		public static const NetType:String = "nettype";				// 0: 是电信 1 是网通
		
		public static const DSSelf:uint = 0;						// 自己做起数据
		public static const DSOther:uint = 1;						// 别人坐骑数据
		public static const DSGmOther:uint = 2;						// gm坐骑数据
		
		public static const ISPTele:uint = 0;						// 电信
		public static const ISPCNC:uint = 1;						// 网通
		public static const ISPCnt:uint = 2;						// ISP 数量
		
		public static const MAX_BUSINESS_SHOP_NUM:uint = 5;
		
		// 没有特效状态
		public static const MWETNone:uint = 0;				// 没有特效状态
		
		// 特效1： 当玩家出阵武将4个都是紫将以上
		public static const MWETO:uint = 1;				// 主角武将特效类型
		public static const MWENO:String = "e3_e11";		// 主角武将特效名字

		// 特效2：当玩家出阵武将4个都是鬼紫将以上
		public static const MWETT:uint = 2;				// 主角武将特效类型
		public static const MWENT:String = "e3_e11";		// 主角武将特效名字

		// 特效3,：当玩家出阵武将4个都是仙紫将以上
		public static const MWETH:uint = 3;				// 主角武将特效类型
		public static const MWENH:String = "e3_e11";		// 主角武将特效名字

		// 特效4：当玩家出阵武将4个都是神紫将以上
		public static const MWETF:uint = 4;				// 主角武将特效类型
		public static const MWENF:String = "e3_e11";		// 主角武将特效名字
		
		
		public static const ModuleGame:uint = 0;	//游戏模块
		//public static const ModuleFight:uint = 2;	//战斗模块
		
		public static const ModuleCnt:uint = 1;	//最大模块数
	}
}