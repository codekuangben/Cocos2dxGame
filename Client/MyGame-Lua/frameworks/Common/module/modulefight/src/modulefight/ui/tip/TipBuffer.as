package modulefight.ui.tip 
{
	import com.bit101.components.PanelContainer;
	//import flash.text.TextFormat;
	import modulecommon.GkContext;
	import com.bit101.components.Label;
	import modulecommon.res.ResGrid9;
	import flash.text.TextField;
	//import modulecommon.scene.prop.table.DataTable;
	//import modulecommon.scene.prop.table.TRoleStateItem;
	import modulefight.netmsg.stmsg.stEntryState;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class TipBuffer extends PanelContainer 
	{
		private var m_gkContext:GkContext;
		private var m_name:Label;
		private var m_txtField:TextField;
		public function TipBuffer(gk:GkContext, parent:DisplayObjectContainer=null) 
		{
			m_gkContext = gk;
			
			m_name = new Label(this, 15, 10);
			m_name.setFontColor(0xbbbbbb);
			m_name.setFontSize(14);
			m_name.setBold(true);
			this.width = 180;
			
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
			
			m_txtField = new TextField();
			this.addChild(m_txtField);

			m_txtField.multiline = true;
			m_txtField.wordWrap = true
			m_txtField.x = 15;
			m_txtField.y = 30;
			m_txtField.width = 150;
			//var textFormat:TextFormat = new TextFormat();
			//textFormat.size = 1
			m_txtField.textColor = 0xbbbbbb;
			m_txtField.height = 200;
		}
		public function showTip(state:stEntryState):void
		{			
			
			
			m_name.text = state.name;
			var desc:String = state.stateDesc.replace("aa", state.value.toString());
			m_txtField.text = desc;
		
			
			var h:uint = m_txtField.y + m_txtField.textHeight + 4 + 10;
			this.height = h;
		}
	}

}