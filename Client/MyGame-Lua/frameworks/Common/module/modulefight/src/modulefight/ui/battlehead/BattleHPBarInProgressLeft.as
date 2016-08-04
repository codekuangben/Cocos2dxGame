package modulefight.ui.battlehead 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.progressBar.IBarInProgress;	
	import com.util.Car1D;
	import com.pblabs.engine.core.ITickedObject;
	//import flash.display.Sprite;
	import flash.geom.Rectangle;
	import modulecommon.GkContext;
	import com.pblabs.engine.entity.EntityCValue;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BattleHPBarInProgressLeft extends PanelContainer implements IBarInProgress , ITickedObject
	{
		private var m_gkContext:GkContext;
		
		protected var _value:Number = 0;
		protected var _max:Number = 1;
		protected var _curValue:Number;
		public var _topShade:Panel;
		public	  var _bg:Panel;
		
		private var m_car:Car1D;
		private var m_bInPM:Boolean;
		private var m_scrollRect:Rectangle;
		public function BattleHPBarInProgressLeft(gk:GkContext) 
		{
			m_gkContext = gk;
			_bg = new Panel(this, 0, 0);
			_bg.autoSizeByImage = false;
			_bg.cacheAsBitmap = true;
			_topShade = new Panel(this, 0, 0);
			m_car = new Car1D();
			m_bInPM = false;		
			m_scrollRect = new Rectangle();
						
			//_topShade.mask = _bg;
		}
		
		public function set maximum(m:Number):void
		{			
			_max = m;	
			_curValue = m;
			_value = m;		
			
		}
		public function set initValue(v:Number):void
		{
			_value = v;	
			_curValue = v;			
			
		}
		
		public function initBar():void
		{		
			m_car.stop();
			removeFromProcessManager();
			drawShade();			
		}
		public function set value(v:Number):void
		{			
			if (_value == v)
			{
				return;
			}
			_value = v;
			
			m_car.sorPos = _curValue;
			m_car.destPos = _value;
			//m_car.mvSpeed = 90;
			m_car.totalTime = 1.5;
			m_car.begin();
			addToProcessManager();
		}	
		
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			_bg.setSize(w, h);
			m_scrollRect.height = h;
		}
		
		private function drawShade():void
		{
			_topShade.x = _value / _max * this.width;
			
			_topShade.graphics.clear();
			_topShade.graphics.beginFill(0xffffff, 0.4);
			try
			{
				_topShade.graphics.drawRect(0, 0, (_curValue - _value) / _max * this.width, this.height);	
			}
			catch (e:Error)
			{
				var str:String = "drawShade_drawRect=" + _curValue + "," + _value + "," + _max + "," + this.width + "," + this.width;
				m_gkContext.addLog(str);	
				throw e;
			}
			_topShade.graphics.endFill();
			m_scrollRect.width = _curValue / _max * this.width;
			_bg.scrollRect = m_scrollRect;
		}
		
		public function onTick(deltaTime:Number):void
		{
			m_car.onTick(deltaTime);
			_curValue = m_car.curPos;
			drawShade();						
			if (m_car.isStop)
			{
				removeFromProcessManager();
			}
		}
		override public function dispose():void 
		{
			removeFromProcessManager();
			super.dispose();
		}
		protected function addToProcessManager():void
		{
			if (m_bInPM == false)
			{
				m_gkContext.m_context.m_processManager.addTickedObject(this, EntityCValue.PriorityUI);
				m_bInPM = true;				
			}			
		}
		protected function removeFromProcessManager():void
		{
			if (m_bInPM == true)
			{
				m_gkContext.m_context.m_processManager.removeTickedObject(this);
				m_bInPM = false;				
			}
		}
	}

}