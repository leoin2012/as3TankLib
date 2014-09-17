package as3TankLib.util
{
	import as3TankLib.event.ParamEvent;
	import as3TankLib.manager.GlobalEventManager;
	
	import flash.utils.Dictionary;

	/**
	 * 调试输出
	 * @author Leo
	 */
	public class Debuger
	{
		public static const SOCKET:String = "SOCKET";
		
		/**
		 * 调试信息输出事件 
		 */		
		public static const DEBUGER_MSG:String = "DEBUGER_MSG";
		
		public function Debuger()
		{
		}
		/**
		 * 索引 
		 */		
		public static var index:uint;
		
		/**
		 * 记录模块可否调试 
		 */		
		private static var moduleDebugDic:Dictionary = new Dictionary();
	
		/**
		 * 设置对应模块是否可调试 
		 * @param module
		 * @param canDebug
		 * 
		 */		
		public static function setModuleDebug(module:String, canDebug:Boolean):void
		{
			moduleDebugDic[module] = canDebug;
		}
		
		public static function show(module:String, msg:String, data:Object = null):void
		{
			if(null == msg|| "" == msg)return;
			
			if(moduleDebugDic[module])
			{
				if(Debuger.SOCKET == module && data)
				{
					index++;
					data.key = msg + index;
					if(msg == "发送协议")
					{
						msg = "<a href='event:"+ data.key +"'>" + data.key +
							"，消息号<font color='#ff00ff'>"+ data.cmd + "   》》》》》》》</font>";
					}
					else
					{
						msg = "<font color='#ffff00'><a href='event:"+ data.key +"'>"+ data.key +"，消息号" + data.cmd +
							"   《《《《《《《</a></font>";
					}
				}
				
				trace(StringUtil.removeHtml(msg));
				GlobalEventManager.getInstance().dispatchEvent(
					new ParamEvent(DEBUGER_MSG, {module:module, msg:msg, data:data}));
			}
		}
	}
}