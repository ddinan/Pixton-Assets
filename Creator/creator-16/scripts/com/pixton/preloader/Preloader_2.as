package com.pixton.preloader
{
   import com.pixton.interfaces.IMain;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   
   public class Preloader extends Sprite
   {
       
      
      public var statusMessage:StatusMessage;
      
      private var mainEditor:IMain;
      
      private var loader:Loader;
      
      public function Preloader()
      {
         this.loader = new Loader();
         super();
         Security.allowDomain("pixton.com");
         Security.allowDomain("*.pixton.com");
         Security.allowDomain("pixton.eu");
         Security.allowDomain("*.pixton.eu");
         stage.scaleMode = StageScaleMode.NO_SCALE;
         var _loc1_:* = root.loaderInfo.parameters.okay == null;
         Status.waitText = root.loaderInfo.parameters.wait == null ? "" : root.loaderInfo.parameters.wait;
         Status.init(this.statusMessage);
         Status.setProgressRange(0,10);
         if(root.loaderInfo.parameters.height != null)
         {
            Status.reposition(72,parseInt(root.loaderInfo.parameters.height),parseInt(root.loaderInfo.parameters.height));
         }
         if(root.loaderInfo.parameters.visibleWidth != null)
         {
            Status.setX(root.loaderInfo.parameters.visibleWidth * 0.5);
         }
         var _loc2_:String = root.loaderInfo.parameters.swf == null ? null : root.loaderInfo.parameters.swf;
         var _loc3_:URLRequest = new URLRequest(_loc2_);
         var _loc4_:LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain,SecurityDomain.currentDomain);
         this.loader.load(_loc3_,_loc4_);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.showProgress);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.showLoadResult);
      }
      
      private function showProgress(param1:ProgressEvent) : void
      {
         if(param1.bytesTotal > 0)
         {
            Status.setProgress(param1.bytesLoaded / param1.bytesTotal);
         }
      }
      
      private function showLoadResult(param1:Event) : void
      {
         addChild(this.loader.content);
         setChildIndex(this.loader.content,0);
         IMain(this.loader.content).init(root.loaderInfo.parameters);
      }
   }
}
