package game.ui.market.module.rongyu 
{
	import com.bit101.components.controlList.CtrolComponent;
	import game.ui.market.module.CommodityBase;
	import modulecommon.appcontrol.MonkeyAndValue;
	import modulecommon.scene.prop.BeingProp;
	/**
	 * ...
	 * @author ...
	 * 荣誉商场
	 */
	public class RongyuCommodity extends CommodityBase 
	{		
		public function RongyuCommodity(param:Object=null) 
		{
			super(param);
			
		}
		
		override protected function createCtrls():void
		{
			super.createCtrls();
			m_normalPrice = new MonkeyAndValue(m_gkContext, this, BeingProp.RONGYU_PAI, m_nameLabel.x, 40);	
			m_normalPrice.m_value.setPos(29, 3);
		}
		
		override public function init():void 
		{			
			super.init();
			
			this.setPanelImageSkin("market.commoditybg");
			m_buyBtn.setSkinButton1Image("market.yellowbuybtn");			
			
		}
	}

}