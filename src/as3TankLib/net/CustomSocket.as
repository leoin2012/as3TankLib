package as3TankLib.net
{
	import as3TankLib.baseData.Int16;
	import as3TankLib.baseData.Int32;
	import as3TankLib.baseData.Int64;
	import as3TankLib.baseData.Int8;
	import as3TankLib.util.Debuger;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.describeType;

	/**
	 * 自定义数据通信管理器
	 * @author Leo
	 */	
	public class CustomSocket extends Socket
	{
		public function CustomSocket()
		{
			super(null, 0);
			
			if(instance)
				throw new Error("CustomSocket is singleton class and allready exists!");
			instance = this;
			
			this.endian = Endian.LITTLE_ENDIAN;
		}
		
		/**
		 * 单例
		 */
		private static var instance:CustomSocket;
		/**
		 * 获取单例
		 */
		public static function getInstance():CustomSocket
		{
			if(!instance)
				instance = new CustomSocket();
			
			return instance;
		}
		
		public var ip:String;
		
		public var port:int;
		/**
		 * HTTP端口 
		 */		
		public var httpPort:int;
		/**
		 * socket是否关闭 
		 */		
		public var isClosed:Boolean = false;
		/**
		 * 包头长度 
		 */		
		public static const HEADLENGTH:int = 7;
		
		/**
		 * 协议数据缓冲区 
		 */		
		private var _dataBuffer:CustomByteArray;
		
		/**
		 * 启动socket
		 * @param ip
		 * @param port
		 */		
		public function start(ip:String = null, port:int = 0):void
		{
			this.ip = ip;
			this.port = port;
			this.configListeners();
			super.connect(ip, port);
		}
		
		/**
		 * 关闭socket 
		 * 
		 */		
		override public function close():void
		{
			super.close();
			this.isClosed = true;
			Debuger.show(Debuger.SOCKET, "socket主动关闭")
		}		
		
		/**
		 * 配置监听
		 */		
		private function configListeners():void
		{
			removeEventListener(Event.CLOSE, closeHandler);
			removeEventListener(Event.CONNECT, connectHandler);
			removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		/**
		 * 和服务端约定的协议下标，初始为0，每发一次协议都自加1（防止外挂发包） 
		 */		
		private var _socketIndex:int = 0;
		
		/**
		 * 发送消息
		 * @param cmd 协议号
		 * @param object 协议号内容
		 */		
		public function sendMessage(cmd:uint, object:* = null):void
		{
			if(!this.connected)
			{
				Debuger.show(Debuger.SOCKET,"游戏线socket还未建立连接," + cmd + "发送失败");
				return;
			}
			
			if(!object)return;
			
			/**
			 * 实际数据
			 */
			var realData:CustomByteArray = new CustomByteArray();
			/**
			 * 发送数据
			 */
			var sendData:CustomByteArray = new CustomByteArray();
			/**
			 * 混淆码
			 */
			var fixNum:int;
			var tempData:CustomByteArray;
			
			if(object is Array && object.length > 0)
			{
				tempData = new CustomByteArray();
				for (var i:int = 0; i < object.length; i++) 
				{
					tempData = this.packageData(object[i]);
					realData.writeBytes(tempData, 0, tempData.length);
				}
			}
			else
			{
				tempData = this.packageData(object);
				realData.writeBytes(tempData, 0, tempData.length);
			}
			
			fixNum = ((_socketIndex + 4 + tempData.length) % 134) ^ 134;
			
			sendData.writeInt(tempData.length + 4);
			sendData.writeByte(_socketIndex);
			sendData.writeByte(fixNum);
			sendData.writeShort(cmd);
			if(object is Array)
				sendData.writeShort(object.length);
			sendData.writeBytes(realData, 0, realData.bytesAvailable);
			
			this.writeBytes(sendData);
			this.flush();
			
			Debuger.show(Debuger.SOCKET, "发送协议", {cmd:cmd, value:object});
			
			_socketIndex++;
			_socketIndex %= 255;
		}
		
		/**
		 * 封装数据发送 
		 * @param object
		 * @return 
		 */		
		private function packageData(object:Object):CustomByteArray
		{
			var byteArray:CustomByteArray = new CustomByteArray();
			
			var objectXml:XML = describeType(object);
			var typeName:String = objectXml.@name;
			var max:Number;
			var tempClassFields:Array=[];
			
			if(typeName == "uint")
			{
				byteArray.writeShort(uint(object));
				return byteArray;
			}
			else if(typeName == "int")
			{
				byteArray.writeInt(int(object));
				return byteArray;
			}
			else if (typeName == "String")
			{
				byteArray.writeUTF(String(object));
				return byteArray;
			}
			else if (typeName == "as3BaseLib.baseData::Int64")
			{
				max=uint.MAX_VALUE+1;
				byteArray.writeInt(int(object.value/max));
				byteArray.writeInt(int(object.value%max));
				return byteArray;
			}
			else if (typeName == "as3BaseLib.baseData::Int32")
			{
				byteArray.writeInt(object.value);
				return byteArray;
			}
			else if (typeName == "as3BaseLib.baseData::Int16")
			{
				byteArray.writeShort(object.value);
				return byteArray;
			}
			else if (typeName == "as3BaseLib.baseData::Int8")
			{
				byteArray.writeByte(object.value);
				return byteArray;
			}
			else
			{
				var variables:XMLList=objectXml.variable as XMLList;
				for each (var ms:XML in variables)
				{
					tempClassFields.push({name: ms.@name, type: ms.@type});
				}
				tempClassFields.sortOn("name");
			}
			
			for each (var obj:Object in tempClassFields)
			{
				if (obj.type == "uint")
				{
					byteArray.writeShort(object[obj.name] as uint);
				}
				else if (obj.type == "int")
				{
					byteArray.writeInt(object[obj.name] as int);
					
				}
				else if (obj.type == "Number")
				{
					var num:Number=object[obj.name] as Number;
					if (isNaN(num))
					{
						num=0;
					}
					byteArray.writeFloat(num);
					
				}
				else if (obj.type == "String")
				{
					var str:String=object[obj.name];
					if (str == null)
					{
						str=" ";
					}
					byteArray.writeUTF(str);
				}
				else if (typeName == "common.baseData::Int64")
				{
					max=uint.MAX_VALUE+1;
					byteArray.writeInt(int(object.value/max));
					byteArray.writeInt(int(object.value%max));
				}
				else if (obj.type == "common.baseData::Int32")
				{
					byteArray.writeInt(object[obj.name].value);
				}
				else if (obj.type == "common.baseData::Int16")
				{
					
					byteArray.writeShort(object[obj.name].value);
				}
				else if (obj.type == "common.baseData::Int8")
				{
					byteArray.writeByte(object[obj.name].value);
				}
				else
				{
					var tempObj:Object=object[obj.name];
					if (tempObj is Array)
					{
						byteArray.writeShort((tempObj as Array).length);
						for each (var innerObj:Object in tempObj)
						{
							var tempByte:CustomByteArray=packageData(innerObj);
							byteArray.writeBytes(tempByte, 0, tempByte.length);
						}
					}
					else
					{
						//处理依赖关系  即对象中装有其他对象
						tempByte=packageData(tempObj);
						byteArray.writeBytes(tempByte, 0, tempByte.length);
					}
				}
			}
			return byteArray;
		}
		
		
		
		
		/**
		 * 是否正在读取数据 
		 */		
		private var _isProcessingData:Boolean = false;
		/**
		 * 一次协议数据
		 */		
		private var _1protocolData:Array = [];
		
		/**
		 * 收到服务端数据
		 * @param event
		 */		
		private function socketDataHandler(event:ProgressEvent):void
		{
			var bytes:CustomByteArray = new CustomByteArray();
			this.readBytes(bytes, 0, this.bytesAvailable);
			_1protocolData.push(bytes);
			
			dataProcess();
		}
		
		/**
		 * 内容长度 
		 */		
		private var _contentLen:int = 0;
		
		/**
		 * 数据处理  
		 */		
		private function dataProcess():void
		{
			if(_1protocolData.length <= 0)
			{
				_isProcessingData = false;
				return;
			}
			_isProcessingData = true;
			
			var tempData:CustomByteArray = this._1protocolData.shift();
			/**
			 * 临时数据缓冲区
			 */	
			var tempDataBuffer:CustomByteArray = new CustomByteArray();
			
			if(_dataBuffer && _dataBuffer.bytesAvailable > 0)
			{
				//拼接缓冲区和新接收数据
				_dataBuffer.readBytes(tempDataBuffer, 0, _dataBuffer.bytesAvailable);
				tempData.readBytes(tempDataBuffer, tempDataBuffer.length, tempData.bytesAvailable);
				_dataBuffer = null;
			}
			//当前数据不够需要的数据长度,且还未读取过包长度  将缓存数据
			if(_contentLen == 0 && tempDataBuffer.bytesAvailable < HEADLENGTH)
			{
				if(!_dataBuffer)
					_dataBuffer = new CustomByteArray();
				tempDataBuffer.readBytes(_dataBuffer, _dataBuffer.length, tempDataBuffer.bytesAvailable); //数据放入缓冲区
				dataProcess();
			}
			else
			{
				getBytes(tempDataBuffer);
			}
		}
		
		/**
		 * 按数据包长度处理数据
		 * @param bytesArray
		 */		
		private function getBytes(bytesArray:CustomByteArray):void
		{
			if(_contentLen == 0)
				_contentLen = bytesArray.readUnsignedInt();	//读数据包长度
			if(bytesArray.bytesAvailable < _contentLen)
			{
				if(!_dataBuffer)
					_dataBuffer = new CustomByteArray();
				bytesArray.readBytes(_dataBuffer, _dataBuffer.length, bytesArray.bytesAvailable);
				dataProcess();
			}
			else
			{
				//读取两个字节的消息号
				var cmd:int = bytesArray.readUnsignedShort();
				_contentLen -= 2;	//减去协议号所占的2个字节
				
				var realData:CustomByteArray = new CustomByteArray();
				if(0 != _contentLen)
				{
					bytesArray.readBytes(realData, 0, _contentLen);
					_contentLen = 0;
				}
				
				receiveData(cmd, realData);
				
				if(bytesArray.bytesAvailable >= HEADLENGTH)
				{
					getBytes(bytesArray);
				}
				else
				{
					if(bytesArray.bytesAvailable > 0)
					{
						if(!_dataBuffer)
							_dataBuffer = new CustomByteArray();
						bytesArray.readBytes(_dataBuffer, _dataBuffer.length, bytesArray.bytesAvailable);
					}
				}
				_isProcessingData = false;
				dataProcess();
			}
		}
		
		/**
		 * 处理收到的服务端送过来的消息 
		 * @param cmd
		 * @param dataBytes
		 */		
		private function receiveData(cmd:int, dataBytes:CustomByteArray):void
		{
			var handler:Array = _cmdHandlers[cmd];
			if(null == handler || handler.length <= 0)
			{
				return;
			}
			
			var objectClass:Object; 		//获取该消息号对应的数据类
			var objectValue:Object;			//协议数据
			
			if(null != CommandMap.getCMDObject(cmd))
			{
				objectClass = CommandMap.getCMDObject(cmd);
				
				if(dataBytes.bytesAvailable > 0)
				{
					try
					{
						objectValue = mappingObject(objectClass,dataBytes);
					} 
					catch(error:Error) 
					{
						throw new Error("协议号"+cmd+"解析出错，CustomSocket.mappingObject")
					}
				}
			}
			
			for each (var fun:Function in handler) 
			{
				if(objectValue == null)
				{
					fun();
				}
				else
				{
					Debuger.show(Debuger.SOCKET, "接收协议", {cmd:cmd, value:objectValue});
					fun(objectValue);
				}
			}
		}
		
		/**
		 * 将二进制数据映射到对象 
		 * @param valueClass
		 * @param dataBytes
		 * @return 
		 */		
		private function mappingObject(valueClass:Object, dataBytes:CustomByteArray):Object
		{
			var tempClassFields:Array = [];
			if(null == CommandMap.getClassFields(valueClass))
			{
				var objectXml:XML = describeType(valueClass);
				var objectFiledsXml:XMLList = objectXml.factory.variable as XMLList;
				for each (var ms:XML in objectFiledsXml) 
				{
					tempClassFields.push({name: String(ms.@name), type:String(ms.@type)});
				}
				tempClassFields.sort("name");
				CommandMap.putClassFields(valueClass,tempClassFields);
			}
			else
			{
				tempClassFields = CommandMap.getClassFields(valueClass);
			}
			
			var valueObject:Object = new valueClass();
			for each (var obj:Object in tempClassFields) 
			{
				if(dataBytes.bytesAvailable <= 0)
				{
					break;
				}
				if(obj.type == "uint")
				{
					valueObject[obj.name] = dataBytes.readShort();
				}
				else if(obj.type == "int")
				{
					valueObject[obj.name] = dataBytes.readInt();
				}
				else if(obj.type == "Number")
				{
					valueObject[obj.name] = dataBytes.readFloat();
				}
				else if(obj.type == "String")
				{
					valueObject[obj.name] = dataBytes.readUTF();
				}
				else if(obj.type == "flash.utils::ByteArray")
				{
					var byteArray:ByteArray = new ByteArray();
					var length:int = dataBytes.readShort();
					dataBytes.readBytes(byteArray, 0, length);
					valueObject[obj.name] = byteArray;
				}
				else if(obj.type == "as3TankLib.baseData::Int64")
				{
					var num1:uint = dataBytes.readUnsignedInt();
					var num2:uint = dataBytes.readUnsignedInt();
					var max:Number = uint.MAX_VALUE + 1;
					var num:Number = Number(num1) * max + Number(num2);
					valueObject[obj.name] = new Int64(num);
				}
				else if(obj.type == "as3TankLib.baseData::Int32")
				{
					valueObject[obj.name] = new Int32(Number(dataBytes.readInt()));
				}
				else if(obj.type == "as3TankLib.baseData::Int16")
				{
					valueObject[obj.name] = new Int16(Number(dataBytes.readShort()));
				}
				else if(obj.type == "as3TankLib.baseData::Int8")
				{
					valueObject[obj.name] = new Int8(dataBytes.readByte());
				}
				else
				{
					//处理属性是list的情况
					var listLength:uint = dataBytes.readShort();
					var objs:Array = valueObject[obj.name];
					var VO:Object = objs.pop();
					for(var i:int = 0; i < listLength; i++)
					{
						if (VO is Number)
						{
							objs.push(dataBytes.readInt());
						}
						else if (VO is String)
						{
							objs.push(dataBytes.readUTF());
						}
						else
						{
							objs.push(mappingObject(VO, dataBytes));
						}
					}
				}
			}
			return valueObject;
		}
		
		
		private var _cmdHandlers:Array;
		
		/**
		 * 添加某个消息号的监听
		 * @param cmd
		 * @param handler
		 */		
		public function addCmdListener(cmd:int, handler:Function):void
		{
			if(null == _cmdHandlers[cmd])
			{
				_cmdHandlers[cmd] = [];
			}
			if(-1 == _cmdHandlers[cmd].indexOf(handler))
			{
				_cmdHandlers[cmd].push(handler);
			}
		}
		
		/**
		 * 移除消息号监听
		 * @param cmd
		 * @param handler
		 */		
		public function removeCmdListener(cmd:int, handler:Function):void
		{
			var handlers:Array = this._cmdHandlers[cmd];
			if(null != handler && handler.length > 0)
			{
				for(var i:int = (handlers.length - 1); i >=0; i--)
				{
					if(handler == handlers[i])
					{
						handlers.splice(i, 1);
					}
				}
			}
		}
		
		
			
		private function closeHandler(event:Event):void
		{
			Debuger.show(Debuger.SOCKET, "Socket 已断开");
		}
		
		private function connectHandler(event:Event):void
		{
			isClosed = false;
		}
		
		private function ioErrorHandler(event:Event):void
		{
			Debuger.show(Debuger.SOCKET, "Socket IO错误");
			
			try
			{
				this.close();
			} 
			catch(error:Error) 
			{
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			Debuger.show(Debuger.SOCKET, "Socket安全沙箱错误");
		}
		
	}
}