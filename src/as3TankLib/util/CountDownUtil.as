package as3TankLib.util
{
	import as3TankLib.manager.TimerManager;
	
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 倒计时工具
	 * @author Leo
	 */
	public class CountDownUtil
	{
		public function CountDownUtil()
		{
			if(instance)
				throw new Error("CountDownUtil is singleton class and allready exists!");
			instance = this;
		}
		
		/**
		 * 单例
		 */
		private static var instance:CountDownUtil;
		/**
		 * 获取单例
		 */
		public static function getInstance():CountDownUtil
		{
			if(!instance)
				instance = new CountDownUtil();
			
			return instance;
		}
		/** 倒计时字典 */
		private static var allCountDownDic:Dictionary = new Dictionary();
		/** 当前倒计时个数 */
		private static var curCountDownNum:int;
		
		/** 删除某个倒计时 */
		private function removeCountDown(func:Function):void
		{
			getInstance().doRemoveCountDown(func);
		}
		
		/**
		 * 注册一个倒计时
		 * @param remainTime 剩余时间
		 * @param stepFunc 执行函数
		 */		
		public static function addWithRemainTime(remainTime:int, stepFunc:Function):void
		{
			getInstance().doAddWithRemainTime(remainTime, stepFunc);
		}
		/**
		 * 注册一个倒计时
		 * @param stopTime 结束时间戳
		 * @param stepFunc 执行函数
		 */		
		public static function addWithStopTime(stopTime:int, stepFunc:Function):void
		{
			getInstance().doAddWithStopTime(stopTime, stepFunc);
		}
		
		/** 是否 */
		public static function hasCountDown(func:Function):Boolean
		{
			return getInstance().doHasCountDown(func);
		}
		
		/**
		 * 删除某个倒计时 
		 * @param func
		 */		
		private function doRemoveCountDown(func:Function):void
		{
			if(null != allCountDownDic[func])
			{
				delete allCountDownDic[func];
				curCountDownNum--;
				if(1 > curCountDownNum)
					TimerManager.getInstance().removeItem(onTimerHandler);
			}
		}
		
		/**
		 * 查询是否有某个倒计时
		 * @param func
		 * @return 
		 */		
		private function doHasCountDown(func:Function):Boolean
		{
			if(null != allCountDownDic[func])
			{
				return true;
			}else
			{
				return false;
			}
		}
		
		/** 注册一个倒计时 */
		private function doAddWithRemainTime(remainTime:int, stepFunc:Function):void
		{
			if(1 > remainTime || null == stepFunc)return;
			
			var now:int = getTimer();
			var stopTime:int = now + remainTime;
			doAddWithStopTime(stopTime, stepFunc);
		}
		/** 注册一个倒计时 */
		private function doAddWithStopTime(stopTime:int, stepFunc:Function):void
		{
			if(getTimer() > stopTime || null == stepFunc)return;
			
			allCountDownDic[stepFunc] = {stopTime:stopTime, stepFunc:stepFunc};
			curCountDownNum++;
			if(2 > curCountDownNum)
				TimerManager.getInstance().addItem(1000, onTimerHandler);
		}
		/** 计时器函数 */
		private function onTimerHandler():void
		{
			var now:int = getTimer();
			for(var key:* in allCountDownDic)
			{
				var obj:* = allCountDownDic[key];
				var func:Function = obj.stepFunc as Function;
				var curCountDownStr:String = "";
				var limitTime:int = obj.stopTime - now;
				if(0 > limitTime)
					limitTime = 0;
				curCountDownStr = TimeUtil.formatTime(new Date(limitTime));
				if(null != func)
					func.apply(null, [curCountDownStr]);
				if(1 > limitTime)
				{
					delete allCountDownDic[key];
					curCountDownNum--;
					if(1 > curCountDownNum)
						TimerManager.getInstance().removeItem(onTimerHandler);
				}
			}
		}
		
	}
}