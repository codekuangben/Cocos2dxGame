package org.ffilmation.engine.helpers
{
	// Imports
	import org.ffilmation.engine.datatypes.fPoint3d;
	
	/**
	 * @private
	 * THIS IS A HELPER OBJECT. OBJECTS IN THE HELPERS PACKAGE ARE NOT SUPPOSED TO BE USED EXTERNALLY. DOCUMENTATION ON THIS OBJECTS IS
	 * FOR DEVELOPER REFERENCE, NOT USERS OF THE ENGINE
	 *
	 * Container object for a sprite definition
	 */
	public class fSpriteDefinition
	{
		// Public properties
		public var angle:Number;
		public var sprite:Class;	// 这个现在不需要 
		public var shadow:Class;	// 这个现在不需要 
		
		// KBEN:如果是图片序列的时候，这个字段有用  
		private var _startName:String; 	// 记录开始时候图片的名字，基本名字，需要自己添加上序号组合成完整的名字   
		
		// KBEN: 特效图片相对于中心点的偏移。特效使用，特效每一张图自己一个包，单独加载       
		protected var m_origin:fPoint3d;
		// 特效图片资源包的名字  
		protected var _mediaPath:String;	// 特效使用，因为特效本来打算如果资源比较大就放在几个包里，但是逻辑比较复杂，最后全部放在一个包里了，这个字段其实可以和模型一样放在方向定义里
		// 图片的宽度
		protected var _picWidth:uint;
		// 图片的高度
		protected var _picHeight:uint;
		
		// Constructor
		function fSpriteDefinition(angle:Number, sprite:Class, shadow:Class):void
		{
			this.angle = angle;
			this.sprite = sprite;
			this.shadow = shadow;
			
			m_origin = new fPoint3d(0, 0, 0);
		}
		
		public function get startName():String 
		{
			return _startName;
		}
		
		public function set startName(value:String):void 
		{
			_startName = value;
		}
		
		public function get origin():fPoint3d 
		{
			return m_origin;
		}
		
		public function set origin(value:fPoint3d):void 
		{
			m_origin = value;
		}
		
		public function get mediaPath():String 
		{
			return _mediaPath;
		}
		
		public function set mediaPath(value:String):void 
		{
			_mediaPath = value;
		}
		
		// 从一个对象拷贝另外一个对象    
		public function copyFrom(rh:fSpriteDefinition):void
		{
			// 其它 3 个成员构造的时候直接拷贝过去了   
			_startName = rh.startName;
			m_origin.x = rh.origin.x;
			m_origin.y = rh.origin.y;
			
			_picWidth = rh.picWidth;
			_picHeight = rh.picHeight;
			
			_mediaPath = rh.mediaPath;
		}
		
		public function overwriteAtt(rh:fSpriteDefinition):void
		{
			// 其它 3 个成员构造的时候直接拷贝过去了   
			//_startName = rh.startName;
			m_origin.x = rh.origin.x;
			m_origin.y = rh.origin.y;
			
			_picWidth = rh.picWidth;
			_picHeight = rh.picHeight;
			
			_mediaPath = rh.mediaPath;
		}
		
		public function get picWidth():uint
		{
			return _picWidth;
		}
		
		public function set picWidth(value:uint):void
		{
			_picWidth = value;
		}
		
		public function get picHeight():uint
		{
			return _picHeight;
		}
		
		public function set picHeight(value:uint):void
		{
			_picHeight = value;
		}
	}
}