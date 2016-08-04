package game.ui.uiHintMgr.addobject 
{
	import com.ani.AniPropertys;
	import com.bit101.components.ButtonText;
	import com.bit101.components.PanelShowAndHide;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.net.msg.propertyUserCmd.stSwapObjectPropertyUserCmd;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.Package;
	import modulecommon.scene.prop.object.stObjLocation;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilTools;
	import game.ui.uiHintMgr.HintTool;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class TopPart extends PanelShowAndHide 
	{
		private var m_gkContext:GkContext;
		private var m_objPanel:ObjectPanel;
		private var m_btn:ButtonText;
		private var m_obj:ZObject;
		private var m_ani:AniPropertys;
		private var m_ui:UIHintAddObjectAni;
		public function TopPart(gk:GkContext, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number =  0) 
		{
			m_gkContext = gk
			super(parent, xpos, ypos);
			m_ui = parent as UIHintAddObjectAni;
			m_objPanel = new ObjectPanel(m_gkContext,this,-23,-29);
			m_objPanel.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
			m_objPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			
			m_btn = new ButtonText(this, -28, 22, "穿上", onEquip);
			m_btn.setSkinButton1Image("commoncontrol/button/redbtn.png");
			m_ani = new AniPropertys();
			m_ani.sprite = this;
			m_ani.duration = 0.8;
			m_ani.resetValues( {alpha:1 } );
		}
		
		public function beginAni():void
		{
			this.alpha = 0;
			m_ani.begin();	
			this.show();
		}
		public function addObject(obj:ZObject):void
		{
			m_obj = obj;
			m_objPanel.objectIcon.setZObject(obj);
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
					m_gkContext.m_uiTip.hintObjectInfo(pt, obj);
				}
			}
		}
		
		public function onEquip(e:MouseEvent):void
		{
			//var strLog:String="点击床上";
			var pak:Object = m_gkContext.m_objMgr.getPackageAndObjectByThisID(m_obj.thisID);
			if (pak && m_obj.isInCommonPackage)
			{
				var heroID:uint = HintTool.getHeroIDWithInferiorEquip(m_gkContext, m_obj);
				if (heroID)
				{
					var sendSwap:stSwapObjectPropertyUserCmd = new stSwapObjectPropertyUserCmd();
					sendSwap.thisID = m_obj.m_object.thisID;
					sendSwap.dst.heroid = heroID;
					sendSwap.dst.location = stObjLocation.determineEquationLocation(heroID);
					sendSwap.dst.x = 0;
					sendSwap.dst.y = ZObjectDef.typeToEquipPos(m_obj.type)
					m_gkContext.sendMsg(sendSwap);
					
					var pack:Package = m_gkContext.m_objMgr.getEquipPakage(heroID);
					var objDest:ZObject = pack.getObject(sendSwap.dst.x, sendSwap.dst.y);
					
					
					if (objDest)
					{
						m_gkContext.m_contentBuffer.addContent("uiHintMgr.subform_ChangeEquip", objDest.m_object.thisID);
					}
					
					var wu:WuProperty=m_gkContext.m_wuMgr.getWuByHeroID(heroID);
					var str:String = wu.fullName+" ";
					str += "装备了 " + m_obj.name;
					m_gkContext.m_systemPrompt.prompt(str);
					
					//UtilTools.keyValueToString();
					//strLog += "--将" + m_obj.m_object.name + m_obj.m_object.thisID+"("+UtilTools.keyValueToString("heroid",sendSwap.dst.heroid,"location",sendSwap.dst.location,"x",sendSwap.dst.x,"y",sendSwap.dst.y)+")";
					
				}
				//strLog += "给" + heroID + "穿上";
			}
			//m_gkContext.addLog(strLog);
			m_ui.exit();
		}
		
	}

}