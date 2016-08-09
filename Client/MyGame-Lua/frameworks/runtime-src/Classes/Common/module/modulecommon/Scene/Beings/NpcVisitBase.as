package modulecommon.scene.beings 
{
	/**
	 * ...
	 * @author 
	 * 
	 */
	import flash.display.Sprite;
	import modulecommon.headtop.HeadTopBlockBase;
	import modulecommon.logicinterface.IVisitSceneObject;
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.utils.mathUtils;
	import com.gamecursor.GameCursor;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	
	public class NpcVisitBase extends Npc  implements IVisitSceneObject
	{
		public static const DISTANCE_VISIT:uint = 80;
		public static const DISTANCE_GOTOVISIT:uint = 70;
		
		protected var m_headTopBlockBase:HeadTopBlockBase;
		public function NpcVisitBase(defObj:XML, scene:fScene) 
		{
			super(defObj, scene);
		}
		public function onClick():void
		{
			var hero:PlayerMain = this.gkcontext.m_playerManager.hero as PlayerMain;
			if (hero == null)
			{
				return;
			}
			if (!hero.cancleAutoWalk())
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
			
		}
		override public function dispose():void 
		{
			if (m_context && m_context.m_gameCursor.staticObject == this)
			{
				m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_General);
			}
			m_headTopBlockBase.dispose();
			super.dispose();
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
		
		override public function onMouseEnter():void
		{
			if (canAttacked)
			{
				m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_Attack,this);
			}
			if(this.customData.flash9Renderer)
			{
				(this.customData.flash9Renderer as fFlash9ElementRenderer).onMouseEnter();
			}
		}
		
		override public function onMouseLeave():void
		{
			m_context.m_gameCursor.setStaticState(GameCursor.STATICSTATE_General);
			if(this.customData.flash9Renderer)
			{
				(this.customData.flash9Renderer as fFlash9ElementRenderer).onMouseLeave();
			}
		}
		
		//实现IVisitSceneObject接口函数
		public function get posX():Number
		{
			return x;
		}
		public function get posY():Number
		{
			return y;
		}
		override public function updateNameDesc():void
		{
			m_headTopBlockBase.invalidate();
		}
		override public function onCreateAssets():void 
		{			
			var base:Sprite = this.uiLayObj;
			m_headTopBlockBase.addToDisplayList(base);		
			if (m_tagBounds2d.height <= 1)
			{
				m_headTopBlockBase.visible = false;				
			}
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
	}

}