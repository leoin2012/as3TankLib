package as3TankLib.manager
{
	import as3TankLib.ui.BaseSprite;
	
	import flash.utils.Dictionary;

	/**
	 * 资源释放管理器
	 *@author Leo
	 */
	public class ReleaseableManager
	{
		public function ReleaseableManager()
		{
			if(instance)
				throw new Error("ReleaseableManager is singleton class and allready exists!");
			instance = this;
		}
		/** 单例*/
		private static var instance:ReleaseableManager;
		/** 获取单例*/
		public static function getInstance():ReleaseableManager
		{
			if(!instance)
				instance = new ReleaseableManager();
			
			return instance;
		}
		/** 可释放资源的对象字典 */
		private var releaseableObjDic:Dictionary = new Dictionary();
		/** 需要管理的对象数量 */
		private var objNum:int = 0;
		/** 释放资源间隔（秒） */
		private var releaseInterval:int = 10;
		
		/** 启动管理器 */
		public function start():void
		{
			TimerManager.getInstance().removeItem(timerHandler);
			TimerManager.getInstance().addItem(1000, timerHandler);
		}
		/** 停止管理器 */
		public function stop():void
		{
			TimerManager.getInstance().removeItem(timerHandler);
		}
		/** 增加一个需管理的视图对象 */
		public function addItem(item:BaseSprite):void
		{
			if(releaseableObjDic[item] != undefined)return;
			
			releaseableObjDic[item] = releaseInterval;
			objNum++;
			if(2 > objNum)
				start();
		}
		/** 删除一个不再需要管理的视图对象 */
		public function removeItem(item:BaseSprite):void
		{
			if(null != releaseableObjDic[item])
			{
				delete releaseableObjDic[item];
				objNum--;
				if(1 > objNum)
					stop();
			}
		}
		
		/** 每秒轮询 */
		private function timerHandler():void
		{
			for(var i:* in releaseableObjDic)
			{
				releaseableObjDic[i] --;
				if(i > releaseableObjDic[i])
				{
					if((i as BaseSprite).hasResume)
						(i as BaseSprite).dispose();
					delete releaseableObjDic[i];
					objNum--;
				}
			}
			if(1 > objNum)
				stop();
		}
		
	}
}