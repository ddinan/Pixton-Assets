package com.pixton.editor
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   
   public final class Popup extends MovieClip
   {
      
      private static const MARGIN_BOTTOM:Number = 50;
      
      private static const PADDING:Number = 10;
      
      private static var handler:Function;
      
      private static var self:Popup;
      
      private static var storedData;
      
      private static var timer:Timer;
      
      private static var timerMessage:String;
      
      private static var timerValue:int;
      
      private static var onTimerComplete:Function;
      
      private static var onTimerCancel:Function;
      
      private static var _comic:Object;
      
      private static var textX:Number;
      
      private static var textWidth:Number;
      
      private static var isConfirm:Boolean;
      
      private static var allowNoValue:Boolean = false;
       
      
      public var btnSubmit:EditorButton;
      
      public var btnCancel:EditorButton;
      
      public var txtMessage:TextField;
      
      public var txtInput:TextField;
      
      public var btnClose:MovieClip;
      
      public var imageContainer:MovieClip;
      
      public var bkgd:MovieClip;
      
      public function Popup()
      {
         super();
         visible = false;
         textX = this.txtInput.x;
         textWidth = this.txtInput.width;
         this.resetPositions();
         this.btnSubmit.setHandler(this.onSubmit);
         this.btnSubmit.makePriority();
         if(this.btnCancel != null)
         {
            this.btnCancel.setHandler(this.onCancel);
         }
         Utils.useHand(this.btnClose);
         Utils.addListener(this.btnClose,MouseEvent.CLICK,this.onClose);
      }
      
      public static function init(param1:Popup, param2:Object) : void
      {
         self = param1;
         _comic = param2;
      }
      
      public static function updateColor() : void
      {
         self.btnSubmit.updateColor();
         if(self.btnCancel != null)
         {
            self.btnCancel.updateColor();
         }
         Utils.setColor(self.bkgd.fill,Palette.colorBkgd);
         Utils.setColor(self.bkgd.line,Palette.colorLine);
         self.txtMessage.textColor = Palette.colorText;
      }
      
      public static function reposition(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         if(self == null)
         {
            return;
         }
         if(param2 > 0)
         {
            _loc4_ = param2 * 0.5 + param1;
            self.y = Math.min(_loc4_,param3 - self.height * 0.5 - MARGIN_BOTTOM);
         }
         else if(_comic != null)
         {
            self.y = _comic.getCurrentY();
         }
      }
      
      public static function show(param1:String, param2:Function, param3:* = null, param4:String = null, param5:* = null, param6:Boolean = true, param7:Boolean = false, param8:Boolean = false) : void
      {
         if(param4 == null)
         {
            param4 = "";
         }
         Popup.isConfirm = param7;
         Popup.allowNoValue = param8;
         makeFocus();
         updateMessage(param1);
         if(param7)
         {
            self.updateButtons(L.text("okay"),L.text("cancel"));
         }
         else
         {
            self.updateButtons(L.text("save"));
         }
         handler = param2;
         storedData = param3;
         self.onShow(param4,param5,param6,param7);
      }
      
      private static function makeFocus() : void
      {
         Main.disableExcept(self);
         self.visible = true;
      }
      
      private static function updateMessage(param1:String) : void
      {
         self.txtMessage.text = param1;
      }
      
      public static function countdown(param1:String, param2:Function, param3:Function, param4:uint) : void
      {
         makeFocus();
         timerValue = param4;
         timerMessage = param1;
         onTimerComplete = param2;
         onTimerCancel = param3;
         self.updateButtons(L.text("continue"));
         self.btnClose.visible = false;
         self.txtInput.visible = false;
         timer = new Timer(1000);
         timer.addEventListener(TimerEvent.TIMER,onCountdown,false,0,true);
         timer.start();
         onCountdown();
      }
      
      private static function onCountdown(param1:TimerEvent = null) : void
      {
         updateMessage(timerMessage.replace("{}",timerValue--));
         if(timerValue < 0)
         {
            timer.stop();
            onTimerComplete();
         }
      }
      
      public static function hasFocus() : Boolean
      {
         if(self == null)
         {
            return false;
         }
         return self.visible;
      }
      
      function resetPositions() : void
      {
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.align = TextFormatAlign.CENTER;
         this.txtInput.x = textX;
         this.txtInput.width = textWidth;
         this.txtInput.defaultTextFormat = _loc1_;
         this.txtMessage.x = this.txtInput.x;
         this.txtMessage.width = this.txtInput.width;
         this.txtMessage.setTextFormat(_loc1_);
         this.btnSubmit.x = 0;
      }
      
      private function onShow(param1:String, param2:*, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:TextFormat = null;
         this.txtInput.text = param1;
         this.btnClose.visible = param3;
         this.txtInput.visible = !param4;
         if(param2 != null)
         {
            if(param2 is BitmapData)
            {
               this.imageContainer.addChild(new Bitmap(param2));
            }
            else
            {
               this.imageContainer.addChild(param2);
            }
            (_loc5_ = new TextFormat()).align = TextFormatAlign.LEFT;
            this.txtInput.x = this.imageContainer.x + this.imageContainer.width + PADDING;
            this.txtInput.width = Math.round(this.bkgd.width * 0.5 - PADDING * 2 - this.txtInput.x);
            this.txtInput.defaultTextFormat = _loc5_;
            this.txtMessage.x = this.txtInput.x - 2;
            this.txtMessage.width = this.txtInput.width;
            this.txtMessage.setTextFormat(_loc5_);
            this.btnSubmit.x = Math.round(this.txtInput.x + this.btnSubmit.width * 0.5);
         }
         else if(this.btnCancel != null)
         {
            this.btnSubmit.x = Math.round(-(this.btnCancel.width + PADDING) * 0.5);
            this.btnCancel.x = Math.round(this.btnSubmit.x + (this.btnSubmit.width + this.btnCancel.width) * 0.5 + PADDING);
         }
         if(this.txtInput.visible)
         {
            stage.focus = this.txtInput;
         }
      }
      
      private function updateButtons(param1:String, param2:String = null) : void
      {
         this.btnSubmit.label = param1;
         if(this.btnCancel != null)
         {
            if(param2 == null)
            {
               this.btnCancel.visible = false;
            }
            else
            {
               this.btnCancel.label = param2;
               this.btnCancel.visible = true;
            }
         }
      }
      
      private function onSubmit(param1:EditorButton) : void
      {
         if(this.txtInput.visible && this.txtInput.text == "" && !allowNoValue)
         {
            return;
         }
         if(isConfirm)
         {
            handler(true);
         }
         else if(onTimerCancel != null)
         {
            timer.stop();
            onTimerCancel();
            onTimerCancel = null;
            onTimerComplete = null;
         }
         else if(storedData == null)
         {
            handler(this.txtInput.text);
         }
         else
         {
            handler(this.txtInput.text,storedData);
         }
         this.onAfterClose();
      }
      
      private function onCancel(param1:EditorButton) : void
      {
         this.onClose();
      }
      
      private function onClose(param1:MouseEvent = null) : void
      {
         if(isConfirm)
         {
            handler(false);
         }
         else
         {
            handler(null,storedData);
         }
         this.onAfterClose();
      }
      
      private function onAfterClose() : void
      {
         if(this.imageContainer.numChildren > 0)
         {
            this.imageContainer.removeChildAt(0);
            this.resetPositions();
         }
         Main.enableAll();
         visible = false;
      }
   }
}
