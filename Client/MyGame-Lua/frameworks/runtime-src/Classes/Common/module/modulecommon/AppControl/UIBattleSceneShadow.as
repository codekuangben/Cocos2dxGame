package modulecommon.appcontrol
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIBattleSceneShadow extends Form
	{
		public var m_blackBtm:Shape;		// 底下的黑影
		public var m_redBaoJi:Shape;		// 被暴击红色
		protected var m_timer:Timer;		// 渐变定时器
		
		public function UIBattleSceneShadow()
		{
			//exitMode = ;
			
			this.id = UIFormID.UIBattleSceneShadow;
			
			m_redBaoJi = new Shape();
			this.addChild(m_redBaoJi);
			
			m_blackBtm = new Shape();
			this.addChild(m_blackBtm);
		}
		
		override public function onShow():void
		{
			var widthStage:int = m_gkcontext.m_context.m_config.m_curWidth;
			var heightStage:int = m_gkcontext.m_context.m_config.m_curHeight;
			this.setSize(widthStage, heightStage);
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			if (this.parent != null)
			{
				this.parent.setChildIndex(this, 0);
			}
			
			//showBaoJi();
		}
		override public function draw():void
		{
			var r:Number = this.m_gkcontext.m_battleLight;
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0x000000, 0x0, 0, 0x000000];
			var alphas:Array = [0 * r/ 255, 40*r / 255, 85*r / 255, 180*r / 255];
			var ratios:Array = [0x0, 80, 0xaa, 0xff];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(this.width + 200, this.height + 200, 0, -100, -100);
			var spreadMethod:String = SpreadMethod.PAD;
			this.m_blackBtm.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			this.m_blackBtm.graphics.drawRect(0, 0, this.width, this.height);
			this.m_blackBtm.graphics.endFill();
		}
		
		override public function onStageReSize():void
		{
			var widthStage:int = m_gkcontext.m_context.m_config.m_curWidth;
			var heightStage:int = m_gkcontext.m_context.m_config.m_curHeight;
			this.setSize(widthStage, heightStage);			
		}
		
		// 被暴击的时候效果
		public function showBaoJi():void
		{
			if (m_timer)
			{
				m_timer.stop();
				m_timer.reset();
			}
			else
			{
				m_timer = new Timer(20);
				m_timer.addEventListener(TimerEvent.TIMER, onTimerTick);
				m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerEnd);
			}
			m_timer.start();
			
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xFF0000, 0xFF0000];
			var alphas:Array = [0, 100];
			var ratios:Array = [100, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(this.width + 200, this.height + 200, 0, -100, -100);
			var spreadMethod:String = SpreadMethod.PAD;
			//this.m_redBaoJi.graphics.clear();
			this.m_redBaoJi.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			this.m_redBaoJi.graphics.drawRect(0, 0, this.width, this.height);
			this.m_redBaoJi.graphics.endFill();
			this.m_redBaoJi.alpha = 0.0;
		}
		
		/**
		 * @brief 定时器函数
		 * */
		private function onTimerTick(event:TimerEvent): void 
		{
			this.m_redBaoJi.alpha += 0.25;
			if (this.m_redBaoJi.alpha >= 0.7)
			{
				m_timer.stop();
				m_timer.removeEventListener(TimerEvent.TIMER, onTimerTick);
				m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerEnd);
				m_timer = null;
				this.m_redBaoJi.graphics.clear();
			}
		}

		private function onTimerEnd(event:TimerEvent): void 
		{
			m_timer.removeEventListener(TimerEvent.TIMER, onTimerTick);
			m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerEnd);
			m_timer = null;
		}
	}
}