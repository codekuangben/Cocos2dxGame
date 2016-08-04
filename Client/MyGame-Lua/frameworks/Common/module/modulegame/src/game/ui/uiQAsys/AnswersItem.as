package game.ui.uiQAsys
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import modulecommon.appcontrol.PanelDisposeEx;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class AnswersItem extends Component 
	{
		private var m_parent:AnswersList;
		private var m_isRight:Boolean;
		private var m_clickBtn:Panel;
		private var m_answerLabel:Label;
		private var m_itembg:PanelDisposeEx;
		private var m_itembgContainer:PanelContainer;
		public function AnswersItem(bg:PanelDisposeEx,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_itembgContainer = new PanelContainer(this);
			m_parent = parent as AnswersList;
			m_itembg = bg;
			m_clickBtn = new Panel(this, 30, 0);
			m_answerLabel = new Label(this, 60, 2, "", UtilColor.WHITE_Yellow);
			setSize(300,30);
			drawRectBG();
		}
		public function setdata(text:String,isright:Boolean):void
		{
			addEventListener(MouseEvent.ROLL_OVER, moveOverFunc);
			addEventListener(MouseEvent.CLICK, retResult);
			m_itembg.hide(m_itembgContainer);
			m_isRight = isright;
			m_clickBtn.setPanelImageSkin("commoncontrol/panel/qasys/normal.png");
			m_answerLabel.text = text;
		}
		private function retResult(e:MouseEvent):void
		{
			m_clickBtn.setPanelImageSkin("commoncontrol/panel/qasys/select.png");
			m_parent.result(m_isRight);
		}
		public function removeListener():void
		{
			removeEventListener(MouseEvent.CLICK, retResult);
			removeEventListener(MouseEvent.ROLL_OVER, moveOverFunc);
		}
		override public function dispose():void 
		{
			removeEventListener(MouseEvent.CLICK, retResult);
			removeEventListener(MouseEvent.ROLL_OVER, moveOverFunc);
			super.dispose();
		}
		private function moveOverFunc(e:MouseEvent):void
		{
			m_itembg.show(m_itembgContainer);
		}
		
	}

}