package com.pixton.editor
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class PhotoSetButton extends MovieClip
   {
       
      
      public var icon:MovieClip;
      
      private var _id:int;
      
      private var _name:String;
      
      private var _iconID:int;
      
      public function PhotoSetButton(param1:int, param2:String, param3:int)
      {
         super();
         this._id = param1;
         this._name = param2;
         this._iconID = param3;
         if(param3 > 0)
         {
            Utils.load(PropPhoto.getImagePath(param3),this.onLoadImage,false,File.BUCKET_DYNAMIC);
         }
      }
      
      function getID() : int
      {
         return this._id;
      }
      
      function getName() : String
      {
         return this._name;
      }
      
      private function onLoadImage(param1:Event) : void
      {
         this.icon.addChild(Bitmap(param1.target.loader.contentLoaderInfo.content));
      }
   }
}
