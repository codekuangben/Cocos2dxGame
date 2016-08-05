package modulecommon.commonfuntion.delayloader
{
	
	import com.pblabs.engine.resource.SWFResource;

	public class DelayLoaderBase
	{
		public static const LoadNone:uint = 0;	// 未加载
		public static const Loading:uint = 1;		// 加载中
		
		public var m_path:String;		// 延迟加载的资源
		// 第一个延迟加载的，延迟长一点时间，后面的可根据自己情况实际操作
		public var m_loadInterval:uint = 5;	// 延迟加载，这个延迟是从进入场景开始算的，单位'秒'
		public var m_loadState:int = 0;		// 加载状态
		
		public function DelayLoaderBase()
		{
			
		}
		
		// 自己写的加载资源的函数，如果有就自己加载，如果没有就走默认的加载
		public function loadRes():Boolean
		{
			return false;	// 返回 false 就需要默认加载，返回 true 说明自己处理了加载
		}
		
		public function onResLoaded(res:SWFResource):void
		{
			
		}
		
		public function onResFailed(res:SWFResource):void
		{
			
		}
		
		// 设置加载回调函数
		public function set fcbLoaded(fn:Function):void
		{
			
		}
		
		public function set fcbFailed(fn:Function):void
		{
			
		}
		
		public function dispose():void
		{
			
		}
	}
}