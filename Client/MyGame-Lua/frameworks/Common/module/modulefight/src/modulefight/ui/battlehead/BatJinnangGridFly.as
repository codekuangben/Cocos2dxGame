package modulefight.ui.battlehead 
{
	import com.ani.AniPositionParamEquation;
	import com.ani.AniPropertys;
	import com.ani.equation.EquationBezierCurve2;
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.easing.Linear;
	import com.pblabs.engine.entity.EntityCValue;
	
	import flash.display.DisplayObjectContainer;
	//import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import modulecommon.GkContext;
	import modulecommon.appcontrol.DigitComponent;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.skill.JinnangIcon;
	import modulecommon.scene.prop.skill.SkillMgr;
	import modulecommon.scene.wu.JinnangItem;
	
	/**
	 * ...
	 * @author 
	 * 用于飞行的锦囊类的定义
	 * 此对象被加到显示列表中，是直接在UIBattleHead对象中的
	 */
	
	public class BatJinnangGridFly extends Component
	{
		public static const SLJN:uint = 0;	// 锦囊
		public static const SLTuoWeiEff:uint = 1;	// 脱尾特效
		public static const SLBaoZhaEff:uint = 2;	// 爆炸特效层
		public static const SLRedDigit:uint = 3;	// 红色数字层
		public static const SLGreenDigit:uint = 4;// 绿色数字层,包括比拼数字以及相克数字
		public static const SLCount:uint = 5;		// 总共层数
		
		
		private var m_gkContext:GkContext;
		private var m_bgPnl:Panel;
		private var m_iconPanel:JinnangIcon;
		private var m_jinnangItem:JinnangItem;
		
		//private var m_jinnangFlyEquation:JinnangFlyEquation;
		private var m_jinnangFlyEquation:EquationBezierCurve2;		// 改成
		private var m_flyAni:AniPositionParamEquation;
		//private var m_scaleAni:AniPropertys;

		private var m_flyEff:Ani;	// 飞行特效
		private var m_alphaAni:AniPropertys;	// 飞行特效的 alpha 属性
		private var m_backAni:AniPropertys;	// 碰撞后向后倒退
		private var m_jnFadeAni:AniPropertys;	// 破碎的锦囊数值降到 0 后淡出
		
		private var m_expEff:Ani;	// 破碎特效
		public var m_jnAniData:DataJNAni;	// 这个是锦囊动画需要的数据
		public var m_side:uint;	// 自己是哪一方的
		
		public var m_digitVec:Vector.<DigitComponent>;		// 数字
		public var m_minusVec:Vector.<Panel>;				// 这个是减号
		public var m_dataAniVec:Vector.<AniPropertys>;	// 数字动画
		public var m_staicdigit:DigitComponent;		// 数字,这个是不动的数字
		
		public var m_posuiPnl:Panel;		// 破碎飘的字
		public var m_aniPnl:AniPropertys;	// 破碎飘的字的动画
		
		public var m_timerDigit:uint;		// 定时器 ID,数字减少
		public var m_decCnt:int;			// 减少的数量
		public var m_layerList:Vector.<DisplayObjectContainer>;	// 所有的层的列表
		
		public function BatJinnangGridFly(gk:GkContext) 
		{
			m_gkContext = gk;
			
			m_layerList = new Vector.<DisplayObjectContainer>(SLCount, true);
			var idx:uint = 0;
			while(idx < m_layerList.length)
			{
				m_layerList[idx] = new Sprite();
				this.addChild(m_layerList[idx]);
				++idx;
			}
			
			// 地图
			m_bgPnl = new Panel(m_layerList[SLJN], -3, -2);
			m_bgPnl.setPanelImageSkin(ZObject.IconBg);
			
			m_iconPanel = new JinnangIcon(gk);
			m_iconPanel.showNum = false;
			m_layerList[SLJN].addChild(m_iconPanel);
			m_iconPanel.setSize(SkillMgr.ICONSIZE_Normal, SkillMgr.ICONSIZE_Normal);
			
			m_jinnangFlyEquation = new EquationBezierCurve2();
			m_jinnangFlyEquation.tInit = 0;
			m_jinnangFlyEquation.tEnd = 1;
			
			m_flyAni = new AniPositionParamEquation();
			m_flyAni.equation = m_jinnangFlyEquation;
			m_flyAni.sprite = this;
			m_flyAni.duration = 1;
			m_flyAni.ease = Exponential.easeIn;
			//m_flyAni.onEnd = onFlyAniEnd;
			m_flyAni.onEnd = onBezierEnd;
			
			//m_scaleAni = new AniPropertys();
			//m_scaleAni.sprite = this;
			//m_scaleAni.duration = 1;
			//m_scaleAni.ease = Exponential.easeIn;
			
			m_alphaAni = new AniPropertys();
			//m_alphaAni.sprite = m_flyEff;
			m_alphaAni.duration = 0.7;
			m_alphaAni.ease = Exponential.easeIn;
			
			m_backAni = new AniPropertys();
			m_backAni.duration = 0.3;
			m_backAni.ease = Exponential.easeOut;	// 碰撞后推
			
			m_digitVec = new Vector.<DigitComponent>();
			m_dataAniVec = new Vector.<AniPropertys>();
			m_minusVec = new Vector.<Panel>();
			
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		//设置锦囊
		public function setJinnang(jinang:JinnangItem):void
		{
			m_jinnangItem = jinang;
			m_iconPanel.setSkillID(m_jinnangItem);
			m_iconPanel.alpha = 1;
			
			// 特效
			if (null == m_flyEff)
			{
				m_flyEff = new Ani(m_gkContext.m_context);
				m_flyEff.duration = 1;
				m_flyEff.repeatCount = int.MAX_VALUE;	// 无限循环播放
				if(!m_side)	// 如果是左边
				{
					m_flyEff.setImageAni("jntuowei.swf");
					m_flyEff.x = -52;
					m_flyEff.y = 12;
				}
				else
				{
					m_flyEff.setImageAniMirror("jntuowei.swf", Image.MirrorMode_HOR);
					m_flyEff.x = 93;
					m_flyEff.y = 12;
				}
				m_flyEff.centerPlay = true;
				m_flyEff.mouseEnabled = false;
				m_flyEff.stop();
				m_layerList[SLTuoWeiEff].addChild(m_flyEff);
			}
			
			if (m_flyEff)
			{
				m_flyEff.alpha = 0;
				m_flyEff.begin();
			}
		}
		
		//锦囊启动飞行。飞到目的位置后，锦囊Icon（左边）的框的右边线在屏幕的中间(x方向), 其值是posCenter。下边线的位置是固定值(posBottom)。右边锦囊类似
		//dir:飞行的方向(EntityCValue.RKLeft或EntityCValue.RKRight)		
		//bRestrained: true -表示被抑制
		public function fly(dir:int):void
		{
			//锦囊Icon飞到目的位置后，YBottom
			var posBottom:Number = m_gkContext.m_context.m_config.m_curHeight / 2;	
			var posCenter:Number = m_gkContext.m_context.m_config.m_curWidth / 2;
			var scaleBig:Number = 1.3;	//锦囊放大时的倍数
			var scaleSmall:Number = 0.8; //锦囊缩小时的倍数
			
			var xDest:Number;
			var yDest:Number;
			var xDestSize:Number;
			var yDestSize:Number;
			var scaleValue:Number = 1.0;
			// 如果是克制关系
			//if (m_jnAniData.relBetwJN() == DataJNAni.RelKZ)
			//{
			//	scaleValue = scaleSmall;
			//}
			//else
			//{
			//	scaleValue = scaleBig;
			//}
			
			xDestSize = SkillMgr.ICONSIZE_Normal * scaleValue;
			yDestSize = xDestSize;
			
			yDest = posBottom - yDestSize * 0.5;
			
			var k:Number;
			if (dir == EntityCValue.RKRight)
			{
				xDest = posCenter - xDestSize;				
			}
			else
			{
				xDest = posCenter;				
			}
			
			//m_jinnangFlyEquation.setFlyPos(this.x, this.y, xDest, yDest);
			// 贝塞尔曲线  参数
			var xS:Number = this.x;
			var yS:Number = this.y;
			
			var xP1:Number = (xDest - xS) * 0.5 + xS;
			//var yP1:Number = (yDest - yS) * 0.5 + yS + 80;
			var yP1:Number = yDest;
			m_jinnangFlyEquation.setPS(xS, yS);
			m_jinnangFlyEquation.setP(xP1, yP1);
			m_jinnangFlyEquation.setPD(xDest, yDest);
			//m_scaleAni.resetValues({scaleX:scaleValue, scaleY:scaleValue});
			m_alphaAni.resetValues({alpha:1});
			
			m_flyAni.begin();
			//m_scaleAni.begin();
			m_alphaAni.sprite = m_flyEff;
			m_alphaAni.begin();
			
			// 播放飞行的声音
			m_gkContext.m_commonProc.playMsc(14, uint.MAX_VALUE);
		}
		//锦囊启动消失
		//public function disappear():void
		//{			
			//m_scaleAni.resetValues( { alpha:0 } );
			//m_scaleAni.duration = 0.6;
			//m_scaleAni.onEnd = destroySelf;
			//m_scaleAni.begin();
		//}
		
		//全部消失后，调用此函数
		public function destroySelf():void
		{
			this.removeSelfFromDisplayList();
			dispose();			
		}
		
		override public function dispose():void
		{
			if(m_flyAni)
			{
				m_flyAni.dispose();
				m_flyAni = null;
			}
			
			if (m_flyEff)
			{
				m_flyEff.dispose();
			}
			if (m_expEff)
			{
				m_expEff.dispose();
			}
			//m_scaleAni.dispose();
			if(m_alphaAni)
			{
				m_alphaAni.dispose();
				m_alphaAni = null;
			}
			m_jnAniData = null;
			
			if(m_aniPnl)
			{
				m_aniPnl.dispose();
				m_aniPnl = null;
			}
			if(m_timerDigit)
			{
				clearInterval(m_timerDigit);
				m_timerDigit = 0;
			}
			if(m_backAni)
			{
				m_backAni.dispose();
				m_backAni = null;
			}
			if(m_jnFadeAni)
			{
				m_jnFadeAni.dispose();
				m_jnFadeAni = null;
			}
			if(m_digitVec)
			{
				for each(var datacom:DigitComponent in m_digitVec)
				{
					datacom.removeSelfFromDisplayList();
					datacom.dispose();
				}
			
				m_digitVec.length = 0;
				m_digitVec = null;
			}
			if(m_dataAniVec)
			{
				for each(var dataani:AniPropertys in m_dataAniVec)
				{
					dataani.dispose();
				}
				m_dataAniVec.length = 0;
				m_dataAniVec = null;
			}
			super.dispose();
		}
		
		protected function onBezierEnd():void
		{
			// 停止飞行的声音
			m_gkContext.m_commonProc.stopMsc(14);

			var destx:Number = 0;
			if(!m_side)
			{
				destx = this.x - 10;
			}
			else
			{
				destx = this.x + 10;
			}
			
			m_backAni.resetValues({x:destx});
			m_backAni.sprite = this;
			m_backAni.onEnd = onBackAniEnd;
			m_backAni.begin();
			
			// 特效开始淡出
			m_alphaAni.resetValues({alpha:0});
			m_alphaAni.begin();
		}
		
		// 碰撞后后推
		protected function onBackAniEnd():void
		{
			var destx:Number = 0;
			if(m_jnAniData.relBetwJN() == DataJNAni.RelNo)	// 如果没有关系,说明只有一方释放锦囊
			{
				onFlyAniEnd();
			}
			else if(m_jnAniData.relBetwJN() == DataJNAni.RelKZ)	// 如果是克制关系
			{
				if(m_jnAniData.m_jnProcess.m_battleArray.aTeamid != m_side)	// 如果自己是失败方
				{
					if(!m_side)
					{
						destx = this.x - 40;
					}
					else
					{
						destx = this.x + 40;
					}

					m_backAni.duration = 0.3;
					m_backAni.ease = Exponential.easeIn;	// 碰撞后推
					m_backAni.onEnd = onFlyAniEnd;
					m_backAni.resetValues({x:destx});
					m_backAni.begin();
				}
			}
			else if(m_jnAniData.relBetwJN() == DataJNAni.RelEqual)	// 如果相等
			{
				if(!m_side)
				{
					destx = this.x - 40;
				}
				else
				{
					destx = this.x + 40;
				}
				
				m_backAni.duration = 0.3;
				m_backAni.ease = Exponential.easeIn;	// 碰撞后推
				m_backAni.onEnd = onFlyAniEnd;
				m_backAni.resetValues({x:destx});
				m_backAni.begin();
			}
			else if( m_jnAniData.relBetwJN() == DataJNAni.RelNotEqual)	// 如果攻击方获胜或者被击方获胜
			{
				if(m_jnAniData.ifFailSide(m_side))	// 如果自己是失败方
				{
					if(!m_side)
					{
						destx = this.x - 40;
					}
					else
					{
						destx = this.x + 40;
					}
				}
				else
				{
					if(!m_side)
					{
						destx = this.x;
					}
					else
					{
						destx = this.x;
					}
				}
				
				m_backAni.duration = 0.3;
				m_backAni.ease = Exponential.easeIn;	// 碰撞后推
				m_backAni.onEnd = onFlyAniEnd;
				m_backAni.resetValues({x:destx});
				m_backAni.begin();
			}
		}
		
		//飞行结束后，调用此函数
		protected function onFlyAniEnd():void
		{
			var ypos:int = 0;
			// 停止特效播放
			m_flyEff.stop();
			m_flyEff.visible = false;
			
			if(m_jnAniData.relBetwJN() == DataJNAni.RelNo)	// 如果没有关系,说明只有一方释放锦囊
			{
				onExpAniEnd(null);		// 直接结束
			}
			else if(m_jnAniData.relBetwJN() == DataJNAni.RelKZ)	// 如果是克制关系
			{
				if(m_jnAniData.m_jnProcess.m_battleArray.aTeamid != m_side)	// 如果自己失败方
				{
					// 播放破碎特效
					if(!m_expEff)
					{
						m_expEff = new Ani(m_gkContext.m_context);
						m_expEff.duration = 0.5;
						m_expEff.repeatCount = 1;
						m_expEff.setImageAni("jnposui.swf");
						m_expEff.x = 20;
						m_expEff.y = 70;
						m_expEff.centerPlay = true;
						m_expEff.mouseEnabled = false;
						m_expEff.onCompleteFun = onExpAniEnd;	// 破碎特效播放完成
						m_layerList[SLBaoZhaEff].addChild(m_expEff);
					}
					
					m_expEff.visible = true;
					m_expEff.begin();
					
					// 播放飞行的声音
					m_gkContext.m_commonProc.playMsc(13);
					
					// 破碎飘升的字
					if(!m_posuiPnl)
					{
						m_posuiPnl = new Panel(m_layerList[SLGreenDigit]);
						m_posuiPnl.setPanelImageSkin("jinengming/beikezhi.png");
						m_aniPnl = new AniPropertys();
						
						m_aniPnl.sprite = m_posuiPnl;
						m_aniPnl.duration = 1;
						m_aniPnl.ease = Exponential.easeIn;
						ypos = m_posuiPnl.y - 30;
						m_aniPnl.resetValues({y:ypos, alpha:0.3});
						m_aniPnl.begin();
					}
					
					m_posuiPnl.setPos(-8, 0);
					m_posuiPnl.visible = true;
				}
			}
			//else if(m_jnAniData.relBetwJN() == DataJNAni.RelEqual)	// 如果比较相等
			//{
			//	onExpAniEnd();		// 直接结束
			//}
			else if(m_jnAniData.relBetwJN() == DataJNAni.RelEqual || 
					 m_jnAniData.relBetwJN() == DataJNAni.RelNotEqual)	// 如果攻击方获胜或者被击方获胜
			{
				// 红色减少数字
				m_decCnt = 0;
				if(!m_staicdigit)
				{
					m_staicdigit = new DigitComponent(m_gkContext.m_context, m_layerList[SLRedDigit]);
					m_staicdigit.setSize(80, 43); 
					//m_staicdigit.setDigitPath("commoncontrol/digit/normaldigit");	// 红色数字
					m_staicdigit.setParam("commoncontrol/digit/addhpdigit",30,43);	// 红色数字
				
					m_staicdigit.digit = m_jnAniData.getNumJinnang(m_side);
				}
				if(!m_timerDigit)
				{
					m_timerDigit = setInterval(updateDigit, 500);
				}
				
				m_staicdigit.setPos(8, 3);
				m_staicdigit.visible = true;
			}
		}
		
		// 破碎特效
		protected function onExpAniEnd(ani:Ani):void
		{
			// 这个是飞行的最后一个调用的函数,把自己移出
			//m_jnAniData.m_jnCnter.removeChild(this);
			if(m_jnAniData.relBetwJN() == DataJNAni.RelEqual)		// 如果是数值比拼,并且相等,这个时候只要一个会doajiuxing了
			{
				if(!m_side)	// 两个是比较数值的,并且相等,只有一个回调就行了
				{
					//if (m_jnAniData.m_pzCB != null)
					//{
					//	m_jnAniData.m_pzCB();
					//}
					// 如果是两个锦囊比较数字，并且相等，直接退出，最后的爆炸效果也不要了
					if(m_jnAniData.m_bzCB != null)
					{
						m_jnAniData.m_bzCB();
					}
				}
				destroySelf();
			}
			else
			{
				if (m_jnAniData.m_pzCB != null)
				{
					m_jnAniData.m_pzCB();
				}
			}

			// 只有克制，比拼数值不相等这 3 中情况才需要协调释放另外一个锦囊特效，其它情况直接释放了
			//if( m_jnAniData.relBetwJN() == DataJNAni.RelKZ || 
			//	m_jnAniData.relBetwJN() == DataJNAni.RelAtt || 
			//	m_jnAniData.relBetwJN() == DataJNAni.RelHurt
			//   )	// 如果是两个锦囊
			//{
				// 同时释放另外一个
			//	m_jnAniData.m_jnFly[1 - m_side].destroySelf();
			//}
			
			// 最后释放自己，一定要放在最后
			//destroySelf();
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			if (m_jinnangItem == null)
			{
				return;
			}
			m_gkContext.m_uiTip.hideTip();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if (m_jinnangItem == null)
			{
				return;
			}
			var pt:Point = this.localToScreen(new Point(43, 0));
			m_gkContext.m_uiTip.hintSkillInfo(pt, m_jinnangItem.idLevel);
		}

		// 更新红色不断减少的数字
		public function updateDigit():void
		{
			var ypos:uint = 0;
			// 生成减少的数字
			++m_decCnt;
			if(m_decCnt <= m_jnAniData.m_decLvl)
			{
				// 更新数字
				m_staicdigit.digit = m_jnAniData.getNumJinnang(m_side) - m_decCnt;
				// 添加一个新的数字
				// 蓝色数字
				m_digitVec.push(new DigitComponent(m_gkContext.m_context, m_layerList[SLGreenDigit]));
				m_minusVec.push(new Panel(m_digitVec[m_digitVec.length - 1]));	// 减号
				m_minusVec[m_minusVec.length - 1].setPanelImageSkin("commoncontrol/digit/normaldigit/subtract.png");
				m_minusVec[m_minusVec.length - 1].x = -20;
				m_minusVec[m_minusVec.length - 1].y = 13;
				m_digitVec[m_digitVec.length - 1].setSize(80, 43); 
				//m_digitVec[m_digitVec.length - 1].setDigitPath("commoncontrol/digit/addhpdigit");
				m_digitVec[m_digitVec.length - 1].setParam("commoncontrol/digit/normaldigit", 30,43);
				m_digitVec[m_digitVec.length - 1].digit = 1;
				m_digitVec[m_digitVec.length - 1].setPos(8, 0);

				m_dataAniVec.push(new AniPropertys());
				m_dataAniVec[m_dataAniVec.length - 1].sprite = m_digitVec[m_digitVec.length - 1];
				m_dataAniVec[m_dataAniVec.length - 1].duration = 0.8;
				m_dataAniVec[m_dataAniVec.length - 1].ease = Linear.easeNone;
				// 插值 y 和 alpha
				ypos = 120;
				m_dataAniVec[m_dataAniVec.length - 1].resetValues({y:ypos, alpha:0});
				m_dataAniVec[m_dataAniVec.length - 1].begin();
				
				if(m_decCnt == m_jnAniData.m_decLvl)	// 数值相等或者失败一方,在数值降到 0 时候,锦囊图片消失
				{
					if(m_jnAniData.ifFailSide(m_side))	// 如果自己是失败方
					{
						if(!m_jnFadeAni)
						{
							m_jnFadeAni = new AniPropertys();
							m_jnFadeAni.sprite = m_iconPanel;
							m_jnFadeAni.duration = 0.2;
							m_jnFadeAni.ease = Exponential.easeIn;
							m_jnFadeAni.resetValues({alpha:0});
						}
						m_jnFadeAni.begin();
					}
				}
			}
			else	// 清除定时器
			{
				clearInterval(m_timerDigit);
				m_timerDigit = 0;
				
				// 清除所有的数字
				for each(var datacom:DigitComponent in m_digitVec)
				{
					datacom.removeSelfFromDisplayList();
					datacom.dispose();
				}
				m_digitVec.length = 0;
				for each(var dataani:AniPropertys in m_dataAniVec)
				{
					dataani.dispose();
				}
				m_dataAniVec.length = 0;
				
				// 判断是不是由于拼数值导致失败,需要播放爆炸效果
				if(m_jnAniData.ifFailSide(m_side))
				{
					// 隐藏数字
					//m_staicdigit.visible = false;
					failExpEffCB();	// 播放爆炸特效
				}
				else if(DataJNAni.RelEqual == m_jnAniData.relBetwJN())	// 如果两边数值相等
				{
					failExpEffCB();	// 播放爆炸特效,这个两边都播放
				}
			}
		}
		
		// 比对失败爆炸特效
		public function failExpEffCB():void
		{
			// 播放破碎特效
			if(!m_expEff)
			{
				m_expEff = new Ani(m_gkContext.m_context);
				m_expEff.duration = 0.5;
				m_expEff.repeatCount = 1;
				m_expEff.setImageAni("jnposui.swf");
				m_expEff.x = 20;
				m_expEff.y = 70;
				m_expEff.centerPlay = true;
				m_expEff.mouseEnabled = false;
				m_expEff.onCompleteFun = onExpAniEnd;	// 破碎特效播放完成
				m_layerList[SLBaoZhaEff].addChild(m_expEff);
			}

			m_expEff.begin();
			
			// 播放飞行的声音
			m_gkContext.m_commonProc.playMsc(13);
		}
		
		// 停止锦囊的播放
		public function stopJN():void
		{
			if(m_flyAni)
			{
				m_flyAni.stop();
			}
			if(m_flyEff)
			{
				m_flyEff.stop();
			}
			if(m_alphaAni)
			{
				m_alphaAni.end();
			}
			
			if(m_backAni)
			{
				m_backAni.end();
			}
			if(m_jnFadeAni)
			{
				m_jnFadeAni.end();
			}
			if(m_expEff)
			{
				m_expEff.stop();
			}
			
			for each(var aniprop:AniPropertys in m_dataAniVec)
			{
				aniprop.end();
			}
			
			if(m_timerDigit)
			{
				clearInterval(m_timerDigit);
				m_timerDigit = 0;
			}
		}
	}
}