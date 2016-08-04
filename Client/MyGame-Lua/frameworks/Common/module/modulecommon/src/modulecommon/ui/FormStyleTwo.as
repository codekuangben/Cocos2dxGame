package modulecommon.ui 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 * 确认对话框基类
	 */
	//import com.pblabs.engine.resource.SWFResource;	
	import com.bit101.components.Panel;
	//import com.pblabs.engine.resource.ResourceEvent;
	import com.dgrigg.image.ImageList;
	import com.dgrigg.image.Image;
	
	import flash.events.Event;
	import modulecommon.res.ResForm;
	
	public class FormStyleTwo extends Form
	{	
		protected var m_imagList:ImageList;
		protected var _titleBG:Panel;
		public function FormStyleTwo() 
		{
			_titleBG = new Panel(this);
			_titleBG.mouseEnabled = false;
			this.addEventListener(Event.RESIZE, onResize);
			m_ocMusic = true;
		}
		
		override public function onReady():void
		{
			this.m_gkcontext.m_context.m_commonImageMgr.loadImage(ResForm.StypeTwo, ImageList, onLoaded, onFailed);		
			super.onReady();
		}
		
		protected function onLoaded(image:Image):void
		{
			m_imagList = image as ImageList;
			this.setSkinGrid9Image9ByImage(m_imagList.getImage(0));
			_titleBG.setPanelImageSkinByImage(m_imagList.getImage(1));
			_titleBG.x = (this.width - _titleBG.width) / 2;
			_titleBG.y = -8;
		}
		protected function onFailed(fileName:String):void
		{
			
		}
		
		override public function dispose():void
		{
			if (m_imagList != null)
			{
				m_gkcontext.m_context.m_commonImageMgr.unLoad(m_imagList.name);
			}
		}
		public function onResize(e:Event):void
		{
			_titleBG.x = (this.width - _titleBG.width) / 2;
		}
	}

}