package ui 
{
	import com.dgrigg.utils.UIConst;
	import common.Context;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import com.pblabs.engine.core.IResizeObject;
	import ui.instance.UIDebugLog;
	import com.pblabs.engine.entity.EntityCValue;
	/**
	 * ...
	 * @author 
	 */
	public class UIManagerSimple extends Sprite  implements IResizeObject
	{		
		
		private var m_context:Context;
		
		private var m_dicLayer:Dictionary;
		
		private var m_dicForm:Dictionary; //[id,form]
		
		public var m_showLog:Boolean;	
		
		public function UIManagerSimple(context:Context)
		{
			m_context = context;								
	
			m_dicLayer = new Dictionary();		
			m_dicLayer[UIConst.FirstLayer] = new UILayerSimple(UIConst.FirstLayer);
			m_dicLayer[UIConst.SecondLayer] = new UILayerSimple(UIConst.SecondLayer);
			this.addChild(m_dicLayer[UIConst.FirstLayer].deskTop);
			this.addChild(m_dicLayer[UIConst.SecondLayer].deskTop);
			
			
			m_dicForm = new Dictionary();	
			m_context.m_processManager.addResizeObject(this, EntityCValue.ResizeUI);
			init();
		}		
		public function getLayer(layerID:uint):UILayerSimple
		{			
			return m_dicLayer[layerID];
		}
		public function addForm(form:FormSimple):void
		{			
			var layer:UILayerSimple = getLayer(UIConst.Layer(form.id));
			layer.addForm(form);
			m_dicForm[form.id] = form;		
			
			form.setContext(m_context);
			form.onReady();
		}
		
		public function getForm(ID:uint):FormSimple
		{
			return m_dicForm[ID];
		}
		
		public function hasForm(ID:uint):Boolean
		{
			return (m_dicForm[ID] != undefined);
		}
	
		
		public function showForm(ID:uint):void
		{
			var form:FormSimple = getForm(ID);
			if (form)
			{
				var layer:UILayerSimple = getLayer(UIConst.Layer(form.id));				
				if (form.parent!=layer.deskTop)
				{
					layer.deskTop.addChild(form);
					form.onShow();
				}				
			}
		}
		
		public function hideForm(ID:uint):void
		{
			var form:FormSimple = getForm(ID);
			if (form)
			{
				var layer:UILayerSimple = getLayer(UIConst.Layer(form.id));
				if (form.parent==layer.deskTop)
				{
					layer.deskTop.removeChild(form);
					form.onHide();
				}
			}
		}	
				
		//关闭界面
		public function exitForm(ID:uint):void
		{
			var win:FormSimple = getForm(ID);
			if (win != null)
			{	
				win.exit();				
			}
		}
		
		public function destroyForm(ID:uint):void
		{
			var form:FormSimple = getForm(ID);			
			if (form != null)
			{
				var layer:UILayerSimple = getLayer(UIConst.Layer(form.id));
				if (form.parent==layer.deskTop)
				{
					layer.deskTop.removeChild(form);
					form.onHide();
				}
				delete layer.winDic[ID];
				form.dispose();
			}
		}
		
		//stage的大小发生变化后，调用此函数
		public function onResize(viewWidth:int, viewHeight:int):void
		{
			var layer:UILayerSimple;
			for each(layer in m_dicLayer)
			{
				layer.onStageReSize();
			}
		}
		
		private function init():void
		{
			var form:FormSimple;
			form = new UIDebugLog();
			this.addForm(form);
		}
	
	

	}

}