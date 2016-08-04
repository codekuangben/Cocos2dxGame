package modulecommon.headtop
{
	import com.bit101.components.Label;
	//import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	//import flash.events.Event;
	//import flash.events.EventDispatcher;
	import modulecommon.GkContext;
	import com.bit101.components.Component;
	/**
	 * ...
	 * @author 
	 */
	public class HeadTopBlockBase extends Component
	{
		private var m_curTop:Number=0;
		private var m_labelInDisplay:Vector.<Label>;
		private var m_labelInBuffer:Vector.<Label>;
		
		//protected var m_nameLabel:Label;
		
		protected var m_gkContext:GkContext;

		public function HeadTopBlockBase(gk:GkContext) 
		{
			m_gkContext = gk;			
			m_labelInDisplay = new Vector.<Label>();
			m_labelInBuffer = new Vector.<Label>();		
		}		
		
		override public function draw():void 
		{
			update();
		}
		
		public function addAutoData(str:String, color:uint, size:uint, top:Number = -20):void
		{
			var label:Label;
			if (m_labelInBuffer.length)
			{
				label = m_labelInBuffer.pop();
			}
			else
			{
				label = new Label();
				label.align = Component.CENTER;	
			}
			
			label.text = str;
			label.setFontColor(color);
			label.setFontSize(size);
			label.y = m_curTop + top;
			addChild(label);
			m_curTop = label.y;
			m_labelInDisplay.push(label);
			label.flush();
		}
		
		public function clearAutoData():void
		{
			m_curTop = 0;
			var label:Label;
			for each(label in m_labelInDisplay)
			{
				removeChild(label);
				m_labelInBuffer.push(label);
			}
			m_labelInDisplay.length = 0;
		}
		
		public function get curTop():Number
		{
			return m_curTop;
		}
		
		public function set curTop(v:Number):void
		{
			m_curTop = v;
		}
		
		public function update():void
		{
			
		}

		public function addToDisplayList(p:DisplayObjectContainer):void
		{
			if (this.parent != p)
			{
				p.addChild(this);
			}
		}
		
		public function removeFromDisplayList():void
		{
			if (parent != null)
			{
				parent.removeChild(this);
			}			
		}
		
		public function get gkContext():GkContext
		{
			return m_gkContext;
		}
		
		//第一个显示为玩家name
		public function get nameStrW():uint
		{
			if (m_labelInDisplay.length)
			{
				return m_labelInDisplay[0].textWidth();
			}
			else
			{
				return 0;
			}
		}
		
		override public function dispose():void
		{		
			removeFromDisplayList();
			super.dispose();			
		}
	}
}