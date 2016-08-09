package modulecommon.scene.beings
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	
	import com.gamecursor.GameCursor;
	import com.gskinner.motion.GTween;
	import com.pblabs.engine.entity.EntityCValue;
	//import modulecommon.headtop.HeadTopBlockBase;
	import modulecommon.headtop.NpcVisitHeadTopBlock;
	
	import flash.display.Sprite;
	
	//import modulecommon.CommonEn;
	import modulecommon.fun.BubbleHeadSprite;
	import modulecommon.appcontrol.BubbleWordSprite;
	//import modulecommon.net.msg.copyUserCmd.stReqMaxClearanceIdUserCmd;
	import modulecommon.net.msg.sceneUserCmd.stVisitNpcUserCmd;
	import modulecommon.scene.prop.table.TNpcVisitItem;
	import modulecommon.ui.UIFormID;
	
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	
	public class NpcVisit extends NpcVisitBase
	{
		private var m_npcBase:TNpcVisitItem;
		private var m_bubbleHeadSprite:BubbleHeadSprite;
		private var m_bubbleSprite:BubbleWordSprite;
		private var m_isArmy:Boolean; //true - 代表此NPC背后有一个兵团
		
		private var m_GTween:GTween;
		private var m_layer:uint = 0; // 这个主要用在有些 npc 需要放在的地物层，永远放在人物层下面，不排序
		private var m_btaskAct:Boolean = false; // 动作类型,是否是任务播放,如果是任务播放,就用死亡动作
		private var m_serverState:uint = uint.MAX_VALUE; // 服务器状态,目前仅仅用来标示死亡,然后客户端需要把动作播放完成,然后再删除
		
		public function NpcVisit(defObj:XML, scene:fScene)
		{
			super(defObj, scene);
			m_type = EntityCValue.TVistNpc;
			m_headTopBlockBase = new NpcVisitHeadTopBlock(gkcontext, this);
			
			// bug: 释放资源
			this.xmlObj = null;
		}
		
		public function set npcBase(base:TNpcVisitItem):void
		{
			m_npcBase = base;
		}
		
		public function get npcBase():TNpcVisitItem
		{
			return m_npcBase;
		}
		
		override public function execFunction():void
		{
			//var str:String;
			//str = "执行地图npc(NpcVisit:" + m_npcBase.m_uID.toString() +")功能函数";			
			//gkcontext.m_uiChat.debugMsg(str);
			
			if (EntityCValue.NPCID_SKIPInCity == m_npcBase.m_uID)
			{
				this.gkcontext.m_UIMgr.showFormInGame(UIFormID.UIWorldMap);
				/*var temp:uint = 0-1;
				
				   if(gkcontext.m_beingProp.checkPoint == temp)
				   {
				   var rsend:stReqMaxClearanceIdUserCmd = new stReqMaxClearanceIdUserCmd();
				   this.context.sendMsg(rsend);
				 }*/
			}
			else
			{
				var send:stVisitNpcUserCmd = new stVisitNpcUserCmd();
				send.npctempid = this.tempid;
				this.gkcontext.sendMsg(send);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if (m_GTween != null)
			{
				m_GTween.paused = true;
				m_GTween.target = null;
				m_GTween = null;
			}
			if (m_bubbleSprite != null)
			{
				m_bubbleSprite.dispose();
				m_bubbleSprite = null;
			}
		}
		
		public function gtAni(values:Object, duration:Number):void
		{
			if (m_GTween == null)
			{
				m_GTween = new GTween(this);
			}
			
			m_GTween.resetValues(values);
			m_GTween.duration = duration;
			m_GTween.paused = false;
		}
		
		/*
		 * 返回值: true - 此NpcVisit是兵团
		 */
		public function get isArmy():Boolean
		{
			return m_isArmy;
		}
		
		public function set isArmy(bFlag:Boolean):void
		{
			m_isArmy = bFlag;
		}
		
		//返回值:true - 表示可以被攻击
		override public function get canAttacked():Boolean
		{
			var ret:Boolean;
			if (m_isArmy)
			{
				if (gkcontext.m_sanguozhanchangMgr.inZhanchang)
				{
					if (!gkcontext.m_sanguozhanchangMgr.isMyShouwei(m_npcBase.m_uID))
					{
						ret = true;
					}
				}
				else
				{
					ret = true;
				}
			}
			return ret;
		}
		
		public function setHeadBubble(str:String, headName:String):void
		{
			if (m_bubbleHeadSprite == null)
			{
				m_bubbleHeadSprite = new BubbleHeadSprite(this.gkcontext);
			}
			
			m_bubbleHeadSprite.setText(str, headName);
			
			var h:Number = this.getTagHeight();
			if (h == 0)
			{
				h = 100;
			}
			m_bubbleHeadSprite.setPos(0, -h - 20);
			var base:Sprite = this.baseObj;
			if (!base)
				return;
			if (base.contains(m_bubbleHeadSprite) == false)
			{
				base.addChild(m_bubbleHeadSprite);
			}
		}
		
		public function setBubble(str:String):void
		{
			if (m_bubbleSprite == null)
			{
				m_bubbleSprite = new BubbleWordSprite(this.context);
				m_bubbleSprite.setTimerComplete(onBubbleComplete);
			}
			m_bubbleSprite.setText(str);
			m_bubbleSprite.setDelayTime(3000 + m_bubbleSprite.getTextLines() * 600);
			m_bubbleSprite.setPos(0, -this.getTagHeight() - 20);
			var base:Sprite = this.baseObj;
			if (base && base.contains(m_bubbleSprite) == false)
			{
				base.addChild(m_bubbleSprite);
			}
		
		}
		
		protected function onBubbleComplete():void
		{
			var base:Sprite = this.baseObj;
			if (base != null && m_bubbleSprite != null)
			{
				if (base.contains(m_bubbleSprite))
				{
					base.removeChild(m_bubbleSprite);
				}
			}
		}
		
		override public function onMouseEnter():void
		{
			var gameCursorState:int = -1;
			if (canAttacked)
			{				
				gameCursorState = GameCursor.STATICSTATE_Attack;				
			}
			else if (EntityCValue.NPCID_SKIPInCity == m_npcBase.m_uID || EntityCValue.NPCID_SKIP == m_npcBase.m_uID)
			{
				gameCursorState = GameCursor.STATICSTATE_Pickup;
			}
			else if (NpcDef.NPCID_MineInSanguoZhanchang == m_npcBase.m_uID)
			{
				gameCursorState = GameCursor.STATICSTATE_hand;
			}
			else
			{
				if (m_npcBase.m_cursor >= 0 && m_npcBase.m_cursor < GameCursor.STATICSTATE_NUM)
				{
					gameCursorState = m_npcBase.m_cursor;
				}
			}
			
			if (gameCursorState != -1)
			{
				m_context.m_gameCursor.setStaticState(gameCursorState,this);
			}
			if (this.customData.flash9Renderer)
			{
				(this.customData.flash9Renderer as fFlash9ElementRenderer).onMouseEnter();
			}
		}
		
		public function hideHeadBubble():void
		{
			var base:Sprite = this.baseObj;
			if (base != null && m_bubbleHeadSprite != null)
			{
				if (base.contains(m_bubbleHeadSprite))
				{
					base.removeChild(m_bubbleHeadSprite);
				}
			}
		}
		
		override public function get layer():uint
		{
			return m_layer;
		}
		
		override public function set layer(value:uint):void
		{
			m_layer = value;
		}
		
		public function set taskAct(value:Boolean):void
		{
			m_btaskAct = value;
		}
		
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			
			if (m_btaskAct)
			{
				if (m_state == EntityCValue.TDie)
				{
					// 动作播放完成,恢复待机状态     
					if (this.customData.flash9Renderer.aniOver())
					{
						state = EntityCValue.TStand;
						m_btaskAct = false;
						
						// 然后直接删除,因为服务器已经把它删除了
						if (m_serverState == EntityCValue.TDie)
						{
							this.gkcontext.m_npcManager.destroyBeingByTmpID(this.m_tempid);
						}
					}
				}
			}
		}
		
		public function get serverState():uint
		{
			return m_serverState;
		}
		
		public function set serverState(value:uint):void
		{
			m_serverState = value;
		}
	
	}
}