package game.ui.treasurehunt 
{
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.TextNoScroll;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class prizeItem extends CtrolVHeightComponent 
	{
		private var nameLabel:TextNoScroll
		public function prizeItem(param:Object) 
		{
			super();
		}
		override public function setData(data:Object):void 
		{
			super.setData(data);
			nameLabel = new TextNoScroll();
			nameLabel.width = 216;
			addChild(nameLabel);
			var textFormat:TextFormat = new TextFormat();
			textFormat.leading = 4;
			textFormat.letterSpacing = 1;
			nameLabel.defaultTextFormat = textFormat;
			nameLabel.htmlText = data as String;
			this.height = nameLabel.height;
		}		
	}

}