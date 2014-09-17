package as3TankLib.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import as3TankLib.manager.FiltersManager;
	import as3TankLib.util.Debuger;
	
	/**
	 * 可设置皮肤的基础视图对象类<br/>
	 * 默认会监听部分鼠标事件
	 * @author Leo
	 */
	public class SkinableSprite extends BaseSprite
	{
		/**
		 * 普通状态的皮肤 （鼠标移走、鼠标弹起时会恢复到普通状态皮肤）
		 */		
		public static var NORMAL_SKIN:String = "SkinableSprite_NORMAL_SKIN";
		
		/**
		 * 鼠标按下时的皮肤
		 */		
		public static var MOUSE_DOWN_SKIN:String = "SkinableSprite_MOUSE_DOWN_SKIN";
		
		/**
		 * 鼠标移上来时的皮肤
		 */		
		public static var MOUSE_OVER_SKIN:String = "SkinableSprite_MOUSE_OVER_SKIN";
		
		/**
		 * desable状态下的皮肤
		 */		
		public static var DISABLE_SKIN:String = "SkinableSprite_DISABLE_SKIN";
		
		/**
		 * 当前正在显示的对象引用
		 * @return
		 *
		 */		
		private var curOnShowObj:DisplayObject;
		
		/**
		 * 底层，用于加载背景
		 */		
		protected var bgLayer:Sprite;
		
		/**
		 * 中间层，用于加入其他对象
		 */		
		protected var otherLayer:Sprite;
		
		/**
		 * 最顶层，用于获取事件
		 */		
		private var topLayer:Sprite;
		
		public function SkinableSprite()
		{
			super();
			
			bgLayer = new Sprite();
			addChild(bgLayer);
			otherLayer = new Sprite();
			addChild(otherLayer);
			topLayer = new Sprite();
			topLayer.alpha = 0;
			addChild(topLayer);
			
			skinsDic = new Dictionary();
			addEventListener( MouseEvent.MOUSE_DOWN , onMouseDownHandler);
			addEventListener( MouseEvent.MOUSE_UP , onMouseUpHandler);
			addEventListener( MouseEvent.MOUSE_OVER , onMouseOverHandler);
			addEventListener( MouseEvent.MOUSE_OUT , onMouseOutHandler);
		}
		
		protected function onMouseDownHandler(event:MouseEvent):void
		{
			if(_disable) //按钮灰掉了，不再处理变更
				return;
			
			var obj:DisplayObject = skinsDic[SkinableSprite.MOUSE_DOWN_SKIN];
			if(obj && obj != curOnShowObj)
			{
				if(curOnShowObj && contains(curOnShowObj))
					bgLayer.removeChild(curOnShowObj);
				curOnShowObj = obj;
				bgLayer.addChild(obj);
			}
		}
		
		protected function onMouseUpHandler(event:MouseEvent):void
		{
			if(_disable) //按钮灰掉了，不再处理变更
				return;
			
			var obj:DisplayObject = skinsDic[SkinableSprite.NORMAL_SKIN];
			if(obj && obj != curOnShowObj)
			{
				if(curOnShowObj && contains(curOnShowObj))
					bgLayer.removeChild(curOnShowObj);
				curOnShowObj = obj;
				bgLayer.addChild(obj);
			}
		}
		
		protected function onMouseOverHandler(event:MouseEvent):void
		{
			if(_disable) //按钮灰掉了，不再处理变更
				return;
			
			var obj:DisplayObject = skinsDic[SkinableSprite.MOUSE_OVER_SKIN];
			if(obj && obj != curOnShowObj)
			{
				if(curOnShowObj && contains(curOnShowObj))
					bgLayer.removeChild(curOnShowObj);
				curOnShowObj = obj;
				bgLayer.addChild(obj);
			}
		}
		
		protected function onMouseOutHandler(event:MouseEvent):void
		{
			if(_disable) //按钮灰掉了，不再处理变更
				return;
			
			var obj:DisplayObject = skinsDic[SkinableSprite.NORMAL_SKIN];
			if(obj && obj != curOnShowObj)
			{
				if(curOnShowObj && contains(curOnShowObj))
					bgLayer.removeChild(curOnShowObj);
				curOnShowObj = obj;
				bgLayer.addChild(obj);
			}
		}
		
		/**
		 * 存放皮肤的字典
		 */		
		private var skinsDic:Dictionary;
		
		/**
		 * 设置皮肤
		 * @param type 类型（普通，鼠标划过，鼠标按下，等等）
		 * @param value 对应的皮肤，可以是显示对象，或者类
		 *
		 */		
		public function setSkin(type:String, value:*):void
		{
			if(null == value)
				return;
			
			var curShowing:Boolean = false; //当前要设置的皮肤是否正在显示
			var oldObj:DisplayObject = skinsDic[type];
			if(oldObj)
			{
				//若当前正在显示，则移除
				if(contains(oldObj))
				{
					curShowing = true;
					bgLayer.removeChild(oldObj);
				}
				//若旧对象是基础图形类，并且没有被显示，则手动释放资源（通过bgLayer.removeChild移除会自动管理资源，这里则不会）
				if(!curShowing && oldObj is BaseSprite)
					(oldObj as BaseSprite).dispose();
			}
			
			if(value is DisplayObject)
			{
				skinsDic[type] = value;
			}
			else if(value is Class)
			{
				var cls:Class = value as Class;
				skinsDic[type] = new cls();
				
				//发现new出来的不是可视对象，则删除
				if(!(skinsDic[type] is DisplayObject))
					delete skinsDic[type];
			}
			else
			{
//				Debuger.show(Debuger.BASE_LIB , "SkinableSprite.setSkin get a illegal param");
				return;
			}
			
			//当前在设置普通背景，则修改标记位，把普通背景加进来
			if(SkinableSprite.NORMAL_SKIN == type) 
				curShowing = true;
			if(curShowing && skinsDic[type])
			{
				curOnShowObj = skinsDic[type];
				bgLayer.addChild(skinsDic[type]);
			}
		}
		
		protected var _width:Number = 0;
		public override function set width(value:Number):void
		{
			if(_width == value)
				return;
			
			_width = value;
			updateTopLayer();
			var obj:DisplayObject = skinsDic[SkinableSprite.NORMAL_SKIN];
			if(obj)
				obj.width = _width;
			obj = skinsDic[SkinableSprite.MOUSE_DOWN_SKIN];
			if(obj)
				obj.width = _width;
			obj = skinsDic[SkinableSprite.MOUSE_OVER_SKIN];
			if(obj)
				obj.width = _width;
			obj = skinsDic[SkinableSprite.DISABLE_SKIN];
			if(obj)
				obj.width = _width;
			super.width = _width;
		}
		
		protected var _height:Number = 0;
		public override function set height(value:Number):void
		{
			if(_height == value)
				return;
			
			_height = value;
			updateTopLayer();
			var obj:DisplayObject = skinsDic[SkinableSprite.NORMAL_SKIN];
			if(obj)
				obj.height = _height;
			obj = skinsDic[SkinableSprite.MOUSE_DOWN_SKIN];
			if(obj)
				obj.height = _height;
			obj = skinsDic[SkinableSprite.MOUSE_OVER_SKIN];
			if(obj)
				obj.height = _height;
			obj = skinsDic[SkinableSprite.DISABLE_SKIN];
			if(obj)
				obj.height = _height;
			super.height = _height;
		}
		
		/**
		 * 重绘事件获取区
		 *
		 */		
		private function updateTopLayer():void
		{
			topLayer.graphics.clear();
			topLayer.graphics.beginFill(0xffffff);
			topLayer.graphics.drawRect(0,0, _width,_height);
			topLayer.graphics.endFill();
		}
		
		protected var _disable:Boolean = false;
		/**
		 * 是否不可用状态（只是灰掉素材，响应事件的移除外面控制）
		 * @return
		 *
		 */
		public function get disable():Boolean
		{
			return _disable;
		}
		
		public function set disable(value:Boolean):void
		{
			if(_disable == value)
				return;
			
			_disable = value;
			mouseEnabled = !value;
			mouseChildren = !value;
			var disableSkin:DisplayObject = skinsDic[SkinableSprite.DISABLE_SKIN];
			var normalSkin:DisplayObject = skinsDic[SkinableSprite.NORMAL_SKIN];
			var mDownSkin:DisplayObject = skinsDic[SkinableSprite.MOUSE_DOWN_SKIN];
			var mUpSkin:DisplayObject = skinsDic[SkinableSprite.MOUSE_OVER_SKIN];
			if(_disable)
			{
				if(disableSkin)
				{
					if(curOnShowObj && contains(curOnShowObj))
						bgLayer.removeChild(curOnShowObj);
					bgLayer.addChild(disableSkin);
				}
				else
				{
					if(normalSkin)
						normalSkin.filters = FiltersManager.greyFilters;
					if(mDownSkin)
						mDownSkin.filters = FiltersManager.greyFilters;
					if(mUpSkin)
						mUpSkin.filters = FiltersManager.greyFilters;
						//					if(null != curOnShowObj)
						//						curOnShowObj.filters = [FiltersManager.grayColorMatrixFilter];
				}
			}
			else
			{
				if(disableSkin)
				{
					if(contains(disableSkin))
						bgLayer.removeChild(disableSkin);
					bgLayer.addChild(curOnShowObj);
				}
				else
				{
					if(normalSkin)
						normalSkin.filters = [];
					if(mDownSkin)
						mDownSkin.filters = [];
					if(mUpSkin)
						mUpSkin.filters = [];
//					if(null != curOnShowObj)
//						curOnShowObj.filters = [];
				}
			}
		}
	
	}
}


