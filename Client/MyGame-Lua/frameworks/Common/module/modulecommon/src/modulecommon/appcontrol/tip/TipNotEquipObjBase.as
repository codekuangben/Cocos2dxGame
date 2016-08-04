package modulecommon.appcontrol.tip 
{
	import com.bit101.components.Label;
	import com.bit101.components.PanelContainer;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ZObject;
	import flash.display.DisplayObjectContainer;
	import modulecommon.scene.prop.object.ZObjectDef;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class TipNotEquipObjBase extends PanelContainer 
	{
		protected var m_gkContext:GkContext;
		private var m_nameLabel:Label;
		private var m_needLevel:Label;
		private var m_valueLabel:Label;
		private var m_saleLabel:Label;
		private var m_tf:TextField;
		public function TipNotEquipObjBase(gk:GkContext, parent:DisplayObjectContainer=null) 
		{
			super(parent);
			m_gkContext = gk;
			
			m_nameLabel = new Label(this, 12, 14);	m_nameLabel.setFontSize(14);	m_nameLabel.setBold(true);
			
			m_needLevel = new Label(this, 12, 40); m_needLevel.setFontColor(UtilColor.WHITE);
			m_valueLabel = new Label(this, 12, 40); m_valueLabel.setFontColor(0xfbdda2);
			m_saleLabel = new Label(this, 12, 40); m_saleLabel.setFontColor(0xcccccc);
			
			
			m_tf = new TextField();
			this.addChild(m_tf);
			m_tf.multiline = true;
			m_tf.wordWrap = true
			m_tf.x = 12;			
			m_tf.width = 242;
			m_tf.height = 300;
			m_tf.mouseEnabled = false;
			
			
			var tformat:TextFormat = new TextFormat();
			tformat.color = 0xbbbbbb;
			tformat.leading = 1;
			tformat.letterSpacing = 1;
			m_tf.defaultTextFormat = tformat;
			var filter:GlowFilter = new GlowFilter(0, 1, 2, 2, 4);
			m_tf.filters = [filter];			
					
			this.setSize(266, 350);			
		}
		
		public function showTip(obj:ZObject):void
		{
			var yOffset:int = 0;
			if (m_gkContext.versonForOut)
			{
				m_nameLabel.text = obj.name;
			}
			else
			{
				m_nameLabel.text = obj.name + "  " + obj.ObjID;
			}
			m_nameLabel.setFontColor(obj.colorValue);
			yOffset = m_nameLabel.y + 30;
			
			if (obj.type==ZObjectDef.ItemType_EmbedGem)
			{
				m_valueLabel.visible = true;
				m_needLevel.visible = true;
				
				m_needLevel.text = "所需等级  " + obj.m_ObjectBase.m_iNeedLevel+"级";
				m_valueLabel.text = ZObjectDef.gemAttrName(obj.m_ObjectBase.m_iShareData2) + "  " + obj.m_ObjectBase.m_iShareData1;
				
				m_needLevel.y = 40;
				yOffset = m_needLevel.y + 25;
				m_valueLabel.y = yOffset;
				yOffset = yOffset + 35;
			}
			else
			{
				m_valueLabel.visible = false;
				m_needLevel.visible = false;
			}
			
			m_tf.y = yOffset;
			m_tf.text = obj.m_ObjectBase.m_iDesc;
			yOffset += m_tf.textHeight + 4;
			
			var str:String;
			var price:int = obj.price_GameMoney;
			if (price)
			{				
				str = "售价 " + price.toString() + " 银币";
			}
			else
			{
				str = "不可出售";
			}
			m_saleLabel.text = str;
			m_saleLabel.flush();
			m_saleLabel.y = yOffset;
			m_saleLabel.x = this.width - m_saleLabel.width - 20;
			yOffset += 20;
			yOffset += 10;
			this.height = yOffset;
		}
		
	}

}