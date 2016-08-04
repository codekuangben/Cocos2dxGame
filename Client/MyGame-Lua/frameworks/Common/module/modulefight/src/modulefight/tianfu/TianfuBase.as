package modulefight.tianfu 
{
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import modulecommon.scene.prop.table.TTianfuXiaoguoItem;
	import modulefight.FightEn;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.PkValue;
	import modulefight.netmsg.stmsg.stTianFuData;
	import modulefight.netmsg.stmsg.stTianFuEffect;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	import modulefight.skillani.tianfuani.TianfuAni;
	/**
	 * ...
	 * @author 
	 */
	public class TianfuBase 
	{
		
		//天赋使用方式类型
		public static const TYPE_None:int = 0;	//有些天赋的类型是TYPE_None，表示触发时，不需要TianfuMgr来维护
		public static const TYPE_BuDuDie:int = 1;	//部队死亡触发类型
		public static const TYPE_RoundBegin:int = 2;	//回合开始
		public static const TYPE_AttackBegin:int = 3;	//攻击开始
		public static const TYPE_AttackEnd:int = 4;	//攻击结束
		public static const TYPE_RestoreHP:int = 5;		//回血
		public static const TYPE_ServerTrigger:int = 6;		//由服务器的数据触发
		public static const TYPE_Attacked:int = 7;		//被攻击
		
		protected var m_mgr:TianfuMgr;
		protected var m_fightDB:FightDB;
		protected var m_fightGrid:FightGrid;	//该天赋对象所属格子对象
		protected var m_baseTianfuID:uint;
		protected var m_tianfuID:uint;
		protected var m_type:int;	//见TYPE_Chufa定义	
		
		protected var m_tianfuSkillBaseItem:TSkillBaseItem;
		private var m_tianfuXiaoguoItem:TTianfuXiaoguoItem;
		
		protected var m_tianfuAni:TianfuAni;
		public function TianfuBase()
		{
			
		}
		public function setInitData(mgr:TianfuMgr, fightDB:FightDB, fightGrid:FightGrid, skillBaseItem:TSkillBaseItem, baseTianfuID:uint, tianfuID:uint):void
		{
			m_mgr = mgr;
			m_fightDB = fightDB;
			m_fightGrid = fightGrid;
			m_tianfuSkillBaseItem = skillBaseItem;
			m_baseTianfuID = baseTianfuID;
			m_tianfuID = tianfuID;
		}
		
		public function init():void
		{
			
		}
		
		protected function createAni():void
		{
			m_tianfuAni = new TianfuAni(m_fightDB.m_gkcontext.m_context, m_fightGrid.side, m_tianfuSkillBaseItem.m_fazhaoPic+".png");
		}
		
		public function dispose():void
		{
			m_fightGrid.tianfu = null;
			m_fightGrid = null;
			if (m_tianfuAni)
			{
				m_tianfuAni.dispose();
			}
		}
		public function playAni():void
		{
			if (m_tianfuAni == null)
			{
				createAni();
			}
			if (m_tianfuAni.isStop == false)
			{
				return;
			}
			m_fightGrid.addToTopEmptySprite(m_tianfuAni);
			var x:Number;
			if (m_fightGrid.side == 0)
			{
				x = -90;
			}
			else
			{
				x = 90;
			}
			
			m_tianfuAni.setPos(x,-160);
			m_tianfuAni.begin();
		}
		
		
		public function isTriger(param:Object = null):Boolean
		{
			return false;
		}
		
		public function exec(param:Object = null):void
		{
			if (param is stTianFuData)
			{
				processTianfuData(param as stTianFuData);
			}
			m_mgr.setTriggerTianfu();
			playAni();
		}
		
		public function get type():int
		{
			return m_type;
		}
		
		public function get baseTianfuID():int
		{
			return m_baseTianfuID;
		}
		
		public function get tianfuXiaoguo():int
		{
			if (m_tianfuXiaoguoItem == null)
			{
				m_tianfuXiaoguoItem = m_fightDB.m_gkcontext.m_dataTable.getItem(DataTable.TABLE_Tianfu_Xiaoguo, m_tianfuID) as TTianfuXiaoguoItem;
			}
			if (m_tianfuXiaoguoItem == null)
			{				
				return 0;
			}
			return m_tianfuXiaoguoItem.m_xiaoguo;
		}
		
		public function get pos():int
		{
			return m_fightGrid.pos;
		}
		
		protected function processTianfuData(tianfuData:stTianFuData):void
		{
			if (tianfuData == null)
			{
				return;
			}
			
			var tianfuEffect:stTianFuEffect;
			var grid:FightGrid;
			for each(tianfuEffect in tianfuData.m_effPart.m_list)
			{
				grid = m_fightDB.getFightGrid(tianfuEffect.pos);
				grid.setHP(tianfuEffect.curhp);
				grid.setShiqi(tianfuEffect.curshiqi);
				var pk:PkValue;
				for each(pk in tianfuEffect.m_pkValuePart.m_list)
				{
					if (pk.type == FightEn.DAMTYPE_VEADDSHIQI)
					{
						grid.emitNamePicForShiqi(true);
					}
					else if (pk.type == FightEn.DAMTYPE_VEREDUCESHIQI)
					{
						grid.emitNamePicForShiqi(false);
					}
					else
					{
						grid.updateHp(pk.type, pk.value, FightEn.DAM_None);
					}
				}
			}
		}
	}

}