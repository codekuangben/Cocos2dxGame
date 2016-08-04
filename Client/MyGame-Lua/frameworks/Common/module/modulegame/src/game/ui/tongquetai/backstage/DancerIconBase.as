package game.ui.tongquetai.backstage 
{
	import com.bit101.components.controlList.controlList_VerticalAlign.ControlList_VerticalAlign_Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.dgrigg.utils.UIConst;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import modulecommon.scene.tongquetai.DancerBase;
	import modulecommon.GkContext;
	import modulecommon.scene.tongquetai.MysteryDancer;
	import modulecommon.scene.tongquetai.NormalDancer;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;
	import com.bit101.components.Component;
	import modulecommon.scene.prop.BeingProp;
	/**
	 * ...
	 * @author 
	 */
	public class DancerIconBase extends ControlList_VerticalAlign_Component 
	{
		protected var m_icon:Panel;	
		protected var m_iconName:Label;
		protected var m_gkContext:GkContext;
		protected var m_dancerData:DancerBase;
		public function DancerIconBase(param:Object=null) 
		{
			this.setPanelImageSkin("commoncontrol/panel/tongquetai/headbg.png");
			this.setSize(107, 174);
			m_icon = new Panel(this,6,-31);
			m_icon.recycleSkins = true;
			m_iconName = new Label(this, 48, 88);
			m_iconName.setFontColor(UtilColor.WHITE_Yellow);
			m_iconName.align = Component.CENTER;
			m_gkContext = param.gk as GkContext;
			
			addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			addEventListener(MouseEvent.ROLL_OVER, onMouseEnter);	
		}
		
		override public function setData(data:Object):void 
		{
			super.setData(data);
			m_dancerData = data as DancerBase;
			update();
		}
		private function onMouseLeave(e:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
		}
		protected function onMouseEnter(e:MouseEvent):void
		{
			var pt:Point = this.localToScreen();
			UtilHtml.beginCompose();
			UtilHtml.add(m_data.m_name, UtilColor.BLUE,14);
			UtilHtml.breakline();
			if (m_data.type == DancerBase.GOT_NARMALDANCER)
			{
				UtilHtml.add("好感度消耗" + (m_data as NormalDancer).m_haogan + "点", UtilColor.WHITE_Yellow, 14);
				UtilHtml.breakline();
			}
			else
			{
				if ((m_data as MysteryDancer).m_notStolen == 1)
				{
					UtilHtml.add("不可被偷", UtilColor.WHITE_Yellow, 14);
					UtilHtml.breakline();
				}
			}
			UtilHtml.add("演绎" + Math.floor(m_data.m_worktime / 3600) + "小时的倾城之舞", UtilColor.WHITE_B);
			UtilHtml.breakline();
			var str:String;
			if (m_data.m_outputtype == BeingProp.SILVER_COIN)
			{
				str = "银币";
			}
			else if(m_data.m_outputtype == -1)
			{
				str = "经验";
			}
			else if (m_data.m_outputtype == BeingProp.JIANG_HUN)
			{
				str = "将魂";
			}
			else if (m_data.m_outputtype == BeingProp.GREEN_SHENHUN)
			{
				str = "绿色神魂";
			}
			else if (m_data.m_outputtype == BeingProp.BLUE_SHENHUN)
			{
				str = "蓝色神魂";
			}
			UtilHtml.add("收益 " + (m_data as DancerBase).m_outputvalue + " " + str, UtilColor.GOLD);
			m_gkContext.m_uiTip.hintHtiml(pt.x,pt.y, UtilHtml.getComposedContent(),266, true,8);	
		}
		
		override public function onOver():void
		{
			if (m_canSelected == false)
			{
				return;
			}
			if (m_select) return;
			this.filters = PushButton.s_funGetFilters(UIConst.EtBtnOver);
		}
		override public function onOut():void
		{
			if (m_canSelected == false)
			{
				return;
			}
			if (m_select) return;
			this.filters = null;
		}
		
		override public function onSelected():void
		{
			super.onSelected();
			this.filtersAttr(true);
		}
		override public function onNotSelected():void
		{
			super.onNotSelected();
			this.filtersAttr(false);
		}
		
		public static function s_compare(data:Object, param:Object):Boolean
		{
			if ((data as DancerBase).m_id == param)
			{
				return true;
			}
			return false;
		}
	}

}