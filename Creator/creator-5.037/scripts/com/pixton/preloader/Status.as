package com.pixton.preloader
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.ColorTransform;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class Status
   {
      
      private static const DEBUGGING:Boolean = false;
      
      private static const BAR_INCR:Number = 1;
      
      private static const MARGIN_BOTTOM:Number = 60;
      
      private static const AUTO_INCREMENT_PERIOD:Number = 50;
      
      private static const AUTO_INCREMENT_AMOUNT:Number = 0.02;
      
      private static const ALLOWCLOSE_TIMEOUT:Number = 30000;
      
      public static var busy:Boolean = false;
      
      public static var waitText:String = "";
      
      public static var value:Number;
      
      public static var includeMessage:Boolean;
      
      public static var onReset:Function;
      
      private static var target:MovieClip;
      
      private static var loading:MovieClip;
      
      private static var loadingBorder:MovieClip;
      
      private static var loadingBkgd:MovieClip;
      
      private static var masker:MovieClip;
      
      private static var main:Sprite;
      
      private static var loadingCounter:Number = 0;
      
      private static var interval:int = -1;
      
      private static var currentIncrement:Number = 0;
      
      private static var _noUI:Boolean = false;
      
      private static var _comic:Object;
      
      private static var lowProgress:uint = 0;
      
      private static var highProgress:uint = 100;
      
      private static var hidden:Boolean = false;
      
      private static var _oneTime:Boolean = false;
      
      private static var timeout:int = 0;
       
      
      public function Status()
      {
         super();
      }
      
      public static function init(param1:MovieClip, param2:Boolean = false) : void
      {
         callJavascript("Pixton.comic.onFlashLoaded");
         Status.target = param1;
         Status.hidden = param2;
         loading = param1.loading;
         loadingBorder = param1.loadingBorder;
         loadingBkgd = param1.loadingBkgd;
         masker = param1.masker;
         param1.btnClose.buttonMode = true;
         param1.btnClose.useHandCursor = true;
         param1.btnClose.addEventListener(MouseEvent.CLICK,reset,false,0,true);
         param1.btnClose.visible = false;
         reset();
      }
      
      public static function setMain(param1:Sprite) : void
      {
         main = param1;
      }
      
      public static function setNoUI(param1:Boolean) : void
      {
         _noUI = param1;
         if(_noUI && target != null)
         {
            target.y = 60;
         }
      }
      
      public static function setComic(param1:Object) : void
      {
         _comic = param1;
      }
      
      public static function setX(param1:Number) : void
      {
         if(target == null)
         {
            return;
         }
         target.x = param1;
      }
      
      public static function setProgressRange(param1:uint, param2:uint, param3:Boolean = false) : void
      {
         lowProgress = Math.max(0,Math.min(param1,100));
         highProgress = Math.max(0,Math.min(param2,100));
         stopAutoIncrement();
         if(param3)
         {
            interval = setInterval(autoIncrement,AUTO_INCREMENT_PERIOD);
         }
         setProgress(0);
      }
      
      public static function setColor(param1:uint, param2:uint) : void
      {
      }
      
      private static function hexToRGB(param1:uint) : Array
      {
         return [(param1 & 16711680) >> 16,(param1 & 65280) >> 8,param1 & 255];
      }
      
      private static function setColorOf(param1:MovieClip, param2:Array) : void
      {
         param1.transform.colorTransform = new ColorTransform(0,0,0,0,param2[0],param2[1],param2[2],255);
      }
      
      private static function stopAutoIncrement() : void
      {
         if(interval > -1)
         {
            clearInterval(interval);
            interval = -1;
         }
         currentIncrement = 0;
      }
      
      private static function autoIncrement() : void
      {
         currentIncrement = Math.min(1,currentIncrement + AUTO_INCREMENT_AMOUNT);
         setProgress(currentIncrement,includeMessage);
      }
      
      public static function setProgress(param1:Number, param2:Boolean = true) : void
      {
         if(param1 == Infinity || !loading)
         {
            return;
         }
         param1 = Math.max(0,Math.min(1,param1));
         Status.value = param1;
         Status.includeMessage = param2;
         var _loc3_:uint = lowProgress + param1 * (highProgress - lowProgress);
         if(masker != null)
         {
            masker.fill.scaleX = _loc3_ / 100;
            masker.cap.x = masker.fill.x + masker.fill.width;
         }
         if(_loc3_ == 0)
         {
            loading.visible = false;
            target.message.y = -9;
            setMessage(waitText,false,true);
         }
         else
         {
            loading.visible = true;
            target.message.y = 9;
            if(param2)
            {
               setMessage(" " + _loc3_.toString() + "%",false,true);
            }
         }
         loadingBorder.visible = loading.visible;
         loadingBkgd.visible = loading.visible;
      }
      
      public static function isLocal() : Boolean
      {
         return target == null;
      }
      
      public static function setMessage(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Function = null) : void
      {
         if(param4 != null)
         {
            Status.onReset = param4;
         }
         else
         {
            Status.onReset = null;
         }
         if(_oneTime)
         {
            if(!param3)
            {
               return;
            }
            param2 = false;
         }
         busy = true;
         if(isLocal())
         {
            return;
         }
         if(main != null)
         {
            main.mouseEnabled = false;
            main.mouseChildren = false;
         }
         target.message.text = param1;
         target.visible = !hidden;
         target.btnClose.visible = param2;
         loading.addEventListener(Event.ENTER_FRAME,onFrame,false,0,true);
         if(param2)
         {
            stopAutoIncrement();
         }
         else
         {
            startTimer();
         }
      }
      
      private static function startTimer() : void
      {
         clearTimer();
         timeout = setTimeout(onTimeout,ALLOWCLOSE_TIMEOUT);
      }
      
      private static function clearTimer() : void
      {
         if(timeout > 0)
         {
            clearTimeout(timeout);
            timeout = 0;
         }
      }
      
      private static function onTimeout() : void
      {
         target.btnClose.visible = true;
      }
      
      public static function error(param1:String = "Error - Please Contact Us") : void
      {
         setMessage(param1,true);
      }
      
      public static function reset(param1:MouseEvent = null) : void
      {
         stopAutoIncrement();
         if(onReset != null)
         {
            onReset();
         }
         busy = false;
         if(_oneTime)
         {
            setProgress(1);
            return;
         }
         setProgressRange(0,100);
         setProgress(0);
         if(target == null)
         {
            return;
         }
         if(main != null)
         {
            main.mouseEnabled = true;
            main.mouseChildren = true;
         }
         target.message.text = "";
         target.visible = false;
         clearTimer();
         loading.removeEventListener(Event.ENTER_FRAME,onFrame,false);
      }
      
      public static function makeOneTime() : void
      {
         _oneTime = true;
      }
      
      private static function onFrame(param1:Event) : void
      {
         if(target == null)
         {
            return;
         }
         loadingCounter = (loadingCounter - BAR_INCR) % 24;
         loading.x = loadingCounter;
      }
      
      public static function reposition(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         if(!target || !target.stage)
         {
            return;
         }
         param3 = Math.min(param3,target.stage.stageHeight);
         if(!_noUI)
         {
            if(param2 > 0)
            {
               _loc4_ = param2 * 0.5 + param1;
               target.y = Math.min(_loc4_,param3 - target.height * 0.5 - MARGIN_BOTTOM);
            }
            else if(_comic != null)
            {
            }
         }
      }
      
      private static function debug(param1:* = null) : void
      {
         if(!DEBUGGING)
         {
            return;
         }
         callJavascript("Debug.trace",param1);
      }
      
      private static function callJavascript(param1:String, param2:* = null) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call(param1,param2);
         }
      }
      
      private static function traceStack() : void
      {
         var _loc1_:Error = new Error();
         debug(_loc1_.getStackTrace());
      }
   }
}
