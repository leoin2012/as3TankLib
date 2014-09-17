package as3TankLib.manager
{
	import flash.events.EventDispatcher;

	/**
	 * 全局事件管理器
	 *@author Leo
	 */
	public class GlobalEventManager extends EventDispatcher
	{
		public function GlobalEventManager()
		{
			if(instance)
				throw new Error("GlobalEventManager is singleton class and allready exists!");
			instance = this;
		}
		
		/**
		 * 单例
		 */
		private static var instance:GlobalEventManager;
		/**
		 * 获取单例
		 */
		public static function getInstance():GlobalEventManager
		{
			if(!instance)
				instance = new GlobalEventManager();
			
			return instance;
		}
	}
}