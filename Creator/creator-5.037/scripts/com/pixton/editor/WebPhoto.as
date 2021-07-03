package com.pixton.editor
{
   import flash.display.BitmapData;
   
   public final class WebPhoto extends Photo
   {
      
      static const ENGINE_FLICKR:String = "flickr";
      
      static const ENGINE_GOOGLE:String = "google";
      
      static const ENGINE_NZ:String = "digitalnz";
      
      private static const localTestImage:uint = 1;
       
      
      public function WebPhoto(param1:uint, param2:uint = 0)
      {
         super();
         cacheKey = "WebPhoto";
         propName = "Photo";
         this.id = param1;
         var _loc3_:BitmapData = Cache.load(cacheKey,param1);
         if(_loc3_ != null)
         {
            placeImage(_loc3_);
         }
         else
         {
            drawPlaceholderBox(800,600);
            Utils.remote("getPhotoInfo",{"photoID":param1},this.onInfo);
         }
      }
      
      static function showSelector(param1:String, param2:String = "") : void
      {
         if(Globals.IDE)
         {
            onSelect(localTestImage);
         }
         else
         {
            Confirm.open("Pixton.imageSearch.showSelector",{
               "engine":param1,
               "popupTitle":param2,
               "extended":1
            });
         }
      }
      
      static function onSelect(param1:uint) : void
      {
         Main.self.enable(true);
         Editor.self.onSelectPhoto(param1);
      }
      
      private function onInfo(param1:Object) : void
      {
         if(param1 != null && param1.width > 0)
         {
            drawPlaceholderBox(param1.width,param1.height);
            if(Editor.self.currentTarget == this)
            {
               Editor.self.updateSelector();
            }
            source = param1.source;
            Editor.self.showImageCredit(this);
            if(param1.engine == ENGINE_GOOGLE)
            {
               Utils.load(Main.IO_DIR + "proxyImage?url=" + param1.url,onLoadImage,false);
            }
            else
            {
               Utils.load(param1.url,onLoadImage,false);
            }
         }
      }
   }
}
