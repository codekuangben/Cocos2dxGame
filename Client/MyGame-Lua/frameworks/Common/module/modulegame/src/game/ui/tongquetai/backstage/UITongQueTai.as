package game.ui.tongquetai.backstage 
{
	import com.bit101.components.Panel;
	import flash.geom.Point;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.ui.FormStyleExitBtn;
	import modulecommon.scene.tongquetai.DancerBase;
	import modulecommon.ui.UIFormID;
	import modulecommon.ui.Form;
	import modulecommon.uiinterface.IUITongQueTai;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	
	/**
	 * ...
	 * @author ...
	 * 藏娇阁
	 */
	public class UITongQueTai extends FormStyleExitBtn implements IUITongQueTai
	{
		private var m_leftPart:NormalPage;
		private var m_midPart:MidPage;
		private var m_rightPart:MysteryPage;
		private var m_redribbon:Panel;
		
		public function UITongQueTai() 
		{
			super();
			_hitYMax = 0;
			
			exitMode = EXITMODE_HIDE;
			setAniForm(65);
			timeForTimingClose = 20;			
		}
		
		override public function onReady():void 
		{
			super.onReady();
			this.setSize(618,574);
			this.setPanelImageSkin("commoncontrol/panel/tongquetai/tongquetaibg.png");
			m_leftPart = new NormalPage(this, m_gkcontext, this, 84, 140);
			m_leftPart.init();
			m_midPart = new MidPage(m_gkcontext, this, 361,107);
			m_rightPart = new MysteryPage(this, m_gkcontext, this,615,60);
			m_redribbon = new Panel( this, 521, 57);
			m_redribbon.setPanelImageSkin("commoncontrol/panel/tongquetai/redribbon.png");
			m_exitBtn.setPos(589,67);
			m_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			swapChildren(m_exitBtn, m_midPart);
			swapChildren(m_exitBtn, m_redribbon);
			
			m_gkcontext.m_tongquetaiMgr.m_uiTongquetai = this;
			m_leftPart.selectFirstDancer();
		}
		
		override public function show():void 
		{
			this.adjustPosWithAlign();
			this.darkOthers();
			super.show();
			
			showNewHandGuide();
		}
		
		override protected function computeAdjustPosWithAlign():Point 
		{
			var ret:Point = new Point();
			var widthStage:int = m_gkcontext.m_context.m_config.m_curWidth;
			var heightStage:int = m_gkcontext.m_context.m_config.m_curHeight;
			ret.y = (heightStage - 574) / 2;
			
			ret.x = (widthStage - (618+161)) / 2;
			return ret;
		}
		
		/*override public function exit():void 
		{
			super.exit();
			m_gkcontext.m_tongquetaiMgr.openWuHui();
		}*/
		override public function dispose():void 
		{
			m_gkcontext.m_context.m_uiObjMgr.releaseAllObjectByPartialName("tongquetai.backstage_MidPage");
			super.dispose();
			m_gkcontext.m_tongquetaiMgr.m_uiTongquetai = null;
		}
	
		public function updateHaogan():void
		{
			m_midPart.updateHaogan();
		}
		public function updataSelectModel(dancer:DancerBase):void
		{
			m_midPart.setDancer(dancer);
			if (dancer.isNormal)
			{
				m_rightPart.selectNO();
			}
			else
			{
				m_leftPart.selectNO();
			}
		}
		
		public function addNormalDancer(id:int):void
		{
			m_leftPart.addNormalDancer(id);
		}
		
		
		//得到神秘舞女
		public function addSpecialDancer(id:uint):void
		{
			m_rightPart.addSpecialDancer(id);
		}
		
		//删除神秘舞女
		public function deleteSpecialDancer(id:uint):void
		{
			if (id == m_midPart.getCunDancerID())
			{
				m_leftPart.selectFirstDancer();
			}
			m_rightPart.deleteSpecialDancer(id);
		}
		
		//更新神秘舞女的数量
		public function updateNumOfSpecialDancer(id:uint):void
		{
			m_rightPart.updateNumOfSpecialDancer(id);
		}
	
		public function setDancerPos(pos:int):void
		{
			m_midPart.setDancerPos(pos);
		}
		
		public function updataIconName():void
		{
			m_leftPart.upDataAll();
		}
		
		public function showNewHandGuide():void
		{
			if (m_gkcontext.m_newHandMgr.isVisible() && SysNewFeatures.NFT_TONGQUETAI == m_gkcontext.m_sysnewfeatures.m_nft)
			{
				m_midPart.showNewHandToBanquetBtn();
			}
		}
	}

}