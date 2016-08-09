package modulecommon.ui 
{
	/**
	 * ...
	 * @author ...
	 */
	//import com.bit101.components.Component;
	//import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PanelDraw;
	import com.bit101.components.PushButton;
	import com.pblabs.engine.resource.SWFResource;
	import flash.events.MouseEvent;
	//import flash.events.Event;
	import com.dgrigg.image.ImageForm;
	import org.ffilmation.engine.datatypes.IntPoint;
	public class FormStyleEight extends Form 
	{
		protected var m_titlePart:PanelDraw;
		protected var m_bgPart:PanelDraw;
		protected var m_exitBtn:PushButton;
		public function FormStyleEight() 
		{			
			super();
			
			m_bgPart = new PanelDraw();
			this.addBackgroundChild(m_bgPart);
			
			m_titlePart = new PanelDraw();
			this.addBackgroundChild(m_titlePart);
			
			m_exitBtn = new PushButton(this,0,4);
			m_exitBtn.m_musicType = PushButton.BNMClose;
			//m_exitBtn.setSkinButton1Image("commoncontrol/button/exitbtn.swf");
			m_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
		}
		
			
		protected function beginTitleDraw(w:Number, h:Number, yTitle:Number ):void
		{			
			m_titlePart.setSize(w, h);
			m_titlePart.y = yTitle;
			m_titlePart.x = (this.width - w)/2;
		}
		protected function endTitleDraw():void
		{
			m_titlePart.drawPanel();
		}
		protected function beginPanelDraw(w:Number,h:Number, formName:String):void
		{
			var size:IntPoint = ImageForm.s_round(w, h,formName);
			this.setSize(size.x, size.y);
			m_bgPart.setSize(this.width, this.height);
			
			var panelContainer:PanelContainer = new PanelContainer();
			panelContainer.setSize(this.width, this.height);
			m_bgPart.addDrawCom(panelContainer, true);
			panelContainer.setSkinForm(formName);
		}
		
		//提供固定背景图片
		protected function beginWholeImage(w:Number,h:Number, imageName:String, swf:SWFResource = null):void
		{
			this.setSize(w, h);
			m_bgPart.setSize(this.width, this.height);
			
			var panelContainer:PanelContainer = new PanelContainer();
			if (swf)
			{
				panelContainer.setPanelImageSkinBySWF(swf, imageName);
			}
			else
			{
				panelContainer.setPanelImageSkin(imageName);
			}
			m_bgPart.addDrawCom(panelContainer);			
		}
		
		protected function endPanelDraw():void
		{
			m_bgPart.drawPanel();
		}
	}

}