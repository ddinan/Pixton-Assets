package com.pixton.widget
{
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.Regular;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.media.Sound;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.net.ObjectEncoding;
   import flash.net.Responder;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   import org.bytearray.gif.events.FrameEvent;
   import org.bytearray.gif.events.GIFPlayerEvent;
   import org.bytearray.gif.events.TimeoutEvent;
   import org.bytearray.gif.player.GIFPlayer;
   
   public class ComicViewer extends Sprite
   {
      
      private static const MIN_HEIGHT:uint = 360;
      
      private static const MODE_LOCAL:String = "dev";
      
      private static const MODE_LOCAL_LIVE:String = "live";
      
      private static const MODE_PIXTON:String = "pixton";
      
      private static const DEFAULT_KEY:String = "";
      
      private static const DEFAULT_MODE:String = "";
      
      private static const DEFAULT_PLATFORM:String = "";
      
      private static const DEFAULT_PRODUCT:String = "";
      
      private static const COMIC_WIDTH:Number = 900;
      
      private static const COMIC_HEIGHT:uint = 300;
      
      private static const TITLE_GAP:uint = 15;
      
      private static const PADDING_W:uint = 7;
      
      private static const PADDING_H:uint = 9;
      
      private static const FADE_DURATION:Number = 0.2;
      
      private static const SLIDE_DURATION:Number = 0.4;
      
      private static const MOVE_FACTOR:Number = 0.75;
      
      private static const SPEED_BASE:uint = 30;
      
      private static const SPEED_MAX:uint = 90;
      
      private static const BOTTOM_PADDING:Number = 43;
      
      private static const FULLSCREEN_PADDING:uint = 30;
      
      private static const BUTTON_GAP:Number = 10;
      
      private static const FULLSCREEN_ENABLED:Boolean = true;
      
      private static const ALPHA_ON:Number = 1;
      
      private static const ALPHA_OFF:Number = 0.3;
      
      private static const ICON_SCALE_OVER:Number = 1.1;
      
      private static const ICON_SCALE_OFF:Number = 1;
      
      private static const STYLE_SIMPLE:String = "simple";
      
      private static const SCALING_DEFAULT:String = "";
      
      private static const SCALING_AUTO:String = "auto";
      
      private static const AMF_GATEWAY:String = "editor/amfphp/gateway";
      
      private static var HTTP:String = "";
      
      private static var domainSuffix:String;
      
      private static var server:String;
      
      private static var mode:String;
      
      private static var netConnection:NetConnection;
      
      private static var scenes:Array;
      
      private static var currentScene:MovieClip;
      
      private static var scaleMode:String = null;
      
      private static var scaleFactor:Number = 1;
      
      private static var isThumb:Boolean = false;
      
      private static var streamingServer:String = "";
      
      private static var localBucket:String = "";
      
      private static var nc:NetConnection;
      
      private static var ns:NetStream;
      
      private static var dynamicServer:String = "";
      
      private static var embedCode:String;
      
      private static var platformKey:String = "";
      
      private static var productKey:String = "";
      
      private static var version:uint = 2;
      
      private static var _isFreeStyle:Boolean = false;
      
      private static var _hasBorders:Boolean = false;
      
      private static var _hasAnimation:Boolean = false;
      
      private static var _createLink:String = "";
      
      private static var _printLink:String = "";
      
      private static var ready:Boolean = false;
      
      private static const BKGD_PADDING:Number = 10;
      
      private static var bgColor:int = 16777215;
      
      private static var bkgd:Sprite;
      
      private static var bkgd2:Sprite;
      
      private static var white:ColorTransform;
      
      private static var isSlideShow:Boolean = false;
      
      private static var slideShowOpacity:Number = 1;
      
      private static var currentPanel:uint = 0;
      
      private static var imageCredits:String;
      
      private static var isDebugging:Boolean = false;
       
      
      public var title:MovieClip;
      
      public var author:MovieClip;
      
      public var btnCredit:MovieClip;
      
      public var btnCreate:MovieClip;
      
      public var btnSources:MovieClip;
      
      public var btnPrint:MovieClip;
      
      public var masker:MovieClip;
      
      public var hotspot:MovieClip;
      
      public var masked:MovieClip;
      
      public var border:MovieClip;
      
      public var btnShare:MovieClip;
      
      public var btnPixton:MovieClip;
      
      public var arrowBack:MovieClip;
      
      public var arrowNext:MovieClip;
      
      public var arrowUp:MovieClip;
      
      public var arrowDown:MovieClip;
      
      public var loading:LoadingIcon;
      
      public var btnFullScreen:MovieClip;
      
      public var btnNormalScreen:MovieClip;
      
      public var btnOpenInPixton:MovieClip;
      
      public var popup:Popup;
      
      private var container:MovieClip;
      
      private var soundContainer:MovieClip;
      
      private var txtTitle:TextField;
      
      private var txtAuthor:TextField;
      
      private var txtCredit:TextField;
      
      private var txtCreate:TextField;
      
      private var txtSources:TextField;
      
      private var key:String;
      
      private var format:uint = 6;
      
      private var titleLink:String;
      
      private var authorLink:String;
      
      private var sceneObjs:Array;
      
      private var tween:Tween;
      
      private var tweenAlpha:Array;
      
      private var tweenX:Tween;
      
      private var tweenY:Tween;
      
      private var tweenX2:Tween;
      
      private var tweenY2:Tween;
      
      private var tweenAlpha1:Tween;
      
      private var tweenAlpha2:Tween;
      
      private var startTime:Number;
      
      private var startX:Number;
      
      private var startY:Number;
      
      private var startMouseX:Number;
      
      private var startMouseY:Number;
      
      private var language:String;
      
      private var voiceovers:Object;
      
      private var buttonsMap:Object;
      
      private var isPreview:Boolean = false;
      
      private var autoFullScreen:Boolean = true;
      
      private var scrolling:Boolean = false;
      
      private var gif:GIFPlayer;
      
      private var stopScrollTime:Number = 0;
      
      private var embedStyle:String;
      
      private var loader:Loader;
      
      public function ComicViewer()
      {
         this.buttonsMap = {};
         this.loader = new Loader();
         super();
         this.btnCredit.visible = false;
         this.btnCreate.visible = false;
         this.btnSources.visible = false;
         this.btnPrint.visible = false;
         this.btnFullScreen.visible = false;
         this.btnNormalScreen.visible = false;
         this.btnOpenInPixton.visible = false;
         this.arrowBack.visible = false;
         this.arrowNext.visible = false;
         this.arrowUp.visible = false;
         this.arrowDown.visible = false;
         this.btnShare.visible = false;
         this.btnShare.normal.visible = true;
         this.btnShare.edmodo.visible = false;
         this.loading.x = Math.round(stage.stageWidth * 0.5);
         this.loading.y = Math.round(stage.stageHeight * 0.5);
         this.btnPixton.x = this.loading.x - this.btnPixton.width * 0.5;
         this.btnPixton.y = this.loading.y + 32;
         addEventListener(Event.ADDED_TO_STAGE,this.onReady);
         this.container = this.masked.container;
         this.txtTitle = this.title.txtTitle;
         this.txtAuthor = this.author.txtAuthor;
         this.txtCredit = this.btnCredit.txtCredit;
         this.txtCreate = this.btnCreate.txtCreate;
         this.txtSources = this.btnSources.txtCreate;
         this.soundContainer = new MovieClip();
         this.masked.addChild(this.soundContainer);
         this.txtTitle.autoSize = TextFieldAutoSize.LEFT;
         this.txtAuthor.autoSize = TextFieldAutoSize.RIGHT;
         this.txtCredit.autoSize = TextFieldAutoSize.LEFT;
         this.txtCreate.autoSize = TextFieldAutoSize.CENTER;
         this.txtTitle.mouseEnabled = false;
         this.txtAuthor.mouseEnabled = false;
         white = new ColorTransform(0,0,0,1,255,255,255,0);
         this.loading.show();
         Cursor.init(stage);
      }
      
      private static function loadSound(param1:ButtonVO) : void
      {
         var button:ButtonVO = param1;
         requireConnection(function():void
         {
            button.hideLoading();
            startStreaming(button);
         });
      }
      
      private static function requireConnection(param1:Function) : void
      {
         var onConnectFunc:Function = param1;
         if(nc != null)
         {
            onConnectFunc();
         }
         else
         {
            nc = new NetConnection();
            NetConnection.prototype.onBWDone = function(param1:*):*
            {
            };
            nc.addEventListener(NetStatusEvent.NET_STATUS,function(param1:NetStatusEvent):void
            {
               onNetStatus(param1,onConnectFunc);
            });
            nc.connect(streamingServer,false);
         }
      }
      
      private static function startStreaming(param1:ButtonVO) : void
      {
         var button:ButtonVO = param1;
         if(ns == null)
         {
            ns = new NetStream(nc);
            NetStream.prototype.onPlayStatus = function(param1:*):*
            {
            };
            ns.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
         }
         ns.play(button.url);
      }
      
      private static function onNetStatus(param1:NetStatusEvent, param2:Function = null) : void
      {
         switch(param1.info.code)
         {
            case "NetConnection.Connect.Success":
               if(param2 != null)
               {
                  param2();
               }
               break;
            case "NetConnection.Connect.Failed":
            case "NetConnection.Connect.Closed":
               nc = null;
         }
      }
      
      private function showMenu() : void
      {
         if(embedCode != null)
         {
            this.updatePopupPosition();
            this.popup.show(embedCode);
         }
      }
      
      private function showSources() : void
      {
         var _loc1_:URLRequest = null;
         if(imageCredits != null)
         {
            _loc1_ = new URLRequest(encodeURI(imageCredits));
            this.gotoURL(_loc1_);
         }
      }
      
      private function gotoURL(param1:URLRequest) : void
      {
         if(stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            return;
         }
         navigateToURL(param1,"_blank");
      }
      
      private function toggleFullScreen(param1:MouseEvent) : void
      {
         if(stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            stage.displayState = StageDisplayState.NORMAL;
         }
         else
         {
            stage.displayState = StageDisplayState.FULL_SCREEN;
         }
         this.autoFullScreen = false;
         this.updateButtonVisibility();
      }
      
      private function updateButtonVisibility() : void
      {
         this.btnCreate.visible = _createLink != "" && !isThumb && !this.isSimple();
         this.btnSources.visible = imageCredits != null;
      }
      
      private function onSlideClick(param1:MouseEvent) : void
      {
         if(stage.displayState != StageDisplayState.FULL_SCREEN && this.autoFullScreen)
         {
            stage.displayState = StageDisplayState.FULL_SCREEN;
            return;
         }
         var _loc2_:uint = currentPanel;
         ++currentPanel;
         if(this.tweenAlpha1 != null)
         {
            this.tweenAlpha1.fforward();
         }
         if(this.tweenAlpha2 != null)
         {
            this.tweenAlpha2.fforward();
         }
         var _loc3_:Boolean = this.autoFullScreen;
         if(currentPanel >= scenes.length)
         {
            currentPanel = 0;
         }
         if(currentPanel == 0 && stage.displayState == StageDisplayState.FULL_SCREEN && this.autoFullScreen)
         {
            scenes[_loc2_].alpha = slideShowOpacity;
            stage.displayState = StageDisplayState.NORMAL;
            this.onResize();
            this.autoFullScreen = _loc3_;
         }
         else
         {
            this.tweenAlpha1 = new Tween(scenes[_loc2_],"alpha",Regular.easeInOut,scenes[_loc2_].alpha,slideShowOpacity,SLIDE_DURATION,true);
            this.tweenAlpha2 = new Tween(scenes[currentPanel],"alpha",Regular.easeInOut,scenes[currentPanel].alpha,1,SLIDE_DURATION,true);
            this.onResize(param1);
         }
      }
      
      private function onTitle(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest(encodeURI(this.titleLink));
         this.gotoURL(_loc2_);
      }
      
      private function onAuthor(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest(encodeURI(this.authorLink));
         this.gotoURL(_loc2_);
      }
      
      private function onPlayAnimation(param1:MouseEvent) : void
      {
         if(this.stopScrollTime - getTimer() >= -1)
         {
            return;
         }
         this.playAnimation(param1.currentTarget as MovieClip);
      }
      
      private function playAnimation(param1:MovieClip) : void
      {
         var _loc2_:String = null;
         if(this.gif != null)
         {
            this.gif.stop();
            this.gif.parent.removeChild(this.gif);
            this.gif.dispose();
            this.gif = null;
            currentScene.btnPlayAnimation.visible = true;
         }
         if(param1 != currentScene)
         {
            currentScene = param1;
            currentScene.btnPlayAnimation.visible = false;
            this.gif = new GIFPlayer();
            this.gif.scaleX = scaleFactor;
            this.gif.scaleY = scaleFactor;
            this.gif.addEventListener(IOErrorEvent.IO_ERROR,this.onGIFIOError);
            this.gif.addEventListener(GIFPlayerEvent.COMPLETE,this.onGIFLoad);
            this.gif.addEventListener(FrameEvent.FRAME_RENDERED,this.onGIFFrame);
            this.gif.addEventListener(TimeoutEvent.TIME_OUT,this.onGIFTimeoutError);
            _loc2_ = param1.src.replace(/\.png$/,".gif");
            param1.addChildAt(this.gif,1);
            this.gif.load(new URLRequest(_loc2_));
         }
         else
         {
            currentScene = null;
         }
      }
      
      private function onGIFLoad(param1:GIFPlayerEvent) : void
      {
      }
      
      private function onGIFFrame(param1:FrameEvent) : void
      {
      }
      
      private function onGIFIOError(param1:IOErrorEvent) : void
      {
      }
      
      private function onGIFTimeoutError(param1:TimeoutEvent) : void
      {
      }
      
      private function onButton(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:URLRequest = null;
         if(this.stopScrollTime - getTimer() >= -1)
         {
            return;
         }
         switch(param1.type)
         {
            case MouseEvent.CLICK:
               switch(param1.currentTarget)
               {
                  case this.btnPixton:
                     _loc2_ = HTTP + "www.pixton." + domainSuffix + "/";
                     break;
                  case this.btnShare:
                     this.showMenu();
                     break;
                  case this.btnSources:
                     this.showSources();
                     break;
                  case this.btnCreate:
                     _loc2_ = _createLink;
                     break;
                  case this.btnPrint:
                     _loc2_ = _printLink;
                     break;
                  default:
                     if(this.scrolling)
                     {
                        this.scrolling = false;
                        return;
                     }
                     if(stage.displayState != StageDisplayState.FULL_SCREEN)
                     {
                        this.toggleFullScreen(param1);
                     }
                     return;
               }
               if(_loc2_ != null)
               {
                  if(stage.displayState == StageDisplayState.FULL_SCREEN)
                  {
                     this.toggleFullScreen(param1);
                  }
                  _loc3_ = new URLRequest(_loc2_);
                  this.gotoURL(_loc3_);
               }
               break;
            case MouseEvent.ROLL_OVER:
               if(param1.currentTarget.icon != null)
               {
                  param1.currentTarget.icon.scaleX = ICON_SCALE_OVER;
                  param1.currentTarget.icon.scaleY = ICON_SCALE_OVER;
               }
               else if(param1.currentTarget.normal != null && param1.currentTarget.normal.icon != null)
               {
                  param1.currentTarget.normal.icon.scaleX = ICON_SCALE_OVER;
                  param1.currentTarget.normal.icon.scaleY = ICON_SCALE_OVER;
               }
               if(param1.currentTarget.border != null)
               {
                  param1.currentTarget.border.alpha = ALPHA_ON;
               }
               else if(param1.currentTarget.normal != null && param1.currentTarget.normal.border != null)
               {
                  param1.currentTarget.normal.border.alpha = ALPHA_ON;
               }
               break;
            case MouseEvent.ROLL_OUT:
               if(param1.currentTarget.icon != null)
               {
                  param1.currentTarget.icon.scaleX = ICON_SCALE_OFF;
                  param1.currentTarget.icon.scaleY = ICON_SCALE_OFF;
               }
               else if(param1.currentTarget.normal != null && param1.currentTarget.normal.icon != null)
               {
                  param1.currentTarget.normal.icon.scaleX = ICON_SCALE_OFF;
                  param1.currentTarget.normal.icon.scaleY = ICON_SCALE_OFF;
               }
               if(param1.currentTarget.border != null)
               {
                  param1.currentTarget.border.alpha = ALPHA_OFF;
               }
               else if(param1.currentTarget.normal != null && param1.currentTarget.normal.border != null)
               {
                  param1.currentTarget.normal.border.alpha = ALPHA_OFF;
               }
         }
      }
      
      private function onReady(param1:Event) : void
      {
         this.btnShare.visible = false;
         this.arrowBack.visible = false;
         this.arrowBack.mouseEnabled = false;
         this.arrowNext.visible = false;
         this.arrowNext.mouseEnabled = false;
         this.arrowUp.visible = false;
         this.arrowUp.mouseEnabled = false;
         this.arrowDown.visible = false;
         this.arrowDown.mouseEnabled = false;
         removeEventListener(Event.ADDED_TO_STAGE,this.onReady);
         this.main();
      }
      
      private function main() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = root.loaderInfo.parameters.secure == "1";
         if(root.loaderInfo.parameters.debug == "1")
         {
            isDebugging = true;
         }
         domainSuffix = root.loaderInfo.parameters.ds == null ? "com" : root.loaderInfo.parameters.ds;
         HTTP = "http" + (!!_loc2_ ? "s" : "") + "://";
         var _loc3_:* = HTTP + "static.pixton." + domainSuffix + "/crossdomain.xml";
         Security.loadPolicyFile(_loc3_);
         this.debug("Load policy file: " + _loc3_);
         this.key = root.loaderInfo.parameters.key == null ? DEFAULT_KEY : root.loaderInfo.parameters.key;
         this.language = root.loaderInfo.parameters.l == null || root.loaderInfo.parameters.l.length != 3 ? "" : root.loaderInfo.parameters.l;
         _loc1_ = root.loaderInfo.parameters.local == null ? DEFAULT_MODE : root.loaderInfo.parameters.local;
         scaleMode = root.loaderInfo.parameters.scale == null ? SCALING_DEFAULT : root.loaderInfo.parameters.scale;
         this.isPreview = root.loaderInfo.parameters.preview == "1";
         platformKey = root.loaderInfo.parameters.platform == null ? DEFAULT_PLATFORM : root.loaderInfo.parameters.platform;
         productKey = root.loaderInfo.parameters.product == null ? DEFAULT_PRODUCT : root.loaderInfo.parameters.product;
         this.embedStyle = root.loaderInfo.parameters.embedStyle == null ? null : root.loaderInfo.parameters.embedStyle;
         if(root.loaderInfo.parameters.v != null)
         {
            version = root.loaderInfo.parameters.v;
         }
         if(this.isSimple())
         {
            this.btnPixton.visible = false;
            this.txtAuthor.visible = false;
         }
         this.updateScalingFactor();
         if(_loc1_ == MODE_LOCAL || Capabilities.playerType == "External")
         {
            mode = MODE_LOCAL;
         }
         else if(_loc1_ == MODE_LOCAL_LIVE)
         {
            mode = MODE_LOCAL_LIVE;
         }
         else
         {
            _loc1_ = "";
            mode = MODE_PIXTON;
         }
         if(platformKey == null)
         {
            platformKey = "";
         }
         if(productKey == null)
         {
            productKey = "";
         }
         server = HTTP + (_loc1_ == "" ? "" : _loc1_ + "-") + (platformKey == "" ? "www" : platformKey) + ".pixton." + domainSuffix + "/" + (productKey == "" ? "" : productKey + "/");
         this.debug("Server: " + server);
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.addEventListener(Event.RESIZE,this.onResize,false,0,true);
         this.btnShare.buttonMode = true;
         this.btnShare.useHandCursor = true;
         this.btnShare.addEventListener(MouseEvent.CLICK,this.onButton,false,0,true);
         this.btnShare.addEventListener(MouseEvent.ROLL_OVER,this.onButton,false,0,true);
         this.btnShare.addEventListener(MouseEvent.ROLL_OUT,this.onButton,false,0,true);
         this.btnPixton.buttonMode = true;
         this.btnPixton.useHandCursor = true;
         this.btnPixton.addEventListener(MouseEvent.CLICK,this.onButton,false,0,true);
         this.btnCredit.buttonMode = true;
         this.btnCredit.useHandCursor = true;
         this.btnCredit.mouseChildren = false;
         this.btnCredit.addEventListener(MouseEvent.CLICK,this.onButton,false,0,true);
         this.btnCreate.buttonMode = true;
         this.btnCreate.useHandCursor = true;
         this.btnCreate.mouseChildren = false;
         this.btnCreate.addEventListener(MouseEvent.CLICK,this.onButton,false,0,true);
         this.btnCreate.addEventListener(MouseEvent.ROLL_OVER,this.onButton,false,0,true);
         this.btnCreate.addEventListener(MouseEvent.ROLL_OUT,this.onButton,false,0,true);
         this.btnSources.buttonMode = true;
         this.btnSources.useHandCursor = true;
         this.btnSources.mouseChildren = false;
         this.btnSources.addEventListener(MouseEvent.CLICK,this.onButton,false,0,true);
         this.btnSources.addEventListener(MouseEvent.ROLL_OVER,this.onButton,false,0,true);
         this.btnSources.addEventListener(MouseEvent.ROLL_OUT,this.onButton,false,0,true);
         this.btnPrint.buttonMode = true;
         this.btnPrint.useHandCursor = true;
         this.btnPrint.mouseChildren = false;
         this.btnPrint.addEventListener(MouseEvent.CLICK,this.onButton,false,0,true);
         this.btnPrint.addEventListener(MouseEvent.ROLL_OVER,this.onButton,false,0,true);
         this.btnPrint.addEventListener(MouseEvent.ROLL_OUT,this.onButton,false,0,true);
         this.btnFullScreen.buttonMode = true;
         this.btnFullScreen.useHandCursor = true;
         this.btnFullScreen.addEventListener(MouseEvent.CLICK,this.toggleFullScreen,false,0,true);
         this.btnFullScreen.addEventListener(MouseEvent.ROLL_OVER,this.onButton,false,0,true);
         this.btnFullScreen.addEventListener(MouseEvent.ROLL_OUT,this.onButton,false,0,true);
         this.btnOpenInPixton.buttonMode = true;
         this.btnOpenInPixton.useHandCursor = true;
         this.btnOpenInPixton.addEventListener(MouseEvent.ROLL_OVER,this.onButton,false,0,true);
         this.btnOpenInPixton.addEventListener(MouseEvent.ROLL_OUT,this.onButton,false,0,true);
         this.btnNormalScreen.buttonMode = true;
         this.btnNormalScreen.useHandCursor = true;
         this.btnNormalScreen.addEventListener(MouseEvent.CLICK,this.toggleFullScreen,false,0,true);
         this.btnNormalScreen.addEventListener(MouseEvent.ROLL_OVER,this.onButton,false,0,true);
         this.btnNormalScreen.addEventListener(MouseEvent.ROLL_OUT,this.onButton,false,0,true);
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
         this.remote("viewComic",{
            "key":this.key,
            "noredirect":true,
            "pr":this.isPreview,
            "sm":scaleMode,
            "w":stage.stageWidth,
            "h":stage.stageHeight
         },this.onLoadComic);
      }
      
      private function isSimple() : Boolean
      {
         return this.embedStyle == STYLE_SIMPLE;
      }
      
      private function getStageWidth() : Number
      {
         return Math.min(stage.stageWidth,COMIC_WIDTH);
      }
      
      private function getStageHeight() : Number
      {
         return stage.stageHeight - (this.btnPixton.height + 2) - (!!isThumb ? 0 : BUTTON_GAP) - this.masker.y;
      }
      
      private function updateScalingFactor() : void
      {
         if(isThumb)
         {
            scaleFactor = Math.min(this.getStageWidth() / this.sceneObjs[0].w,this.getStageHeight() / this.sceneObjs[0].h);
            this.btnPixton.scaleX = Math.max(scaleFactor,0.3);
            this.btnPixton.scaleY = this.btnPixton.scaleX;
         }
         else if(_hasAnimation)
         {
            scaleFactor = 1;
         }
         else if(scaleMode == SCALING_AUTO || stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            scaleFactor = this.getStageWidth() / 900;
         }
         else
         {
            scaleFactor = 1;
         }
      }
      
      private function onFullScreen(param1:FullScreenEvent) : void
      {
         this.resetScrolling();
         if(!param1.fullScreen)
         {
            this.autoFullScreen = false;
         }
      }
      
      private function resetScrolling() : void
      {
         this.container.x = 0;
         this.container.y = 0;
         this.updateArrows();
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this.updateArrows();
         if(this.arrowBack.visible || this.arrowNext.visible || this.arrowDown.visible || this.arrowUp.visible)
         {
            Cursor.show(Cursor.DRAG);
         }
         this.container.addEventListener(MouseEvent.ROLL_OUT,this.onOut,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.startScroll,false,0,true);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.arrowBack.visible = false;
         this.arrowNext.visible = false;
         this.arrowUp.visible = false;
         this.arrowDown.visible = false;
         Cursor.hide();
         this.container.removeEventListener(MouseEvent.ROLL_OUT,this.onOut,false);
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.startScroll,false);
      }
      
      private function onResize(param1:Event = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc5_:MovieClip = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(!ready)
         {
            return;
         }
         var _loc2_:Number = this.getStageWidth();
         this.btnFullScreen.visible = FULLSCREEN_ENABLED && stage.displayState != StageDisplayState.FULL_SCREEN && version > 1 && !isThumb;
         this.btnNormalScreen.visible = FULLSCREEN_ENABLED && !this.btnFullScreen.visible && version > 1 && !isThumb;
         this.updateScalingFactor();
         this.updateLayout();
         this.btnCredit.visible = !isThumb && stage.stageWidth >= MIN_HEIGHT;
         this.btnPrint.visible = _printLink != "" && !isThumb && stage.displayState != StageDisplayState.FULL_SCREEN;
         this.masker.width = this.getStageWidth();
         if(scaleMode == SCALING_AUTO || stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            if(stage.displayState == StageDisplayState.FULL_SCREEN)
            {
               _loc3_ = this.getStageHeight() - FULLSCREEN_PADDING * 2;
            }
            else
            {
               _loc3_ = this.getStageHeight();
            }
            if(this.container.height > 0 && this.container.height < _loc3_)
            {
               _loc3_ = this.container.height;
            }
            this.masker.height = Math.max(Math.round((COMIC_HEIGHT + 2) * scaleFactor),_loc3_);
         }
         else
         {
            _loc3_ = this.getStageHeight();
            if(this.container.height > 0 && this.container.height < _loc3_)
            {
               _loc3_ = this.container.height;
            }
            this.masker.height = Math.round(Math.max(COMIC_HEIGHT + 2,_loc3_) * scaleFactor);
         }
         this.hotspot.width = this.masker.width;
         this.hotspot.height = this.masker.height;
         this.btnShare.y = this.masker.y + (!!isThumb ? this.sceneObjs[0].h * scaleFactor + 2 : this.masker.height + BUTTON_GAP) - 3;
         this.btnCreate.y = this.btnShare.y;
         this.btnSources.y = this.btnShare.y;
         this.btnPrint.y = this.btnShare.y;
         this.btnFullScreen.y = this.btnShare.y - 2;
         this.btnOpenInPixton.y = this.btnShare.y - 2;
         this.btnNormalScreen.y = this.btnShare.y;
         if(isThumb)
         {
            this.btnPixton.y = this.btnShare.y + 5;
         }
         else
         {
            this.btnPixton.y = this.btnShare.y - 2;
         }
         this.btnCredit.y = !!this.isSimple() ? Number(this.btnPixton.y - 4) : Number(this.btnPixton.y);
         this.arrowBack.x = 0;
         this.arrowNext.x = _loc2_;
         this.arrowBack.y = this.arrowNext.y = Math.round(this.masker.y + this.masker.height * 0.5);
         this.btnPixton.x = 0 + 3;
         this.arrowUp.x = Math.round(_loc2_ * 0.5);
         this.arrowUp.y = this.masker.y;
         this.arrowDown.x = this.arrowUp.x;
         this.arrowDown.y = this.masker.y + this.masker.height;
         var _loc4_:Number = _loc2_ - 1 - 3;
         if(this.btnFullScreen.visible || this.btnNormalScreen.visible)
         {
            this.btnFullScreen.x = _loc4_ - this.btnFullScreen.width;
            this.btnNormalScreen.x = _loc4_ - this.btnFullScreen.width;
            _loc4_ = this.btnFullScreen.x - 10;
         }
         if(this.btnPrint.visible)
         {
            this.btnPrint.x = _loc4_ - this.btnPrint.width;
            _loc4_ = this.btnPrint.x - 10;
         }
         if(this.btnShare.visible)
         {
            this.btnShare.x = _loc4_ - this.btnShare.width;
            _loc4_ = this.btnShare.x - 10;
         }
         if(this.btnCreate.visible)
         {
            this.btnCreate.x = _loc4_ - this.btnCreate.width;
            _loc4_ = this.btnCreate.x - 10;
         }
         if(this.btnSources.visible)
         {
            this.btnSources.x = _loc4_ - this.btnSources.width;
            _loc4_ = this.btnSources.x - 10;
         }
         this.btnOpenInPixton.visible = this.btnFullScreen.visible;
         this.author.x = _loc2_ - 2 - 3;
         if(this.author.x + this.txtAuthor.width - this.txtAuthor.textWidth - this.txtTitle.textWidth < TITLE_GAP)
         {
            this.author.x = TITLE_GAP - this.txtAuthor.width + this.txtAuthor.textWidth + this.txtTitle.textWidth;
         }
         if(this.btnPixton.visible)
         {
            this.btnCredit.x = this.btnPixton.x + this.btnPixton.width + 7;
         }
         else
         {
            this.btnCredit.x = 0;
         }
         this.txtAuthor.x = -this.txtAuthor.textWidth;
         if(this.btnOpenInPixton.visible)
         {
            this.btnOpenInPixton.y = this.title.y - 20;
            this.btnOpenInPixton.x = this.title.x + this.txtTitle.textWidth + 3;
         }
         if(isSlideShow)
         {
            _loc5_ = scenes[currentPanel] as MovieClip;
            if(this.tweenX != null)
            {
               this.tweenX.stop();
            }
            if(this.tweenY != null)
            {
               this.tweenY.stop();
            }
            if(this.tweenX2 != null)
            {
               this.tweenX2.stop();
            }
            if(this.tweenY2 != null)
            {
               this.tweenY2.stop();
            }
            _loc6_ = Math.floor(-_loc5_.x + (this.masker.width / scaleFactor - this.sceneObjs[_loc5_.index].w) * 0.5 * scaleFactor);
            _loc7_ = Math.floor(-_loc5_.y + (this.masker.height / scaleFactor - this.sceneObjs[_loc5_.index].h) * 0.5 * scaleFactor);
            if(param1 == null)
            {
               this.container.x = _loc6_;
               this.container.y = _loc7_;
               scenes[currentPanel].alpha = 1;
            }
            else
            {
               this.tweenX = new Tween(this.container,"x",Regular.easeInOut,this.container.x,_loc6_,SLIDE_DURATION,true);
               this.tweenY = new Tween(this.container,"y",Regular.easeInOut,this.container.y,_loc7_,SLIDE_DURATION,true);
               if(this.soundContainer.numChildren > 0)
               {
                  this.tweenX2 = new Tween(this.soundContainer,"x",Regular.easeInOut,this.soundContainer.x,_loc6_,SLIDE_DURATION,true);
                  this.tweenY2 = new Tween(this.soundContainer,"y",Regular.easeInOut,this.soundContainer.y,_loc7_,SLIDE_DURATION,true);
               }
            }
         }
         else
         {
            this.container.x = this.checkContainerX(this.container.x);
            this.container.y = this.checkContainerY(this.container.y);
         }
         this.updateArrows();
         if(stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            this.x = Math.round((stage.stageWidth - COMIC_WIDTH) * 0.5);
            if(this.container.height < this.getStageHeight())
            {
               this.y = Math.round((stage.stageHeight - this.container.height) * 0.5);
            }
            else
            {
               this.y = FULLSCREEN_PADDING;
            }
         }
         else
         {
            this.x = 0;
            this.y = 0;
         }
         this.updateBkgd();
      }
      
      private function startScroll(param1:MouseEvent) : void
      {
         this.startTime = getTimer();
         this.startX = this.container.x;
         this.startY = this.container.y;
         this.startMouseX = stage.mouseX;
         this.startMouseY = stage.mouseY;
         this.container.addEventListener(MouseEvent.MOUSE_MOVE,this.onStep,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll,false,0,true);
      }
      
      private function onStep(param1:Event) : void
      {
         if(Math.abs(stage.mouseX - this.startMouseX) > 2 || Math.abs(stage.mouseY - this.startMouseY) > 2)
         {
            this.scrolling = true;
         }
         if(this.arrowBack.visible || this.arrowNext.visible)
         {
            this.container.x = this.checkContainerX(this.startX + (stage.mouseX - this.startMouseX));
         }
         if(this.arrowUp.visible || this.arrowDown.visible)
         {
            this.container.y = this.checkContainerY(this.startY + (stage.mouseY - this.startMouseY));
         }
         this.updateArrows();
      }
      
      private function stopScroll(param1:MouseEvent) : void
      {
         this.container.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStep,false);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll,false);
         if(this.scrolling)
         {
            this.stopScrollTime = getTimer();
         }
         else
         {
            this.stopScrollTime = 0;
         }
         this.scrolling = false;
      }
      
      private function onTween(param1:TweenEvent) : void
      {
         this.updateArrows();
      }
      
      private function updateArrows() : void
      {
         if(isSlideShow)
         {
            return;
         }
         var _loc1_:Number = Math.round(Math.min(-this.container.width + this.getStageWidth(),0));
         var _loc2_:Number = Math.round(Math.min(-this.container.height + stage.stageHeight,0));
         this.arrowBack.visible = this.container.x < -2 && !isThumb;
         this.arrowNext.visible = this.container.x > _loc1_ + 2 && !isThumb;
         this.arrowUp.visible = this.container.y < 0 && !isThumb;
         this.arrowDown.visible = this.container.y > _loc2_ && !isThumb;
         this.soundContainer.x = this.container.x;
         this.soundContainer.y = this.container.y;
      }
      
      private function checkContainerX(param1:Number) : Number
      {
         var _loc2_:Number = Math.min(-this.container.width + this.getStageWidth(),0);
         if(param1 > 0)
         {
            param1 = 0;
         }
         else if(param1 < _loc2_)
         {
            param1 = _loc2_;
         }
         return Math.round(param1);
      }
      
      private function checkContainerY(param1:Number) : Number
      {
         var _loc2_:Number = Math.min(-this.container.height + this.masker.height,0);
         if(param1 > 0)
         {
            param1 = 0;
         }
         else if(param1 < _loc2_)
         {
            param1 = _loc2_;
         }
         return Math.round(param1);
      }
      
      private function hasBorders() : Boolean
      {
         return _hasBorders;
      }
      
      private function isFreestyle() : Boolean
      {
         return _isFreeStyle;
      }
      
      private function onLoadComic(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:ButtonVO = null;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:TextFormat = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:MovieClip = null;
         this.debug("Comic loaded");
         this.loading.hide();
         if(param1 != null && param1.error != null)
         {
            this.updatePopupPosition();
            this.popup.show(param1.error);
            return;
         }
         try
         {
            isThumb = param1.thumb == 1;
            if(isThumb)
            {
               (_loc12_ = new TextFormat()).size = 11;
               this.txtTitle.defaultTextFormat = _loc12_;
               this.txtTitle.y = -16;
               this.txtAuthor.visible = false;
            }
            this.key = param1.key;
            this.txtTitle.text = param1.title + " ";
            dynamicServer = param1.sdyn;
            if(param1.ss != null)
            {
               isSlideShow = param1.ss;
               slideShowOpacity = param1.sso;
            }
            if(param1.ec != null)
            {
               embedCode = param1.ec;
               this.btnShare.visible = !isThumb && !this.isSimple();
               if(param1.edmodo != null)
               {
                  this.btnShare.normal.visible = false;
                  this.btnShare.edmodo.visible = true;
               }
            }
            if(param1.ic != null)
            {
               imageCredits = param1.ic;
            }
            if(param1.format != null)
            {
               this.format = param1.format;
            }
            if(param1.isFreestyle != null)
            {
               _isFreeStyle = param1.isFreestyle;
            }
            if(param1.hasBorders != null)
            {
               _hasBorders = param1.hasBorders;
            }
            if(param1.hasAnimation != null)
            {
               _hasAnimation = param1.hasAnimation && !isThumb;
            }
            if(param1.titleLink != null)
            {
               this.titleLink = param1.titleLink;
               this.title.buttonMode = true;
               this.title.useHandCursor = true;
               this.title.addEventListener(MouseEvent.CLICK,this.onTitle,false,0,true);
               this.btnOpenInPixton.addEventListener(MouseEvent.CLICK,this.onTitle,false,0,true);
            }
            if(param1.authorLink != null)
            {
               this.authorLink = param1.authorLink;
               this.author.buttonMode = true;
               this.author.useHandCursor = true;
               this.author.addEventListener(MouseEvent.CLICK,this.onAuthor,false,0,true);
            }
            if(param1.title == null)
            {
               this.txtTitle.visible = false;
            }
            if(param1.author == null)
            {
               this.txtAuthor.visible = false;
            }
            else
            {
               this.txtAuthor.text = param1.author;
            }
            if(param1.credit != null)
            {
               if(this.isSimple() && param1.creditSimple)
               {
                  this.txtCredit.text = param1.creditSimple.toUpperCase();
               }
               else
               {
                  this.txtCredit.text = param1.credit.replace("{}","©").replace("&COPY;","©") + " ";
               }
            }
            _createLink = param1.createLink;
            this.txtCreate.text = param1.createText;
            this.txtSources.text = param1.sourcesText;
            this.updateButtonVisibility();
            _printLink = param1.printLink;
            if(param1.vo != null)
            {
               this.voiceovers = param1.vo;
               streamingServer = param1.sstr;
               localBucket = param1.slbt;
            }
            if(isSlideShow || param1.bgc != null)
            {
               if(isSlideShow)
               {
                  bgColor = 0;
               }
               else
               {
                  bgColor = parseInt(param1.bgc.substr(1),16);
               }
               _loc13_ = (bgColor & 16711680) >> 16;
               _loc14_ = (bgColor & 65280) >> 8;
               _loc15_ = bgColor & 255;
               if(_loc13_ + _loc14_ + _loc15_ < 382)
               {
                  this.btnPixton.transform.colorTransform = white;
                  this.btnPrint.transform.colorTransform = white;
                  this.btnShare.transform.colorTransform = white;
                  this.btnFullScreen.transform.colorTransform = white;
                  this.btnOpenInPixton.transform.colorTransform = white;
                  this.btnNormalScreen.transform.colorTransform = white;
                  this.txtTitle.textColor = 16777215;
                  this.txtAuthor.textColor = 16777215;
                  this.txtCredit.textColor = 16777215;
               }
            }
            scenes = [];
            this.sceneObjs = param1.scenes;
            _loc10_ = this.sceneObjs.length;
            _loc2_ = 0;
            while(_loc2_ < _loc10_)
            {
               _loc3_ = new MovieClip();
               _loc4_ = new MovieClip();
               _loc5_ = new MovieClip();
               _loc3_.image = _loc3_.addChild(_loc4_);
               _loc3_.border = _loc5_;
               _loc3_.index = _loc2_;
               _loc3_.addChild(_loc5_);
               this.updateBorder(_loc2_,_loc3_);
               if(isSlideShow)
               {
                  _loc3_.alpha = slideShowOpacity;
               }
               this.container.addChild(_loc3_);
               if(!isThumb && this.voiceovers != null && this.voiceovers[this.sceneObjs[_loc2_].key] != null)
               {
                  _loc6_ = new MovieClip();
                  this.buttonsMap[this.sceneObjs[_loc2_].key] = _loc6_;
                  this.soundContainer.addChild(_loc6_);
                  _loc8_ = this.voiceovers[this.sceneObjs[_loc2_].key] as Array;
                  for each(_loc9_ in _loc8_)
                  {
                     (_loc7_ = new ButtonVO()).soundKey = _loc9_.soundKey;
                     _loc6_.addChild(_loc7_);
                     _loc7_.addEventListener(MouseEvent.CLICK,this.playSound);
                  }
               }
               else if(_hasAnimation && this.sceneObjs[_loc2_].anim == 1)
               {
                  (_loc16_ = new btnPlayAnimation()).alpha = 0;
                  _loc3_.btnPlayAnimation = _loc3_.addChild(_loc16_);
                  _loc3_.addEventListener(MouseEvent.CLICK,this.onPlayAnimation);
               }
               else if(!isSlideShow && !_hasAnimation)
               {
                  _loc3_.addEventListener(MouseEvent.CLICK,this.onButton);
               }
               scenes[_loc2_] = _loc3_;
               _loc3_.src = this.loadScene(_loc2_);
               _loc2_++;
            }
            this.container.buttonMode = true;
            this.container.useHandCursor = true;
            if(isSlideShow)
            {
               this.hotspot.buttonMode = true;
               this.hotspot.useHandCursor = true;
               this.hotspot.addEventListener(MouseEvent.CLICK,this.onSlideClick);
               this.container.addEventListener(MouseEvent.CLICK,this.onSlideClick);
            }
            else
            {
               this.hotspot.visible = false;
               if(isThumb)
               {
                  this.container.addEventListener(MouseEvent.CLICK,this.onTitle);
               }
               else
               {
                  this.container.addEventListener(MouseEvent.ROLL_OVER,this.onOver,false,0,true);
               }
            }
            ready = true;
            this.onResize();
         }
         catch(error:Error)
         {
         }
      }
      
      private function updateLayout() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         var _loc11_:ButtonVO = null;
         var _loc12_:Array = null;
         var _loc13_:Object = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc18_:Number = 0;
         if(isSlideShow)
         {
            _loc2_ = this.sceneObjs.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc18_ = Math.max(_loc18_,this.sceneObjs[_loc1_].h);
               _loc1_++;
            }
         }
         _loc2_ = scenes.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc9_ = scenes[_loc1_] as MovieClip;
            this.updateImage(_loc1_);
            _loc7_ = Math.floor(this.sceneObjs[_loc1_].w * scaleFactor);
            if(!this.isFreestyle())
            {
               if((scaleMode == SCALING_AUTO || stage.displayState == StageDisplayState.FULL_SCREEN || stage.stageHeight > MIN_HEIGHT) && _loc5_ + _loc7_ >= Math.round(COMIC_WIDTH * scaleFactor))
               {
                  _loc5_ = 0;
                  _loc6_ += _loc8_ + PADDING_H * scaleFactor;
               }
            }
            _loc8_ = Math.floor(this.sceneObjs[_loc1_].h * scaleFactor);
            if(_loc9_.btnPlayAnimation != null)
            {
               _loc9_.btnPlayAnimation.x = _loc7_ * 0.5;
               _loc9_.btnPlayAnimation.y = _loc8_ * 0.5;
               _loc9_.btnPlayAnimation.alpha = 1;
               _loc9_.btnPlayAnimation.scaleX = scaleFactor;
               _loc9_.btnPlayAnimation.scaleY = scaleFactor;
               if(this.gif != null && currentScene == _loc9_)
               {
                  this.gif.scaleX = scaleFactor;
                  this.gif.scaleY = scaleFactor;
               }
            }
            _loc9_.x = Math.round(!!this.isFreestyle() ? Number(this.sceneObjs[_loc1_].x * scaleFactor) : Number(_loc5_));
            _loc9_.y = Math.round(!!this.isFreestyle() ? Number(this.sceneObjs[_loc1_].y * scaleFactor) : Number(_loc6_));
            this.updateBorder(_loc1_,_loc9_);
            if(this.voiceovers != null && this.voiceovers[this.sceneObjs[_loc1_].key] != null)
            {
               (_loc10_ = this.buttonsMap[this.sceneObjs[_loc1_].key] as MovieClip).x = _loc9_.x;
               _loc10_.y = _loc9_.y;
               _loc12_ = this.voiceovers[this.sceneObjs[_loc1_].key] as Array;
               _loc3_ = 0;
               for each(_loc13_ in _loc12_)
               {
                  _loc11_ = _loc10_.getChildAt(_loc3_) as ButtonVO;
                  _loc14_ = -(_loc16_ = Math.round(parseInt(_loc13_.w) * 0.5 * scaleFactor));
                  _loc15_ = -(_loc17_ = Math.round(parseInt(_loc13_.h) * 0.5 * scaleFactor));
                  _loc11_.x = Math.round(_loc13_.x * scaleFactor);
                  _loc11_.y = Math.round((_loc13_.y + parseInt(_loc13_.h) * 0.5) * scaleFactor);
                  _loc11_.icon.x = Math.round(_loc16_ - _loc11_.icon.width * 0.5);
                  _loc11_.graphics.clear();
                  _loc11_.graphics.beginFill(16711680,0);
                  _loc11_.graphics.moveTo(_loc14_,_loc15_);
                  _loc11_.graphics.lineTo(_loc16_,_loc15_);
                  _loc11_.graphics.lineTo(_loc16_,_loc17_);
                  _loc11_.graphics.lineTo(_loc14_,_loc17_);
                  _loc11_.graphics.lineTo(_loc14_,_loc15_);
                  _loc11_.graphics.endFill();
                  _loc3_++;
               }
            }
            if(!this.isFreestyle())
            {
               _loc5_ += _loc7_ + PADDING_W * scaleFactor;
            }
            _loc1_++;
         }
      }
      
      private function updateBkgd() : void
      {
         var _loc1_:Graphics = this.container.graphics;
         _loc1_.clear();
         _loc1_.beginFill(bgColor);
         _loc1_.drawRect(0,0,this.container.width,this.container.height);
         _loc1_.endFill();
         if(bkgd == null)
         {
            bkgd = new Sprite();
            addChildAt(bkgd,0);
            bkgd2 = new Sprite();
            addChildAt(bkgd2,0);
         }
         _loc1_ = bkgd.graphics;
         _loc1_.clear();
         _loc1_.beginFill(bgColor);
         _loc1_.drawRect(-BKGD_PADDING,-BKGD_PADDING,this.masker.width + 2 * BKGD_PADDING,this.masker.height + 2 * BKGD_PADDING + 54);
         _loc1_.endFill();
         if(stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            _loc1_ = bkgd2.graphics;
            _loc1_.clear();
            _loc1_.beginFill(0);
            _loc1_.drawRect(-0.5 * (stage.stageWidth - this.masker.width),-0.5 * (stage.stageHeight - this.masker.height) - this.masker.y,stage.stageWidth,stage.stageHeight + this.masker.y + (!!isThumb ? 0 : 42));
            _loc1_.endFill();
         }
      }
      
      private function updateBorder(param1:uint, param2:Object) : void
      {
         if(this.hasBorders())
         {
            return;
         }
         var _loc3_:uint = Math.floor(this.sceneObjs[param1].w * scaleFactor);
         var _loc4_:uint = Math.floor(this.sceneObjs[param1].h * scaleFactor);
         var _loc5_:MovieClip;
         (_loc5_ = param2.border).graphics.clear();
         _loc5_.graphics.lineStyle(1,7829367,1,true);
         _loc5_.graphics.moveTo(0,0);
         _loc5_.graphics.lineTo(_loc3_,0);
         _loc5_.graphics.lineTo(_loc3_,_loc4_);
         _loc5_.graphics.lineTo(0,_loc4_);
         _loc5_.graphics.lineTo(0,0);
      }
      
      private function playSound(param1:MouseEvent) : void
      {
         var _loc4_:Sound = null;
         var _loc2_:ButtonVO = param1.currentTarget as ButtonVO;
         var _loc3_:String = _loc2_.soundKey;
         if(streamingServer.match(/dev\./))
         {
            (_loc4_ = new Sound()).load(new URLRequest(streamingServer + "sound/" + _loc3_ + ".mp3"));
            _loc4_.play();
         }
         else
         {
            _loc2_.url = "mp3:" + localBucket + "sound/" + _loc3_;
            _loc2_.showLoading();
            loadSound(_loc2_);
         }
      }
      
      private function loadScene(param1:uint) : String
      {
         var _loc2_:* = dynamicServer + "comic/" + this.key.substr(0,1) + "/" + this.key.substr(1,1) + "/" + this.key.substr(2,1) + "/" + this.key.substr(3,1) + "/" + this.key + this.sceneObjs[param1].key + ".png";
         this.loadImage(_loc2_,this.onLoadImage,param1);
         return _loc2_;
      }
      
      private function loadImage(param1:String, param2:Function, param3:uint) : Loader
      {
         var url:String = param1;
         var handler:Function = param2;
         var index:uint = param3;
         var loader:Loader = new Loader();
         var context:LoaderContext = new LoaderContext();
         context.checkPolicyFile = true;
         var onComplete:Function = function(param1:Event):void
         {
            handler(param1,index);
         };
         loader.contentLoaderInfo.addEventListener(Event.INIT,onComplete);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onComplete);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onComplete);
         loader.addEventListener(Event.COMPLETE,onComplete);
         loader.load(new URLRequest(url),context);
         return loader;
      }
      
      private function onLoadImage(param1:Event, param2:uint) : void
      {
         var _loc3_:DisplayObject = param1.target.loader.content;
         scenes[param2].imageCache = _loc3_;
         this.updateImage(param2);
         var _loc4_:DisplayObject;
         (_loc4_ = scenes[param2].image).alpha = 0;
         if(this.tweenAlpha == null)
         {
            this.tweenAlpha = [];
         }
         this.tweenAlpha[param2] = new Tween(_loc4_,"alpha",Regular.easeInOut,_loc4_.alpha,1,FADE_DURATION,true);
         this.updateBkgd();
      }
      
      private function updateImage(param1:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc6_:BitmapData = null;
         var _loc7_:Bitmap = null;
         var _loc8_:Matrix = null;
         if(scenes[param1].imageCache == null)
         {
            return;
         }
         var _loc2_:DisplayObject = scenes[param1].imageCache;
         var _loc3_:MovieClip = scenes[param1].image;
         var _loc5_:uint;
         if((_loc5_ = _loc3_.numChildren) > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc3_.removeChildAt(_loc4_);
               _loc4_++;
            }
         }
         if(scaleFactor != 1)
         {
            _loc6_ = new BitmapData(Math.round(_loc2_.width),Math.round(_loc2_.height),true,16777215);
            (_loc7_ = new Bitmap(_loc6_,"auto",true)).scaleX = scaleFactor;
            _loc7_.scaleY = scaleFactor;
            _loc8_ = new Matrix();
            _loc6_.draw(_loc2_,_loc8_,null,null,null,true);
            scenes[param1].image.addChild(_loc7_);
         }
         else
         {
            scenes[param1].image.addChild(_loc2_);
         }
      }
      
      private function remote(param1:String, param2:Object, param3:Function = null) : *
      {
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         if(netConnection == null)
         {
            netConnection = new NetConnection();
            netConnection.objectEncoding = ObjectEncoding.AMF3;
            netConnection.connect(server + this.language + AMF_GATEWAY);
         }
         var _loc4_:Responder = new Responder(param3,this.onRemoteEvent);
         netConnection.call("Editor." + param1,_loc4_,param2);
         if(isDebugging)
         {
            _loc5_ = "";
            if(param2 != null)
            {
               for(_loc6_ in param2)
               {
                  if(String(param2[_loc6_]).length <= 255)
                  {
                     _loc5_ += _loc6_ + "=" + param2[_loc6_] + "&";
                  }
               }
            }
            this.debug("editor/load?method=" + param1 + "&" + _loc5_);
         }
      }
      
      private function onRemoteEvent(param1:*) : void
      {
         visible = true;
      }
      
      private function debug(param1:String) : void
      {
         if(!isDebugging)
         {
            return;
         }
         this.javascript("console.log",param1);
      }
      
      private function javascript(param1:*, param2:* = null) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call(param1,param2);
         }
      }
      
      private function updatePopupPosition() : void
      {
         this.popup.x = Math.round(stage.stageWidth * 0.5 - this.x);
         this.popup.y = Math.round(stage.stageHeight * 0.5 - this.y);
      }
   }
}
