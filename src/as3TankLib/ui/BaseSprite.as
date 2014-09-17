package as3TankLib.ui
{	
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import as3TankLib.manager.FiltersManager;
	import as3TankLib.manager.ReleaseableManager;
	import as3TankLib.manager.ToolTipsManager;
	import as3TankLib.ui.IReleaseable;
	
	/**
	 * 基础图形对象
	 * @author Leo
	 */
	public class BaseSprite extends Sprite implements IReleaseable
	{
		public function BaseSprite()
		{
			super();
		}
		
		/**
		 * 保存当前窗口宽度
		 * @return
		 */		
		public var _w:Number = 0;
		
		/**
		 * 保存当前窗口高度
		 * @return
		 */		
		public var _h:Number = 0;
		
		/**
		 * 设置窗口宽高
		 * @param newWidth
		 * @param newHeight
		 *
		 */		
		public function setActualSize(newWidth:Number, newHeight:Number):void
		{
			_w = newWidth;
			_h = newHeight;
		}
		
		private var _initialized:Boolean = false;
		
		/**
		 * 是否已初始化 （是否已createChilden）
		 */		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		protected var _isTopOwner:Boolean = false;
		/**
		 * 设置此对象是否最底层容器<br/>
		 * 若是，则 set topOwner不会生效，而且topOwner永远指向自己
		 */
		public function get isTopOwner():Boolean
		{
			return _isTopOwner;
		}
		
		/**
		 * @private
		 */
		public function set isTopOwner(value:Boolean):void
		{
			if(true == value)
			{
				//				_topOwner = this;
				setTopOwner(this);
			}
			else
			{
			}
			_isTopOwner = value;
		}
		
		private var _topOwner:BaseSprite = null;
		
		/**
		 * 包含当前对象的最底层容器，可用于同一面板里的事件派发器 <br/>
		 * （是否能改变此对象由isTopOwner控制）
		 * @return 
		 * 
		 */		
		public function get topOwner():BaseSprite
		{
			return _topOwner;
		}
		
		public function set topOwner(value:BaseSprite):void
		{
			if(isTopOwner)
				return;
			_topOwner = value;
		}
		
		//		/**
		//		 * 此对象上一次被移除的时间戳<br/>
		//		 * 用于在适当时间之后自动释放资源<br/>
		//		 * 用getTimer()获取
		//		 */		
		//		public var lastBeenRemoveTime:int;
		
		private var _isOnshow:Boolean = false;
		/**
		 * 是否处于被显示状态（被最底层容器直接或间接包含） <br/>
		 * set方法会递归设置所有子对象
		 */
		public function get isOnshow():Boolean
		{
			return _isOnshow;
		}
		
		/**
		 * @private
		 */
		public function set isOnshow(value:Boolean):void
		{
			_isOnshow = value;
			var num:int = numChildren;
			var childObj:BaseSprite = null;
			for (var i:int = 0; i < num; i++) 
			{
				childObj = getChildAt(i) as BaseSprite;
				if(null != childObj)
				{
					childObj.isOnshow = value;
				}
			}
		}
		
		private var _fade:Boolean = false;
		/**
		 * 是否变灰
		 */
		public function get fade():Boolean
		{
			return _fade;
		}
		/**
		 * @private
		 */
		public function set fade(value:Boolean):void
		{
			_fade = value;
			if(value)
				filters = FiltersManager.greyFilters;
			else
				filters = [];
		}
		
		
		/**
		 * 根据变量创建或取消tooltip
		 * 
		 */		
		private function resetToolTip():void
		{
			if(!initialized)
				return;
			
			if(null != _toolTipClass) //使用自定义tooltip
				ToolTipsManager.getInstance().setTooltips(this, "", _toolTipClass , _tooltipDataFunc);
			else if("" != _tooltipStr) //使用默认tooltip
				ToolTipsManager.getInstance().setTooltips(this, _tooltipStr);
			else
				ToolTipsManager.getInstance().removeTooltips(this);
		}
		
		private var _tooltipStr:String = "";
		/**
		 * 为此对象加入一个默认背景的tooltip提示 
		 * @param value
		 * 
		 */		
		public function set tooltip(value:String):void
		{
			_tooltipStr = value;
			if(initialized)
				resetToolTip();
		}
		
		private var _toolTipClass:Class = null;
		private var _tooltipDataFunc:Function = null;
		/**
		 * 设置自定义tips视图类的tooltip
		 * @param toolTipClass tooltip视图类
		 * @param tooltipDataFunc 获取toolTipClass所需的数据的函数
		 * 
		 */		
		public function setExtraToolTip(toolTipClass:Class , tooltipDataFunc:Function):void
		{
			_toolTipClass = toolTipClass;
			_tooltipDataFunc = tooltipDataFunc;
			resetToolTip();
		}
		
		/**
		 * 删除tooltip 
		 * 
		 */		
		public function cancelTooltip():void
		{
			_toolTipClass = null;
			_tooltipStr = "";
			resetToolTip();
		}
		
		/**
		 * 此函数是视图的内容初始化函数<br/>
		 * 在被BaseSprite对象Addchild的时候触发一次
		 * 
		 */		
		protected function createChildren():void
		{
			_initialized = true;
			resetToolTip();
		}
		
		/**
		 * 强制初始化对象<br/>
		 * 一般在父对象不是baseSprite时才用这个初始化 
		 * 
		 */		
		public function forceCreateChild():void
		{
			if(!_initialized)
				createChildren();
		}
		
		/**
		 * 重写方法，增加初始化判断
		 * @param child
		 * @return 
		 * 
		 */		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			var _child:BaseSprite = child as BaseSprite;
			var _irelease:IReleaseable = child as IReleaseable;
			if(_child)
			{
				_child.isOnshow = isOnshow;
				if(topOwner)
					_child.setTopOwner(this.topOwner);
				else
					_child.setTopOwner(this);
				if( !_child.initialized)
					_child.createChildren();
				//自己在显示列表里
				if(isOnshow)
				{
					_child.autoReleaseable = false;
					if(!_child._hasResume)
						_child.resume();
				}
			}
			else if(_irelease) //处理非BaseSprite的情况
			{
				if(isOnshow) //自己在显示列表里
				{
					_irelease.resume();
				}
			}
			return child;
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child,index);
			var _child:BaseSprite = child as BaseSprite;
			if(_child)
			{
				if( !_child.initialized)
					_child.createChildren();
				if(topOwner)
					_child.setTopOwner(this.topOwner);
				else
					_child.setTopOwner(this);
				//自己在显示列表里
				if(isOnshow)
				{
					//此对象在显示列表里，说明子对象从不显示到显示，从资源回收管理器里移除
					_child.autoReleaseable = false;
					if(!_child._hasResume)
						_child.resume();
				}
				_child.isOnshow = isOnshow;
			}
			else if(child is IReleaseable) //处理非BaseSprite的情况
			{
				if(isOnshow) //自己在显示列表里
				{
					(child as IReleaseable).resume();
				}
			}
			return child;
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			super.removeChild(child);
			var _child:BaseSprite = child as BaseSprite;
			if(_child && _child.initialized)
			{
				//				_child.dispose();
				_child.setTopOwner(_child);
				//				_child.lastBeenRemoveTime = getTimer();
				_child.isOnshow = false;//isOnshow;
				//此对象在显示列表里，说明子对象从显示到不显示，加入资源回收管理器
				if(isOnshow )
					_child.autoReleaseable = true;
			}
			else if(child is IReleaseable) //处理非BaseSprite的情况
			{
				if(isOnshow) //自己在显示列表里
				{
					(child as IReleaseable).dispose();
				}
			}
			return child;
		}
		
		public override function removeChildAt(index:int):DisplayObject
		{
			var obj:DisplayObject = super.removeChildAt(index);
			var _child:BaseSprite = obj as BaseSprite;
			if(_child && _child.initialized)
			{
				//				_child.dispose();
				_child.setTopOwner(_child);
				//				_child.lastBeenRemoveTime = getTimer();
				//此对象在显示列表里，说明子对象从显示到不显示，加入资源回收管理器
				if(isOnshow )
					_child.autoReleaseable = true;
			}
			else if(obj is IReleaseable) //处理非BaseSprite的情况
			{
				if(isOnshow) //自己在显示列表里
				{
					(obj as IReleaseable).dispose();
				}
			}
			return obj;
		}
		
		/**
		 * 设置该对象所有子包含对象的topOwner
		 * @param child
		 * 
		 */		
		public function setTopOwner(tOwner:BaseSprite):void
		{
			if(isTopOwner)
				return;
			
			topOwner = tOwner;
			var num:int = numChildren;
			var childObj:BaseSprite = null;
			for (var i:int = 0; i < num; i++) 
			{
				childObj = getChildAt(i) as BaseSprite;
				if(null != childObj)
				{
					childObj.setTopOwner(tOwner);
				}
			}
		}
		
		/**
		 * 移动坐标 
		 * @param xpos
		 * @param ypos
		 * 
		 */		
		public function move(xpos:Number , ypos:Number):void
		{
			x = xpos;
			y = ypos;
		}
		
		/**
		 *  删除所有子对象
		 * 
		 */		
		public function removeAllChildren():void
		{
			while(0 < numChildren)
				this.removeChildAt(0);
		}
		
		private var _hasResume:Boolean = false;
		/**
		 * dispose后是否已经resume过了，当前是否处于resume后的状态<br/>
		 * 用于控制不能连续resume或dispose 
		 */
		public function get hasResume():Boolean
		{
			return _hasResume;
		}
		
		private var _lockReleaseble:Boolean = false;
		/**
		 * 是否锁住的资源释放和恢复的操作 
		 */
		public function get lockReleaseble():Boolean
		{
			return _lockReleaseble;
		}
		/**
		 * @private
		 */
		public function set lockReleaseble(value:Boolean):void
		{
			_lockReleaseble = value;
		}
		
		/**
		 * 注册自动释放管理器，一段时间后释放本身的资源<br/>
		 * （反注册会递归到子孙节点，防止出现BUG:<br/>
		 *  一个对象被addchild，注册了releaseable，父容器被移除，此对象没有反注册releaseable） 
		 * @param value
		 */		
		private function set autoReleaseable(value:Boolean):void
		{
			if(value)
			{
				ReleaseableManager.getInstance().addItem(this);
			}
			else
			{
				ReleaseableManager.getInstance().removeItem(this);
				var num:int = numChildren;
				var childObj:BaseSprite = null;
				for (var i:int = 0; i < num; i++) 
				{
					childObj = getChildAt(i) as BaseSprite;
					if(null != childObj)
						childObj.autoReleaseable = false;
				}
			}
		}
		
		/**
		 * 恢复资源<br/>
		 * 迭代调用所有此对象的子对象的resume函数 
		 * 
		 */		
		public function resume():void
		{
			if(lockReleaseble)
				return;
			if(_hasResume)
				return;
			
			_hasResume = true;
			var num:int = numChildren;
			var childObj:IReleaseable = null;
			for (var i:int = 0; i < num; i++) 
			{
				childObj = getChildAt(i) as IReleaseable;
				if(null != childObj)
				{
					childObj.resume();
				}
			}
			resetToolTip();
		}
		
		
		/**
		 * 释放资源<br/>
		 * 迭代调用所有此对象的子对象的dispose函数 
		 * 
		 */	
		public function dispose():void
		{
			if(lockReleaseble)
				return;
			if(!_hasResume)
				return;
			
			_hasResume = false;
			var num:int = numChildren;
			var childObj:IReleaseable = null;
			for (var i:int = 0; i < num; i++) 
			{
				childObj = getChildAt(i) as IReleaseable;
				if(null != childObj)
				{
					childObj.dispose();
				}
			}
			ToolTipsManager.getInstance().removeTooltips(this);
		}
	}
}
