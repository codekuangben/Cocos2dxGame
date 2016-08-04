package game.ui.giftwatch 
{
	import com.bit101.components.controlList.CtrolComponent;
	import modulecommon.scene.prop.object.ObjectDataVirtual;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ZObject;
	/**
	 * ...
	 * @author ...
	 */
	public class ObjectItem extends CtrolComponent 
	{
		private var m_obj:ZObject;
		private var m_gkContext:GkContext;
		private var m_panel:ObjectPanel;
		public function ObjectItem(param:Object=null) 
		{
			super(param);
			m_gkContext = param["gk"] as GkContext;	
			this.setSize(50, 50);
			m_panel = new ObjectPanel(m_gkContext, this, 2, 2);
			m_panel.setPanelImageSkin(ZObject.IconBg);
			m_panel.showObjectTip = true;
		}
		
		public override function setData(data:Object):void
		{
			super.setData(data);
			var dataObj:ObjectDataVirtual = data as ObjectDataVirtual;
			m_obj = ZObject.createClientObject(dataObj.m_objID, dataObj.m_num, dataObj.m_upgrade);
			m_panel.objectIcon.setZObject(m_obj);
		}
	}

}