package modulecommon.scene.prop.skill
{
	import com.dgrigg.image.Image;
	import flash.display.BitmapData;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author ...
	 */
	public class MountsSkillIcon extends SkillIcon
	{
		protected var m_lvl:uint;	// 当前等级

		public function MountsSkillIcon(gk:GkContext) 
		{
			super(gk);
		}
		
		override public function draw():void
		{
			if (m_uSkillID == 0 || m_image == null)
			{
				return;
			}
			if (m_image.loadState != Image.Loaded)
			{
				return;
			}
			//m_bitmap.bitmapData = m_image.data;
			
			var bitMD:BitmapData;
			if (m_bitmap.bitmapData != null)
			{
				bitMD = m_bitmap.bitmapData;
			}
			else
			{
				bitMD = new BitmapData(SkillMgr.ICONSIZE_Normal, SkillMgr.ICONSIZE_Normal);
				m_bitmap.bitmapData = bitMD;
				m_bitmap.width = SkillMgr.ICONSIZE_Normal;
				m_bitmap.height = SkillMgr.ICONSIZE_Normal;
			}
			
			m_gkContext.m_skillDrawTool.drawZhanShuMounts(m_lvl, m_image, bitMD, m_bDrag, m_bShowNum, m_uSkillType);
		}
		
		public function get lvl():uint
		{
			return m_lvl;
		}
		
		public function set lvl(value:uint):void
		{
			m_lvl = value;
			invalidate();
		}
	}
}