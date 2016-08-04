package game.ui.uibackpack.wujiang 
{
	import com.bit101.components.ButtonImageText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.progressBar.BarInProgress2;
	import com.dgrigg.image.CommonImageManager;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.commonfuntion.ConfirmDialogMgr;
	import modulecommon.GkContext;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.wu.TrainAttr;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.scene.wu.YuanqiDan;
	import com.util.UtilColor;
	import game.ui.uibackpack.msg.stHeroTrianingCmd;
	import game.ui.uibackpack.tips.TrainTip;
	/**
	 * ...
	 * @author ...
	 */
	public class SubTrain extends SubBase
	{
		private var m_allWP:AllWuPanel;
		private var m_halfPanel:PanelContainer;	//半身像
		private var m_nameLabel:Label2;	//名字
		private var m_jobLabel:Label2;	//职业
		private var m_levelLabel:Label;		//等级
		private var m_addExpLbabel:Label;	//增加经验
		private var m_payCostLabel:Label;	//花费银币
		private var m_objPanel:ObjectPanel;	//元气丹
		private var m_expBar:BarInProgress2;//经验条
		private var m_propvalue:Label;	//当前等级增加属性值
		private var m_trainAttr:TrainAttr;
		private var m_dan:YuanqiDan;
		private var m_trainBtn:ButtonImageText;
		private var m_highTrainBtn:ButtonImageText;
		private var m_danNum:uint;
		private var m_tip:TrainTip;
		private var m_exp:uint;
		private var m_expTotal:uint;
		private var m_expTotalOld:uint;
		
		public function SubTrain(allPanel:AllWuPanel, parent:DisplayObjectContainer, gk:GkContext, wu:WuProperty)
		{
			super(allPanel, parent, gk);
			m_wu = wu;
			m_allWP = allPanel;
			
			m_trainAttr = m_gkContext.m_wuMgr.getTrainAttrByLevel(m_wu.m_trainLevel);
			
			m_halfPanel = new PanelContainer(this, 2, 0);
			m_halfPanel.setPanelImageSkin(m_wu.halfingPathName);
			
			m_nameLabel = new Label2(this, 10, 10);
			m_jobLabel = new Label2(this, 210, 8);
			
			var lf:LabelFormat = new LabelFormat();
			lf.fontName = "STXINWEI";
			lf.size = 20;
			if (m_wu.isMain)
			{
				lf.color = 0xeeeeee;
			}
			else
			{
				lf.color = (m_wu as WuHeroProperty).colorValue;
			}
			lf.text = m_wu.fullName;
			m_nameLabel.labelFormat = lf;
			
			lf.color = UtilColor.WHITE_Yellow;
			lf.fontName = null;
			lf.size = 12;
			lf.text = PlayerResMgr.toJobName(m_wu.m_uJob);
			m_jobLabel.labelFormat = lf;
			
			m_expBar = new BarInProgress2(this, 6, 266);
			m_expBar.setSize(232, 7);
			m_expBar.autoSizeByImage = false;
			m_expBar.setPanelImageSkin("commoncontrol/panel/backpack/train/bar.png");
			m_expBar.maximum = 1;
			var v:Number = m_wu.m_trainPower / m_trainAttr.m_maxpower;
			m_expBar.initValue = v;
			
			m_levelLabel = new Label(this, 106, 260, "", UtilColor.WHITE_Yellow);
			
			var label:Label;
			label = new Label(this, 6, 263);
			label.setSize(232, 12)
			label.mouseEnabled = true;
			label.drawRectBG();
			label.addEventListener(MouseEvent.ROLL_OVER, onMouseOverExpBar);
			label.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
			
			m_objPanel = new ObjectPanel(m_gkContext, this, 12, 286);
			m_objPanel.setSize(ZObject.IconBgSize, ZObject.IconBgSize);
			m_objPanel.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			m_objPanel.addEventListener(MouseEvent.ROLL_OUT, m_gkContext.hideTipOnMouseOut);
			
			label = new Label(this, 72, 286, "培养增加经验：", UtilColor.WHITE_Yellow);
			label = new Label(this, 72, 312, "银币消耗：", UtilColor.WHITE_Yellow); 
			
			m_addExpLbabel = new Label(this, 160, 287, "", UtilColor.GREEN);
			m_payCostLabel = new Label(this, 156, 313, "", UtilColor.GREEN);
			
			var panel:Panel;
			panel = new Panel(this, 134, 314);
			panel.setPanelImageSkin("commoncontrol/panel/gamemoney.png");
			
			m_propvalue = new Label(this, 85, 244, "", UtilColor.GOLD);
			m_propvalue.setSize(40, 12)
			
			m_trainBtn = new ButtonImageText(this, 129, 349, onTrainBtn);
			m_trainBtn.autoSizeByImage = false;
			m_trainBtn.setSize(85,30);
			m_trainBtn.setPanelImageSkin("commoncontrol/button/button5_mirror.swf");
			m_trainBtn.setImageText("commoncontrol/panel/backpack/train/train.png");
			m_trainBtn.tag = 0;
			
			m_highTrainBtn = new ButtonImageText(this, 23, 349, onTrainBtn);
			m_highTrainBtn.autoSizeByImage = false;
			m_highTrainBtn.setSize(85,30);
			m_highTrainBtn.setPanelImageSkin("commoncontrol/button/button5_mirror.swf");
			m_highTrainBtn.setImageText("commoncontrol/panel/backpack/train/highTrain.png");
			m_highTrainBtn.tag = 1;
		}
		
		override public function draw():void
		{
			super.draw();
			update();
		}
		
		override public function onShow():void
		{
			update();
		}
		
		override public function update():void
		{
			m_trainAttr = m_gkContext.m_wuMgr.getTrainAttrByLevel(m_wu.m_trainLevel);
			m_dan = m_gkContext.m_wuMgr.getNeedYuanqidan(m_wu.m_trainLevel);
			
			m_levelLabel.text = m_wu.trainLevel + "级";
			m_propvalue.text = TrainAttr.getStrAddAttr(m_trainAttr.m_proptype) + " +" + m_trainAttr.m_propvalue;
			m_payCostLabel.text = m_trainAttr.m_cost.toString();
			
			if (m_dan)
			{
				m_danNum = m_gkContext.m_objMgr.computeObjNumInCommonPackage(m_dan.m_id);
				if (0 == m_danNum)
				{
					m_objPanel.objectIcon.showNum = false;
					m_objPanel.becomeGray();
				}
				else
				{
					m_objPanel.objectIcon.showNum = true;
					m_objPanel.becomeUnGray();
				}
				var obj:ZObject = ZObject.createClientObject(m_dan.m_id, m_danNum);
				if (obj)
				{
					m_objPanel.objectIcon.setZObject(obj);
					m_addExpLbabel.text = (obj.m_ObjectBase.m_iShareData1 * m_danNum).toString();
				}
			}
		}
		
		override public function onShowThisWu():void
		{
			m_allWu.m_wuTrainSubBg.show(m_halfPanel);			
		}
		
		public function updateTraniData():void
		{
			update();
			updateExpCount();
		}
		
		private function onMouseRollOver(event:MouseEvent):void
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
		
		private function onMouseOverExpBar(event:MouseEvent):void
		{
			var pt:Point = m_gkContext.m_context.mouseScreenPos();
			var tempTip:TrainTip = tip;
			tempTip.showTip(m_wu.trainLevel, m_wu.m_trainPower);
			m_gkContext.m_uiTip.hintComponent(pt, tempTip);
		}
		
		private function get tip():TrainTip
		{
			if (null == m_tip)
			{
				m_tip = new TrainTip(m_gkContext);
			}
			return m_tip;
		}
		
		override public function dispose():void 
		{
			if (m_tip != null)
			{
				if (m_tip.parent)
				{
					m_tip.parent.removeChild(m_tip);
				}
				
				m_tip.dispose();
				m_tip = null;
			}
			super.dispose();
		}
		
		private function onTrainBtn(event:MouseEvent):void
		{
			var btn:ButtonImageText = event.currentTarget as ButtonImageText;
			var desc:String;
			var radio:Object = new Object();
			radio[ConfirmDialogMgr.RADIOBUTTON_select] = false;
			radio[ConfirmDialogMgr.RADIOBUTTON_desc] = "不再询问";
			
			if (0 == m_danNum)
			{
				if (!m_gkContext.m_wuMgr.bQueryFastTrain)
				{
					desc = "当前您的元气丹不足，可每次花费 " + m_dan.m_yuanbao + "元宝 快速修炼。";
					m_gkContext.m_confirmDlgMgr.showMode1(0, desc, ConfirmFastTrainFn, null, "确认", "取消", radio);
				}
				else
				{
					ConfirmFastTrainFn();
				}
			}
			else
			{
				switch(btn.tag)
				{
					case 1:
						{
							if (!m_gkContext.m_wuMgr.bQueryHighTrain)
							{
								desc = "是否需要扣除 元宝？";
								m_gkContext.m_confirmDlgMgr.showMode1(0, desc, ConfirmTrainFn, null, "确认", "取消", radio);
							}
							else
							{
								ConfirmTrainFn();
							}
						}
						break;
					case 0:
						sendMsgToStartTrain(m_wu.m_uHeroID, 0, objectThisID);
						break;
				}
			}
		}
		
		//快速培养
		private function ConfirmFastTrainFn():Boolean
		{
			if (m_gkContext.m_confirmDlgMgr.isRadioButtonCheck())
			{
				m_gkContext.m_wuMgr.bQueryFastTrain = true;
			}
			
			sendMsgToStartTrain(m_wu.m_uHeroID, 0, 0);
			return true;
		}
		
		//高级培养
		private function ConfirmTrainFn():Boolean
		{
			if (m_gkContext.m_confirmDlgMgr.isRadioButtonCheck())
			{
				m_gkContext.m_wuMgr.bQueryHighTrain = true;
			}
			
			sendMsgToStartTrain(m_wu.m_uHeroID, 1, objectThisID);
			return true;
		}
		
		private function sendMsgToStartTrain(id:uint, type:uint, fastxiulian:uint):void
		{
			var cmd:stHeroTrianingCmd = new stHeroTrianingCmd();
			cmd.m_heroid = id;
			cmd.m_type = type;
			cmd.m_fastXiulian = fastxiulian;
			
			m_gkContext.sendMsg(cmd);
		}
		
		private function get objectThisID():uint
		{
			var list:Array = m_gkContext.m_objMgr.getObjThisIdListByID(m_objPanel.objectIcon.zObject.ObjID);
			return list[0];
		}
		
		//经验条显示更新
		private function updateExpCount():void
		{
			m_exp = m_wu.m_trainPower;
			m_expTotal = m_trainAttr.m_maxpower;
			
			if (m_expTotalOld && m_exp < m_expTotalOld)
			{
				m_expBar.setAniEndCallBack(updateExpToNextLevel);
				m_expBar.value = 1;
			}
			else
			{
				m_expBar.setAniEndCallBack(null);
				if (m_expBar.value)
				{
					m_expBar.value = m_exp / m_expTotal;
				}
				else
				{
					m_expBar.initValue = m_exp / m_expTotal;
				}
			}
			m_expTotalOld = m_exp;
		}
		
		private function updateExpToNextLevel():void
		{
			m_expBar.initValue = 0;
			m_expBar.value = m_wu.m_trainPower / m_trainAttr.m_maxpower;
			m_expBar.setAniEndCallBack(null)
		}
		
	}

}