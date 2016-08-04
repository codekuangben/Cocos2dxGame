package modulefight.scene.fight
{
	//import adobe.utils.CustomActions;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.entity.TerrainEntity;
	import modulefight.effectmgr.EffectMgrForFight;
	import modulefight.ModuleFightRoot;
	import modulefight.netmsg.fight.stAttackResultUserCmd;
	import modulefight.skillani.JuqiSkillAni;
	import modulefight.tianfu.TianfuMgr;
	import modulefight.ui.battlehead.TipsMgr;
	import modulefight.ui.battlehead.TipsString;
	import modulefight.ui.uiFightResult.UIFightResult;
	import modulefight.ui.uireplay.UIReplay;
	//import modulefight.scene.battleContrl.BattleControlBase;
	import modulefight.scene.roundcontrol.RoundControl;
	
	//import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	//import modulecommon.scene.fight.IFightController;
	import modulecommon.tools.Earthquake;
	import modulecommon.ui.UIFormID;
	
	import modulefight.digitani.BBNameMgr;
	//import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.render.BitmapRenderer;
	import modulefight.scene.beings.NpcBattleMgr;
	import modulefight.scene.fight.rank.IRankFightAction;
	import modulefight.scene.preload.PreDB;
	import modulefight.skillani.SkillAni;
	import modulefight.ui.battlehead.UIBattleHead;
	import modulefight.ui.tip.UIBattleTip;
	
	import org.ffilmation.engine.core.fCamera;
	import org.ffilmation.engine.core.fScene;
	//import org.ffilmation.engine.datatypes.IntPoint;
	//import modulecommon.uiinterface.IUICloud;
	import modulecommon.ui.Form;
	import modulefight.ui.UIJNHalfImg;


	/**
	 * @brief 战斗用到的所有数据
	 * */
	public class FightDB implements IFightDB
	{
		public var m_gkcontext:GkContext;
		public var m_fightControl:GameFightController;
		public var m_ModuleFightRoot:ModuleFightRoot;
		
		public var m_effectMgr:EffectMgrForFight;
		public var m_centerXGrid:int; // 这个是战斗的中心点在地形中的偏移，单位是像素  
		public var m_centerYGrid:int; // 这个是战斗的中心点在地形中的偏移，单位是像素  
		
		public var m_offXGrid:uint; // 左边队伍右上角（或右边队伍左上角）与中心点（m_centerXGrid，m_centerYGrid）的距离
		public var m_offYGrid:uint; // 左边队伍右上角（或右边队伍左上角）与中心点（m_centerXGrid，m_centerYGrid）的距离  
		public var m_cameraYOff:uint; // 摄像机 Y 值偏移  
		
		public var m_gridWidth:uint; // 九宫格格子宽度 
		public var m_gridHeight:uint; // 九宫格格子高度
		
		public var m_gridWidthHalf:uint; // 九宫格格子宽度的一半
		public var m_gridHeightHalf:uint; // 九宫格格子高度的一半
		public var m_camera:fCamera;
			
		public var m_roundCtrol:RoundControl;
		public var m_nextRoundCtrolIndex:int;
		
		public var m_actionList:Vector.<IRankFightAction>; // 这个是动作列表，每一帧都会遍历      
		public var m_inFightScene:Boolean; // 是否在战斗场景中  	 
		
		public var m_moveDist:Number; // 移动的距离   
		public var m_fightGrids:Vector.<Vector.<FightGrid>>;
		public var m_fightGridsWithBudui:Vector.<Vector.<FightGrid>>;
		//protected var m_curFightList:Vector.<Vector.<uint>>; // 记录当前战斗队伍列表 
		
		
		public var m_fightProcess:stAttackResultUserCmd;		// 整个战斗流程 
		
		public var m_npcBattleMgr:NpcBattleMgr; // 战斗 npc 管理器  		
		public var m_topEmptySpriteYOff:int; // 顶层空精灵距离格子中心点的偏移
		public var m_botEmptySpriteYOff:int; // 顶层空精灵距离格子中心点的偏移 
		// 0:攻击准备 1:攻击 2:飞行 3:被击 
		public var m_effFrameRateList:Vector.<uint>; // 特效帧率，这个是默认的帧率，不用所有都判断
			
		
		public var m_curRoundIndex:int; //当前是第几回合。zero-based，例如：m_curRoundIndex == 0时，表示第一回合; -1表示还未开始第一回合。
		public var m_aArmyIndex:int;
		public var m_bArmyIndex:int;		

		// UI 区域
		public var m_UIBattleHead:UIBattleHead;
		public var m_UIBattleTip:UIBattleTip;
		public var m_UIReplay:UIReplay;
		public var m_uiFightResult:UIFightResult;
		public var m_UIJNHalfImg:UIJNHalfImg;

		public var m_bOver:uint; // 战斗结束	//0 - 战斗未结束；1-战斗结束状态；2-战斗结束状态，并弹出战斗结果对话框；3- 战斗结束状态，对话框弹出完毕
		public var m_overTime:Number; // 战斗结束 UI 
		
		public var m_bStart:uint;		// 不可能出现同时某一个事件触发这个设置 = 1,因为只有一次战斗播放的时候才会触发下一个 =1 的设置
		public var m_starTime:Number; // 每一回合之间间隔的时间
		public var m_bitmapRenderer:BitmapRenderer; // 这个是绘制拖尾
		
		public var m_quake:Earthquake; // 震动
		public var m_intensity:Number = 60; // GI 强度，最小值是 20
		public var m_bchGI:Boolean = false; // 是否改变 GI 
		public var m_fightscene:fScene; // 战斗场景
		public var m_skillAni:SkillAni;
		private var m_juqiSkillAni:JuqiSkillAni;
		public var m_bStopPlayer:Boolean;	// 停止播放战斗，停在当前界面动画
		
		public var m_preDB:PreDB;	// 提前加载的资源
		public var m_terEntity:TerrainEntity;		
		
		//public var m_trigGridSide:uint;		// 触发下一次攻击的格子方向
		//public var m_trigGridIdx:uint;		// 触发下一次攻击的格子的索引
		public var m_trigMode:uint;			// 就是 ASHurting 这些常量值		
		
		public var m_fightIdx:int = -1;	// 总的战斗次数,当前战斗索引可能要 m_fightIdx ,给每一场战斗一个唯一id
		public var m_fightMode:uint;		// 战斗模式,顺序播放还是上一次战斗没结束就出发下一次攻击
		public var m_fightInterval:Number = 0;	// 战斗间隔
		
	
		public var m_moveVel:uint = 2000;			// 玩家移动速度
		public var m_effVel:uint = 2000;			// 特效移动速度	
		public var m_bbNameMgr:BBNameMgr;
		public var m_tianfuMgr:TianfuMgr;
		public var m_tipsMgr:TipsMgr;
		
		public function FightDB(value:GkContext,fc:GameFightController)
		{
			m_gkcontext = value;
			m_fightControl = fc;
			m_effectMgr = new EffectMgrForFight(m_gkcontext);
			
			m_inFightScene = false;		
			m_moveDist = 500;
			
			m_gridWidth = 140;
			m_gridHeight = 140;
			
			m_gridWidthHalf = m_gridWidth / 2;
			m_gridHeightHalf = m_gridHeight / 2;
			
		
			m_cameraYOff = 100; // 摄像机 Y 偏移的绝对值     			
			m_npcBattleMgr = new NpcBattleMgr(m_gkcontext.m_context);
			
			
			m_topEmptySpriteYOff = 80;
			m_botEmptySpriteYOff = 80;
			m_effFrameRateList = new Vector.<uint>(4, true);
			this.m_gkcontext.m_context.m_npcBattleMgr = m_npcBattleMgr;			
			m_bOver = 0;
			m_overTime = 0;
			
			m_bStart = 0;
			m_starTime = 0;
			m_curRoundIndex = -1;
			m_preDB = new PreDB(m_gkcontext,this);
			m_fightMode = EntityCValue.FMPar;
			
			if(m_fightMode == EntityCValue.FMSeq)
			{
				m_fightInterval = 1.0;
			}
			else
			{
				m_fightInterval = 0.5;
			}

			m_bbNameMgr = new BBNameMgr(m_gkcontext.m_context);
			m_tianfuMgr = new TianfuMgr(this);

			// 显示云
			var uiCloud:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UIMCloud);
			if(uiCloud)		// 在主场景显示
			{
				uiCloud.exit()
			}
			
			m_fightGridsWithBudui = new Vector.<Vector.<FightGrid>>(2);
			m_fightGridsWithBudui[0] = new Vector.<FightGrid>;
			m_fightGridsWithBudui[1] = new Vector.<FightGrid>;
			
			m_tipsMgr = new TipsMgr(m_gkcontext);
			m_tipsMgr.loadConfig();
		}
		
		public function dispose():void
		{
			if (!m_inFightScene)
			{
				return;
			}
			if (m_skillAni)
			{
				m_skillAni.dispose();
				m_skillAni = null;
			}
			if (m_juqiSkillAni)
			{
				m_juqiSkillAni.dispose();
				m_juqiSkillAni = null;
			}
			// bug: 震动如果没有结束就结束震动，否则会宕机
			if(m_quake)
			{
				m_quake.dispose();
				m_quake = null;
			}
			
			// 动作队列 
			if(m_actionList)
			{
				var act:IRankFightAction;
				for each (act in m_actionList)
				{
					act.dispose();
				}
				m_actionList.length = 0;
				m_actionList = null;
			}
			
			m_roundCtrol.dispose();
			
			
			// 设置变量  
			m_inFightScene = false;	
			
			m_npcBattleMgr = null;
			m_gkcontext.m_context.m_npcBattleMgr = null;
			
			// 释放拖尾
			if(m_fightscene)
			{
				m_fightscene.sceneLayer(EntityCValue.SLBlur).removeChild(m_bitmapRenderer);
				m_fightscene = null;
				m_bitmapRenderer.dispose();
				m_bitmapRenderer = null;
			}		
			
			// 战斗结果消息清理
			//m_gkcontext.m_contentBuffer.delContent("uiFightResult_result");
			// 资源结束
			m_preDB.dispose();
			m_preDB = null;
			
			// 卸载云效果
			var uiCloud:Form = m_gkcontext.m_UIMgr.getForm(UIFormID.UICloud);
			if(uiCloud)		// 在主场景显示
			{
				uiCloud.exit()
			}
			
			// 卸载回放界面
			if(m_UIReplay)		// 在主场景显示
			{
				m_UIReplay.exit();
				m_UIReplay = null;
			}
			
			if (m_uiFightResult)
			{
				m_uiFightResult.exit();
				m_uiFightResult = null;
			}
			
			if(m_UIJNHalfImg)
			{
				m_UIJNHalfImg.exit();
				m_UIJNHalfImg = null;
			}			
		
			m_fightProcess = null;
			m_camera = null;
			//m_effFrameRateList.length = 0
			m_effFrameRateList = null;
			
			m_terEntity = null;				
			m_bbNameMgr = null;
			
			var idx:int = 0;
			if(m_fightGrids)
			{
				while(idx < m_fightGrids.length)
				{
					m_fightGrids[idx] = null;
					++idx;
				}

				m_fightGrids = null;
			}
			
			m_gkcontext = null;
		}
		
		public function get moveVel():uint
		{
			return m_moveVel;
		}
		
		public function get effVel():uint
		{
			return m_effVel;
		}
		
		public function get bbNameMgr():BBNameMgr
		{
			return m_bbNameMgr;
		}
		
		//十位数表示部队，个位数表示格子编号
		public function getFightGrid(pos:int):FightGrid
		{
			return m_fightGrids[Math.floor(pos / 10)][Math.floor(pos % 10)];
		}
		
		public function get juqiSkillAni():JuqiSkillAni
		{
			if (m_juqiSkillAni == null)
			{
				m_juqiSkillAni = new JuqiSkillAni(m_gkcontext.m_context);
			}
			return m_juqiSkillAni;
		}
	}
}