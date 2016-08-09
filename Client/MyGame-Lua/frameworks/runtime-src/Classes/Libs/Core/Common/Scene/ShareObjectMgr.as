package common.scene
{
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.SWFResource;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import org.ffilmation.engine.helpers.fActDirOff;

	/**
	 * ...
	 * @author 
	 * @brief 存放程序中许多公用的变量，就不单独写每一个类型了   
	 */
	public class ShareObjectMgr
	{		
		// 动作公用  
		public var m_actDirResList:Vector.<SWFResource>;
		public var m_frameInitList:Vector.<Boolean>;
		
		public var m_actDir2Key:Dictionary;			// 共享数据，所有的 act dir 对应的偏移的 key 值
		public var m_tmpModelOff:Point;				// 临时的模型特效偏移，目的是不在循环中使用临时变量
		public var m_keyOff:String;				// 偏移时候的 key 值
		
		public var m_tmpMountserActDirOff:fActDirOff;	// 坐骑骑乘者偏移，这个偏移是每一帧都需要配置的，主要是有些坐骑动作比较夸张，需要每一帧都去调整，因此需要去单独配置
		public var m_mountserActDir2Key:Dictionary;		// 共享数据，骑乘者坐骑所有的 act dir 对应的偏移的 key 值
		
		public var m_hasOffInCurFrame:Boolean;			// 当前帧中骑乘者是否有动作偏移
		
		public var m_nullByteArray:ByteArray;			// 默认的字节数组，主要用于一些消息，如果赋值 null 就会有问题，因此提供这个
		
		public var m_scaleMatrix:Matrix;				// 临时变量
		
		public function ShareObjectMgr() 
		{
			m_actDirResList = new Vector.<SWFResource>(8, true);
			m_frameInitList = new Vector.<Boolean>(8, true);
			
			m_actDir2Key = new Dictionary();
			// 动作
			m_actDir2Key[EntityCValue.TActStand] = new Dictionary();
			// 方向
			m_actDir2Key[EntityCValue.TActStand][0] = "00";
			m_actDir2Key[EntityCValue.TActStand][1] = "00";
			m_actDir2Key[EntityCValue.TActStand][2] = "00";
			m_actDir2Key[EntityCValue.TActStand][3] = "00";
			m_actDir2Key[EntityCValue.TActStand][4] = "00";
			m_actDir2Key[EntityCValue.TActStand][5] = "00";
			m_actDir2Key[EntityCValue.TActStand][6] = "00";
			m_actDir2Key[EntityCValue.TActStand][7] = "00";
			// 动作
			m_actDir2Key[EntityCValue.TActRun] = new Dictionary();
			// 方向
			m_actDir2Key[EntityCValue.TActRun][0] = "00";
			m_actDir2Key[EntityCValue.TActRun][1] = "00";
			m_actDir2Key[EntityCValue.TActRun][2] = "00";
			m_actDir2Key[EntityCValue.TActRun][3] = "00";
			m_actDir2Key[EntityCValue.TActRun][4] = "00";
			m_actDir2Key[EntityCValue.TActRun][5] = "00";
			m_actDir2Key[EntityCValue.TActRun][6] = "00";
			m_actDir2Key[EntityCValue.TActRun][7] = "00";
			// 动作
			m_actDir2Key[EntityCValue.TActJump] = new Dictionary();
			// 方向
			m_actDir2Key[EntityCValue.TActJump][0] = "00";
			m_actDir2Key[EntityCValue.TActJump][1] = "00";
			m_actDir2Key[EntityCValue.TActJump][2] = "00";
			m_actDir2Key[EntityCValue.TActJump][3] = "00";
			m_actDir2Key[EntityCValue.TActJump][4] = "00";
			m_actDir2Key[EntityCValue.TActJump][5] = "00";
			m_actDir2Key[EntityCValue.TActJump][6] = "00";
			m_actDir2Key[EntityCValue.TActJump][7] = "00";
			
			m_actDir2Key[EntityCValue.TActAttack] = new Dictionary();
			// 方向
			m_actDir2Key[EntityCValue.TActAttack][0] = "00";
			m_actDir2Key[EntityCValue.TActAttack][1] = "00";
			m_actDir2Key[EntityCValue.TActAttack][2] = "00";
			m_actDir2Key[EntityCValue.TActAttack][3] = "00";
			m_actDir2Key[EntityCValue.TActAttack][4] = "00";
			m_actDir2Key[EntityCValue.TActAttack][5] = "00";
			m_actDir2Key[EntityCValue.TActAttack][6] = "00";
			m_actDir2Key[EntityCValue.TActAttack][7] = "00";
			// 动作
			m_actDir2Key[EntityCValue.TActHurt] = new Dictionary();
			// 方向
			m_actDir2Key[EntityCValue.TActHurt][0] = "00";
			m_actDir2Key[EntityCValue.TActHurt][1] = "00";
			m_actDir2Key[EntityCValue.TActHurt][2] = "00";
			m_actDir2Key[EntityCValue.TActHurt][3] = "00";
			m_actDir2Key[EntityCValue.TActHurt][4] = "00";
			m_actDir2Key[EntityCValue.TActHurt][5] = "00";
			m_actDir2Key[EntityCValue.TActHurt][6] = "00";
			m_actDir2Key[EntityCValue.TActHurt][7] = "00";
			// 动作
			m_actDir2Key[EntityCValue.TActDie] = new Dictionary();
			// 方向
			m_actDir2Key[EntityCValue.TActDie][0] = "00";
			m_actDir2Key[EntityCValue.TActDie][1] = "00";
			m_actDir2Key[EntityCValue.TActDie][2] = "00";
			m_actDir2Key[EntityCValue.TActDie][3] = "00";
			m_actDir2Key[EntityCValue.TActDie][4] = "00";
			m_actDir2Key[EntityCValue.TActDie][5] = "00";
			m_actDir2Key[EntityCValue.TActDie][6] = "00";
			m_actDir2Key[EntityCValue.TActDie][7] = "00";
			// 动作
			m_actDir2Key[EntityCValue.TActSkill] = new Dictionary();
			// 方向
			m_actDir2Key[EntityCValue.TActSkill][0] = "00";
			m_actDir2Key[EntityCValue.TActSkill][1] = "00";
			m_actDir2Key[EntityCValue.TActSkill][2] = "00";
			m_actDir2Key[EntityCValue.TActSkill][3] = "00";
			m_actDir2Key[EntityCValue.TActSkill][4] = "00";
			m_actDir2Key[EntityCValue.TActSkill][5] = "00";
			m_actDir2Key[EntityCValue.TActSkill][6] = "00";
			m_actDir2Key[EntityCValue.TActSkill][7] = "00";
			// 动作
			m_actDir2Key[EntityCValue.TActDaZuo] = new Dictionary();
			// 方向
			m_actDir2Key[EntityCValue.TActDaZuo][0] = "00";
			m_actDir2Key[EntityCValue.TActDaZuo][1] = "00";
			m_actDir2Key[EntityCValue.TActDaZuo][2] = "00";
			m_actDir2Key[EntityCValue.TActDaZuo][3] = "00";
			m_actDir2Key[EntityCValue.TActDaZuo][4] = "00";
			m_actDir2Key[EntityCValue.TActDaZuo][5] = "00";
			m_actDir2Key[EntityCValue.TActDaZuo][6] = "00";
			m_actDir2Key[EntityCValue.TActDaZuo][7] = "00";
			// 动作
			m_actDir2Key[EntityCValue.TActRideStand] = new Dictionary();
			// 方向
			m_actDir2Key[EntityCValue.TActRideStand][0] = "130";
			m_actDir2Key[EntityCValue.TActRideStand][1] = "130";
			m_actDir2Key[EntityCValue.TActRideStand][2] = "130";
			m_actDir2Key[EntityCValue.TActRideStand][3] = "130";
			m_actDir2Key[EntityCValue.TActRideStand][4] = "130";
			m_actDir2Key[EntityCValue.TActRideStand][5] = "130";
			m_actDir2Key[EntityCValue.TActRideStand][6] = "130";
			m_actDir2Key[EntityCValue.TActRideStand][7] = "130";
			// 动作
			m_actDir2Key[EntityCValue.TActRideRun] = new Dictionary();
			// 方向
			m_actDir2Key[EntityCValue.TActRideRun][0] = "130";
			m_actDir2Key[EntityCValue.TActRideRun][1] = "130";
			m_actDir2Key[EntityCValue.TActRideRun][2] = "130";
			m_actDir2Key[EntityCValue.TActRideRun][3] = "130";
			m_actDir2Key[EntityCValue.TActRideRun][4] = "130";
			m_actDir2Key[EntityCValue.TActRideRun][5] = "130";
			m_actDir2Key[EntityCValue.TActRideRun][6] = "130";
			m_actDir2Key[EntityCValue.TActRideRun][7] = "130";
			
			// ------------------
			// 骑乘者偏移
			m_mountserActDir2Key = new Dictionary();
			// 动作
			m_mountserActDir2Key[EntityCValue.TActStand] = new Dictionary();
			// 方向
			m_mountserActDir2Key[EntityCValue.TActStand][0] = "00";
			m_mountserActDir2Key[EntityCValue.TActStand][1] = "00";
			m_mountserActDir2Key[EntityCValue.TActStand][2] = "00";
			m_mountserActDir2Key[EntityCValue.TActStand][3] = "00";
			m_mountserActDir2Key[EntityCValue.TActStand][4] = "00";
			m_mountserActDir2Key[EntityCValue.TActStand][5] = "00";
			m_mountserActDir2Key[EntityCValue.TActStand][6] = "00";
			m_mountserActDir2Key[EntityCValue.TActStand][7] = "00";
			// 动作
			m_mountserActDir2Key[EntityCValue.TActRun] = new Dictionary();
			// 方向
			m_mountserActDir2Key[EntityCValue.TActRun][0] = "00";
			m_mountserActDir2Key[EntityCValue.TActRun][1] = "00";
			m_mountserActDir2Key[EntityCValue.TActRun][2] = "00";
			m_mountserActDir2Key[EntityCValue.TActRun][3] = "00";
			m_mountserActDir2Key[EntityCValue.TActRun][4] = "00";
			m_mountserActDir2Key[EntityCValue.TActRun][5] = "00";
			m_mountserActDir2Key[EntityCValue.TActRun][6] = "00";
			m_mountserActDir2Key[EntityCValue.TActRun][7] = "00";
			// 动作
			m_mountserActDir2Key[EntityCValue.TActJump] = new Dictionary();
			// 方向
			m_mountserActDir2Key[EntityCValue.TActJump][0] = "00";
			m_mountserActDir2Key[EntityCValue.TActJump][1] = "00";
			m_mountserActDir2Key[EntityCValue.TActJump][2] = "00";
			m_mountserActDir2Key[EntityCValue.TActJump][3] = "00";
			m_mountserActDir2Key[EntityCValue.TActJump][4] = "00";
			m_mountserActDir2Key[EntityCValue.TActJump][5] = "00";
			m_mountserActDir2Key[EntityCValue.TActJump][6] = "00";
			m_mountserActDir2Key[EntityCValue.TActJump][7] = "00";
			
			m_mountserActDir2Key[EntityCValue.TActAttack] = new Dictionary();
			// 方向
			m_mountserActDir2Key[EntityCValue.TActAttack][0] = "00";
			m_mountserActDir2Key[EntityCValue.TActAttack][1] = "00";
			m_mountserActDir2Key[EntityCValue.TActAttack][2] = "00";
			m_mountserActDir2Key[EntityCValue.TActAttack][3] = "00";
			m_mountserActDir2Key[EntityCValue.TActAttack][4] = "00";
			m_mountserActDir2Key[EntityCValue.TActAttack][5] = "00";
			m_mountserActDir2Key[EntityCValue.TActAttack][6] = "00";
			m_mountserActDir2Key[EntityCValue.TActAttack][7] = "00";
			// 动作
			m_mountserActDir2Key[EntityCValue.TActHurt] = new Dictionary();
			// 方向
			m_mountserActDir2Key[EntityCValue.TActHurt][0] = "00";
			m_mountserActDir2Key[EntityCValue.TActHurt][1] = "00";
			m_mountserActDir2Key[EntityCValue.TActHurt][2] = "00";
			m_mountserActDir2Key[EntityCValue.TActHurt][3] = "00";
			m_mountserActDir2Key[EntityCValue.TActHurt][4] = "00";
			m_mountserActDir2Key[EntityCValue.TActHurt][5] = "00";
			m_mountserActDir2Key[EntityCValue.TActHurt][6] = "00";
			m_mountserActDir2Key[EntityCValue.TActHurt][7] = "00";
			// 动作
			m_mountserActDir2Key[EntityCValue.TActDie] = new Dictionary();
			// 方向
			m_mountserActDir2Key[EntityCValue.TActDie][0] = "00";
			m_mountserActDir2Key[EntityCValue.TActDie][1] = "00";
			m_mountserActDir2Key[EntityCValue.TActDie][2] = "00";
			m_mountserActDir2Key[EntityCValue.TActDie][3] = "00";
			m_mountserActDir2Key[EntityCValue.TActDie][4] = "00";
			m_mountserActDir2Key[EntityCValue.TActDie][5] = "00";
			m_mountserActDir2Key[EntityCValue.TActDie][6] = "00";
			m_mountserActDir2Key[EntityCValue.TActDie][7] = "00";
			// 动作
			m_mountserActDir2Key[EntityCValue.TActSkill] = new Dictionary();
			// 方向
			m_mountserActDir2Key[EntityCValue.TActSkill][0] = "00";
			m_mountserActDir2Key[EntityCValue.TActSkill][1] = "00";
			m_mountserActDir2Key[EntityCValue.TActSkill][2] = "00";
			m_mountserActDir2Key[EntityCValue.TActSkill][3] = "00";
			m_mountserActDir2Key[EntityCValue.TActSkill][4] = "00";
			m_mountserActDir2Key[EntityCValue.TActSkill][5] = "00";
			m_mountserActDir2Key[EntityCValue.TActSkill][6] = "00";
			m_mountserActDir2Key[EntityCValue.TActSkill][7] = "00";
			// 动作
			m_mountserActDir2Key[EntityCValue.TActDaZuo] = new Dictionary();
			// 方向
			m_mountserActDir2Key[EntityCValue.TActDaZuo][0] = "00";
			m_mountserActDir2Key[EntityCValue.TActDaZuo][1] = "00";
			m_mountserActDir2Key[EntityCValue.TActDaZuo][2] = "00";
			m_mountserActDir2Key[EntityCValue.TActDaZuo][3] = "00";
			m_mountserActDir2Key[EntityCValue.TActDaZuo][4] = "00";
			m_mountserActDir2Key[EntityCValue.TActDaZuo][5] = "00";
			m_mountserActDir2Key[EntityCValue.TActDaZuo][6] = "00";
			m_mountserActDir2Key[EntityCValue.TActDaZuo][7] = "00";
			// 动作，待机目前基本不配置
			m_mountserActDir2Key[EntityCValue.TActRideStand] = new Dictionary();
			// 方向
			m_mountserActDir2Key[EntityCValue.TActRideStand][0] = "130";
			m_mountserActDir2Key[EntityCValue.TActRideStand][1] = "131";
			m_mountserActDir2Key[EntityCValue.TActRideStand][2] = "132";
			m_mountserActDir2Key[EntityCValue.TActRideStand][3] = "133";
			m_mountserActDir2Key[EntityCValue.TActRideStand][4] = "132";
			m_mountserActDir2Key[EntityCValue.TActRideStand][5] = "131";
			m_mountserActDir2Key[EntityCValue.TActRideStand][6] = "130";
			m_mountserActDir2Key[EntityCValue.TActRideStand][7] = "137";
			// 动作，只配置 1 和 5 方向，其它方向不配置
			m_mountserActDir2Key[EntityCValue.TActRideRun] = new Dictionary();
			// 方向
			m_mountserActDir2Key[EntityCValue.TActRideRun][0] = "140";
			m_mountserActDir2Key[EntityCValue.TActRideRun][1] = "141";
			m_mountserActDir2Key[EntityCValue.TActRideRun][2] = "142";
			m_mountserActDir2Key[EntityCValue.TActRideRun][3] = "143";
			m_mountserActDir2Key[EntityCValue.TActRideRun][4] = "142";
			m_mountserActDir2Key[EntityCValue.TActRideRun][5] = "141";
			m_mountserActDir2Key[EntityCValue.TActRideRun][6] = "140";
			m_mountserActDir2Key[EntityCValue.TActRideRun][7] = "147";
			
			m_nullByteArray = new ByteArray();
		}
	}
}