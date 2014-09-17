package as3TankLib.ui
{
	
	
	/**
	 * 图片按钮
	 * @author Leo
	 */
	public class IconButton extends SkinableSprite
	{
		/**
		 * 比如需要的图片素材是：res/a_1.png , res/a_2.png , res/a_3.png<br/>
		 * 那么path传“res/a_”，imageType传“png”
		 * @param path 素材路径
		 * @param imageType 素材后缀（"png" or "jpg"）
		 */
		public function IconButton(path:String = "", imageType:String = "png")
		{
			super();
			_path = path;
			_imageType = imageType;
		}
		
		private var _path:String;
		private var _imageType:String = "png";
		
		private var _lock:Boolean;
		/**
		 * 是否锁住皮肤状态
		 */
		public function get lock():Boolean
		{
			return _lock;
		}
		/**
		 * @private
		 */
		public function set lock(value:Boolean):void
		{
			_lock = value;
			var rb:CustomImage;
			if(_lock)
			{
				rb = new CustomImage();
				rb.load(_path + "_" + _lockSkin);
//				rb.source = _path + _lockSkin +"." + _imageType;
				setSkin(SkinableSprite.NORMAL_SKIN , rb);
				setSkin(SkinableSprite.MOUSE_OVER_SKIN , rb);
				setSkin(SkinableSprite.MOUSE_DOWN_SKIN , rb);
			}
			else
			{
				rb = new CustomImage();
				rb.load(_path + "_1");
//				rb.source = _path + "1." + _imageType;
				setSkin(SkinableSprite.NORMAL_SKIN , rb);
				
				rb = new CustomImage();
				rb.load(_path + "_2");
//				rb.source = _path + "2." + _imageType;
				setSkin(SkinableSprite.MOUSE_OVER_SKIN , rb);
				
				rb = new CustomImage();
				rb.load(_path + "_3");
//				rb.source = _path + "3." + _imageType;
				setSkin(SkinableSprite.MOUSE_DOWN_SKIN , rb);
			}
		}
		
		public function get enable():Boolean
		{
			return !disable;
		}
		/**
		 * 设置按钮是否可使用，不可使用时自动变灰，不接收鼠标事件
		 * @param value
		 */		
		public function set enable(value:Boolean):void
		{
			disable = !value;
		}
		
		private var _lockSkin:int = 3;
		/**
		 * 设置锁定皮肤(默认为3)
		 */
		public function get lockSkin():int
		{
			return _lockSkin;
		}
		/**
		 * @private
		 */
		public function set lockSkin(value:int):void
		{
			_lockSkin = value;
			if(_lock){
				this.lock = _lock;
			}
		}
		
		/**
		 * 设置素材数据 <br/>
		 * 比如需要的图片素材是：res/a_1.png , res/a_2.png , res/a_3.png<br/>
		 * 那么path传“res/a_”，imageType传“png”
		 * @param path 素材路径
		 * @param imageType 素材后缀（"png" or "jpg"）
		 *
		 */
		public function setSource(path:String , imageType:String = "png"):void
		{
			_path = path;
			_imageType = imageType;
			updateSkin();
		}
		
		/**
		 * 此函数是视图的内容初始化函数<br/>对父类的覆盖
		 *
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			
			buttonMode = true;
			updateSkin();
		}
		
		/**
		 * 更新皮肤
		 *
		 */		
		private function updateSkin():void
		{
			if(!initialized)
				return;
			
			var rb:CustomImage = new CustomImage();
			rb.load(_path + "_1");
//			rb.source = _path + "1." + _imageType;
			setSkin(SkinableSprite.NORMAL_SKIN , rb);
			
			rb = new CustomImage();
			rb.load(_path + "_2");
//			rb.source = _path + "2." + _imageType;
			setSkin(SkinableSprite.MOUSE_OVER_SKIN , rb);
			
			rb = new CustomImage();
			rb.load(_path + "_3");
//			rb.source = _path + "3." + _imageType;
			setSkin(SkinableSprite.MOUSE_DOWN_SKIN , rb);
		}
		
	}
}


