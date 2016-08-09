package modulecommon.commonfuntion.confirmdlg.subform 
{
	/**
	 * ...
	 * @author ...
	 */
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import modulecommon.res.ResGrid9;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	public class UIConfirm_YES extends UIConfirmBase 
	{
		protected var m_input:InputText;
		public function UIConfirm_YES() 
		{			
			
		}
		override public function onReady():void 
		{
			super.onReady();
			this.width = 400;
			m_input = new InputText(this, 158, 0, "");
			m_input.setSize(100, 24);
			m_input.setTextFormat(0xffffff, 14);	
			m_input.maxChars = 3;
			m_input.marginLeft = 5;
			m_input.align = Component.CENTER;
			m_input.setHorizontalImageSkin("commoncontrol/horstretch/inputBg_mirror.png");
			
			var label:Label = new Label(m_input, 55, -25);
			label.align = Component.CENTER;
			UtilHtml.beginCompose();
			UtilHtml.add("请在下方输入", UtilColor.WHITE_Yellow, 14);
			UtilHtml.add("【YES】", UtilColor.GREEN, 14);
			UtilHtml.add("确认操作。", UtilColor.WHITE_Yellow, 14);
			label.htmlText = UtilHtml.getComposedContent();
			
			this.setSkinGrid9Image9(ResGrid9.StypeSix);
		}
		
		public function process(param:Object):void
		{
			if (param["title"] != undefined)
			{
				m_title.text = param["title"];
			}
			
			setDesc(param);
			
			m_input.y = m_tf.y + m_tf.textHeight + 45;
			m_input.text = "";
			
			var top:Number = m_input.y + m_input.height + 10;
			
			setConfirmAndConcelBtn(param, top);
			top += 70;
			if (top < 199)
			{
				top = 199;
			}
			this.height = top;
			m_input.focus = true;
			this.adjustPosWithAlign();
			this.darkOthers();
		}
		override public function onConfirmBtnClick(e:MouseEvent):void
		{
			var str:String = m_input.text;
			str.toLowerCase();
			if (str.toLowerCase() == "yes")
			{
				if (m_funOnConfirm())
				{
					this.exit();
				}
			}
			else
			{
				m_gkcontext.m_systemPrompt.prompt("输入错误，请重新输入");
			}
			
		}
	}

}