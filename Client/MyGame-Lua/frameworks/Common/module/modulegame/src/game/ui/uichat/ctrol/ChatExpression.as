package game.ui.uichat.ctrol 
{
	import modulecommon.GkContext;
	import com.bit101.components.Ani;
	import com.riaidea.text.GraphicBase;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TExpressionItem;
	/**
	 * ...
	 * @author 
	 */
	public class ChatExpression  extends GraphicBase 
	{
		private var m_ani:Ani;
		private var m_id:int;
		public function ChatExpression(gk:GkContext, id:int) 
		{
			m_id = id;
			m_ani = new Ani(gk.m_context, this, 13,5);
			m_ani.centerPlay = true;
			m_ani.duration = 2;
			m_ani.repeatCount = 0;
			var base:TExpressionItem = gk.m_dataTable.getItem(DataTable.TABLE_EXPRESSION, m_id) as TExpressionItem;
			m_ani.setImageAni("expression/" + base.m_expressID + ".swf");
			m_ani.begin();
			m_ani.mouseEnabled = false;
			m_ani.mouseChildren = false;
			
		}
		override public function get width():Number 
		{
			return 26;
		}
		
		override public function get height():Number 
		{
			return 12;
		}	
		public function dispose():void
		{
			m_ani.disposeEx();
		}
		override public function get identification():String 
		{
			return ChatRichTextField.s_formatExpression(m_id);
		}
	}

}