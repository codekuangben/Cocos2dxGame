package com.pblabs.engine.core
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.serialization.TypeUtility;
	import com.util.DebugBox;
	
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import common.Context;
	
	/**
	 * The process manager manages all time related functionality in the engine.
	 * It provides mechanisms for performing actions every frame, every tick, or
	 * at a specific time in the future.
	 *
	 * <p>A tick happens at a set interval defined by the TICKS_PER_SECOND constant.
	 * Using ticks for various tasks that need to happen repeatedly instead of
	 * performing those tasks every frame results in much more consistent output.
	 * However, for animation related tasks, frame events should be used so the
	 * display remains smooth.</p>
	 *
	 * @see ITickedObject
	 * @see IAnimatedObject
	 */
	public class ProcessManager implements IProcessManager
	{
		/**
		 * If true, disables warnings about losing ticks.
		 */
		public static var disableSlowWarning:Boolean = true;
		
		/**
		 * The number of ticks that will happen every second.
		 */
		public static const TICKS_PER_SECOND:int = 30;
		
		/**
		 * The rate at which ticks are fired, in seconds.
		 */
		public static const TICK_RATE:Number = 1.0 / Number(TICKS_PER_SECOND);
		
		/**
		 * The rate at which ticks are fired, in milliseconds.
		 */
		public static const TICK_RATE_MS:Number = TICK_RATE * 1000;
		
		// 连续运行模式
		public static const ModeContinue:uint = 0;
				// 单步运行模式
		public static const ModeStep:uint = 1;
		
		/**
		 * The maximum number of ticks that can be processed in a frame.
		 *
		 * <p>In some cases, a single frame can take an extremely long amount of
		 * time. If several ticks then need to be processed, a game can
		 * quickly get in a state where it has so many ticks to process
		 * it can never catch up. This is known as a death spiral.</p>
		 *
		 * <p>To prevent this we have a safety limit. Time is dropped so the
		 * system can catch up in extraordinary cases. If your game is just
		 * slow, then you will see that the ProcessManager can never catch up
		 * and you will constantly get the "too many ticks per frame" warning,
		 * if you have disableSlowWarning set to false.</p>
		 */
		public static const MAX_TICKS_PER_FRAME:int = 5;
		
		protected var m_context:Context;
		
		public function ProcessManager(context:Context)
		{
			m_context = context;
		}
		
		/**
		 * The scale at which time advances. If this is set to 2, the game
		 * will play twice as fast. A value of 0.5 will run the
		 * game at half speed. A value of 1 is normal.
		 */
		public function get timeScale():Number
		{
			return _timeScale;
		}
		
		/**
		 * @private
		 */
		public function set timeScale(value:Number):void
		{
			_timeScale = value;
		}
		
		/**
		 * TweenMax uses timeScale as a config property, so by also having a
		 * capitalized version, we can tween TimeScale instead and get along
		 * just fine.
		 */
		public function set TimeScale(value:Number):void
		{
			timeScale = value;
		}
		
		/**
		 * @private
		 */
		public function get TimeScale():Number
		{
			return timeScale;
		}
		
		/**
		 * Used to determine how far we are between ticks. 0.0 at the start of a tick, and
		 * 1.0 at the end. Useful for smoothly interpolating visual elements.
		 */
		public function get interpolationFactor():Number
		{
			return _interpolationFactor;
		}
		
		/**
		 * The amount of time that has been processed by the process manager. This does
		 * take the time scale into account. Time is in milliseconds.
		 */
		public function get virtualTime():Number
		{
			return _virtualTime;
		}
		
		/**
		 * Current time reported by getTimer(), updated every frame. Use this to avoid
		 * costly calls to getTimer(), or if you want a unique number representing the
		 * current frame.
		 */
		public function get platformTime():Number
		{
			return _platformTime;
		}
		
		public function get runMode():uint
		{
			return m_runMode;
		}
		
		public function set runMode(value:uint):void
		{
			m_runMode = value;
		}
		
		public function get internalTime():Number
		{
			return m_internalTime;
		}
		
		public function set internalTime(value:Number):void
		{
			m_internalTime = value;
		}
		
		/**
		 * Starts the process manager. This is automatically called when the first object
		 * is added to the process manager. If the manager is stopped manually, then this
		 * will have to be called to restart it.
		 */
		public function start():void
		{
			if (started)
			{
				Logger.warn(this, "start", "The ProcessManager is already started.");
				return;
			}
			
			lastTime = getTimer();
			elapsed = 0.0;
			lastTime1Sec = lastTime;
			lastTime1Minute = lastTime;
			lastTime10Minute = lastTime;
			m_context.mainStage.addEventListener(Event.ENTER_FRAME, onFrame);
			m_context.mainStage.addEventListener(Event.RESIZE, onResize);
			started = true;
		}
		
		/**
		 * Stops the process manager. This is automatically called when the last object
		 * is removed from the process manager, but can also be called manually to, for
		 * example, pause the game.
		 */
		public function stop():void
		{
			if (!started)
			{
				Logger.warn(this, "stop", "The ProcessManager isn't started.");
				return;
			}
			
			started = false;
			m_context.mainStage.removeEventListener(Event.ENTER_FRAME, onFrame);
			m_context.mainStage.removeEventListener(Event.RESIZE, onResize);
		}
		
		/**
		 * Returns true if the process manager is advancing.
		 */
		public function get isTicking():Boolean
		{
			return started;
		}
		
		/**
		 * Schedules a function to be called at a specified time in the future.
		 *
		 * @param delay The number of milliseconds in the future to call the function.
		 * @param thisObject The object on which the function should be called. This
		 * becomes the 'this' variable in the function.
		 * @param callback The function to call.
		 * @param arguments The arguments to pass to the function when it is called.
		 */
		public function schedule(delay:Number, thisObject:Object, callback:Function, ... arguments):void
		{
			if (!started)
				start();
			
			var schedule:ScheduleObject = new ScheduleObject();
			schedule.dueTime = _virtualTime + delay;
			schedule.thisObject = thisObject;
			schedule.callback = callback;
			schedule.arguments = arguments;
			
			thinkHeap.enqueue(schedule);
		}
		
		/**
		 * Registers an object to receive tick callbacks.
		 *
		 * @param object The object to add.
		 * @param priority The priority of the object. Objects added with higher priorities
		 * will receive their callback before objects with lower priorities. The highest
		 * (first-processed) priority is Number.MAX_VALUE. The lowest (last-processed)
		 * priority is -Number.MAX_VALUE.
		 */
		public function addTickedObject(object:ITickedObject, priority:Number = 0.0):void
		{
			addObject(object, priority, tickedObjects);
		}
		
		/**
		 * Queue an IQueuedObject for callback. This is a very cheap way to have a callback
		 * happen on an object. If an object is queued when it is already in the queue, it
		 * is removed, then added.
		 */
		public function queueObject(object:IQueuedObject):void
		{
			// Assert if this is in the past.
			if (object.nextThinkTime < _virtualTime)
				throw new Error("Tried to queue something into the past, but no flux capacitor is present!");
			
			//Profiler.enter("queueObject");
			if (m_context.m_profiler)
				m_context.m_profiler.enter("queueObject");
			
			if (object.nextThinkTime >= _virtualTime && thinkHeap.contains(object))
				thinkHeap.remove(object);
			
			thinkHeap.enqueue(object);
			
			//Profiler.exit("queueObject");
			if (m_context.m_profiler)
				m_context.m_profiler.exit("queueObject");
		}
		
		/**
		 * Unregisters an object from receiving tick callbacks.
		 *
		 * @param object The object to remove.
		 */
		public function removeTickedObject(object:ITickedObject):void
		{
			removeObject(object, tickedObjects);
		}
		
		/**
		 * Forces the process manager to advance by the specified amount. This should
		 * only be used for unit testing.
		 *
		 * @param amount The amount of time to simulate.
		 */
		public function testAdvance(amount:Number):void
		{
			advance(amount * _timeScale, true);
		}
		
		/**
		 * Forces the process manager to seek its virtualTime by the specified amount.
		 * This moves virtualTime without calling advance and without processing ticks or frames.
		 * WARNING: USE WITH CAUTION AND ONLY IF YOU REALLY KNOW THE CONSEQUENCES!
		 */
		public function seek(amount:Number):void
		{
			_virtualTime += amount;
		}
		
		/**
		 * Deferred function callback - called back at start of processing for next frame. Useful
		 * any time you are going to do setTimeout(someFunc, 1) - it's a lot cheaper to do it
		 * this way.
		 * @param method Function to call.
		 * @param args Any arguments.
		 */
		public function callLater(method:Function, args:Array = null):void
		{
			var dm:DeferredMethod = new DeferredMethod();
			dm.method = method;
			dm.args = args;
			deferredMethodQueue.push(dm);
		}
		
		/**
		 * @return How many objects are depending on the ProcessManager right now?
		 */
		private function get listenerCount():int
		{
			return tickedObjects.length + animatedObjects.length;
		}
		
		/**
		 * Internal function add an object to a list with a given priority.
		 * @param object Object to add.
		 * @param priority Priority; this is used to keep the list ordered.
		 * @param list List to add to.
		 */
		private function addObject(object:*, priority:Number, list:Array):void
		{
			// If we are in a tick, defer the add.
			if (duringAdvance)
			{
				callLater(addObject, [object, priority, list]);
				return;
			}
			
			if (!started)
				start();
			
			var position:int = -1;
			for (var i:int = 0; i < list.length; i++)
			{
				if (!list[i])
					continue;
				
				if (list[i].listener == object)
				{
					//Logger.warn(object, "AddProcessObject", "This object has already been added to the process manager.");
					return;
				}
				
				if (list[i].priority < priority)
				{
					position = i;
					break;
				}
			}
			
			var processObject:ProcessObject = new ProcessObject();
			processObject.listener = object;
			processObject.priority = priority;
			processObject.profilerKey = TypeUtility.getObjectClassName(object);
			
			if (position < 0 || position >= list.length)
				list.push(processObject);
			else
				list.splice(position, 0, processObject);
		}
		
		/**
		 * Peer to addObject; removes an object from a list.
		 * @param object Object to remove.
		 * @param list List from which to remove.
		 * @bug 如果加入到 calllater 这个列表里面去，如果要删除的正在 calllater 队列里面，就会删除不了，在下一帧会加入到里面
		 */
		private function removeObject(object:*, list:Array):void
		{
			if (listenerCount == 1 && thinkHeap.size == 0)
				stop();
			
			for (var i:int = 0; i < list.length; i++)
			{
				if (!list[i])
					continue;
				
				if (list[i].listener == object)
				{
					if (duringAdvance)
					{
						list[i] = null;
						needPurgeEmpty = true;
					}
					else
					{
						list.splice(i, 1);
					}
					
					return;
				}
			}
			
			Logger.warn(object, "RemoveProcessObject", "This object has not been added to the process manager.");
		}
		
		/**
		 * Main callback; this is called every frame and allows game logic to run.
		 * @ brief 如果最小化的时候，这个帧数会降下来，这个时候使用定时器模拟
		 */
		private function onFrame(event:Event = null):void
		{
			// This is called from a system event, so it had better be at the 
			// root of the profiler stack!
			//Profiler.ensureAtRoot();
			if (m_context.m_profiler)
				m_context.m_profiler.ensureAtRoot();
			
			//// Track current time.
			//_platformTime = getTimer();
			///*if (lastTime < 0)
			   //{
			   //lastTime = _platformTime;
			   //return;
			 //}*/
			//processScheduledObjects();
			//duringAdvance = true;
			//// Calculate time since last frame and advance that much.
			//var deltaTime:Number = (_platformTime - lastTime) * _timeScale;
			//advance(deltaTime);
			//
			//if (_platformTime - lastTime1Sec >= 1000)
			//{
				//if (m_timeUpdateObjects.length > 0)
				//{
					//on1SecondUpdate();
				//}
				//lastTime1Sec = _platformTime;
				//
				//if (_platformTime - lastTime1Minute >= 60000)
				//{
					//if (m_1MinuteUpdateObjects.length > 0)
					//{
						//on1MinuteUpdate();
					//}
					//lastTime1Minute = _platformTime;
					//
					////10分钟
					//if (_platformTime - lastTime10Minute >= 600000)
					//{
						//if (m_10MinuteUpdateObjects.length > 0)
						//{
							//on10MinuteUpdate();
						//}
						//lastTime10Minute = _platformTime;
					//}
				//}
			//}
			//
			//duringAdvance = false;
			//// Note new last time.
			//lastTime = _platformTime;
			
			if (m_runMode == ModeContinue)		// 连续运行模式才需要一直执行
			{
				nextFrameContinue();
			}
			//else	// 单步运行模式
			//{
			//	nextFrameStep();
			//}
		}
		
		// 下一帧, timefromstart 启动时间
		public function nextFrameContinue():void
		{
			// Track current time.
			_platformTime = getTimer();
			/*if (lastTime < 0)
			   {
			   lastTime = _platformTime;
			   return;
			 }*/
			processScheduledObjects();
			duringAdvance = true;
			// Calculate time since last frame and advance that much.
			//var deltaTime:Number = (_platformTime - lastTime) * _timeScale;
			m_deltaTime = (_platformTime - lastTime) * _timeScale;
			advance(m_deltaTime);
			
			if (_platformTime - lastTime1Sec >= 1000)
			{
				if (m_timeUpdateObjects.length > 0)
				{
					on1SecondUpdate();
				}
				lastTime1Sec = _platformTime;
				
				if (_platformTime - lastTime1Minute >= 60000)
				{
					if (m_1MinuteUpdateObjects.length > 0)
					{
						on1MinuteUpdate();
					}
					lastTime1Minute = _platformTime;
					
					//10分钟
					if (_platformTime - lastTime10Minute >= 600000)
					{
						if (m_10MinuteUpdateObjects.length > 0)
						{
							on10MinuteUpdate();
						}
						lastTime10Minute = _platformTime;
					}
				}
			}
			
			duringAdvance = false;
			
			if (m_bUseIdleTime && _platformTime >= 17000)
			{
				if (m_deltaTime < 30)
				{
					m_context.m_idleTimeProcessMgr.process();
				}
			}
			// Note new last time.
			lastTime = _platformTime;
		}
		
		public function nextFrameStep():void
		{
			// Track current time.
			_platformTime = getTimer();
			/*if (lastTime < 0)
			   {
			   lastTime = _platformTime;
			   return;
			 }*/
			processScheduledObjects();
			duringAdvance = true;
			// Calculate time since last frame and advance that much.
			//var deltaTime:Number = (_platformTime - lastTime) * _timeScale;
			m_deltaTime = m_internalTime * _timeScale;
			advance(m_deltaTime);
			
			if (_platformTime - lastTime1Sec >= 1000)
			{
				if (m_timeUpdateObjects.length > 0)
				{
					on1SecondUpdate();
				}
				lastTime1Sec = _platformTime;
				
				if (_platformTime - lastTime1Minute >= 60000)
				{
					if (m_1MinuteUpdateObjects.length > 0)
					{
						on1MinuteUpdate();
					}
					lastTime1Minute = _platformTime;
					
					//10分钟
					if (_platformTime - lastTime10Minute >= 600000)
					{
						if (m_10MinuteUpdateObjects.length > 0)
						{
							on10MinuteUpdate();
						}
						lastTime10Minute = _platformTime;
					}
				}
			}
			
			duringAdvance = false;
			// Note new last time.
			lastTime = _platformTime;
		}
		
		private function advance(deltaTime:Number, suppressSafety:Boolean = false):void
		{
			// Update platform time, to avoid lots of costly calls to getTimer.
			//_platformTime = getTimer();
			
			// Note virtual time we started advancing from.
			var startTime:Number = _virtualTime;
			
			/*
			   // Add time to the accumulator.
			   elapsed += deltaTime;
			
			   // Perform ticks, respecting tick caps.
			   var tickCount:int = 0;
			   while (elapsed >= TICK_RATE_MS && (suppressSafety || tickCount < MAX_TICKS_PER_FRAME))
			   {
			   // Ticks always happen on interpolation boundary.
			   _interpolationFactor = 0.0;
			
			   // Process pending events at this tick.
			   // This is done in the loop to ensure the correct order of events.
			   processScheduledObjects();
			
			   // Do the onTick callbacks, noting time in profiler appropriately.
			   //Profiler.enter("Tick");
			   if(m_context.m_profiler)
			   m_context.m_profiler.enter("Tick");
			
			   duringAdvance = true;
			   for(var j:int=0; j<tickedObjects.length; j++)
			   {
			   var object:ProcessObject = tickedObjects[j] as ProcessObject;
			   if(!object)
			   continue;
			
			   //Profiler.enter(object.profilerKey);
			   if (m_context.m_profiler)
			   m_context.m_profiler.enter(object.profilerKey);
			   (object.listener as ITickedObject).onTick(TICK_RATE);
			   //Profiler.exit(object.profilerKey);
			   if (m_context.m_profiler)
			   m_context.m_profiler.exit(object.profilerKey);
			   }
			   duringAdvance = false;
			
			   //Profiler.exit("Tick");
			   if(m_context.m_profiler)
			   m_context.m_profiler.exit("Tick");
			
			   // Update virtual time by subtracting from accumulator.
			   _virtualTime += TICK_RATE_MS;
			   elapsed -= TICK_RATE_MS;
			   tickCount++;
			   }
			
			   // Safety net - don't do more than a few ticks per frame to avoid death spirals.
			   if (tickCount >= MAX_TICKS_PER_FRAME && !suppressSafety && !disableSlowWarning)
			   {
			   // By default, only show when profiling.
			   Logger.warn(this, "advance", "Exceeded maximum number of ticks for frame (" + elapsed.toFixed() + "ms dropped) .");
			   elapsed = 0;
			   }
			
			   // Make sure that we don't fall behind too far. This helps correct
			   // for short-term drops in framerate as well as the scenario where
			   // we are consistently running behind.
			   elapsed = PBUtil.clamp(elapsed, 0, 300);
			 */
			
			// Make sure we don't lose time to accumulation error.
			// Not sure this gains us anything, so disabling -- BJG
			//_virtualTime = startTime + deltaTime;
			
			// We process scheduled items again after tick processing to ensure between-tick schedules are hit
			// Commenting this out because it can cause too-often calling of callLater methods. -- BJG
			// processScheduledObjects();
			
			// Update objects wanting OnFrame callbacks.
			// 动画更新换成这个，换成这个
			//Profiler.enter("frame");
			
			if (m_context.m_profiler)
				m_context.m_profiler.enter("Tick");
			
			//_interpolationFactor = elapsed / TICK_RATE_MS;
			for (var j:int = 0; j < tickedObjects.length; j++)
			{
				var object:ProcessObject = tickedObjects[j] as ProcessObject;
				if (!object)
					continue;
				
				//Profiler.enter(object.profilerKey);
				if (m_context.m_profiler)
					m_context.m_profiler.enter(object.profilerKey);
				(object.listener as ITickedObject).onTick(deltaTime / 1000);
				//Profiler.exit(object.profilerKey);
				if (m_context.m_profiler)
					m_context.m_profiler.exit(object.profilerKey);
			}
			
			//Profiler.exit("frame");
			if (m_context.m_profiler)
				m_context.m_profiler.exit("Tick");
			
			// Purge the lists if needed.
			if (needPurgeEmpty)
			{
				needPurgeEmpty = false;
				
				//Profiler.enter("purgeEmpty");
				if (m_context.m_profiler)
					m_context.m_profiler.enter("purgeEmpty");
				
				for (j = 0; j < animatedObjects.length; j++)
				{
					if (animatedObjects[j])
						continue;
					
					animatedObjects.splice(j, 1);
					j--;
				}
				
				for (var k:int = 0; k < tickedObjects.length; k++)
				{
					if (tickedObjects[k])
						continue;
					
					tickedObjects.splice(k, 1);
					k--;
				}
				
				//Profiler.exit("purgeEmpty");
				if (m_context.m_profiler)
					m_context.m_profiler.exit("purgeEmpty");
			}
			
			// 一帧结束更新深度排序
			var frameobj:IFrameStage;
			for each (frameobj in m_frameStage)
			{
				frameobj.onFrameEnd();
			}
			
			//Profiler.ensureAtRoot();
			if (m_context.m_profiler)
				m_context.m_profiler.ensureAtRoot();
		}
		
		private function processScheduledObjects():void
		{
			// Do any deferred methods.
			var oldDeferredMethodQueue:Array = deferredMethodQueue;
			if (oldDeferredMethodQueue.length)
			{
				//Profiler.enter("callLater");
				if (m_context.m_profiler)
					m_context.m_profiler.enter("callLater");
				
				// Put a new array in the queue to avoid getting into corrupted
				// state due to more calls being added.
				deferredMethodQueue = [];
				
				for (var j:int = 0; j < oldDeferredMethodQueue.length; j++)
				{
					var curDM:DeferredMethod = oldDeferredMethodQueue[j] as DeferredMethod;
					curDM.method.apply(null, curDM.args);
				}
				
				// Wipe the old array now we're done with it.
				oldDeferredMethodQueue.length = 0;
				
				//Profiler.exit("callLater");
				if (m_context.m_profiler)
					m_context.m_profiler.exit("callLater");
			}
			
			// Process any queued items.
			if (thinkHeap.size)
			{
				//Profiler.enter("Queue");
				if (m_context.m_profiler)
					m_context.m_profiler.enter("Queue");
				
				while (thinkHeap.front && thinkHeap.front.priority >= -_virtualTime)
				{
					var itemRaw:IPrioritizable = thinkHeap.dequeue();
					var qItem:IQueuedObject = itemRaw as IQueuedObject;
					var sItem:ScheduleObject = itemRaw as ScheduleObject;
					
					var type:String = TypeUtility.getObjectClassName(itemRaw);
					
					//Profiler.enter(type);
					if (m_context.m_profiler)
						m_context.m_profiler.enter(type);
					if (qItem)
					{
						// Check here to avoid else block that throws an error - empty callback
						// means it unregistered.
						if (qItem.nextThinkCallback != null)
							qItem.nextThinkCallback();
					}
					else if (sItem && sItem.callback != null)
					{
						sItem.callback.apply(sItem.thisObject, sItem.arguments);
					}
					else
					{
						throw new Error("Unknown type found in thinkHeap.");
					}
					//Profiler.exit(type);
					if (m_context.m_profiler)
						m_context.m_profiler.exit(type);
				}
				
				//Profiler.exit("Queue");
				if (m_context.m_profiler)
					m_context.m_profiler.exit("Queue");
			}
		}
		
		/**
		 * @brief 窗口大小改变的时候会调用这个函数
		 */
		public function onResize(event:Event = null):void
		{
			//m_context.m_config.m_stageWidth = m_context.m_mainStage.stageWidth;
			//m_context.m_config.m_stageHeight = m_context.m_mainStage.stageHeight;
			
			if (m_context.adjustWindowPos())
			{
				//var resizeobj:IResizeObject;
				//for each (resizeobj in m_resizeObject)
				//{
					//resizeobj.onResize(m_context.m_config.m_stageWidth, m_context.m_config.m_curHeight);
				//	resizeobj.onResize(m_context.m_config.m_curWidth, m_context.m_config.m_curHeight);
				//}
				
				for (var j:int = 0; j < m_resizeObject.length; j++)
				{
					var object:ProcessObject = m_resizeObject[j] as ProcessObject;
					if (!object)
						continue;

					(object.listener as IResizeObject).onResize(m_context.m_config.m_curWidth, m_context.m_config.m_curHeight);
				}
			}
		}
		
		// 添加一个对象,不要在便利的过程中添加，否则会有问题
		public function addResizeObject(object:IResizeObject, priority:Number = 0.0):void
		{
			//m_resizeObject.push(object);
			addObject(object, priority, m_resizeObject);
		}
		
		// 移除一个对象  
		public function removeResizeObject(object:IResizeObject):void
		{
			//var idx:int = m_resizeObject.indexOf(object);
			//if (idx != -1)
			//{
			//	m_resizeObject.splice(idx, 1);
			//}
			
			removeObject(object, m_resizeObject);
		}
		
		// 添加一个对象  
		public function addFrameObject(object:IFrameStage):void
		{
			m_frameStage.push(object);
		}
		
		// 移除一个对象  
		public function removeFrameObject(object:IFrameStage):void
		{
			var idx:int = m_frameStage.indexOf(object);
			if (idx != -1)
			{
				m_frameStage.splice(idx, 1);
			}
		}
		
		public function add1SecondUpateObject(obj:ITimeUpdateObject):void
		{
			if (duringAdvance)
			{
				callLater(add1SecondUpateObject, [obj]);
				return;
			}
			
			if (-1 == m_timeUpdateObjects.indexOf(obj))
			{
				m_timeUpdateObjects.push(obj);
			}
		
		}
		
		public function remove1SecondUpateObject(obj:ITimeUpdateObject):void
		{
			if (duringAdvance)
			{
				callLater(remove1SecondUpateObject, [obj]);
				return;
			}
			
			var i:int = m_timeUpdateObjects.indexOf(obj);
			if (i != -1)
			{
				m_timeUpdateObjects.splice(i, 1);
			}
		}
		
		//每隔1秒执行一次
		public function on1SecondUpdate():void
		{
			var obj:ITimeUpdateObject;
			for each (obj in m_timeUpdateObjects)
			{
				obj.onTimeUpdate();
			}
		}
		
		public function add1MinuteUpateObject(obj:ITimeUpdateObject):void
		{
			if (duringAdvance)
			{
				callLater(add1MinuteUpateObject, [obj]);
				return;
			}
			
			if (-1 == m_1MinuteUpdateObjects.indexOf(obj))
			{
				m_1MinuteUpdateObjects.push(obj);
			}
		
		}
		
		public function remove1MinuteUpateObject(obj:ITimeUpdateObject):void
		{
			if (duringAdvance)
			{
				callLater(remove1MinuteUpateObject, [obj]);
				return;
			}
			
			var i:int = m_1MinuteUpdateObjects.indexOf(obj);
			if (i != -1)
			{
				m_1MinuteUpdateObjects.splice(i, 1);
			}
		}
		
		//每隔1分钟执行一次
		public function on1MinuteUpdate():void
		{
			var obj:ITimeUpdateObject;
			for each (obj in m_1MinuteUpdateObjects)
			{
				obj.onTimeUpdate();
			}
		}
		
		public function add10MinuteUpateObject(obj:ITimeUpdateObject):void
		{
			if (duringAdvance)
			{
				callLater(add10MinuteUpateObject, [obj]);
				return;
			}
			
			if (-1 == m_10MinuteUpdateObjects.indexOf(obj))
			{
				m_10MinuteUpdateObjects.push(obj);
			}
		
		}
		
		public function remove10MinuteUpateObject(obj:ITimeUpdateObject):void
		{
			if (duringAdvance)
			{
				callLater(remove10MinuteUpateObject, [obj]);
				return;
			}
			
			var i:int = m_10MinuteUpdateObjects.indexOf(obj);
			if (i != -1)
			{
				m_10MinuteUpdateObjects.splice(i, 1);
			}
		}
		
		//每隔10分钟执行一次
		public function on10MinuteUpdate():void
		{
			var beginTime:int = getTimer();
			var obj:ITimeUpdateObject;
			for each (obj in m_10MinuteUpdateObjects)
			{
				obj.onTimeUpdate();
			}
			var endTime:int = getTimer();
			if (endTime-beginTime > 200)
			{
				var strLog:String = "on10MinuteUpdate执行的时间过长=" + (endTime-beginTime).toString();
				DebugBox.sendToDataBase(strLog);
			}
		}
		
		// frame = 0 就是事件,否则就是定时器
		public function toggleTimer(frame:uint):void
		{
			if (EntityCValue.TMFrame == frame) // 开启事件
			{
				m_context.mainStage.addEventListener(Event.ENTER_FRAME, onFrame);
				clearInterval(m_24frameTimer);
				m_24frameTimer = 0;
			}
			else
			{
				m_context.mainStage.removeEventListener(Event.ENTER_FRAME, onFrame);
				m_24frameTimer = setInterval(onFrame, 50); // 20 帧/秒
			}
		}
		
		public function setUseIdleTime(b:Boolean):void
		{
			m_bUseIdleTime = b;
		}
		
		protected var deferredMethodQueue:Array = [];
		protected var started:Boolean = false;
		protected var _virtualTime:int = 0.0;
		protected var _interpolationFactor:Number = 0.0;
		protected var _timeScale:Number = 1.0;
		protected var lastTime:Number = -1.0;
		
		protected var elapsed:Number = 0.0;
		protected var animatedObjects:Array = new Array();
		protected var tickedObjects:Array = new Array();
		
		protected var lastTime1Sec:Number = -1.0; //1秒标记，每隔1秒钟onTick一次		
		protected var m_timeUpdateObjects:Vector.<ITimeUpdateObject> = new Vector.<ITimeUpdateObject>();
		
		protected var lastTime1Minute:Number = -1.0; //1分钟标记，每隔1分钟钟onTick一次
		protected var m_1MinuteUpdateObjects:Vector.<ITimeUpdateObject> = new Vector.<ITimeUpdateObject>();
		
		protected var lastTime10Minute:Number = -1.0; //10分钟标记，每隔10分钟钟onTick一次
		protected var m_10MinuteUpdateObjects:Vector.<ITimeUpdateObject> = new Vector.<ITimeUpdateObject>();
		
		protected var needPurgeEmpty:Boolean = false;
		
		protected var _platformTime:Number = 0;
		
		protected var duringAdvance:Boolean = false;
		
		protected var thinkHeap:SimplePriorityQueue = new SimplePriorityQueue(1024);
		
		// KBEN:窗口大小改变的时候需要处理的队列 
		//protected var m_resizeObject:Vector.<IResizeObject> = new Vector.<IResizeObject>();
		protected var m_resizeObject:Array = new Array();;
		protected var m_frameStage:Vector.<IFrameStage> = new Vector.<IFrameStage>();
		protected var m_24frameTimer:uint; // 24 帧定时器
		protected var m_bUseIdleTime:Boolean;
		
		protected var m_runMode:uint;
		protected var m_internalTime:Number;	// 如果是单步运行，这个是间隔,单位毫秒
		protected var m_deltaTime:Number;	// 这个是为了不使用临时变量才定义的
	}
}