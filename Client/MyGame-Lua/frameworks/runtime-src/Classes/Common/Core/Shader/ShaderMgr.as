package shader 
{
	import flash.display.Shader;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	
	public class ShaderMgr 
	{		
		private var m_liuguangByteCode:ByteArray;
		[Embed(source = "shaderRes/liuguang.pbj", mimeType = "application/octet-stream")]
		private var LiuguangClass:Class;
		public function ShaderMgr() 
		{
			
		}
		public function getLiuguangShader():Shader
		{
			if (m_liuguangByteCode == null)
			{
				m_liuguangByteCode = new LiuguangClass();
			}
			return new Shader(m_liuguangByteCode);
		}
		
	}

}