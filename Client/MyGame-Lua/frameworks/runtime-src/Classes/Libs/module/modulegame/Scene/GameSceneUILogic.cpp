package game.scene
{	
	import com.gamecursor.GameCursor;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.logicinterface.ISceneUIHandle;
	import modulecommon.logicinterface.ISceneUILogic;
	import org.ffilmation.engine.core.fRenderableElement;
	import org.ffilmation.engine.datatypes.fPoint3d;
	/**
	 * ...
	 * @author
	 * @brief 场景逻辑处理
	 */
	public class GameSceneUILogic implements ISceneUILogic
	{
		public var m_gkcontext:GkContext;
		protected var m_elementUnderMouse:fRenderableElement;
		protected var m_mouseDispach:Sprite;		// 事件分发
		protected var m_ISceneUIHandle:ISceneUIHandle;		// 发生事件处理
		
		public function GameSceneUILogic(value:GkContext)
		{
			m_gkcontext = value;
		}
		
		// 设置处理句柄
		public function addHandle(dispatch:Sprite, handle:ISceneUIHandle):void
		{
			m_mouseDispach = dispatch;
			m_ISceneUIHandle = handle;
			this.m_mouseDispach.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			this.m_mouseDispach.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.m_mouseDispach.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		// 移除处理句柄
		public function removeHandle():void
		{
			// 释放的时候，如果 addHandle 没有调用，就会导致 m_mouseDispach 为空，因为 addHandle 是在资源加载完成后调用的，有可能资源没有加载完成就退出了
			if (this.m_mouseDispach)
			{
				this.m_mouseDispach.removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
				this.m_mouseDispach.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this.m_mouseDispach.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				this.m_mouseDispach = null;
			}
		}
		
		// KBEN: 点击场景处理        
		public function onClick(evt:MouseEvent):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_gkcontext.m_context.m_sceneView.isLoading)
			{
				return;
			}
			if (m_gkcontext.m_context.m_gameCursor.cmdState == GameCursor.CMDSTATE_DragItem)
			{
				return;
			}
			
			var globalx:Number = this.m_gkcontext.m_context.mainStage.mouseX;
			var globaly:Number = this.m_gkcontext.m_context.mainStage.mouseY;
			var ret:Array = this.m_gkcontext.m_context.m_uiObjMgr.getSceneUILstUnderMouse(globalx, globaly);
			
			if (ret)
			{
				m_ISceneUIHandle.onClick(evt, ret);
			}
		}
		
		public function onMouseMove(evt:MouseEvent):void
		{
			// KBEN:创景加载完毕才能进入循环 
			if (m_gkcontext.m_context.m_sceneView.isLoading)
			{
				return;
			}

			var globalx:Number = this.m_gkcontext.m_context.mainStage.mouseX;
			var globaly:Number = this.m_gkcontext.m_context.mainStage.mouseY;
			var ret:Array = this.m_gkcontext.m_context.m_uiObjMgr.getSceneUILstUnderMouse(globalx, globaly);
			
			var curEle:fRenderableElement;
			if (ret && ret.length > 0)
			{
				curEle = ret[0];
			}
			
			if (m_elementUnderMouse && m_elementUnderMouse.isDisposed)
			{
				m_elementUnderMouse = null;
			}
			if (curEle != m_elementUnderMouse)
			{
				if (m_elementUnderMouse != null)
				{
					m_elementUnderMouse.onMouseLeave();
					m_ISceneUIHandle.onMouseLeave(evt);
				}
				
				m_elementUnderMouse = curEle;
				if (m_elementUnderMouse != null)
				{
					m_elementUnderMouse.onMouseEnter();
					m_ISceneUIHandle.onMouseEnter(evt, ret);
				}
			}
		}
		
		public function onMouseOut(evt:MouseEvent):void
		{	
			if (m_elementUnderMouse && m_elementUnderMouse.isDisposed)
			{
				m_elementUnderMouse = null;
			}
			
			if (m_elementUnderMouse != null)
			{
				m_elementUnderMouse.onMouseLeave();
				m_elementUnderMouse = null;
				m_ISceneUIHandle.onMouseLeave(evt);
			}
		}
		
		// 释放元素,主要是用来释放当前鼠标下面的对象
		public function disposeElement(element:fRenderableElement):void
		{
			if (m_elementUnderMouse == element)
			{
				m_elementUnderMouse = null;
			}
		}
	}
}