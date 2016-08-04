package game.ui.tongquetai.forestage 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelShowAndHide;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import com.bit101.components.Component;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author 
	 */
	public class DancerPanelBase extends PanelShowAndHide 
	{
		protected var m_gkContext:GkContext;
		protected var m_dancers:Dictionary;//[pos,DancerModel]
		protected var m_namePanel:Panel;
		protected var m_nameLabel:Label;
		public var m_parent:DisplayObjectContainer;
		public function DancerPanelBase(gk:GkContext, dancerClass:Class, parent:DisplayObjectContainer, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_parent = parent;
			m_dancers = new Dictionary();
			m_gkContext = gk;
			m_nameLabel = new Label(this, 356, -137, "", UtilColor.GOLD, 15);
			m_nameLabel.align = Component.CENTER;
			m_namePanel = new Panel(m_nameLabel, -48,-13);
			m_namePanel.setPanelImageSkin("commoncontrol/panel/tongquetai/name.png");
			var hinitpos:int=20;
			var hwidth:int=226;
			for (var i:int = 0; i < 3; i++ )
			{
				m_dancers[i] = new dancerClass(i, m_gkContext, this, hinitpos + i * hwidth);				
			}
		}
		
		protected function exchangeName(name:String=null):void
		{
		}
		
	}

}