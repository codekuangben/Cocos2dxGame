package  modulecommon.commonfuntion
{
	import com.pblabs.engine.idleprocess.IIdleTimeProcess;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.Resource;
	import com.pblabs.engine.resource.SWFResource;
	import common.Context;	
	import com.pblabs.engine.resource.ResourceEvent;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.xml.DataXml;
	/**
	 * ...
	 * @author 
	 */
	public class PreLoadInIdleTimeProcess implements IIdleTimeProcess 
	{
		private var m_context:Context;
		public var m_swfNamesForPreLoad:Vector.<String>;
		/**
		 * 存放预加载图片路径名
		 */
		public var m_pictureNamesForPreLoad:Vector.<String>;
		private var m_dicResource:Dictionary;
		/**
		 * 公共字段
		 */
		private var m_gkcontext:GkContext;
		private var m_preLoadXml:PreLoadXmlMgr;
		public function PreLoadInIdleTimeProcess(gk:GkContext) 
		{
			m_gkcontext = gk;
			m_context = gk.m_context;
			m_dicResource = new Dictionary();
			m_swfNamesForPreLoad = new Vector.<String>();//["asset/uiimage/module/backpack.swf", "asset/uiimage/module/market.swf","asset/uiimage/module/imageZhenfa.swf"]移入配置文件
			m_pictureNamesForPreLoad = new Vector.<String>();
			m_preLoadXml = new PreLoadXmlMgr(gk);
			changeLevel();
			
		}
		/**
		 * 等级改变添加进程
		 */
		public function changeLevel():void
		{
			m_context.m_idleTimeProcessMgr.insertProcess(this);
		}
		
		/* INTERFACE com.pblabs.engine.idleprocess.IIdleTimeProcess */
		public function process():void 
		{
			m_preLoadXml.loadConfig();
			var resClass:Class;
			var loadedFun:Function;
			var failedFun:Function;
			if (m_swfNamesForPreLoad.length != 0)
			{
				var fileName:String = m_swfNamesForPreLoad.pop();
				resClass = SWFResource;
				loadedFun = onLoadedSWF;
				failedFun = onFailedSWFImage;
			}
			else
			{
				fileName = m_pictureNamesForPreLoad.pop();
				resClass = ImageResource;
				loadedFun = onLoadedImage;
				failedFun = onFailedPicImage;
			}
			m_context.m_resMgr.load(fileName, resClass, loadedFun, failedFun);
			
			if (m_swfNamesForPreLoad.length == 0 && m_pictureNamesForPreLoad.length == 0)
			{
				m_context.m_idleTimeProcessMgr.deleteProcess(this);
			}
		}
		
		private function onLoadedSWF(event:ResourceEvent):void
		{
			var resource:Resource = event.resourceObject;
			m_dicResource[resource.filename] = resource;
		}
		
		private function onFailedSWFImage(event:ResourceEvent):void
		{
			
		}
		private function onLoadedImage(event:ResourceEvent):void
		{
			
		}
		private function onFailedPicImage(event:ResourceEvent):void
		{
			
		}
		
	}

}