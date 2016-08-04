package modulefight.ui.battlehead 
{
	import com.ani.equation.EquationInverse;
	
	/**
	 * ...
	 * @author 
	 */
	public class JinnangFlyEquation extends EquationInverse 
	{
		public static const T_Init:Number = 1;	//t的初始值
		public static const T_End:Number = 10; //t的终值
		public function JinnangFlyEquation()
		{		
			m_pow = -1;
			tInit = T_Init;
			tEnd = T_End;
		}
		
		//通过飞的起点与终点，计算相关参数
		public function setFlyPos(xSrc:Number, ySrc:Number, xDest:Number, yDest:Number):void
		{
			m_xScale = (xDest - xSrc) / (T_End - T_Init);
			m_xOffset = xSrc - m_xScale * T_Init;
			
			m_yScale = (yDest - ySrc) * (T_Init * T_End)/(T_Init - T_End) ;
			m_yOffset = ySrc - 1 / T_Init * m_yScale;
		}
		
		
		
	}

}