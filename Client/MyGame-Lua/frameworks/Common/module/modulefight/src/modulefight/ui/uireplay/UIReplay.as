package modulefight.ui.uireplay
{
	import com.bit101.components.ButtonImageText;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import modulefight.scene.fight.GameFightController;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUITurnCard;
	import modulecommon.scene.wu.WuMainProperty;
	import modulecommon.scene.MapInfo;
	
	/**
	 * @brief 回放
	 * */
	public class UIReplay extends Form
	{
		public static const MODE_jieshu:int = 0; //立刻结束
		public static const MODE_huifang:int = 1;	//回放
		
		private var m_btnReplay:PushButton; // 立即退出和回放，使用同一个按钮
		protected var m_btnMode:uint = 0; // 0 立即退出 1 回放
		protected var m_lblDesc:Label; // 描述
		
		//protected var m_pnl:Panel;
		//protected var m_bgSprite:Sprite;
		//protected var m_bgShape:Shape;
		protected var m_quit:Boolean = false; // 玩家是否已经选择退出
		private var m_gameFightController:GameFightController;
		private var m_quitTimer:Timer;	//战斗结束后，5秒退出
		public function UIReplay(fightController:GameFightController)
		{
			this.id = UIFormID.UIReplay;
			m_gameFightController = fightController;
		}
		
		override public function onShow():void
		{
			// 显示不居中，因此不需要调用父类函数
			// 调整按钮位置
			onStageReSize();
		}
		override public function onHide():void 
		{
			super.onHide();
			removeQuitTimer();
		}
		override public function onReady():void
		{
			// 战斗进行1回合后,再显示回访按钮			
			//m_bgSprite = new Sprite();
			//this.addChild(m_bgSprite);
			
			//m_bgShape = new Shape();
			//m_bgShape.graphics.clear();
			//m_bgShape.graphics.beginFill(0xFF0000, 0);
			//m_bgShape.graphics.drawRect(0, 0, this.m_gkcontext.m_context.m_config.m_curWidth, this.m_gkcontext.m_context.m_config.m_curHeight);
			//m_bgShape.graphics.endFill();
			// 转换成回放的时候再出现
			//this.m_bgSprite.addChild(m_bgShape);
			
			//this.m_bgSprite.addEventListener(MouseEvent.CLICK, onClkBg);
			/*m_pnl = new Panel(this);
			m_pnl.autoSizeByImage = false;
			m_pnl.setSize(this.m_gkcontext.m_context.m_config.m_curWidth, this.m_gkcontext.m_context.m_config.m_curHeight);
			m_pnl.setPanelImageSkin("commoncontrol/panel/comnpnl.png");
			m_pnl.alpha = 0;
			m_pnl.visible = false;
			m_pnl.addEventListener(MouseEvent.CLICK, onClkBg);*/
			
			// 退出放在右边,回放左边
			m_btnReplay = new ButtonImageText(this, 150, 160, onClkReplay);
			m_btnReplay.recycleSkins = true;
			m_btnReplay.setSize(110, 74);
			//m_btnReplay.setSkinButton1Image("fightscene/end.png");
			//m_btnReplay.visible = false;
			
				
			
			m_lblDesc = new Label(this, 150, 200, "点击任意地方退出", 0xffeec0);
			m_lblDesc.visible = false;
			super.onReady();
		}
		
		override public function onDestroy():void
		{
			removeQuitTimer();
			m_gameFightController.m_fightDB.m_UIReplay = null;
			this.stage.removeEventListener(MouseEvent.CLICK, onClkBg);		
		}
		
		// 大小改变的时候更改控件位置
		override public function onStageReSize():void
		{
			// 按钮位置，局下面居中
			// 退出放在右边,回放左边
			if(0 == m_btnMode)
			{
				m_btnReplay.setPos((this.m_gkcontext.m_context.m_config.m_curWidth) / 2, this.m_gkcontext.m_context.m_config.m_curHeight - 100);
			}
			else
			{
				m_btnReplay.setPos((this.m_gkcontext.m_context.m_config.m_curWidth) / 2 - m_btnReplay.width, this.m_gkcontext.m_context.m_config.m_curHeight - 100);
			}
			m_lblDesc.setPos((this.m_gkcontext.m_context.m_config.m_curWidth - 90) / 2, this.m_gkcontext.m_context.m_config.m_curHeight - 20);			
		}
		
		// 立即退出，回放
		public function onClkReplay(event:MouseEvent):void
		{			
			replay();
		}
		
		// 退出流程,走这个流程没有 vip 限制,目前 Q 键直接退出
		public function replay():void
		{			
			if (0 == m_btnMode) // 立即退出
			{
				if (!m_quit)
				{
					if (m_gkcontext.m_battleMgr.m_bClientBattleSimulation)
					{
						m_gameFightController.bStopPlayer = true;
						m_quit = true;
						//this.m_gkcontext.m_fightControl.cbAniEnd();
						m_gameFightController.resetFight();
						return;
					}
					// 如果在竞技场中，也有战斗结果的，如果是回看竞技场战争就没有了
					//if (!m_gkcontext.m_mapInfo.m_bInArean)
					if (m_gameFightController.fightProcess.m_stAttackVictoryInfoUserCmd)
					{
						// 立即退出也需要显示这个对话框
						m_gameFightController.showFightResult().updateData();					
						
						// 停止播放动画
						m_gameFightController.bStopPlayer = true;
						m_quit = true;
					}
					else
					{
						// 停止播放动画
						m_gameFightController.bStopPlayer = true;
						m_quit = true;
						// 没有战斗结果就肯定不显示了,因为判断不出来
						//m_gkcontext.m_beingProp.m_bShowFailTip = false;
						
						// 如果在竞技场,并且有翻拍奖励,显示翻拍奖励
						if (m_gkcontext.m_contentBuffer.getContent("uiCopyTurnCard_reward", false)) // 如果有战斗奖励
						{
							// 先显示战斗奖励
							var ui:IUITurnCard = m_gkcontext.m_UIMgr.getForm(UIFormID.UIFTurnCard) as IUITurnCard;
							if (ui)
							{
								ui.parseCopyReward(m_gkcontext.m_contentBuffer.getContent("uiCopyTurnCard_reward", true) as ByteArray);
							}
							else
							{
								m_gkcontext.m_UIMgr.loadForm(UIFormID.UIFTurnCard);
							}
						}
						else
						{
							// 在竞技场中如果是回放,没有结果消息
							//m_gkcontext.m_beingProp.m_bShowFailTip = false;
							//this.m_gkcontext.m_fightControl.cbAniEnd();
							m_gameFightController.resetFight();
						}
					}
				}				
			}
			else // 回放
			{
				// 重置退出状态
				// 回放前，需要先关闭战斗结果界面
				m_quit = false;
				this.stage.removeEventListener(MouseEvent.CLICK, onClkBg);	
				m_gameFightController.palyerBack();				
				
			}
		}
		
		// 点击背景，直接退出
		protected function onClkBg(event:MouseEvent):void
		{
			if (event.target == m_btnReplay)
			{
				return;
			}
		
			// 点击背景直接退出战斗
			m_gameFightController.endFight();
			this.m_gkcontext.m_quitFight();		
		}
		
		public function set btnMode(value:uint):void
		{
			m_btnMode = value;		
			
			if (0 == m_btnMode)
			{
				m_btnReplay.setPos((this.m_gkcontext.m_context.m_config.m_curWidth) / 2, this.m_gkcontext.m_context.m_config.m_curHeight - 100);
				m_btnReplay.setSkinButton1Image("fightscene/end.png");	
				
				//m_pnl.visible = false;
				
				m_lblDesc.visible = false;
				this.stage.removeEventListener(MouseEvent.CLICK, onClkBg);
				removeQuitTimer();
			}
			else
			{
				m_btnReplay.setPos((this.m_gkcontext.m_context.m_config.m_curWidth) / 2 - m_btnReplay.width, this.m_gkcontext.m_context.m_config.m_curHeight - 100);
				m_btnReplay.setSkinButton1Image("fightscene/replay.png");				
				
				//m_pnl.visible = true;				
				this.stage.addEventListener(MouseEvent.CLICK, onClkBg);
				m_lblDesc.visible = true;
				
				if (m_gameFightController.m_fightDB.m_fightProcess.isSelfVictory()==0)
				{
					startQuitTimer();				
				}
			}
		}
		
		private function startQuitTimer():void
		{
			if (m_quitTimer == null)
			{
				m_quitTimer = new Timer(5000, 1);
				m_quitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			}
			m_quitTimer.reset();
			m_quitTimer.start();
		}
		
		private function removeQuitTimer():void
		{
			if (m_quitTimer)
			{
				m_quitTimer.stop();
				m_quitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
				m_quitTimer = null;
			}
		}
		protected function onTimer(e:TimerEvent):void
		{
			removeQuitTimer();
			
			m_gameFightController.endFight();
			this.m_gkcontext.m_quitFight();
		}
		public function get btnMode():uint
		{
			return m_btnMode;
		}
		
		public function get bquit():Boolean
		{
			return m_quit;
		}
	}
}