package game.ui.uibackpack.subForm.fastZhuansheng
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.ButtonText;
	import flash.events.MouseEvent;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author
	 */
	public class ItemNeedBase extends Component
	{
		protected var m_gkContext:GkContext;
		protected var m_label:Label;
		protected var m_btnObtain:ButtonText;
		protected var m_bSatisfied:Boolean;
		public function ItemNeedBase(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			m_gkContext = gk;
			super(parent, xpos, ypos);
			m_label = new Label(this);
			m_label.setFontSize(14);
			m_label.setBold(true);
			m_bSatisfied = false;
		}
		
		protected function showObtainBtn():void
		{
			if (m_btnObtain == null)
			{
				m_btnObtain = new ButtonText(this);
				m_btnObtain.setSize(40, 16);
				m_btnObtain.addEventListener(MouseEvent.CLICK, onClick);
				m_btnObtain.label = "获得";
				m_btnObtain.overColor = UtilColor.GREEN;
				m_btnObtain.downColor=UtilColor.GREEN;
				m_btnObtain.y = 2;
				//m_btnObtain.normalColor = UtilColor.GREEN;
				m_btnObtain.labelComponent.underline = true;
				m_btnObtain.labelComponent.setFontSize(14);
			}
			
			if (m_btnObtain.visible == false)
			{
				m_btnObtain.visible = true;
			}
		}
		
		public function update():void
		{
			
		}
		protected function hideObtainBtn():void
		{
			if (m_btnObtain && m_btnObtain.visible)
			{
				m_btnObtain.visible = false;
			}
		}
		
		protected function onClick(e:MouseEvent):void
		{
		
		}
		
		public function get satisfied():Boolean
		{
			return m_bSatisfied;
		}
	}

}