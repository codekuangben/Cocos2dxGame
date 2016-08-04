package game.ui.tasktrace.yugaogongneng 
{
	import com.bit101.components.Label;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import flash.display.DisplayObjectContainer;
	import modulecommon.appcontrol.PanelDisposeEx;
	import com.util.UtilColor;
	import modulecommon.res.ResGrid9;
	/**
	 * ...
	 * @author ...
	 */
	public class YugaoTip extends PanelDisposeEx 
	{
		private var m_title:Label;
		private var m_tf:TextNoScroll;
		public function YugaoTip() 
		{			
			m_title = new Label(this, 13, 16,"新功能预告");
			m_title.setFontColor(UtilColor.BLUE);
			m_title.setFontSize(14);
			m_title.setBold(true);
			
			m_tf = new TextNoScroll();
			m_tf.x = m_title.x;
			m_tf.y = m_title.y + 24;
			m_tf.width = 190;
			this.addChild(m_tf);
			m_tf.setBodyCSS(UtilColor.WHITE_Yellow, 12, 2, 4);
			this.width = 212;
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
		}
		
		public function showTip(yugao:GongnengItem):void
		{
			m_tf.setBodyHtml(yugao.m_desc);
			this.height = m_tf.y + m_tf.height + 20;
		}
		
	}

}