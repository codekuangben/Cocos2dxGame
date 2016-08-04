package com.pblabs.engine.core
{
	import com.pblabs.engine.entity.EntityCValue;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import common.Context;

    /**
     * The input manager wraps the default input events produced by Flash to make
     * them more game friendly. For instance, by default, Flash will dispatch a
     * key down event when a key is pressed, and at a consistent interval while it
     * is still held down. For games, this is not very useful.
     *
     * <p>The InputMap class contains several constants that represent the keyboard
     * and mouse. It can also be used to facilitate responding to specific key events
     * (OnSpacePressed) rather than generic key events (OnKeyDown).</p>
     *
     * @see InputMap
     */
    public class InputManager extends EventDispatcher implements ITickedObject, IInputManager
    {
        public function InputManager(context:Context)
        {
			m_context = context
			// UI 事件自己处理，这个只管场景事件处理   
			
			m_context.mainStage.addEventListener(Event.DEACTIVATE, flash_lose_focus);
			m_context.mainStage.addEventListener(Event.ACTIVATE, flash_has_focus);

            m_context.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            m_context.mainStage.addEventListener(KeyboardEvent.KEY_UP,   onKeyUp);
			
            //m_context.mainStage.addEventListener(MouseEvent.MOUSE_DOWN,  onMouseDown);
            //m_context.mainStage.addEventListener(MouseEvent.MOUSE_UP,    onMouseUp);
            //m_context.mainStage.addEventListener(MouseEvent.MOUSE_MOVE,  onMouseMove);
            //m_context.mainStage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
            //m_context.mainStage.addEventListener(MouseEvent.MOUSE_OVER,  onMouseOver);
            //m_context.mainStage.addEventListener(MouseEvent.MOUSE_OUT,   onMouseOut);
			
			//m_context.getLay(Context.TLayScene).addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            //m_context.getLay(Context.TLayScene).addEventListener(KeyboardEvent.KEY_UP,   onKeyUp);
            m_context.getLay(Context.TLayScene).addEventListener(MouseEvent.MOUSE_DOWN,  onMouseDown);	// 鼠标按钮按下
            m_context.getLay(Context.TLayScene).addEventListener(MouseEvent.MOUSE_UP,    onMouseUp);	// 鼠标按钮弹出
			m_context.getLay(Context.TLayScene).addEventListener(MouseEvent.CLICK,    onMouseClick);		// 鼠标点击，注意这个在上面两个事件触发完成后调用
            m_context.getLay(Context.TLayScene).addEventListener(MouseEvent.MOUSE_MOVE,  onMouseMove);
            m_context.getLay(Context.TLayScene).addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
            m_context.getLay(Context.TLayScene).addEventListener(MouseEvent.ROLL_OVER,  onMouseOver);
            m_context.getLay(Context.TLayScene).addEventListener(MouseEvent.ROLL_OUT,   onMouseOut);			
            
            // Add ourselves with the highest priority, so that our update happens at the beginning of the next tick.
            // This will keep objects processing afterwards as up-to-date as possible when using keyJustPressed() or keyJustReleased()
            m_context.m_processManager.addTickedObject( this, EntityCValue.PriorityUI );
        }
        
        /**
         * @inheritDoc
         */
        public function onTick(deltaTime:Number):void
        {
            // This function tracks which keys were just pressed (or released) within the last tick.
            // It should be called at the beginning of the tick to give the most accurate responses possible.
            
            var cnt:int;
            
            for (cnt = 0; cnt < _keyState.length; cnt++)
            {
                if (_keyState[cnt] && !_keyStateOld[cnt])
                    _justPressed[cnt] = true;
                else
                    _justPressed[cnt] = false;
                
                if (!_keyState[cnt] && _keyStateOld[cnt])
                    _justReleased[cnt] = true;
                else
                    _justReleased[cnt] = false;
                
                _keyStateOld[cnt] = _keyState[cnt];
            }
        }
        
		//flash_has_focus失去焦点事件
		protected function flash_lose_focus(e:Event):void {
			trace("失去焦点");
			onLoseFocus();
			if (m_context.m_gkcontext)
			{
				m_context.m_gkcontext.onLoseFocus();
			}
		}
		
		//flash_has_focus获得焦点事件
		protected function flash_has_focus(e:Event):void {
			// 获取焦点后强制重新绘制一次
			m_context.mainStage.invalidate();
			trace("获得焦点");
			if (m_context.m_gkcontext)
			{
				m_context.m_gkcontext.onHasFocus();
			}
		} 
		
		public function onLoseFocus():void
		{
			 var cnt:int;
			for (cnt = 0; cnt < _keyState.length; cnt++)
			{
				if (_keyState[cnt])
				{
					_keyState[cnt] = false;
				}
			}
		}
        /**
         * Returns whether or not a key was pressed since the last tick.
         */
        public function keyJustPressed(keyCode:int):Boolean
        {
            return _justPressed[keyCode];
        }
        
		
		
        /**
         * Returns whether or not a key was released since the last tick.
         */
        public function keyJustReleased(keyCode:int):Boolean
        {
            return _justReleased[keyCode];
        }

        /**
         * Returns whether or not a specific key is down.
         */
        public function isKeyDown(keyCode:int):Boolean
        {
            return _keyState[keyCode];
        }
        
        /**
         * Returns true if any key is down.
         */
        public function isAnyKeyDown():Boolean
        {
            for each(var b:Boolean in _keyState)
                if(b)
                    return true;
            return false;
        }

        /**
         * Simulates a key press. The key will remain 'down' until SimulateKeyUp is called
         * with the same keyCode.
         *
         * @param keyCode The key to simulate. This should be one of the constants defined in
         * InputMap
         *
         * @see InputMap
         */
        public function simulateKeyDown(keyCode:int):void
        {
            dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, keyCode));
            _keyState[keyCode] = true;
        }

        /**
         * Simulates a key release.
         *
         * @param keyCode The key to simulate. This should be one of the constants defined in
         * InputMap
         *
         * @see InputMap
         */
        public function simulateKeyUp(keyCode:int):void
        {
            dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 0, keyCode));
            _keyState[keyCode] = false;
        }

        /**
         * Simulates clicking the mouse button.
         */
        public function simulateMouseDown():void
        {
            dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
        }

        /**
         * Simulates releasing the mouse button.
         */
        public function simulateMouseUp():void
        {
            dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
        }

        /**
         * Simulates moving the mouse button. All this does is dispatch a mouse
         * move event since there is no way to change the current cursor position
         * of the mouse.
         */
        public function simulateMouseMove():void
        {
            dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, true, false, Math.random() * 100, Math.random () * 100));
        }

        public function simulateMouseOver():void
        {
            dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
        }

        public function simulateMouseOut():void
        {
            dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
        }

        public function simulateMouseWheel():void
        {
            dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL));
        }

        private function onKeyDown(event:KeyboardEvent):void
        {			
			// 如果有输入焦点，就说明上层 UI 在处理输入事件    
			if (this.m_context.mainStage.focus is TextField && event.keyCode != InputKey.SHIFT.keyCode)
				return;
            if (_keyState[event.keyCode])
                return;

            _keyState[event.keyCode] = true;
            dispatchEvent(event);
        }

        private function onKeyUp(event:KeyboardEvent):void
        {			
			// 如果有输入焦点，就说明上层 UI 在处理输入事件    
			if (this.m_context.mainStage.focus is TextField && event.keyCode != InputKey.SHIFT.keyCode)
				return;

            _keyState[event.keyCode] = false;
            dispatchEvent(event);			
        }

        private function onMouseDown(event:MouseEvent):void
        {
            dispatchEvent(event);
			//event.stopPropagation();	// 不要传递到 stage 上面， UI 在 stage 上面监听一些事件
        }

        private function onMouseUp(event:MouseEvent):void
        {
            dispatchEvent(event);
			//event.stopPropagation();	// 不要传递到 stage 上面， UI 在 stage 上面监听一些事件
        }
		
		private function onMouseClick(event:MouseEvent):void
		{
			dispatchEvent(event);
		}

        private function onMouseMove(event:MouseEvent):void
        {
            dispatchEvent(event);
			//event.stopPropagation();	// 不要传递到 stage 上面， UI 在 stage 上面监听一些事件
        }

        private function onMouseOver(event:MouseEvent):void
        {			
            dispatchEvent(event);
			//event.stopPropagation();	// 不要传递到 stage 上面， UI 在 stage 上面监听一些事件
        }
		
        private function onMouseOut(event:MouseEvent):void
        {			
            dispatchEvent(event);
			//event.stopPropagation();	// 不要传递到 stage 上面， UI 在 stage 上面监听一些事件
        }

        private function onMouseWheel(event:MouseEvent):void
        {
            dispatchEvent(event);
			//event.stopPropagation();	// 不要传递到 stage 上面， UI 在 stage 上面监听一些事件
        }

        private var _keyState:Array = new Array();     // The most recent information on key states
        private var _keyStateOld:Array = new Array();  // The state of the keys on the previous tick
        private var _justPressed:Array = new Array();  // An array of keys that were just pressed within the last tick.
        private var _justReleased:Array = new Array(); // An array of keys that were just released within the last tick.
		protected var m_context:Context;
    }
}

