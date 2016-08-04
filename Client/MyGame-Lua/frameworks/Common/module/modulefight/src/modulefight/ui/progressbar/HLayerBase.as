package modulefight.ui.progressbar 
{
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class HLayerBase extends PanelContainer 
	{
		protected var m_srcRect:Rectangle;
		protected var m_virtualShade:Shape;
		
		public function HLayerBase(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_srcRect = new Rectangle();
			m_virtualShade = new Shape();
			this.addChild(m_virtualShade);
		}
		public function setParam(imageFun:String, name:String, w:Number, h:Number):void	{ }
		public function setValues(showValue:Number, realValue:Number):void{ }
	}

}