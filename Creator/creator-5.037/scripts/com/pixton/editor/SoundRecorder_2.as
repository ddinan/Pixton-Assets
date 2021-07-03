package com.pixton.editor
{
   import com.pixton.preloader.Status;
   import fl.controls.ComboBox;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.NetStatusEvent;
   import flash.events.StatusEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.media.Microphone;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   
   public final class SoundRecorder extends MovieClip
   {
      
      static var SHOW_INSTRUCTIONS:Boolean = false;
      
      private static var USE_JS:Boolean = true;
      
      private static const MARGIN_BOTTOM:Number = 50;
      
      private static const PADDING:Number = 10;
      
      private static const STATE_NOT_CONNECTED:uint = 0;
      
      private static const STATE_IDLE:uint = 1;
      
      private static const STATE_WAITING:uint = 2;
      
      private static const STATE_RECORDING:uint = 3;
      
      private static const STATE_SAVING:uint = 4;
      
      private static const USE_MASTER_SERVER:Boolean = true;
      
      public static var MAX_DURATION:uint = 0;
      
      public static var hasSpeechToText:Boolean = false;
      
      private static var myMic:Microphone;
      
      private static var nc:NetConnection;
      
      private static var ns:NetStream;
      
      private static var recordingState:uint = STATE_NOT_CONNECTED;
      
      private static var sampleRate:Number = 44;
      
      private static var silenceLevel:Number = 0;
      
      private static var volumeLevel:Number = 75;
      
      private static var timer:Timer;
      
      private static var self:SoundRecorder;
      
      private static var _comic:Object;
      
      private static var handler:Function;
      
      private static var soundKey:String;
      
      private static var onConnectFunc:Function;
      
      private static var maxLevel:Number = 0;
      
      private static var microphoneDenied:Boolean = false;
      
      private static var targetDialog:Dialog;
       
      
      public var level:MovieClip;
      
      public var txtMessage:TextField;
      
      public var loading:MovieClip;
      
      public var masker:MovieClip;
      
      public var btnClose:MovieClip;
      
      public var maxLevelIndicator:MovieClip;
      
      public var barBkgd:MovieClip;
      
      public var reflection:MovieClip;
      
      public var selMic:ComboBox;
      
      public var btnRecord:MenuItem;
      
      public var btnStop:MenuItem;
      
      private var _startTime:int;
      
      private var _timer:int = -1;
      
      public function SoundRecorder()
      {
         super();
         USE_JS = Utils.javascript("Pixton.sound.record.isSupported");
         Debug.trace("USE_JS " + USE_JS);
         this.loading = this.level.loading;
         this.masker = this.level.masker;
         this.maxLevelIndicator = this.level.maxLevelIndicator;
         this.barBkgd = this.level.barBkgd;
         this.reflection = this.level.reflection;
         visible = false;
         if(USE_JS)
         {
            this.level.visible = false;
            this.selMic.visible = false;
            this.btnRecord.x = this.btnStop.x = 0;
            this.btnRecord.scaleX = this.btnRecord.scaleY = this.btnStop.scaleX = this.btnStop.scaleY = 1.5;
            this.txtMessage.x = -74;
            this.txtMessage.y = -41;
         }
         else
         {
            this.btnRecord.x = this.btnStop.x = 83;
            this.btnRecord.scaleX = this.btnRecord.scaleY = this.btnStop.scaleX = this.btnStop.scaleY = 1;
            this.txtMessage.x = -100;
            this.txtMessage.y = -4;
         }
         this.btnRecord.setColor(Editor.COLOR[Editor.MODE_MOVE],Editor.COLOR_OVER[Editor.MODE_MOVE]);
         this.btnStop.setColor(Editor.COLOR[Editor.MODE_MOVE],Editor.COLOR_OVER[Editor.MODE_MOVE]);
         this.btnRecord.disablable = true;
         Utils.useHand(this.reflection);
         Utils.useHand(this.btnClose);
      }
      
      public static function init(param1:SoundRecorder, param2:Object) : void
      {
         self = param1;
         _comic = param2;
         if(ExternalInterface.available && !Status.isLocal())
         {
            ExternalInterface.addCallback("onSpeechToText",onSpeechToText);
         }
      }
      
      static function isAvailable() : Boolean
      {
         if(USE_JS)
         {
            return true;
         }
         return Microphone.names.length > 0;
      }
      
      static function wasPermitted() : Boolean
      {
         return !microphoneDenied;
      }
      
      public static function show(param1:Function, param2:String) : void
      {
         SoundRecorder.handler = param1;
         SoundRecorder.soundKey = param2;
         self.onShow();
      }
      
      public static function initText() : void
      {
         self.initText();
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
      
      static function speechToText(param1:Dialog) : void
      {
         if(Utils.javascript("Pixton.sound.speechToText"))
         {
            targetDialog = param1;
         }
      }
      
      static function onSpeechToText(param1:String) : void
      {
         targetDialog.addText(param1);
         targetDialog = null;
      }
      
      private function initText() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(USE_JS)
         {
            this.selMic.visible = false;
         }
         else
         {
            _loc2_ = Microphone.names.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.selMic.addItem({
                  "label":Microphone.names[_loc1_],
                  "data":_loc1_
               });
               _loc1_++;
            }
            Utils.addListener(this.selMic,Event.CHANGE,this.onSelectMic);
         }
      }
      
      private function onShow() : void
      {
         recordingState = STATE_IDLE;
         this.makeFocus();
         this.refreshButtons();
         this.prepareMic();
      }
      
      function makeFocus() : void
      {
         Main.disableExcept(self);
         visible = true;
         Utils.addListener(this.btnRecord,MouseEvent.CLICK,this.onButton);
         Utils.addListener(this.btnRecord,MouseEvent.ROLL_OVER,this.showHelp);
         Utils.addListener(this.btnRecord,MouseEvent.ROLL_OUT,this.hideHelp);
         Utils.addListener(this.btnStop,MouseEvent.CLICK,this.onButton);
         Utils.addListener(this.btnStop,MouseEvent.ROLL_OVER,this.showHelp);
         Utils.addListener(this.btnStop,MouseEvent.ROLL_OUT,this.hideHelp);
         Utils.addListener(this.reflection,MouseEvent.CLICK,this.onButton);
         Utils.addListener(this.btnClose,MouseEvent.CLICK,this.onClose);
      }
      
      private function onSelectMic(param1:Event) : void
      {
         if(parseInt(this.selMic.value) == -1 && Microphone.names.length > 0)
         {
            this.selMic.selectedIndex = 1;
         }
         this.prepareMic();
      }
      
      private function prepareMic() : void
      {
         this.resetMaxLevel();
         this.showMicLevel();
         if(USE_JS)
         {
            recordingState = STATE_IDLE;
            this.startMonitoring();
         }
         else
         {
            if(parseInt(this.selMic.value) == -1)
            {
               return;
            }
            myMic = Microphone.getMicrophone(parseInt(this.selMic.value));
            Utils.addListener(myMic,StatusEvent.STATUS,this.onMicStatus);
            myMic.setSilenceLevel(silenceLevel);
            myMic.gain = volumeLevel;
            myMic.rate = sampleRate;
            this.requireConnection(this.startMonitoring);
         }
      }
      
      private function requireConnection(param1:Function) : void
      {
         var onConnectFunc:Function = param1;
         SoundRecorder.onConnectFunc = onConnectFunc;
         if(nc != null)
         {
            onConnectFunc();
         }
         else
         {
            nc = new NetConnection();
            nc.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
            nc.client = {
               "onBWDone":function(... rest):void
               {
               },
               "onBWCheck":function(... rest):Number
               {
                  return 0;
               }
            };
            nc.connect(Utils.recordingServer);
         }
      }
      
      private function startMonitoring() : void
      {
         if(!USE_JS)
         {
            if(ns == null)
            {
               ns = new NetStream(nc);
               ns.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
               timer = new Timer(100);
               Utils.addListener(timer,TimerEvent.TIMER,this.showMicLevel);
               timer.start();
            }
            ns.attachAudio(myMic);
         }
      }
      
      private function onMicStatus(param1:StatusEvent) : void
      {
         if(param1.code == "Microphone.Muted")
         {
            microphoneDenied = true;
            this.onClose();
         }
      }
      
      private function onNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetConnection.Connect.Success":
               recordingState = STATE_IDLE;
               onConnectFunc();
               break;
            case "NetStream.Record.Start":
               recordingState = STATE_RECORDING;
               this._startTime = getTimer();
               break;
            case "NetStream.Unpublish.Success":
               recordingState = STATE_SAVING;
               this.convertRecording();
               break;
            case "NetConnection.Connect.Closed":
            case "NetStream.Record.Stop":
            case "NetStream.Publish.Start":
               break;
            default:
               this.onClose();
               Utils.alert(L.text("record-error") + (!!Main.isSuper() ? ": " + Utils.recordingServer + "; " + Utils.toString(param1.info) : ""));
         }
         this.refreshButtons();
      }
      
      private function refreshButtons() : void
      {
         this.btnRecord.enableState = recordingState == STATE_IDLE && (USE_JS || myMic != null);
         this.btnStop.enableState = recordingState == STATE_RECORDING;
         this.btnRecord.visible = !this.btnStop.enableState;
         if(recordingState == STATE_RECORDING)
         {
            this.txtMessage.text = L.text("record-recording");
         }
         else if(recordingState == STATE_SAVING)
         {
            this.txtMessage.text = L.text("saving");
         }
         else if(recordingState == STATE_WAITING)
         {
            this.txtMessage.text = L.text("please-wait");
         }
         else if(USE_JS)
         {
            this.txtMessage.text = L.text("record-btn");
         }
         else
         {
            this.txtMessage.text = L.text("record-monitor");
         }
      }
      
      private function onButton(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this.btnRecord:
               this.recordStart();
               break;
            case this.btnStop:
               this.recordStop();
               break;
            case this.reflection:
               this.resetMaxLevel();
         }
      }
      
      private function recordStart() : void
      {
         recordingState = STATE_WAITING;
         this.refreshButtons();
         this.resetMaxLevel();
         if(USE_JS)
         {
            this.startRecording();
         }
         else
         {
            this.requireConnection(this.startRecording);
         }
      }
      
      private function startRecording() : void
      {
         if(soundKey == null)
         {
            soundKey = Utils.randomString();
         }
         if(USE_JS)
         {
            this.startTimer();
            recordingState = STATE_RECORDING;
            Utils.javascript("Pixton.sound.record.start");
            this.refreshButtons();
         }
         else
         {
            ns.publish(soundKey,"record");
         }
      }
      
      private function clearTimer() : void
      {
         if(this._timer != -1)
         {
            clearInterval(this._timer);
            this._timer = -1;
         }
      }
      
      private function startTimer() : void
      {
         this.clearTimer();
         this._startTime = getTimer();
         this._timer = setInterval(this.onInterval,100);
      }
      
      private function onInterval() : void
      {
         var _loc1_:int = 0;
         if(recordingState == STATE_RECORDING)
         {
            _loc1_ = getTimer() - this._startTime;
            if(_loc1_ > MAX_DURATION * 1000)
            {
               if(USE_JS || maxLevel > 0)
               {
                  Utils.alert(L.text("record-max",MAX_DURATION));
               }
               this.recordStop();
            }
         }
      }
      
      private function recordStop() : void
      {
         if(USE_JS)
         {
            this.clearTimer();
            Utils.javascript("Pixton.sound.record.stop",soundKey);
         }
         else if(ns != null)
         {
            ns.close();
         }
         recordingState = STATE_SAVING;
         this.refreshButtons();
      }
      
      private function convertRecording() : void
      {
         Utils.remote("getSessionID",{},this.onSessionID);
      }
      
      private function onSessionID(param1:Object) : void
      {
         if(maxLevel == 0)
         {
            Utils.alert(L.text("record-silent"));
            recordingState = STATE_IDLE;
            this.refreshButtons();
         }
         else if(USE_MASTER_SERVER)
         {
            Utils.sendAndLoad(Utils.masterServer + "util/sound/convert?rtmp" + "&platform=" + param1.platform + "&product=" + param1.product + "&sess=" + param1.sess + "&key=" + soundKey,this.onConverted,true,true);
         }
         else
         {
            Utils.remote("convertSound",{"key":soundKey},this.onConverted,true);
         }
      }
      
      public function onConverted(param1:Object) : void
      {
         recordingState = STATE_IDLE;
         this.refreshButtons();
         if(param1 != null && param1.error == null)
         {
            handler(soundKey);
         }
         else
         {
            Utils.alert(param1.error);
         }
         this.onClose();
      }
      
      public function onError(param1:String) : *
      {
         this.clearTimer();
         this.onClose();
      }
      
      private function resetMaxLevel(param1:MouseEvent = null) : void
      {
         maxLevel = 0;
         this.maxLevelIndicator.visible = false;
      }
      
      private function showMicLevel(param1:TimerEvent = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            this.loading.visible = false;
         }
         else
         {
            _loc2_ = Utils.limit(myMic.activityLevel / volumeLevel,0,1);
            if(_loc2_ > maxLevel)
            {
               maxLevel = _loc2_;
               this.maxLevelIndicator.x = Math.round(this.barBkgd.x + this.barBkgd.width * _loc2_);
               this.maxLevelIndicator.visible = true;
            }
            this.loading.visible = true;
            this.masker.fill.scaleX = _loc2_;
            if(recordingState == STATE_RECORDING)
            {
               _loc3_ = getTimer() - this._startTime;
               if(_loc3_ > MAX_DURATION * 1000)
               {
                  if(maxLevel > 0)
                  {
                     Utils.alert(L.text("record-max",MAX_DURATION));
                  }
                  this.recordStop();
               }
            }
         }
      }
      
      private function showHelp(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         switch(param1.currentTarget)
         {
            case this.btnRecord:
               _loc2_ = L.text("record-start");
               _loc3_ = true;
               break;
            case this.btnStop:
               _loc2_ = L.text("record-stop");
               _loc3_ = true;
         }
         if(_loc2_ != null)
         {
            Help.show(_loc2_,param1.currentTarget,_loc3_);
         }
      }
      
      private function hideHelp(param1:MouseEvent = null) : void
      {
         Help.hide();
      }
      
      private function onClose(param1:MouseEvent = null) : void
      {
         if(ns != null)
         {
            ns.close();
            ns = null;
         }
         if(nc != null)
         {
            nc.close();
            nc = null;
         }
         if(myMic != null)
         {
            Utils.addListener(myMic,StatusEvent.STATUS,this.onMicStatus);
            myMic = null;
         }
         if(timer != null)
         {
            Utils.removeListener(timer,TimerEvent.TIMER,this.showMicLevel);
            timer.stop();
         }
         Utils.removeListener(this.btnRecord,MouseEvent.CLICK,this.onButton);
         Utils.removeListener(this.btnRecord,MouseEvent.ROLL_OVER,this.showHelp);
         Utils.removeListener(this.btnRecord,MouseEvent.ROLL_OUT,this.hideHelp);
         Utils.removeListener(this.btnStop,MouseEvent.CLICK,this.onButton);
         Utils.removeListener(this.btnStop,MouseEvent.ROLL_OVER,this.showHelp);
         Utils.removeListener(this.btnStop,MouseEvent.ROLL_OUT,this.hideHelp);
         Utils.removeListener(this.reflection,MouseEvent.CLICK,this.onButton);
         Utils.removeListener(this.btnClose,MouseEvent.CLICK,this.onClose);
         Main.enableAll();
         visible = false;
      }
   }
}
