package modulefight.ui.battlehead
{
	import com.ani.AniPropertys;
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.easing.Linear;
	import com.pblabs.engine.debug.Logger;
	import com.util.DebugBox;
	import common.event.UIEvent;
	import flash.events.Event;
	import modulecommon.scene.wu.JinnangItem;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import modulecommon.GkContext;
	import modulecommon.scene.prop.skill.SkillMgr;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TSkillBaseItem;

	/**
	 * @brief 锦囊碰撞后的爆炸以及锦囊文字效果
	 * */
	public class SubJNColde extends Component
	{
		private var m_gkContext:GkContext;
		private var m_expEff:Ani;		// 爆炸特效
		
		protected var m_alphaAni:AniPropertys;	// 这个是锦囊名字图片淡入
		protected var m_alphaEffAni:AniPropertys;	// 这个是特效淡入
		private var m_jnNamePnl:Panel;	// 锦囊名字 panel
		//public var m_jnName:String;	// 锦囊名字
		protected var m_bNameShow:Boolean = false;	// 锦囊名字面板是否显示
		public var m_timer:uint;		// 定时器 ID
		
		public var m_jnAniData:DataJNAni;	// 这个是锦囊动画需要的数据		
		
		public function SubJNColde(gkcon:GkContext, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			m_gkContext = gkcon;
			super(parent, xpos, ypos);
			//m_jnName = "liehuoliaoyuan";
		}

		// 显示
		public function show():void
		{
			if (!m_expEff)
			{
				m_expEff = new Ani(m_gkContext.m_context);
				m_expEff.duration = 1;
				m_expEff.repeatCount = 1;
				m_expEff.setImageAni("jnbaozha.swf");	// 爆炸
				m_expEff.x = 0;
				m_expEff.y = 0;
				m_expEff.centerPlay = true;
				m_expEff.mouseEnabled = false;
				m_expEff.m_fcomp = onAinEnd;
				m_expEff.stop();
				//m_expEff.onCompleteFun = m_jnAniData.m_bzCB;	// 爆炸效果结束
				if(DataJNAni.RelEqual != m_jnAniData.relBetwJN())
				{
					m_expEff.m_fpreframe = onPreFrame;		// 每一镇之前调用
				}
				this.addChild(m_expEff);
			}
			// 如果是等级比拼,并且数值相等, 此时 m_battleArray 是空值,这个时候是不显示锦囊名字的
			if(DataJNAni.RelEqual != m_jnAniData.relBetwJN())
			{
				if(!m_jnNamePnl)
				{
					m_jnNamePnl = new Panel(this);
					m_jnNamePnl.addEventListener(UIEvent.IMAGELOADED, onLoadedJnNameLoaded);
				}
				m_jnNamePnl.alpha = 0;
				// 手工加载
				// bug: 锦囊名字只配置一个技能段的第一个,例如 3001 3002 ,只配置在 3001 里面,都需要读取 3001 的
				var jinnangItem:JinnangItem = m_jnAniData.victoryJinnangItem;
				var skillitem:TSkillBaseItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_SKILL, jinnangItem.idInit) as TSkillBaseItem;
				if (skillitem)
				{
					var imageName:String = "jinengming/" + skillitem.m_fazhaoPic + ".png";
					m_jnNamePnl.setPanelImageSkin(imageName);		
				}
				else
				{
					DebugBox.sendToDataBase("SubJNColde:show skillitem==null jinnangItem.idInit="+jinnangItem.idInit);
				}
			}
			if (m_expEff)
			{
				m_expEff.visible = true;
				m_expEff.begin();
			}
			
			if(!m_alphaEffAni)
			{
				m_expEff.alpha = 0;
				m_alphaEffAni = new AniPropertys();
				m_alphaEffAni.sprite = m_expEff;
				m_alphaEffAni.duration = 0.5;
				m_alphaEffAni.ease = Exponential.easeIn;
				m_alphaEffAni.resetValues({alpha:1});
			}
			m_alphaEffAni.begin();
			
			// 调整位置
			var globalpt:Point;
			if(m_jnAniData.relBetwJN() == DataJNAni.RelNo)	// 如果没有关系,说明只有一方释放锦囊
			{
				globalpt = m_jnAniData.m_jnFly[m_jnAniData.jnSide()].localToGlobal(new Point(SkillMgr.ICONSIZE_Normal * 0.5, SkillMgr.ICONSIZE_Normal * 0.5));
				globalpt = this.globalToLocal(globalpt);
				
				m_expEff.x = globalpt.x;
				m_expEff.y = globalpt.y;
				
			}
			else if(m_jnAniData.relBetwJN() == DataJNAni.RelKZ)	// 如果是克制关系,被克制一方一定是被击一方,攻击方一定是克制别人的一个
			{
				globalpt = m_jnAniData.m_jnFly[m_jnAniData.jnSide()].localToGlobal(new Point(SkillMgr.ICONSIZE_Normal * 0.5, SkillMgr.ICONSIZE_Normal * 0.5));
				globalpt = this.globalToLocal(globalpt);
				
				m_expEff.x = globalpt.x;
				m_expEff.y = globalpt.y;
			}
			else if( m_jnAniData.relBetwJN() == DataJNAni.RelNotEqual)	// 如果攻击方获胜或者被击方获胜
			{
				if(m_jnAniData.ifFailSide(0))
				{
					globalpt = m_jnAniData.m_jnFly[1].localToGlobal(new Point(SkillMgr.ICONSIZE_Normal * 0.5, SkillMgr.ICONSIZE_Normal * 0.5));
				}
				else
				{
					globalpt = m_jnAniData.m_jnFly[0].localToGlobal(new Point(SkillMgr.ICONSIZE_Normal * 0.5, SkillMgr.ICONSIZE_Normal * 0.5));
				}
				globalpt = this.globalToLocal(globalpt);
				
				m_expEff.x = globalpt.x;
				m_expEff.y = globalpt.y;
			}
		}
		
		private function onLoadedJnNameLoaded(e:Event):void
		{
			m_jnNamePnl.setPos((m_gkContext.m_context.m_config.m_curWidth - m_jnNamePnl.width) * 0.5, (m_gkContext.m_context.m_config.m_curHeight - m_jnNamePnl.height) * 0.5);
		}

		override public function dispose():void
		{
			m_jnAniData = null;
			// 手工释放
			if(m_expEff && !this.contains(m_expEff))
			{
				m_expEff.dispose();
				m_expEff = null;
			}
			if(m_timer)
			{
				clearInterval(m_timer);
				m_timer = 0;
			}
			if(m_alphaAni)
			{
				m_alphaAni.dispose();
				m_alphaAni = null;
			}
			if(m_alphaEffAni)
			{
				m_alphaEffAni.dispose();
				m_alphaEffAni = null;
			}
			
			m_gkContext = null;
			if (m_jnNamePnl)
			{
				m_jnNamePnl.removeEventListener(UIEvent.IMAGELOADED, onLoadedJnNameLoaded);
			}
			super.dispose();
		}
		
		
		
		protected function onAinEnd(ani:Ani):void
		{
			if(m_jnAniData.m_justbzCB != null)
			{
				m_jnAniData.m_justbzCB();
			}
			// 特效结束移出,最后一阵图像会一直显示
			//this.removeChild(m_expEff);
			m_expEff.visible = false;
			m_bNameShow = false;
		}
		
		public function onPreFrame(fFrame:Number):void
		{
			// 在特效播放一半就开始播放
			if(!m_bNameShow && fFrame > 10)
			{
				m_bNameShow = true;
				
				if(!m_alphaAni)
				{
					m_alphaAni = new AniPropertys();
					m_alphaAni.sprite = m_jnNamePnl;
					m_alphaAni.duration = 0.4;
					m_alphaAni.ease = Linear.easeNone;
					m_alphaAni.resetValues({alpha:1});
				}
				m_alphaAni.begin();
				
				if(!m_timer)
				{
					m_timer = setInterval(updateTimer, 2000);	// 两秒后消失
				}
			}
		}
		
		protected function updateTimer():void
		{
			clearInterval(m_timer);
			m_timer = 0;
			if(m_jnAniData.m_bzCB != null)
			{
				m_jnAniData.m_bzCB();
			}
		}
		
		public function stopJN():void
		{
			if(m_expEff)
			{
				m_expEff.stop();
			}
			if(m_alphaAni)
			{
				m_alphaAni.end();
			}
			if(m_alphaEffAni)
			{
				m_alphaEffAni.end();
			}
		}
	}
}