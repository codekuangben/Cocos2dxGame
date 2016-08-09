package ui.instance
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;
	import com.util.UtilColor;
	
	/**
	 * @brief 政府信息
	 */
	public class OrgInfo extends Component
	{
		protected var m_lbl1f:Label;
		protected var m_lbl2f:Label;
		protected var m_lbl3f:Label;
		
		public function OrgInfo(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_lbl1f = new Label(this, 0, 0, "审批文号：新广出审（2014）544号", UtilColor.COLOR2);
			m_lbl1f.align = Component.CENTER;

			m_lbl2f = new Label(this, 0, 20, "互联网游戏出版物ISBN号：ISBN 978-7-89989-971-7", UtilColor.COLOR2);
			m_lbl2f.align = Component.CENTER;
			
			m_lbl3f = new Label(this, 0, 40, "著作权登记号：2013SR161769", UtilColor.COLOR2);
			m_lbl3f.align = Component.CENTER;
		}
		
		override public function dispose():void
		{
			m_lbl1f.dispose();
			m_lbl2f.dispose();
			m_lbl3f.dispose();
			super.dispose();
		}
	}
}