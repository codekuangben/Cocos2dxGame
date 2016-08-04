package modulefight.ui.battlehead 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.dgrigg.image.CommonImageManager;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.Resource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import modulefight.scene.fight.FightDB;
	
	import flash.display.DisplayObjectContainer;
	//import flash.display.Sprite;
	
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	import modulefight.netmsg.stmsg.stArmy;
	//import modulefight.scene.fight.FightDB;

	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIBattleHead extends Form 
	{
		private var m_fightDB:FightDB;
		private var m_roundPanel:RoundPanel;
		private var m_leftPanel:BattleHeadLeftPanel;
		private var m_rightPanel:BattleHeadRightPanel;
		private var m_bReady:Boolean;
		private var m_res:Resource;
		private var m_aniArmyEnter:AniArmyEnter;
		private var m_tipsPanel:AniTips;
		private var m_jnCnter:DisplayObjectContainer;	// 飞行的锦囊容器
		private var m_expCnter:DisplayObjectContainer;	// 爆炸特效容器
		
		private var m_expPnl:SubJNColde;	// 锦囊碰撞后的爆炸面板
		public var m_jnAniData:DataJNAni;	// 这个是锦囊动画需要的数据
		
		public function UIBattleHead(fightDB:FightDB) 
		{
			m_fightDB = fightDB;
			this.id = UIFormID.UIBattleHead;	
			m_bReady = false;
		}
		public static function IMAGESWF():String
		{
			return CommonImageManager.toPathString("module/imageBattleHead.swf");
		}
		override public function onReady():void
		{
			this.exitMode = EXITMODE_DESTORY;
			this.alignHorizontal = Component.LEFT;
			this.alignVertial = Component.TOP;
			this.marginTop = 1;
			m_jnAniData = new DataJNAni();
			
			this.draggable = false;
			
			m_tipsPanel = new AniTips(this, 0, -158);
			
			m_roundPanel = new RoundPanel(this, m_gkcontext.m_context);
			m_roundPanel.y = 40;
			//m_roundPanel.x = (this.m_gkcontext.m_context.m_config.m_curWidth - 207) / 2;
			
			m_leftPanel = new BattleHeadLeftPanel(m_gkcontext, this);
			m_leftPanel.x = 5;
			m_leftPanel.jnAniData = m_jnAniData;	// 更新锦囊数据
			this.addChild(m_leftPanel);
			
			m_rightPanel = new BattleHeadRightPanel(m_gkcontext, this);
			m_rightPanel.jnAniData = m_jnAniData;
			this.addChild(m_rightPanel);
			m_rightPanel.x = this.m_gkcontext.m_context.m_config.m_curWidth-5;
			m_res = m_gkcontext.m_context.m_resMgr.load(IMAGESWF(), SWFResource, onImageSwfLoaded, onImageSwfFailed);
			
			m_jnAniData.m_pzCB = flyEndCB;
			m_jnAniData.m_bzCB = expEndCB;
			m_jnAniData.m_justbzCB = justExpEndCB;
			
			// 飞行的锦囊的特效
			m_jnCnter = new Panel();
			this.addChild(m_jnCnter);
			m_jnAniData.m_jnCnter = m_jnCnter;
			// 爆炸特效
			m_expCnter = new Panel();
			this.addChild(m_expCnter);
			super.onReady();
			
			
		}		
		
		private function onImageSwfLoaded(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			createImage(resource);
			m_gkcontext.m_context.m_resMgr.unload(IMAGESWF(), SWFResource);
			m_res = null;
		}
		
		override public function adjustPosWithAlign():void 
		{
			super.adjustPosWithAlign();
			m_roundPanel.x = (this.m_gkcontext.m_context.m_config.m_curWidth - 207) / 2 - 20;
			m_tipsPanel.x = (this.m_gkcontext.m_context.m_config.m_curWidth - 570) / 2 ;
			m_rightPanel.x = this.m_gkcontext.m_context.m_config.m_curWidth-5;			
		}
		
		override public function dispose():void 
		{
			// 爆炸,只有显示的时候才在显示列表
			if(m_expPnl && !this.contains(m_expPnl))
			{
				m_expPnl.dispose();
				m_expPnl = null;
			}
			
			if (m_aniArmyEnter)
			{
				if (m_aniArmyEnter.isVisible()==false)
				{
					m_aniArmyEnter.dispose();
				}
			}
			if (m_tipsPanel)
			{
				m_tipsPanel.dispose()
				m_tipsPanel = null;
			}
			super.dispose();
			if (m_res)
			{
				m_res.removeEventListener(ResourceEvent.LOADED_EVENT, onImageSwfLoaded);
				m_res.removeEventListener(ResourceEvent.FAILED_EVENT, onImageSwfFailed);
				m_gkcontext.m_context.m_resMgr.unload(IMAGESWF(), SWFResource);
				m_res = null;
			}
			
			// 释放
			m_jnAniData.dispose();
		}
		public function setCurArmy(side:int, army:stArmy):void
		{
			if (side == EntityCValue.RKLeft)
			{
				m_leftPanel.setCurArmy(army);
			}
			else
			{
				if (m_rightPanel != null)
				{
					m_rightPanel.setCurArmy(army);
				}
			}
		}
		
		private function createImage(resource:SWFResource):void
		{
			m_roundPanel.setPanelImageSkinBySWF(resource, "battleHead.roundback");			
			setRound(this.m_fightDB.m_fightControl.curRoundIndex);
		}
		
		//bRestrained: true - 表示此锦囊被抑制
		//public function useJinnang(side:uint, idJinnang:uint, bRestrained:Boolean, onFlyEnd:Function=null):void
		public function useJinnang():void
		{
			if(1 == m_jnAniData.jnCnt())	// 如果只有一方释放
			{
				if(0 == m_jnAniData.jnSide())	// 如果左边释放
				{
					m_leftPanel.useJinnangID();
				}
				else
				{
					m_rightPanel.useJinnangID();
				}
			}
			else	// 两边都释放锦囊
			{
				m_leftPanel.useJinnangID();
				m_rightPanel.useJinnangID();
			}
		}
		public function updateHp(side:uint):void
		{
/*			if (side == 0)
			{
				m_leftPanel.updateHp();
			}
			else
			{
				if (m_rightPanel != null)
				{
					m_rightPanel.updateHp();
				}
			}*/
		}
		
		public function setRound(roundIndex:int):void
		{
			m_roundPanel.setRound(roundIndex);
		}
		public function showTips():void
		{
			if (m_tipsPanel)
			{
				m_tipsPanel.beginPlay(m_fightDB.m_tipsMgr.getString());
				m_tipsPanel.visible = true;
			}
		}
		public function hideTips():void
		{
			if (m_tipsPanel)
			{
				m_tipsPanel.visible = false;
			}
		}
		public function onEndRound():void
		{
			m_leftPanel.onEndRound();
			m_rightPanel.onEndRound();
		}
		
		//return true-表示UIBattleHead已经准备完毕。
		public function get isReady():Boolean
		{
			return m_bReady;
		}
		
		//更新是否准备完毕
		public function updateReady():void
		{
			if (!m_bReady && m_leftPanel.visible && m_rightPanel.visible)
			{
				m_bReady = true;
				//m_fightDB.m_fightControl.attemptBegin();
			}
		}
		
		// 锦囊飞行效果完成
		public function flyEndCB():void
		{
			// 开始爆炸特效
			if(!m_expPnl)
			{
				// 在屏幕中心位置
				//m_expPnl = new SubJNColde(m_gkcontext, this, m_gkcontext.m_context.m_config.m_curWidth/2, m_gkcontext.m_context.m_config.m_curHeight/2);
				m_expPnl = new SubJNColde(m_gkcontext, this);
				m_expPnl.m_jnAniData = m_jnAniData;		// 保存锦囊特效全局变量
			}
			m_expCnter.addChild(m_expPnl);
			m_expPnl.show();
		}
		
		// 爆炸特效完成会掉
		public function expEndCB():void
		{
			// 删爆炸特效,如果是比较,并且锦囊等级相等,那么就不播放爆炸特效
			if(m_expPnl && m_expCnter.contains(m_expPnl))
			{
				m_expCnter.removeChild(m_expPnl);
				m_expPnl.dispose();
				m_expPnl = null;
			}
			
			if(m_jnAniData.m_firEndCB != null)
			{
				m_jnAniData.m_firEndCB();
			}
		}
		
		public function justExpEndCB():void
		{
			m_leftPanel.disposeFlyJN();
			m_rightPanel.disposeFlyJN();
		}
		
		// 如果锦囊在播放中,停止播放
		public function stopJN():void
		{
			m_leftPanel.stopJN();
			m_rightPanel.stopJN();
			
			if(m_expPnl)
			{
				m_expPnl.stopJN();
			}
		}
		
		// side 左边还是右边  cnt: 兵团的剩余数量
		public function setLeftArmyCnt(side:uint, cnt:uint):void
		{
			if(EntityCValue.RKLeft == side)
			{
				m_leftPanel.setLeftArmyCnt(cnt);
			}
			else
			{
				m_rightPanel.setLeftArmyCnt(cnt);
			}
		}
		
		public function beginAniArmyEnter():void
		{
			if (m_aniArmyEnter == null)
			{
				m_aniArmyEnter = new AniArmyEnter(this);
			}
			m_aniArmyEnter.x = m_roundPanel.x + 55;
			m_aniArmyEnter.y = m_roundPanel.y+140;
			m_aniArmyEnter.beginAni();
		}
	}
}