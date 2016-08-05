package com.gamecursor 
{		
	import common.Context;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
		
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class GameCursor extends EventDispatcher 
	{
		public static const RELEASE_EVENT:String = "CURSOR_RELEASE_EVENT";
		//静态鼠标状态
		public static const STATICSTATE_General:int = 0;
		public static const STATICSTATE_Attack:int = 1;		//鼠标指向可被攻击的怪或人
		//public static const STATICSTATE_VisitNpc:int = 2;		//鼠标指向可被访问的NPC
		public static const STATICSTATE_Pickup:int = 2;		//拾取地上物
		public static const STATICSTATE_bet:int = 3;		//赌博中下注
		public static const STATICSTATE_hand:int = 4;		//手型
		public static const STATICSTATE_Talk:int = 5;		//对话
		public static const STATICSTATE_NUM:int = 6;		//数量
		
		//命令鼠标状态
		public static const CMDSTATE_None:int = -1;
		public static const CMDSTATE_DragItem:int = 0;	//鼠标拿起道具
		public static const CMDSTATE_ChaifenItem:int = 1;	//拆分道具
		public static const CMDSTATE_Sale:int = 2;		//售出
		public static const CMDSTATE_NUM:int = 3;		//数量
		
		private var m_iCmdState:int;
		private var m_iStaticState:int;
		private var m_onCmdRelease:Function;
		private var m_callbackOnMouseUp:Function;
		
		private var m_vecCmdCursorData:Vector.<CursorDataDef>;
		private var m_vecStaticCurData:Vector.<CursorDataDef>;
		private var m_context:Context;
		private var m_staticObject:Object;	//记录设置静态鼠标状态的对象
		
		public function GameCursor(con:Context) 
		{
			m_context = con;
			m_iCmdState = CMDSTATE_None;
			m_iStaticState = STATICSTATE_General;
			init();
		}
		protected function init():void
		{
			m_vecStaticCurData = new Vector.<CursorDataDef>(STATICSTATE_NUM);
			m_vecStaticCurData[STATICSTATE_General] = new CursorDataDef("auto", null, true);
			m_vecStaticCurData[STATICSTATE_Attack] = new CursorDataDef("attack", "attack", false);
			//m_vecStaticCurData[STATICSTATE_VisitNpc] = new CursorDataDef("visit", null, false);
			m_vecStaticCurData[STATICSTATE_Pickup] = new CursorDataDef("hand", null, true);
			m_vecStaticCurData[STATICSTATE_bet] = new CursorDataDef("bet", "bet", false);
			m_vecStaticCurData[STATICSTATE_hand] = new CursorDataDef("hand", "hand", false);
			m_vecStaticCurData[STATICSTATE_Talk] = new CursorDataDef("talk", "talk", false);
			
			m_vecCmdCursorData = new Vector.<CursorDataDef>(CMDSTATE_NUM);
			m_vecCmdCursorData[CMDSTATE_DragItem] = new CursorDataDef("auto", null, true);			
			m_vecCmdCursorData[CMDSTATE_ChaifenItem] = new CursorDataDef("separate", "separate", false);
			m_vecCmdCursorData[CMDSTATE_Sale] = new CursorDataDef("sale", "sale", false);
		}
		
		public function setCmdState(state:int, onRelease:Function = null, callbackOnMouseUp:Function = null):void
		{
			if (m_iCmdState != CMDSTATE_None || state == CMDSTATE_None)
			{
				return;
			}
			m_iCmdState = state;
			m_onCmdRelease = onRelease;
			if (m_onCmdRelease != null)
			{
				this.addEventListener(RELEASE_EVENT, m_onCmdRelease);
			}
			m_callbackOnMouseUp = callbackOnMouseUp
			if (m_callbackOnMouseUp != null)
			{
				m_context.m_mainStage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			
			
			var name:String = getCmdCursorName(state);
			if (name == null)
			{
				return;
			}
			if (Mouse.cursor != name)
			{
				Mouse.cursor = name;
			}
		}
		
		public function releaseCmdState(state:int):void
		{
			if (m_iCmdState == state)
			{
				m_iCmdState = CMDSTATE_None;
				this.dispatchEvent(new Event(RELEASE_EVENT));
				
				if (m_onCmdRelease != null)
				{
					this.removeEventListener(RELEASE_EVENT, m_onCmdRelease);
				}
				
				if (m_callbackOnMouseUp != null)
				{
					m_callbackOnMouseUp = null;
					m_context.m_mainStage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
				var name:String = getStaticCursorName(m_iStaticState);
				if (Mouse.cursor != name)
				{
					Mouse.cursor = name;
				}
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (m_callbackOnMouseUp != null)
			{
				m_callbackOnMouseUp(e, m_iCmdState);
			}
		}
		public function setStaticState(state:int, staticObject:Object = null):void
		{
			m_staticObject = staticObject;
			if (m_iStaticState == state)
			{ 
				return;
			}
			m_iStaticState = state;
			if (m_iCmdState == CMDSTATE_None)
			{
				var name:String = getStaticCursorName(m_iStaticState);
				if (name == null)
				{
					return;
				}
				if (Mouse.cursor != name)
				{
					Mouse.cursor = name;
				}
			}
			
		}
		protected function getCmdCursorName(state:int):String
		{
			var data:CursorDataDef = m_vecCmdCursorData[state];
			if (data.m_bRegistered)
			{
				return data.m_name;
			}
			loadCursor(data);
			return null;
		}
		
		protected function getStaticCursorName(state:int):String
		{
			var data:CursorDataDef = m_vecStaticCurData[state];
			if (data.m_bRegistered)
			{
				return data.m_name;
			}
			loadCursor(data);
			return null;			
		}
		
		protected function loadCursor(data:CursorDataDef):void
		{
			data.loadCursor(m_context,data, onloaded);
		}	
		
		public function onloaded(data:CursorDataDef):void
		{
			var name:String;
			if (m_iCmdState != CMDSTATE_None)
			{
				name = m_vecCmdCursorData[m_iCmdState].m_name;
			}
			else
			{
				name = m_vecStaticCurData[m_iStaticState].m_name
			}
			
			if (data.m_name == name)
			{
				Mouse.cursor = name;				
			}
		}
		
		public function get cmdState():int
		{
			return m_iCmdState;
		}
		public function get staticObject():Object
		{
			return m_staticObject;
		}
	}

}