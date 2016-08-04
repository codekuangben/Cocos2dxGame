package game.ui.uibenefithall.subcom.welfarepackage 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.scene.benefithall.welfarepackage.WelfarePackageMgr;
	
	/**
	 * ...
	 * @author 
	 */
	public class WelfareStateControl extends Component 
	{
		private var m_gkcontext:GkContext;
		private var m_Package:Panel;
		private var m_type:uint;
		private var m_path:String;
		public function WelfareStateControl(type:uint, buyPath:String, receivePath:String, gk:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkcontext = gk;			
			initPackage(type,buyPath,receivePath);
		}
		
		private function initPackage(type:uint, buyPath:String, receivePath:String):void
		{
			if (!m_gkcontext.m_welfarePackageMgr.packageState(type))
			{
				return;
			}
			if (m_gkcontext.m_welfarePackageMgr.packageState(type).m_buyTime == 0)
			{
				m_Package = new WelfareBuyState(type, buyPath, m_gkcontext, this);
				m_type = type;
				m_path = receivePath;
			}
			else
			{
				m_Package = new WelfareReceiveState(type, receivePath,m_gkcontext,this);
			}
			addChild(m_Package);
		}
		public function operatePackage(handler:uint):void //负责执行具体更新操作
		{
			if (handler == WelfarePackageMgr.WELFARE_OP_BUY)
			{
				exchangePackage();
			}
			else if (handler == WelfarePackageMgr.WELFARE_OP_HARVEST)
			{
				(m_Package as WelfareReceiveState).harvest();
			}
			else
			{
				(m_Package as WelfareReceiveState).nextDay();
			}
		}
		private function exchangePackage():void
		{
			removeChild(m_Package);
			m_Package.dispose();
			m_Package = new WelfareReceiveState(m_type, m_path, m_gkcontext, this);
		}
	}

}