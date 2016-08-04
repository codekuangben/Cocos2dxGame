package game.ui.uibackpack.subForm.fastZhuansheng
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.util.UtilColor;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.net.msg.sceneHeroCmd.ActiveHero;
	import modulecommon.net.msg.sceneHeroCmd.stReqRebirthCmd;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.ui.UIFormID;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TWuPropertyItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.wu.WuProperty;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import flash.events.MouseEvent;
	import com.bit101.components.ButtonText;
	import modulecommon.ui.FormConfirmBase;
	
	/**
	 * ...
	 * @author
	 */
	public class UIFastZhuansheng extends FormConfirmBase
	{
		protected var m_mgr:FastZhuanshengMgr;
		protected var m_mainWu:WuHeroProperty;
		private var m_wuIcon:Panel;
		private var m_list:Vector.<ItemNeedBase>;
		private var m_shengeLabel:Label;		//所需神格
		
		public function UIFastZhuansheng(mgr:FastZhuanshengMgr)
		{
			m_mgr = mgr;
			draggable = false;
		}
		
		override public function onReady():void
		{
			super.onReady();
			m_title.text = "快速转生";
			m_wuIcon = new Panel(this, 50, 55);
			m_wuIcon.setSize(WuProperty.SQUAREHEAD_WIDHT, WuProperty.SQUAREHEAD_HEIGHT);
			m_wuIcon.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			m_wuIcon.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			
			m_confirmBtn.label = "转生";
			m_confirmBtn.x = 72;
			m_cancelBtn.label = "取消";
			m_cancelBtn.x = 224;
			m_tf.x = 115;
			this.width = 400;
			this.setSkinGrid9Image9(ResGrid9.StypeSix);
		}
		
		public function zhuanshengWu(wu:WuHeroProperty):void
		{
			m_mainWu = wu;
			
			var iconRes:String;
			iconRes = NpcBattleBaseMgr.composeSquareHeadResName((m_mainWu as WuHeroProperty).m_npcBase.m_squareHeadName);
			m_wuIcon.setPanelImageSkin(iconRes);
			
			var str:String;
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("快速转生");
			UtilHtml.add(m_mainWu.fullName, m_mainWu.colorValue, 14);
			UtilHtml.addStringNoFormat("需消耗：");
			
			m_tf.htmlText = "<body>" + UtilHtml.getComposedContent() + "</body>";
			
			var dic:Dictionary = needList(m_mainWu);
			createList(dic);
			this.update();
		}
		
		override public function onDestroy():void
		{
			m_gkcontext.m_dynamicFormIDAllocator.retrieve(this.id);
			m_mgr.onDestroyForm(this);
			super.onDestroy();
		}
		
		override public function onStageReSize():void
		{
			super.onStageReSize();
			this.darkOthers();
		}
		
		public function createList(content:Dictionary):void
		{
			if (m_list == null)
			{
				m_list = new Vector.<ItemNeedBase>();
			}
			
			var left:Number;
			var leftFirstColumn:Number = 144;
			var leftSecondColumn:Number = leftFirstColumn + 100;
			var top:Number = 90;
			var intervalVertical:Number = 25;
			var bSecondColumn:Boolean;
			var itemShenhun:ItemNeedShenhun;
			var itemWu:ItemNeedWu;
			if (content[WuProperty.COLOR_GREEN] != undefined)
			{
				itemShenhun = new ItemNeedShenhun(m_gkcontext, this, leftFirstColumn, top);
				itemShenhun.setShenhun(content[WuProperty.COLOR_GREEN], WuProperty.COLOR_GREEN);
				m_list.push(itemShenhun);
				bSecondColumn = true;
			}
			
			if (content[WuProperty.COLOR_BLUE] != undefined)
			{
				if (bSecondColumn)
				{
					left = leftSecondColumn;
				}
				else
				{
					left = leftFirstColumn;
				}
				itemShenhun = new ItemNeedShenhun(m_gkcontext, this, left, top);
				itemShenhun.setShenhun(content[WuProperty.COLOR_BLUE], WuProperty.COLOR_BLUE);
				m_list.push(itemShenhun);
			}
			if (m_list.length > 0)
			{
				top += intervalVertical;
			}
			
			var wuList:Array;
			if (content["list"] != undefined)
			{
				wuList = content["list"];
			}
			
			if (wuList == null)
			{
				
			}
			else
			{
				var i:int;
				var add:int = m_mainWu.add;
				
				left = leftFirstColumn;
			
				for (i = 0; i < wuList.length; i++)
				{
					
					itemWu = new ItemNeedWu(m_gkcontext,m_mgr, this, left, top);
					itemWu.setHeroID(WuHeroProperty.composeWuID(wuList[i], add));
					m_list.push(itemWu);
					top += intervalVertical;
					
				}				
			}
			
			if (WuHeroProperty.Add_Xian == m_mainWu.add)
			{
				if (null == m_shengeLabel)
				{
					m_shengeLabel = new Label(this, 144, 0);
				}
				
				var money:int = m_mainWu.m_wuPropertyBase.m_shenge;
				var nShenge:int = m_gkcontext.m_objMgr.computeObjNumInCommonPackage(ZObjectDef.OBJID_shenge);
				var color:uint;
				
				UtilHtml.beginCompose();
				UtilHtml.add(UtilHtml.formatBold("神格 "), UtilColor.GOLD, 14);
				if (nShenge >= money)
				{
					color = UtilColor.GREEN;
				}
				else
				{
					color = UtilColor.RED;
				}
				UtilHtml.add("x " + money.toString(), color, 15);
				m_shengeLabel.htmlText = UtilHtml.getComposedContent();
				
				m_shengeLabel.y = top;
				top += 10;
			}
			else
			{
				if (m_shengeLabel)
				{
					m_shengeLabel.visible = false;
				}
			}
			
			top += 25;
			m_confirmBtn.y = top;
			m_cancelBtn.y = m_confirmBtn.y;
			
			top += 70;
			if (top < 199)
			{
				top = 199;
			}
			this.height = top;
			
			this.adjustPosWithAlign();
			this.darkOthers();
		}
		
		private function getCost(heroID:uint, ret:Dictionary):void
		{
			var tableID:uint = heroID / 10;
			var add:int = heroID % 10;
			var addToList:Boolean = false;
			var wu:WuHeroProperty = m_gkcontext.m_wuMgr.getWuByHeroID(heroID) as WuHeroProperty;
			if (wu)
			{
				addToList = true;
			}
			else
			{
				var base:TNpcBattleItem = m_gkcontext.m_npcBattleBaseMgr.getTNpcBattleItem(tableID) as TNpcBattleItem;
				if (base.m_uColor == WuProperty.COLOR_PURPLE || add > 0)
				{
					addToList = true;
				}
			}
			if (addToList)
			{
				var list:Array;
				if (ret["list"] != undefined)
				{
					list = ret["list"];
				}
				else
				{
					list = new Array();
					ret["list"] = list;
				}
				list.push(tableID);
				return;
			}
			
			var propertyID:uint = tableID * 10 + base.m_uColor;
			var propertyBase:TWuPropertyItem = m_gkcontext.m_dataTable.getItem(DataTable.TABLE_WUPROPERTY, propertyID) as TWuPropertyItem;
			var type:int;
			
			
			var sorNum:uint = 0;
			if (ret[base.m_uColor] != undefined)
			{
				sorNum = ret[base.m_uColor];
			}
			
			ret[base.m_uColor] = propertyBase.m_uCost+sorNum;
		
		}
		
		private function needList(wu:WuHeroProperty):Dictionary
		{
			var i:int;
			var ret:Dictionary = new Dictionary();
			var list:Vector.<ActiveHero> = wu.m_vecActiveHeros;
			
			for (i = 0; i < list.length; i++)
			{
				getCost(list[i].id, ret);
			}
			return ret;
		}
		
		public function update():void
		{
			if (m_list == null)
			{
				return;
			}
			var item:ItemNeedBase;
			var satisfied:Boolean = true;
			for each (item in m_list)
			{
				item.update();
				if (item.satisfied == false)
				{
					satisfied = false;
				}
			}
			if (satisfied)
			{
				m_confirmBtn.enabled = true;
			}
			else
			{
				m_confirmBtn.enabled = false;
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			m_gkcontext.m_wuMgr.hideWuMouseOverPanel(m_wuIcon);
			if (m_gkcontext.m_uiTip)
			{
				m_gkcontext.m_uiTip.hideTip();
			}
		
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			m_gkcontext.m_wuMgr.showWuMouseOverPanel(m_wuIcon);
			var pt:Point = m_wuIcon.localToScreen(new Point(m_wuIcon.width, 0));
			m_gkcontext.m_uiTip.hintWu(pt, m_mainWu.m_uHeroID);
		}
		
		override public function onConcelBtnClick(e:MouseEvent):void
		{
			this.exit();
		}
		
		override public function onConfirmBtnClick(e:MouseEvent):void
		{
			if (false == m_gkcontext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_HEROREBIRTH))
			{
				m_gkcontext.m_systemPrompt.prompt("完成26级剧情任务后开放武将转生");
				return;
			}
			
			var dic:Dictionary = needList(m_mainWu);
			var wuList:Array;
			if (dic["list"] != undefined)
			{
				wuList = dic["list"];
				var wu:WuHeroProperty;
				var chuzhanList:Array = new Array();
				var id:int;
				for each(id in wuList)
				{
					wu = m_gkcontext.m_wuMgr.getWuByHeroID(WuHeroProperty.composeWuID(id, m_mainWu.add)) as WuHeroProperty;
					if (wu && wu.chuzhan && (1 == wu.m_num))
					{
						chuzhanList.push(wu);					
					}
				}
				if (chuzhanList.length > 0)
				{
					//此次转生将消耗掉阵上武将 XXXX， 请手动将他拖下阵位，并妥善安置接替武将。
					UtilHtml.beginCompose();
					UtilHtml.addStringNoFormat("此次转生将消耗掉阵上武将 ");
					for each(wu in chuzhanList)
					{
						UtilHtml.add(wu.fullName, wu.colorValue, 14);
						UtilHtml.addStringNoFormat(", ");
					}
					UtilHtml.addStringNoFormat("请手动将他拖下阵位，并妥善安置接替武将");
					m_gkcontext.m_confirmDlgMgr.showMode2(UIFormID.UIBackPack, UtilHtml.getComposedContent(), null);
					return;
				}
			}
			
			var send:stReqRebirthCmd = new stReqRebirthCmd();
			send.m_heroid = m_mainWu.m_uHeroID;
			m_gkcontext.sendMsg(send);
			this.exit();
		}
	
	}

}