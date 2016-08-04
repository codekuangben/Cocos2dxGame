package modulefight.ui.uiFightResult
{
	
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;	

	import modulecommon.ui.Form;
	
	import modulecommon.net.msg.fight.stAttackVictoryInfoUserCmd;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITurnCard;
	import modulefight.scene.fight.GameFightController;
	import modulecommon.scene.MapInfo;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIFightResult extends Form
	{
		private var m_winAni:WinAni;
		private var m_defeat:DefeatAni;
		private var m_timer:Timer;
		//protected var m_quitMode:uint = 0;		// 0 是战斗序列播放完成退出  1 是战斗序列没有播放完成退出
		private var m_gameFightController:GameFightController;
		public function UIFightResult(fightController:GameFightController)
		{
			m_timer = new Timer(1500);
			id = UIFormID.UIFightResult;
			m_gameFightController = fightController;
		}
		
		override public function onReady():void
		{
			super.onReady();
			// 者人格界面忽略所有的鼠标消息
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			setSize(0, 0);
			updateData();
			
		}
		
		override public function onDestroy():void
		{
			super.onDestroy();		
			m_gameFightController.m_fightDB.m_uiFightResult = null;
			// 去除定时器事件，如果这个时候定时器事件启动，然后外部主动退出，这个时候定时器还会继续出发事件
			if(m_timer)
			{
				m_timer.stop();
				m_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				m_timer = null;
			}
		}
		
		override public function updateData(param:Object=null):void
		{
			var victory:int = m_gameFightController.fightProcess.isSelfVictory();
			var rev:stAttackVictoryInfoUserCmd = m_gameFightController.fightProcess.m_stAttackVictoryInfoUserCmd;
			if (victory !=-1&&rev)
			{
				if(m_gkcontext.m_mapInfo.mapType() == MapInfo.MTZhanYi)	// 如果在战役挑战中
				{
					if(victory == 1)
					{
						m_gkcontext.m_beingProp.m_fightFail = true;
					}
				}
				
				if (victory == 0)
				{
					if (m_winAni == null)
					{
						m_winAni = new WinAni(m_gkcontext, this);
						this.addChild(m_winAni);
					}
					m_winAni.setData(rev.exp, rev.money);
				}
				else
				{
					if (m_defeat == null)
					{
						m_defeat = new DefeatAni(this);
						this.addChild(m_defeat);
					}
					m_defeat.begin();
				}
				
				if(victory == 0)
				{
					// 播放音效
					m_gkcontext.m_commonProc.playMsc(53);
				}
				else
				{
					// 播放音效
					m_gkcontext.m_commonProc.playMsc(54);					
				}
				//onTimer(null);
				rev = null;
			}
			else
			{
				exit();
			}
		}
		
		public function onAniEnd():void
		{
			//return;
			m_timer.reset();
			m_timer.repeatCount = 1;
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			m_timer.start();
			
		}
		protected function onTimer(e:TimerEvent):void
		{
			m_timer.stop();
			m_timer.removeEventListener(TimerEvent.TIMER, onTimer);

			var uiturncard:IUITurnCard;
			// 如果在竞技场,如果有翻拍
			if(m_gkcontext.m_mapInfo.m_bInArean)		// 如果在竞技场中
			{
				if(m_gkcontext.m_contentBuffer.getContent("uiCopyTurnCard_reward", false))
				{
					// 先显示战斗奖励
					uiturncard = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFTurnCard) as IUITurnCard;
					if(uiturncard)
					{
						uiturncard.parseCopyReward(m_gkcontext.m_contentBuffer.getContent("uiCopyTurnCard_reward", true) as ByteArray);
					}
					else
					{
						m_gkcontext.m_UIMgr.loadForm(UIFormID.UIFTurnCard);
					}
				}
				else
				{
					//this.m_gkcontext.m_fightControl.cbAniEnd();
					m_gameFightController.resetFight();
				}
			}
			else
			{
				//this.m_gkcontext.m_fightControl.cbAniEnd();
				m_gameFightController.resetFight();
			}
		}
		
		//public function set quitMode(value:uint):void
		//{
			//m_quitMode = value;
			
			// 如果设置成 1 ，说明战斗序列没有播放完成就退出
			//if(1 == m_quitMode)
			//{
			//	m_timer.stop();
			//	m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			//}
		//}
	}
}