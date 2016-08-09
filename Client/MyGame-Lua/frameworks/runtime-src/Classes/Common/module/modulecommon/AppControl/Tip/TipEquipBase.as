package modulecommon.appcontrol.tip
{
	import com.bit101.components.Label;
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	//import com.bit101.components.Panel;
	//import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import modulecommon.appcontrol.AttrStrip;
	import modulecommon.scene.prop.object.GemIcon;
	import modulecommon.scene.prop.object.SmallAttrData;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.GkContext;
	import flash.display.DisplayObjectContainer;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TEnchUpperItem;
	import modulecommon.scene.prop.table.TObjectBaseItem;
	import modulecommon.scene.prop.table.TEquipXilianItem;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.appcontrol.TipBase;
	
	/**
	 * ...
	 * @author
	 */
	public class TipEquipBase extends TipBase
	{
		protected var m_nameLabel:Label;
		protected var m_enhanceMaxLevel:Label;
		protected var m_score:Label;
		protected var m_attrStrip:AttrStrip;
		protected var m_baseAttr:TextNoScroll
		protected var m_saleLabel:Label;
		protected var m_gemPanel:Vector.<GemIcon>;
		public function TipEquipBase(gk:GkContext, parent:DisplayObjectContainer = null)
		{
			super(gk, parent);
			
			m_nameLabel = new Label(this, 12, 14);
			m_nameLabel.setFontSize(14);
			m_nameLabel.setBold(true);
			m_enhanceMaxLevel = new Label(this, 12, 34);
			m_score = new Label(this, 180, 34);
			
			m_saleLabel = new Label(this, 12, 40); m_saleLabel.setFontColor(0xcccccc);
			
			m_attrStrip = new AttrStrip(this, 4, 55);
			m_attrStrip.setSize(266 - 8, 63);
			
			m_baseAttr = new TextNoScroll();
			m_baseAttr.x = 10;
			m_baseAttr.y = 5;
			m_baseAttr.width = 200;
			m_baseAttr.setCSS("body", {leading: 3, letterSpacing: 1});
			m_attrStrip.addChild(m_baseAttr);
			this.width = 266;
			m_gemPanel=new Vector.<GemIcon>(4,true);
			
		}
		
		public function showTip(obj:ZObject):void
		{
			var str:String;
			var offsetY:int;
			
			m_nameLabel.setFontColor(obj.colorValue);
						
			str = obj.name;
			if (m_gkContext.versonForOut == false)
			{
				str += "  " + obj.ObjID;
			}
			
			m_nameLabel.text = str;
			
			var enchUpperItem:TEnchUpperItem;
			if (obj.iconColor > 0)
			{
				enchUpperItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_EQUIPQHUPPER, obj.enchUpperID) as TEnchUpperItem;
			}
			
			m_score.y = 34;
			m_attrStrip.y = 58;
			if (enchUpperItem && enchUpperItem.m_upperLimit > 0)
			{
				str = "( 可强化至 " + enchUpperItem.m_upperLimit.toString() + " )";				
				m_attrStrip.y = 58;						
			}
			else
			{
				str = "( 不可强化 )";
			}
			m_enhanceMaxLevel.text = str;
			
			m_score.visible = true;
			m_score.text = "评价 " + obj.m_object.m_equipData.equipmark;
			
			m_baseAttr.htmlText = printBaseAttrs(obj);
		
			m_baseAttr.y = (m_attrStrip.height - (m_baseAttr.height - 16)) / 2;
			
			offsetY = m_attrStrip.y + m_attrStrip.height;
			offsetY += 10;
			if (obj.m_object.m_equipData.smallAttrs)
			{
				offsetY = printsmalAttrs(obj, offsetY);
				offsetY += 10;
			}
			
			if (obj.numSlot)
			{
				offsetY = printGem(obj, offsetY);
			}			
			
			m_saleLabel.text = "售价 " + obj.price_GameMoney + " 银币";	
			m_saleLabel.flush();
			m_saleLabel.y = offsetY;
			offsetY += 20;
			
			m_saleLabel.x = this.width - m_saleLabel.width - 20;
			m_saleLabel.visible = true;
			
			this.height = offsetY + 10;
		}
		
		//是否显示售价
		public function showSaleLabel(bool:Boolean = true):void
		{
			m_saleLabel.visible = bool;
		}
		
		protected function printBaseAttrs(obj:ZObject):String
		{
			var str:String;
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("<body>");
			str = "所需等级  " + obj.needLevel + "级";
			UtilHtml.add(str, UtilColor.WHITE);
			UtilHtml.breakline();
			var value:int = obj.equipBaseAttrValue;
			if (obj.isWeapon)
			{
				str = "物理攻击  " + value;
				UtilHtml.add(str, UtilColor.WHITE);
				if (obj.m_object.m_equipData.basePropEnhance > 0)
				{
					str = " +" + obj.m_object.m_equipData.basePropEnhance;
					UtilHtml.add(str, UtilColor.GREEN);
				}
				UtilHtml.breakline();
				
				str = "策略攻击  " + value;
				UtilHtml.add(str, UtilColor.WHITE);
				if (obj.m_object.m_equipData.basePropEnhance > 0)
				{
					str = " +" + obj.m_object.m_equipData.basePropEnhance;
					UtilHtml.add(str, UtilColor.GREEN);
				}
				UtilHtml.breakline();
			}
			else
			{
				str = ZObjectDef.baseAttrTypeToName(obj.equipBaseAttrType);				
				
				str += "  "+value;
				UtilHtml.add(str, UtilColor.WHITE);
				if (obj.m_object.m_equipData.basePropEnhance > 0)
				{
					str = " +" + obj.m_object.m_equipData.basePropEnhance;
					UtilHtml.add(str, UtilColor.GREEN);
				}
				UtilHtml.breakline();
			}
			UtilHtml.addStringNoFormat("</body>");
			return UtilHtml.getComposedContent();
		}
		
		protected function printsmalAttrs(obj:ZObject, offsetY:int):int
		{
			var base:TEquipXilianItem;
			var col:Number;
			var smalAttrs:Vector.<SmallAttrData> = obj.m_object.m_equipData.smallAttrs;
			var label:Label2;
			var lf:LabelFormat;
			var str:String;		
			var i:int;
			var sad:SmallAttrData;
			lf = new LabelFormat();
			lf.size = 12;
			
			for (i = 0; i < smalAttrs.length; i++)
			{
				
				sad = smalAttrs[i];
				label = addUsedCtrol(Label2) as Label2;
				label.setPos(14, offsetY  - 3);
				if (sad.m_type != 0)
				{
					base = m_gkContext.m_dataTable.getItem(DataTable.TABLE_EQUIP_XILIAN, (sad.m_type + 1000 * obj.needLevel)) as TEquipXilianItem;
					col =  sad.m_value / base.m_uplimit;
					if (col <= .3)
					{
						lf.color = UtilColor.GREEN;
					}
					else if (col <= .6)
					{
						lf.color = UtilColor.BLUE;
					}
					else if (col <= .9)
					{
						lf.color = UtilColor.PURPLE;
					}
					else
					{
						lf.color = UtilColor.GOLD;
					}
					str = smallAttrName(sad.m_type) + " +" + sad.m_value+"（上限"+base.m_uplimit+"）";
				}
				else
				{
					lf.color = UtilColor.RED;
					str = "< 洗练属性未解锁 >";
				}
				label.labelFormat = lf;
				label.text = str;
				offsetY += 17;
			}
			return offsetY;
		}
		private function getGemPanel(i:int):GemIcon
		{
			var panel:GemIcon = m_gemPanel[i];
			if (panel == null)
			{
				panel = new GemIcon(m_gkContext);
				m_gemPanel[i] = panel;
				this.addChild(panel);
			}
			return panel;
		}
		
		/*
		 * bForColorAdvance:颜色进阶装备的预览
		 */ 
		protected function printGem(obj:ZObject, offsetY:int, bForColorAdvance:Boolean=false):int
		{
			var panel:GemIcon;
			var label:Label2;
			var i:int;
			var imageStr:String;
			var base:TObjectBaseItem;
			var gemID:uint;		
			var numSlot:int = obj.numSlot;
			var lf:LabelFormat = new LabelFormat();			
			
			for (i = 0; i < numSlot; i++)
			{
				panel = getGemPanel(i);
				panel.visible = true;
				panel.setPos(14, offsetY - 5);
				panel.autoSizeByImage = false;
				panel.setSize(20, 20);
				label = addUsedCtrol(Label2) as Label2;
				label.setPos(39, offsetY -3);
				
				gemID = obj.getGemID(i);				
				
				if (gemID == 0)
				{
					if (bForColorAdvance && i==numSlot-1)
					{
						lf.color = UtilColor.RED;
						lf.text = "< 新宝石孔 >";
					}
					else
					{
						lf.color = UtilColor.WHITE_B;
						lf.text = "未镶嵌";
					}
				}
				else
				{
					base = m_gkContext.m_dataTable.getItem(DataTable.TABLE_OBJECT, gemID) as TObjectBaseItem;
					if (base == null)
					{
						continue;
					}
					
					lf.text = ZObjectDef.gemAttrName(base.m_iShareData2) + "+" + base.m_iShareData1+"（"+base.m_iLevel+ "级）";
					lf.color = UtilColor.GOLD;
				}
				
				panel.setGemID(gemID);
				label.labelFormat = lf;
				offsetY += 20;
				
			}
			for (; i < 4; i++)
			{
				if (m_gemPanel[i])
				{
					m_gemPanel[i].visible = false;
				}
			}
			
			return offsetY;
		}
		
		public static function smallAttrName(type:int):String
		{
			var ret:String;
			switch (type)
			{
				case ZObjectDef.XLPROP_PHYDAM: 
					ret = "物理攻击";
					break;
				case ZObjectDef.XLPROP_STRATEGYDAM: 
					ret = "策略攻击";
					break;
				case ZObjectDef.XLPROP_ZFDAM: 
					ret = "技能攻击";
					break;
				case ZObjectDef.XLPROP_PHYDEF: 
					ret = "物理防御";
					break;
				case ZObjectDef.XLPROP_STRATEGYDEF: 
					ret = "策略防御";
					break;
				case ZObjectDef.XLPROP_ZFDEF: 
					ret = "技能防御";
					break;
				case ZObjectDef.XLPROP_HPLIMIT: 
					ret = "兵力";
					break;
				case ZObjectDef.XLPROP_BAOJI: 
					ret = "暴击";
					break;
				case ZObjectDef.XLPROP_BJDEF: 
					ret = "防暴击";
					break;
				case ZObjectDef.XLPROP_POJI: 
					ret = "破击";
					break;
				case ZObjectDef.XLPROP_GEDANG: 
					ret = "运气"; //格挡
					break;
				case ZObjectDef.XLPROP_ATTACKSPEED: 
					ret = "出手速度";
					break;
				case ZObjectDef.XLPROP_FORCE: 
					ret = "武力";
					break;
				case ZObjectDef.XLPROP_IQ: 
					ret = "智力";
					break;
				case ZObjectDef.XLPROP_CHIEF: 
					ret = "统率";
					break;
			}
			return ret;
		}
	
	}

}