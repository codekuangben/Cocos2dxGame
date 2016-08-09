package modulecommon.ui
{
	import com.bit101.components.Label;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.ImageForm;
	import com.util.UtilFont;
	import org.ffilmation.engine.datatypes.IntPoint;
	import com.bit101.components.Component;
	import flash.events.MouseEvent;
	
	//import modulecommon.res.ResForm;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class FormStyleOne extends Form
	{
		protected var _titleBG:PanelContainer;
		protected var _exitBtn:PushButton;
		protected var _titleLabel:Label;
		
		public function FormStyleOne()
		{
			super();
			setSkinForm("form4.swf");
			
			_exitBtn = new PushButton(this, 0, 4);
			_exitBtn.setPanelImageSkin("commoncontrol/button/exitbtn.swf");
			_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);
			_exitBtn.m_musicType = PushButton.BNMClose;
			
			_titleBG = new PanelContainer();
			this.addBackgroundChild(_titleBG);
			
			_titleBG.y = -35;
			_titleBG.setHorizontalImageSkin("commoncontrol/form/" + "titlebg_mirror.png");
			
			_titleLabel = new Label(_titleBG);
			_titleLabel.y = 20;
			_titleLabel.setFontSize(18);
			_titleLabel.setFontColor(0xe7e565);
			_titleLabel.setFontName(UtilFont.NAME_HuawenXinwei);
			_titleLabel.setLetterSpacing(6);
			_titleLabel.setSize(4, 25);
			_titleLabel.autoSize = false;
			_titleLabel.align = Component.CENTER;
			m_ocMusic = true;
		}
		
		public function setFormSkin(resName:String, lenTitleBG:int):void
		{
			_titleBG.setSize(lenTitleBG, 36);
			_titleBG.x = (this.width - _titleBG.width) / 2;
			_titleLabel.x = _titleBG.width / 2;
			//m_gkcontext.m_context.m_commonImageMgr.loadImage(ResForm.StypeOne, ImageList, onImageLoaded, onImageFailed);			
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			if (_exitBtn)
			{
				var size:IntPoint = ImageForm.s_round(w, h);
				super.setSize(size.x, size.y);
				_exitBtn.x = this.width - 55;
				_titleBG.x = (this.width - _titleBG.width) / 2;
			}
		}
		
		override public function onDestroy():void
		{
			_exitBtn.removeEventListener(MouseEvent.CLICK, onExitBtnClick);
			super.onDestroy();
		}
		
		public function set title(t:String):void
		{
			if (t.length > 4)
			{
				_titleLabel.setLetterSpacing(4);
			}
			_titleLabel.text = t;
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