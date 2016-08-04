package game.ui.uiTeamFBSys.teaminvite 
{
	import com.bit101.components.comboBox.ComoBoxItem;
	import com.bit101.components.Label;
	import flash.display.DisplayObjectContainer;
	import modulecommon.scene.wu.WuProperty;
	
	/**
	 * ...
	 * @author 
	 */
	public class FBInviteComboBoxItem extends ComoBoxItem 
	{
		
		public function FBInviteComboBoxItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object = null, param:Object = null) 
		{
			this.m_funMakeLabel = makeLabel;
			super(parent, xpos, ypos,data,param);
			this.data = data;
			
		}
		
		override public function set data(value:Object):void 
		{
			if (value)
			{
				_data = value;
				var wu:WuProperty = value as WuProperty;
				var str:String = wu.fullName;
				
				m_label.text = str;
				m_label.setFontColor(wu.colorValue);
				
			}
			
		}

		public function makeLabel(label:Label):void
		{
			if (this.data)
			{
				var wu:WuProperty = data as WuProperty;
				var str:String = wu.fullName;
				
				label.text = str;
				label.setFontColor(wu.colorValue);
			}
		}	
	}
}