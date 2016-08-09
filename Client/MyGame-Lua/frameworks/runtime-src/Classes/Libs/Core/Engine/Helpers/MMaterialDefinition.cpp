package org.ffilmation.engine.helpers
{
	
	/**
	 * @private
	 * THIS IS A HELPER OBJECT. OBJECTS IN THE HELPERS PACKAGE ARE NOT SUPPOSED TO BE USED EXTERNALLY. DOCUMENTATION ON THIS OBJECTS IS
	 * FOR DEVELOPER REFERENCE, NOT USERS OF THE ENGINE
	 *
	 * This object stores a material definition loaded from a definition XML
	 */
	public class fMaterialDefinition extends fResourceDefinition
	{
		// Public vars
		public var type:String; // This is the type of material. @see fEngineMaterialTypes
		// KBEN: media 资源文件的路径 
		private var _mediaPath:String;
		// KBEN: 漫反射贴图
		public var m_diffuse:String;
		
		// Constructor
		public function fMaterialDefinition(data:XML, basepath:String):void
		{
			super(data, basepath);
			this.type = data.@type;
			this._mediaPath = data.@media;
			this.m_diffuse = data.diffuse;
			
			// bug: 总是释放不了 xml ,这里直接释放
			this.xmlData = null;
		}
		
		public function get mediaPath():String 
		{
			return _mediaPath;
		}
		
		public function set mediaPath(value:String):void 
		{
			_mediaPath = value;
		}
	}
}