package modulefight.ui
{
	import com.ani.AniPosition;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Exponential;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import ui.player.PlayerResMgr;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;

	/**
	 * @ brief 锦囊半身像效果
	 * */
	public class UIJNHalfImg extends Form
	{
		protected var m_pnlBlack:Panel;
		protected var m_pnlHalf:Panel;
		protected var m_pnlTopRed:Panel;
		protected var m_pnlMidRed:Panel;
		protected var m_pnlBtmRed:Panel;
		
		protected var m_aniHalf:AniPosition;
		protected var m_easeHalf:Function = Back.easeOut;
		
		protected var m_aniTop:AniPosition;
		protected var m_easeTop:Function = Back.easeOut;
		
		protected var m_aniMid:AniPosition;
		protected var m_easeMid:Function = Back.easeOut;
		
		protected var m_aniBtm:AniPosition;
		protected var m_easeBtm:Function = Back.easeOut;

		protected var m_time:uint;		// 定时器
		public var m_fEndCB:Function;
		protected var m_res:SWFResource;	// 加载的资源
		protected var m_job:uint;
		protected var m_gender:uint;

		public function UIJNHalfImg()
		{
			this.id = UIFormID.UIJNHalfImg;
		}
		
		override public function onReady():void
		{
			this._alignVertial = Component.TOP;
			this._alignHorizontal = Component.LEFT;

			m_pnlBlack = new Panel(this);
			m_pnlBlack.autoSizeByImage = false;
			m_pnlBlack.setPanelImageSkin("commoncontrol/panel/comnpnl.png");
			m_pnlBlack.alpha = 0.6;

			// 红光.png   1920 x 150
			m_pnlTopRed = new Panel(this);
			m_pnlTopRed.autoSizeByImage = false;
			m_pnlTopRed.setPanelImageSkin("fightscene/redrad.png");
			
			m_pnlMidRed = new Panel(this);
			m_pnlMidRed.autoSizeByImage = false;
			m_pnlMidRed.setPanelImageSkin("fightscene/redrad.png");
			
			m_pnlBtmRed = new Panel(this);
			m_pnlBtmRed.autoSizeByImage = false;
			m_pnlBtmRed.setPanelImageSkin("fightscene/redrad.png");
			
			m_aniTop = new AniPosition();
			m_aniTop.sprite = m_pnlTopRed;
			m_aniTop.onEnd = onAniEndTop;
			m_aniTop.ease = m_easeTop;

			m_aniMid = new AniPosition();
			m_aniMid.sprite = m_pnlMidRed;
			m_aniMid.onEnd = onAniEndMid;
			m_aniMid.ease = m_easeMid;
			
			m_aniBtm = new AniPosition();
			m_aniBtm.sprite = m_pnlBtmRed;
			m_aniBtm.onEnd = onAniEndBtm;
			m_aniBtm.ease = m_easeBtm;
			
			m_pnlHalf = new Panel(this);
			
			m_aniHalf = new AniPosition();
			m_aniHalf.sprite = m_pnlHalf;
			m_aniHalf.duration = 0.6;
			m_aniHalf.onEnd = onAniEndHalf;
			m_aniHalf.ease = Exponential.easeIn;
			super.onReady();
		}
		
		override public function onShow():void
		{
			super.onShow();
			onStageReSize();
			
			m_pnlHalf.visible = false;
			m_pnlTopRed.visible = false;
			m_pnlMidRed.visible = false;
			m_pnlBtmRed.visible = false;
		}
		
		override public function onStageReSize():void
		{
			super.onStageReSize();
			
			// 调整具体的位置 // 红光.png   1920 x 150
			m_pnlTopRed.setSize(this.m_gkcontext.m_context.m_config.m_curWidth, 150);
			m_pnlTopRed.setPos(0, 50);
			m_pnlMidRed.setSize(this.m_gkcontext.m_context.m_config.m_curWidth, 150);
			m_pnlMidRed.setPos(0, (this.m_gkcontext.m_context.m_config.m_curHeight - 150)/2);
			m_pnlBtmRed.setSize(this.m_gkcontext.m_context.m_config.m_curWidth, 150);
			m_pnlBtmRed.setPos(0, this.m_gkcontext.m_context.m_config.m_curHeight - 150 - 50);
			
			m_pnlBlack.setSize(this.m_gkcontext.m_context.m_config.m_curWidth, this.m_gkcontext.m_context.m_config.m_curHeight);
		}
		
		override public function dispose():void
		{
			if(m_time)
			{
				clearInterval(m_time);
				m_time = 0;
			}
			
			m_fEndCB = null;
			
			if(m_aniHalf)
			{
				m_aniHalf.dispose();
				m_aniHalf = null;
			}
			
			if(m_aniTop)
			{
				m_aniTop.dispose();
				m_aniTop = null;
			}
			
			if(m_aniMid)
			{
				m_aniMid.dispose();
				m_aniMid = null;
			}
			
			if(m_aniBtm)
			{
				m_aniBtm.dispose();
				m_aniBtm = null;
			}
			if(m_res)
			{
				m_gkcontext.m_context.m_resMgr.unload(m_res.filename, SWFResource);
				m_res = null;
			}
			
			super.dispose();
		}
		
		protected function onTimer():void
		{
			clearInterval(m_time);
			m_time = 0;
			
			// 通知锦囊播放完成
			if(m_fEndCB != null)
			{
				m_fEndCB();
			}
			
			exit();
		}
		
		// type: 说明战斗的是万家还是怪
		public function setHalfImage(type:uint, job:uint = 0, gender:uint = 0):void
		{
			m_job = job;
			m_gender = gender;
			if(m_res)
			{
				m_gkcontext.m_context.m_resMgr.unload(m_res.filename, SWFResource);
			}
			// 加载资源
			m_res = m_gkcontext.m_context.m_resMgr.load(m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(job, gender, PlayerResMgr.HDHalf), SWFResource, onResLoaded, onResFailed) as SWFResource;
			// 设置半身像
			//if(0 == type)		// 如果是玩家
			//{
				//m_pnlHalf.setPanelImageSkinBySWF(m_gkcontext.m_context.m_playerResMgr.roundHeadPathName(job, gender, PlayerResMgr.HDHalf), m_gkcontext.m_context.m_playerResMgr.halfImgClsName(job, gender));
			//}
			//else				// 如果是怪
			//{
			//	m_pnlHalf.setPanelImageSkin("herohalfing/monster.png");
			//}
		}
		
		// 设置胜的是那一边
		public function setSide(side:uint):void
		{
			if(side == EntityCValue.RKLeft)
			{
				m_aniHalf.setBeginPos(this.m_gkcontext.m_context.m_config.m_curWidth, (this.m_gkcontext.m_context.m_config.m_curHeight - 878)/2);
				m_aniHalf.setEndPos(0, (this.m_gkcontext.m_context.m_config.m_curHeight - 878)/2)
				//m_aniHalf.speed = 800;
			}
			else
			{
				m_aniHalf.setBeginPos(-1200, (this.m_gkcontext.m_context.m_config.m_curHeight - 878)/2);
				m_aniHalf.setEndPos(this.m_gkcontext.m_context.m_config.m_curWidth - 1200, (this.m_gkcontext.m_context.m_config.m_curHeight - 878)/2);
				//m_aniHalf.speed = 800;
			}
		}
		
		public function startAni():void
		{
			// 红光.png   1920 x 150
			//m_aniHalf.setBeginPos(this.m_gkcontext.m_context.m_config.m_curWidth, 200);
			//m_aniHalf.setEndPos(0, 200)
			//m_aniHalf.speed = 800;
			
			m_aniTop.setBeginPos(this.m_gkcontext.m_context.m_config.m_curWidth, 50);
			m_aniTop.setEndPos(0, 50);
			m_aniTop.speed = 800;
			
			m_aniMid.setBeginPos(-1920, (this.m_gkcontext.m_context.m_config.m_curHeight - 150)/2);
			m_aniMid.setEndPos(0, (this.m_gkcontext.m_context.m_config.m_curHeight - 150)/2);
			m_aniMid.speed = 800;
			
			m_aniBtm.setBeginPos(this.m_gkcontext.m_context.m_config.m_curWidth, this.m_gkcontext.m_context.m_config.m_curHeight - 150 - 50);
			m_aniBtm.setEndPos(0, this.m_gkcontext.m_context.m_config.m_curHeight - 150 - 50)
			m_aniBtm.speed = 800;
			
			// 开始特效
			m_aniHalf.begin();
			m_aniTop.begin();
			m_aniMid.begin();
			m_aniBtm.begin();
			
			m_pnlHalf.visible = true;
			m_pnlTopRed.visible = true;
			m_pnlMidRed.visible = true;
			m_pnlBtmRed.visible = true;
		}
		
		protected function onAniEndHalf():void
		{
			m_time = setInterval(onTimer, 1000);
		}
		
		protected function onAniEndTop():void
		{
			
		}
		
		protected function onAniEndMid():void
		{
			
		}
		
		protected function onAniEndBtm():void
		{
			
		}
		
		public function onResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			Logger.info(null, null, event.resourceObject.filename + " loaded");
			
			m_pnlHalf.setPanelImageSkinBySWF(m_res, m_gkcontext.m_context.m_playerResMgr.halfImgClsName(m_job, m_gender));
			
			m_gkcontext.m_context.m_resMgr.unload(m_res.filename, SWFResource);
			m_res = null;
		}
		
		public function onResFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			Logger.error(null, null, event.resourceObject.filename + " failed");
			
			m_gkcontext.m_context.m_resMgr.unload(m_res.filename, SWFResource);
			m_res = null;
		}
	}
}