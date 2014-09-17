package as3TankLib.util
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.sampler.NewObjectSample;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    
	/**
	 * 资源加载器 
	 * @author Leo
	 * 
	 */	
    public class AssetsLoader extends EventDispatcher {
        private const ASSETS_URL:String = "config/assetConfig.xml";
        
        private var _urlLoader:URLLoader;
        private var _fileNum:int;
        
        public function AssetsLoader() {
            _urlLoader = new URLLoader(new URLRequest(ASSETS_URL)); 
            _urlLoader.addEventListener(Event.COMPLETE, AssetsLoaded);
        }
        
        private function AssetsLoaded(e:Event):void {
            _urlLoader.removeEventListener(Event.COMPLETE, AssetsLoaded);
            
            var xml:XML = new XML(_urlLoader.data);
            var xmlList:XMLList = xml.assets;
            
            _fileNum = xmlList.length();
            
            if(_fileNum == 0) {
                dispatchEvent(new Event(Event.COMPLETE));
                return;
            }
            
            var fileURL:String;
            var loader:Loader;
            var loaderContext:LoaderContext;
            
            for each (var file:XML in xmlList) {
                fileURL = file.toString();
                loader = new Loader();
                loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
                loader.load(new URLRequest(fileURL), loaderContext);
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fileLoaded);
            }
        }
        
        private function fileLoaded(e:Event):void {
            var lodaerInfo:LoaderInfo = e.target as LoaderInfo;
            lodaerInfo.removeEventListener(Event.COMPLETE, fileLoaded);
            
            _fileNum--;
            if (_fileNum == 0) {
                dispatchEvent(new Event(Event.COMPLETE));
                return;
            }
        }
    }
}