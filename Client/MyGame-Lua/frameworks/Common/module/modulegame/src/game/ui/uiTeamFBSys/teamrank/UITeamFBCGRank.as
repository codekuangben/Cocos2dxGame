package game.ui.uiTeamFBSys.teamrank 
{
	import flash.events.Event;
	import modulecommon.ui.FormStyleFour;
	import com.bit101.components.ButtonImageText;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.ImageForm;
	import flash.events.MouseEvent;
	import modulecommon.res.ResGrid9;
	import modulecommon.ui.FormStyleFour;
	import org.ffilmation.engine.datatypes.IntPoint;
	import modulecommon.ui.UIFormID;
	import game.ui.uiTeamFBSys.msg.retTeamBossRankUserCmd;
	import game.ui.uiTeamFBSys.UITFBSysData;

	/**
	 * ...
	 * @author 
	 * 过关斩将-排行榜界面
	 */
	public class UITeamFBCGRank extends FormStyleFour 
	{
		public var m_TFBSysData:UITFBSysData;
		
		private var m_rankList:ControlListVHeight;
		private var m_closeBtn:ButtonImageText;

		public function UITeamFBCGRank() 
		{
			this._hitYMax = 60;
			id = UIFormID.UITeamFBCGRank;
		}

		override public function onReady():void 
		{
			super.onReady();
			m_bCloseOnSwitchMap = false;
			var size:IntPoint = ImageForm.s_round(400, 520);
			this.setSize(size.x, size.y);
			//m_bgPart.addContainer();
			m_bgPart.setSize(this.width, this.height);
			
			var panel:Panel;
			var panelContainer:PanelContainer;
			
			panelContainer = new PanelContainer(null, 4, 58);
			panelContainer.setSize(387, 440);
			m_bgPart.addDrawCom(panelContainer);
			panelContainer.setSkinGrid9Image9(ResGrid9.StypeOne);
			
			panelContainer = new PanelContainer(null, 6, 60);
			panelContainer.setSize(384, 436);
			m_bgPart.addDrawCom(panelContainer);
			panelContainer.setSkinForm(ResGrid9.Form3);
			
			panel = new Panel(null, -5, 0);
			panel.setSize(410, 69);
			m_bgPart.addDrawCom(panel);
			panel.setHorizontalImageSkin("commoncontrol/panel/titleback_mirror.png");
			
			panel = new Panel(null, 150, 25);
			panel.setSize(76, 27);
			m_bgPart.addDrawCom(panel);
			panel.setPanelImageSkin("commoncontrol/panel/guoguanrank.png");
			
			var titleBar:Panel = new Panel(null, 12, 67);
			titleBar.setSize(370, 35);
			m_bgPart.addDrawCom(titleBar);
			titleBar.setPanelImageSkinMirror("commoncontrol/panel/nameback.png", Image.MirrorMode_LR);
			
			panel = new Panel(titleBar, 43, 10);
			panel.setSize(35, 18);
			panel.setPanelImageSkin("commoncontrol/panel/rank.png");
			panel = new Panel(titleBar, 165, 10);
			panel.setSize(36, 17);
			panel.setPanelImageSkin("commoncontrol/panel/name.png");
			panel = new Panel(titleBar, 250, 10);
			panel.setSize(37, 17);
			panel.setPanelImageSkin("commoncontrol/panel/tongguolayer.png");
			
			panel = new Panel(null, 12, 422);
			panel.width = 370;
			m_bgPart.addDrawCom(panel);
			panel.setHorizontalImageRepeatSkin("commoncontrol/horizontalrepeat/decorate.swf");
			
			panel = new Panel(null, 0, 54);
			panel.setSize(19, 80);
			m_bgPart.addDrawCom(panel);
			panel.setPanelImageSkin("commoncontrol/panel/side.png");
			
			panel = new Panel(null, 377, 54);
			panel.setSize(19, 80);
			m_bgPart.addDrawCom(panel);
			panel.setPanelImageSkinMirror("commoncontrol/panel/side.png", Image.MirrorMode_HOR);
			
			m_bgPart.drawPanel();
			
			m_closeBtn = new ButtonImageText(this, 147, 440, onCloseBtn);
			m_closeBtn.setSize(100, 42);
			m_closeBtn.setGrid9ImageSkin("commoncontrol/button/button2.swf");
			m_closeBtn.setImageText("commoncontrol/panel/close.png");
			
			m_rankList = new ControlListVHeight(this, 12, 103);
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_class = ItemFBCGRank;
			param.m_marginBottom = 0;
			param.m_marginLeft = 5;
			param.m_marginRight = 5;
			param.m_marginTop = 0;
			param.m_intervalV = 2;
			param.m_heightList = param.m_marginTop + param.m_marginBottom + (30 + param.m_intervalV) * 10;
			param.m_lineSize = 32;
			param.m_width = 342;
			param.m_scrollType = 1;
			param.m_bCreateScrollBar = true;
			m_rankList.setParam(param);
			
			updateData();			
			
			m_exitBtn.y = 60;
		}
		
		override public function onShow():void
		{
			super.onShow();
			psretTeamBossRankUserCmd(null);
		}

		override public function exit():void
		{
			m_TFBSysData.m_onUIClose(this.id);
			super.exit();
		}

		private function onCloseBtn(e:MouseEvent):void
		{
			if (e.target == m_closeBtn)
			{
				this.exit();
			}
		}

		override protected function onResize(e:Event):void
		{
			if (m_exitBtn)
			{
				m_exitBtn.x = this.width - 60;
			}
			if (m_titlePart)
			{
				m_titlePart.x = (this.width - m_titlePart.width) / 2;
			}
		}

		public function psretTeamBossRankUserCmd(cmd:retTeamBossRankUserCmd):void
		{	
			var param:Object = new Object();
			param["data"] = m_TFBSysData;
			
			if(m_TFBSysData.m_rankLst)
			{
				m_rankList.setDatas(m_TFBSysData.m_rankLst, param);
			}
		}
	}
}