package org.bytearray.gif.player
{
   import flash.display.Bitmap;
   import flash.errors.ScriptTimeoutError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.bytearray.gif.decoder.GIFDecoder;
   import org.bytearray.gif.errors.FileTypeError;
   import org.bytearray.gif.events.FileTypeEvent;
   import org.bytearray.gif.events.FrameEvent;
   import org.bytearray.gif.events.GIFPlayerEvent;
   import org.bytearray.gif.events.TimeoutEvent;
   import org.bytearray.gif.frames.GIFFrame;
   
   public class GIFPlayer extends Bitmap
   {
       
      
      private var urlLoader:URLLoader;
      
      private var gifDecoder:GIFDecoder;
      
      private var aFrames:Array;
      
      private var myTimer:Timer;
      
      private var iInc:int;
      
      private var iIndex:int;
      
      private var auto:Boolean;
      
      private var arrayLng:uint;
      
      public function GIFPlayer(param1:Boolean = true)
      {
         super();
         this.auto = param1;
         this.iIndex = this.iInc = 0;
         this.myTimer = new Timer(0,0);
         this.aFrames = new Array();
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlLoader.addEventListener(Event.COMPLETE,this.onComplete);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.myTimer.addEventListener(TimerEvent.TIMER,this.update);
         this.gifDecoder = new GIFDecoder();
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onComplete(param1:Event) : void
      {
         this.readStream(param1.target.data);
      }
      
      private function readStream(param1:ByteArray) : void
      {
         var lng:int = 0;
         var i:int = 0;
         var pBytes:ByteArray = param1;
         var gifStream:ByteArray = pBytes;
         this.aFrames = new Array();
         this.iInc = 0;
         try
         {
            this.gifDecoder.read(gifStream);
            lng = this.gifDecoder.getFrameCount();
            i = 0;
            while(i < lng)
            {
               this.aFrames[int(i)] = this.gifDecoder.getFrame(i);
               i++;
            }
            this.arrayLng = this.aFrames.length;
            if(this.auto)
            {
               this.play();
            }
            else
            {
               this.gotoAndStop(1);
            }
            dispatchEvent(new GIFPlayerEvent(GIFPlayerEvent.COMPLETE,this.aFrames[0].bitmapData.rect));
         }
         catch(e:ScriptTimeoutError)
         {
            dispatchEvent(new TimeoutEvent(TimeoutEvent.TIME_OUT));
         }
         catch(e:FileTypeError)
         {
            dispatchEvent(new FileTypeEvent(FileTypeEvent.INVALID));
         }
         catch(e:Error)
         {
            throw new Error("An unknown error occured, make sure the GIF file contains at least one frame\nNumber of frames : " + aFrames.length);
         }
      }
      
      private function update(param1:TimerEvent) : void
      {
         var _loc2_:int = this.aFrames[int(this.iIndex = this.iInc++ % this.arrayLng)].delay;
         param1.target.delay = _loc2_ > 0 ? _loc2_ : 100;
         switch(this.gifDecoder.disposeValue)
         {
            case 1:
               if(!this.iIndex)
               {
                  bitmapData = this.aFrames[0].bitmapData.clone();
               }
               bitmapData.draw(this.aFrames[this.iIndex].bitmapData);
               break;
            case 2:
               bitmapData = this.aFrames[this.iIndex].bitmapData;
         }
         dispatchEvent(new FrameEvent(FrameEvent.FRAME_RENDERED,this.aFrames[this.iIndex]));
      }
      
      private function concat(param1:int) : int
      {
         bitmapData.lock();
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            bitmapData.draw(this.aFrames[_loc2_].bitmapData);
            _loc2_++;
         }
         bitmapData.unlock();
         return _loc2_;
      }
      
      public function load(param1:URLRequest) : void
      {
         this.stop();
         this.urlLoader.load(param1);
      }
      
      public function loadBytes(param1:ByteArray) : void
      {
         this.readStream(param1);
      }
      
      public function play() : void
      {
         if(this.aFrames.length > 0)
         {
            if(!this.myTimer.running)
            {
               this.myTimer.start();
            }
            return;
         }
         throw new Error("Nothing to play");
      }
      
      public function stop() : void
      {
         if(this.myTimer.running)
         {
            this.myTimer.stop();
         }
      }
      
      public function get currentFrame() : int
      {
         return this.iIndex + 1;
      }
      
      public function get totalFrames() : int
      {
         return this.aFrames.length;
      }
      
      public function get loopCount() : int
      {
         return this.gifDecoder.getLoopCount();
      }
      
      public function get autoPlay() : Boolean
      {
         return this.auto;
      }
      
      public function get frames() : Array
      {
         return this.aFrames;
      }
      
      public function gotoAndStop(param1:int) : void
      {
         if(param1 >= 1 && param1 <= this.aFrames.length)
         {
            if(param1 == this.currentFrame)
            {
               return;
            }
            this.iIndex = this.iInc = int(int(param1) - 1);
            switch(this.gifDecoder.disposeValue)
            {
               case 1:
                  bitmapData = this.aFrames[0].bitmapData.clone();
                  bitmapData.draw(this.aFrames[this.concat(this.iInc)].bitmapData);
                  break;
               case 2:
                  bitmapData = this.aFrames[this.iInc].bitmapData;
            }
            if(this.myTimer.running)
            {
               this.myTimer.stop();
            }
            return;
         }
         throw new RangeError("Frame out of range, please specify a frame between 1 and " + this.aFrames.length);
      }
      
      public function gotoAndPlay(param1:int) : void
      {
         if(param1 >= 1 && param1 <= this.aFrames.length)
         {
            if(param1 == this.currentFrame)
            {
               return;
            }
            this.iIndex = this.iInc = int(int(param1) - 1);
            switch(this.gifDecoder.disposeValue)
            {
               case 1:
                  bitmapData = this.aFrames[0].bitmapData.clone();
                  bitmapData.draw(this.aFrames[this.concat(this.iInc)].bitmapData);
                  break;
               case 2:
                  bitmapData = this.aFrames[this.iInc].bitmapData;
            }
            if(!this.myTimer.running)
            {
               this.myTimer.start();
            }
            return;
         }
         throw new RangeError("Frame out of range, please specify a frame between 1 and " + this.aFrames.length);
      }
      
      public function getFrame(param1:int) : GIFFrame
      {
         var _loc2_:GIFFrame = null;
         if(param1 >= 1 && param1 <= this.aFrames.length)
         {
            return this.aFrames[param1 - 1];
         }
         throw new RangeError("Frame out of range, please specify a frame between 1 and " + this.aFrames.length);
      }
      
      public function getDelay(param1:int) : int
      {
         var _loc2_:int = 0;
         if(param1 >= 1 && param1 <= this.aFrames.length)
         {
            return int(this.aFrames[param1 - 1].delay);
         }
         throw new RangeError("Frame out of range, please specify a frame between 1 and " + this.aFrames.length);
      }
      
      public function dispose() : void
      {
         this.stop();
         var _loc1_:int = this.aFrames.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.aFrames[int(_loc2_)].bitmapData.dispose();
            _loc2_++;
         }
      }
   }
}
