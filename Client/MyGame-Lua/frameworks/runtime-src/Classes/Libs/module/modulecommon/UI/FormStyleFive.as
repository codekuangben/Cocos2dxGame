package modulecommon.ui
{
	//import com.bit101.components.Component;
	//import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.ImageForm;
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.events.MouseEvent;
	
	//import modulecommon.res.ResForm;
	
	import org.ffilmation.engine.datatypes.IntPoint;
	
	/**
	 * @brief 边框都是拉伸的，不是反复贴的
	 * */
	public class FormStyleFive extends Form 
	{
		protected var _pnlBg:Panel;				// 中间的 Panel
		protected var _titleBG:PanelContainer;		// 标题文字
		protected var _exitBtn:PushButton;			// 关闭按钮
		
		public function FormStyleFive()
		{
			super();
			setSkinGrid9Image9("commoncontrol/form/form6.swf");
			
			_exitBtn = new PushButton(this, 0, 4);
			_exitBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			_exitBtn.m_musicType = PushButton.BNMClose;
			
			_titleBG = new PanelContainer();
			this.addBackgroundChild(_titleBG);
			
			_titleBG.y = -35;
			
			_pnlBg = new Panel(this);
			_pnlBg.setPos(27, 60);
			_pnlBg.autoSizeByImage = false;
			_pnlBg.setPanelImageSkin("commoncontrol/panel/gradualbg.png");
			m_ocMusic = true;
		}
		
		public function setFormSkin(resName:String, lenTitleBG:int):void
		{
			_titleBG.setSize(lenTitleBG, 20);
			_titleBG.setPos((this.width - _titleBG.width) / 2, 16);			
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			if (_exitBtn)
			{
				var size:IntPoint = ImageForm.s_round(w, h);
				super.setSize(size.x, size.y);
				_exitBtn.setPos(this.width - 39, 15);
				_titleBG.x = (this.width - _titleBG.width) / 2;
			}
			
			_pnlBg.setSize(w - 60, h - 90);	// 注意最小不能小于 [60, 90]
		}
		
		// 设置背景资源名字
		public function titleBgImage(resName:String):void
		{
			_titleBG.setPanelImageSkin(resName);
		}
		
		public function titleBgImageBySwf(swf:SWFResource, className:String):void
		{
			_titleBG.setPanelImageSkinBySWF(swf, className);
		}
		
		public function newHandMoveToExitBtn():void
		{
			if (m_gkcontext.m_newHandMgr.isVisible())
			{
				m_gkcontext.m_newHandMgr.prompt(false, 40, 40, "点击关闭。", this._exitBtn);
			}
		}
	}
}