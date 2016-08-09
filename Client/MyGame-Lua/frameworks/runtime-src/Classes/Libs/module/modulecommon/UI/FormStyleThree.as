package modulecommon.ui 
{
	/**
	 * ...
	 * @author 
	 */
	import com.bit101.components.PushButton;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.ImageList;
	import flash.events.MouseEvent;
	
	//import com.dgrigg.image.CommonImageManager;
	//import modulecommon.res.ResForm;
	import com.bit101.components.Panel;

	public class FormStyleThree extends Form 
	{
		protected var m_imageList:ImageList;
		protected var _titleBG:Panel;
		protected var _exitBtn:PushButton;
		private var m_imageName:String;
		
		public function FormStyleThree() 
		{
			_titleBG = new Panel();
			_exitBtn = new PushButton(this);
			_exitBtn.m_musicType = PushButton.BNMClose;
			m_ocMusic = true;
		}
		public function setFormSkin(resName:String):void
		{
			_titleBG.y = -20;
			_titleBG.setSize(250, 36);
			
			m_imageName = resName;
			m_gkcontext.m_context.m_commonImageMgr.loadImage(resName, ImageList, onImageLoaded, onImageFailed);			
		}
		
		public function onImageLoaded(image:Image):void
		{
			m_imageList = image as ImageList;
			//第一个是Form
			//第二个是关闭按钮
			//第三个是title
			
			this.setSkinFormByImage(m_imageList.getImage(0));			
			//this.setSize(this.skin.width, this.skin.height);
			
			//_titleBG.setHorizontalImageSkinByImage(m_imageList.getImage(2));
			_titleBG.x = (this.width - _titleBG.width) / 2;
			this.addBackgroundChild(_titleBG);
			
			_exitBtn.y = 0;
			_exitBtn.setSize(48, 32);
			_exitBtn.x = this.width - 49;
			
			_exitBtn.setPanelImageSkinByImage(m_imageList.getImage(1));
			_exitBtn.addEventListener(MouseEvent.CLICK, onExitBtnClick);			
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (m_imageList != null)
			{
				m_gkcontext.m_context.m_commonImageMgr.unLoad(m_imageList.name);
				m_imageList = null;
			}
			else if (m_imageName != null)
			{
				m_gkcontext.m_context.m_commonImageMgr.removeFun(m_imageName, onImageLoaded, onImageFailed);
			}
		}
		
		public function onImageFailed(filename:String):void
		{
			
		}	
	}

}