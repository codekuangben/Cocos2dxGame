package modulecommon.ui 
{
	/**
	 * ...
	 * @author 
	 */
	import com.bit101.components.ButtonText;
	import com.bit101.components.Label;
	import com.bit101.components.TextNoScroll;
	import com.util.UtilFont;
	import flash.events.MouseEvent;
	import com.util.UtilColor;
	
	public class FormConfirmBase extends Form 
	{
		protected var m_title:Label;
		protected var m_tf:TextNoScroll;
		protected var m_confirmBtn:ButtonText;
		protected var m_cancelBtn:ButtonText;
		public function FormConfirmBase() 
		{
			
		}
		override public function onReady():void 
		{
			super.onReady();
			
			m_title = new Label(this);
			m_title.miaobian = false;
			//m_title.setFontSize(14);
			m_title.y = 18;
			m_title.setFontColor(0);
			m_title.setBold(true);
			m_title.text = "提示";			
			m_title.x = 110;
			
			
			m_tf = new TextNoScroll();	this.addChild(m_tf);		
			m_tf.x = 55;
			m_tf.y = 65;
			
			m_tf.setCSS("body", {fontFamily:UtilFont.NAME_Songti,leading:10, color:"#fbdda2", fontSize:14,letterSpacing:1});
			m_tf.width = 315;
			
			m_confirmBtn = new ButtonText(this);
			m_confirmBtn.setSize(120, 42);
			m_confirmBtn.setGrid9ImageSkin("commoncontrol/button/button2.swf");		
			
			m_confirmBtn.setParam(14, true, onConfirmBtnClick, 1, UtilColor.WHITE_Yellow);
			
			m_cancelBtn = new ButtonText(this);
			m_cancelBtn.setSize(120, 42);
			m_cancelBtn.setGrid9ImageSkin("commoncontrol/button/button2.swf");
			m_cancelBtn.setParam(14, true, onConcelBtnClick, 1, UtilColor.WHITE_Yellow);
			m_cancelBtn.addEventListener(MouseEvent.CLICK, onConcelBtnClick);			
		}
		public function onConcelBtnClick(e:MouseEvent):void
		{
			
		}
		public function onConfirmBtnClick(e:MouseEvent):void
		{
			
		}
	}

}