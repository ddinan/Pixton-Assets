package com.pixton.editor
{
   import com.adobe.serialization.json.JSON;
   import com.pixton.animate.Animation;
   import com.pixton.animate.Sequence;
   import com.pixton.designer.Designer;
   import com.pixton.interfaces.IMain;
   import com.pixton.preloader.Status;
   import com.pixton.preloader.StatusMessage;
   import com.pixton.team.Red5;
   import com.pixton.team.Team;
   import com.pixton.team.TeamRole;
   import com.pixton.team.TeamUser;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.system.System;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class Main extends MovieClip implements IMain
   {
      
      public static const DEFAULT_DOMAIN:String = "10.0.1.2";
      
      public static const DEFAULT_SERVER:String = "http://" + DEFAULT_DOMAIN + "/";
      
      private static const DEFAULT_KEY:String = "";
      
      public static const CACHE_AS_BITMAPS:Boolean = true;
      
      private static const DEFAULT_READ_ONLY:Boolean = false;
      
      public static const DEMO_MODE:Boolean = false;
      
      private static const LOCAL_VIEW_ONLY:Boolean = false;
      
      private static const _PIXTON_PLUS:uint = 1;
      
      private static const _PIXTON_ID:uint = 17;
      
      private static const _CHARS_ID:uint = 2445;
      
      private static const _POSES_ID:uint = 5649;
      
      private static const _OUTFITS_ID:uint = 1745207;
      
      private static const _PROPS_ID:uint = 6147059;
      
      private static const _TEMPLATES_ID:uint = 5;
      
      public static const AUTO_HIDE_PADDING:Number = 100;
      
      public static const IO_DIR:String = "editor/";
      
      public static const BUTTON_ALPHA:Number = 0.5;
      
      private static const HI_RES_PRELOAD:Number = 0.5;
      
      private static const HI_RES_PAUSE:Number = 2000;
      
      private static const PREGEN_PAUSE:Number = 50;
      
      private static const EDIT_TYPE_CHARACTER:String = "character";
      
      public static const FORMAT_SUPERLONG:uint = 1;
      
      public static const FORMAT_POSTER:uint = 2;
      
      public static const FORMAT_PIXTURE:uint = 3;
      
      public static const FORMAT_ONE_ROW:uint = 6;
      
      public static const FORMAT_BOOK:uint = 7;
      
      public static const FORMAT_BANNER:uint = 8;
      
      public static const FORMAT_TWO_ROWS:uint = 9;
      
      public static const FORMAT_FREESTYLE:uint = 10;
      
      public static const FORMAT_MOBILE_H:uint = 11;
      
      public static const FORMAT_MOBILE_V:uint = 12;
      
      public static const FORMAT_MOBILE_T:uint = 13;
      
      public static const FORMAT_CONTEST:uint = 14;
      
      public static const FORMAT_4KOMA:uint = 15;
      
      public static const FORMAT_STORYBOARD:uint = 17;
      
      public static const FORMAT_MOBILE:uint = 18;
      
      public static const FORMAT_JOB:uint = 19;
      
      public static const FORMAT_CHAR:uint = 20;
      
      public static const FORMAT_COMIC_STRIP:uint = 21;
      
      public static const FORMAT_TIMELINE:uint = 22;
      
      public static const FORMAT_T_CHART:uint = 23;
      
      public static const FORMAT_GRID:uint = 24;
      
      public static const FORMAT_MIND_MAP:uint = 25;
      
      public static const FORMAT_SLIDESHOW:uint = 26;
      
      public static const FORMAT_PHOTO_ESSAY:uint = 27;
      
      public static const FORMAT_CHAR_MAP:uint = 28;
      
      public static const FORMAT_PLOT_DIAGRAM:uint = 29;
      
      public static const RENDER_DEFAULT:uint = 0;
      
      public static const RENDER_HIRES:uint = 1;
      
      public static const RENDER_PROP:uint = 2;
      
      public static const RENDER_PROP_PARAMS:uint = 3;
      
      public static const RENDER_PROP_IMAGES:uint = 4;
      
      public static const RENDER_PREGEN_TEMPLATES:uint = 5;
      
      public static const RENDER_PREGEN_CHARS:uint = 6;
      
      public static const DEFAULT_FORMAT:uint = FORMAT_SUPERLONG;
      
      public static const DEFAULT_PRODUCT:uint = 1;
      
      public static const DEFAULT_WIDTH:uint = 0;
      
      public static const DEFAULT_HEIGHT:uint = 0;
      
      public static const KEY_CHARACTERS:String = "characters";
      
      public static const KEY_PROP_PREVIEW:String = "prop-preview";
      
      public static const UI_WIDTH:Number = 900;
      
      public static var isLiveDB:Boolean = false;
      
      public static var isCloudFront:Boolean = false;
      
      public static var isMe:Boolean = false;
      
      public static var PLUS_NAME:String = null;
      
      public static var OFFSET_X:Number = 0;
      
      public static var OFFSET_Y:Number = 0;
      
      public static var QUERY_MIN_LENGTH:uint = 3;
      
      public static var isScrolling:Boolean = false;
      
      public static var isPlusTrial:Boolean = false;
      
      private static var _isTempAnon:Boolean = false;
      
      public static var ALLOW_TRANSPARENT_BKGD:Boolean = false;
      
      public static var isPregen:Boolean = false;
      
      public static var displayManager:DisplayManager = new DisplayManager();
      
      private static const DEFAULT_STYLE:String = "";
      
      private static const DEFAULT_LANG:String = "";
      
      private static const DEFAULT_APP:String = "";
      
      private static const BUTTON_PADDING_H:Number = 15;
      
      public static const LIVE_SERVER:String = "http://www.pixton.com/";
      
      public static const DEFAULT_BASE:String = "";
      
      private static const MAX_PROFILE_DURATION:Number = 1;
      
      private static const KEY_LENGTH:uint = 8;
      
      private static const COPY_SCENE:Boolean = true;
      
      private static var READ_ONLY:Boolean = false;
      
      private static var UI_X_OFFSET:uint = 5;
      
      public static var userID:uint = 0;
      
      public static var userVersion:uint = 2;
      
      public static var userName:String;
      
      public static var sessionID:String = null;
      
      public static var self:Main;
      
      public static var widthUI:Number;
      
      public static var enableState:Boolean = true;
      
      public static var controlPressed:Boolean = false;
      
      public static var shiftPressed:Boolean = false;
      
      public static var optionPressed:Boolean = false;
      
      public static var product:uint;
      
      public static var useNode:Boolean = false;
      
      private static var PROP_SCALES:Array = [0.5,1];
      
      private static var alive:Boolean = true;
      
      public static var format:uint;
      
      private static var skippedSnapshot:Boolean = false;
      
      private static var isFBApp:Boolean = false;
      
      private static var isBook:Boolean = false;
      
      private static var actualStageHeight:Number;
      
      private static var detectZoom:Boolean = false;
      
      private static var recentZoomRatio:Number = 1;
      
      private static var checkZoomTimeout:int = -1;
      
      private static var isEmbeddedApp:Boolean = false;
      
      private static var propIDs:Array;
      
      private static var propColorIDs:Array;
      
      private static var currentPropID:int = -1;
      
      private static var onFinishURL:String;
      
      private static var skipPrompts:Boolean = false;
      
      private static var _allowHiRes:Boolean = false;
      
      private static var allowSoundUploading:Boolean = false;
      
      private static var hiResScale:Number = 0;
      
      private static var hiResScaleExtra:Number = 1;
      
      private static var hiResTimeout:uint;
      
      private static var noMoreWarnings:Boolean = false;
      
      private static var visibleWidth:Number;
      
      private static var startMemory:Number;
      
      private static var waitingForUser:uint = 0;
      
      private static var _renderMode:uint = 0;
      
      private static var _showUI:Boolean = true;
      
      private static var _resampleThumbs:Boolean = false;
      
      private static var _savingSnapshot:int = 0;
      
      private static var editType:String;
      
      private static var _canSwitchToFreestyle:Boolean = false;
      
      private static var _hasNewFormats:Boolean = false;
      
      private static var _superUser:Boolean = false;
      
      private static var _allowFullCapture:Boolean = false;
      
      private static var _allowNotes:Boolean = false;
      
      private static var _notesAlwaysVisible:Boolean = false;
      
      private static var _notesHidden:Boolean = false;
      
      private static var _doFullCapture:Boolean = false;
      
      private static var propParamsMC:MovieClip;
      
      private static var _isFunStudent:Boolean = false;
      
      public static var sceneToMove:String;
      
      private static var KEEP_ALIVE:uint = 1000 * 60 * 5;
      
      private static var TIMEOUT_COUNTDOWN:uint = 60;
      
      private static var _isPhotoComic:Boolean = false;
      
      private static var _largeMode:Boolean = false;
      
      private static var _isPlain:Boolean = false;
      
      private static var _dataLoaded:Boolean = false;
      
      private static var _presetsLoaded:Boolean = false;
      
      private static var _loads:Array;
      
      private static var _numLoads:uint = 0;
      
      private static var _numLoaded:uint = 0;
      
      public static var comicRendered:Boolean = false;
      
      public static var windowHeight:Number = 0;
      
      public static var stageVisibleHeight:Number = 600;
      
      public static var stageVisibleWidth:Number = 900;
      
      public static var stageTopY:Number = 0;
      
      static var previewWidth:uint = 0;
      
      static var previewHeight:uint = 0;
      
      static var previewScale:Number = 1;
      
      private static const ADD_SCENE:uint = 0;
      
      private static const INSERT_SCENE:uint = 1;
       
      
      public var comic:Comic;
      
      public var team:Team;
      
      public var editor:Editor;
      
      public var animation:Animation;
      
      public var picker:MovieClip;
      
      public var btnNew:EditorButton;
      
      public var btnInsert:EditorButton;
      
      public var btnMoveUp:EditorButton;
      
      public var help:HelpTab;
      
      public var btnCancel:EditorButton;
      
      public var btnOkay:EditorButton;
      
      public var btnAdmin:EditorButton;
      
      public var maxedMessage:MovieClip;
      
      public var appSettings:AppSettings;
      
      public var popup:Popup;
      
      public var recorder:SoundRecorder;
      
      public var statusMessage:StatusMessage;
      
      private var savingPropSet:PropSet;
      
      private var savingCharacter:Character;
      
      private var savingSequence:Sequence;
      
      private var savingPose:Pose;
      
      private var delaySaveScene:Boolean = false;
      
      private var insertingScene:Boolean = false;
      
      private var delayAddSetting:Boolean = false;
      
      private var delayNewScene:int = -1;
      
      private var delayEditScene:String;
      
      private var sceneToMoveStartIndex:int = -1;
      
      private var savingSceneData:Object;
      
      private var _savingComic:Boolean = false;
      
      private var _wasSavingComic:Boolean = false;
      
      private var okayURL:String = "";
      
      private var cancelURL:String = "";
      
      private var skinLoading:uint;
      
      private var originalKey:String;
      
      private var publishing:Boolean = false;
      
      private var saving:Boolean = false;
      
      private var finishing:Boolean = false;
      
      private var newComic:Boolean = false;
      
      private var sceneGhost:Ghost;
      
      private var loadedData:Object;
      
      private var savingAnimation:Boolean = false;
      
      private var loadBatch:int = 1;
      
      private var _initComplete:Boolean = false;
      
      private var pregenCharacters:Array;
      
      private var pregenOutfits:Array;
      
      private var pregenCharactersAll:Array;
      
      private var pregenOutfitsAll:Array;
      
      private var pregenQueue:Array;
      
      private var pregenQueuePosition:uint;
      
      private var autoRenderScenes:Array;
      
      private var autoRenderScene:uint;
      
      private var currentLibraryFrame:uint = 0;
      
      private var btnCancelVisible:Boolean = false;
      
      private var btnOkayVisible:Boolean = false;
      
      private var btnOkayAlert:String = null;
      
      private var btnAdminVisible:Boolean = false;
      
      public function Main()
      {
         this.loadedData = {};
         super();
         startMemory = System.totalMemory;
         OS.init();
         self = this;
         visible = false;
         this.editor.animation = this.animation;
         if(this.statusMessage != null)
         {
            Status.init(this.statusMessage);
         }
         Status.setMain(this as Sprite);
         if(parent != null)
         {
            Globals.IDE = true;
         }
         if(Globals.IDE)
         {
            Security.allowDomain(DEFAULT_DOMAIN);
            Security.loadPolicyFile(DEFAULT_SERVER + "crossdomain.xml");
            this.init(root.loaderInfo.parameters);
         }
         this.showEditor(false);
      }
      
      private static function getPlayerVersion() : uint
      {
         var _loc1_:String = Capabilities.version;
         var _loc2_:RegExp = /^(\w*) (\d*),(\d*),(\d*),(\d*)$/;
         var _loc3_:Object = _loc2_.exec(_loc1_);
         if(_loc3_ != null)
         {
            return parseInt(_loc3_[2]);
         }
         return 0;
      }
      
      private static function getSWFName() : String
      {
         return self.loaderInfo.url;
      }
      
      public static function onTeamUpdate(param1:String, param2:String, param3:String, param4:Boolean = false) : void
      {
         var valueObj:Object = null;
         var teamVar:String = param1;
         var property:String = param2;
         var encodedValue:String = param3;
         var force:Boolean = param4;
         if(sessionID == null || encodedValue == null)
         {
            return;
         }
         if(encodedValue == null || encodedValue == "")
         {
            return;
         }
         try
         {
            valueObj = com.adobe.serialization.json.JSON.decode(encodedValue);
         }
         catch(e:*)
         {
            if(isSuper())
            {
               Utils.javascript("console.log","Error decoding JSON: " + teamVar + "/" + property + "; " + encodedValue);
            }
            return;
         }
         if(!force && valueObj.s == sessionID)
         {
            return;
         }
         var value:* = valueObj.v;
         var currentPanelKey:String = self.comic.getPanelKey();
         switch(teamVar)
         {
            case Team.P_COMIC:
               self.team.setTitleData(value as Object);
               break;
            case Team.P_PANEL_LIST:
               Team.onPanelList(value as Array);
               break;
            case Team.P_PANEL_LOCK:
               Comic.updateLock(property,value);
               break;
            case Team.P_PANEL_V:
               self.comic.updateVersion(property,uint(value));
               break;
            case Team.P_PANEL_INDEX:
               self.comic.updateIndex(property,uint(value));
               if(displayManager.GET(self.editor,DisplayManager.P_VIS))
               {
                  self.repositionEditor();
               }
               break;
            case Team.P_PANEL_XY:
               self.comic.updatePosition2(property,value);
               if(displayManager.GET(self.editor,DisplayManager.P_VIS))
               {
                  self.repositionEditor();
               }
               break;
            case Team.P_PANEL_SIZES:
               self.comic.updatePanelSizes(value);
               if(displayManager.GET(self.editor,DisplayManager.P_VIS))
               {
                  self.repositionEditor();
               }
               break;
            case Team.P_PANEL_SAVED:
               if(property == currentPanelKey)
               {
                  if(value != null && value.saved != null)
                  {
                     self.editor.setSaved(value.saved,true,false);
                  }
               }
               break;
            case Team.P_PANEL_STATE:
               if(value != Team.NO_DATA)
               {
                  if(value == Panel.STATE_DELETED)
                  {
                     if(property == currentPanelKey)
                     {
                        self.closeEditor();
                        self.updateStage();
                     }
                     self.comic.deleteScene(self.comic.getIndex(property,true));
                  }
                  else if(currentPanelKey != null && property == currentPanelKey && displayManager.GET(self.editor,DisplayManager.P_VIS))
                  {
                     self.editor.updateData(value);
                  }
                  else
                  {
                     self.comic.updatePanelState(property,value);
                  }
               }
               break;
            case Team.P_CHARACTER_LIST:
               Team.require(property,null,Team.P_CHARACTER);
               break;
            case Team.P_PROPSET_LIST:
               Team.require(property,null,Team.P_PROPSET);
               break;
            case Team.P_PHOTO_LIST:
               Team.require(property,null,Team.P_PHOTO);
               break;
            case Team.P_CHARACTER:
               Character.onTeamUpdate(int(property),value);
               if(value != null)
               {
                  self.editor.updateAllCharacters(int(property),value);
               }
               break;
            case Team.P_PROPSET:
               PropSet.onTeamUpdate(int(property),value);
               break;
            case Team.P_PHOTO:
               PropPhoto.onTeamUpdate(int(property),value);
         }
      }
      
      static function handleError(param1:Object, param2:Boolean = false) : Boolean
      {
         if(param1 != null && param1.error != null)
         {
            if(param1.error !== true)
            {
               if(param1.redirect != null)
               {
                  Status.reset();
                  Utils.javascript("Pixton.login.popup");
               }
               else if(param2)
               {
                  Utils.alert(param1.error);
               }
               else
               {
                  Status.setMessage(param1.error,true);
               }
            }
            self.savingAnimation = false;
            return false;
         }
         return true;
      }
      
      static function reloadTeamUsers(param1:uint, param2:Boolean) : void
      {
         if(param1 != TeamUser.num || param2)
         {
            self.loadTeamUsers();
         }
      }
      
      static function setVars(param1:Object) : void
      {
         SoundRecorder.hasSpeechToText = param1.stt == 1;
      }
      
      private static function onSizeChanged() : void
      {
         Comic.self.dirtyMargins();
         Comic.self.drawMargins();
      }
      
      private static function onResized() : void
      {
         if(!detectZoom)
         {
            return;
         }
         if(checkZoomTimeout > -1)
         {
            clearTimeout(checkZoomTimeout);
            checkZoomTimeout = -1;
         }
         checkZoomTimeout = setTimeout(checkZoom,1000);
      }
      
      public static function loadRandomPhrases(param1:Function) : void
      {
         var onComplete:Function = param1;
         Status.setMessage(L.text("please-wait"));
         Utils.remote("loadPhrases",{"langID":L.indexID},function(param1:Object):void
         {
            Status.reset();
            if(param1 != null && param1.phrases != null && param1.phrases.length > 0)
            {
               Dialog.randomPhrases = param1.phrases;
               onComplete();
            }
         });
      }
      
      public static function gotoURL(param1:String) : void
      {
         if(isBusiness())
         {
            navigateToURL(new URLRequest(param1),"_blank");
         }
         else
         {
            Utils.javascript("Pixton.redirect.openURL",param1);
         }
      }
      
      public static function isInitComplete() : Boolean
      {
         return self._initComplete;
      }
      
      private static function onRenderError(param1:String, param2:Boolean = false) : void
      {
         Utils.javascript("PixtonPro.onError",param1,param2);
      }
      
      static function loadNewScene(param1:String) : void
      {
         self.reloadScenes(param1);
      }
      
      public static function saveAnimation() : void
      {
         Animation.rewind();
         self.savingAnimation = true;
         self.saveScene();
      }
      
      static function getLiveDBPath() : String
      {
         return !!isLiveDB ? LIVE_SERVER : "";
      }
      
      public static function capture() : void
      {
         Utils.capture(self as Sprite,-40,26,320,410);
      }
      
      public static function hasPreview() : Boolean
      {
         return previewWidth > 0 && previewHeight > 0;
      }
      
      public static function isCharEdit() : Boolean
      {
         return Comic.key == KEY_CHARACTERS;
      }
      
      public static function isCharCreate() : Boolean
      {
         return editType == EDIT_TYPE_CHARACTER;
      }
      
      public static function isPropPreview() : Boolean
      {
         return Comic.key == KEY_PROP_PREVIEW;
      }
      
      public static function isAdmin() : Boolean
      {
         return userID == _PIXTON_ID || userID == 1;
      }
      
      public static function isPixton() : Boolean
      {
         return userID == _PIXTON_ID;
      }
      
      public static function isCharacters() : Boolean
      {
         return userID == _CHARS_ID;
      }
      
      public static function isOutfitsAdmin() : Boolean
      {
         return userID == _OUTFITS_ID;
      }
      
      public static function isPropsAdmin() : Boolean
      {
         return userID == _PROPS_ID;
      }
      
      public static function isTemplatesUser() : Boolean
      {
         return userID == _TEMPLATES_ID;
      }
      
      public static function allowHiRes() : Boolean
      {
         return _allowHiRes;
      }
      
      public static function canUploadSound() : Boolean
      {
         return allowSoundUploading && !isProfile();
      }
      
      public static function canSwitchToFreestyle() : Boolean
      {
         return _canSwitchToFreestyle;
      }
      
      public static function isSavingPoses() : Boolean
      {
         return isPosesUser() && controlPressed && !shiftPressed;
      }
      
      public static function isSavingPosesWeb() : Boolean
      {
         return isPosesUser() && controlPressed && shiftPressed;
      }
      
      public static function isPosesUser() : Boolean
      {
         return userID == _POSES_ID;
      }
      
      public static function isPregenUser() : Boolean
      {
         return Utils.userName == "Pixton Pregen";
      }
      
      public static function showVectors() : Boolean
      {
         return isPosesUser() && (isSavingPoses() || isSavingPosesWeb());
      }
      
      public static function promptUpgrade(param1:int = 0, param2:Boolean = false) : void
      {
         var featureID:int = param1;
         var precludeTrial:Boolean = param2;
         self.enable(false);
         var data:Object = {
            "trial":featureID,
            "precludeTrial":precludeTrial,
            "returnCancel":true
         };
         if(featureID == FeatureTrial.COMMUNITY)
         {
            data["experiment"] = "community";
         }
         else if(featureID == FeatureTrial.POSING)
         {
            data["experiment"] = "posing";
         }
         Confirm.open("Pixton.member.advertise",Utils.mergeObjects(self.comic.getIDData(),data),function(param1:*):*
         {
            self.enable(true);
         });
      }
      
      public static function isFB() : Boolean
      {
         return isFBApp;
      }
      
      public static function isEmbedded() : Boolean
      {
         return isEmbeddedApp;
      }
      
      public static function isAutoRender() : Boolean
      {
         return _renderMode != RENDER_DEFAULT;
      }
      
      public static function isPropRender() : Boolean
      {
         return _renderMode == RENDER_PROP;
      }
      
      public static function isHiResRender() : Boolean
      {
         return _renderMode == RENDER_HIRES;
      }
      
      public static function isPregenRender() : Boolean
      {
         return _renderMode == RENDER_PREGEN_TEMPLATES || _renderMode == RENDER_PREGEN_CHARS;
      }
      
      public static function isPregenRenderChars() : Boolean
      {
         return _renderMode == RENDER_PREGEN_CHARS;
      }
      
      public static function isPropParams() : Boolean
      {
         return _renderMode == RENDER_PROP_PARAMS;
      }
      
      public static function isPropImages() : Boolean
      {
         return _renderMode == RENDER_PROP_IMAGES;
      }
      
      public static function isAutoBatchRender() : Boolean
      {
         return isHiResRender() || isPregenRender();
      }
      
      public static function isReadOnly() : Boolean
      {
         return READ_ONLY || isAutoRender() && !Debug.ACTIVE;
      }
      
      public static function resizeStage() : void
      {
         self.updateStage();
      }
      
      public static function getComicBottomY() : uint
      {
         var _loc1_:uint = 0;
         if(isReadOnly() || isCharCreate() || !displayManager.GET(self.editor,DisplayManager.P_VIS))
         {
            _loc1_ = Comic.getBottomY() + 30;
         }
         else
         {
            _loc1_ = Math.max(Comic.getBottomY(),displayManager.GET(self.editor,DisplayManager.P_Y) + (self.editor.getHeight(false) + MenuItem.SIZE * 2 + self.editor.getHeight(false,true)) * self.editor.scaleY,displayManager.GET(self.editor,DisplayManager.P_Y) + self.editor.heightWithMenu * self.editor.scaleY,Animation.getBottom(),Picker.getBottom()) + 30;
         }
         return Math.max(_loc1_,420);
      }
      
      public static function getLeftX() : int
      {
         return -(self.stage.stageWidth - widthUI) * 0.5 + self.x;
      }
      
      public static function getRightX() : int
      {
         return Math.ceil(widthUI + (self.stage.stageWidth - widthUI) * 0.5);
      }
      
      public static function getVisibleBottomY() : uint
      {
         return Math.min(self.stage.stageHeight - 6,windowHeight + stageTopY - 64);
      }
      
      public static function getBottomY() : uint
      {
         var _loc1_:Number = getComicBottomY();
         var _loc2_:Number = Animation.getBottom();
         if(!isAutoBatchRender() && _loc2_ > _loc1_)
         {
            return Math.round(_loc2_);
         }
         return Math.round(_loc1_);
      }
      
      public static function copyData() : void
      {
         if(AppSettings.isAdvanced && !Globals.isFullVersion())
         {
            return;
         }
         Utils.remote("saveClipboard",{"cb":Utils.encode(self.editor.getData())},null,true);
      }
      
      public static function saveComicMeta(param1:String, param2:*) : void
      {
         var _loc3_:Object = Comic.self.getIDData();
         Utils.remote("saveComicMeta",Utils.mergeObjects(_loc3_,{
            "field":param1,
            "value":param2
         }));
      }
      
      public static function disableExcept(param1:MovieClip) : void
      {
         self.enable(false,param1);
      }
      
      public static function enableAll() : void
      {
         self.enable(true);
      }
      
      public static function saveSequence(param1:Sequence) : void
      {
         self.saveSequence(param1);
      }
      
      public static function savePose(param1:Pose) : void
      {
         self.savePose(param1);
      }
      
      public static function deletePose(param1:Pose) : void
      {
         self.deletePose(param1);
      }
      
      public static function deleteCharacter(param1:uint) : void
      {
         self.deleteCharacter(param1);
      }
      
      public static function isFun() : Boolean
      {
         return !isSchools() && !isBusiness();
      }
      
      public static function isFunStudent() : Boolean
      {
         return _isFunStudent;
      }
      
      public static function isSchools() : Boolean
      {
         return product == 2;
      }
      
      public static function isBusiness() : Boolean
      {
         return product == 3;
      }
      
      private static function isBookCover() : Boolean
      {
         return isBook && format == FORMAT_BOOK;
      }
      
      public static function isMobile(param1:Boolean = false) : Boolean
      {
         if(param1)
         {
            return Utils.inArray(format,[FORMAT_MOBILE_H,FORMAT_MOBILE_V,FORMAT_MOBILE_T]);
         }
         return Utils.inArray(format,[FORMAT_MOBILE_H,FORMAT_MOBILE_V]);
      }
      
      public static function hasNewFormats() : Boolean
      {
         return _hasNewFormats;
      }
      
      public static function isProfile() : Boolean
      {
         return Utils.inArray(format,[FORMAT_PIXTURE,FORMAT_BANNER]) && !isBusiness() && !isEmbedded();
      }
      
      public static function isPoster() : Boolean
      {
         return format == FORMAT_POSTER;
      }
      
      public static function isStoryboard() : Boolean
      {
         return format == FORMAT_STORYBOARD;
      }
      
      public static function isComicStrip() : Boolean
      {
         return format == FORMAT_COMIC_STRIP;
      }
      
      public static function isTimeline() : Boolean
      {
         return format == FORMAT_TIMELINE;
      }
      
      public static function isTChart() : Boolean
      {
         return format == FORMAT_T_CHART;
      }
      
      public static function isGrid() : Boolean
      {
         return format == FORMAT_GRID;
      }
      
      public static function isMindMap() : Boolean
      {
         return format == FORMAT_MIND_MAP;
      }
      
      public static function isSlideshow() : Boolean
      {
         return format == FORMAT_SLIDESHOW;
      }
      
      public static function isPhotoEssay() : Boolean
      {
         return format == FORMAT_PHOTO_ESSAY;
      }
      
      public static function isCharMap() : Boolean
      {
         return format == FORMAT_CHAR_MAP;
      }
      
      public static function isPlotDiagram() : Boolean
      {
         return format == FORMAT_PLOT_DIAGRAM;
      }
      
      public static function canChangeRowHeight() : Boolean
      {
         return format == FORMAT_SUPERLONG || format == FORMAT_ONE_ROW || format == FORMAT_TWO_ROWS;
      }
      
      public static function isPixture() : Boolean
      {
         return format == FORMAT_PIXTURE;
      }
      
      public static function isPhotoComic() : Boolean
      {
         return _isPhotoComic;
      }
      
      public static function isLarge() : Boolean
      {
         return Utils.inArray(format,[FORMAT_POSTER]);
      }
      
      public static function isSingle() : Boolean
      {
         return Utils.inArray(format,[FORMAT_POSTER,FORMAT_BOOK,FORMAT_CONTEST]);
      }
      
      public static function isDefault() : Boolean
      {
         return format == FORMAT_SUPERLONG;
      }
      
      public static function isSuper() : Boolean
      {
         return _superUser;
      }
      
      public static function warn(param1:String, param2:Boolean = false) : void
      {
         if(isAutoRender() && !noMoreWarnings)
         {
            onRenderError(param1,true);
            if(param2)
            {
               noMoreWarnings = true;
            }
         }
      }
      
      private static function onPixton(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest("http://www.pixton.com/");
         navigateToURL(_loc2_,"_blank");
      }
      
      public static function repositionInWindow(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Boolean) : void
      {
         if(isAutoRender())
         {
            return;
         }
         stageTopY = param2 + param1 - param3;
         stageVisibleWidth = param4;
         stageVisibleHeight = !!param7 ? Number(param5) : Number(param6);
         Main.windowHeight = param5;
         Comic.reposition(!!param7 ? Number(stageTopY) : Number(0),stageVisibleHeight,param6);
         Status.reposition(stageTopY,param5,param6);
         Popup.reposition(stageTopY,param5,param6);
         SoundRecorder.reposition(stageTopY,param5,param6);
         self.y = -(!!param7 ? stageTopY : 0);
         if(!isCharCreate())
         {
            self.autoHideNonVisibleElements();
         }
      }
      
      static function repositionComic(param1:Number) : void
      {
         self.comic.x = Math.round((UI_WIDTH - self.editor.getWidth()) * 0.5) + OFFSET_X;
         self.comic.y = Math.round((param1 - self.editor.getHeight(false) * self.editor.scaleY) * 0.5) + OFFSET_Y;
         self.updateEditorPosition();
      }
      
      private static function getPanelPosition() : Object
      {
         return {
            "top":Editor.self.y,
            "left":Editor.self.x - getLeftX()
         };
      }
      
      private static function dispatchMouseUp(param1:Event = null) : void
      {
         self.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true,false));
      }
      
      private static function onChangeAppSetting(param1:PixtonEvent) : void
      {
         var evt:PixtonEvent = param1;
         switch(evt.value)
         {
            case AppSettings.NUMBERS:
               Comic.self.updateNumbers();
               break;
            case AppSettings.MODE:
               if(!AppSettings.isAdvanced)
               {
                  Editor.self.resetMode();
               }
               else
               {
                  AppSettings.setActive(evt.value,false);
                  promptUpgrade(FeatureTrial.ADVANCED_MODE);
               }
               Team.update();
               break;
            case AppSettings.BASIC:
               if(!AppSettings.allowNonBasic)
               {
                  AppSettings.setActive(evt.value,true);
                  promptUpgrade(FeatureTrial.ADVANCED_MODE);
               }
               else if(!AppSettings.allowNonBeginner)
               {
                  Utils.alert(L.text("beginner-only",L.text("editor-basic")));
               }
               else
               {
                  Confirm.open("Pixton.comic.confirm",L.text("goto-advanced"),function(param1:Boolean):*
                  {
                     if(param1)
                     {
                        gotoAdvanced();
                     }
                  });
               }
               break;
            case AppSettings.ZOOM:
               Editor.self.refreshMenu();
               if(!AppSettings.getActive(AppSettings.ZOOM) && !AppSettings.getActive(AppSettings.ZOOM_DEF) && isLargeMode())
               {
                  setLargeMode(false);
               }
               break;
            case AppSettings.ZOOM_DEF:
               setLargeMode(AppSettings.getActive(AppSettings.ZOOM_DEF));
               break;
            case AppSettings.MORE:
               if(Globals.isFullVersion() || !isFun() || !AppSettings.getActive(evt.value))
               {
                  Editor.self.refreshMenu();
               }
               else
               {
                  AppSettings.setActive(evt.value,false,true);
                  promptUpgrade(FeatureTrial.ADVANCED_MODE);
               }
               break;
            case AppSettings.ANIMATION:
               if(Animation.isAvailable())
               {
                  if(Animation.isApplicableFormat)
                  {
                     Animation.updateVisibility();
                     self.updateStage();
                  }
                  else
                  {
                     AppSettings.setActive(evt.value,false,true);
                     Utils.alert(L.text("animation-format"));
                  }
               }
               else
               {
                  AppSettings.setActive(evt.value,false,true);
                  promptUpgrade(FeatureTrial.ANIMATION);
               }
               break;
            case AppSettings.PAGES:
               self.comic.drawMargins();
         }
      }
      
      public static function showEditor(param1:Boolean = true) : void
      {
         self.showEditor(param1);
      }
      
      static function setLargeMode(param1:Boolean) : void
      {
         if(isPoster() || param1 == _largeMode)
         {
            return;
         }
         _largeMode = param1;
         self.updateScrim();
      }
      
      private static function getLargeScale() : Number
      {
         var _loc7_:Number = NaN;
         var _loc1_:Number = getRightX() - getLeftX() - 100;
         var _loc2_:Number = stageVisibleHeight - 50;
         var _loc3_:Number = _loc1_ / _loc2_;
         var _loc4_:Number = self.editor.getWidth() + Editor.WIDTH_CONTROLS * 2;
         var _loc5_:Number = self.editor.getHeight() + Editor.HEIGHT_CONTROLS * 2;
         var _loc6_:Number = _loc4_ / _loc5_;
         if(_loc3_ > _loc6_)
         {
            _loc7_ = _loc2_ / _loc5_;
         }
         else
         {
            _loc7_ = _loc1_ / _loc4_;
         }
         return Number(Utils.limit(_loc7_,1.4,2));
      }
      
      static function isLargeMode() : Boolean
      {
         return _largeMode;
      }
      
      private static function gotoAdvanced() : void
      {
         Status.setMessage(L.text("please-wait"));
         Utils.remote("disableTemplate",Utils.mergeObjects(self.getStyleData(),self.comic.getIDData()),function(param1:Object):void
         {
            Status.reset();
            if(param1 && param1.responseComplete && !param1.error)
            {
               self.saveComic(null,null,true);
            }
         });
      }
      
      static function convertComic() : void
      {
         format = Comic.FORMAT_FREESTYLE;
         Comic.setLayout(Comic.LAYOUT_FREESTYLE);
         Border.setAllowed(true);
         var _loc1_:String = self.editor.customBorder.getData();
         var _loc2_:Array = self.comic.setFreeStyle(_loc1_);
         self.editor.customBorder.thickness = 1;
         self.saveComic(null,_loc2_,true);
      }
      
      private static function onConvertComic(param1:Object) : void
      {
         self.saveChanges("reload");
      }
      
      private static function checkZoom() : void
      {
         recentZoomRatio = self.stage.stageHeight / actualStageHeight;
      }
      
      private static function getPropLayers(param1:MovieClip, param2:String = "") : Array
      {
         var _loc4_:DisplayObject = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc3_:uint = param1.numChildren;
         var _loc5_:Array = [];
         var _loc6_:uint = 0;
         while(_loc6_ < _loc3_)
         {
            if((_loc4_ = param1.getChildAt(_loc6_)) is MovieClip)
            {
               if(_loc4_.name == "icon")
               {
                  _loc5_.push("i");
               }
               else if(_loc4_.name == "alphable")
               {
                  _loc5_.push("a");
               }
               else if(_loc4_.name == "masker")
               {
                  _loc5_.push("m");
               }
               else if(_loc4_.name == "handle")
               {
                  _loc5_.push("h");
               }
               else if(_loc4_.name == "inner")
               {
                  _loc5_.push("n");
               }
               else
               {
                  _loc7_ = {};
                  if(_loc4_.name == "fill" || _loc4_.name == "fill1")
                  {
                     _loc7_.n = 1;
                  }
                  else if(_loc4_.name == "fill2")
                  {
                     _loc7_.n = 2;
                  }
                  else if(_loc4_.name == "fill3")
                  {
                     _loc7_.n = 3;
                  }
                  else if(_loc4_.name == "fill4")
                  {
                     _loc7_.n = 4;
                  }
                  else if(_loc4_.name == "fill5")
                  {
                     _loc7_.n = 5;
                  }
                  else if(_loc4_.name == "line" || _loc4_.name == "line1")
                  {
                     _loc7_.n = -1;
                  }
                  else if(_loc4_.name == "line2")
                  {
                     _loc7_.n = -2;
                  }
                  else if(_loc4_.name == "line3")
                  {
                     _loc7_.n = -3;
                  }
                  else if(_loc4_.name == "line4")
                  {
                     _loc7_.n = -4;
                  }
                  else if(_loc4_.name == "line5")
                  {
                     _loc7_.n = -5;
                  }
                  if((_loc8_ = getPropLayers(_loc4_ as MovieClip,param2 + "-")) && _loc8_.length)
                  {
                     _loc7_.l = _loc8_;
                     _loc5_.push(_loc7_);
                  }
                  else if(_loc7_.n)
                  {
                     _loc5_.push(_loc7_.n);
                  }
                  else
                  {
                     _loc5_.push(0);
                  }
               }
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public static function promptFreestyle() : void
      {
         Confirm.open("Pixton.comic.confirm",L.text("convert-freestyle"),function(param1:Boolean):*
         {
            if(param1)
            {
               convertComic();
            }
         });
      }
      
      public static function allowFullCapture() : Boolean
      {
         return _allowFullCapture;
      }
      
      public static function allowNotes() : Boolean
      {
         return _allowNotes && !isCharCreate();
      }
      
      public static function notesAlwaysVisible() : Boolean
      {
         return _notesAlwaysVisible && !isCharCreate();
      }
      
      public static function setNotesAlwaysVisible(param1:Boolean) : void
      {
         _notesAlwaysVisible = param1;
      }
      
      public static function notesHidden() : Boolean
      {
         return _notesHidden;
      }
      
      public static function doFullCapture() : Boolean
      {
         return _doFullCapture;
      }
      
      public function init(param1:Object) : void
      {
         if(ExternalInterface.available)
         {
            try
            {
               ExternalInterface.addCallback("reposition",repositionInWindow);
               ExternalInterface.addCallback("getPanelPosition",getPanelPosition);
               ExternalInterface.addCallback("onConfirm",Confirm.onClose);
               ExternalInterface.addCallback("saveChanges",this.saveChanges);
               ExternalInterface.addCallback("onSelectPhoto",WebPhoto.onSelect);
               ExternalInterface.addCallback("applyFormat",this.onApplyFormat);
               ExternalInterface.addCallback("toggleSettings",this.appSettings.toggleShown);
               ExternalInterface.addCallback("reloadTeamUsers",reloadTeamUsers);
               ExternalInterface.addCallback("setVars",setVars);
               ExternalInterface.addCallback("onResized",onResized);
               ExternalInterface.addCallback("onSizeChanged",onSizeChanged);
               ExternalInterface.addCallback("onButton",this.onButtonJS);
               ExternalInterface.addCallback("onKeypad",this.onKeypad);
               ExternalInterface.addCallback("onClickOutside",this.onClickOutside);
               ExternalInterface.addCallback("onSoundConverted",this.recorder.onConverted);
               ExternalInterface.addCallback("onSoundError",this.recorder.onError);
               ExternalInterface.addCallback("onSOConnection",Red5.onConnected);
               ExternalInterface.addCallback("onSOConnectionError",Red5.onConnectionError);
               ExternalInterface.addCallback("onSOSync",Red5.onSyncJS);
               ExternalInterface.addCallback("getTarget",Guide.getTarget);
            }
            catch(error:SecurityError)
            {
            }
            catch(error:Error)
            {
            }
         }
         Cursor.init(stage);
         stage.scaleMode = StageScaleMode.NO_SCALE;
         READ_ONLY = !!Globals.IDE ? Boolean(DEFAULT_READ_ONLY) : param1.readOnly == 1;
         Utils.server = !!Globals.IDE ? DEFAULT_SERVER + DEFAULT_APP + DEFAULT_LANG : param1.server;
         Utils.base = !!Globals.IDE ? DEFAULT_BASE : (param1.base == null ? "" : param1.base);
         Style.init(!!Globals.IDE ? DEFAULT_STYLE : (param1.style == null ? "" : param1.style));
         isFBApp = param1.width != null;
         L.multiLangID = !!Globals.IDE ? uint(0) : uint(param1.cl);
         isBook = param1.book == 1;
         useNode = param1.useNode == 1;
         Template.init(param1);
         if(param1.render == "hi-res")
         {
            _renderMode = RENDER_HIRES;
         }
         else if(param1.render == "prop-params")
         {
            _renderMode = RENDER_PROP_PARAMS;
         }
         else if(param1.render == "prop-images")
         {
            _renderMode = RENDER_PROP_IMAGES;
         }
         else if(param1.render == "pregen-templates")
         {
            _renderMode = RENDER_PREGEN_TEMPLATES;
         }
         else if(param1.render == "pregen-chars")
         {
            _renderMode = RENDER_PREGEN_CHARS;
         }
         else
         {
            _renderMode = RENDER_DEFAULT;
         }
         Debug.trace("_renderMode: " + _renderMode);
         if(param1.isPlain != null)
         {
            _isPlain = true;
         }
         Prop.preloadAll = Prop.PRELOAD || isPropParams() || isPropImages();
         if(param1.debug == 1)
         {
            Debug.ACTIVE = true;
         }
         actualStageHeight = param1.height;
         detectZoom = param1.detectZoom == 1 && _renderMode == RENDER_DEFAULT;
         onResized();
         if(param1.editType != null)
         {
            editType = param1.editType;
         }
         if(READ_ONLY)
         {
            Utils.rearrange(this.editor);
         }
         var _loc2_:String = param1.props == null ? null : param1.props;
         if(_loc2_ != null)
         {
            propIDs = _loc2_.split("|");
            propColorIDs = param1.propColors.split("|");
            _renderMode = RENDER_PROP;
         }
         if(isAutoRender() && !Debug.ACTIVE)
         {
            _showUI = false;
         }
         if(param1.visibleWidth != null)
         {
            visibleWidth = param1.visibleWidth;
         }
         if(param1.propID != null)
         {
            Prop.previewID = param1.propID;
         }
         widthUI = param1.width == null ? Number(UI_WIDTH) : Number(param1.width);
         Comic.initY = this.comic.y;
         this.comic.x += OFFSET_X;
         this.comic.y += OFFSET_Y;
         displayManager.SET(this.team,DisplayManager.P_X,displayManager.GET(this.team,DisplayManager.P_X) + OFFSET_X);
         displayManager.SET(this.team,DisplayManager.P_Y,displayManager.GET(this.team,DisplayManager.P_Y) + OFFSET_Y);
         displayManager.SET(this.appSettings,DisplayManager.P_X,displayManager.GET(this.appSettings,DisplayManager.P_X) + OFFSET_X);
         displayManager.SET(this.appSettings,DisplayManager.P_Y,displayManager.GET(this.appSettings,DisplayManager.P_Y) + OFFSET_Y);
         if(isReadOnly() || isCharCreate())
         {
            this.comic.x = OFFSET_X;
            this.comic.y = OFFSET_Y;
            this.editor.mouseEnabled = false;
            this.editor.mouseChildren = false;
            if(isAutoRender() && !Debug.ACTIVE)
            {
               this.editor.alpha = 0;
               this.comic.visible = false;
               Status.makeOneTime();
               this.comic.mouseEnabled = false;
               this.comic.mouseChildren = false;
            }
            else if(isCharCreate())
            {
               this.comic.visible = false;
            }
         }
         if(isFB() || isAutoRender())
         {
            stage.align = StageAlign.TOP_LEFT;
         }
         else
         {
            stage.align = StageAlign.TOP;
         }
         if(param1.offset != null)
         {
            x = param1.offset;
         }
         Selector.init();
         Comic.init(this.comic);
         Team.init(this.team);
         if(param1.editKey != null)
         {
            this.comic.setEditKey(param1.editKey);
         }
         Editor.init(this.editor);
         Picker.init(this.picker);
         Help.init(this.help);
         Popup.init(this.popup,this.comic);
         SoundRecorder.init(this.recorder,this.comic);
         stage.showDefaultContextMenu = true;
         Status.setNoUI(!_showUI && isReadOnly());
         if(isFB())
         {
            Status.setX(Math.round(widthUI * 0.5) + x - 1);
         }
         Status.setComic(this.comic as Object);
         Utils.addListener(this.team,PixtonEvent.CHANGE_COMIC,this.saveComic);
         Utils.addListener(this.comic,PixtonEvent.EDIT_SCENE,this.editScene);
         Utils.addListener(this.comic,PixtonEvent.PRESS_SCENE,this.onPressScene);
         Utils.addListener(this.editor,PixtonEvent.SAVE_SCENE,this.saveScene);
         Utils.addListener(this.editor,PixtonEvent.DOWNLOAD_SCENE,this.downloadScene);
         Utils.addListener(this.editor,PixtonEvent.CLOSE_SCENE,this.closeScene);
         Utils.addListener(this.editor,PixtonEvent.DELETE_SCENE,this.deleteScene);
         Utils.addListener(this.editor,PixtonEvent.RESIZE_SCENE,this.onResizeScene);
         Utils.addListener(this.editor,PixtonEvent.SAVE_CHARACTER,this.saveCharacter);
         Utils.addListener(this.editor,PixtonEvent.SAVE_PROPSET,this.savePropSet);
         Utils.addListener(this.editor,PixtonEvent.SAVE_STATE,this.updateSaveState);
         Utils.addListener(this.editor,PixtonEvent.COMPLETE,this.onSceneLoaded);
         Utils.addListener(this.appSettings,PixtonEvent.CHANGE,onChangeAppSetting);
         if(!isReadOnly())
         {
            Utils.addListener(stage,KeyboardEvent.KEY_DOWN,this.onDownKey);
            Utils.addListener(stage,KeyboardEvent.KEY_UP,this.onUpKey);
         }
         Utils.addListener(stage,Event.MOUSE_LEAVE,dispatchMouseUp);
         if(this.maxedMessage != null)
         {
            displayManager.SET(this.maxedMessage,DisplayManager.P_VIS,false);
         }
         displayManager.SET(this.btnNew,DisplayManager.P_VIS,false);
         displayManager.SET(this.btnInsert,DisplayManager.P_VIS,false);
         displayManager.SET(this.btnMoveUp,DisplayManager.P_VIS,false);
         this.btnNew.makePriority();
         this.btnInsert.makePriority();
         this.btnMoveUp.makePriority();
         this.btnCancelVisible = false;
         this.btnOkayVisible = false;
         this.btnAdminVisible = false;
         this.updateButton("cancel",{"visible":false});
         this.updateButton("okay",{"visible":false});
         displayManager.SET(this.btnAdmin,DisplayManager.P_VIS,false);
         if(isCharCreate())
         {
            this.updateButton("cancel",{"alpha":0});
            this.updateButton("okay",{"alpha":0});
         }
         Utils.addListener(this.btnNew,MouseEvent.ROLL_OVER,this.showHelp);
         Utils.addListener(this.btnNew,MouseEvent.ROLL_OUT,this.hideHelp);
         Utils.addListener(this.btnInsert,MouseEvent.ROLL_OVER,this.showHelp);
         Utils.addListener(this.btnMoveUp,MouseEvent.ROLL_OVER,this.showHelp);
         Utils.addListener(this.btnInsert,MouseEvent.ROLL_OUT,this.hideHelp);
         Utils.addListener(this.btnMoveUp,MouseEvent.ROLL_OUT,this.hideHelp);
         this.btnNew.setHandler(this.newScene,false);
         this.btnInsert.setHandler(this.newScene,false);
         this.btnMoveUp.setHandler(this.moveUpScene,false);
         this.btnCancel.setHandler(this.onButton);
         this.btnOkay.setHandler(this.onButton);
         Comic.key = !!Globals.IDE ? DEFAULT_KEY : (param1.key == null ? "" : param1.key);
         Utils.userName = param1.uname == null ? (!!READ_ONLY ? "Reader" : "IDE") : param1.uname;
         this.newComic = Comic.isNew();
         var _loc3_:uint = !!Globals.IDE ? uint(DEFAULT_FORMAT) : uint(param1.create);
         var _loc4_:uint = !!Globals.IDE ? uint(DEFAULT_WIDTH) : uint(param1.cw);
         var _loc5_:uint = !!Globals.IDE ? uint(DEFAULT_HEIGHT) : uint(param1.ch);
         product = !!Globals.IDE ? uint(DEFAULT_PRODUCT) : uint(param1.product);
         this.originalKey = Comic.key;
         format = _loc3_;
         if(isProfile())
         {
            this.editor.fixSize();
         }
         this.loadData({
            "cw":_loc4_,
            "ch":_loc5_
         });
         this.loadPresets();
      }
      
      private function loadPresets() : void
      {
         if(Comic.key != "")
         {
            Utils.sendAndLoad(Utils.server + "editor/presets",this.onLoadPresets,false);
         }
         else
         {
            this.onLoadPresets();
         }
      }
      
      private function onLoadPresets(param1:String = null) : void
      {
         if(param1 != null)
         {
            this.loadedData = Utils.mergeObjects(this.loadedData,com.adobe.serialization.json.JSON.decode(param1) as Object);
         }
         _presetsLoaded = true;
         this.checkLoadData();
      }
      
      private function loadData(param1:Object = null) : void
      {
         Status.setProgressRange(10,80 * (!!isAutoBatchRender() ? HI_RES_PRELOAD : 1),true);
         Utils.remote("loadData",Utils.mergeObjects({
            "fpv":getPlayerVersion(),
            "fn":getSWFName(),
            "batch":-1,
            "readOnly":(!!isReadOnly() ? 1 : 0),
            "f":format,
            "renderMode":_renderMode
         },param1,this.getStyleData(),this.comic.getIDData()),this.onLoadData,true);
      }
      
      private function onLoadTeamRoles() : void
      {
         if(displayManager.GET(this.editor,DisplayManager.P_VIS))
         {
            this.editor.refreshMenu();
         }
      }
      
      private function onLoadData(param1:Object = null) : void
      {
         if(!handleError(param1))
         {
            return;
         }
         if(param1.debug != null)
         {
            Debug.ACTIVE = true;
         }
         this.loadedData = Utils.mergeObjects(this.loadedData,param1);
         _dataLoaded = true;
         this.checkLoadData();
      }
      
      private function checkLoadData() : void
      {
         var _loc1_:Array = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(!_presetsLoaded || !_dataLoaded)
         {
            return;
         }
         visible = true;
         PLUS_NAME = this.loadedData.plus;
         isLiveDB = !!this.loadedData.ldb;
         isCloudFront = !!this.loadedData.csf;
         Dialog.RANDOM_PHRASES = !!this.loadedData.rdp;
         QUERY_MIN_LENGTH = parseInt(this.loadedData.query_min);
         _isFunStudent = this.loadedData.fs == 1;
         L.id = this.loadedData.lsp;
         L.indexID = this.loadedData.lid;
         L.showKeypad = !!this.loadedData.kpd;
         _superUser = !!this.loadedData.su;
         _allowFullCapture = this.loadedData.capture_all == 1;
         _allowNotes = this.loadedData.notes == 1;
         _notesAlwaysVisible = this.loadedData.notes_vis == 1;
         _notesHidden = this.loadedData.notes_hidden == 1;
         File.LOCAL_BUCKET = this.loadedData.slbt;
         Utils.staticServer = this.loadedData.ssta;
         Utils.staticServerBase = this.loadedData.ssta2;
         Utils.dynamicServer = this.loadedData.sdyn;
         Utils.assetServer = this.loadedData.sass;
         Utils.streamingServer = this.loadedData.sstr;
         Utils.recordingServer = this.loadedData.srec;
         Utils.masterServer = this.loadedData.srec2;
         SpellCheck.isAvailable = this.loadedData.spelling == 1;
         VideoRecorder.isAllowed = this.loadedData.characterPhoto == 1;
         ActivityLog.enabled = this.loadedData.act == 1;
         ActivityLog.interval = this.loadedData.acti;
         if(this.loadedData.pregen == 1)
         {
            isPregen = true;
         }
         isPlusTrial = this.loadedData.plusTrial == 1;
         _isTempAnon = this.loadedData.tempAnon == 1;
         Training.setActive(this.loadedData.ta == 1);
         if(!Globals.IDE)
         {
            Security.loadPolicyFile(Utils.staticServerBase + "crossdomain.xml");
         }
         Character.setEditor(this.loadedData.est);
         Animation.init(this.loadedData);
         Printing.init(this.loadedData);
         EditorConfig.init(this.loadedData);
         Keyword.init(this.loadedData);
         Presets.init(this.loadedData);
         Pixton.THUMBNAIL = this.loadedData.thumbScale;
         if(this.loadedData.previewWidth != null && this.loadedData.previewHeight != null)
         {
            previewWidth = this.loadedData.previewWidth;
            previewHeight = this.loadedData.previewHeight;
            if(this.loadedData.previewScale != null)
            {
               previewScale = this.loadedData.previewScale;
            }
         }
         if(this.loadedData.photoComic != null)
         {
            _isPhotoComic = true;
         }
         if(this.loadedData.defZoom1 != null)
         {
            Editor.DEFAULT_SCALE_1 = this.loadedData.defZoom1;
         }
         if(this.loadedData.defZoom2 != null)
         {
            Editor.DEFAULT_SCALE_2 = this.loadedData.defZoom2;
         }
         if(this.loadedData.tbc != null)
         {
            ALLOW_TRANSPARENT_BKGD = this.loadedData.tbc;
         }
         KEEP_ALIVE = this.loadedData.toa * 1000;
         TIMEOUT_COUNTDOWN = this.loadedData.toc;
         isEmbeddedApp = this.loadedData.embedded;
         SoundRecorder.MAX_DURATION = parseInt(this.loadedData.rmd);
         SoundRecorder.SHOW_INSTRUCTIONS = this.loadedData.rwa;
         PhotoDrawing.ENABLED = this.loadedData.dre == 1;
         PhotoDrawing.FIXED = this.loadedData.drf == 1;
         userID = this.loadedData.uid;
         userVersion = this.loadedData.uv;
         sessionID = this.loadedData.sess;
         isMe = this.loadedData.isme;
         userName = this.loadedData.uname;
         Team.isVisible = this.loadedData.team_v && !isAutoRender();
         Team.isAllowed = this.loadedData.team_a && !isAutoRender();
         Team.DEBUGGING = this.loadedData.team_d == 1;
         _allowHiRes = this.loadedData.hra;
         _resampleThumbs = this.loadedData.thr;
         Utils.bitmapMax = this.loadedData.bmmax;
         Utils.bitmapTotal = this.loadedData.bmtotal;
         PropSet.COMMUNITY_VISIBLE = this.loadedData.pcv;
         PropSet.COMMUNITY_LABEL = this.loadedData.pcl;
         Character.COMMUNITY_VISIBLE = this.loadedData.ccv;
         Globals.setFullVersion(this.loadedData.tier >= _PIXTON_PLUS || isCharCreate());
         Globals.setAdmin(isAdmin());
         allowSoundUploading = this.loadedData.sua;
         Border.setAllowed(this.loadedData.ffa);
         Border.locked = this.loadedData.ffl || isPropPreview();
         _hasNewFormats = this.loadedData.ncs;
         _canSwitchToFreestyle = this.loadedData.fsf && !isPropPreview();
         Comic.showMargins = this.loadedData.scm;
         if(this.loadedData.hrv != null)
         {
            hiResScale = this.loadedData.hrv;
            if(isBookCover())
            {
               hiResScaleExtra = 900 / 435;
            }
         }
         if(isPregenRender())
         {
            hiResScale = 1;
            hiResScaleExtra = 1;
         }
         this.editor.init();
         FileUpload.init(this.loadedData);
         FeatureTrial.setData(this.loadedData);
         PhotoSet.setData(this.loadedData);
         Picker.initButtons();
         if(!isPropRender())
         {
            format = this.loadedData.format;
            this.okayURL = this.loadedData.okay;
            this.cancelURL = this.loadedData.cancel;
            L.init(this.loadedData.tb);
            SkinManager.init(this.loadedData);
            Dialog.init(this.loadedData);
            Filter.init(this.loadedData);
            Style.load(this.loadedData.si);
            Platform.load(this.loadedData.pi);
            Character.init(this.loadedData);
            PropSet.init(this.loadedData);
            PropPhoto.init(this.loadedData);
            SoundRecorder.initText();
            Pose.init();
            PixtonMenu.setMenu(this);
         }
         Prop.version = this.loadedData.prv;
         Prop.basePath = this.loadedData.fsr;
         if(this.loadedData.fp != null)
         {
            if(this.loadedData.pprev != null)
            {
               _loc1_ = this.loadedData.fp as Array;
               _loc1_.unshift(this.loadedData.pprev);
               this.loadedData.fp = _loc1_;
            }
            Prop.init(this.loadedData.fp);
         }
         if(isPropRender())
         {
            if(this.loadedData.fp.length < 1)
            {
               onRenderError("render-no-pack");
            }
            else
            {
               this.loadProps();
            }
         }
         else if(!isReadOnly())
         {
            if(this.loadedData.c_hot != null && this.loadedData.c_link != null && this.loadedData.c_bkgd != null && this.loadedData.c_text != null)
            {
               Palette.load(this.loadedData);
               this.btnNew.updateColor();
               this.btnInsert.updateColor();
               this.btnMoveUp.updateColor();
               this.btnCancel.updateColor();
               this.btnOkay.updateColor();
               Popup.updateColor();
               AppSettings.updateColor();
               Picker.updateColor();
               this.help.updateColor();
               this.editor.updateUIColor();
               this.team.updateColor();
               this.comic.updateColor();
               if(this.maxedMessage)
               {
                  this.maxedMessage.txtValue.textColor = Palette.colorText;
               }
            }
            if(this.loadedData.okayText != null)
            {
               this.btnOkay.label = this.loadedData.okayText;
            }
            if(this.loadedData.cancelText != null)
            {
               this.btnCancel.label = this.loadedData.cancelText;
            }
            else
            {
               this.btnCancel.label = "";
            }
            this.updateButton("cancel",{"label":this.btnCancel.label});
            this.updateButton("okay",{"label":this.btnOkay.label});
            if(isNaN(visibleWidth))
            {
               visibleWidth = this.loadedData.maxWidth;
            }
            displayManager.SET(this.appSettings,DisplayManager.P_X,widthUI + UI_X_OFFSET + (widthUI - visibleWidth) + OFFSET_X);
            displayManager.SET(this.appSettings,DisplayManager.P_Y,(!!Team.isVisible ? 4 : 18) + OFFSET_Y);
         }
         this.appSettings.setData(this.loadedData);
         if(AppSettings.getActive(AppSettings.ZOOM_DEF))
         {
            setLargeMode(true);
         }
         if(!isCharEdit())
         {
            this.comic.loadData(this.loadedData);
            this.team.loadData(this.loadedData);
         }
         if(this.maxedMessage != null)
         {
            this.maxedMessage.txtValue.text = L.text("maxed",Comic.maxRows);
         }
         Fonts.init(this.loadedData);
         if(isReadOnly() && this.loadedData.scenes != null)
         {
            _loc3_ = this.loadedData.scenes.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.comic.setCacheByIndex(this.loadedData.scenes[_loc2_],_loc2_);
               _loc2_++;
            }
         }
         if(Team.isVisible)
         {
            Red5.comicKey = Comic.key;
            Red5.sharingServer = this.loadedData.ssha;
         }
         if(this.loadedData.designer != null)
         {
            Designer.getInstance().setData(this.loadedData);
         }
         if(!isPropRender())
         {
            this.loadAll();
         }
         this.onStageSizeChanged();
      }
      
      private function loadTeamUsers() : void
      {
         if(!Team.isAllowed)
         {
            return;
         }
         Utils.remote("loadTeamUsers",{"key":Comic.key},this.onLoadTeamUsers);
      }
      
      private function onLoadTeamUsers(param1:Object) : void
      {
         var _loc2_:* = !handleError(param1);
         if(!this._initComplete)
         {
            return;
         }
         if(param1.userMap != null)
         {
            TeamUser.map = param1.userMap;
            TeamUser.num = param1.n;
            if(param1.hideTeam != null)
            {
               Team.isVisible = false;
               Team.isAllowed = false;
               Team.isActive = false;
               TeamUser.num = 1;
               Team.update();
            }
            if(param1.roles != null)
            {
               TeamRole.setData(param1);
            }
            TeamRole.approved = param1.approved == true;
         }
         if(!_loc2_ && TeamUser.num > 1)
         {
            Team.initSharing();
         }
      }
      
      function updateUserAssets(param1:Object, param2:Boolean = true) : void
      {
         if(isPropRender())
         {
            return;
         }
         PropSet.setData(param1,param2);
         PropPhoto.setData(param1,param2);
         Character.setData(param1,param2);
      }
      
      private function loadAll() : void
      {
         if(isAutoBatchRender())
         {
            Status.setProgressRange(80 * HI_RES_PRELOAD,100 * HI_RES_PRELOAD,true);
         }
         else
         {
            Status.setProgressRange(80,100,true);
         }
         _loads = [];
         _numLoaded = 0;
         this.addLoad("loadSkins");
         if(!isCharCreate())
         {
            this.addLoad("loadProps");
         }
         if(!isCharCreate() && !isPropParams() && !isPropImages() && !isPropRender())
         {
            this.addLoad("startLoadFonts");
         }
         this.doLoadAll();
      }
      
      private function addLoad(param1:String) : void
      {
         _loads.push(param1);
         _numLoads = _loads.length;
      }
      
      private function doLoadAll() : void
      {
         var _loc1_:uint = _loads.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            this[_loads[_loc2_]]();
            _loc2_++;
         }
      }
      
      private function checkLoad() : void
      {
         ++_numLoaded;
         if(_numLoaded == _numLoads)
         {
            _numLoads = 0;
            _numLoaded = 0;
            this.onInitComplete();
         }
      }
      
      private function loadSkins() : void
      {
         Utils.load(Character.getFile(this.skinLoading),this.onLoadSkins,true,File.BUCKET_ASSET);
      }
      
      private function onLoadSkins(param1:Event = null) : void
      {
         if(param1 != null && isCharacters())
         {
            Character.skinMCs.push(param1.currentTarget.content as MovieClip);
         }
         Character.addSkin();
         ++this.skinLoading;
         if(this.skinLoading < Character.getNumSkins())
         {
            this.loadSkins();
         }
         else
         {
            this.checkLoad();
         }
      }
      
      private function loadProps(param1:Event = null) : void
      {
         var _loc2_:String = null;
         if((isPropParams() || isPropImages()) && param1 != null)
         {
            propParamsMC = param1.currentTarget.content as MovieClip;
         }
         if(isCharEdit())
         {
            this.onLoadProps();
         }
         else
         {
            if(isPropPreview() && param1 != null)
            {
               Prop.detectNew(param1);
            }
            if(Prop.preloadAll)
            {
               _loc2_ = Prop.getNextFile();
               if(_loc2_ != null)
               {
                  Utils.load(_loc2_,this.loadProps,true,File.BUCKET_ASSET);
               }
               else
               {
                  this.onLoadProps();
               }
            }
            else if(Prop.USE_IMAGES)
            {
               Prop.loadMeta();
            }
            else
            {
               this.onLoadProps();
            }
         }
      }
      
      public function onLoadProps() : void
      {
         if(!isCharEdit())
         {
            Prop.setData(this.loadedData);
         }
         this.checkLoad();
      }
      
      private function startLoadFonts() : void
      {
         Fonts.loadInit(this.loadedData.preFonts,this.onLoadFonts);
      }
      
      private function onLoadFonts() : void
      {
         this.checkLoad();
      }
      
      public function loadPropSets(param1:Array, param2:Function = null) : void
      {
         var IDs:Array = param1;
         var closure:Function = param2;
         Utils.remote("loadPropsDyn",{
            "id":IDs,
            "type":Prop.PROP_SET
         },function(param1:Object):void
         {
            onLoadPropSets(param1);
            if(closure != null)
            {
               closure();
            }
         },true);
      }
      
      private function onLoadPropSets(param1:Object) : void
      {
         if(!handleError(param1))
         {
            return;
         }
         PropSet.setData(param1,false);
      }
      
      function reloadPropPhotos(param1:uint, param2:Function) : void
      {
         Utils.remote("reloadPropPhotos",Utils.mergeObjects({"photo":param1},this.comic.getIDData(),this.getStyleData()),this.onReloadPropPhotos,true,param2);
      }
      
      private function onReloadPropPhotos(param1:Object) : void
      {
         if(!handleError(param1))
         {
            param1.onComplete(false);
            return;
         }
         PropPhoto.setData(param1);
         param1.onComplete(true);
         if(Team.isActive && param1.photo != null)
         {
            PropPhoto.sendTeamUpdate(param1.photo,PropPhoto.getData(param1.photo));
         }
      }
      
      private function loadHiResScenes() : void
      {
         Utils.remote("loadHiResScenes",Utils.mergeObjects(this.comic.getIDData(),this.getStyleData(),{"scale":hiResScale}),this.onLoadHiResScenes,true);
      }
      
      private function loadPregenScenes() : void
      {
         Utils.remote("loadPregenScenes",Utils.mergeObjects(this.comic.getIDData(),this.getStyleData(),{
            "renderMode":_renderMode,
            "scale":hiResScale
         }),this.onLoadHiResScenes,true);
      }
      
      private function onLoadHiResScenes(param1:Object) : void
      {
         if(!handleError(param1))
         {
            return;
         }
         this.autoRenderScenes = param1.scenes;
         this.autoRenderScene = 0;
         if(isPregenRender())
         {
            this.pregenCharacters = Utils.arrayToInts(param1.characters);
            this.pregenOutfits = Utils.arrayToInts(param1.outfits);
            this.pregenCharactersAll = Utils.arrayToInts(param1.characters_all);
            this.pregenOutfitsAll = Utils.arrayToInts(param1.outfits_all);
         }
         this.autoRenderNextScene();
      }
      
      private function autoRenderNextScene() : void
      {
         var _loc1_:* = 100 * (1 - HI_RES_PRELOAD) / this.autoRenderScenes.length;
         var _loc2_:Number = 100 * HI_RES_PRELOAD + this.autoRenderScene * _loc1_;
         var _loc3_:Number = 100 * HI_RES_PRELOAD + (this.autoRenderScene + 1) * _loc1_;
         Status.setProgressRange(_loc2_,_loc3_,true);
         if(this.autoRenderScene < this.autoRenderScenes.length)
         {
            this.editScene({"value":this.autoRenderScenes[this.autoRenderScene++]});
         }
         else
         {
            Utils.javascript("onComicRendered");
         }
      }
      
      private function saveHiRes(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         if(hiResScale == 0)
         {
            return;
         }
         if(param1)
         {
            setTimeout(this.saveHiRes,HI_RES_PAUSE);
         }
         else if(Editor.self.getHeight() == 0)
         {
            this.onSaveHiRes();
         }
         else
         {
            _loc2_ = Utils.limitScale(hiResScale * hiResScaleExtra,this.editor.bkgd);
            Editor.self.customBorder.visible = true;
            _loc3_ = 0;
            if(isPregenRender())
            {
               this.pregenQueue = [];
               this.pregenQueuePosition = 0;
               if((_loc4_ = Editor.self.getNumChars()) == 0)
               {
                  this.pregenQueue.push({
                     "charIDs":[],
                     "outfitIDs":[]
                  });
               }
               else
               {
                  for each(_loc5_ in this.pregenCharactersAll)
                  {
                     if(Utils.inArray(_loc5_,this.pregenCharacters))
                     {
                        if(isPregenRenderChars())
                        {
                           _loc6_ = Editor.self.getCharIDs()[0];
                           this.pregenQueue.push({
                              "charIDs":[_loc5_],
                              "outfitIDs":[_loc6_]
                           });
                        }
                        else
                        {
                           for each(_loc6_ in this.pregenOutfitsAll)
                           {
                              if(Utils.inArray(_loc6_,this.pregenOutfits))
                              {
                                 if(_loc4_ == 1)
                                 {
                                    this.pregenQueue.push({
                                       "charIDs":[_loc5_],
                                       "outfitIDs":[_loc6_]
                                    });
                                 }
                                 else
                                 {
                                    for each(_loc7_ in this.pregenCharactersAll)
                                    {
                                       if(Utils.inArray(_loc7_,this.pregenCharacters))
                                       {
                                          if(_loc5_ != _loc7_)
                                          {
                                             for each(_loc8_ in this.pregenOutfitsAll)
                                             {
                                                if(Utils.inArray(_loc8_,this.pregenOutfits))
                                                {
                                                   this.pregenQueue.push({
                                                      "charIDs":[_loc5_,_loc7_],
                                                      "outfitIDs":[_loc6_,_loc8_]
                                                   });
                                                }
                                             }
                                          }
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
               this.nextInPregenQueue();
            }
            else
            {
               this.comic.storeImage(this.editor,_loc2_);
               Utils.remote("saveSnapshot",Utils.mergeObjects({
                  "f":format,
                  "scaleOriginal":hiResScale,
                  "readOnly":(!!isReadOnly() ? 1 : 0)
               },this.getStyleData(),this.comic.getIDData(),this.comic.getStoredImage(_loc2_)),this.onSaveHiRes);
               this.comic.clearImage(_loc2_);
            }
         }
      }
      
      private function nextInPregenQueue() : void
      {
         var _loc1_:Object = null;
         if(this.pregenQueuePosition >= this.pregenQueue.length)
         {
            this.onSaveHiRes();
         }
         else
         {
            _loc1_ = this.pregenQueue[this.pregenQueuePosition++];
            this.pregenScene(_loc1_.charIDs,_loc1_.outfitIDs);
         }
      }
      
      private function pregenScene(param1:Array, param2:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = param1.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = param1[_loc5_];
            _loc4_ = param2[_loc5_];
            Debug.trace("Set char " + _loc5_ + " to " + _loc3_ + " with outfit " + _loc4_);
            Editor.self.setCharacterByNum(_loc5_,_loc3_,_loc4_);
            _loc5_++;
         }
         Editor.self.redraw(true);
         setTimeout(this.pregenSceneSave,PREGEN_PAUSE,param1,param2);
      }
      
      private function pregenSceneSave(param1:Array, param2:Array) : void
      {
         var scale:Number = NaN;
         var charIDs:Array = param1;
         var outfitIDs:Array = param2;
         scale = hiResScale;
         this.comic.storeImage(this.editor,scale);
         Utils.remote("savePregen",Utils.mergeObjects({
            "renderMode":_renderMode,
            "charIDs":charIDs,
            "outfitIDs":outfitIDs,
            "readOnly":(!!isReadOnly() ? 1 : 0)
         },this.getStyleData(),this.comic.getIDData(),this.comic.getStoredImage(scale)),function():void
         {
            comic.clearImage(scale);
            nextInPregenQueue();
         });
      }
      
      private function onSaveHiRes(param1:Object = null) : void
      {
         if(isAutoBatchRender())
         {
            this.autoRenderNextScene();
         }
         else
         {
            Status.reset();
            if(!param1 || param1.error != null)
            {
               handleError(param1,true);
               return;
            }
            navigateToURL(new URLRequest(param1.url),"_blank");
         }
      }
      
      private function onInitComplete() : void
      {
         this._initComplete = true;
         if(!isAutoRender())
         {
            Animation.setPreferences(this.loadedData.prefs);
         }
         this.skinLoading = 0;
         this.updateUserAssets(this.loadedData);
         Sequence.setData(this.loadedData);
         Pose.setData(this.loadedData);
         Palette.init(this.loadedData.pal);
         if(Team.isVisible)
         {
            this.loadTeamUsers();
         }
         this.loadedData = null;
         if(isPropImages())
         {
            this.savePropParams(propParamsMC,true);
            Status.reset();
         }
         else if(isPropParams())
         {
            this.savePropParams(propParamsMC);
            Status.reset();
         }
         else if(isPropRender())
         {
            this.onComicRendered();
         }
         else if(isCharEdit() || isPropPreview())
         {
            this.onComicRendered();
         }
         else
         {
            this.loadScenes();
         }
      }
      
      private function loadScenes() : void
      {
         Status.reset();
         Utils.addListener(stage,PixtonEvent.LOAD_COMIC,this.onComicRendered);
         this.team.load();
         this.comic.load();
      }
      
      private function getDefaultPanelKey() : String
      {
         var _loc1_:Panel = null;
         if(!Template.isActive() || this.comic.numScenes() == 0)
         {
            return null;
         }
         if(isMindMap())
         {
            _loc1_ = this.comic.getPanelAt(1);
         }
         else
         {
            _loc1_ = this.comic.getPanelAt(0);
         }
         if(_loc1_.isNew)
         {
            return _loc1_.key;
         }
         return null;
      }
      
      private function onComicRendered(param1:Object = null) : void
      {
         if(comicRendered)
         {
            return;
         }
         comicRendered = true;
         this.updateStage();
         if(isHiResRender())
         {
            this.loadHiResScenes();
         }
         else if(isPregenRender())
         {
            this.loadPregenScenes();
         }
         else if(AppState.exists())
         {
            if(!AppState.getPanelKey())
            {
               this.comic.index = this.comic.numScenes();
            }
            this.editScene({"value":AppState.getPanelKey()});
         }
         else if(this.isComicStart() && TeamRole.can(TeamRole.PANELS))
         {
            this.editScene(this.getDefaultPanelKey());
         }
         else if(isCharCreate())
         {
            this.comic.index = 0;
            this.editScene({"value":this.comic.getPanelKey()});
         }
         this.appSettings.onReady(!Utils.SCREEN_CAPTURE_MODE && !isAutoRender() && !DEMO_MODE && !READ_ONLY);
         this.comic.drawMargins();
         Utils.javascript("Pixton.comic.onEditorReady");
         ActivityLog.getInstance().init(stage);
      }
      
      private function captureNextProp() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         ++currentPropID;
         this.editor.clearAll();
         var _loc1_:Prop = this.editor.addProp(propIDs[currentPropID]);
         if(_loc1_ == null)
         {
            onRenderError("pro-prop-null");
         }
         else
         {
            _loc1_.drawSnapshot(Pixton.THUMBNAIL_PROP);
            this.comic.setStoredImage(Pixton.THUMBNAIL_PROP,_loc1_.imageData);
            _loc3_ = PROP_SCALES.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc1_.drawSnapshot(PROP_SCALES[_loc2_]);
               this.comic.setStoredImage(PROP_SCALES[_loc2_],_loc1_.imageData);
               _loc2_++;
            }
            this.saveImages();
         }
      }
      
      public function savePosition(param1:String, param2:Number, param3:Number) : void
      {
         if(Comic.isLockedPanels())
         {
            return;
         }
         Utils.remote("saveScenePosition",Utils.mergeObjects(this.comic.getIDData(),this.getStyleData(),{
            "scene":param1,
            "x":param2,
            "y":param3
         }));
      }
      
      public function savePanelOrder(param1:Array) : void
      {
         var keys:Array = param1;
         Utils.remote("saveSceneOrder",Utils.mergeObjects(this.comic.getIDData(),this.getStyleData(),{"keys":keys}),function(param1:Object):void
         {
            onSavePanelOrder(keys);
         });
      }
      
      private function onSavePanelOrder(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(Team.isActive)
         {
            _loc3_ = param1.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               Team.onChange(Comic.key,param1[_loc2_],Team.P_PANEL_INDEX,null,_loc2_);
               _loc2_++;
            }
         }
      }
      
      private function showNextScene(param1:PixtonEvent = null) : void
      {
         if(this.comic.index + 1 < this.comic.numScenes())
         {
            this.editScene({"value":this.comic.index + 1});
         }
         else
         {
            this.closeScene();
            if(isAutoBatchRender())
            {
               this.finalizeAnimation();
            }
         }
      }
      
      private function saveComic(param1:PixtonEvent = null, param2:Array = null, param3:Boolean = false) : void
      {
         if(isReadOnly())
         {
            return;
         }
         stage.focus = null;
         if(Comic.isNew() || this.finishing || param2 != null)
         {
            Status.setMessage(L.text("please-wait"));
         }
         var _loc4_:Object = Utils.mergeObjects({"f":format},this.getStyleData(),this.comic.getIDData(),this.team.getTitleData());
         if(param2 != null)
         {
            _loc4_["scenes"] = param2;
         }
         if(isCharCreate())
         {
            Character(this.editor.getCharacter()).setName(_loc4_.title);
         }
         this._savingComic = !param3;
         Utils.remote("saveComic",_loc4_,!!param3 ? onConvertComic : this.onSaveComic);
      }
      
      private function reloadScenes(param1:String) : void
      {
         Utils.remote("loadScenes",Utils.mergeObjects({
            "newKey":param1,
            "f":format
         },this.getStyleData(),this.comic.getIDData()),this.onReloadScenes);
      }
      
      private function onReloadScenes(param1:Object) : void
      {
         this.comic.addNewScenes(param1);
      }
      
      private function onTimeout() : void
      {
         Utils.javascript("Pixton.comic.onTimeout");
      }
      
      private function onSaveComic(param1:Object) : void
      {
         handleError(param1);
         Animation.setPrefsChanged(false);
         this._savingComic = false;
         if(!(param1 == null || param1.key == null || param1.key.length != KEY_LENGTH))
         {
            Comic.key = param1.key;
            if(Comic.key != this.originalKey)
            {
               Utils.javascript("Pixton.comic.setKey",Comic.key);
            }
            if(param1.title != null)
            {
               this.team.updateTitle(param1.title);
            }
            if(Team.isActive)
            {
               Team.onChange(Comic.key,null,Team.P_COMIC,null,this.team.getTitleData());
            }
            if(this.delaySaveScene)
            {
               this.saveScene();
            }
            else if(!this.savingAnimation)
            {
               if(this._wasSavingComic)
               {
                  this._wasSavingComic = false;
                  this.checkFinish();
               }
            }
         }
      }
      
      private function savePropSet(param1:PixtonEvent) : void
      {
         if(isReadOnly())
         {
            return;
         }
         Status.setMessage(L.text("please-wait"));
         this.savingPropSet = param1.value as PropSet;
         Utils.remote("saveScene",Utils.mergeObjects(this.getStyleData(),this.savingPropSet.getSetData()),this.onSavePropSet);
      }
      
      private function onSavePropSet(param1:Object) : void
      {
         Status.reset();
         if(!handleError(param1))
         {
            this.editor.cancelPropSet(this.savingPropSet);
            return;
         }
         if(this.savingPropSet.id == 0)
         {
            this.savingPropSet.updateID(param1.id);
            this.savingPropSet.updateSceneKey(param1.scene);
            PropSet.add(this.savingPropSet);
         }
         else
         {
            PropSet.update(this.savingPropSet);
         }
         PropSet.updateValue(this.savingPropSet.id,"v",param1.v);
         if(Team.isActive)
         {
            PropSet.sendTeamUpdate(this.savingPropSet.id,Utils.mergeObjects(PropSet.getData(this.savingPropSet.id),{"u":userName}));
            if(displayManager.GET(this.editor,DisplayManager.P_VIS))
            {
               this.editor.onPropSetSaved();
            }
         }
         this.savingPropSet.setSaved();
         Utils.remote("saveSnapshot",Utils.mergeObjects({
            "propset":this.savingPropSet.id,
            "v":PropSet.getValue(this.savingPropSet.id,"v"),
            "f":format
         },this.getStyleData(),this.savingPropSet.imageData));
         this.savingPropSet = null;
         if(this.delaySaveScene)
         {
            this.saveScene();
         }
      }
      
      private function saveCharacter(param1:PixtonEvent) : void
      {
         if(isReadOnly())
         {
            return;
         }
         Status.reset();
         this.savingCharacter = param1.value as Character;
         if(this.savingCharacter.hasID() || !AppSettings.isAdvanced || Template.isActive() || Guide.isActive)
         {
            this.onCharacterName();
         }
         else
         {
            this.savingCharacter.promptForName(this.onCharacterName);
         }
      }
      
      private function onCharacterName() : void
      {
         Status.setMessage(L.text("please-wait"));
         Utils.remote("saveCharacter",Utils.mergeObjects({
            "uf":this.savingCharacter.updateFromID,
            "ck":Comic.key,
            "v":Character.getValue(this.savingCharacter.getID(),"v")
         },this.getStyleData(),this.savingCharacter.getGenome()),this.onSaveCharacter);
      }
      
      private function onSaveCharacter(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(!handleError(param1))
         {
            this.savingCharacter = null;
            return;
         }
         if(!this.savingCharacter.hasID())
         {
            _loc2_ = this.savingCharacter.getID();
            this.savingCharacter.updateID(param1.id);
            Character.add(this.savingCharacter);
            if(Team.isActive)
            {
               Character.stopSharing(_loc2_);
            }
         }
         else
         {
            Character.update(this.savingCharacter);
         }
         Character.saveImage(this.savingCharacter.getID(),param1.v,this.onSaveCharacterImage);
      }
      
      private function onSaveCharacterImage(param1:Object) : void
      {
         this.savingCharacter.setSaved();
         this.savingCharacter = null;
         Status.reset();
         if(this.delaySaveScene)
         {
            this.saveScene();
         }
         else if(Team.isActive)
         {
            this.editor.sendTeamUpdate();
         }
      }
      
      private function onRenderingComplete(param1:PixtonEvent) : void
      {
         Debug.trace("onRenderingComplete");
         Utils.removeListener(this.animation,PixtonEvent.COMPLETE,this.onRenderingComplete);
         if(isAutoBatchRender() || this.savingAnimation)
         {
            this.saveAnimation();
         }
         else if(this.delaySaveScene)
         {
            this.saveScene();
         }
      }
      
      public function saveSequence(param1:Sequence) : void
      {
         if(isAutoBatchRender())
         {
            return;
         }
         Status.setMessage(L.text("please-wait"));
         this.savingSequence = param1;
         Utils.remote("saveSequence",Utils.mergeObjects(this.getStyleData(),this.savingSequence.getData()),this.onSaveSequence);
      }
      
      private function onSaveSequence(param1:Object) : void
      {
         handleError(param1);
         Status.reset();
         this.savingSequence.saved = true;
         if(this.savingSequence.id == 0)
         {
            this.savingSequence.id = param1.id;
            Sequence.addData(this.savingSequence);
         }
         this.savingSequence = null;
      }
      
      public function savePose(param1:Pose) : void
      {
         if(isReadOnly())
         {
            return;
         }
         Status.setMessage(L.text("please-wait"));
         this.savingPose = param1;
         Utils.remote("savePose",Utils.mergeObjects(this.getStyleData(),this.savingPose.getData()),this.onSavePose);
      }
      
      public function deletePose(param1:Pose) : void
      {
         if(isReadOnly())
         {
            return;
         }
         Utils.remote("deletePose",Utils.mergeObjects(this.getStyleData(),param1.getData()));
      }
      
      public function deleteCharacter(param1:uint) : void
      {
         if(isReadOnly())
         {
            return;
         }
         Utils.remote("deleteCharacter",Utils.mergeObjects(this.getStyleData(),{"id":param1}));
         if(Team.isActive)
         {
            Character.sendTeamUpdate(param1,null);
         }
      }
      
      private function onSavePose(param1:Object) : void
      {
         handleError(param1);
         Status.reset();
         this.savingPose.saved = true;
         if(this.savingPose.id == 0)
         {
            this.savingPose.id = param1.id;
            Pose.addData(this.savingPose);
            this.editor.refreshMenu();
         }
         this.savingPose = null;
      }
      
      private function editScene(param1:Object = null) : void
      {
         if(param1 && param1 is String)
         {
            param1 = {"value":param1};
         }
         this.delayEditScene = null;
         var _loc2_:String = param1 == null ? null : param1.value;
         if(!isAutoRender() && displayManager.GET(this.editor,DisplayManager.P_VIS))
         {
            this.editor.setSelection();
            if(!this.editor.getSaved())
            {
               if(this.saveScene())
               {
                  this.delayEditScene = _loc2_;
               }
               return;
            }
            this.closeScene();
         }
         if(this.isBeginnerStart())
         {
            this.delayAddSetting = true;
         }
         this.loadScene(_loc2_);
      }
      
      private function isBeginnerStart() : Boolean
      {
         if(!Template.isActive())
         {
            return false;
         }
         return this.isComicStart();
      }
      
      private function isComicStart() : Boolean
      {
         return this.comic.numScenes() == 0 || this.getDefaultPanelKey() != null;
      }
      
      private function downloadScene(param1:PixtonEvent) : void
      {
         Status.setMessage(L.text("please-wait"));
         hiResTimeout = setTimeout(this.saveHiRes,HI_RES_PAUSE);
      }
      
      function resetSave() : void
      {
         this.delaySaveScene = false;
         this.savingCharacter = null;
         this.delayNewScene = -1;
         this.delayEditScene = null;
      }
      
      private function saveScene(param1:PixtonEvent = null) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Object = null;
         var _loc2_:Boolean = !!param1 ? Boolean(param1.value2) : false;
         if(isReadOnly() || this.savingCharacter != null || !displayManager.GET(this.editor,DisplayManager.P_VIS))
         {
            return false;
         }
         if(allowFullCapture())
         {
            this.setFullCapture(_loc2_);
            if(doFullCapture())
            {
               _loc3_ = this.editor.panelNotes.visible;
               this.comic.visible = false;
               this.editor.panelNotes.visible = false;
               this.comic.storeImage(this.editor,Pixton.FULLSIZE,false,false,this.comic.getPanel());
               this.comic.visible = true;
               this.editor.panelNotes.visible = _loc3_;
            }
         }
         stage.focus = null;
         this.editor.resetMode();
         if(!this.comic.isSaved())
         {
            this.delaySaveScene = true;
            this.saveComic();
            return true;
         }
         if(!this.editor.allSaved())
         {
            this.delaySaveScene = true;
            this.editor.saveAll();
            return true;
         }
         if(this.comic.setSaving())
         {
            this.delaySaveScene = false;
            this.savingSceneData = this.editor.getData();
            this.editor.sendTeamUpdate(this.savingSceneData);
            _loc4_ = this.comic.getIDData();
            if(this.insertingScene)
            {
               _loc4_.ins = this.comic.index + 1;
               this.insertingScene = false;
            }
            Status.setMessage(L.text("please-wait"),false,false,Comic.self.unsetSaving);
            Utils.remote("saveScene",Utils.mergeObjects({
               "f":format,
               "iv":this.savingSceneData.q == null || this.savingAnimation
            },this.getStyleData(),_loc4_,this.savingSceneData),this.onSaveSceneData,false,null,this.onError);
            return true;
         }
         if(!this.finishing)
         {
            Utils.alert(L.text("editor-busy"));
         }
         return false;
      }
      
      public function startRendering() : void
      {
         if(Utils.inArray(this.comic.index + 1,this.autoRenderScenes) || isProfile() || _showUI)
         {
            Status.setMessage(L.text("please-wait"));
            if(isProfile())
            {
               Status.setProgressRange(0,100);
            }
            this.updateAnimationProgress(0);
            Utils.addListener(this.animation,PixtonEvent.COMPLETE,this.onRenderingComplete);
            Animation.captureFrames();
         }
         else
         {
            this.showNextScene();
         }
      }
      
      public function updateAnimationProgress(param1:Number) : void
      {
         var _loc2_:* = null;
         _loc2_ = "(" + Math.round(param1 * 100) + "%)";
         Status.setMessage(L.text("rendering-scene",_loc2_));
         Status.setProgress(param1,false);
      }
      
      private function onError(param1:*) : void
      {
         Status.reset();
         this.comic.setSaved();
         Utils.onNetError(param1 && param1.info ? Utils.toString(param1.info) : null);
      }
      
      private function onSaveSceneData(param1:Object = null) : void
      {
         skipPrompts = false;
         if(param1 != null && param1.error != null)
         {
            this.comic.setSaved();
            Status.reset();
            handleError(param1,true);
            return;
         }
         if(param1 == null || param1.scene == null)
         {
            this.comic.setSaved();
            Status.setMessage(L.text("scene-timeout"),true);
            return;
         }
         if(param1.index != null)
         {
            this.comic.index = param1.index - 1;
         }
         if(param1.numWords != null)
         {
            Comic.numWords = param1.numWords;
         }
         if(param1.editKey != null)
         {
            this.comic.setEditKey(param1.editKey);
         }
         if(this.delayEditScene == "auto")
         {
            this.delayEditScene = param1.scene;
         }
         Presets.update(param1);
         this.comic.updatePanel(param1);
         this.comic.setCache(this.savingSceneData);
         this.comic.savePanelSizes();
         if(isPlotDiagram() && param1.pt)
         {
            Utils.javascript("Pixton.comic.onChangePT",this.comic.getIndex(),param1.pt);
         }
         if(param1.v == 1)
         {
            if(Team.isActive)
            {
               Team.onChange(Comic.key,null,Team.P_PANEL_LIST,null,Comic.getSceneKeys());
            }
         }
         if(!doFullCapture())
         {
            this.comic.storeImage(this.editor,Pixton.FULLSIZE);
            if(!_resampleThumbs)
            {
               this.comic.storeImage(this.editor,Pixton.THUMBNAIL);
            }
         }
         this.comic.setSaved();
         if(this.finishing || isProfile() || this.savingAnimation)
         {
            Status.setMessage(L.text("please-wait"));
         }
         else
         {
            Status.reset();
         }
         this.saveImages(param1.w == 0 || param1.h == 0);
      }
      
      private function saveImages(param1:Boolean = false) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         var _loc2_:Object = this.comic.getIDData();
         var _loc3_:uint = this.getPropID();
         ++_savingSnapshot;
         if(isPropRender())
         {
            _loc5_ = PROP_SCALES.length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               Utils.remote("saveSnapshot",Utils.mergeObjects({
                  "f":format,
                  "prop":_loc3_,
                  "scaleName":PROP_SCALES[_loc4_]
               },this.getStyleData(),_loc2_,this.comic.getStoredImage(PROP_SCALES[_loc4_])),this.onSaveSnapshot,false,null,this.onError);
               _loc4_++;
            }
         }
         if(!param1)
         {
            _loc6_ = Utils.mergeObjects({
               "f":format,
               "prop":_loc3_,
               "hq":controlPressed
            },this.getStyleData(),_loc2_,this.comic.getStoredImage(Pixton.FULLSIZE));
            if(doFullCapture())
            {
               _loc6_["fullCapture"] = true;
            }
            Utils.remote("saveSnapshot",_loc6_,this.onSaveSnapshot,false,null,this.onError);
            if(!_resampleThumbs || isPropRender())
            {
               Utils.remote("saveSnapshot",Utils.mergeObjects({
                  "f":format,
                  "prop":_loc3_
               },this.getStyleData(),_loc2_,this.comic.getStoredImage(_loc3_ > 0 ? Number(Pixton.THUMBNAIL_PROP) : Number(Pixton.THUMBNAIL))));
            }
         }
         else
         {
            this.onSaveSnapshot();
         }
         if(!this.savingAnimation)
         {
            this.onSaveScene();
         }
      }
      
      private function onSaveSnapshot(param1:Object = null) : void
      {
         --_savingSnapshot;
         if(isPropRender())
         {
            Utils.javascript("PixtonPro.prop.onMakeImage",currentPropID,propIDs.length);
            if(currentPropID < propIDs.length - 1)
            {
               this.captureNextProp();
            }
         }
         else
         {
            this.comic.reloadImages();
            if(Team.isActive)
            {
               Team.onChange(Comic.key,param1.scene,Team.P_PANEL_V,null,param1.v);
            }
            if(this.savingAnimation)
            {
               self.startRendering();
            }
            else
            {
               this.checkFinish();
            }
         }
      }
      
      private function saveAnimation() : void
      {
         var _loc1_:Object = this.comic.getCache();
         var _loc2_:Object = this.comic.getIDData();
         var _loc3_:Object = {
            "w":_loc1_.w,
            "h":_loc1_.h,
            "start":Animation.startCaptureFrame,
            "end":Animation.completelyRendered,
            "loop":Animation.isLooping,
            "fps":Animation.fps
         };
         var _loc4_:uint;
         if((_loc4_ = Animation.getImagesSize()) > Animation.MAX_BYTES)
         {
            Status.reset();
            this.savingAnimation = false;
            Utils.alert(L.text("anim-oversize",Math.round((_loc4_ - Animation.MAX_BYTES) / Animation.MAX_BYTES * 100)));
         }
         else
         {
            Utils.remote("saveAnimation",Utils.mergeObjects({"f":format},Animation.getStoredImages(),_loc2_,_loc3_,this.getStyleData()),this.onSaveAnimation,true);
         }
      }
      
      private function onSaveAnimation(param1:Object) : void
      {
         if(param1.v != null)
         {
         }
         if(Animation.completelyRendered)
         {
            Status.reset();
            this.savingAnimation = false;
            this.editor.setSaved(true);
         }
         else
         {
            this.startRendering();
         }
      }
      
      private function finalizeAnimation() : void
      {
         Status.setMessage(L.text("rendering-final"));
         var _loc1_:Object = this.comic.getIDData();
         Utils.remote("finalizeAnimation",Utils.mergeObjects({},_loc1_,this.getStyleData()),this.onFinalizeAnimation,true);
      }
      
      private function onFinalizeAnimation(param1:Object = null) : void
      {
         Status.setProgress(1,false);
         if(!_showUI)
         {
            this.onButton(this.btnOkay);
         }
      }
      
      private function onSaveScene(param1:Object = null) : void
      {
         if(param1 != null)
         {
         }
         if(!this.finishing)
         {
            Status.reset();
         }
         this.comic.clearImages();
         Animation.clearCapture();
         this.closeScene();
         if(!isProfile())
         {
            if(isAutoBatchRender())
            {
               this.showNextScene();
            }
            else
            {
               Comic.setRelModTime(getTimer());
               if(this.delayNewScene != -1)
               {
                  this.newScene(null);
               }
               else if(this.delayEditScene != null)
               {
                  this.editScene(this.delayEditScene);
               }
            }
         }
      }
      
      private function getStyleData() : Object
      {
         return {
            "st":Style._get("key"),
            "pr":product,
            "uid":userID,
            "cl":L.multiLangID,
            "book":isBook
         };
      }
      
      function loadScene(param1:String, param2:Boolean = false, param3:String = null) : void
      {
         var _loc4_:Object = null;
         Debug.trace("Loading scene " + param1 + "...");
         if(sceneToMove == null)
         {
            this.comic.setPanelKey(param1);
            this.repositionEditor(true);
         }
         var _loc5_:Boolean = false;
         if(!isAutoRender())
         {
            if(AppState.exists(param1))
            {
               _loc4_ = AppState.restore();
               _loc5_ = true;
               if(Main.isStoryboard() || Main.isPhotoEssay())
               {
                  _loc4_["w"] = Comic.defaultWidth;
                  _loc4_["h"] = Comic.defaultHeight;
               }
            }
            if(!param2 && !_loc4_)
            {
               if(param1 == null)
               {
                  _loc4_ = this.comic.getCacheByIndex();
               }
               else if(Team.isActive && !Main.controlPressed)
               {
                  Debug.trace("loading scene from team...");
                  _loc4_ = Team.getData(Comic.key,sceneToMove == null ? param1 : sceneToMove,Team.P_PANEL_STATE);
               }
               else
               {
                  _loc4_ = this.comic.getCache(param1);
               }
            }
         }
         if(_loc4_ == null)
         {
            Status.setMessage(L.text("please-wait"));
            Utils.remote("loadScene",Utils.mergeObjects({
               "prop":(propIDs == null ? 0 : 1),
               "fromSceneKey":param3,
               "readOnly":(!!isReadOnly() ? 1 : 0)
            },this.getStyleData(),this.comic.getIDData(sceneToMove == null ? param1 : sceneToMove)),this.onLoadScene,false,null,this.onError);
         }
         else
         {
            this.loadSceneData(_loc4_,_loc5_);
         }
      }
      
      private function getPropID() : uint
      {
         if(propIDs != null)
         {
            return propIDs[currentPropID];
         }
         return 0;
      }
      
      function repositionEditor(param1:Boolean = false) : void
      {
         var _loc2_:Object = this.comic.getSceneData();
         if(isPropRender())
         {
            _loc2_.maxWidth = Comic.maxWidth;
         }
         else if(isPropPreview())
         {
            _loc2_.w = Comic.maxWidth;
         }
         this.editor.setPositionData(_loc2_,param1);
         this.positionMnuInsert(_loc2_);
         this.positionMnuMoveUp(_loc2_);
         this.updateStage();
      }
      
      private function onLoadScene(param1:Object) : void
      {
         if(!handleError(param1))
         {
            this.closeScene();
            return;
         }
         if(!this.finishing)
         {
            Status.reset();
         }
         this.loadSceneData(param1);
      }
      
      public function loadSceneData(param1:Object, param2:Boolean = false) : void
      {
         var _loc4_:Object = null;
         var _loc3_:Object = param1;
         if(!isAutoRender())
         {
            if(sceneToMove != null && (this.comic.hasCache() || !this.comic.hasPanel()))
            {
               if(this.comic.hasCache())
               {
                  _loc4_ = this.comic.getCache();
               }
               else
               {
                  _loc4_ = this.editor.getData();
               }
               _loc3_ = Utils.clone(param1);
               if(this.editor.mode != Editor.MODE_BORDER && (!Main.controlPressed || !AppSettings.isAdvanced))
               {
                  _loc3_.w = _loc4_.w;
                  _loc3_.h = _loc4_.h;
                  _loc3_.b = _loc4_.b;
                  _loc3_.pt = _loc4_.pt;
                  _loc3_.pd = _loc4_.pd;
                  _loc3_.pn = _loc4_.pn;
               }
               if(Comic.isFreestyle() && _loc4_.xp != null && _loc4_.yp != null)
               {
                  _loc3_.xp = _loc4_.xp;
                  _loc3_.yp = _loc4_.yp;
               }
            }
            else if(Comic.isFreestyle())
            {
               if(_loc3_.xp != null && _loc3_.yp != null && parseInt(_loc3_.xp) > Comic.maxWidth - Comic.minWidth)
               {
                  _loc3_.xp = 0;
                  _loc3_.yp = parseInt(_loc3_.yp) + parseInt(_loc3_.h) + Comic.PADDING_V;
               }
            }
         }
         if(param1.panelPos != null)
         {
            this.comic.addNewScene(param1);
            this.comic.setPanelPositions(param1.panelPos);
         }
         if(sceneToMove == null)
         {
            if(!isAutoRender() || Debug.ACTIVE)
            {
               this.comic.hideCurrentScene();
            }
         }
         else
         {
            this.closeEditor();
            this.repositionEditor(true);
            this.editor.onChange();
         }
         this.comic.setDefaultHeight(_loc3_.h);
         this.editor.setData(_loc3_,0);
         if(isAutoBatchRender())
         {
            this.editor.showOnlyContents();
         }
         if(isPropPreview())
         {
            Prop.addNewProps();
         }
         this.editor.resetUndo();
         this.updateScrim(true);
         this.comic.checkLock();
         this.comic.debugPanels();
         if(!isReadOnly())
         {
            if(isCharCreate() || param2 || sceneToMove != null || this.comic.index == this.comic.numScenes() || this.insertingScene || _loc3_.im > 0 && _loc3_.m > 0 && _loc3_.im < _loc3_.m || _loc3_.isNew == 1 || this.comic.numScenes() == 0 || Comic.self.panelNeedsResaving())
            {
               this.editor.setSaved(false,true);
            }
         }
         if(!param2)
         {
            if(sceneToMove != null)
            {
               this.updatePanelData(_loc3_);
            }
            else
            {
               this.comic.setCache(_loc3_);
            }
         }
         sceneToMove = null;
         if(isPropRender())
         {
            this.captureNextProp();
         }
         else if(isPregenRender())
         {
            this.saveHiRes();
         }
         else if(!isHiResRender())
         {
            if(this.delayAddSetting)
            {
               this.delayAddSetting = false;
               Template.addScene();
            }
            else if(Team.isVisible && this.comic.noImage() && !Editor.hasPhotosLoading())
            {
               this.delayEditScene = "auto";
               this.saveScene();
            }
            else if(isCharCreate())
            {
               Designer.getInstance().start();
            }
            else
            {
               this.editor.doAutoAction();
            }
         }
         Guide.onLoad();
      }
      
      function onSceneLoaded(param1:PixtonEvent) : void
      {
         if(isHiResRender())
         {
            this.saveHiRes(true);
         }
      }
      
      function updatePanelData(param1:Object) : void
      {
         this.comic.setPanelData(param1);
         this.comic.repositionPanels();
      }
      
      private function onDownKey(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case Keyboard.CONTROL:
               controlPressed = true;
               break;
            case Keyboard.ALTERNATE:
               optionPressed = true;
               break;
            case Keyboard.SHIFT:
               shiftPressed = true;
         }
      }
      
      private function onUpKey(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case Keyboard.SHIFT:
               shiftPressed = false;
               break;
            case Keyboard.ALTERNATE:
               optionPressed = false;
               break;
            case Keyboard.CONTROL:
               controlPressed = false;
         }
      }
      
      private function onResizeScene(param1:PixtonEvent) : void
      {
         this.comic.repositionPanels(param1.value);
         this.updateStage();
         this.positionMnuInsert();
         this.positionMnuMoveUp(param1.value);
         this.positionAnimation();
      }
      
      private function positionAnimation() : void
      {
         Animation.setXY(displayManager.GET(this.editor,DisplayManager.P_X) - 2 * this.editor.scaleX,displayManager.GET(this.editor,DisplayManager.P_Y) + this.editor.heightWithMenu * this.editor.scaleY + MenuItem.SIZE);
      }
      
      private function positionMnuInsert(param1:Object = null) : void
      {
         if(isReadOnly())
         {
            return;
         }
         var _loc2_:Number = this.comic.getInsertAllowance();
         displayManager.SET(this.btnInsert,DisplayManager.P_VIS,!isReadOnly() && !isSingle() && _loc2_ > 0 && !this.insertingScene && !isProfile() && !Comic.isFreestyle() && !Template.isActive() && !isPropPreview());
         if(displayManager.GET(this.btnInsert,DisplayManager.P_VIS))
         {
            if(Main.isLargeMode() && displayManager.GET(this.editor,DisplayManager.P_VIS))
            {
               displayManager.SET(this.btnInsert,DisplayManager.P_X,displayManager.GET(this.editor,DisplayManager.P_X) - this.btnInsert.width - 5 - 3 * this.editor.scaleX);
               displayManager.SET(this.btnInsert,DisplayManager.P_Y,displayManager.GET(this.editor,DisplayManager.P_Y) + (this.editor.getHeight() + 3) * this.editor.scaleY + 5);
            }
            else if(param1 != null)
            {
               displayManager.SET(this.btnInsert,DisplayManager.P_X,param1.x - this.btnInsert.width - 10);
               displayManager.SET(this.btnInsert,DisplayManager.P_Y,param1.y + param1.h + 8);
            }
         }
      }
      
      private function positionMnuMoveUp(param1:Object = null) : void
      {
         if(isReadOnly())
         {
            return;
         }
         var _loc2_:Object = this.comic.getSceneData();
         var _loc3_:Boolean = this.comic.getMoveUpAllowance(param1) && _loc2_.x <= 0;
         displayManager.SET(this.btnMoveUp,DisplayManager.P_VIS,!isReadOnly() && !isSingle() && _loc3_ && !this.insertingScene && !isProfile());
         if(displayManager.GET(this.btnMoveUp,DisplayManager.P_VIS))
         {
            if(Main.isLargeMode() && displayManager.GET(this.editor,DisplayManager.P_VIS))
            {
               if(displayManager.GET(this.btnInsert,DisplayManager.P_VIS))
               {
                  displayManager.SET(this.btnMoveUp,DisplayManager.P_X,this.btnInsert.x - this.btnMoveUp.width - 5);
               }
               else
               {
                  displayManager.SET(this.btnMoveUp,DisplayManager.P_X,displayManager.GET(this.editor,DisplayManager.P_X) - this.btnMoveUp.width - 5 - 3 * this.editor.scaleX);
               }
               displayManager.SET(this.btnMoveUp,DisplayManager.P_Y,displayManager.GET(this.editor,DisplayManager.P_Y) + this.editor.getHeight() * this.editor.scaleY + 5 + 3 * this.editor.scaleY);
            }
            else if(_loc2_ != null)
            {
               if(displayManager.GET(this.btnInsert,DisplayManager.P_VIS))
               {
                  displayManager.SET(this.btnMoveUp,DisplayManager.P_X,_loc2_.x - 8 - 5 - this.btnInsert.width * 2);
               }
               else
               {
                  displayManager.SET(this.btnMoveUp,DisplayManager.P_X,_loc2_.x - 5 - 3 - this.btnMoveUp.width);
               }
               displayManager.SET(this.btnMoveUp,DisplayManager.P_Y,_loc2_.y + _loc2_.h + 8);
            }
         }
      }
      
      private function getEndPosition() : Object
      {
         var _loc1_:Object = this.comic.getEndPosition();
         if(displayManager.GET(this.editor,DisplayManager.P_VIS))
         {
            if(this.comic.getPanelKey() == null)
            {
               _loc1_.x = displayManager.GET(this.editor,DisplayManager.P_X) + this.editor.getWidth() * this.editor.scaleX + Comic.PADDING_H;
            }
            _loc1_.y = Math.max(_loc1_.y,displayManager.GET(this.editor,DisplayManager.P_Y) + Math.max(this.editor.getHeight(false) * this.editor.scaleY,this.editor.btnPan.y + this.editor.btnPan.height + this.btnNew.height));
         }
         return _loc1_;
      }
      
      public function updateStage() : void
      {
         var _loc5_:uint = 0;
         var _loc1_:Object = this.getEndPosition();
         var _loc2_:Boolean = this.comic.maxedRows();
         if(displayManager.GET(this.editor,DisplayManager.P_VIS))
         {
            this.positionAnimation();
         }
         displayManager.SET(this.btnNew,DisplayManager.P_X,_loc1_.x + 5 + Math.round(3 * this.editor.scaleX));
         displayManager.SET(this.btnNew,DisplayManager.P_Y,_loc1_.y - this.btnNew.height + (!!Comic.isFreestyle() ? 0 : 1));
         displayManager.SET(this.btnNew,DisplayManager.P_VIS,!isCharCreate() && !isPropPreview() && !isCharMap() && !isPlotDiagram() && !isReadOnly() && !isSingle() && !isProfile() && !(_loc1_.x == 0 && _loc1_.y == 0) && !((Training.isActive() || Globals.isFullVersion() && !_isTempAnon && !Comic.hasLimitedRow()) && (this.comic.maxedRows(true,true) || this.comic.maxedScenes(_loc1_))));
         if(this.maxedMessage != null && _loc2_ && !isReadOnly() && !Platform._get("anon") && Comic.maxRows > 2)
         {
            displayManager.SET(this.maxedMessage,DisplayManager.P_Y,getBottomY() - 25);
            displayManager.SET(this.maxedMessage,DisplayManager.P_VIS,!Style.exists());
         }
         if(isCharCreate())
         {
            displayManager.SET(this.btnOkay,DisplayManager.P_Y,12);
            this.btnCancel.y = displayManager.GET(this.btnOkay,DisplayManager.P_Y);
         }
         this.btnCancelVisible = this.btnCancel.hasLabel && !isReadOnly() && !Platform._get("anon") && !Utils.SCREEN_CAPTURE_MODE && !isAutoRender() && !DEMO_MODE;
         this.btnOkayVisible = this.btnOkay.hasLabel && !isReadOnly() && !Utils.SCREEN_CAPTURE_MODE && !isAutoRender() && !DEMO_MODE && !isPropPreview();
         this.btnAdminVisible = !isCharCreate() && (isPixton() || isPropsAdmin() || this.comic.canSaveBkgd() || isPosesUser() || isCharacters() && !isPropPreview());
         this.btnOkayAlert = null;
         var _loc3_:uint = this.comic.numScenes() + (displayManager.GET(this.editor,DisplayManager.P_VIS) && this.comic.getPanelKey() == null ? 1 : 0);
         if(_loc3_ < Comic.minPanelsReq)
         {
            this.btnCancelVisible = this.btnCancel.hasLabel;
            this.btnOkayAlert = L.text("min-panels",Comic.minPanelsReq,_loc3_);
         }
         if(Comic.numWords < Comic.minWords)
         {
            this.btnCancelVisible = this.btnCancel.hasLabel;
            this.btnOkayAlert = L.text("min-words",Comic.minWords,Comic.numWords);
         }
         this.updateButton("cancel",{"visible":this.btnCancelVisible});
         this.updateButton("okay",{"visible":this.btnOkayVisible});
         this.updateButton("admin",{"visible":this.btnAdminVisible});
         if(this.btnOkayVisible)
         {
            if(this.btnOkayAlert)
            {
               this.btnOkay.makePriority(false);
               this.updateButton("okay",{"removeClass":"priority"});
               this.btnCancel.makePriority(true);
               this.updateButton("cancel",{"addClass":"priority"});
            }
            else
            {
               this.btnOkay.makePriority();
               this.updateButton("okay",{"addClass":"priority"});
               this.btnCancel.makePriority(false);
               this.updateButton("cancel",{"removeClass":"priority"});
            }
         }
         else if(this.btnCancelVisible)
         {
            this.btnCancel.makePriority();
            this.updateButton("cancel",{"addClass":"priority"});
         }
         var _loc4_:Number = !!isProfile() ? Number(Comic.maxWidth) : Number(UI_WIDTH);
         if(isCharCreate())
         {
            displayManager.SET(this.btnOkay,DisplayManager.P_X,Math.round(UI_WIDTH - this.btnOkay.width * 0.5));
            displayManager.SET(this.btnCancel,DisplayManager.P_X,Math.round(this.btnOkay.x - this.btnOkay.width * 0.5 - BUTTON_PADDING_H - this.btnCancel.width * 0.5));
         }
         else if(!isPropsAdmin())
         {
            if(Platform._get("anon"))
            {
               displayManager.SET(this.btnOkay,DisplayManager.P_X,Math.round(_loc4_ - this.btnOkay.width * 0.5 - BUTTON_PADDING_H));
            }
            else if(displayManager.GET(this.btnOkay,DisplayManager.P_VIS))
            {
               if(displayManager.GET(this.btnCancel,DisplayManager.P_VIS))
               {
                  displayManager.SET(this.btnCancel,DisplayManager.P_X,Math.round((_loc4_ - this.btnCancel.width - BUTTON_PADDING_H) * 0.5));
                  displayManager.SET(this.btnOkay,DisplayManager.P_X,Math.round((_loc4_ + this.btnOkay.width + BUTTON_PADDING_H) * 0.5));
               }
               else
               {
                  displayManager.SET(this.btnOkay,DisplayManager.P_X,Math.round(UI_WIDTH * 0.5));
               }
            }
            else
            {
               displayManager.SET(this.btnCancel,DisplayManager.P_X,Math.round(_loc4_ * 0.5));
            }
         }
         if(isCharCreate())
         {
            _loc5_ = Designer.FIXED_Y + Designer.FIXED_HEIGHT + 90;
         }
         else
         {
            _loc5_ = getComicBottomY();
         }
         if(!isAutoRender() && _loc5_ != actualStageHeight)
         {
            actualStageHeight = _loc5_;
            this.onStageSizeChanged();
         }
      }
      
      private function onStageSizeChanged() : void
      {
         Utils.javascript("Pixton.swf.onStageSizeChanged",actualStageHeight);
      }
      
      private function deleteScene(param1:PixtonEvent) : void
      {
         if(isMindMap())
         {
            Status.setMessage(L.text("please-wait"));
         }
         if(this.comic.getPanelKey())
         {
            Utils.remote("deleteScene",Utils.mergeObjects(this.getStyleData(),this.comic.getIDData()),this.onDeleteScene,false,null,this.onError);
         }
         this.closeEditor();
         this.comic.deleteScene();
         this.comic.repositionPanels();
         this.updateStage();
      }
      
      private function closeEditor() : void
      {
         this.editor.teamUnlock();
         this.editor.unsetData();
         displayManager.SET(this.btnInsert,DisplayManager.P_VIS,false);
         displayManager.SET(this.btnMoveUp,DisplayManager.P_VIS,false);
         setLargeMode(AppSettings.getActive(AppSettings.ZOOM_DEF));
         this.comic.alpha = 1;
      }
      
      private function onDeleteScene(param1:Object = null) : void
      {
         if(Team.isActive)
         {
            Team.onChange(Comic.key,param1.deletedSceneKey,Team.P_PANEL_STATE,null,Panel.STATE_DELETED);
         }
         if(param1.panelPos != null)
         {
            this.comic.setPanelPositions(param1.panelPos);
         }
         Presets.update(param1);
         this.comic.savePanelSizes();
         if(isMindMap())
         {
            Status.reset();
         }
      }
      
      private function closeScene(param1:PixtonEvent = null) : void
      {
         this.closeEditor();
         this.comic.showCurrentScene();
         this.comic.resetCurrentScene();
         if(this.insertingScene)
         {
            this.undoInsertScene();
         }
         this.comic.repositionPanels();
         this.updateStage();
      }
      
      private function moveUpScene(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.editor.getSizeData();
         this.comic.repositionPanels({"autoWidth":_loc2_.width},false);
         this.repositionEditor();
      }
      
      private function newScene(param1:MouseEvent) : void
      {
         var _loc2_:* = false;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         if(!Comic.isFreestyle() || !displayManager.GET(this.editor,DisplayManager.P_VIS))
         {
            _loc3_ = this.getEndPosition();
            if(this.comic.maxedRows(true,true) || this.comic.maxedScenes(_loc3_))
            {
               if((!Globals.isFullVersion() || _isTempAnon || Comic.hasLimitedRow()) && !Training.isActive())
               {
                  promptUpgrade();
               }
               return;
            }
         }
         if(this.delayNewScene == -1)
         {
            _loc2_ = Boolean(param1 == null || param1.currentTarget == this.btnNew);
            if(!_loc2_)
            {
               this.editor.setSaved(false,false,false);
            }
         }
         else
         {
            _loc2_ = this.delayNewScene == ADD_SCENE;
            this.delayNewScene = -1;
         }
         if(displayManager.GET(this.editor,DisplayManager.P_VIS) && (!this.editor.getSaved() || this.comic.noImage()))
         {
            Status.setMessage(L.text("please-wait"));
            if(!this.saveScene(null))
            {
               Status.reset();
               return;
            }
            this.delayNewScene = !!_loc2_ ? int(ADD_SCENE) : int(INSERT_SCENE);
         }
         else
         {
            _loc4_ = !!displayManager.GET(this.editor,DisplayManager.P_VIS) ? this.comic.getPanelKey() : null;
            if(displayManager.GET(this.editor,DisplayManager.P_VIS))
            {
               this.closeScene();
            }
            if(displayManager.GET(this.btnNew,DisplayManager.P_VIS))
            {
               if(_loc2_)
               {
                  this.comic.index = this.comic.numScenes();
                  this.loadScene(null,false,_loc4_);
               }
               else
               {
                  this.insertScene();
                  this.loadScene(this.comic.getPanelKey());
               }
            }
         }
      }
      
      private function insertScene() : void
      {
         this.insertingScene = true;
         this.comic.insertScene();
      }
      
      private function undoInsertScene() : void
      {
         this.insertingScene = false;
         this.comic.deleteScene();
         this.onDeleteScene();
      }
      
      private function onPressScene(param1:PixtonEvent) : void
      {
         if(isScrolling)
         {
            return;
         }
         if(!Comic.isFreestyle() && this.comic.numScenes() < 2)
         {
            return;
         }
         if(this.comic.getPanel(param1.value).getHeight(true,true) == 0)
         {
            return;
         }
         sceneToMove = param1.value;
         if(displayManager.GET(this.editor,DisplayManager.P_VIS))
         {
            this.sceneToMoveStartIndex = -1;
         }
         else
         {
            if(!TeamRole.can(TeamRole.PANELS))
            {
               this.sceneToMoveStartIndex = -1;
               sceneToMove = null;
               return;
            }
            this.sceneToMoveStartIndex = this.comic.getIndex(sceneToMove);
         }
         if(this.sceneToMoveStartIndex != -1 && Comic.isLockedPanels() && !isTemplatesUser())
         {
            this.sceneToMoveStartIndex = -1;
            sceneToMove = null;
            return;
         }
         this.comic.startDragging();
         this.sceneGhost = new Ghost(Utils.getSnapshot(this.comic.getImage(sceneToMove)),param1.value2.localX,param1.value2.localY,sceneToMove == null ? Number(0.8) : Number(0.4));
         addChild(this.sceneGhost);
         this.updateGhost(param1.value2);
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this.updateGhost);
         if(this.sceneToMoveStartIndex == -1)
         {
            Utils.addListener(stage,MouseEvent.MOUSE_UP,this.copyScene);
            Utils.addListener(this.editor,MouseEvent.MOUSE_UP,this.copyScene);
         }
         else
         {
            Utils.addListener(stage,MouseEvent.MOUSE_UP,this.moveScene);
         }
      }
      
      private function updateGhost(param1:Object) : void
      {
         this.sceneGhost.x = param1.stageX;
         this.sceneGhost.y = param1.stageY - this.y - (!!Comic.hasPanelTitles() ? Comic.PANEL_TITLE_HEIGHT : 0);
         if(this.sceneToMoveStartIndex == -1)
         {
            this.editor.borderHighlight = this.editor.border.hitTestPoint(this.sceneGhost.x,this.sceneGhost.y);
         }
         else
         {
            this.comic.movePanel(sceneToMove,this.sceneGhost,false);
         }
      }
      
      private function moveScene(param1:MouseEvent) : void
      {
         this.comic.movePanel(sceneToMove,this.sceneGhost,true,this.sceneToMoveStartIndex);
         sceneToMove = null;
         this.sceneToMoveStartIndex = -1;
         removeChild(this.sceneGhost);
         this.sceneGhost = null;
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateGhost);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.moveScene);
         this.comic.stopDragging();
      }
      
      private function copyScene(param1:MouseEvent) : void
      {
         this.editor.borderHighlight = false;
         this.comic.stopDragging();
         if(param1.currentTarget == this.editor && sceneToMove != this.comic.getPanelKey() && this.editor.getHeight() > 0)
         {
            this.loadScene(sceneToMove);
         }
         else
         {
            sceneToMove = null;
         }
         removeChild(this.sceneGhost);
         this.sceneGhost = null;
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this.updateGhost);
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.copyScene);
         Utils.removeListener(this.editor,MouseEvent.MOUSE_UP,this.copyScene);
      }
      
      private function onButtonJS(param1:String) : void
      {
         switch(param1)
         {
            case "okay":
               this.onButton(this.btnOkay);
               break;
            case "cancel":
               this.onButton(this.btnCancel);
               break;
            case "admin":
               this.onButton(this.btnAdmin);
         }
      }
      
      private function onKeypad(param1:String) : void
      {
         Dialog(Editor.self.currentTarget).recallCaret(param1);
      }
      
      private function onClickOutside() : void
      {
         if(displayManager.GET(self.editor,DisplayManager.P_VIS))
         {
            this.editor.onClickAway();
         }
      }
      
      private function onButton(param1:EditorButton) : void
      {
         var _loc2_:Boolean = isProfile() || Platform._get("anon");
         switch(param1)
         {
            case this.btnOkay:
               if(this.btnOkayAlert)
               {
                  Utils.alert(this.btnOkayAlert);
                  return;
               }
               this.saving = true;
               this.publishing = true;
               break;
            case this.btnCancel:
               this.saving = !_loc2_;
               this.publishing = false;
               break;
            case this.btnAdmin:
               if(isPropsAdmin())
               {
                  this.editor.setPropDefaults();
               }
               else if(this.comic.canSaveBkgd())
               {
                  this.saveComicBkgd();
               }
               else if(isCharacters())
               {
                  this.editor.captureCharacters();
               }
               return;
         }
         this.finishing = true;
         this.checkFinish();
      }
      
      private function saveComicBkgd() : void
      {
         var _loc1_:MovieClip = this.comic.bkgd;
         var _loc2_:Rectangle = _loc1_.getBounds(_loc1_);
         var _loc3_:BitmapData = new BitmapData(_loc2_.x + _loc2_.width,_loc2_.y + _loc2_.height,true,0);
         _loc3_.draw(_loc1_);
         Utils.remote("saveComicBkgd",Utils.mergeObjects({"name":Main.self.team.getTitle()},Pixton.encodeBMD(_loc3_)));
      }
      
      private function checkFinish() : void
      {
         var _loc1_:* = null;
         if(!this.finishing)
         {
            return;
         }
         if(this._savingComic)
         {
            this._wasSavingComic = true;
            return;
         }
         if(isPropPreview())
         {
            navigateToURL(new URLRequest(this.okayURL),isFB() || isEmbedded() ? "_self" : "_top");
            return;
         }
         if(_savingSnapshot > 0)
         {
            Status.setMessage(L.text("please-wait"));
            return;
         }
         if(onFinishURL != null)
         {
            if(onFinishURL == "reload")
            {
               Utils.javascript("Pixton.redirect.reload");
            }
            else if(onFinishURL == "changeFormat")
            {
               Utils.javascript("Pixton.comic.changeFormat",Comic.self.getKey());
               Status.reset();
               this.finishing = false;
            }
            else
            {
               Utils.javascript("Pixton.redirect.goto",onFinishURL);
            }
            onFinishURL = null;
            return;
         }
         if(!this.saving && (!this.editor.getSaved() || !this.comic.isSaved()))
         {
            Utils.javascript("Pixton.comic.confirmCancel",this.cancelURL);
            this.finishing = false;
            return;
         }
         if(this.saving && !this.editor.isSaved())
         {
            this.saveScene(null);
         }
         else if(this.saving && !this.comic.isSaved())
         {
            this.saveComic();
         }
         else if(this.publishing && !Comic.fixedWidth && !this.comic.marginsMet())
         {
            Utils.alert(L.text(!!Comic.isFreestyle() ? "check-margins" : "right-margin"));
            Status.reset();
            this.finishing = false;
         }
         else
         {
            if(this.publishing)
            {
               if(isProfile() || isPhotoComic())
               {
                  _loc1_ = this.okayURL.replace("{key}","");
               }
               else
               {
                  _loc1_ = this.okayURL.replace("{key}",Comic.key);
               }
               if(this.newComic && !Style.exists())
               {
                  _loc1_ += "/new";
               }
            }
            else
            {
               _loc1_ = this.cancelURL;
            }
            if(!Globals.IDE)
            {
               if(_loc1_ == "back")
               {
                  Utils.javascript("Pixton.back");
               }
               else if(_isPlain)
               {
                  Utils.javascript("Pixton.comic.closeWindow",Comic.key);
               }
               else
               {
                  navigateToURL(new URLRequest(_loc1_),isFB() || isEmbedded() ? "_self" : "_top");
               }
            }
         }
      }
      
      public function enable(param1:Boolean, param2:MovieClip = null) : void
      {
         var _loc3_:uint = 0;
         var _loc5_:DisplayObject = null;
         var _loc4_:uint = numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if((_loc5_ = getChildAt(_loc3_)) is MovieClip)
            {
               MovieClip(_loc5_).mouseEnabled = param1 || _loc5_ == param2;
               MovieClip(_loc5_).mouseChildren = MovieClip(_loc5_).mouseEnabled;
            }
            _loc3_++;
         }
         enableState = param1;
      }
      
      private function showHelp(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this.btnNew:
               Help.show(L.text("add-scene"),param1.currentTarget);
               break;
            case this.btnInsert:
               Help.show(L.text("insert-scene"),param1.currentTarget);
               break;
            case this.btnMoveUp:
               Help.show(L.text("move-scene"),param1.currentTarget);
         }
      }
      
      private function hideHelp(param1:MouseEvent = null) : void
      {
         Help.hide();
      }
      
      private function updateSaveState(param1:PixtonEvent) : void
      {
         if(isReadOnly())
         {
            return;
         }
         if(Utils.javascript("Pixton.comic.setDirty",!param1.value))
         {
            if(Team.isActive && param1.value2)
            {
               Team.onChange(Comic.key,this.comic.getPanelKey(),Team.P_PANEL_SAVED,null,{"saved":param1.value});
            }
         }
      }
      
      private function autoHideNonVisibleElements() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = stageTopY - AUTO_HIDE_PADDING;
         var _loc8_:Number = stageTopY + AUTO_HIDE_PADDING + stageVisibleHeight;
         displayManager.clear();
         _loc2_ = this.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.getChildAt(_loc1_);
            _loc6_ = _loc3_ == this.team ? Number(_loc3_.y) : Number(_loc3_.y + _loc3_.height);
            if(_loc3_ != this.comic && (_loc6_ < _loc7_ || _loc3_.y > _loc8_))
            {
               displayManager.addItem(_loc3_,_loc7_);
            }
            _loc1_++;
         }
         this.comic.autoHideNonVisibleElements();
      }
      
      function updateEditorPosition() : void
      {
         var _loc1_:Object = this.comic.getSceneData();
         this.editor.setComicXY(_loc1_.x,_loc1_.y);
      }
      
      public function saveChanges(param1:String) : void
      {
         skipPrompts = true;
         this.finishing = true;
         Main.onFinishURL = param1;
         if(displayManager.GET(this.editor,DisplayManager.P_VIS))
         {
            this.saveScene();
         }
         else
         {
            this.checkFinish();
         }
      }
      
      private function showEditor(param1:Boolean) : void
      {
         displayManager.SET(this.editor,DisplayManager.P_VIS,param1,true);
         Animation.updateVisibility();
      }
      
      function updateScrim(param1:Boolean = false) : void
      {
         if(!displayManager.GET(self.editor,DisplayManager.P_VIS))
         {
            return;
         }
         if(isLargeMode())
         {
            this.editor.setViewScale(getLargeScale());
            this.comic.alpha = 0.5;
         }
         else
         {
            this.editor.setViewScale(1);
            this.comic.alpha = 1;
         }
         this.updateEditorPosition();
         this.editor.refreshMenu();
         this.editor.updateEditLarge();
         this.repositionEditor(param1);
         if(isLargeMode())
         {
            Utils.javascript("Pixton.comic.jumpToEditor",displayManager.GET(this.editor,DisplayManager.P_Y) - 20 + this.y);
         }
      }
      
      private function onApplyFormat(param1:uint) : void
      {
         this.enable(true);
      }
      
      private function savePropParams(param1:MovieClip, param2:Boolean = false) : void
      {
         var _loc3_:Prop = null;
         var _loc5_:uint = 0;
         var _loc9_:Rectangle = null;
         var _loc11_:BitmapData = null;
         var _loc12_:String = null;
         var _loc13_:Object = null;
         var _loc15_:Array = null;
         var _loc4_:Array;
         var _loc6_:uint = (_loc4_ = Prop.getAllPropData()).length;
         Debug.trace("savePropParams (" + _loc6_ + ")");
         var _loc7_:Array = [];
         var _loc8_:Object = Prop.getIDMap();
         var _loc10_:uint = !!param2 ? uint(149) : uint(80);
         var _loc14_:Object = [];
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = Prop.add(null,_loc4_[_loc5_].id,Prop.PROP_PRESET);
            Debug.trace(_loc4_[_loc5_].id + ": " + _loc4_[_loc5_].l + "; " + _loc3_);
            Debug.trace("Prop " + _loc4_[_loc5_].id);
            _loc12_ = _loc4_[_loc5_].l;
            if(!param2)
            {
               _loc15_ = getPropLayers(_loc3_.asset);
               _loc9_ = _loc3_.getBounds(_loc3_);
               _loc7_.push({
                  "n":_loc12_,
                  "id":parseInt(_loc8_[_loc12_]),
                  "l":_loc15_,
                  "w":_loc9_.width,
                  "h":_loc9_.height,
                  "px":_loc9_.x,
                  "py":_loc9_.y
               });
            }
            _loc3_.updateInners(1);
            if(_loc3_.hasIcon)
            {
               _loc3_.setColor(0,Palette.GRAY);
            }
            _loc11_ = Utils.renderImage(_loc3_,1,null,null,_loc10_,_loc10_,1,param2);
            _loc13_ = Utils.encodedPNG(_loc11_,1);
            _loc14_[String(_loc3_.id)] = _loc13_;
            _loc5_++;
         }
         Debug.trace("Saving...");
         Utils.remote("savePropParams",{
            "size":_loc10_,
            "layers":_loc7_,
            "snapshotsXML":_loc14_
         });
      }
      
      public function onUpdateDesigner(param1:Boolean) : void
      {
         this.updateButton("okay",{"alpha":1});
         this.updateButton("cancel",{"alpha":this.btnOkay.alpha});
         this.btnOkay.mouseEnabled = this.btnOkay.alpha == 1;
         this.btnCancel.mouseEnabled = this.btnOkay.mouseEnabled;
      }
      
      private function updateButton(param1:String, param2:Object) : void
      {
         var _loc3_:EditorButton = null;
         switch(param1)
         {
            case "cancel":
               _loc3_ = this.btnCancel;
               break;
            case "admin":
               _loc3_ = this.btnAdmin;
               break;
            case "okay":
               _loc3_ = this.btnOkay;
         }
         if(param2)
         {
            if(param2.visible != null)
            {
               displayManager.SET(_loc3_,DisplayManager.P_VIS,param2.visible && this.okayCancelVisible());
            }
            if(param2.alpha != null)
            {
               _loc3_.alpha = !!this.okayCancelVisible() ? Number(param2.alpha) : Number(0);
            }
         }
         Utils.javascript("Pixton.comic.updateEditorButton",param1,param2);
      }
      
      private function okayCancelVisible() : Boolean
      {
         return isCharCreate();
      }
      
      private function setFullCapture(param1:Boolean) : void
      {
         if(!allowFullCapture())
         {
            return;
         }
         _doFullCapture = param1;
      }
   }
}
