package as3TankLib.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import as3TankLib.util.Reflection;
	import as3TankLib.util.Tools;

	/**
	 * 自定义图片类（加载库元件）
	 * @author Leo
	 */	
	public class CustomImage extends Sprite
	{
		private var _image:Bitmap;					
		private var _imageURL:String;
		private var _isCenter:Boolean = false;		//是否以图片中心点为起始点
		private var _isGray:Boolean = false;
		
		private var _colorBitmapData:BitmapData;
		private var _grayBitmapData:BitmapData;
		
		/**
		 * 
		 * @param imageURL 文件相对路径或swf元件名
		 * @param isCenter 是否居中
		 * @param isGray 是否置灰
		 * 
		 */		
		public function CustomImage(imageURL:String=null,isCenter:Boolean=false,isGray:Boolean=false)
		{
			if(imageURL == null) return;
			
			this._imageURL = imageURL;
			this._isCenter = isCenter;
			this._isGray = isGray;
			
			this.doLoad(_imageURL);
		}
		
		/**
		 * 加载资源
		 * @param imageURL 文件相对路径或swf元件名
		 * @param isCenter 是否居中
		 * @param isGray 是否置灰
		 */		
		public function load(imageURL:String,isCenter:Boolean=false,isGray:Boolean=false):void {
			this.dispose();
			
			this._imageURL = imageURL;
			this._isCenter = isCenter;
			this._isGray = isGray;
			
			this.doLoad(imageURL);
		}
		
		private function doLoad(imageURL:String):void {
				if(_image == null) {
					_image = new Bitmap()
					addChild(_image);
				}
				_colorBitmapData = Reflection.createBitmapDataInstance(imageURL);
				this.gray = _isGray;
				this.layout();
		}
		
		public function set gray(value:Boolean):void {
			_isGray = value;
			if(_isGray == true) {
				if(_grayBitmapData == null) {
					_grayBitmapData = Tools.grayFilter(_colorBitmapData);
				}
				_image.bitmapData = _grayBitmapData;
			} else {
				_image.bitmapData = _colorBitmapData;
			}
		}
		
		private function layout():void {
			if(_isCenter == true) {
				_image.x = -_image.width >> 1;
				_image.y = -_image.height >> 1;	
			}
		}
		
		public function dispose():void {
			_imageURL = null;
			if(_image != null) {
				_image.bitmapData = null;
			}
			_colorBitmapData = null;
			_grayBitmapData = null;	
		}
		
		/**
		 *返回bitmapData 
		 * @return 
		 * 
		 */		
		public function getBitmapData():BitmapData
		{
			if(_image)
			{
				return  _image.bitmapData;
			}
			return null;
		}
		
		public function getImage():Bitmap
		{
			return this._image;
		}
	}
}