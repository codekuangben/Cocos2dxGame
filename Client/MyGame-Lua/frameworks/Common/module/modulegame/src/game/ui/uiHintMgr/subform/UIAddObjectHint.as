package game.ui.uiHintMgr.subform 
{
	/**
	 * ...
	 * @author 
	 * 得到道具时的提示
	 */
	
	 import flash.events.MouseEvent;
	 import flash.geom.Point;
	 import modulecommon.net.msg.propertyUserCmd.stSwapObjectPropertyUserCmd;
	 import modulecommon.scene.prop.object.ObjectPanel;
	 import modulecommon.scene.prop.object.Package;
	 import modulecommon.scene.prop.object.stObjLocation;
	 import modulecommon.scene.prop.object.ZObject;
	 import modulecommon.scene.prop.object.ZObjectDef;
	 import com.util.UtilHtml;
	 import uiHintMgr.HintTool;
	 import uiHintMgr.UIHintMgr;
	 
	public class UIAddObjectHint extends UIHint 
	{
		private var m_obj:ZObject;
		private var m_objPanel:ObjectPanel;
		public function UIAddObjectHint(mgr:UIHintMgr) 
		{
			super(mgr);
			
			
		}
		
		override public function onReady():void 
		{			
			m_objPanel = new ObjectPanel(m_gkcontext, this, 34, 47);
			m_objPanel.setSize(ZObject.IconBgSize, ZObject.IconBgSize);
			m_objPanel.setPanelImageSkin(ZObject.IconBg);
			m_objPanel.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			m_objPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			
			super.onReady();
		}
		
		//srcType来源类型:srcType:0-是新得到的装备；1-被替换到包裹中的装备
		//
		public function addObject(obj:ZObject, srcType:int):void
		{
			m_obj = obj;
			m_objPanel.objectIcon.setZObject(obj);
			
			UtilHtml.beginCompose();
			if (srcType == 0)
			{
				UtilHtml.addStringNoFormat("获得了更强的装备【");
			}
			else
			{
				UtilHtml.addStringNoFormat("包裹中有了更强的装备【");
			}
			UtilHtml.add(obj.name, m_obj.colorValue);
			UtilHtml.addStringNoFormat("】，您是否立刻更换上?");
			var str:String = UtilHtml.getComposedContent();
			this.setText(str);
			m_funBtn.label = "自动装备";
		}
		
		override protected function onFunBtnClick(e:MouseEvent):void 
		{
			var pak:Object = m_gkcontext.m_objMgr.getPackageAndObjectByThisID(m_obj.thisID);
			if (pak && m_obj.isInCommonPackage)
			{
				var heroID:uint = HintTool.getHeroIDWithInferiorEquip(m_gkcontext, m_obj);
				if (heroID)
				{
					var sendSwap:stSwapObjectPropertyUserCmd = new stSwapObjectPropertyUserCmd();
					sendSwap.thisID = m_obj.m_object.thisID;
					sendSwap.dst.heroid = heroID;
					sendSwap.dst.location = stObjLocation.determineEquationLocation(heroID);
					sendSwap.dst.x = 0;
					sendSwap.dst.y = ZObjectDef.typeToEquipPos(m_obj.type)
					m_gkcontext.sendMsg(sendSwap);
					
					var pack:Package = m_gkcontext.m_objMgr.getEquipPakage(heroID);
					var objDest:ZObject = pack.getObject(sendSwap.dst.x, sendSwap.dst.y);
					if (objDest)
					{
						m_gkcontext.m_contentBuffer.addContent("uiHintMgr.subform_ChangeEquip", objDest.m_object.thisID);
					}
					
				}
			}
			exit();		
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			m_gkcontext.m_uiTip.hideTip();
		}
		protected function onMouseOver(event:MouseEvent):void
		{
			if (event.currentTarget is ObjectPanel)
			{
				var panel:ObjectPanel = event.currentTarget as ObjectPanel;
				var pt:Point = panel.localToScreen();
				
				var obj:ZObject = panel.objectIcon.zObject;
				if (obj != null)
				{					
					m_gkcontext.m_uiTip.hintObjectInfo(pt, obj);
				}
			}
		}
	}

}