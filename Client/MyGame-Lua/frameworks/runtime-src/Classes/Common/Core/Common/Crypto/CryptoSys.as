package common.crypto
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.DESKey;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.IVMode;
	import com.hurlant.crypto.symmetric.PKCS5;
	
	import flash.utils.ByteArray;
	//import flash.utils.Endian;

	/**
	 * @brief 加密解密系统
	 * */
	public class CryptoSys
	{
		protected var m_bStartEncrypt:Boolean;		// 开始加密解密消息
		//protected var m_key:String;				// key 对应的加密的 key
		protected var m_keyba:ByteArray;
		protected var m_slastIV:String = '87654321';	// 随机向量
		
		protected var m_myDes:DESKey;

		public function CryptoSys()
		{
			m_keyba = new ByteArray();
			//var by:ByteArray = new ByteArray();
			//by.endian = Endian.LITTLE_ENDIAN;
			//by.writeUTFBytes("12345678");
			//key = by;
		}
		
		public function set key(value:ByteArray):void
		{
			//m_key = value;
			//m_keyba.position = 0;
			//m_keyba.writeUTFBytes(m_key);
			m_keyba = value;
			m_myDes = new DESKey(m_keyba);
		}
		
		public function get key():ByteArray
		{
			//return m_key;
			return m_keyba;
		}
		
		public function set bStartEncrypt(value:Boolean):void
		{
			m_bStartEncrypt = value;
		}
		
		public function get bStartEncrypt():Boolean
		{
			return m_bStartEncrypt;
		}
		
		// 必然是 8 个字节的整数倍
		public function encrypt(data:ByteArray):void
		{
			var idx:int = 0;
			var remain:int = data.length % 8;
			if(remain)
			{
				data.position = data.length;
				while(idx < 8 - remain)
				{
					data.writeByte(0);
					++idx;
				}
			}
			idx = 0;
			while(idx < data.length)
			{
				if(idx + 8 <= data.length)	// 如果剩余的够 8 个字节
				{
					m_myDes.encrypt(data, idx);
				}
				idx += 8;
			}
			
			data.position = 0;
		}
		
		// 必然是 8 个字节的整数倍
		public function decrypt(data:ByteArray):void
		{
			var idx:int = 0;
			while(idx < data.length)
			{
				if(idx + 8 <= data.length)	// 如果剩余的够 8 个字节
				{
					m_myDes.decrypt(data, idx);
				}
				idx += 8;
			}
			
			data.position = 0;
		}
		
		//String转ByteArray
		public function convertStringToByteArray(str:String):ByteArray
		{
			var bytes:ByteArray;
			if (str)
			{
				bytes=new ByteArray();
				bytes.writeUTFBytes(str);
			}
			return bytes;
		}
		//ByteArray转String
		public function convertByteArrayToString(bytes:ByteArray):String
		{
			var str:String;
			if (bytes)
			{
				bytes.position=0;
				str=bytes.readUTFBytes(bytes.length);
			}
			return str;
		}
		
		/**
		 * @brief 字节数组加密
		 * */
		public function encrypt2f(keyba:String, data:ByteArray):ByteArray
		{
			var kdata:ByteArray = new ByteArray();
			//kdata = Hex.toArray(Hex.fromString(keyba));
			//data = Hex.toArray(Hex.fromArray(data));
			kdata.writeMultiByte(keyba, "utf-8");
			
			var name:String = "des-crc";
			var pad:IPad = new PKCS5();
			var mode:ICipher = Crypto.getCipher(name, kdata, pad);
			pad.setBlockSize(mode.getBlockSize());
			
			var iv:ByteArray = new ByteArray();
			iv.writeMultiByte(m_slastIV, "utf-8");
			var ivmode:IVMode = mode as IVMode;
			ivmode.IV = iv;
			mode.encrypt(data);
			
			//var ivmode:IVMode = mode as IVMode;
			//m_slastIV= Hex.fromArray(ivmode.IV);
			
			return data;
		}
		
		/**
		 * @brief 字节数组解密
		 * */
		public function decrypt2f(keyba:String, data:ByteArray):ByteArray
		{
			var kdata:ByteArray = new ByteArray();
			//kdata = Hex.toArray(Hex.fromString(keyba));
			kdata.writeMultiByte(keyba, "utf-8");
			
			var name:String = "des-crc";
			var pad:IPad = new PKCS5;
			var mode:ICipher = Crypto.getCipher(name, kdata, pad);
			pad.setBlockSize(mode.getBlockSize());
			
			var iv:ByteArray = new ByteArray();
			iv.writeMultiByte(m_slastIV, "utf-8");
			//var ivmode:IVMode = mode as IVMode;
			//ivmode.IV = Hex.toArray(m_slastIV);
			var ivmode:IVMode = mode as IVMode;
			ivmode.IV = iv;
			
			mode.decrypt(data);
			
			return data;
		}
		
		/**
		 * @brief 字符串加密
		 * */
		public function encryptStr(k:String, txt:String):ByteArray
		{
			/*
			var kdata:ByteArray;
			kdata = Hex.toArray(Hex.fromString(k));
			
			var data:ByteArray;
			data = Hex.toArray(Hex.fromString(txt));
			
			var name:String = "des-crc";
			var pad:IPad = new PKCS5;
			var mode:ICipher = Crypto.getCipher(name, kdata, pad);
			pad.setBlockSize(mode.getBlockSize());
			mode.encrypt(data);
			
			var ivmode:IVMode = mode as IVMode;
			m_slastIV= Hex.fromArray(ivmode.IV);
			
			return data;
			*/
			
			var data:ByteArray = new ByteArray();
			data.writeMultiByte(txt, "utf-8");
			
			return encrypt2f(k, data);
		}
		
		/**
		 * @brief 字符串解密
		 * */
		public function decryptStr(k:String, txt:ByteArray):String
		{
			/*
			var kdata:ByteArray;
			kdata = Hex.toArray(Hex.fromString(k));
			
			var data:ByteArray;
			data = txt;
			
			var name:String = "des-crc";
			
			var pad:IPad = new PKCS5;
			var mode:ICipher = Crypto.getCipher(name, kdata, pad);
			pad.setBlockSize(mode.getBlockSize());
			
			var ivmode:IVMode = mode as IVMode;
			ivmode.IV = Hex.toArray(m_slastIV);
			
			mode.decrypt(data);
			
			var ret:String;
			ret = Hex.toString(Hex.fromArray(data));
			
			return ret;
			*/
			
			var data:ByteArray = decrypt2f(k, txt);
			data.position = 0;
			var ret:String;
			//ret = Hex.toString(Hex.fromArray(data));
			ret = data.readMultiByte(data.length, "utf-8");
			
			return ret;
		}
	}
}