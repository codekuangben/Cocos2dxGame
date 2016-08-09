package com.pblabs.engine.resource
{
	import flash.events.ProgressEvent;
	
	/**
	 * 
	 * */
	public class ResourceProgressEvent extends ProgressEvent
	{
		// 资源渐进事件
		public static const PROGRESS_EVENT:String = "PROGRESS_EVENT";
		
		public var _percentLoaded:Number;
		public var resourceObject:Resource = null;
		
		public function ResourceProgressEvent(type:String, resource:Resource, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			resourceObject = resource;
		}
	}
}