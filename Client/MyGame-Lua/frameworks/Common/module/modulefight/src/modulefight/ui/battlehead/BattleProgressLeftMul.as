package modulefight.ui.battlehead 
{
	import com.bit101.components.PanelContainer;
	import com.bit101.components.progressBar.IBarInProgress;	
	import com.util.Car1D;
	import com.pblabs.engine.core.ITickedObject;
	import modulecommon.GkContext;
	import com.bit101.components.Panel;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BattleProgressLeftMul extends PanelContainer//  implements IBarInProgress , ITickedObject
	{
		/*private var m_gkContext:GkContext;
		private var m_car:Car1D;
		private var m_bInPM:Boolean;
		public function BattleProgressLeftMul(gk:GkContext) 
		{
			m_gkContext = gk;
			
			m_car = new Car1D();
			m_bInPM = false;
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
			_lenPixel = _value * _totalLenPixel / _max;
		}
		
		public function initBar():void
		{
			_eachLenPixel = this.width;
			_totalLenPixel = _eachLenPixel * _numLayer;
			_lenPixel = _totalLenPixel;
			_curLenPixel = _totalLenPixel;
			drawLen();
		}
		public function set value(v:Number):void
		{				
			if (_value == v)
			{
				return;
			}
			_value = v;
			_lenPixel = _value * _totalLenPixel / _max;
			
			m_car.sorPos = _curValue;
			m_car.destPos = _value;
			m_car.totalTime = 1.5;
			m_car.begin();
			addToProcessManager();
		}		
		
		public function onTick(deltaTime:Number):void
		{
			m_car.onTick(deltaTime);
			_curValue = m_car.curPos;
			_curLenPixel = _curValue * _totalLenPixel / _max;
			drawLen();
			drawMaskLen();
			
			if (m_car.isStop)
			{
				removeFromProcessManager();
			}
		}
		
		public function set numLayer(num:uint):void
		{
			_numLayer = num;
			_vecLayer = new Vector.<Panel>(_numLayer);
			for (var i:int; i < _numLayer; i++)
			{
				_vecLayer[i] = new Panel(this);
				_vecLayer[i].autoSizeByImage = false;
				_vecLayer[i].setSize(this.width, this.height);
			}			
			
			_topShade = new Panel(this, 0, 0);	
			
			
		}
		public function get layers():Vector.<Panel>
		{
			return _vecLayer;
		}
		
		protected function drawLen():void
		{
			var added:uint = _curLenPixel;
			var i:uint;
			for (i = 0; i < _numLayer; i++)
			{
				if (added <= _eachLenPixel)
				{
					_vecLayer[i].scaleX = added / _eachLenPixel;
					_vecLayer[i].x = (1 - _vecLayer[i].scaleX) * _vecLayer[i].width;
					i++;
					break;
				}
				else
				{
					_vecLayer[i].scaleX = 1;
					_vecLayer[i].x = 0;
					added -= _eachLenPixel;
				}
			}
			
			for (; i < _numLayer; i++)
			{
				_vecLayer[i].scaleX = 0;
			}
		}
		
		protected function drawMaskLen():void
		{
			_topShade.graphics.clear();
			_topShade.graphics.beginFill(0xffffff, 0.4);			
		
			var added:uint = _curLenPixel - _lenPixel;
			if (added == 0)
			{
				_topShade.graphics.endFill();
				return;
			}
			
			var i:uint = _lenPixel / _eachLenPixel;
			var already:uint = _lenPixel % _eachLenPixel;
			var can:uint;
			var arrRect:Array = new Array();
			for (; i < _numLayer; i++)
			{
				can = _eachLenPixel - already;
				if (added <= can)
				{
					arrRect.push(new Rectangle(_eachLenPixel - already - added, 0, added, this.height));
					//_topShade.graphics.drawRect(already, 0, added, this.height);	
					break;
				}
				else
				{
					arrRect.push(new Rectangle(already, 0, can, this.height));
					//_topShade.graphics.drawRect(already, 0, can, this.height);
					added -= can;
					already = 0;
				}
			}
			
			var lastRect:Rectangle;
			if (arrRect.length >= 1)
			{
				lastRect = arrRect[arrRect.length - 1] as Rectangle;
				_topShade.graphics.drawRect(lastRect.x, lastRect.y, lastRect.width, lastRect.height);
				
				if (arrRect.length >= 2)
				{
					var curRect:Rectangle = arrRect[arrRect.length - 2] as Rectangle;
					if (curRect.width > lastRect.x)
					{
						curRect.width = lastRect.x;
					}
					//_topShade.graphics.drawRect(curRect.x, curRect.y, curRect.width, curRect.height);
				}
			}
			
			_topShade.graphics.endFill();
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
		}*/
	}

}