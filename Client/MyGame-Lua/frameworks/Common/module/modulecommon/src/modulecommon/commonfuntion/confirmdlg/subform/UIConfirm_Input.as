package modulecommon.commonfuntion.confirmdlg.subform 
{
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import modulecommon.commonfuntion.ConfirmInputRelevantData;
	import modulecommon.res.ResGrid9;
	/**
	 * ...
	 * @author 
	 */
	public class UIConfirm_Input extends UIConfirmBase 
	{
		protected var m_input:InputText;
		protected var m_labelRelevant:Label;
		protected var m_funRelevant:Function;
		protected var m_label2Relevant:Label;
		protected var m_fun2Relevant:Function;
		public function UIConfirm_Input() 
		{
			
		}
		override public function onReady():void 
		{
			super.onReady();
			this.width = 400;
			m_input = new InputText(this, 0, 0, "", onCiShuChange);
			m_input.setTextFormat(0xffffff, 14);
			m_input.number = true;
			m_input.marginLeft = 5;
			m_input.align = Component.CENTER;
			m_input.setHorizontalImageSkin("commoncontrol/horstretch/inputBg_mirror.png");
			m_labelRelevant = new Label(this);
			m_labelRelevant.autoSize = false;
			m_labelRelevant.setFontSize(14);
			m_labelRelevant.setBold(true);
			m_labelRelevant.align = Component.CENTER;
			m_labelRelevant.width = 0;
			
			m_label2Relevant = new Label(this);
			m_label2Relevant.autoSize = false;
			m_label2Relevant.setFontSize(14);
			m_label2Relevant.setBold(true);
			m_label2Relevant.align = Component.CENTER;
			m_label2Relevant.width = 0;
			
			this.setSkinGrid9Image9(ResGrid9.StypeSix);
		}
		public function process(param:Object):void
		{
			if (param["title"] != undefined)
			{
				m_title.text = param["title"];
			}
			
			var rectInput:Rectangle = param["rectInput"];
			m_input.setPos(rectInput.x+m_tf.x, rectInput.y+m_tf.y);
			m_input.setSize(rectInput.width, rectInput.height);
			if (param["minValue"] != undefined)
			{
				m_input.minNumber = param["minValue"];
			}
			if (param["maxValue"] != undefined)
			{
				m_input.maxNumber = param["maxValue"];
			}
			if (param["defaultValue"] != undefined)
			{
				m_input.intText = param["defaultValue"];
			}
			
			var data:ConfirmInputRelevantData;
			if (param["labelRelevantData"] != undefined)
			{
				data = param["labelRelevantData"];
				m_labelRelevant.visible = true;
				m_labelRelevant.setPos(data.m_pos.x + m_tf.x, data.m_pos.y + m_tf.y);
				m_funRelevant = data.m_func;
				m_labelRelevant.text = (m_funRelevant(m_input.intText)).toString();
				m_labelRelevant.setFontColor(data.m_color);
			}
			else
			{
				m_labelRelevant.visible = false;
			}
			
			if (param["label2RelevantData"] != undefined)
			{
				data = param["label2RelevantData"];
				m_label2Relevant.visible = true;
				m_label2Relevant.setPos(data.m_pos.x + m_tf.x, data.m_pos.y + m_tf.y);
				m_fun2Relevant = data.m_func;
				m_label2Relevant.text = (m_fun2Relevant(m_input.intText)).toString();
				m_label2Relevant.setFontColor(data.m_color);
			}
			else
			{
				m_label2Relevant.visible = false;
			}
			
			var top:int = setDesc(param);
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
		public function getInputNumber():int
		{
			return m_input.intText;
		}
		protected function onCiShuChange(event:Event):void	
		{
			if (m_funRelevant != null)
			{
				m_labelRelevant.text = (m_funRelevant(m_input.intText)).toString();
			}
			
			if (m_fun2Relevant != null)
			{
				m_label2Relevant.text = (m_fun2Relevant(m_input.intText)).toString();
			}
		}
	}

}