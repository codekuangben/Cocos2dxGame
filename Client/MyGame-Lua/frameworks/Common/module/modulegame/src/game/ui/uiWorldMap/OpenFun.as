package game.ui.uiWorldMap 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import org.ffilmation.engine.datatypes.PosOfLine;
	/**
	 * ...
	 * @author 
	 */
	public class OpenFun extends Component 
	{		
		private var m_funList:Vector.<String>;		
		private var m_funLabelList:Vector.<FunLabel>;
		public function OpenFun(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);			
			
		}
		public function setFunList(funList:Vector.<String>, posList:Vector.<Point>):void
		{
			m_funList = funList;			
						
			var i:int;
			var funLabel:FunLabel;
			m_funLabelList = new Vector.<FunLabel>();
			var interval:Number = 5;
			var left:Number=0;
			for (i = 0; i < m_funList.length; i++)
			{
				funLabel = new FunLabel(this,posList[i].x,posList[i].y);
				funLabel.setCaption(m_funList[i]);
				m_funLabelList.push(funLabel);						
			}		
		}		
		
	}

}