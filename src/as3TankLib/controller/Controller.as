package as3TankLib.controller
{
	import as3TankLib.event.ParamEvent;
	import as3TankLib.manager.GlobalEventManager;
	import as3TankLib.net.CustomSocket;

	/**
	 * 控制器基类
	 *@author Leo
	 */
	public class Controller
	{
		/**
		 * 统一事件派发器 
		 */		
		private var dispatcher:GlobalEventManager = GlobalEventManager.getInstance();
		
		/**
		 * 统一协议派发器 
		 */		
		private var socket:CustomSocket = CustomSocket.getInstance();
		
		public function Controller()
		{
		}
		
		/**
		 * 通过控制器的统一事件派发器，派发事件 
		 * @param event
		 * 
		 */		
		protected function dispatchEvent(event:ParamEvent):void
		{
			if(dispatcher)
				dispatcher.dispatchEvent(event);
		}
		
		/**
		 * 通过控制器的统一事件派发器，监听事件 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		protected function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if(dispatcher)
				dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		/**
		 * 通过控制器的统一事件派发器，移除事件 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * 
		 */		
		protected function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if(dispatcher)
				dispatcher.removeEventListener(type,listener,useCapture);
		}
		/**
		 * 封装消息
		 * @param cmd	消息消息号
		 * @param object 消息内容
		 *
		 */
		protected function sendMessage(cmd:uint, object:*=null):void
		{
			socket.sendMessage(cmd , object);
		}
		
		/**
		 * 添加某个消息号的监听
		 * @param cmd	消息号
		 * @param args	处理函数
		 * 
		 */		
		protected function addCmdListener(cmd:int, hander:Function):void
		{
			socket.addCmdListener(cmd , hander);
		}
		
		/**
		 *移除 消息号监听
		 * @param cmd
		 *
		 */
		public function removeCmdListener(cmd:int, hander:Function):void
		{
			socket.removeCmdListener(cmd, hander);
		}
	}
}