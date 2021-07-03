package com.pixton.editor
{
   import com.pixton.preloader.Status;
   import flash.events.DataEvent;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.FileFilter;
   import flash.net.FileReference;
   import flash.net.URLRequest;
   
   public final class FileUpload
   {
      
      private static const UPLOAD_SCRIPT:String = "editor/saveUpload";
      
      public static const MEDIA_IMAGE:uint = 0;
      
      public static const MEDIA_SOUND:uint = 1;
      
      public static var imagesEnabled:Boolean = false;
      
      public static var forcedVisible:Boolean = false;
      
      public static var soundEnabled:Boolean = false;
      
      private static var maxFileSize:uint = 0;
      
      private static var uploadOwn:Boolean = false;
      
      private static var file:FileReference;
      
      private static var handler:Function;
      
      private static var mediaType:uint = 0;
      
      private static var existingID;
       
      
      public function FileUpload()
      {
         super();
      }
      
      public static function init(param1:Object) : void
      {
         maxFileSize = param1.uploadMaxSize;
         imagesEnabled = param1.uploadEnabled >= 1;
         forcedVisible = param1.uploadEnabled == 2;
         soundEnabled = param1.sua > 0;
         uploadOwn = imagesEnabled && param1.uploadOwn == 1;
         if(imagesEnabled || soundEnabled)
         {
            file = new FileReference();
            Utils.addListener(file,Event.SELECT,onFileSelected);
            Utils.addListener(file,Event.COMPLETE,onComplete);
            Utils.addListener(file,ProgressEvent.PROGRESS,onProgress);
            Utils.addListener(file,Event.CANCEL,onCancel);
            Utils.addListener(file,Event.OPEN,onOpen);
            Utils.addListener(file,DataEvent.UPLOAD_COMPLETE_DATA,onUploadComplete);
            Utils.addListener(file,HTTPStatusEvent.HTTP_STATUS,onHTTPStatus);
            Utils.addListener(file,SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
            Utils.addListener(file,IOErrorEvent.IO_ERROR,onIOError);
         }
      }
      
      public static function canUploadOwn() : Boolean
      {
         return uploadOwn;
      }
      
      public static function prompt(param1:Function, param2:uint, param3:* = null) : void
      {
         FileUpload.handler = param1;
         FileUpload.mediaType = param2;
         FileUpload.existingID = param3;
         file.browse(getTypes());
      }
      
      private static function onFileSelected(param1:Event) : void
      {
         if(file.size > maxFileSize)
         {
            handleResponse(L.text("upload-max",Math.ceil(maxFileSize / 1000000) + "MB"));
         }
         else
         {
            promptForName(onFileSource);
         }
      }
      
      private static function promptForName(param1:Function = null) : void
      {
         Popup.show(L.text("image-source"),param1,null,"",null,true,false,true);
      }
      
      private static function onFileSource(param1:String = null, param2:* = null) : void
      {
         var imageSource:String = param1;
         var notUsed:* = param2;
         Utils.remote("getSessionID",{},function(param1:Object):void
         {
            onSessionID(param1,imageSource);
         });
      }
      
      private static function onSessionID(param1:Object, param2:String) : void
      {
         var _loc3_:URLRequest = null;
         if(param1.sess != null)
         {
            Status.setMessage(file.name);
            Status.setProgressRange(0,100);
            _loc3_ = new URLRequest();
            _loc3_.url = Utils.makePath(UPLOAD_SCRIPT) + "?type=" + mediaType + "&sess=" + param1.sess;
            if(existingID != null)
            {
               _loc3_.url += "&id=" + existingID;
            }
            if(param2 != null)
            {
               _loc3_.url += "&src=" + encodeURIComponent(param2);
            }
            file.upload(_loc3_);
         }
      }
      
      private static function getTypes() : Array
      {
         return [getImageTypeFilter()];
      }
      
      private static function getImageTypeFilter() : FileFilter
      {
         switch(mediaType)
         {
            case MEDIA_SOUND:
               return new FileFilter("Audio (*.mp3, *.wav)","*.mp3;*.wav");
            case MEDIA_IMAGE:
         }
         return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)","*.jpg;*.jpeg;*.gif;*.png");
      }
      
      private static function onProgress(param1:ProgressEvent) : void
      {
         Status.setProgress(param1.bytesLoaded / param1.bytesTotal);
      }
      
      private static function onComplete(param1:Event) : void
      {
      }
      
      private static function onUploadComplete(param1:DataEvent) : void
      {
         Status.reset();
         handleResponse(param1.data);
      }
      
      private static function onCancel(param1:Event) : void
      {
         Status.reset();
      }
      
      private static function onHTTPStatus(param1:HTTPStatusEvent) : void
      {
      }
      
      private static function onOpen(param1:Event) : void
      {
      }
      
      private static function onSecurityError(param1:SecurityErrorEvent) : void
      {
         Status.reset();
         handleResponse(L.text("editor-err-general"));
      }
      
      private static function onIOError(param1:IOErrorEvent) : void
      {
         Status.reset();
         handleResponse(L.text("editor-err-general"));
      }
      
      private static function handleResponse(param1:String) : void
      {
         if(param1.substr(0,3) == "id:")
         {
            handler(param1.substr(3));
         }
         else
         {
            Confirm.alert(param1,false);
         }
      }
   }
}
