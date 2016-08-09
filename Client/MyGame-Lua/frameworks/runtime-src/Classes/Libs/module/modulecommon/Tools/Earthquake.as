package modulecommon.tools 
{
	//import com.gskinner.motion.easing.Back;
	import com.pblabs.engine.entity.EntityCValue;
	
	//import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	* @brief Earthquake 类为显示对象提供震动效果动画
	*/
	public class Earthquake 
	{
		private var source:Object;	// 需要有 x y 属性
		private var originalX:Number;
		private var originalY:Number;
		
		private var timer:Timer;
		private var intensity:Number;
		private var fnend:Function;		// 震动结束回调
		
		private var type:uint;			// 摄像机类型
		private var upper:int;			// -1 向上 1 向下
		private var curDelta:Number;	// 震动方向 1 : 向下 intensity -1 : 向上 intensity 0 : 原点
		
		/**
		 * @param	source 将要加入震动效果的显示对象
		 */
		public function Earthquake(source:Object, fn:Function = null) 
		{
			this.source = source;
			this.fnend = fn;
			
			type = EntityCValue.CMUBtm;
			upper = 1;
			curDelta = 0;
		}
		 
		/**
		 * 启用震动效果
		 * @param	intensity 震动强度
		 * @param	times 震动次数
		 * @param	intervalSeconds 间隔时间
		 */
		public function quake(intensity:Number = 10, times:uint = 5, intervalSeconds:Number = 0.05):void 
		{
			this.intensity = intensity;
			originalX = source.x;
			originalY = source.y;
			
			timer = new Timer(intervalSeconds * 1000, times);
			timer.addEventListener(TimerEvent.TIMER, onQuake);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, rest);
			timer.start();
		}
		
		// bug: 退出战斗的时候，一定要把这个摄像机关联的震动销毁，否则会宕机
		private function onQuake( event:TimerEvent ): void 
		{
			var delY:Number;
			if (type == EntityCValue.CMRandom)
			{
				source.moveTo(originalX + ((Math.random() - 0.5) * 2) * intensity, originalY + ((Math.random() - 0.5) * 2) * intensity, 0)
			}
			else
			{
				source.moveTo(originalX, originalY + upper * this.intensity, 0);
				upper = Math.abs(upper - 1);
			}
		}

		private function rest(e:TimerEvent): void 
		{
			if (source)
			{
				source.moveTo(originalX, originalY, 0);
			}
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER, onQuake);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, rest);
				timer = null;
			}
			if (fnend != null)
			{
				fnend();
			}
		}
		
		/**
		 * @brief 手工停止
		 */
		public function stop():void
		{
			source.moveTo(originalX, originalY, 0);
			
			if (timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onQuake);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, rest);
				
				if (fnend != null)
				{
					fnend();
				}
				timer = null;
			}
		}
		
		/**
		 * @brief 释放资源
		 */
		public function dispose():void
		{
			stop();
			fnend = null;
		}
	}
}