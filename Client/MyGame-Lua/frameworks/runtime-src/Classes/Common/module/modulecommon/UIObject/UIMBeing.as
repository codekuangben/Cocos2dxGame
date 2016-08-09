package modulecommon.uiObject 
{
	import com.pblabs.engine.entity.EntityCValue;
	import com.util.DebugBox;
	import org.ffilmation.engine.datatypes.fPoint3d;
	
	import flash.display.Sprite;
	
	import common.Context;
	
	import modulecommon.appcontrol.BubbleWordSprite;
	import com.util.UtilHtml;
	
	import org.ffilmation.engine.model.fUIObject;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ObjectSeqRenderer;
	import org.ffilmation.utils.mathUtils;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class UIMBeing extends fUIObject
	{
		private var m_funOnArrive:Function;
		public var m_angle:Number = 0;
		public var m_vx:Number = 0;
		public var m_vy:Number = 0;
		
		public var m_dx:Number = 0;
		public var m_dy:Number = 0;
		protected var m_vel:Number = 140;	// 标量速度, 默认值: 140 
		
		protected var m_name:String;
		protected var m_order:int = -1;	// 出手顺序	 -1 表示不显示出手顺序
		protected var m_wjActived:int;	// 激活武将的数量，不显示了，显示绿，蓝，紫武将的颜色鬼，仙，神武将
		protected var m_typeName:String;	// 绿，蓝，紫武将的颜色鬼，仙，神武将
		protected var m_color:uint;			// 显示的颜色
		protected var m_showOrderActive:Boolean;	// 是否显示出手循序和激活
		private var m_bubbleSprite:BubbleWordSprite;
		
		protected var m_currentPath:Array = null;
		
		public function UIMBeing(defObj:XML, con:Context)
		{
			super(defObj, con);
			m_typeName = "";
			m_color = 0xffffff;
		}
		public override function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			updateMove(deltaTime);
		}
		override public function dispose():void
		{
			if (m_bubbleSprite != null)
			{
				m_bubbleSprite.dispose();
			}
			super.dispose();
		}
		protected function isMoving():Boolean
		{
			if (this.m_state == EntityCValue.TRun)
			{
				return true;
			}
			
			return false;
		}
		
		public function updateMove(deltaTime:Number):void
		{
			if (isMoving())
			{
				// 判断是否到达终点，放在这里可以少计算一次  
				if (this.m_dx == this.x && this.m_dy == this.y)
				{
					if (this.m_currentPath && this.m_currentPath.length > 0)
					{
						var dest3D:fPoint3d;
						dest3D = this.m_currentPath.shift();
						this.moveToPosNoAIf(dest3D.x, dest3D.y);
					}
					else
					{
						this.stopMoving();
						return;
					}
				}
				
				var angleRad:Number = this.m_angle * Math.PI / 180;
				this.m_vx = m_vel * Math.cos(angleRad);
				this.m_vy = m_vel * Math.sin(angleRad);
				
				var disx:Number = this.m_vx * deltaTime;
				var disy:Number = this.m_vy * deltaTime;
				
				if (Math.abs(this.m_dx - this.x) < Math.abs(disx))
				{
					disx = this.m_dx - this.x;
				}
				if (Math.abs(this.m_dy - this.y) < Math.abs(disy))
				{
					disy = this.m_dy - this.y;
				}

				try
				{
					this.moveTo(this.x + disx, this.y + disy, 0);
				}
				catch (e:Error)
				{
					var str:String = "m_objID=" + m_objID;
					if (customData.flash9Renderer)
					{
						str += "flash9Renderer ";
					}
					str += e.errorID + e.getStackTrace();
					DebugBox.sendToDataBase(str);
				}
			}
		}
		public function set funOnarrive(fun:Function):void
		{
			m_funOnArrive = fun;
		}
		public function moveToPos(wherex:Number, wherey:Number, ste:uint = EntityCValue.TRun):void 
		{
			this.state = ste;
			
			this.m_dx = wherex;
			this.m_dy = wherey;
			
			this.m_angle = mathUtils.getAngle(this.x, this.y, this.m_dx, this.m_dy);			
			this.startMoving();
		}
		
		public function startMoving():void
		{			
			this.updateAngle();		
			
		}
		
		// 这个主要是检测主角是否按下方向键    
		public function updateAngle():void
		{
			this.orientation = this.m_angle;
		}
		public function stopMoving():void
		{
			state = EntityCValue.TStand;
			if (m_funOnArrive != null)
			{
				m_funOnArrive();
			}
		}
		
		public function setScale(s:Number):void
		{
			var render:fFlash9ObjectSeqRenderer = (customData.flash9Renderer as fFlash9ObjectSeqRenderer);
			render.setScale(s);
			
			if (m_name)	// 只有设置了名字的才需要缩放名字
			{
				render.compensateScale(1 / s);
			}
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		public function set name(name:String):void
		{
			if(m_name != name)
			{
				m_name = name;
				updateNameDesc();
			}
		}
		public function updateNameDesc():void
		{
			var content:String = m_name;
			if(m_showOrderActive)
			{
				//content += "[" + m_wjActived + "]激活";
				if (m_typeName.length)
				{
					//content += "[" + m_typeName + "]";		// 绿，蓝，紫武将的颜色鬼，仙，神武将
					content = m_typeName + " • " + content;
				}
				
				if(m_order != -1)
				{
					content += "\n" + m_order;
				}
			}
			
			m_nameDisc = UtilHtml.formatPDirect(content, m_color, 14, UtilHtml.CENTER);	// 居中对齐
			
			if (customData.flash9Renderer)
			{
				(customData.flash9Renderer as fFlash9ObjectSeqRenderer).rawTextField = true;
			}
		}
		
		public function setBubble(str:String):void
		{
			if (m_bubbleSprite == null)
			{
				m_bubbleSprite = new BubbleWordSprite(this.m_context);
				m_bubbleSprite.setTimerComplete(onBubbleComplete);
			}
			m_bubbleSprite.setText(str);
			m_bubbleSprite.setDelayTime(3000+m_bubbleSprite.getTextLines() * 600);
			m_bubbleSprite.setPos(0, -this.getTagHeight() - 20);
			var base:Sprite = this.uiLayObj;
			if (base&&base.contains(m_bubbleSprite) == false)
			{
				base.addChild(m_bubbleSprite);
			}
			if (m_tagBounds2d.height <= 1)
			{
				m_bubbleSprite.visible = false;				
			}
		
		}
		protected function onBubbleComplete():void
		{
			var base:Sprite = this.uiLayObj;
			if (base != null && m_bubbleSprite != null)
			{
				if (base.contains(m_bubbleSprite))
				{
					base.removeChild(m_bubbleSprite);
				}
			}		
		}
		
		override public function onSetTagBounds2d():void 
		{
			if (m_bubbleSprite)
			{
				m_bubbleSprite.setPos(0, -this.getTagHeight() - 20);
				if (m_bubbleSprite.visible == false)
				{
					m_bubbleSprite.visible = true;
				}
			}
		}
		
		public function get order():int
		{
			return m_order;
		}
		
		public function set order(value:int):void
		{
			if(m_order != value)
			{
				m_order = value;
				updateNameDesc();
			}
		}
		
		//public function get wjActived():int
		//{
		//	return m_wjActived;
		//}
		
		//public function set wjActived(value:int):void
		//{
		//	if(m_wjActived != value)
		//	{
		//		m_wjActived = value;
		//		updateNameDesc();
		//	}
		//}

		public function setColorAndTypeName(typename:String, color:uint):void
		{
			if (m_typeName != typename)
			{
				m_typeName = typename;
				m_color = color
				updateNameDesc();
			}
		}
		
		public function get showOrderActive():Boolean
		{
			return m_showOrderActive;
		}
		
		public function set showOrderActive(value:Boolean):void
		{
			m_showOrderActive = value;
		}
		
		override public function getAction():uint
		{
			switch (m_state)
			{
				case EntityCValue.TDance: 
					return EntityCValue.TActSkill;
				default:
					return super.getAction();
			}
		}
		
		public function moveToPosNoAIf(wherex:Number, wherey:Number, ste:uint = EntityCValue.TRun):void 
		{
			this.state = ste;
			
			this.m_dx = wherex;
			this.m_dy = wherey;

			this.m_angle = mathUtils.getAngle(this.x, this.y, this.m_dx, this.m_dy);
			this.startMoving();
		}
		
		public function set currentPath(path:Array):void
		{
			m_currentPath = path;
		}
		
		public function set vel(value:Number):void
		{
			m_vel = value;
		}
		
		override public function onMouseEnter():void
		{
			if(this.customData.flash9Renderer)
			{
				(this.customData.flash9Renderer as fFlash9ElementRenderer).onMouseEnter();
			}
		}
		
		override public function onMouseLeave():void
		{
			if(this.customData.flash9Renderer)
			{
				(this.customData.flash9Renderer as fFlash9ElementRenderer).onMouseLeave();
			}
		}
	}
}