package game.ui.uichargerank 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import modulecommon.net.msg.rankcmd.stRechargeRankItem;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class ChargeRankItem extends CtrolVHeightComponent 
	{
		private var m_rank:Label;
		private var m_name:Label;
		private var m_YuanBao:Label;
		public function ChargeRankItem(param:Object = null) 
		{
			super();
			var top:Number = 7;
			var panel:Panel = new Panel(this);
			panel.setSize(465, 35);
			panel.autoSizeByImage = false;
			panel.setPanelImageSkinMirror("commoncontrol/panel/sanguozhanchang/decorateLeft.png", Image.MirrorMode_LR);
			panel.mouseChildren = false;
			panel.mouseEnabled = false;
			
			m_rank = new Label(this, 74, top, "", UtilColor.WHITE_Yellow, 14);
			m_rank.align = Component.CENTER;
			m_name = new Label(this, 230, top, "", UtilColor.WHITE_Yellow,14);
			m_name.align = Component.CENTER;
			m_YuanBao = new Label(this, 402, top, "", UtilColor.WHITE_Yellow, 14);
			m_YuanBao.align = Component.CENTER;
		}
		override public function setData(data:Object):void
		{
			super.setData(data);
			var Rankdata:stRechargeRankItem = data as stRechargeRankItem;
			m_rank.text = Rankdata.m_index + "";
			m_name.text = Rankdata.m_name;
			m_YuanBao.text = Rankdata.m_yuanbao + "";
		}
	}

}