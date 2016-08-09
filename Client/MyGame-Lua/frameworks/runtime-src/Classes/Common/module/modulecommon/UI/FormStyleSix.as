package modulecommon.ui 
{
	/**
	 * ...
	 * @author 
	 */
	//import com.bit101.components.Component;
	//import com.bit101.components.Label;
	//import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	//import com.bit101.components.PanelDraw;
	//import com.bit101.components.PushButton;
	import com.dgrigg.image.ImageForm;
	//import flash.events.MouseEvent;
	//import flash.events.Event;
	import modulecommon.res.ResForm;
	import org.ffilmation.engine.datatypes.IntPoint;
	
	public class FormStyleSix extends FormStyleFour
	{		
		
		public function FormStyleSix(showExitBtn:Boolean = true) 
		{
			super(showExitBtn);
			m_ocMusic = true;
		}
		
		public function setTitleForForm7(title:String, titleBGWidth:int,letterspace:Number=6):void
		{
			super.setTitle(title, titleBGWidth, ResForm.TitleBG_Form7, 6,letterspace);
			m_titlePart.y = -16;
			m_exitBtn.y = 4;	
			
		}	
		protected function beginPanelDraw(w:Number,h:Number):void
		{
			var size:IntPoint = ImageForm.s_round(w, h);
			this.setSize(size.x, size.y);			
			m_bgPart.setSize(this.width, this.height);
			
			var panelContainer:PanelContainer = new PanelContainer();
			panelContainer.setSize(this.width, this.height);
			m_bgPart.addDrawCom(panelContainer, true);
			panelContainer.setSkinForm("form7.swf");
		}
		protected function endPanelDraw():void
		{
			m_bgPart.drawPanel();
		}
	}

}