package modulecommon.scene.beings 
{
	/**
	 * ...
	 * @author 
	 * 假玩家
	 */
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;
	
	import modulecommon.CommonEn;
	import modulecommon.headtop.TopBlockNpcPlayerFake;
	import modulecommon.net.msg.copyUserCmd.notifyTouXiangData;
	import modulecommon.net.msg.sceneUserCmd.stAttackUserCmd;
	
	import org.ffilmation.engine.core.fScene;
	import modulecommon.net.msg.copyUserCmd.notifyTouXiangData;
	
	public class NpcPlayerFake extends NpcVisitBase 
	{
		public var m_charID:int;
		public var m_zhanli:uint;
		protected var m_fakeType:uint;	// 指定是藏宝库还是军团城市争夺战
		protected var m_clkHandle:Function;		// 点击回调，军团城市系统中使用
		protected var m_cmd:notifyTouXiangData;	// 记录服务器数据

		public function get clkHandle():Function
		{
			return m_clkHandle;
		}

		public function set clkHandle(value:Function):void
		{
			m_clkHandle = value;
		}
		
		public function NpcPlayerFake(defObj:XML, scene:fScene) 
		{
			m_type = EntityCValue.TNpcPlayerFake;
			super(defObj, scene);
			
			m_headTopBlockBase = new TopBlockNpcPlayerFake(gkcontext,this);
			m_fakeType = EntityCValue.FakeCBK;
		}
		
		public function get fakeType():uint
		{
			return m_fakeType;
		}

		public function set fakeType(value:uint):void
		{
			m_fakeType = value;
			if(m_fakeType == EntityCValue.FakeCCS)
			{
				//m_headTopBlockBase.dispose();
				//m_headTopBlockBase = null;
				if(m_headTopBlockBase)
				{
					m_headTopBlockBase.visible = false;
				}
			}
		}

		override public function execFunction():void
		{
			if(m_fakeType == EntityCValue.FakeCBK)
			{
				execFunctionCBK();
			}
			else if(m_fakeType == EntityCValue.FakeCCS)
			{
				m_clkHandle(this.tempid);
			}
		}
		
		public function execFunctionCBK():void
		{
			var str:String;
			str = "执行假玩家(NpcPlayerFake:" + m_charID.toString() +")功能函数";			
			gkcontext.m_uiChat.debugMsg(str);
			
			if (this.gkcontext.m_cangbaokuMgr.coldTime > 0)
			{
				if (this.gkcontext.m_cangbaokuMgr.m_uiCangbaoku)
				{
					this.gkcontext.m_cangbaokuMgr.m_uiCangbaoku.openJiasuDialog();
				}
				else
				{
					DebugBox.sendToDataBase("NpcPlayerFake::execFunctionCBK--m_uiCangbaoku==null");
				}
				return;
			}
			
			var hero:PlayerMain = this.gkcontext.m_playerManager.hero as PlayerMain;
			var cmd:stAttackUserCmd = new stAttackUserCmd();
			cmd.byAttTempID = hero.tempid;
			cmd.byDefTempID = this.tempid;
			cmd.attackType = CommonEn.ATTACKTYPE_U2FU;
			this.gkcontext.sendMsg(cmd);
		}
		
		public function execFunctionCCS():void
		{
			
		}
		
		override public function get canAttacked():Boolean
		{
			return true;
		}
		
		override public function updateNameDesc():void
		{
			m_headTopBlockBase.invalidate();
		}
		
		override public function onSetTagBounds2d():void
		{
			super.onSetTagBounds2d();
			
			if(m_fakeType == EntityCValue.FakeCCS)
			{
				if(m_headTopBlockBase)
				{
					m_headTopBlockBase.visible = false;
				}
			}
		}
		
		override public function onClick():void
		{
			if(m_fakeType == EntityCValue.FakeCBK)
			{
				super.onClick();
			}
			else if(m_fakeType == EntityCValue.FakeCCS)
			{
				m_clkHandle(this.tempid);
			}
		}
		
		public function showTouXiangBtn():void
		{
			if (m_headTopBlockBase)
			{
				(m_headTopBlockBase as TopBlockNpcPlayerFake).showTouXiangBtn();
			}
		}
		
		public function set cmd(msg:notifyTouXiangData):void
		{
			m_cmd = msg;
		}
		
		public function get cmd():notifyTouXiangData
		{
			return m_cmd;
		}
	}
}