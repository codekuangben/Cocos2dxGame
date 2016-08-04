package game.ui.uiTeamFBSys.teaminvite
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	
	import flash.display.DisplayObjectContainer;
	
	import modulecommon.res.ResGrid9;
	import com.util.UtilColor;
	
	import game.ui.uiTeamFBSys.UITFBSysData;

	/**
	 * @brief 标签窗口基类
	 * */
	public class TWBase extends Component
	{
		public var m_TFBSysData:UITFBSysData;
		
		protected var m_pnlBg:Panel;			// 背景
		public var m_list:ControlListVHeight;	// 列表框
		public var m_binit:Boolean;		// 是否内容初始化
		protected var m_pnlHead:Panel;			// 标题头
		public var m_lblLst:Vector.<Label>;	// 标签列表
		
		public function TWBase(cls:Class, data:UITFBSysData, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos)
			m_TFBSysData = data;
			this.height = 300;
			
			m_pnlBg = new Panel(this);
			m_pnlBg.autoSizeByImage = false;
			m_pnlBg.setSize(312, 208);
			m_pnlBg.setSkinGrid9Image9(ResGrid9.StypeOne);
			
			var caplst:Vector.<String> = new Vector.<String>(3, true);
			caplst[0] = "名称";
			caplst[1] = "等级";
			caplst[2] = "战力";
			
			var poslst:Vector.<uint> = new Vector.<uint>(3, true);
			poslst[0] = 35;
			poslst[1] = 160;
			poslst[2] = 230;
			
			m_pnlHead = new Panel(this, 4, 3);
			m_pnlHead.autoSizeByImage = false;
			m_pnlHead.setSize(305, 30);
			m_pnlHead.setPanelImageSkinBySWF(m_TFBSysData.m_form.swfRes, "uiteamfbsysinvite.head");
			
			m_lblLst = new Vector.<Label>(3, true);
			var idx:uint = 0;
			while(idx < 3)
			{
				m_lblLst[idx] = new Label(this, poslst[idx], 10, caplst[idx], UtilColor.WHITE_Yellow);
				++idx;
			}
			
			m_list = new ControlListVHeight(this, 0, 35);
			var m_param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			m_param.m_class = cls;
			m_param.m_marginTop = 0;
			m_param.m_marginBottom = 0;
			m_param.m_intervalV = 2;
			m_param.m_width = 308;
			m_param.m_heightList = m_param.m_marginTop + 20 + (20 + m_param.m_intervalV) * 7 + m_param.m_marginBottom;
			m_param.m_lineSize = m_param.m_heightList;
			m_param.m_scrollType = 0;
			m_param.m_bCreateScrollBar = true;
			m_list.setParam(m_param);
		}
		
		// 设置数据
		public function setDatas(datas:Array):void
		{
			var param:Object = new Object();
			param["data"] = m_TFBSysData;
			
			param["over"] = m_TFBSysData.m_overPanel;
			param["select"] = m_TFBSysData.m_selectPanel;
			
			m_list.setDatas(datas, param);
		}
	}
}