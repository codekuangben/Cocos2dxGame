package game.ui.giftwatch 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.controlList.ControlAlignmentParam;
	import com.bit101.components.controlList.ControlList;
	import com.bit101.components.Label;	
	import com.bit101.components.Panel;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.FormStyleSix;
	
	/**
	 * ...
	 * @author ...
	 */
	public class UIGiftWatch extends FormStyleSix 
	{
		private var m_label:Label;
		private var m_list:ControlList;
		
		private var m_closeBtn:ButtonText;
		private var m_segmentLine1:Panel;
		private var m_segmentLine2:Panel;
		public function UIGiftWatch() 
		{
			super(true);		
			exitMode = EXITMODE_HIDE;
		}
		
		private function drawBack():void
		{
			var top:Number = m_list.y + m_list.height + 8;
			m_segmentLine2.y = top;
			top += 2;
			m_closeBtn.y = top +20;
			
			this.beginPanelDraw(380, top+100);
			this.endPanelDraw();
		}
		override public function onReady():void 
		{
			super.onReady();
			this.setTitleForForm7("礼包内容", 250, 1);
			
			
			m_segmentLine1 = new Panel(this, 40, 65);
			m_segmentLine1.autoSizeByImage = false;
			m_segmentLine1.setPanelImageSkin("commoncontrol/panel/segment.png");
			m_segmentLine1.setSize(297, 2);
			
			
			m_segmentLine2 = new Panel(this, 40, 182);
			m_segmentLine2.autoSizeByImage = false;
			m_segmentLine2.setPanelImageSkin("commoncontrol/panel/segment.png");
			m_segmentLine2.setSize(297, 2);		
			
			
			
			m_list = new ControlList(this, 36, 73);
			var param:ControlAlignmentParam = new ControlAlignmentParam();
			
			param.m_class = ObjectItem;
			param.m_width = 50;
			param.m_height = 50;
			
			param.m_intervalH = 0;
			param.m_intervalV = 0;
			param.m_marginTop = 0;
			param.m_marginBottom = 0;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_bAutoHeight = true;
			//param.m_lineSize = 6*ZObject.IconBgSize;
			param.m_needScroll = false;
			//param.m_scrollType = 1;
			param.m_numColumn = 6;
			//param.m_parentHeight = param.m_lineSize;
			
			var dataParam:Object = new Object();
			dataParam["gk"] = m_gkcontext;
			param.m_dataParam = dataParam;
			m_list.setParam(param);
			
			m_label = new Label(this, 25, 40); m_label.mouseEnabled = true;
			
			m_closeBtn = new ButtonText(this, 140, 205, "关闭", onExitBtnClick);
			//m_closeBtn.setSize(100, 42);			
			//m_closeBtn.setGrid9ImageSkin("commoncontrol/button/button2.swf");
			m_closeBtn.setPanelImageSkin("commoncontrol/button/button5_mirror.swf");
			m_closeBtn.labelComponent.miaobian = false;
			//m_closeBtn.labelComponent.setFontSize(12)
			m_closeBtn.labelComponent.setBold(true);
			m_closeBtn.normalColor = UtilColor.WHITE_Yellow;
			m_closeBtn.overColor  = 0xffffff;
			m_closeBtn.downColor = 0xaaaaaa;			
			
			timeForTimingClose = 10;
			this.draggable = false;
			this.darkOthers();
		}
		
		//输入礼包ID
		override public function updateData(param:Object = null):void 
		{
			var id:uint = param as uint;
			var obj:ZObject = ZObject.createClientObject(id);
			if (obj == null)
			{
				return;
			}
			var dataList:Array = m_gkcontext.m_marketMgr.getGiftPackContent(id);
			if (dataList == null)
			{
				return;
			}
			UtilHtml.beginCompose();
			UtilHtml.add("【",UtilColor.WHITE_Yellow);
			UtilHtml.add(obj.name, obj.colorValue);
			UtilHtml.add("】：",UtilColor.WHITE_Yellow);
			
			var str:String;
			if (obj.m_ObjectBase.m_iShareData1 == 0)
			{
				str = "有几率获得以下物品：";
			}
			else
			{
				str = "可以获得：";
			}
			UtilHtml.add(str,UtilColor.WHITE_Yellow);
			m_label.htmlText = UtilHtml.getComposedContent();
			
			var listCopy:Array;
			//if(dataList.length>
			listCopy = dataList;
			m_list.setDatas(listCopy);
			drawBack();
		}
		
		
		
	}

}