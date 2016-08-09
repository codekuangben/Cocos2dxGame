package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.BeingProp;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 * 用于显示元宝，银币，金币等panel
	 */
	public class MoneyPanel extends Component 
	{
		private var m_gkContext:GkContext;
		private var m_type:int;	//参见BeingProp.SILVER_COIN等定义。
		public function MoneyPanel(gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
		}
		
		public function set type(type:int):void
		{
			m_type = type;
			var str:String;
			switch(type)
			{
				case BeingProp.SILVER_COIN: str = "gamemoney"; break;
				case BeingProp.GOLD_COIN: str = "goldmoney"; break;
				case BeingProp.YUAN_BAO: str = "rmb"; break;
				case BeingProp.LING_PAI: str = "lingpai"; break;
				case BeingProp.RONGYU_PAI: str = "money_rongyupai"; break;
				case BeingProp.XINGYUN_BI: str = "luckymoney"; break;
			}
			str = "commoncontrol/panel/" + str +".png";
			this.setPanelImageSkin(str);
		}
		
		public function set showTip(bFlag:Boolean):void
		{
			if (bFlag)
			{
				this.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
				this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			}
		}		
		protected function onMouseOver(event:MouseEvent):void
		{
			var pt:Point = this.localToScreen();
			pt.x += this.width / 2;
			
			var str:String;
			switch(m_type)
			{
				case BeingProp.SILVER_COIN: str = "银币"; break;
				case BeingProp.GOLD_COIN: str = "金币"; break;
				case BeingProp.YUAN_BAO: str = "元宝"; break;
				case BeingProp.LING_PAI: str = "令牌"; break;
				case BeingProp.RONGYU_PAI: str = "荣誉勋章"; break;
				case BeingProp.XINGYUN_BI: str = "幸运币"; break;
			}
			
			m_gkContext.m_uiTip.hintCondense(pt, str);
		}
	}

}