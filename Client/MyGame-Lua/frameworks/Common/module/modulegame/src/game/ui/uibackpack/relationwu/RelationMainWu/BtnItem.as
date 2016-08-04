package game.ui.uibackpack.relationwu.RelationMainWu 
{
	import com.bit101.components.ButtonTab;
	import com.bit101.components.Component;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.utils.PanelDrawCreator;
	import com.dgrigg.skins.ISkinButtonPanelDrawCreator;
	import com.dgrigg.utils.UIConst;
	import flash.events.MouseEvent;
	import modulecommon.appcontrol.PanelDisposeEx;
	import modulecommon.GkContext;
	import modulecommon.scene.wu.ActHerosGroup;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author ...
	 */
	public class BtnItem extends CtrolVHeightComponent implements ISkinButtonPanelDrawCreator
	{
		public static const BTN_WIDTH:int = 113;
		public static const BTN_HEIGHT:int = 36;
		
		private var m_gkContext:GkContext;
		private var m_btnList:BtnList;
		private var m_btn:ButtonTab;
		private var m_btnLight:PanelDisposeEx;
		private var m_data:ActHerosGroup;
		
		public function BtnItem(param:Object) 
		{
			m_gkContext = param["gk"] as GkContext;
			m_btnList = param["btnlist"] as BtnList;
			m_btnLight = param["lightpanel"] as PanelDisposeEx;
			
			m_btn = new ButtonTab(this, 0, 0);
			
			this.setSize(BTN_WIDTH, BTN_HEIGHT);
		}
		
		override public function setData(data:Object):void
		{
			super.setData(data);
			
			m_data = data as ActHerosGroup
		}
		
		override public function init():void
		{
			m_btn.setSkinButtonPanelDraw(this);
		}
		
		public function createPanelDrawCreator(etbtn:uint):PanelDrawCreator		
		{
			var cr:PanelDrawCreator = new PanelDrawCreator();
			cr.beginAddCom(BTN_WIDTH, BTN_HEIGHT);
			
			//btn背景
			var panel:Panel = new Panel();
			var bgName:String;
			if (UIConst.EtBtnSelected == etbtn)
			{
				bgName = "blueBtn";
			}
			else
			{
				bgName = "redBtn";
			}
			panel.setPanelImageSkin("commoncontrol/panel/backpack/mainwurelation/" + bgName + ".png");
			cr.addDrawCom(panel);
			
			var letterSpace:int;
			var label:Label = new Label(null, 56, 9, "", UtilColor.WHITE_Yellow);
			label.align = Component.CENTER;
			label.setFontSize(13);
			label.setBold(true);
			label.setMiaoBianColor(0x202020);
			label.text = m_data.m_desc;
			if (m_data.m_desc.length == 2)
			{
				letterSpace = 16;
			}
			else
			{
				letterSpace = 0;
			}
			label.setLetterSpacing(letterSpace);
			label.flush();
			cr.addDrawCom(label);
			
			cr.endAddCom();
			
			if (UIConst.EtBtnSelected != etbtn)
			{
				cr.setFilter(PushButton.s_funGetFilters(etbtn));
			}
			
			return cr;
		}
		
		override public function onNotSelected():void
		{
			m_btn.selected = false;
			m_btnLight.hide(this);
		}
		
		override public function onSelected():void
		{
			m_btn.selected = true;
			m_btnLight.show(this);
			this.setChildIndex(m_btnLight, 0);
		}
		
		public function get groupID():uint
		{
			return m_data.m_groupID;
		}
	}

}