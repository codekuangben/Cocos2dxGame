package ui.instance
{
	//import com.bit101.components.Panel;
	import com.bit101.components.ButtonText;
	import com.bit101.components.Label;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import com.bit101.components.progressBar.ProgressBar;
	import com.dgrigg.utils.UIConst;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ui.FormSimple;
	//import com.pblabs.engine.resource.ResourceEvent;
	//import com.pblabs.engine.resource.SWFResource;
	
	import flash.display.Shape;
	import flash.text.TextFieldAutoSize;
	
	import net.loginUserCmd.stClientResourceLoadOverLoginCmd;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	//import modulecommon.ui.Form;
	//import modulecommon.ui.UIFormID;

	/**
	 * ...
	 * @author ...
	 * @brief 加载进度条
	 */
	public class UIProgLoading extends FormSimple
	{				
		protected var m_progBarLoading:ProgressBar;	// 这个是总的进度条
		protected var m_progBarOneLoading:ProgressBar;	// 这个是单独文件的进度条
		
		// 这些在使用前设置需要加载的数据
		protected var m_loadingRes:Vector.<String>;	// 将要加载的资源
		protected var m_loadedRes:Vector.<String>;	// 已经加载成功的资源
		protected var m_failedRes:Vector.<String>;	// 已经加载失败的资源
		
		protected var m_totaldesc:TextNoScroll;		// 所有文件的描述加载信息
		protected var m_onedesc:TextNoScroll;		// 每一个文件的描述加载信息
		
		protected var m_state:uint;					// 加载状态，如果是 0 说明是第一次进入，此时要加载很多东西，加载地形缩略图就不进入这个加载界面了，但是之后跳地图需要进入这个加载界面
		//protected var m_loadBG:ProgLoadingBg;		// 加载背景
		
		protected var m_promptLabel:Label;
		protected var m_orgInfo:OrgInfo;
		//protected var m_btnNetISP:ButtonText;		// 切换网络的按钮
		protected var m_logBtn:ButtonText;
		public function UIProgLoading()
		{
			this.id = UIConst.UIProgLoading;
		}
		
		override public function onReady():void
		{
			exitMode = EXITMODE_HIDE;
			alignHorizontal = CENTER;
			alignVertial = BOTTOM;
			marginBottom = 200;
			
		
			//this.m_loadBG = new ProgLoadingBg(this, this);
			
			m_progBarLoading = new ProgressBar(this);
			m_progBarLoading.setBar(new ComProgBarLoading(m_context));
			//(m_progBarLoading.bar as PanelContainer).setSize(229, 14);
			(m_progBarLoading.bar as ComProgBarLoading).m_parForm = this;
			m_progBarLoading.setPos(-(m_progBarLoading.bar as PanelContainer).width / 2, - 30);
			
			m_progBarOneLoading = new ProgressBar(this);
			m_progBarOneLoading.setBar(new ComProgBarLoading(m_context));
			m_progBarOneLoading.setPos( - (m_progBarLoading.bar as PanelContainer).width/2, 30);
			//(m_progBarOneLoading.bar as ComProgBarLoading).m_parForm = this;
			
			m_onedesc = new TextNoScroll();
			this.addChild(m_onedesc);
			m_onedesc.autoSize = TextFieldAutoSize.LEFT;
			m_onedesc.wordWrap = false;
			m_onedesc.multiline = false;
			m_onedesc.x = -50;
			m_onedesc.y = 60;
			
			m_totaldesc = new TextNoScroll();
			this.addChild(m_totaldesc);
			m_totaldesc.autoSize = TextFieldAutoSize.LEFT;
			m_totaldesc.wordWrap = false;
			m_totaldesc.multiline = false;
			
			m_orgInfo = new OrgInfo(this);
			m_orgInfo.setPos(0, 90);	// 调整政府信息
			
			m_totaldesc.text = "总进度";
			m_totaldesc.x = - 50;
			m_totaldesc.y = - 20;
			
			m_loadingRes = new Vector.<String>();
			m_loadedRes = new Vector.<String>();
			m_failedRes = new Vector.<String>();
			
			/*m_btnNetISP = new ButtonText(this, 0, 0, "如果进度条长时间没有变化，请点击此处", onBtnNetISP);
			m_btnNetISP.normalColor = UtilColor.RED;
			m_btnNetISP.overColor = UtilColor.RED;
			m_btnNetISP.downColor = UtilColor.RED;
			m_btnNetISP.setPos(0, 170);*/	// 调整网络 ISP 位置
			m_logBtn = new ButtonText(this, -275, 90, "日志", onLogBtnClick);
			
		
			
			m_state = EntityCValue.PgNo;	// 0: 第一次进入游戏加载资源
			super.onReady();		
			
		}
		
		override public function onShow():void
		{
			onStageReSize();
			
			// 调整进度条位置
			//(m_progBarOneLoading.bar as ComProgBarLoading).beginDaojishi(100 * 1000);
			//(m_progBarLoading.bar as ComProgBarLoading).beginDaojishi(100 * 1000);
			
			// 调整位置，这个 UI 所在的层的位置，可能这个时候加载进度条正在显示
			if (this.parent.numChildren > 1)
			{
				this.parent.addChildAt(this, this.parent.numChildren - 1);
			}
		}	
	
		override public function onStageReSize():void
		{
			super.onStageReSize();
			// 绘制背景
			//if(m_loadBG.m_bLogoLoaded)
			//{
				var wS:Number = m_context.m_config.m_curWidth;
				var hS:Number = m_context.m_config.m_curHeight;
				this.graphics.clear()
				this.graphics.beginFill(0x000000);				
				this.graphics.drawRect( -this.x, -this.y, wS, hS);
				this.graphics.endFill();
			//}
			
		
		}
		
		override public function onHide():void
		{
			//m_state = 1;	// 第一次隐藏的时候就是改成 1
			
			m_loadingRes.length = 0;
			m_loadedRes.length = 0;
			m_failedRes.length = 0;
			
			// 处理一些信息
			if(EntityCValue.PgHeroSel == m_state)	// 角色选择
			{
				// 显示登陆界面
				//m_gkcontext.m_UIMgr.loadForm(UIFormID.UIHeroSelectNew);
				
								
				// 加载 UI
				//m_gkcontext.m_UIMgr.load1000SceneRes();
				m_state = EntityCValue.Pg1001FES;	// 设置下一个阶段
			}
			else if(EntityCValue.Pg1001FES == m_state)	// 这个条件不会进来的
			{
				m_state = EntityCValue.PgFES;	// 设置下一个阶段
			}
			else if(EntityCValue.PgFES == m_state)		// 第一次进入场景
			{
				// 给服务器发送消息
				var cmd:stClientResourceLoadOverLoginCmd = new stClientResourceLoadOverLoginCmd();
				cmd.isnew = m_context.m_bNewHero;
				m_context.sendMsg(cmd);

				// 释放背景
				//this.removeChild(this.m_loadBG);
				//this.m_loadBG.dispose();
				//this.m_loadBG = null;

				// 释放政府信息
				this.removeChild(this.m_orgInfo);
				this.m_orgInfo.dispose();
				this.m_orgInfo = null;
				
				//m_gkcontext.m_removeLogo();
				
				// 启动延迟加载
				if (m_context.m_gkcontext)
				{
					m_context.m_gkcontext.onIntoScene();
				}
				
				m_state = EntityCValue.PgNFES;	// 设置下一个阶段
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			m_context.progLoading = null;
		}	
		
		public function loadRes():void
		{
			//this.m_loadBG.loadRes();
			(m_progBarLoading.bar as ComProgBarLoading).loadRes();
			(m_progBarOneLoading.bar as ComProgBarLoading).loadRes();
		}
		
		// 资源加载成功
		public function progResLoaded(path:String):void
		{
			Logger.info(null, null, "UIProgLoading::progResLoaded " + path + " loaded");
			
			var residx:int = m_loadingRes.indexOf(path);
			if (residx != -1)
			{
				m_loadedRes.push(m_loadingRes[residx]);
				m_loadingRes.splice(residx, 1);
				//m_loadingRes.splice(residx, 1);
				// 更新进度条
				m_progBarLoading.value = m_loadedRes.length + m_failedRes.length;
				updateTotalDesc(path, Number((m_progBarLoading.value/m_progBarLoading.maximum).toFixed(2)) * 100);
			}
			
			// 是否加载完成
			//if (m_loadedRes.length + m_failedRes.length == m_loadingRes.length)
			//{
				//exit();
			//}
		}
		
		// 资源加载失败
		public function progResFailed(path:String):void
		{
			Logger.error(null, null, "UIProgLoading::progResFailed " + path + " failed");

			var residx:int = m_loadingRes.indexOf(path);
			if (residx != -1)
			{
				m_failedRes.push(m_loadingRes[residx]);
				m_loadingRes.splice(residx, 1);
				//m_loadingRes.splice(residx, 1);
				// 更新进度条
				m_progBarLoading.value = m_loadedRes.length + m_failedRes.length;
			}
			
			// 是否加载完成
			//if (m_loadedRes.length + m_failedRes.length == m_loadingRes.length)
			//{
				//exit();
			//}
		}
		
		// 资源进度
		public function progResProgress(path:String, percent:Number):void
		{
			Logger.info(null, null, "UIProgLoading::progResProgress " + path + " progress " + int(percent));
			var residx:int = m_loadingRes.indexOf(path);
			if (residx != -1)
			{
				updateOneDesc(path, Number(percent.toFixed(2)) * 100);
				m_progBarOneLoading.value = percent;
			}
		}
		
		// 资源开始
		public function progResStarted(path:String):void
		{
			Logger.info(null, null, "UIProgLoading::progResStarted " + path);
			var residx:int = m_loadingRes.indexOf(path);
			if (residx != -1)
			{
				updateOneDesc(path, 0);
				m_progBarOneLoading.value = 0;
			}
		}
		
		// 跳跃地图的时候需要加载的资源
		//public function addProgLoadResPath(path:String):void
		//{
		//	m_loadingRes.push(path);
		//}
		
		// 更新一个资源加载的进度显示
		public function updateOneDesc(path:String, percent:Number):void
		{
			UtilHtml.beginCompose();
			UtilHtml.add("正在加载 " + path + " 进度" + int(percent) + "%", UtilColor.GREEN, 12);	
			m_onedesc.htmlText = UtilHtml.getComposedContent();
		}
		
		// 更新总资源加载的进度显示
		public function updateTotalDesc(path:String, percent:Number):void
		{
			UtilHtml.beginCompose();
			UtilHtml.add("总进度 " + int(percent) + "%", UtilColor.GREEN, 12);	
			m_totaldesc.htmlText = UtilHtml.getComposedContent();
		}
		
		// 添加加载的资源
		public function addResName(path:String):void
		{
			m_loadingRes.push(path);
			m_progBarLoading.maximum = m_loadingRes.length;
		}
		
		// 开始加载资源
		public function startLoading():void
		{
			//m_progBarLoading.maximum = m_loadingRes.length;
			m_loadingRes.length = 0;
			m_progBarOneLoading.maximum = 1;
		}
		
		public function isState(value:uint):Boolean
		{
			return (m_state == value);	// 如果进行过角色选择或者没有角色选择(就是默认的角色选择)阶段，就是第一次进入场景
		}
		
		public function set state(value:uint):void
		{
			m_state = value;
		}
		
		public function reset():void
		{
			m_progBarLoading.maximum = 1;
			m_progBarLoading.value = 0;
			m_progBarOneLoading.maximum = 1;
			m_progBarOneLoading.value = 0;
			
			m_onedesc.htmlText = "";
			m_totaldesc.htmlText = "";
		}
		
		public function setText(text:String):void
		{
			UtilHtml.beginCompose();
			UtilHtml.add(text, UtilColor.GREEN, 12);	
			m_totaldesc.htmlText = UtilHtml.getComposedContent();
		}
	
		private function onLogBtnClick(event:MouseEvent):void
		{
			m_context.m_debugLog.info(m_context.m_logContent);
		}
		
		
		public function showPrompt(str:String):void
		{
			if (m_promptLabel == null)
			{
				m_promptLabel = new Label(this, 0, 0, "", UtilColor.RED);
				m_promptLabel.setPos(0, m_progBarOneLoading.y-20);
				//m_promptLabel.setPos(m_progBarOneLoading.x+(m_progBarLoading.bar as PanelContainer).width/2, m_progBarOneLoading.y+50);
				m_promptLabel.align = CENTER;
			}
			
			m_promptLabel.text = "登陆出现问题，请刷新页面重新进入";
		}
		
		
		public function hideLogBtn():void
		{
			m_logBtn.visible = false;
		}
	}
}