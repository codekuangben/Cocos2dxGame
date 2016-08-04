package modulecommon.scene.prop.skill 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.dgrigg.image.PanelImage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import modulecommon.scene.wu.JinnangItem;
	import com.util.UtilFilter;
	//import flash.filters.GlowFilter;
	
	public class SkillDrawTool 
	{
		private var m_gkContext:GkContext;
		private var m_container:Sprite;
		private var m_iconBitmap:Bitmap;
			
		public function SkillDrawTool(gk:GkContext)
		{
			m_gkContext = gk;
			init();
		}
		public function drawJinnang(jinnang:JinnangItem, image:PanelImage, bitMD:BitmapData, bDrag:Boolean, shownum:Boolean):void
		{			
			m_iconBitmap.bitmapData = image.data;
			if (bDrag == true)
			{
				m_container.filters = [UtilFilter.createGrayFilter()];
			}
			else
			{
				m_container.filters = null;
			}			
			
			if(shownum)
			{
				var _tf:TextField = this.tf;
				_tf.text = jinnang.num.toString();
				_tf.x = 40 - (_tf.textWidth+4);
				bitMD.draw(m_container);
				m_container.removeChild(_tf);
			}
			else
			{
				bitMD.draw(m_container);
			}
		}
		
		public function drawZhanShu(zhanshuid:uint, image:PanelImage, bitMD:BitmapData, bDrag:Boolean, shownum:Boolean, type:uint):void
		{
			m_iconBitmap.bitmapData = image.data;
			if (bDrag == true)
			{
				m_container.filters = [UtilFilter.createGrayFilter()];
			}
			else
			{
				m_container.filters = null;
			}			
			
			if(shownum)
			{
				var _tf:TextField = this.tf;
				var level:uint;
				if (TSkillBaseItem.TYPE_TIANFU == type)
				{
					level = zhanshuid % 10;
				}
				else
				{
					level = zhanshuid % 100;
				}
				_tf.text = level.toString();
				_tf.x = 40 - (_tf.textWidth+4);
				bitMD.draw(m_container);
				m_container.removeChild(_tf);
			}
			else
			{
				bitMD.draw(m_container);
			}
		}
		
		public function drawZhanShuMounts(level:uint, image:PanelImage, bitMD:BitmapData, bDrag:Boolean, shownum:Boolean, type:uint):void
		{
			m_iconBitmap.bitmapData = image.data;
			if (bDrag == true)
			{
				m_container.filters = [UtilFilter.createGrayFilter()];
			}
			else
			{
				m_container.filters = null;
			}			
			
			if(shownum)
			{
				var _tf:TextField = this.tf;
				_tf.text = level.toString();
				_tf.x = 40 - (_tf.textWidth+4);
				bitMD.draw(m_container);
				m_container.removeChild(_tf);
			}
			else
			{
				bitMD.draw(m_container);
			}
		}
		
		public function get tf():TextField
		{			
			var _tf:TextField = m_gkContext.m_context.m_globalObj.tf;
			//_tf.x = 30;
			_tf.y = 25;
			_tf.defaultTextFormat = new TextFormat(null, 12, 0xffffff);
			//tf.textColor = 0xffffff;			
			_tf.filters = m_gkContext.m_context.m_globalObj.glowFilter;
			m_container.addChild(_tf);
			return _tf;
		}
		public function drawDragJinnang(jinnang:JinnangItem, image:PanelImage, bitMD:BitmapData):void
		{
			m_container.filters = null;
			m_iconBitmap.bitmapData = image.data;	
			var _tf:TextField = this.tf;
			_tf.text = jinnang.num.toString();
			_tf.x = 40 - (_tf.textWidth+4);
			bitMD.draw(m_container);
			m_container.addChild(_tf);
		}
		public function init():void
		{
			m_container = new Sprite();			
			m_iconBitmap = new Bitmap();			
			m_container.addChild(m_iconBitmap);
		}
	}

}