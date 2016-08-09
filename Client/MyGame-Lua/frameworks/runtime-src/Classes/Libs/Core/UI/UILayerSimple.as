package ui 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.Dictionary;
	import flash.display.Sprite;
	public class UILayerSimple 
	{		
		private var m_layer:int;	//UIFormID.FirstLayer定义
		private var m_deskTop:Sprite;
		private var m_winDic:Dictionary;
		public var m_closeReguarlyProcessed:Boolean;
		public function UILayerSimple(layer:int) 
		{
			m_layer = layer;
			m_deskTop = new Sprite();
			m_winDic = new Dictionary();
		}
		public function get deskTop():Sprite
		{
			return m_deskTop;
		}
		
		public function get winDic():Dictionary
		{
			return m_winDic;
		}
		
		public function hasForm(form:FormSimple):Boolean
		{
			return m_winDic[form.id] != undefined;
		}
		
		public function removeForm(form:FormSimple):void
		{			
			if (m_winDic[form.id] != undefined)
			{
				delete m_winDic[form.id];
				if (form.parent == m_deskTop)
				{
					m_deskTop.removeChild(form);
				}
			}
		}
		public function get layerID():int
		{
			return m_layer;
		}
		
		public function addForm(form:FormSimple):void
		{
			m_winDic[form.id] = form;			
		}
		public function onStageReSize():void
		{
			var num:int = m_deskTop.numChildren;
			var index:int = 0;
			var form:FormSimple;
			for (index = 0; index < num; index++)
			{
				form = m_deskTop.getChildAt(index) as FormSimple;
				form.onStageReSize();
			}
		}
	}

}