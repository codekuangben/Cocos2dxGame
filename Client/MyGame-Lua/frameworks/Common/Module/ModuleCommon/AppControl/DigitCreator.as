package modulecommon.appcontrol 
{
	/**
	 * ...
	 * @author 
	 */
	import com.dgrigg.utils.ImageTempStorage;
	import common.Context;
	import com.bit101.components.PanelDraw;
	import com.bit101.components.Panel;
	import com.dgrigg.image.PanelImage;
	import common.event.UIEvent;
	
	public class DigitCreator 
	{		
		private var m_context:Context;
		private var m_panelDraw:PanelDraw;
		private var m_funAfterDraw:Function;
		
		private var m_imageStg:ImageTempStorage;
		private var m_panelList:Vector.<Panel>;
		
		private var m_interval:int;
		private var m_path:String;
		private var m_width:Number;
		private var m_height:Number;
		
		public function DigitCreator(con:Context) 
		{
			m_context = con;
			m_panelDraw = new PanelDraw();
			m_panelDraw.addEventListener(UIEvent.IMAGELOADED,onDraw);
			m_panelDraw.notDisposeAfterDraw = true;
			m_imageStg = new ImageTempStorage(con);
			m_panelList = new Vector.<Panel>();
		}
		public function setParam(path:String, interval:int, h:Number):void
		{
			m_path = path + "/";
			m_interval = interval;
			m_height = h;
		}
		
		public function set digit(n:uint):void
		{			
			var strDigit:String = n.toString();
			var str:String;
			var i:int = 0;
			var digit:int;
			m_panelDraw.beginDraw();
			var panel:Panel;
			var left:int = 0;
			
			while (i < strDigit.length)
			{
				digit = parseInt(strDigit.charAt(i));
				str = m_path + digit.toString() + ".png";
				if (i >= m_panelList.length)
				{
					panel = new Panel();
					m_panelList.push(panel);
				}
				else
				{
					panel = m_panelList[i];					
				}
				panel.setPanelImageSkin(str);
				panel.x = left;
				left += m_interval;
				m_panelDraw.addDrawCom(panel);
				if (m_imageStg.hasRes(str)==false)
				{
					m_imageStg.add(PanelImage, str);
				}
				i++;
			}
			m_width = left+10;
			m_panelDraw.setSize(m_width, m_height);		
			m_panelDraw.drawPanel();
		}
		
		private function onDraw(e:UIEvent):void
		{
			
			if (m_funAfterDraw != null)
			{
				m_funAfterDraw();
			}
		}
		public function dispose():void 
		{
			m_panelDraw.removeEventListener(UIEvent.IMAGELOADED,onDraw);
			m_imageStg.clear();
			var i:int = 0;
			for (i = 0; i < m_panelList.length; i++)
			{
				m_panelList[i].dispose();
			}		
		}
		
		public function get panlDraw():PanelDraw
		{
			return m_panelDraw;
		}
		public function get width():Number
		{
			return m_width;
		}
		public function get height():Number
		{
			return m_height;
		}
		
		public function set funAfterDraw(fun:Function):void
		{
			m_funAfterDraw = fun;
		}
	}

}