package game.ui.uiTeamFBSys.iteamzx
{
	import com.bit101.components.ButtonTabText;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.dgrigg.image.Image;
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.uiinterface.IUITeamFBZX;
	
	import game.ui.uiTeamFBSys.UITFBSysData;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class WuIconList extends Component
	{
		private static const HEIGHT:int = 360;
		
		protected var m_TFBSysData:UITFBSysData;
		private var m_gkContext:GkContext;
		private var m_dicBtn:Dictionary;
		private var m_curPage:uint;
		private var m_fightWuList:ControlListVHeight;
		private var m_preBtn:PushButton;
		private var m_nextBtn:PushButton;
		private var m_pageLabel:Label;
		private var m_uiZhenfa:IUITeamFBZX;
		
		public function WuIconList(parent:DisplayObjectContainer, data:UITFBSysData)
		{
			m_TFBSysData = data;
			m_gkContext = m_TFBSysData.m_gkcontext;
			m_uiZhenfa = parent as IUITeamFBZX;
			super(parent);
			
			var obj:Object = new Object();
			obj["data"] = m_TFBSysData;
			
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_class = WuIconItem;
			param.m_width = WuProperty.SQUAREHEAD_WIDHT;
			param.m_intervalV = 21;
			param.m_marginTop = 0;
			param.m_marginBottom = 0;
			param.m_marginLeft = 0;
			param.m_marginRight = 0;
			param.m_heightList = param.m_marginTop + WuProperty.SQUAREHEAD_HEIGHT + (WuProperty.SQUAREHEAD_HEIGHT + param.m_intervalV) * 4 + param.m_marginBottom;
			param.m_lineSize = param.m_heightList;
			param.m_scrollType = 0;
			param.m_bCreateScrollBar = true;
			param.m_dataParam = obj;
			
			m_fightWuList = new ControlListVHeight(this);
			m_fightWuList.setParam(param);
		}
		
		public function initData(res:SWFResource):void
		{
			var btn:ButtonTabText;
			var wuPro:WuProperty;
			generate();
		}
		
		public function build():void
		{
			var wuPro:WuProperty;
			var arFight:Array = m_gkContext.m_wuMgr.getFightWuList(true, true);
			//var arNotFight:Array = m_gkContext.m_wuMgr.getFightWuList(false, false);
			//var allwj:Array;
			//var allwj:Array = m_gkContext.m_wuMgr.getAllWu();
			//allwj = arFight.concat(arNotFight);
			
			// 只有出阵武将才可上阵
			m_fightWuList.setDatas(arFight);
			//m_fightWuList.setDatas(allwj);
			//m_notFightWuList.setDatas(arNotFight);
			
			if (m_fightWuList.pageCount > 1)
			{
				if (m_preBtn == null)
				{
					m_preBtn = new PushButton(this, 9, 390, onPageBtnClick);
					m_preBtn.setPanelImageSkin("commoncontrol/button/leftArrow2.swf");
					m_preBtn.tag = 0;
					m_preBtn.m_musicType = PushButton.BNMPage;
					
					m_nextBtn = new PushButton(this, 75, 390, onPageBtnClick);
					m_nextBtn.setPanelImageSkinMirror("commoncontrol/button/leftArrow2.swf", Image.MirrorMode_HOR);
					m_nextBtn.tag = 1;
					m_nextBtn.m_musicType = PushButton.BNMPage;
					
					m_pageLabel = new Label(this, 36, 390);
					m_pageLabel.setBold(true);
					m_pageLabel.setLetterSpacing(3);
				}
				m_preBtn.enabled = false;
				m_nextBtn.enabled = true;
				
				m_preBtn.visible = true;
				m_nextBtn.visible = true;
				m_pageLabel.visible = true;
				
				updatePage();
			}
			else
			{
				if (m_preBtn != null)
				{
					m_preBtn.visible = false;
					m_nextBtn.visible = false;
					m_pageLabel.visible = false;
				}
			}
		}
		
		public function generate():void
		{
			build();
			//adjustPos();
			m_uiZhenfa.updateAllWuZhanli();		
		}
		
		protected function updatePage():void
		{
			if (m_fightWuList.pageCount <= 1)
			{
				return;
			}
			
			var str:String;
			str = (m_fightWuList.curPage + 1).toString() + " / " + m_fightWuList.pageCount;
			m_pageLabel.text = str;
		}
		
		public function onPageBtnClick(e:MouseEvent):void
		{
			var btn:PushButton = e.target as PushButton;
			if (btn == null)
			{
				return;
			}
			
			switch (btn.tag)
			{
				case 0: 
				{
					m_fightWuList.toPreLine();
					
					if (m_fightWuList.canToPriLine() == false)
					{
						m_preBtn.enabled = false;
					}
					if (m_nextBtn.enabled == false)
					{
						m_nextBtn.enabled = true;
					}
					break;
				}
				case 1: 
				{
					m_fightWuList.toNextLine();
					if (m_fightWuList.canToNextLine() == false)
					{
						m_nextBtn.enabled = false;
					}
					
					if (m_preBtn.enabled == false)
					{
						m_preBtn.enabled = true;
					}
					break;
				}
			}
			updatePage();
		}
	}
}