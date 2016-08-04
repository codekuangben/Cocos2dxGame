package game.ui.uibenefithall.subcom.sevenlogin 
{
	import com.bit101.components.Ani;
	import com.bit101.components.controlList.CtrolHComponent;
	import flash.geom.Point;
	import modulecommon.scene.benefithall.qiridenglu.Qiri_DayObject;
	import modulecommon.scene.godlyweapon.WeaponItem;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import game.ui.uibenefithall.DataBenefitHall;
	import flash.events.MouseEvent;
	import modulecommon.scene.prop.object.ZObjectDef;
	
	/**
	 * ...
	 * @author 
	 */
	public class Qiri_AwardItem extends CtrolHComponent 
	{
		private var m_objPanel:ObjectPanel;
		protected var m_dataBenefitHall:DataBenefitHall;
		private var m_objData:Qiri_DayObject;
		private var m_weaponItem:WeaponItem;
		private var m_ani:Ani;
		public function Qiri_AwardItem(param:Object=null) 
		{
			super(param);
			m_dataBenefitHall = param.data;
			m_objPanel = new ObjectPanel(m_dataBenefitHall.m_gkContext, this);
			m_objPanel.setPanelImageSkin(ZObject.IconBg);
			
			
			m_ani = new Ani(m_dataBenefitHall.m_gkContext.m_context, this, 23, 23);
			m_ani.setParam(0, true, false, 2, false);
		
			this.width = 46;
		}
		
		override public function setData(data:Object):void 
		{
			//super.setData(data);
			var obj:ZObject;
			if (data is Qiri_DayObject)
			{
				m_objData = data as Qiri_DayObject;
				obj = ZObject.createClientObject(m_objData.m_id, m_objData.m_num, m_objData.m_upgrade);
				m_objPanel.showObjectTip = true;				
			}
			else
			{
				m_weaponItem = m_dataBenefitHall.m_gkContext.m_godlyWeaponMgr.getWeaponDataByID(data as int);
				obj = ZObject.createClientObject(m_weaponItem.m_objID);
				m_objPanel.showObjectTip = false;
				m_objPanel.addEventListener(MouseEvent.ROLL_OUT, m_dataBenefitHall.m_gkContext.hideTipOnMouseOut);
				m_objPanel.addEventListener(MouseEvent.ROLL_OVER, onPanelMouseOver);
			}
			m_objPanel.objectIcon.setZObject(obj);
			
			m_ani.setImageAni(ZObjectDef.getObjAniResName(obj.iconColor));
			m_ani.begin();
		}
		protected function onPanelMouseOver(event:MouseEvent):void
		{
			var tip:TipGodlyWeapon = m_dataBenefitHall.m_qiriBottomPart.getTipGodlyWeapon();
			tip.setData(m_weaponItem.m_id);
			var pt:Point = this.localToScreen();
			pt.x -= 265;
			pt.y -= 200;
			
			m_dataBenefitHall.m_gkContext.m_uiTip.hintComponent(pt, tip);
		}
		
		
	}

}