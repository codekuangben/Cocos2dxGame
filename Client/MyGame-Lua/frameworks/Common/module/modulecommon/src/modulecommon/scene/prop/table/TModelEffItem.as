package modulecommon.scene.prop.table
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.ffilmation.engine.helpers.fOffList;
	
	import org.ffilmation.engine.helpers.fActDirOff;

	/**
	 * ...
	 * @author 
	 * @brief 配置模型以及模型特效信息
	 */
	public class TModelEffItem extends TDataItem
	{
		public var m_streff:String;
		//public var m_strModelOff:String;
		public var m_tagHeight:int = 0;
		public var m_attType:int = 0;		// excel 中填写的数据时 1 是远攻 2 是近攻，不间隔 3 近攻间隔一个格子 依次类推，自己用的是 0 是远攻 1 是近攻，不间隔 2 近攻间隔一个格子 依次类推，要减 1
		public var m_actFrameRate:String = "";		// 动作帧率，格式 1:10;2:20 ，动作编号:动作帧率;动作编号:动作帧率
		public var m_link1fHeight:int = 0;	// 就是第一个连接点的高度，用来调整人物高度
		
		// 这个是自己需要的数据结构
		public var m_EffOffDic:Dictionary;
		//public var m_ModelOffDic:Dictionary;
		public var m_ModelActDirOff:fActDirOff;	// 模型自身的偏移
		public var m_actFrameRateDic:Dictionary;
		public var m_mounterActDirOff:fActDirOff;	// 骑乘者的偏移，这个记录在坐骑身上
		
		override public function parseByteArray(bytes:ByteArray):void
		{
			super.parseByteArray(bytes);
			
			m_streff = TDataItem.readString(bytes);
			
			// 解析特效
			m_EffOffDic = new Dictionary();
			var semiArr:Array;	// 分号
			var colonArr:Array;	// 冒号
			var commaArr:Array;	// 逗号
			var andArr:Array;	// & 分割符号
			var semiidx:uint = 0;
			var colonidx:uint = 0;
			var commaidx:uint = 0;
			var andidx:uint = 0;
			
			if (m_streff != "" && m_streff != "0")
			{
				semiArr = m_streff.split(";");
				
				semiidx = 0;
				while(semiidx < semiArr.length)
				{
					colonArr = semiArr[semiidx].split(":");
					commaArr = colonArr[1].split(",");
					m_EffOffDic[colonArr[0]] = new Point(parseInt(commaArr[0]), parseInt(commaArr[1]));
					
					++semiidx;
				}
			}
			
			var m_strModelOff:String;
			// 开始解析模型自己的偏移信息
			m_strModelOff = TDataItem.readString(bytes);
			//m_ModelOffDic = new Dictionary();
			m_ModelActDirOff = new fActDirOff();
			
			if (m_strModelOff != "" && m_strModelOff != "0")
			{
				semiArr = m_strModelOff.split(";");
				
				semiidx = 0;
				while(semiidx < semiArr.length)
				{
					colonArr = semiArr[semiidx].split(":");
					andArr = colonArr[1].split("&");
					andidx = 0;
					while (andidx < andArr.length)
					{
						commaArr = andArr[andidx].split(",");
						if (!m_ModelActDirOff.m_ModelOffDic[colonArr[0]])
						{
							m_ModelActDirOff.m_ModelOffDic[colonArr[0]] = new fOffList();
						}
						m_ModelActDirOff.m_ModelOffDic[colonArr[0]].m_offLst.push(new Point(parseInt(commaArr[0]), parseInt(commaArr[1])));
						
						++andidx;
					}
					
					++semiidx;
				}
			}
			
			//m_tagHeight = bytes.readShort();	// 现在改成字符型，格式如下，如果马匹:名字高度:第一连接点高度，如果是玩家:名字高度。
			
			var heightstr:String = TDataItem.readString(bytes);
			var heightArr:Array;
			// 根据格式去解析
			heightArr = heightstr.split(":");
			// 第一个高度是名字高度，基本必然存在
			if (heightArr.length >= 1)
			{
				m_tagHeight = parseInt(heightArr[0]);
			}

			// 第二个高度是第一个连接点的高度，只有乘车物存在
			if (heightArr.length >= 2)
			{
				m_link1fHeight = parseInt(heightArr[1]);
			}
			
			m_attType = bytes.readUnsignedByte() - 1;	// excel 中的数据比程序用的数据多 1
			
			// 动作帧率解析
			m_actFrameRateDic = new Dictionary();
			m_actFrameRate = TDataItem.readString(bytes);
			if (m_actFrameRate != "" && m_actFrameRate != "0")
			{
				semiArr = m_actFrameRate.split(";");
				semiidx = 0;
				while(semiidx < semiArr.length)
				{
					colonArr = semiArr[semiidx].split(":");
					m_actFrameRateDic[colonArr[0]] = parseInt(colonArr[1]);
					
					++semiidx;
				}
			}
			
			// 开始解析骑乘者的偏移信息，这个主要是有的坐骑动作每一帧都需要调整，因此需要配置，如果配置就每一帧都更新
			m_strModelOff = TDataItem.readString(bytes);
			
			if (m_strModelOff != "" && m_strModelOff != "0")
			{
				m_mounterActDirOff = new fActDirOff();	// 如果有的时候才创建数据
				semiArr = m_strModelOff.split(";");
				
				semiidx = 0;
				while(semiidx < semiArr.length)
				{
					colonArr = semiArr[semiidx].split(":");
					andArr = colonArr[1].split("&");
					andidx = 0;
					while (andidx < andArr.length)
					{
						commaArr = andArr[andidx].split(",");
						if (!m_mounterActDirOff.m_ModelOffDic[colonArr[0]])
						{
							m_mounterActDirOff.m_ModelOffDic[colonArr[0]] = new fOffList();
						}
						m_mounterActDirOff.m_ModelOffDic[colonArr[0]].m_offLst.push(new Point(parseInt(commaArr[0]), parseInt(commaArr[1])));
						
						++andidx;
					}
					
					++semiidx;
				}
			}
		}
	}
}