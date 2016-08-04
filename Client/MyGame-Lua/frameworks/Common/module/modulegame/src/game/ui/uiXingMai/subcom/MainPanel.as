package game.ui.uiXingMai.subcom 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.skill.SkillIcon;
	import modulecommon.scene.xingmai.AttrData;
	import modulecommon.scene.xingmai.ItemSkill;
	import modulecommon.scene.xingmai.OpenSkill;
	import com.util.UtilColor;
	import game.ui.uiXingMai.tip.TipNextActSkill;
	import game.ui.uiXingMai.UIXingMai;

	/**
	 * ...
	 * @author 
	 */
	public class MainPanel extends Component 
	{
		private var m_gkContext:GkContext;
		private var m_uiXingMai:UIXingMai;
		//private var m_xlValue:Label;		//星力值
		private var m_jhValue:Label;		//将魂值
		private var m_vecAttrItem:Vector.<AttrItem>;
		private var m_itemSkill:ItemSkill;
		private var m_willActSkill:SkillIcon;	//下一个开启技能
		private var m_usingSkill:SkillIcon;		//使用中技能
		private var m_tipNextActSkill:TipNextActSkill;	//下一个将开启技能Tips
		private var m_bWillActSkill:Boolean = false;	//下个将开启技能是否已开放
		private var m_promptLabel:Label;
		
		public function MainPanel(gk:GkContext, uiXingmai:UIXingMai, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_uiXingMai = uiXingmai;
			
			initData();
		}
		
		private function initData():void
		{
			//var label:Label;
			//label = new Label(this, 0, 30, "觉醒提升战力：", UtilColor.GOLD, 14);
			
			m_jhValue = new Label(this, 54, 0, "", UtilColor.WHITE, 18);
			m_jhValue.setBold(true);
			//m_xlValue = new Label(this, 25, 56);
			
			m_promptLabel = new Label(this, 606, 365, "", UtilColor.WHITE_Yellow);
			m_promptLabel.align = Component.RIGHT;
			
			m_vecAttrItem = new Vector.<AttrItem>(6);
			
			var vecpoint:Vector.<Point> = new Vector.<Point>(6);
			vecpoint[0] = new Point(80, 270); vecpoint[1] = new Point(75, 145); vecpoint[2] = new Point(155, 50);
			vecpoint[3] = new Point(395, 50); vecpoint[4] = new Point(465, 145); vecpoint[5] = new Point(460, 270);
			
			var vecAttr:Vector.<AttrData> = m_gkContext.m_xingmaiMgr.vecAttrDatas;
			for (var i:int = 0; i < 6; i++)
			{
				m_vecAttrItem[i] = new AttrItem(m_gkContext, m_uiXingMai, this, vecpoint[i].x, vecpoint[i].y);
				if (vecAttr && vecAttr[i])
				{
					m_vecAttrItem[i].setData(vecAttr[i]);
				}
			}
			
			m_willActSkill = new SkillIcon(m_gkContext);
			this.addChild(m_willActSkill);
			m_willActSkill.showNum = false;
			m_willActSkill.setPos(285, 340);
			m_willActSkill.buttonMode = true;
			m_willActSkill.addEventListener(MouseEvent.ROLL_OVER, onWillActSkillRollOver);
			m_willActSkill.addEventListener(MouseEvent.ROLL_OUT, onSkillRollOut);
			
			updateWillActSkill();
			
			m_usingSkill = new SkillIcon(m_gkContext);
			this.addChild(m_usingSkill);
			m_usingSkill.setPos(475, 426);
			m_usingSkill.buttonMode = true;
			m_usingSkill.addEventListener(MouseEvent.ROLL_OVER, onUsingSkillRollOver);
			m_usingSkill.addEventListener(MouseEvent.ROLL_OUT, onSkillRollOut);
			
			updateUsingSkill();
		}
		
		public function updateXingLi(xingli:uint):void
		{
			//m_xlValue.text = xingli.toString();
		}
		
		public function updateJiangHun(jianghun:uint):void
		{
			m_jhValue.text = jianghun.toString();
			
			for (var i:int = 0; i < m_vecAttrItem.length; i++)
			{
				m_vecAttrItem[i].updateData();
			}
		}
		
		//更新属性等级
		public function updateAttrLevel(id:uint):void
		{
			for each(var item:AttrItem in m_vecAttrItem)
			{
				if (item.id == id)
				{
					item.updateLevel();
					break;
				}
			}
		}
		
		public function updateWillActSkill():void
		{
			var skillid:uint = m_gkContext.m_xingmaiMgr.willActXMSkillID;
			
			m_willActSkill.setSkillID(skillid);
			
			if (skillid == m_gkContext.m_xingmaiMgr.lastActXMSkillID)
			{
				m_promptLabel.text = "";
				
				m_willActSkill.becomeUnGray();
				m_bWillActSkill = true;
			}
			else
			{
				var openskill:OpenSkill = m_gkContext.m_xingmaiMgr.getOpenSkill(skillid);
				m_promptLabel.text = "所有觉醒等级达到 " + openskill.m_attrlevel + " 级，开启新技能";
				
				m_willActSkill.becomeGray();
				m_bWillActSkill = false;
			}
		}
		
		public function updateUsingSkill():void
		{
			var usingSkillID:uint = m_gkContext.m_xingmaiMgr.curUsingXMSkillID;
			if (usingSkillID && m_gkContext.m_xingmaiMgr.actSkillsList.length)
			{
				m_usingSkill.setSkillID(usingSkillID);
			}
		}
		
		private function onWillActSkillRollOver(event:MouseEvent):void
		{
			var pt:Point = m_willActSkill.localToScreen(new Point(43, -5));
			
			if (null == m_tipNextActSkill)
			{
				m_tipNextActSkill = new TipNextActSkill(m_gkContext);
			}
			
			m_tipNextActSkill.showTip(m_willActSkill.skillID, m_bWillActSkill);
			m_gkContext.m_uiTip.hintComponent(pt, m_tipNextActSkill);
			
			m_gkContext.m_objMgr.showObjectMouseOverPanel(m_willActSkill, -7, -7);
		}
		
		private function onUsingSkillRollOver(event:MouseEvent):void
		{
			var pt:Point = m_usingSkill.localToScreen(new Point(43, -5));
			
			m_gkContext.m_uiTip.hintSkillInfo(pt, m_usingSkill.skillID);
			m_gkContext.m_objMgr.showObjectMouseOverPanel(m_usingSkill, -7, -7);
		}
		
		private function onSkillRollOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
			m_gkContext.m_objMgr.hideObjectMouseOverPanel(m_willActSkill);
		}
		
		override public function dispose():void
		{
			if (m_tipNextActSkill)
			{
				m_tipNextActSkill.dispose();
			}
			
			super.dispose();
		}
		
		public function onShowNewHand():void
		{
			if (SysNewFeatures.NFT_XINGMAI == m_gkContext.m_sysnewfeatures.m_nft)
			{
				m_gkContext.m_newHandMgr.setFocusFrame(-15, -15, 94, 94, 1);
				m_gkContext.m_newHandMgr.prompt(true, 0, 80, "点击，提升觉醒属性等级", m_vecAttrItem[0]);
			}
		}
	}

}