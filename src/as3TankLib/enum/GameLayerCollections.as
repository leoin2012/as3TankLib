package as3TankLib.enum
{
	import as3TankLib.ui.BaseSprite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 *@author Leo
	 */
	public class GameLayerCollections
	{
		private var _bottomLayer:BaseSprite;
		private var _sceneLayer:BaseSprite;
		private var _uiLayer:BaseSprite;
		private var _effectLayer:BaseSprite;
		private var _menuLayer:BaseSprite;
		private var _loadingLayer:BaseSprite;
		private var _msgLayer:BaseSprite;
		private var _topLayer:BaseSprite;
		
		public function GameLayerCollections(display:DisplayObjectContainer)
		{
			_bottomLayer = new BaseSprite();
			_bottomLayer.mouseEnabled = false;
			display.addChild(_bottomLayer);
			
			_sceneLayer = new BaseSprite();
			_sceneLayer.mouseEnabled = false;
			display.addChild(_sceneLayer);
			
			_uiLayer = new BaseSprite();
			_uiLayer.mouseEnabled = false;
			display.addChild(_uiLayer);
			
			_effectLayer = new BaseSprite();
//			_effectLayer.mouseEnabled = false;
//			_effectLayer.mouseChildren = false;
			display.addChild(_effectLayer);
			
			_menuLayer = new BaseSprite();
			_menuLayer.mouseEnabled = false;
			display.addChild(_menuLayer);
			
			_loadingLayer = new BaseSprite();
			_loadingLayer.mouseEnabled = false;
			display.addChild(_loadingLayer);
			
			_msgLayer = new BaseSprite();
			_msgLayer.mouseEnabled = false;
			display.addChild(_msgLayer);
			
			_topLayer = new BaseSprite();
			_topLayer.mouseEnabled = false;
			display.addChild(_topLayer);
		}
		
		/** 最底层 */
		public function get bottomLayer():BaseSprite
		{
			return _bottomLayer;
		}
		/** 场景层 */
		public function get sceneLayer():BaseSprite
		{
			return _sceneLayer;
		}
		/** ui层 */
		public function get uiLayer():BaseSprite
		{
			return _uiLayer;
		}
		/** 特效层 */
		public function get effectLayer():BaseSprite
		{
			return _effectLayer;
		}
		/** 主菜单 */
		public function get menuLayer():BaseSprite
		{
			return _menuLayer;
		}
		/** 加载层 */
		public function get loadingLayer():BaseSprite
		{
			return _loadingLayer;
		}
		/** 提示信息层 */
		public function get msgLayer():BaseSprite
		{
			return _msgLayer;
		}
		/** 最顶层 */
		public function get topLayer():BaseSprite
		{
			return _topLayer;
		}
		
	}
}