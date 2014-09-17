package as3TankLib.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.getQualifiedClassName;
	
	import as3TankLib.manager.FiltersManager;
	import as3TankLib.ui.SimpleWindow;
	import as3TankLib.util.Color;
	import as3TankLib.util.Reflection;
	
	/**
	 * 游戏基础窗体
	 * @author Leo
	 *
	 */	
	public class GameWindow extends SimpleWindow
	{
		public function GameWindow()
		{
			super();
		}
		
		/**
		 * 窗口背景
		 */		
		protected var _windowBg:Sprite;
		/**
		 * 窗口内部背景
		 */		
		private var innerBgSprite:Sprite;
		/**
		 * 第二层内部背景 
		 */		
		private var secondInnerBgSprite:Sprite;
		/**
		 * 是否拥有内部背景
		 */		
		private var _innerBg:Boolean = false;
		/**
		 * 是否拥有第二层内部背景 
		 */		
		private var _secondInnerBg:Boolean = false;
		
		/**
		 * 标题素材图片
		 */		
		protected var titleImg:CustomImage;
		
		protected var titleText:CustomTextfield;
		
		private var _titleName:String
		/**
		 * 设置标题名字，用于加载标题背景
		 * @return
		 */		
		protected function get titleName():String
		{
			return _titleName;
		}
		protected function set titleName(value:String):void
		{
			_titleName = value;
			if(!initialized)
				return;
			
//			titleImg.load("windowTitle_" + value);
			
			titleText.text = _titleName;
			titleText.x = _w/2 - titleText.textWidth/2;
//			titleImg.source = rLanguage("res/image/windowTitle/{language}/" + _titleName + ".png");
		}
		
		/**
		 * 调整窗口各控件大小
		 *
		 */		
		protected override function drawWindow():void
		{
			if(!initialized)
				return;
			super.drawWindow();
			
			_windowBg.cacheAsBitmap = false;
			
			_windowBg.width = _w;
			_windowBg.height = _h;
			
			innerBgSprite.width = _windowBg.width - 14;
			innerBgSprite.height = _windowBg.height - 42;
			
			secondInnerBgSprite.width = _windowBg.width - 24;
			secondInnerBgSprite.height = _windowBg.height - 53;
			
			if(super.hasCloseBtn)
			{
				closeBtn.x = _w-31;
				closeBtn.y = _windowBg.y + 7;
			}
			
			titleImg.x = _w/2 - titleImg.width/2;
			
			_windowBg.cacheAsBitmap = true;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_windowBg = Reflection.createSpriteInstance("winBg_1");
			addChild(_windowBg);
			
			if(!innerBgSprite)
			{
				innerBgSprite = Reflection.createSpriteInstance("winBg_2");
				innerBgSprite.x = 7;
				innerBgSprite.y = 35;
			}
			
			if(!secondInnerBgSprite)
			{
				secondInnerBgSprite = Reflection.createSpriteInstance("winBg_3");
				secondInnerBgSprite.x = 12;
				secondInnerBgSprite.y = 41;
			}
			
			isAddInnerBg(_innerBg);
			isAddSecondInnerBg(_secondInnerBg);
			
			titleImg = new CustomImage();
			titleImg.y = 5;
			titleImg.addEventListener(Event.COMPLETE , onTitleImgLoadComplete);
			addChild(titleImg);
			
			titleText = new CustomTextfield(true, new GlowFilter(Color.WHITE, 1, 3, 3, 3));
			titleText.color = Color.GRAY;
			titleText.size = 18;
			titleText.bold = true;
			titleText.text = "Alert";
			
			titleText.y = 5;
			titleText.x = _w/2 - titleText.textWidth/2;
			addChild(titleText);
			
			//没有手动设置过标题素材，则没有标题
			if(null == _titleName || "" == _titleName)
			{
//				var tmpTitleName:String = getQualifiedClassName(this);
//				titleName = tmpTitleName.substr( tmpTitleName.indexOf("::")+2);
			}
			else
				titleName = _titleName;
			
			if(hasCloseBtn)
			{
				closeBtn = Reflection.createSimpleButtonInstance("window_closeButton");
				if(!closeBtn.hasEventListener(MouseEvent.CLICK))
					closeBtn.addEventListener(MouseEvent.CLICK , onCloseWindowHandler);
				addChild(closeBtn);
			}
			else
			{
				closeBtn.removeEventListener(MouseEvent.CLICK , onCloseWindowHandler);
				closeBtn.parent.removeChild(closeBtn);
			}
			
			drawWindow();
			
			cacheList.push(_windowBg);
			cacheList.push(innerBgSprite);
			cacheList.push(secondInnerBgSprite);
			cacheList.push(titleImg);
		}
		
		/**
		 * 是否显示内部背景
		 * @param value
		 */		
		private function isAddInnerBg(value:Boolean):void
		{
			if(value && innerBgSprite && !innerBgSprite.parent) 
				this.addChild(innerBgSprite);
		}
		/**
		 * 是否显示第二层内部背景
		 * @param value
		 */		
		private function isAddSecondInnerBg(value:Boolean):void
		{
			if(value && secondInnerBgSprite && !secondInnerBgSprite.parent) 
				this.addChild(secondInnerBgSprite);
		}
		
		/**
		 * 是否有内部背景
		 * @param value
		 */		
		public function set innerBg(value:Boolean):void
		{
			this._innerBg = value;
			isAddInnerBg(_innerBg);
		}
		
		/**
		 * 是否有第二层内部背景
		 * @param value
		 */		
		public function set secondInnerBg(value:Boolean):void
		{
			this._secondInnerBg = value;
			isAddSecondInnerBg(_secondInnerBg);
		}
		/**
		 * 标题素材加载完毕，重设位置
		 * @param event
		 *
		 */		
		protected function onTitleImgLoadComplete(event:Event):void
		{
			titleImg.x = _w/2 - titleImg.width/2;
		}
	}
}


