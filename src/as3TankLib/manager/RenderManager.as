package as3TankLib.manager
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import as3TankLib.manager.item.IRender;
	
	/**
	 * 统一渲染管理类 
	 * 
	 * @author Michael.Huang
	 * 
	 */	
	public class RenderManager
	{
		private static var instance:RenderManager;
		
		public static function getInstance():RenderManager
		{
			if (null == instance)
				instance = new RenderManager();
			return instance;
		}
		
		public function RenderManager()
		{
			_renderMc = new MovieClip();
			_dic = new Dictionary();
		}
		
		/**
		 * @private 
		 */		
		private var _renderMc:MovieClip;
		
		/**
		 * 函数引用dic 
		 */		
		private var _dic:Dictionary;
		
		/**
		 * 统计加入到RenderManager中的实例 
		 */		
		private var _count:int = 0;
		
		/**
		 * 是否停止 
		 */		
		private var _isStop:Boolean = true;
		
		/**
		 * 记录帧数 
		 */		
		public var step:int;
		/**
		 * 渲染记数id 
		 */
		private var _interval:int;
		
		/**
		 * 开始渲染
		 */
		public function start():void
		{
			if(_isStop)
			{
				_interval = EnterFrameUtil.delayCall(1,enterFrameHandler,true,0,false);
				_isStop = false;
			}
		}
		
		/**
		 * @private 
		 */		
		private function enterFrameHandler(e:Event = null):void
		{
			if (_isStop == true)
				return;
			step++;
			nextStep();
		}
		
		/**
		 * 渲染执行函数 
		 */		
		public function nextStep():void
		{
			for (var i:* in _dic)
			{
				if(i is IRender)
				{
					IRender(i).rendering(step);
				}
				else if(i is Function)
				{
					i(step);
				}
			}
		}
		
		/**
		 * 停止渲染 
		 */		
		public function stop():void
		{
			_isStop = true;
			if(_interval > 0)
			{
				EnterFrameUtil.removeItem(_interval);
				_interval = 0;
				// 避免停止后，不再恢复问题，3秒钟后自动恢复渲染
				EnterFrameUtil.delayCall(3000, start, false, 1);
			}
		}
		
		/**
		 * 添加
		 * @param render
		 * @param delay
		 * 
		 */		
		public function add(render:*, delay:int = 0):void
		{
			if(false == (render in _dic))
			{
				_count++;
				_dic[render] = delay;
			}
			render = null;
		}
		
		/**
		 * 删除
		 * @param render
		 * 
		 */		
		public function remove(render:*):void
		{
			if(render in _dic)
			{
				_count--;
				delete _dic[render];
			}
		}
		
		/**
		 * 渲染列表长度
		 * @return 
		 */
		public function get length():int
		{
			return _count;
		}
		
	}
}
