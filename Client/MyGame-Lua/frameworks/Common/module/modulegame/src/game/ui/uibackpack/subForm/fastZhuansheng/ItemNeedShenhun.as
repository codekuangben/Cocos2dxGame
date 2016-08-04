package game.ui.uibackpack.subForm.fastZhuansheng 
{
	import com.bit101.components.Ani;
	import flash.events.MouseEvent;
	import modulecommon.ui.UIFormID;
	
	import com.bit101.components.Component;	
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.wu.WuProperty;
	/**
	 * ...
	 * @author 
	 */
	public class ItemNeedShenhun extends ItemNeedBase 
	{		
		private var m_ani:Ani;
		private var m_value:int;
		private var m_wuColor:uint;	//武将颜色
		
		public function ItemNeedShenhun(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			
			super(gk, parent, xpos, ypos);
			
			m_ani = new Ani(m_gkContext.m_context);
			m_ani.x = 40;
			m_ani.y = 5;
			m_ani.centerPlay = true;
			this.addChild(m_ani);
			m_ani.duration = 1;
			m_ani.repeatCount = 0;
		}
		
		public function setShenhun(value:int, color:int):void
		{
			m_value = value;
			m_label.text = value.toString();
			m_label.flush();
			m_wuColor = color;
			if (m_wuColor == WuProperty.COLOR_BLUE)
			{
				m_ani.setImageAni("e40412.swf");				
			}
			else
			{
				m_ani.setImageAni("e40411.swf");				
			}
			m_ani.begin();
			m_ani.x = m_label.width + 11;
			update();
		}
		
		override public function update():void
		{
			if (m_bSatisfied)
			{
				return;
			}
			var moneyType:int;
			if (m_wuColor == WuProperty.COLOR_BLUE)
			{				
				moneyType = BeingProp.BLUE_SHENHUN;
			}
			else
			{				
				moneyType = BeingProp.GREEN_SHENHUN;
			}
			var money:int = m_gkContext.m_beingProp.getMoney(moneyType);
			if (m_value > money)
			{
				showObtainBtn();
				m_btnObtain.x = m_label.width+22;
				m_bSatisfied = false;
			}
			else
			{
				m_bSatisfied = true;
				hideObtainBtn();
			}
		}
		
		override protected function onClick(e:MouseEvent):void
		{
			m_gkContext.m_UIMgr.showFormEx(UIFormID.UIGamble);
		}
		
	}

}