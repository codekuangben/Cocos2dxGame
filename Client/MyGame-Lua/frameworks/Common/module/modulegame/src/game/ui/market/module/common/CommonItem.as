package game.ui.market.module.common 
{

	import com.bit101.components.controlList.CtrolComponent;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import modulecommon.scene.market.stMarketBaseObj;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ZObject;
	/**
	 * ...
	 * @author ...
	 */
	public class CommonItem extends CommondityYuanbaoBase 
	{
		
		public function CommonItem(param:Object=null) 
		{
			super(param);
			
		}		
		override public function init():void 
		{
			super.init();
			this.setPanelImageSkin("market.commoditybg");
			m_buyBtn.setSkinButton1Image("market.yellowbuybtn");
		}
	}

}