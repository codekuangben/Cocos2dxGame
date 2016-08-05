package modulecommon.scene.beings 
{
	/**
	 * ...
	 * @author 
	 */
	//import modulecommon.GkContext;
	import modulecommon.CommonEn;
	import modulecommon.headtop.PlayerOtherHeadTopBlock;
	import modulecommon.net.msg.sceneUserCmd.stAttackUserCmd;
	import org.ffilmation.engine.core.fScene;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GradientGlowFilter;
	import com.util.PBUtil;
	import com.util.UtilFilter;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9SceneObjectSeqRenderer;
	import com.gamecursor.GameCursor;
	import modulecommon.logicinterface.IVisitSceneObject;
	import org.ffilmation.utils.mathUtils;
	
	public class PlayerOther extends Player implements IVisitSceneObject
	{
		public static const DISTANCE_VISIT:uint = 80;
		public static const DISTANCE_GOTOVISIT:uint = 70;
		public var m_corpsName:String;
		
		public function PlayerOther(defObj:XML, scene:fScene)
		{
			super(defObj, scene);
			m_headTopBlockBase = new PlayerOtherHeadTopBlock(gkcontext,this);
			
			// bug: 释放资源
			this.xmlObj = null;
		}
		
		override protected function onUserStateSet(id:uint):void
		{
			super.onUserStateSet(id);
		}
		
		override protected function onUserStateClear(id:uint):void
		{
			super.onUserStateClear(id);
		}
		override public function onMouseEnter():void
		{		
			var list:Array = new Array();
			if (m_greyFilter)
			{
				list.push(m_greyFilter);
			}
			
			var filter1:GradientGlowFilter =PBUtil.buildGradientGlowFilter();
			var filter2:ColorMatrixFilter = UtilFilter.createLuminanceFilter(1.2);
			//m_filters = [UtilFilter.createGrayFilter(), filter1, filter2];
			list.push(filter1);
			list.push(filter2);
			if(this.customData.flash9Renderer)
			{
				(this.customData.flash9Renderer as fFlash9SceneObjectSeqRenderer).filters=list;
			}
			
			if (gkcontext.m_sanguozhanchangMgr.inZhanchang)
			{
				if (m_zhenying != gkcontext.m_sanguozhanchangMgr.zhenying)
				{
					m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_Attack);
				}
			}
		}
		
		override public function onMouseLeave():void
		{		
			var list:Array = new Array();
			if (m_greyFilter)
			{
				list.push(m_greyFilter);
			}
			if(this.customData.flash9Renderer)
			{
				(this.customData.flash9Renderer as fFlash9SceneObjectSeqRenderer).filters=list;
			}
			m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_General);
		}
		public function set corpsName(str:String):void
		{
			m_corpsName = str;
			m_headTopBlockBase.invalidate();
		}
		
		public function onClick():void
		{
			var hero:PlayerMain = this.gkcontext.m_playerManager.hero as PlayerMain;
			if (hero == null)
			{
				return;
			}
			if (mathUtils.distance(this.x, this.y, hero.x, hero.y) <= DISTANCE_VISIT)
			{
				execFunction();
			}
			else
			{
				hero.toSceneObject(this);
			}
		}
		public function execFunction():void
		{
			var stAttackCmd:stAttackUserCmd = new stAttackUserCmd();
			stAttackCmd.byAttTempID = gkcontext.playerMain.tempid;
			stAttackCmd.byDefTempID = this.tempid;
			stAttackCmd.attackType = CommonEn.ATTACKTYPE_U2U;
			gkcontext.sendMsg(stAttackCmd);
		}
		public function get hasCorps():Boolean
		{
			return m_corpsName && m_corpsName.length > 0;
		}
		
		public function onPlayerMainArrive():void
		{
			var hero:PlayerMain = this.gkcontext.m_playerManager.hero as PlayerMain;
			if (hero == null)
			{
				return;
			}
			
			if (mathUtils.distance(this.x, this.y, hero.x, hero.y) <= DISTANCE_VISIT + 10)
			{
				execFunction();
			}
		}
		public function get posX():Number
		{
			return x;
		}
		public function get posY():Number
		{
			return y;
		}
	}

}