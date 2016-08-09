package modulecommon.scene.beings
{
	import com.pblabs.engine.entity.BeingEntity;
	import com.pblabs.engine.entity.EffectEntity;
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.UtilCommon;
	
	import flash.display.Sprite;
	
	import modulecommon.GkContext;
	import modulecommon.appcontrol.BubbleWordSprite;
	import modulecommon.headtop.HeadTopBlockBase;
	import modulecommon.headtop.HeadTopPlayerStateBase;
	import ui.player.PlayerResMgr;
	import com.util.UtilTools;
	
	import org.ffilmation.engine.core.fScene;
	//import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	//import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ObjectSeqRenderer;
	
	//import org.ffilmation.utils.mathUtils;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class Player extends BeingEntity
	{			
		private var m_uCharID:uint;
		private var m_gender:int;
		private var m_job:uint;
		private var m_platform:int;	//平台
		private var m_zoneID:int;	//（前端）区ID		
		
		private var m_bubbleSprite:BubbleWordSprite;
		public var m_uVipscore:uint;
		private var m_filters:Array;
		protected var m_guanzhi:String;		//官职竞技中获得称号		
		
		protected var m_headTopBlockBase:HeadTopBlockBase;
		private var m_states:Vector.<uint>;
		protected var m_eff:EffectEntity;
		
		public var m_titileInSanguozhanchang:int;	//玩家在三国战场中的称号
		public var m_zhenying:int;	//玩家在三国战场中的称号
		
		protected var m_wuEffType:uint;		// 武将特效类型
		protected var m_wuEff:EffectEntity;
		
		public function Player(defObj:XML, scene:fScene)
		{
			super(defObj, scene);
			
			m_type = EntityCValue.TPlayer;
			m_gender = PlayerResMgr.GENDER_male;			
		}
		
		// KBEN: 释放资源
		override public function dispose():void
		{
			// bug: 现在都是从管理器中主动释放的，没有被动释放的 
			//this.scene.engine.m_context.m_playerManager.disposeBeing(this as Player);	
			m_headTopBlockBase.dispose()
			this.disposePlayer();
			if (m_bubbleSprite != null)
			{
				m_bubbleSprite.dispose();
			}
			super.dispose();
		}

		public function set guanzhiName(str:String):void
		{
			m_guanzhi = str;
			m_headTopBlockBase.invalidate();
		}
		
		public function get guanzhiName():String
		{
			return m_guanzhi;
		}
		
		protected function disposePlayer():void
		{
		
		}
		
		public function get isHero():Boolean
		{
			return this is PlayerMain;
		}
		
		public function setBaseParam(charID:uint, gender:int, job:int, platform:int, zonID:int):void
		{
			m_uCharID = charID;
			m_gender = gender;
			m_job = job;
			m_platform = platform;
			m_zoneID = zonID;
		}		
		
		public function get charID():uint
		{
			return m_uCharID;
		}
		
		public function set gender(gender:int):void
		{
			m_gender = gender;
		}
		
		public function get gender():int
		{
			return m_gender;
		}	
		
		public function get job():uint
		{
			return m_job;
		}
		
		public function get platform():int
		{
			return m_platform;
		}
		public function get platformName():String
		{
			return m_context.m_platformMgr.getPlatformName(m_platform);
		}
		public function get zoneID():int
		{
			return m_zoneID;
		}
		
		override public function updateNameDesc():void
		{
			m_headTopBlockBase.invalidate();	
		}
		
		public function get gkcontext():GkContext
		{
			return this.context.m_gkcontext as GkContext;
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
		
		public function setBubble(str:String):void
		{
			if (m_bubbleSprite == null)
			{
				m_bubbleSprite = new BubbleWordSprite(this.context);
				m_bubbleSprite.setTimerComplete(onBubbleComplete);
			}
			m_bubbleSprite.setText(str);
			m_bubbleSprite.setDelayTime(m_bubbleSprite.getTextLines() * 3000);
			m_bubbleSprite.setPos(0, -this.getTagHeight() - 20);
			var base:Sprite = this.baseObj;
			if (base.contains(m_bubbleSprite) == false)
			{
				base.addChild(m_bubbleSprite);
			}
		}
		
		public function initStates(states:Vector.<uint>):void
		{
			m_states = states;
			if (this.assetsCreated)
			{
				onInitUserStates();
			}
			
		}

		public function onInitUserStates():void
		{
			if (m_states == null)
			{
				return;
			}
			var id:int = 0;
			for (id = 0; id < UserState.USERSTATE_MAX; id++)
			{
				if (isUserSet(id))
				{
					onUserStateSet(id);
				}
			}			
		}
		
		public function setUserState(id:uint):void
		{
			if (isUserSet(id))
			{
				return;
			}
			UtilCommon.setState(m_states, id);
			
			if (!this.assetsCreated)
			{
				return;
			}
			
			
			onUserStateSet(id);
		}
		
		public function clearUserState(id:uint):void
		{
			if (isUserSet(id)==false)
			{
				return;
			}
			UtilCommon.clearState(m_states, id);
			
			if (!this.assetsCreated)
			{
				return;
			}
			
			
			onUserStateClear(id);			
		}
		
		protected function onUserStateSet(id:uint):void
		{
			if (id == UserState.USERSTATE_DAZUO)
			{
				this.direction = UtilTools.convS2CDir(2);
				this.state = EntityCValue.TDaZuo;
				
				if (null == m_eff)
				{
					m_eff = this.addLinkEffect("e3_e403", 9, true);	//打坐时特效
				}
				
				//如果在骑乘直接进入 打坐状态，更新一下文字标签高度，否则高度不对
				this.hasUpdateTagBounds2d = false;
			}
			else if (id == UserState.USERSTATE_FUYOUEXP)
			{			
				(m_headTopBlockBase as HeadTopPlayerStateBase).showDazuoBall();		
			}
			else if (id == UserState.USERSTATE_DIE)
			{
				grayChange(true);
			}
			else if (id == UserState.USERSTATE_4NORMALPHEFFECT || id == UserState.USERSTATE_4GUIPHEFFECT || id == UserState.USERSTATE_4XIANPHEFFECT || id == UserState.USERSTATE_4SHENPHEFFECT)
			{
				wuEffType = (id - UserState.USERSTATE_4NORMALPHEFFECT + 1);
			}
			
			if (UserState.s_shouldUpdateHeadTopOnStateChange(id))
			{
				updateNameDesc();
			}
		}
		
		protected function onUserStateClear(id:uint):void
		{
			if (id == UserState.USERSTATE_DAZUO)
			{
				this.direction = UtilTools.convS2CDir(2);
				this.state = EntityCValue.TStand;
				
				this.removeLinkEffect(m_eff);
				m_eff = null;
				
				// 打坐状态取消的时候，如果在骑乘，更新一下文字标签高度
				this.hasUpdateTagBounds2d = false;
			}
			else if (id == UserState.USERSTATE_FUYOUEXP)
			{
				(m_headTopBlockBase as HeadTopPlayerStateBase).hideDazuoBall();
			}
			else if (id == UserState.USERSTATE_DIE)
			{
				grayChange(false);
			}
			else if (id == UserState.USERSTATE_4NORMALPHEFFECT || id == UserState.USERSTATE_4GUIPHEFFECT || id == UserState.USERSTATE_4XIANPHEFFECT || id == UserState.USERSTATE_4SHENPHEFFECT)
			{
				wuEffType = EntityCValue.MWETNone;
			}
			
			if (UserState.s_shouldUpdateHeadTopOnStateChange(id))
			{
				updateNameDesc();
			}
		}
		
		public function isUserSet(id:uint):Boolean
		{			
			return UtilCommon.isSet(m_states, id);
		}
		
		//判断数组（list）中是否存在处于设置状态的项
		public function isSetWithArray(list:Array):Boolean
		{
			var id:uint;
			for each(id in list)
			{
				if (UtilCommon.isSet(m_states, id))
				{
					return true;
				}
			}
			return false;
		}
		
		override public function onCreateAssets():void 
		{			
			var base:Sprite = this.uiLayObj; 
			m_headTopBlockBase.addToDisplayList(base);		
			if (m_tagBounds2d.height <= 1)
			{
				m_headTopBlockBase.visible = false;				
			}
			onInitUserStates();
			//m_headTopBlockBase.setPos(m_tagBounds2d.x+m_tagBounds2d.width/2, -this.getTagHeight() - 20);
		}

		override public function onSetTagBounds2d():void 
		{
			m_headTopBlockBase.setPos(m_tagBounds2d.x + m_tagBounds2d.width / 2, m_tagBounds2d.y);
			if (m_headTopBlockBase.visible == false)
			{
				m_headTopBlockBase.visible = true;
			}
		}
		
		public function get isGM():Boolean
		{
			return isUserSet(UserState.USERSTATE_GM);
		}
		
		public function toggleSceneShow(bshow:Boolean):void
		{
			if (this.customData.flash9Renderer)
			{
				(this.customData.flash9Renderer as fFlash9ElementRenderer).toggleSceneShow(bshow);
			}
		}

		public function get wuEffType():uint
		{
			return m_wuEffType;
		}
		
		public function set wuEffType(value:uint):void
		{
			if (m_wuEffType != value)
			{
				if (m_wuEffType != EntityCValue.MWETNone)
				{
					clearWuEff();
				}
			}
			
			m_wuEffType = value;
			
			if (m_wuEffType != EntityCValue.MWETNone)
			{
				addWuEff();
			}
		}
		
		public function clearWuEff():void
		{
			if (m_wuEff)
			{
				removeLinkEffect(m_wuEff);
				m_wuEff = null;
			}
		}
		
		public function addWuEff():void
		{
			if (m_wuEffType == EntityCValue.MWETO)
			{
				m_wuEff = addLinkEffect(EntityCValue.MWENO, 0, true);
			}
			else if (m_wuEffType == EntityCValue.MWETT)
			{
				m_wuEff = addLinkEffect(EntityCValue.MWENT, 0, true);
			}
			else if (m_wuEffType == EntityCValue.MWETH)
			{
				m_wuEff = addLinkEffect(EntityCValue.MWENH, 0, true);
			}
			else if (m_wuEffType == EntityCValue.MWETF)
			{
				m_wuEff = addLinkEffect(EntityCValue.MWENF, 0, true);
			}
		}
	}
}