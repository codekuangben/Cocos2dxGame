package game.ui.uibackpack.wujiang
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.dgrigg.display.DisplayCombinationBase;
	import com.dgrigg.image.Image;
	import common.Context;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author
	 */
	public class ZhuanshengAni
	{
		private static const LEFT:String = "LEFT";
		private static const RIGHT:String = "RIGHT";
		private var m_listAniParent:Sprite;
		private var m_listAni:Vector.<Object>; //每个元素是包含左右（镜像）特效
		private var m_zhuanAni:Ani;
		private var m_con:Context;
		private var m_mask:Shape;
		
		private var m_parent:DisplayObjectContainer;
		
		private var m_bShowZhuanAni:Boolean;
		private var m_bInEquipPage:Boolean;
		
		public function ZhuanshengAni(con:Context)
		{
			m_con = con;
			m_listAni = new Vector.<Object>();
			
			m_mask = new Shape();
			m_listAniParent = new Sprite();
			m_listAniParent.addChild(m_mask);
			m_listAniParent.mask = m_mask;
			m_listAniParent.mouseEnabled = false;
			
			m_zhuanAni = new Ani(m_con);
			m_zhuanAni.setImageAni("ejzhuangshengzi.swf");
			m_zhuanAni.duration = 3;
			m_zhuanAni.repeatCount = 0;
			m_zhuanAni.centerPlay = true;
			m_zhuanAni.setAutoStopWhenHide();
			m_zhuanAni.y = -27;
		}
		
		public function onAddToEquipPage():void
		{
			m_bInEquipPage = true;
			addZhuanAniToDisplayList();
		}
		
		public function onAddToAttrPage():void
		{
			m_bInEquipPage = false;
			removeZhuanAniFromDisplayList();
		}
		
		public function isInParent(p:DisplayObjectContainer):Boolean
		{
			return p == m_parent;
		}
		
		private function addZhuanAniToDisplayList():void
		{
			if (m_bInEquipPage && m_bShowZhuanAni)
			{
				if (m_parent != m_zhuanAni.parent)
				{
					m_parent.addChild(m_zhuanAni);
				}
			}
		}
		
		private function removeZhuanAniFromDisplayList():void
		{
			if (m_bInEquipPage == false || m_bShowZhuanAni ==false)
			{
				if (m_zhuanAni.parent)
				{
					m_zhuanAni.parent.removeChild(m_zhuanAni);
				}
			}
		}
		public function onUIBackPackHide():void
		{
			if (m_zhuanAni)
			{
				m_zhuanAni.stop();
			}
			var i:int = 0;
			var obj:Object;
			var ani:Ani;
			for each (obj in m_listAni)
			{
				ani = obj[LEFT];
				ani.stop();
				ani = obj[RIGHT];
				ani.stop();
			}
		}
		
		public function onUIBackPackShow():void
		{
			if (m_zhuanAni && m_zhuanAni.parent)
			{
				m_zhuanAni.begin();
			}
			var i:int = 0;
			var obj:Object;
			var ani:Ani;
			for each (obj in m_listAni)
			{
				ani = obj[LEFT];
				if (ani.parent)
				{
					ani.begin();
				}
				ani = obj[RIGHT];
				if (ani.parent)
				{
					ani.begin();
				}
			}
		}
		public function showZhuanAni(p:DisplayObjectContainer,nWu:int):void
		{
			m_parent = p;
			var wAll:int = nWu * 58;
			m_zhuanAni.x = wAll / 2;
			m_zhuanAni.begin();
			m_bShowZhuanAni = true;
			addZhuanAniToDisplayList();
			
			m_mask.graphics.clear();
			m_mask.graphics.beginFill(0xff0000);
			m_mask.graphics.drawRect(-50, -100, wAll + 50 + 50, 101);
			m_mask.graphics.drawRect(-50, 64, wAll + 50 + 50, 28);
			m_mask.graphics.drawRect(-50, 3, 80, 80);
			m_mask.graphics.drawRect(wAll - 30, 3, 80, 80);
			m_mask.graphics.endFill();
		}
		
		public function showHuoAni(p:DisplayObjectContainer, nWu:int):void
		{
			m_parent = p;
			var i:int = m_listAni.length;
			var obj:Object;
			var ani:Ani;
			var left:int = 0;
			
			if (p != m_listAniParent.parent)
			{
				p.addChild(m_listAniParent);
			}
			
			while (i < nWu)
			{
				left = i * 58;
				obj = new Object();
				
				ani = new Ani(m_con);
				ani.x = left - 16;
				ani.y = -35;
				ani.setImageAni("ejzhuangshenghuo.swf");
				ani.duration = 4;
				ani.mouseEnabled = false;
				ani.repeatCount = 0;
				ani.setAutoStopWhenHide();
				obj[LEFT] = ani;
				
				ani = new Ani(m_con);
				ani.x = left + 58 - (106 - 31);
				ani.y = -35;
				ani.setImageAniMirror("ejzhuangshenghuo.swf", Image.MirrorMode_HOR);
				ani.duration = 4;
				ani.repeatCount = 0;
				ani.setAutoStopWhenHide();
				ani.mouseEnabled = false;
				obj[RIGHT] = ani;
				
				m_listAni.push(obj);
				i++;
			}
			
			for (i = 0; i < nWu; i++)
			{
				ani = m_listAni[i][LEFT];
				if (m_listAniParent != ani.parent)
				{
					m_listAniParent.addChild(ani);
				}
				
				ani.begin();
				
				ani = m_listAni[i][RIGHT];
				if (m_listAniParent != ani.parent)
				{
					m_listAniParent.addChild(ani);
				}
				ani.begin();
			}
			for (i = nWu; i < m_listAni.length; i++)
			{
				ani = m_listAni[i][LEFT];
				if (ani.parent)
				{
					ani.parent.removeChild(ani);
				}
				ani.stop();
				
				ani = m_listAni[i][RIGHT];
				if (ani.parent)
				{
					ani.parent.removeChild(ani);
				}
				ani.stop();
			}
			
			var wAll:int = nWu * 58;
			m_mask.graphics.clear();
			m_mask.graphics.beginFill(0xff0000);
			m_mask.graphics.drawRect(-50, -100, wAll + 50 + 50, 101);
			m_mask.graphics.drawRect(-50, 64, wAll + 50 + 50, 28);
			m_mask.graphics.drawRect(-50, 3, 80, 80);
			m_mask.graphics.drawRect(wAll - 30, 3, 80, 80);
			m_mask.graphics.endFill();
		}
		
		public function hideHuoAni():void
		{
			if (m_listAniParent.parent)
			{
				m_listAniParent.parent.removeChild(m_listAniParent);
			}
		}
		public function hideZhuanAni():void
		{
			if (m_zhuanAni.parent)
			{
				m_zhuanAni.parent.removeChild(m_zhuanAni);
			}
			m_zhuanAni.stop();
			m_bShowZhuanAni = false;
		}
		public function hideAni():void
		{
			hideHuoAni();
			hideZhuanAni()
		}
		public function dispose():void
		{
			var i:int;
			var ani:Ani;
			for (i = 0; i < m_listAni.length; i++)
			{
				ani = m_listAni[i][LEFT];
				ani.dispose();
				
				ani = m_listAni[i][RIGHT];
				ani.dispose();
			}
			if (m_zhuanAni)
			{
				if (m_zhuanAni.parent)
				{
					m_zhuanAni.parent.removeChild(m_zhuanAni);
				}
				m_zhuanAni.dispose();
			}
		}
	}

}