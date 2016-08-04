package modulefight.ui.battlehead 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.progressBar.IBarInProgress;	
	import com.util.Car1D;
	import com.pblabs.engine.core.ITickedObject;
	import flash.geom.Rectangle;
	import modulecommon.GkContext;
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.ui.progressbar.HLayerBase;
	
	/**
	 * ...
	 * @author 
	 */
	public class BattleHPBarInProgressMulBase extends PanelContainer    implements IBarInProgress , ITickedObject
	{
		
		protected var m_gkContext:GkContext;
		
		protected var _max:Number = 1;
		protected var _value:Number = 0;	//当前实际值		
		protected var _curValue:Number;		//当前的虚值，以动画的方式变化	
		
		protected var _numLayer:uint;
		protected var _vecLayer:Vector.<HLayerBase>;
		
		protected var m_car:Car1D;
		protected var m_bInPM:Boolean;
		public function BattleHPBarInProgressMulBase(gk:GkContext)
		{
			m_gkContext = gk;
			
			m_car = new Car1D();
			m_bInPM = false;
		}
		public function set maximum(m:Number):void
		{
			_max = m;		
		}
				
		public function initBar():void
		{
			removeFromProcessManager();
			drawLen();
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
			m_car.totalTime = 1.5;
			m_car.begin();
			addToProcessManager();
		}
				
		public function set initValue(v:Number):void
		{
			_value = v;
			_curValue = v;
			drawLen();
		}
		
		public function onTick(deltaTime:Number):void
		{
			m_car.onTick(deltaTime);
			_curValue = m_car.curPos;			
			drawLen();		
			
			if (m_car.isStop)
			{
				removeFromProcessManager();
			}
		}
		
		public function setParam(w:Number, h:Number, paramList:Array):void
		{
			_numLayer = paramList.length;
			_vecLayer = new Vector.<HLayerBase>(_numLayer);
			
			var base:HLayerBase;
			for (var i:int; i < _numLayer; i++)
			{
				base = createLayer();
				_vecLayer[i] = base;
				base.autoSizeByImage = false;
				base.setParam("setPanelImageSkin", paramList[i], w, h);
			}
			
		}	
	
		protected function createLayer():HLayerBase
		{
			return null;
		}
	
		protected function drawLen():void
		{
			var i:int;
			
			var realList:Array = new Array(_numLayer);
			var showValueList:Array = new Array(_numLayer);
			
			computeArray(_value, realList);
			computeArray(_curValue, showValueList);
			
			for (i = 0; i < _numLayer; i++)
			{
				_vecLayer[i].setValues(showValueList[i], realList[i]);
			}
		}
		
		private function computeArray(len:Number, list:Array):void
		{
			len *= _numLayer;
			var cur:Number = 0;
			var a:Number;
			var i:int;
			for (i = 0; i < _numLayer; i++)
			{
				if (cur < len)
				{
					if (cur + 1 >= len)
					{
						a = len - cur;
						cur = len;
					}
					else
					{
						a = 1;
						cur = cur + 1;
					}
				}
				else
				{
					a = 0;
				}
				list[i] = a;
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