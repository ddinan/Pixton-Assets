package com.pixton.editor
{
   import com.pixton.animate.Animation;
   import com.pixton.team.Team;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public final class Comic extends MovieClip
   {
      
      public static const STANDARD_WIDTH:uint = 295;
      
      public static const STANDARD_HEIGHT:uint = 300;
      
      public static const PANEL_TITLE_HEIGHT:uint = 34;
      
      public static const PANEL_DESC_HEIGHT:uint = 88;
      
      public static const DEFAULT_DESC_LINES:uint = 4;
      
      public static const LAYOUT_INLINE:uint = 0;
      
      public static const LAYOUT_FREESTYLE:uint = 1;
      
      public static var PADDING_H:uint = 7;
      
      public static const PADDING_V:uint = 10;
      
      public static const FORMAT_FREESTYLE:uint = 10;
      
      private static const GHOST_DELAY:uint = 200;
      
      private static const MAX_PRESS_MOVE:Number = 5;
      
      public static var initY:Number = 0;
      
      public static const ACTIVITY_CHARS:String = "chars";
      
      public static const ACTIVITY_POSES:String = "poses";
      
      public static var minWidth:uint = 175;
      
      public static var minHeight:uint = 175;
      
      public static var maxWidth:uint = 0;
      
      public static var maxHeight:uint = 0;
      
      public static var maxPanelWidth:uint = 0;
      
      public static var defaultHeight:uint = 300;
      
      public static var defaultWidth:uint = 0;
      
      public static var pageLength:uint = 0;
      
      public static var fixedWidth:Boolean = false;
      
      public static var fixedHeight:Boolean = false;
      
      public static var maxRows:uint = 1;
      
      public static var maxPanels:uint = 0;
      
      public static var minPanels:uint = 0;
      
      public static var minPanelsReq:uint = 0;
      
      public static var minWords:uint = 0;
      
      public static var presetCharsOnly:Boolean = false;
      
      public static var presetPosesOnly:Boolean = false;
      
      public static var numWords:uint = 0;
      
      public static var key:String = "";
      
      public static var self:Comic;
      
      public static var edges:Object;
      
      public static var showMargins:Boolean = false;
      
      public static var displayManager:DisplayManager = new DisplayManager();
      
      public static var contentYOffset:uint = 0;
      
      private static var _layout:uint;
      
      private static var _panelLocks:Object = {};
      
      private static var _panelOpens:Object = {};
      
      private static var _isLockedPanels:Boolean = false;
      
      private static var _canAddRows:Boolean = false;
      
      private static var _hasPanelTitles:Boolean = false;
      
      private static var _hasPanelDescriptions:Boolean = false;
      
      private static var _size:uint = 0;
      
      private static const LINE_THICKNESS:uint = 6;
      
      private static const LINE_PADDING:uint = 2;
      
      private static const LINE_ALPHA:Number = 0.5;
       
      
      public var txtHeight:TextField;
      
      public var txtPage:TextField;
      
      public var characterBase:Character;
      
      public var propLibrary:Character;
      
      public var panels:Array;
      
      public var map:Object;
      
      public var contents:MovieClip;
      
      public var bkgd:MovieClip;
      
      private var latestHeight:uint;
      
      private var mode:String;
      
      private var _index:int = 0;
      
      private var currentSavingPanel:Panel;
      
      private var imageData:Array;
      
      private var timeout:uint;
      
      private var _dragging:Boolean = false;
      
      private var maxX:Number;
      
      private var maxY:Number;
      
      private var _editKey:String = "";
      
      private var _startPanel:Panel;
      
      private var _startPanelPress:Point;
      
      private var _hasScrolled:Boolean;
      
      private var panelsToLoad:uint = 0;
      
      private var panelsLoaded:uint = 0;
      
      private var marginsMC:MovieClip;
      
      private var _rowsByPanel:Object;
      
      private var _pageBottomYList:Array;
      
      private var _pageBottomYListDirty:Boolean = true;
      
      private var _visiblePage:int = -1;
      
      public function Comic()
      {
         this.panels = [];
         this.map = {};
         super();
         this.contents = new MovieClip();
         addChild(this.contents);
         this.txtHeight.visible = false;
         this.txtHeight.mouseEnabled = false;
         this.txtHeight.autoSize = TextFieldAutoSize.LEFT;
         this.txtHeight.multiline = false;
         this.txtHeight.wordWrap = false;
         this.txtHeight.parent.removeChild(this.txtHeight);
         this.txtPage.visible = false;
         this.txtPage.mouseEnabled = false;
         this.txtPage.autoSize = TextFieldAutoSize.LEFT;
         this.txtPage.multiline = false;
         this.txtPage.wordWrap = false;
         this.txtPage.parent.removeChild(this.txtPage);
      }
      
      public static function init(param1:Comic) : void
      {
         Comic.self = param1;
         setLayout(LAYOUT_INLINE);
      }
      
      static function setLayout(param1:uint) : void
      {
         if(param1 != _layout && self.panels != null)
         {
            updateAllBorders();
         }
         _layout = param1;
      }
      
      private static function updateAllBorders() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = self.panels.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            Panel(self.panels[_loc1_]).updateBorder();
            _loc1_++;
         }
      }
      
      static function getLayout() : uint
      {
         return _layout;
      }
      
      public static function isFreestyle(param1:Boolean = false) : Boolean
      {
         if(param1)
         {
            return getLayout() == LAYOUT_FREESTYLE;
         }
         return Main.isCharMap() || getLayout() == LAYOUT_FREESTYLE;
      }
      
      static function isNew() : Boolean
      {
         return key == "";
      }
      
      private static function getHeightOffset() : uint
      {
         return getPanelTitleOffset() + getPanelDescOffset();
      }
      
      private static function getPanelTitleOffset() : uint
      {
         if(hasPanelTitles())
         {
            return Comic.PANEL_TITLE_HEIGHT;
         }
         return 0;
      }
      
      private static function getPanelDescOffset() : uint
      {
         if(hasPanelDescriptions())
         {
            return Comic.PANEL_DESC_HEIGHT;
         }
         return 0;
      }
      
      static function reposition(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number;
         if((_loc4_ = initY) != self.y)
         {
            self.y = _loc4_;
            self.repositionEditor();
         }
      }
      
      static function repositionPanels(param1:int = 0) : void
      {
         self.position(param1);
         self.repositionEditor();
      }
      
      public static function setRelModTime(param1:Number) : void
      {
         self.setRelModTime(param1);
      }
      
      public static function getRelModTime() : Number
      {
         return self.getRelModTime();
      }
      
      public static function isSingle(param1:Boolean = false) : Boolean
      {
         if(param1)
         {
            return self.panels.length <= 1;
         }
         return self.panels.length == 1;
      }
      
      public static function getBottomY() : Number
      {
         var _loc1_:uint = self.latestHeight + 4;
         if(Main.notesAlwaysVisible())
         {
            _loc1_ += PANEL_DESC_HEIGHT;
         }
         return _loc1_;
      }
      
      static function updatePosition(param1:uint, param2:uint) : void
      {
         self.updatePosition(param1,param2);
      }
      
      static function bringForward(param1:Boolean = false) : void
      {
         self.rearrange(param1,1);
      }
      
      static function sendBack(param1:Boolean = false) : void
      {
         self.rearrange(param1,-1);
      }
      
      public static function getSceneKeys() : Array
      {
         var _loc2_:Panel = null;
         var _loc1_:Array = [];
         for each(_loc2_ in self.panels)
         {
            if(_loc2_.key != null)
            {
               _loc1_.push(_loc2_.key);
            }
         }
         return _loc1_;
      }
      
      static function resetCache() : void
      {
         self.resetCache();
      }
      
      static function lockPanel(param1:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc2_:String = self.getPanelKey();
         if(_loc2_ != null)
         {
            _loc3_ = {
               "u":Main.userID,
               "s":Main.sessionID,
               "a":param1
            };
            updateLock(_loc2_,_loc3_);
            Team.onChange(Comic.key,_loc2_,Team.P_PANEL_LOCK,null,_loc3_);
         }
      }
      
      static function unlockPanel() : void
      {
         var _loc1_:String = self.getPanelKey();
         if(_loc1_ != null)
         {
            if(_panelLocks[_loc1_] != null && _panelLocks[_loc1_].u != Main.userID)
            {
               return;
            }
            updateLock(_loc1_);
            Team.onChange(Comic.key,_loc1_,Team.P_PANEL_LOCK,null,null);
         }
      }
      
      static function updateOpen(param1:String, param2:Object = null) : *
      {
         if(param2 == null)
         {
            _panelOpens[param1] = null;
         }
         else
         {
            if(_panelOpens[param1] == null)
            {
               _panelOpens[param1] = {};
            }
            if(param2.v)
            {
               _panelOpens[param1][param2.u.toString()] = param2;
            }
            else
            {
               _panelOpens[param1][param2.u.toString()] = null;
            }
         }
      }
      
      static function updateLock(param1:String, param2:Object = null) : *
      {
         var _loc3_:Panel = self.getPanel(param1);
         if(_loc3_ == null)
         {
            return;
         }
         if(param2 == null || param2.s == Main.sessionID)
         {
            if(param1 == self.getPanelKey())
            {
               Editor.self.locked = null;
            }
            if(_loc3_.locked != null && _loc3_.locked.a != null && _loc3_.locked.a)
            {
               Main.self.enable(true);
            }
            _loc3_.locked = null;
         }
         else
         {
            if(param1 == self.getPanelKey())
            {
               Editor.self.locked = param2;
            }
            _loc3_.locked = param2;
            if(param2 != null && param2.a != null && param2.a)
            {
               Main.self.enable(false);
            }
         }
         _panelLocks[param1] = param2;
      }
      
      static function isLocked(param1:String = null, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         return self.isLocked(param1,param2,param3);
      }
      
      static function isLockedPanels() : Boolean
      {
         return _isLockedPanels;
      }
      
      static function canAddRows() : Boolean
      {
         return _canAddRows;
      }
      
      public static function getPath(param1:String, param2:uint, param3:String = null) : String
      {
         return Utils.dynamicServer + "comic/" + Utils.directify(param1) + param1 + (!!param3 ? param3 : "") + Utils.v(param2) + Utils.EXT_PNG;
      }
      
      public static function hasPanelTitles(param1:Boolean = false) : Boolean
      {
         if(param1)
         {
            return Main.isStoryboard() || Main.isMindMap() || Main.isCharMap() || Main.isPlotDiagram() || Main.isTimeline() || Main.isPhotoEssay();
         }
         return _hasPanelTitles || Main.isPlotDiagram();
      }
      
      public static function hasPanelDescriptions(param1:Boolean = false) : Boolean
      {
         if(param1)
         {
            return Main.isStoryboard() || Main.isMindMap() || Main.isCharMap() || Main.isPlotDiagram() || Main.isTimeline() || Main.isPhotoEssay();
         }
         return _hasPanelDescriptions || Main.isPlotDiagram();
      }
      
      public static function getSize() : uint
      {
         return _size;
      }
      
      public static function hasLimitedRow() : Boolean
      {
         return maxRows < 8;
      }
      
      public static function getDefDescLines() : uint
      {
         if(Main.isTimeline())
         {
            return 8;
         }
         return DEFAULT_DESC_LINES;
      }
      
      public function setNotesVisible(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this.panels.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            Panel(this.panels[_loc2_]).setNotesVisible(param1);
            _loc2_++;
         }
         this.position(0);
      }
      
      private function getPanelX(param1:Panel) : Number
      {
         return displayManager.GET(param1,DisplayManager.P_X);
      }
      
      private function getPanelY(param1:Panel) : Number
      {
         return displayManager.GET(param1,DisplayManager.P_Y);
      }
      
      public function setPanelVisible(param1:Panel, param2:Boolean) : void
      {
         var _loc3_:Object = displayManager.getItem(param1);
         if(_loc3_)
         {
            _loc3_.visible = param2;
         }
         else
         {
            param1.setVisible(param2);
         }
      }
      
      public function setPanelX(param1:Panel, param2:Number) : void
      {
         displayManager.SET(param1,DisplayManager.P_X,param2);
      }
      
      public function setPanelY(param1:Panel, param2:Number) : void
      {
         displayManager.SET(param1,DisplayManager.P_Y,param2);
      }
      
      public function setFreeStyle(param1:String) : Array
      {
         var _loc3_:uint = 0;
         var _loc5_:Panel = null;
         var _loc2_:Array = [];
         var _loc4_:uint = this.panels.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            (_loc5_ = Panel(this.panels[_loc3_])).xp = this.getPanelX(_loc5_);
            _loc5_.yp = this.getPanelY(_loc5_);
            _loc5_.updateBorder();
            _loc2_.push({
               "key":_loc5_.key,
               "xp":_loc5_.xp,
               "yp":_loc5_.yp,
               "b":param1
            });
            if(_loc3_ == this.index)
            {
               Editor.self.setComicXY(this.getPanelX(_loc5_),this.getPanelY(_loc5_),true);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function setDefaultHeight(param1:uint) : void
      {
         if(param1 <= 0)
         {
            return;
         }
         defaultHeight = param1;
         this.latestHeight = param1;
      }
      
      public function setDefaultWidth(param1:uint) : void
      {
         if(param1 <= 0)
         {
            return;
         }
         defaultWidth = param1;
      }
      
      public function updateColor() : void
      {
         this.txtHeight.textColor = Palette.colorLinkStr;
         this.txtPage.textColor = Palette.colorLinkStr;
      }
      
      public function loadData(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.setDefaultHeight(param1.defHeight);
         this.setDefaultWidth(param1.defWidth);
         maxWidth = param1.maxWidth;
         maxPanelWidth = param1.maxPanelWidth;
         maxHeight = param1.maxHeight;
         minWidth = param1.minWidth;
         minHeight = param1.minHeight;
         fixedWidth = param1.fixedWidth == 1;
         fixedHeight = param1.fixedWidth == 1;
         maxRows = param1.maxRows;
         minPanelsReq = param1.minPanelsReq;
         minPanels = param1.minPanels;
         maxPanels = param1.maxPanels;
         minWords = param1.minWords;
         numWords = param1.numWords;
         if(param1.paddingH != null)
         {
            PADDING_H = param1.paddingH;
         }
         if(param1.rules != null)
         {
            presetCharsOnly = !Utils.inArray(ACTIVITY_CHARS,param1.rules);
            presetPosesOnly = !Utils.inArray(ACTIVITY_POSES,param1.rules);
         }
         if(param1.pl != null)
         {
            _hasPanelTitles = hasPanelTitles(true) && (param1.pl == "all" || param1.pl == "title");
            _hasPanelDescriptions = hasPanelDescriptions(true) && (param1.pl == "all" || param1.pl == "desc");
         }
         if(param1.sz != null)
         {
            _size = param1.sz;
         }
         _isLockedPanels = param1.lockPanels;
         _canAddRows = param1.addRows;
         if(Border.canView())
         {
            setLayout(LAYOUT_FREESTYLE);
         }
         if(param1.scenes != null)
         {
            _loc3_ = param1.scenes.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               param1.scenes[_loc2_].o = _loc2_;
               this.panels[_loc2_] = this.createPanel(param1.scenes[_loc2_]);
               _loc2_++;
            }
         }
         if(Main.isTChart() || Main.isGrid())
         {
            contentYOffset = PANEL_TITLE_HEIGHT;
         }
         this.contents.y = contentYOffset;
         this.position(0);
         this.updateMap();
      }
      
      public function load() : void
      {
         this.reloadImages();
      }
      
      function reloadImages() : void
      {
         var _loc1_:Panel = null;
         this.panelsToLoad = 0;
         this.panelsLoaded = 0;
         for each(_loc1_ in this.panels)
         {
            if(!_loc1_.imageLoaded && !_loc1_.imageLoading)
            {
               ++this.panelsToLoad;
               _loc1_.loadImage();
            }
         }
         this.checkPanelsLoaded();
      }
      
      public function unsetSaving() : void
      {
         if(this.panels[this.index] != null)
         {
            Panel(this.panels[this.index]).busy = false;
         }
         this.currentSavingPanel = null;
      }
      
      public function setSaving(param1:Boolean = false) : Boolean
      {
         if(this.panels[this.index] == null)
         {
            this.panels[this.index] = this.createPanelAt(this.index);
            this.position(this.index);
         }
         var _loc2_:Panel = Panel(this.panels[this.index]);
         if(_loc2_.busy || this.currentSavingPanel != null)
         {
            return false;
         }
         this.currentSavingPanel = _loc2_;
         _loc2_.busy = true;
         return true;
      }
      
      function setSaved() : void
      {
         if(this.currentSavingPanel != null)
         {
            this.currentSavingPanel.busy = false;
            this.currentSavingPanel = null;
         }
      }
      
      public function updatePanel(param1:Object) : void
      {
         if(this.currentSavingPanel == null)
         {
            return;
         }
         this.currentSavingPanel.key = param1.scene;
         this.updateMap();
         this.currentSavingPanel.version = param1.v;
         this.currentSavingPanel.absModTime = param1.sm;
         this.currentSavingPanel.isNew = false;
      }
      
      private function updateMap() : void
      {
         var _loc1_:Panel = null;
         this.map = {};
         for each(_loc1_ in this.panels)
         {
            this.map[_loc1_.key] = _loc1_;
         }
      }
      
      public function getScenePositionData() : Object
      {
         var _loc2_:Panel = null;
         var _loc1_:Object = {};
         if(this.index > -1 && this.panels[this.index] != null)
         {
            _loc2_ = Panel(this.panels[this.index]);
            _loc1_["xp"] = this.getPanelX(_loc2_);
            _loc1_["yp"] = this.getPanelY(_loc2_);
         }
         return _loc1_;
      }
      
      public function startDragging() : void
      {
         this._dragging = true;
      }
      
      public function stopDragging() : void
      {
         this._dragging = false;
      }
      
      public function getKey() : String
      {
         return key;
      }
      
      public function getIDData(param1:String = null) : Object
      {
         var _loc3_:Panel = null;
         var _loc2_:uint = 0;
         if(param1 == null)
         {
            param1 = this.getPanelKey();
         }
         if(param1 != null)
         {
            _loc3_ = this.getPanel(param1);
            _loc2_ = _loc3_.version;
         }
         return {
            "key":key,
            "scene":param1,
            "v":_loc2_
         };
      }
      
      public function storeImage(param1:Editor, param2:Number, param3:Boolean = false, param4:Boolean = false, param5:Panel = null) : void
      {
         if(param3)
         {
            this.currentSavingPanel = this.panels[0];
         }
         var _loc6_:Object;
         if((_loc6_ = Pixton.getEditorImage(param1,param2,param2 == Pixton.FULLSIZE && !param4 ? (!!param5 ? param5 : this.currentSavingPanel) : null)) != null)
         {
            _loc6_.alpha = param1.getColor() == Palette.TRANSPARENT_ID;
         }
         this.setStoredImage(param2,_loc6_,param4);
      }
      
      public function setStoredImage(param1:Number, param2:Object, param3:Boolean = false) : void
      {
         if(this.imageData == null)
         {
            this.imageData = [];
         }
         this.imageData[param1.toString() + (!!param3 ? "_" : "")] = param2;
      }
      
      public function getStoredImage(param1:Number, param2:Boolean = false) : Object
      {
         return this.imageData[param1.toString() + (!!param2 ? "_" : "")];
      }
      
      public function clearImage(param1:Number) : void
      {
         delete this.imageData[param1.toString()];
      }
      
      public function clearImages() : void
      {
         this.imageData = [];
      }
      
      public function noImage() : Boolean
      {
         return this.index > -1 && this.panels[this.index] == null;
      }
      
      public function panelNeedsResaving() : Boolean
      {
         var _loc1_:Panel = this.getActivePanel();
         if(_loc1_)
         {
            return _loc1_.imageNeedsSaving;
         }
         return false;
      }
      
      public function getActivePanel() : Panel
      {
         if(this.currentSavingPanel != null)
         {
            return this.currentSavingPanel;
         }
         return this.panels[this.index] as Panel;
      }
      
      private function createPanelAt(param1:uint, param2:Panel = null, param3:Number = -1) : Panel
      {
         return this.createPanel({"o":param1},param2,param3,false);
      }
      
      private function createPanel(param1:Object, param2:Panel = null, param3:Number = -1, param4:Boolean = true) : Panel
      {
         var _loc5_:Object = null;
         if(param2 != null)
         {
            (_loc5_ = param2.cache).key = null;
            _loc5_.o = param1.o;
         }
         else
         {
            _loc5_ = param1;
         }
         if(param3 != -1 && param3 < _loc5_.w)
         {
            _loc5_.w = param3;
         }
         var _loc6_:Panel = new Panel(_loc5_);
         if(Main.notesAlwaysVisible())
         {
            _loc6_.setNotesVisible(true);
         }
         if(!param4)
         {
            _loc6_.loading.hide();
         }
         if(param2 != null)
         {
            _loc6_.cache = _loc5_;
         }
         this.contents.addChild(_loc6_);
         Utils.addListener(_loc6_,MouseEvent.ROLL_OVER,this.showHelp);
         Utils.addListener(_loc6_,MouseEvent.ROLL_OUT,this.hideHelp);
         if(Main.isReadOnly())
         {
            Utils.addListener(_loc6_,MouseEvent.ROLL_OVER,this.readOnlyPanel);
         }
         else
         {
            Utils.addListener(_loc6_,MouseEvent.MOUSE_DOWN,this.onMousePress);
         }
         Utils.addListener(_loc6_,PixtonEvent.LOAD_PANEL,this.onLoadPanel);
         return _loc6_;
      }
      
      private function onLoadComplete() : void
      {
         stage.dispatchEvent(new PixtonEvent(PixtonEvent.LOAD_COMIC));
      }
      
      private function position(param1:int, param2:Object = null, param3:Boolean = false, param4:Boolean = true) : void
      {
         var _loc6_:Object = null;
         if(Main.canChangeRowHeight())
         {
            ComicLayout.updateLayout();
            return;
         }
         var _loc5_:Panel = Panel(this.panels[param1]);
         if(isFreestyle())
         {
            if(_loc5_ != null)
            {
               if(this.contents.getChildIndex(_loc5_) != param1)
               {
                  this.contents.setChildIndex(_loc5_,param1);
               }
               if(!isNaN(_loc5_.xp) && !isNaN(_loc5_.yp))
               {
                  this.updatePosition(_loc5_.xp,_loc5_.yp,_loc5_);
               }
            }
            Main.resizeStage();
         }
         else
         {
            if(param1 < 0 || param1 >= this.panels.length)
            {
               return;
            }
            _loc6_ = this.getNextPosition(param1 - 1,_loc5_,param2,param3);
            this.updatePosition(_loc6_.x,_loc6_.y,_loc5_);
            _loc5_.row = _loc6_.row;
            this.latestHeight = this.y + this.getPanelY(_loc5_) + _loc5_.getHeight() + 2;
            Main.resizeStage();
            if(param1 < this.panels.length - 1 && param4)
            {
               this.position(param1 + 1);
            }
         }
      }
      
      public function debugPanels() : void
      {
         var _loc1_:Panel = null;
         var _loc2_:uint = this.panels.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.panels[_loc3_] as Panel;
            _loc3_++;
         }
      }
      
      public function getSceneData() : Object
      {
         var _loc1_:Panel = null;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc2_:Object = {};
         if(this.index > -1 && this.panels.length > this.index)
         {
            _loc1_ = Panel(this.panels[this.index]);
            if(isFreestyle())
            {
               _loc2_.x = this.getPanelX(_loc1_);
               _loc2_.y = this.getPanelY(_loc1_);
            }
            else
            {
               _loc2_.x = this.x + this.getPanelX(_loc1_);
               _loc2_.y = this.y + this.getPanelY(_loc1_);
            }
            _loc2_.w = _loc1_.getWidth();
            _loc2_.h = _loc1_.getHeight();
            _loc2_.noImage = false;
         }
         else
         {
            _loc1_ = Panel(this.panels[this.panels.length - 1]);
            _loc4_ = this.getNextPosition(this.panels.length - 1,_loc1_,null,this.index == this.panels.length);
            if(isFreestyle())
            {
               _loc2_.x = _loc4_.x;
               _loc2_.y = _loc4_.y;
            }
            else
            {
               _loc2_.x = x + _loc4_.x;
               _loc2_.y = y + _loc4_.y;
            }
            _loc2_.w = _loc4_.width;
            _loc2_.h = _loc4_.height;
            _loc2_.noImage = true;
         }
         if(isFreestyle())
         {
            _loc2_.maxWidth = maxWidth;
         }
         else if(this.maxedRows(true))
         {
            _loc3_ = this.getLastRowIndex();
            _loc1_ = Panel(this.panels[_loc3_]);
            _loc2_.maxWidth = maxWidth - 1 - this.getPanelX(_loc1_) - _loc1_.getWidth();
            if(this.panels[this.index] != null)
            {
               _loc2_.maxWidth += Panel(this.panels[this.index]).getWidth();
            }
            else
            {
               _loc2_.maxWidth -= PADDING_H;
            }
         }
         else
         {
            _loc1_ = Panel(this.panels[this.index]);
            if(this.index < this.panels.length - 1 && _loc1_.row == maxRows - 1)
            {
               _loc3_ = this.getLastRowIndex();
               _loc2_.maxWidth = Math.round(maxWidth - (this.getPanelX(Panel(this.panels[_loc3_])) + Panel(this.panels[_loc3_]).width - this.getPanelX(Panel(this.panels[this.index + 1]))) - this.getPanelX(Panel(this.panels[this.index])) - PADDING_H);
            }
            else
            {
               _loc2_.maxWidth = maxWidth - _loc2_.x - 1 + x;
            }
         }
         _loc2_.index = this.index;
         return _loc2_;
      }
      
      private function getNextPosition(param1:int, param2:Panel = null, param3:Object = null, param4:Boolean = false) : Object
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:Panel = null;
         if(Main.isTimeline())
         {
            _loc10_ = param1 + 1;
            _loc5_ = (_loc11_ = (param1 + 1) % 2) * (maxWidth - defaultWidth);
            _loc6_ = _loc10_ * Math.round((Comic.PANEL_TITLE_HEIGHT + defaultHeight + Comic.PANEL_DESC_HEIGHT / Comic.DEFAULT_DESC_LINES * Comic.getDefDescLines()) / 2 + PADDING_V) + PANEL_TITLE_HEIGHT;
            _loc8_ = defaultWidth;
            _loc9_ = defaultHeight;
            _loc7_ = _loc10_;
         }
         else
         {
            if(param1 > -1 && param1 < this.panels.length)
            {
               _loc12_ = Panel(this.panels[param1]);
               _loc5_ = this.getPanelX(_loc12_) + (param3 == null || param3.width == null ? _loc12_.getWidth() : param3.width) + PADDING_H;
               _loc6_ = this.getPanelY(_loc12_);
               _loc7_ = _loc12_.row;
               if(param3 != null && param3.autoWidth != null)
               {
                  _loc8_ = param3.autoWidth;
               }
               else
               {
                  _loc8_ = param2 == null || param4 ? Number(_loc12_.getWidth()) : Number(param2.getWidth());
               }
               if(param3 != null)
               {
                  _loc9_ = param3.height;
               }
               else
               {
                  _loc9_ = param2 == null || param4 ? Number(_loc12_.getHeight()) : Number(param2.getHeight());
               }
               if(_loc5_ + _loc8_ > maxWidth && (!param4 || _loc5_ > maxWidth - minWidth))
               {
                  _loc5_ = 0;
                  if(_loc12_.getHeight() > 0)
                  {
                     _loc6_ += _loc12_.getHeight(true,false,Main.isTChart() || Main.isGrid());
                  }
                  else if(param3 != null)
                  {
                     _loc6_ += param3.height;
                  }
                  else
                  {
                     _loc6_ += defaultHeight;
                  }
                  _loc6_ += PADDING_V;
                  _loc7_ = _loc12_.row + 1;
               }
            }
            else
            {
               _loc5_ = 0;
               _loc6_ = getPanelTitleOffset();
               _loc7_ = 0;
               _loc8_ = defaultWidth;
               _loc9_ = defaultHeight;
            }
            _loc9_ += getHeightOffset();
         }
         return {
            "x":_loc5_,
            "y":_loc6_,
            "width":_loc8_,
            "height":_loc9_,
            "row":_loc7_
         };
      }
      
      public function hideCurrentScene() : void
      {
         if(this.index > -1 && this.panels.length > this.index)
         {
            this.setPanelVisible(Panel(this.panels[this.index]),false);
            this.autoHideNonVisibleElements();
            this.dirtyMargins();
         }
      }
      
      public function showCurrentScene() : void
      {
         if(this.index < 0 || this.index >= this.panels.length)
         {
            return;
         }
         this.setPanelVisible(Panel(this.panels[this.index]),true);
         this.autoHideNonVisibleElements();
         this.dirtyMargins();
      }
      
      public function resetCurrentScene() : void
      {
         if(this.index < 0 || this.index >= this.panels.length)
         {
            return;
         }
         Panel(this.panels[this.index]).reset();
      }
      
      public function isSaved() : Boolean
      {
         if(Team.isVisible && this.isLocked(null,false,true))
         {
            return true;
         }
         return key != "" && Team.isSaved() && (!Animation.isAvailable() || !Animation.getPrefsChanged());
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function setPanelKey(param1:String) : void
      {
         if(param1 != null)
         {
            this.index = Panel(this.map[param1]).index;
         }
      }
      
      public function getPanel(param1:String = null) : Panel
      {
         if(param1 == null)
         {
            param1 = this.getPanelKey();
         }
         if(this.map[param1] != null)
         {
            return Panel(this.map[param1]);
         }
         return null;
      }
      
      public function getPanelAt(param1:uint) : Panel
      {
         if(!this.panels || !this.panels[param1])
         {
            return null;
         }
         return Panel(this.panels[param1]);
      }
      
      public function getPanelVersion() : uint
      {
         var _loc1_:Panel = this.getPanel();
         return _loc1_.version;
      }
      
      public function getPanelKey() : String
      {
         if(this.index < 0 || this.panels[this.index] == null)
         {
            return null;
         }
         return Panel(this.panels[this.index]).key;
      }
      
      private function readOnlyPanel(param1:MouseEvent) : void
      {
         this._startPanel = Panel(param1.currentTarget);
         dispatchEvent(new PixtonEvent(PixtonEvent.EDIT_SCENE,this._startPanel.key));
      }
      
      private function onMousePress(param1:MouseEvent) : void
      {
         if(!Utils.mcContains(param1.target,AppSettings.self) && AppSettings.isVisible())
         {
            AppSettings.toggleShown();
            return;
         }
         if(Picker.isVisible() || Editor.self.currentTarget)
         {
            Editor.self.onClickAway();
            return;
         }
         this._hasScrolled = false;
         this._startPanel = Panel(param1.currentTarget);
         this._startPanelPress = new Point(param1.stageX,param1.stageY);
         this.timeout = setTimeout(this.startGhost,GHOST_DELAY,Panel(param1.currentTarget).key,{
            "localX":param1.localX,
            "localY":param1.localY,
            "stageX":param1.stageX,
            "stageY":param1.stageY
         });
         Utils.addListener(stage,MouseEvent.MOUSE_UP,this.onMouseRelease);
         Utils.addListener(stage,MouseEvent.MOUSE_MOVE,this._onMouseMove);
      }
      
      private function _onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         var _loc3_:Number = Point.distance(_loc2_,this._startPanelPress);
         if(_loc3_ > MAX_PRESS_MOVE)
         {
            this._hasScrolled = true;
         }
      }
      
      private function onMouseRelease(param1:MouseEvent) : void
      {
         Utils.removeListener(stage,MouseEvent.MOUSE_UP,this.onMouseRelease);
         Utils.removeListener(stage,MouseEvent.MOUSE_MOVE,this._onMouseMove);
         if(this._dragging || this._startPanel == null)
         {
            return;
         }
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         var _loc3_:Number = Point.distance(_loc2_,this._startPanelPress);
         clearTimeout(this.timeout);
         if(!this._hasScrolled)
         {
            dispatchEvent(new PixtonEvent(PixtonEvent.EDIT_SCENE,this._startPanel.key));
         }
         this._hasScrolled = false;
         this._startPanel = null;
         this._startPanelPress = null;
      }
      
      private function startGhost(param1:String, param2:Object) : void
      {
         if(Main.isScrolling)
         {
            return;
         }
         dispatchEvent(new PixtonEvent(PixtonEvent.PRESS_SCENE,param1,param2));
      }
      
      public function getImage(param1:String) : MovieClip
      {
         return this.getPanel(param1) as MovieClip;
      }
      
      public function numScenes() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.panels.length;
         var _loc3_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(Panel(this.panels[_loc1_]).key != null)
            {
               _loc3_++;
            }
            _loc1_++;
         }
         return _loc3_;
      }
      
      public function numSceneKeys() : uint
      {
         return this.panels.length;
      }
      
      private function repositionEditor() : void
      {
         var _loc1_:Panel = Panel(this.panels[this.index]);
         if(Main.displayManager.GET(Editor.self,DisplayManager.P_VIS) && _loc1_ != null)
         {
            Editor.self.setComicXY(this.getPanelX(_loc1_),this.getPanelY(_loc1_),false,true);
         }
      }
      
      public function repositionPanels(param1:Object = null, param2:Boolean = true) : void
      {
         if(param1 != null && this.panels[this.index] != null)
         {
            Panel(this.panels[this.index]).setWidth(param1.width);
            Panel(this.panels[this.index]).setHeight(param1.height);
         }
         if(param2 || param1 == null)
         {
            this.position(this.index + 1,param1);
         }
         else
         {
            this.position(this.index,param1);
         }
      }
      
      public function getEndPosition() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = this.panels.length - 1;
         this.updateMaxXY();
         if(isFreestyle())
         {
            if(_loc2_ < 0)
            {
               _loc1_ = {
                  "x":this.x + defaultWidth,
                  "y":this.y + defaultHeight
               };
            }
            else
            {
               _loc1_ = {
                  "x":this.x + this.maxX,
                  "y":this.y + this.maxY
               };
            }
         }
         else if(_loc2_ < 0)
         {
            _loc1_ = {
               "x":0,
               "y":0
            };
         }
         else
         {
            _loc1_ = {
               "x":this.x + this.getPanelX(this.panels[_loc2_]) + Panel(this.panels[_loc2_]).getWidth(),
               "y":this.y + this.getPanelY(this.panels[_loc2_]) + Panel(this.panels[_loc2_]).getHeight()
            };
         }
         this.latestHeight = _loc1_.y;
         return _loc1_;
      }
      
      public function maxedRows(param1:Boolean = false, param2:Boolean = false) : Boolean
      {
         var _loc5_:Panel = null;
         var _loc6_:Object = null;
         if(isFreestyle())
         {
            return false;
         }
         var _loc3_:uint = (!!hasPanelTitles() ? PANEL_TITLE_HEIGHT : 0) + (!!hasPanelDescriptions() ? PANEL_DESC_HEIGHT : 0);
         var _loc4_:uint = !!hasPanelTitles() ? uint(PANEL_TITLE_HEIGHT) : uint(0);
         if(param1)
         {
            if(this.panels.length == 0)
            {
               return false;
            }
            _loc5_ = Panel(this.panels[this.panels.length - 1]);
            if(param2)
            {
               return this.getPanelY(_loc5_) - _loc4_ > (defaultHeight + _loc3_ + PADDING_V) * (maxRows - 1);
            }
            return this.getPanelY(_loc5_) >= (defaultHeight + _loc3_ + PADDING_V) * (maxRows - 1);
         }
         _loc6_ = this.getNextPosition(this.panels.length - 1,null,null,false);
         if(param2)
         {
            return _loc6_.y > (defaultHeight + _loc3_ + PADDING_V) * maxRows;
         }
         return _loc6_.y >= (defaultHeight + _loc3_ + PADDING_V) * maxRows;
      }
      
      public function atEnd() : Boolean
      {
         return isFreestyle() || this.index >= this.panels.length - 1;
      }
      
      private function getLastRowIndex() : uint
      {
         var _loc1_:uint = this.index;
         if(_loc1_ == this.panels.length)
         {
            _loc1_--;
         }
         var _loc2_:Number = this.panels[_loc1_].y;
         var _loc3_:Number = _loc2_;
         var _loc4_:uint = _loc1_;
         while(_loc3_ == _loc2_)
         {
            if(++_loc4_ == this.panels.length)
            {
               break;
            }
            _loc3_ = this.panels[_loc4_].y;
         }
         return --_loc4_;
      }
      
      public function getMoveUpAllowance(param1:Object) : Boolean
      {
         if(this.index == 0 || this.panels[this.index - 1] == null || param1.width == null)
         {
            return false;
         }
         return maxWidth - this.getPanelX(this.panels[this.index - 1]) - Panel(this.panels[this.index - 1]).getWidth() - PADDING_H >= param1.width;
      }
      
      public function getInsertAllowance() : Number
      {
         var _loc1_:Boolean = this.maxedRows(true,true);
         if(_loc1_)
         {
            return 0;
         }
         _loc1_ = this.maxedRows(true);
         if(!_loc1_)
         {
            return maxWidth;
         }
         var _loc2_:uint = this.getLastRowIndex();
         var _loc3_:Number = maxWidth - PADDING_H - this.getPanelX(this.panels[_loc2_]) - Panel(this.panels[_loc2_]).getWidth();
         if(_loc3_ >= minWidth)
         {
            return _loc3_;
         }
         return 0;
      }
      
      public function insertScene(param1:Panel = null) : void
      {
         var _loc3_:Panel = null;
         var _loc2_:Number = this.getInsertAllowance();
         if(param1 == null)
         {
            _loc3_ = this.createPanelAt(this.index,Panel(this.panels[this.index]),_loc2_);
         }
         else
         {
            _loc3_ = param1;
         }
         this.insertPanel(this.index,_loc3_);
      }
      
      private function insertPanel(param1:uint, param2:Panel) : void
      {
         var _loc3_:uint = 0;
         this.panels.splice(param1,0,param2);
         var _loc4_:uint = this.panels.length;
         _loc3_ = param1 + 1;
         while(_loc3_ < _loc4_)
         {
            ++Panel(this.panels[_loc3_]).index;
            _loc3_++;
         }
         this.position(param1,null,true);
      }
      
      public function updatePanelState(param1:String, param2:Object) : void
      {
         var _loc3_:Panel = this.getPanel(param1);
         _loc3_.setWidth(param2.w);
         _loc3_.setHeight(param2.h);
         this.position(_loc3_.index);
      }
      
      public function deleteScene(param1:int = -1) : void
      {
         if(param1 == -2)
         {
            return;
         }
         if(param1 == -1)
         {
            param1 = this.index;
         }
         this.removePanel(param1);
         this.updateMap();
         Main.self.updateStage();
      }
      
      public function removePanel(param1:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1 == -1)
         {
            return;
         }
         if(this.panels[param1] == null)
         {
            return;
         }
         var _loc2_:Panel = Panel(this.panels[param1]);
         if(_loc2_.key != null)
         {
            updateLock(_loc2_.key);
            updateOpen(_loc2_.key);
         }
         if(_loc2_.parent)
         {
            this.contents.removeChild(_loc2_);
         }
         this.panels.splice(param1,1);
         _loc4_ = this.panels.length;
         _loc3_ = param1;
         while(_loc3_ < _loc4_)
         {
            --Panel(this.panels[_loc3_]).index;
            _loc3_++;
         }
         if(this.index >= param1)
         {
            --this.index;
         }
         this.position(param1);
      }
      
      public function isLastScene() : Boolean
      {
         return this.index >= this.panels.length - 1;
      }
      
      private function showHelp(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         if(Main.notesAlwaysVisible())
         {
            _loc2_ = param1.currentTarget as MovieClip;
            _loc2_.parent.setChildIndex(_loc2_,_loc2_.parent.numChildren - 1);
         }
         Help.show(L.text("click-edit"),param1.currentTarget,false);
      }
      
      private function hideHelp(param1:MouseEvent = null) : void
      {
         Help.hide();
      }
      
      public function setRelModTime(param1:Number) : void
      {
         if(this.panels[this.index] != null)
         {
            Panel(this.panels[this.index]).relModTime = param1;
         }
      }
      
      public function getRelModTime() : Number
      {
         if(this.panels[this.index] == null)
         {
            return -1;
         }
         return Panel(this.panels[this.index]).relModTime;
      }
      
      public function getCurrentY() : Number
      {
         if(this.panels[this.index] == null)
         {
            return defaultHeight * 0.5 + this.y;
         }
         return this.getPanelY(this.panels[this.index]) + Panel(this.panels[this.index]).getHeight() * 0.5 + this.y;
      }
      
      public function requireEdges() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.panels.length;
         var _loc3_:Number = maxWidth;
         var _loc4_:Number = 0;
         var _loc5_:Number = 1000000;
         var _loc6_:Number = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.getPanelX(this.panels[_loc1_]) < _loc3_)
            {
               _loc3_ = this.getPanelX(this.panels[_loc1_]);
            }
            if(this.getPanelX(this.panels[_loc1_]) + this.panels[_loc1_].width > _loc4_)
            {
               _loc4_ = this.getPanelX(this.panels[_loc1_]) + this.panels[_loc1_].width;
            }
            if(this.getPanelY(this.panels[_loc1_]) < _loc5_)
            {
               _loc5_ = this.getPanelY(this.panels[_loc1_]);
            }
            if(this.getPanelY(this.panels[_loc1_]) + this.panels[_loc1_].height > _loc6_)
            {
               _loc6_ = this.getPanelY(this.panels[_loc1_]) + this.panels[_loc1_].height;
            }
            _loc1_++;
         }
         edges = {
            "minX":_loc3_,
            "maxX":_loc4_,
            "minY":_loc5_,
            "maxY":_loc6_
         };
      }
      
      public function marginsMet() : Boolean
      {
         return true;
      }
      
      public function maxedScenes(param1:Object) : Boolean
      {
         if(isFreestyle())
         {
            return maxPanels > 0 && this.panels.length >= maxPanels;
         }
         if(this.panels != null && this.panels.length > 0 && this.getPanelY(this.panels[this.panels.length - 1]) + Panel(this.panels[this.panels.length - 1]).getHeight() + PADDING_V >= maxRows * (defaultHeight + PADDING_V))
         {
            return param1.x - this.x > maxWidth - minWidth;
         }
         return false;
      }
      
      public function updatePosition2(param1:String, param2:Object) : void
      {
         var _loc3_:Panel = this.getPanel(param1);
         if(_loc3_ == null)
         {
            return;
         }
         this.updatePosition(param2.x,param2.y,_loc3_,true);
         Main.self.updateStage();
      }
      
      public function updatePosition(param1:int, param2:int, param3:Panel = null, param4:Boolean = false) : void
      {
         if(param3 == null)
         {
            param3 = Panel(this.panels[this.index]);
         }
         if(param3 == null)
         {
            return;
         }
         if(Main.isPregenRender())
         {
            this.setPanelX(param3,0);
            this.setPanelY(param3,0);
         }
         else if(isFreestyle())
         {
            param3.xp = param1;
            param3.yp = param2;
            if(param4)
            {
               Main.self.savePosition(param3.key,param1,param2);
               this.setCache({
                  "xp":param1,
                  "yp":param2
               },param3.key,true);
            }
         }
         else
         {
            this.setPanelX(param3,param1);
            this.setPanelY(param3,param2);
         }
         this.drawMargins();
         this.updateBkgd();
      }
      
      public function canSaveBkgd() : Boolean
      {
         return Main.isTemplatesUser() && Main.self.team.getTitle().match(/^mind-map-/);
      }
      
      private function updateBkgd() : void
      {
         var _loc2_:Panel = null;
         var _loc3_:uint = 0;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         if(!(Main.isMindMap() || Main.isTimeline() || this.canSaveBkgd()) || Utils.empty(this.panels) || this.panels.length < 2)
         {
            return;
         }
         if(!this.bkgd)
         {
            this.bkgd = new MovieClip();
            this.addChildAt(this.bkgd,0);
         }
         var _loc1_:Graphics = this.bkgd.graphics;
         _loc1_.clear();
         var _loc4_:uint = this.panels.length;
         if(Main.isMindMap() || this.canSaveBkgd())
         {
            _loc2_ = this.panels[0] as Panel;
            _loc6_ = new Point(this.getPanelX(_loc2_) + _loc2_.getWidth() / 2,this.getPanelY(_loc2_) - _loc2_.getHeight() / 2);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc2_ = this.panels[_loc3_];
               if(_loc3_ > 0)
               {
                  _loc5_ = new Point(this.getPanelX(_loc2_) + _loc2_.getWidth() / 2,this.getPanelY(_loc2_) + _loc2_.getHeight(true,true) / 2);
                  _loc1_.lineStyle(LINE_THICKNESS + LINE_PADDING * 2,16777215,LINE_ALPHA);
                  _loc1_.moveTo(_loc6_.x,_loc6_.y);
                  _loc1_.lineTo(_loc5_.x,_loc5_.y);
                  _loc1_.lineStyle(LINE_THICKNESS,0,LINE_ALPHA);
                  _loc1_.moveTo(_loc6_.x,_loc6_.y);
                  _loc1_.lineTo(_loc5_.x,_loc5_.y);
               }
               _loc3_++;
            }
         }
         else if(Main.isTimeline())
         {
            _loc7_ = uint.MAX_VALUE;
            _loc8_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc2_ = this.panels[_loc3_];
               if(Main.displayManager.GET(_loc2_,DisplayManager.P_VIS))
               {
                  _loc9_ = Math.round(this.getPanelY(_loc2_) + _loc2_.getHeight(true,true) / 2);
                  _loc7_ = Math.min(_loc7_,_loc9_);
                  _loc8_ = Math.max(_loc8_,_loc9_);
               }
               _loc3_++;
            }
            _loc7_ -= Math.round(defaultHeight / 2);
            _loc8_ += Math.round(defaultHeight / 2);
            _loc6_ = new Point(maxWidth / 2,_loc7_);
            _loc5_ = new Point(maxWidth / 2,_loc8_);
            this.bkgd.y = _loc7_;
            _loc1_.lineStyle(LINE_THICKNESS + LINE_PADDING * 2,16777215,LINE_ALPHA,false,"normal","none");
            _loc1_.moveTo(_loc6_.x,_loc6_.y - _loc7_);
            _loc1_.lineTo(_loc5_.x,_loc5_.y - _loc7_);
            _loc1_.lineStyle(LINE_THICKNESS,0,LINE_ALPHA,false,"normal","none");
            _loc1_.moveTo(_loc6_.x,_loc6_.y - _loc7_);
            _loc1_.lineTo(_loc5_.x,_loc5_.y - _loc7_);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc2_ = this.panels[_loc3_];
               if(Main.displayManager.GET(_loc2_,DisplayManager.P_VIS))
               {
                  _loc9_ = Math.round(this.getPanelY(_loc2_) + _loc2_.getHeight(true,true) / 2);
                  _loc6_ = new Point(this.getPanelX(_loc2_) + _loc2_.getWidth() / 2,_loc9_);
                  if(_loc3_ % 2 == 0)
                  {
                     _loc5_ = new Point(maxWidth / 2 - LINE_THICKNESS / 2 - LINE_PADDING,_loc9_);
                  }
                  else
                  {
                     _loc5_ = new Point(maxWidth / 2 + LINE_THICKNESS / 2 + LINE_PADDING,_loc9_);
                  }
                  _loc1_.lineStyle(LINE_THICKNESS + LINE_PADDING * 2,16777215,LINE_ALPHA,false,"normal","none");
                  _loc1_.moveTo(_loc6_.x,_loc6_.y - _loc7_);
                  _loc1_.lineTo(_loc5_.x,_loc5_.y - _loc7_);
                  if(_loc3_ % 2 == 0)
                  {
                     _loc5_ = new Point(maxWidth / 2 - LINE_THICKNESS / 2,_loc9_);
                  }
                  else
                  {
                     _loc5_ = new Point(maxWidth / 2 + LINE_THICKNESS / 2,_loc9_);
                  }
                  _loc1_.lineStyle(LINE_THICKNESS,0,LINE_ALPHA,false,"normal","none");
                  _loc1_.moveTo(_loc6_.x,_loc6_.y - _loc7_);
                  _loc1_.lineTo(_loc5_.x,_loc5_.y - _loc7_);
               }
               _loc3_++;
            }
         }
      }
      
      public function dirtyMargins() : void
      {
         this._pageBottomYListDirty = true;
         this._visiblePage = -1;
      }
      
      public function drawMargins() : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Array = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         if(!showMargins || !Main.comicRendered)
         {
            return;
         }
         if(!this.marginsMC)
         {
            this.marginsMC = new MovieClip();
            this.marginsMC.mouseChildren = false;
            this.marginsMC.mouseEnabled = false;
            this.addChildAt(this.marginsMC,0);
         }
         var _loc1_:Graphics = this.marginsMC.graphics;
         if(!AppSettings.getActive(AppSettings.PAGES) || this.panels.length == 0)
         {
            this.txtHeight.visible = false;
            this.txtPage.visible = false;
            _loc1_.clear();
            return;
         }
         var _loc2_:Number = Printing.getPageLength(maxWidth);
         var _loc3_:Number = Math.floor(_loc2_ / Editor.GRID_SIZE) * Editor.GRID_SIZE;
         var _loc5_:Number;
         var _loc6_:Number = (_loc5_ = Number(Main.stageTopY - this.y)) + Main.stageVisibleHeight;
         if(this._pageBottomYListDirty)
         {
            _loc7_ = -Printing.titleHeight;
            _loc8_ = 0;
            _loc9_ = 0;
            _loc10_ = -_loc7_;
            _loc12_ = [];
            _loc14_ = this.panels.length;
            _loc13_ = 0;
            while(_loc13_ < _loc14_)
            {
               _loc9_ = (_loc11_ = this.getPanelY(this.panels[_loc13_])) + Panel(this.panels[_loc13_]).getHeight();
               _loc12_.push({
                  "topY":_loc11_,
                  "bottomY":_loc9_
               });
               _loc13_++;
            }
            this._pageBottomYList = [];
            _loc16_ = null;
            _loc12_.sortOn("bottomY",Array.NUMERIC);
            _loc14_ = _loc12_.length;
            _loc13_ = 0;
            while(_loc13_ < _loc14_)
            {
               _loc10_ = (_loc15_ = _loc12_[_loc13_]).bottomY - _loc7_;
               if(_loc16_ != null && _loc10_ > _loc2_)
               {
                  this._pageBottomYList.push(_loc16_.bottomY);
                  _loc7_ = _loc15_.topY;
               }
               _loc16_ = _loc15_;
               _loc13_++;
            }
            if(this._pageBottomYList[this._pageBottomYList.length - 1] != _loc15_.bottomY)
            {
               this._pageBottomYList.push(_loc15_.bottomY);
            }
            this._pageBottomYListDirty = false;
         }
         if(this._pageBottomYList && this._pageBottomYList.length > 0)
         {
            _loc17_ = PADDING_V;
            _loc18_ = -1;
            _loc14_ = this._pageBottomYList.length;
            _loc13_ = 0;
            while(_loc13_ < _loc14_)
            {
               if(this._pageBottomYList[_loc13_] > _loc5_ && this._pageBottomYList[_loc13_] < _loc6_)
               {
                  _loc18_ = _loc13_;
                  break;
               }
               _loc13_++;
            }
            if(_loc18_ >= 0 && _loc18_ != this._visiblePage)
            {
               _loc19_ = Main.getLeftX();
               _loc20_ = Main.getRightX();
               if(_loc18_ > 0)
               {
                  _loc21_ = this._pageBottomYList[_loc18_] - this._pageBottomYList[_loc18_ - 1] - PADDING_V;
               }
               else
               {
                  _loc21_ = this._pageBottomYList[_loc18_] + Printing.titleHeight;
               }
               if(_loc21_ > 30)
               {
                  _loc22_ = _loc21_ >= _loc3_ ? Number(2) : Number(1);
                  _loc23_ = this._pageBottomYList[_loc18_] - getPanelTitleOffset();
                  this.txtPage.alpha = this.txtHeight.alpha = 0.5 * _loc22_;
                  _loc1_.clear();
                  _loc1_.beginFill(Palette.colorLinkStr,0.25 * _loc22_);
                  _loc1_.moveTo(_loc19_,_loc23_ + 1);
                  _loc1_.lineTo(_loc20_,_loc23_ + 1);
                  _loc1_.lineTo(_loc20_,_loc23_ + PADDING_V);
                  _loc1_.lineTo(_loc19_,_loc23_ + PADDING_V);
                  _loc1_.lineTo(_loc19_,_loc23_ + 1);
                  _loc1_.endFill();
                  this.txtHeight.text = L.text("page-marker",_loc18_ + 1,"").replace(", ","").replace("%","") + "/" + this._pageBottomYList.length;
                  this.txtHeight.y = _loc23_ - this.txtHeight.height - 3;
                  this.txtHeight.x = Math.max(maxWidth + _loc17_ + 28,_loc20_ - this.txtHeight.width - _loc17_);
                  this.txtHeight.visible = true;
                  this.txtPage.text = _loc21_ == _loc3_ ? "✓" : _loc21_ - _loc3_ + "px";
                  this.txtPage.y = this.txtHeight.y;
                  this.txtPage.x = Math.min(-(_loc17_ + 28),_loc19_ + _loc17_);
                  this.txtPage.visible = Main.canChangeRowHeight() || isFreestyle(true);
                  if(!this.txtHeight.parent)
                  {
                     this.addChild(this.txtHeight);
                  }
                  if(!this.txtPage.parent)
                  {
                     this.addChild(this.txtPage);
                  }
                  this._visiblePage = _loc18_;
               }
            }
         }
      }
      
      private function updateMaxXY() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:uint = this.panels.length;
         this.maxX = 0;
         this.maxY = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if((_loc4_ = this.getPanelX(this.panels[_loc1_]) + Panel(this.panels[_loc1_]).getWidth()) > this.maxX)
            {
               this.maxX = _loc4_;
            }
            _loc3_ = this.getPanelY(this.panels[_loc1_]) + Panel(this.panels[_loc1_]).getHeight();
            if(_loc3_ > this.maxY)
            {
               this.maxY = _loc3_;
            }
            _loc1_++;
         }
         this.maxY += Printing.titleHeight;
         this.drawMargins();
      }
      
      function movePanel(param1:String, param2:Ghost, param3:Boolean, param4:int = -1) : void
      {
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc11_:uint = 0;
         var _loc12_:Point = null;
         var _loc13_:uint = 0;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:Panel = null;
         var _loc19_:Boolean = false;
         var _loc8_:uint = this.getPanel(param1).index;
         var _loc9_:Panel = Panel(this.panels[_loc8_]);
         var _loc10_:Boolean = param4 > -1 && _loc8_ != param4;
         this.setPanelVisible(_loc9_,param3);
         this.autoHideNonVisibleElements();
         this.dirtyMargins();
         if(isFreestyle())
         {
            _loc5_ = new Point(param2.topLeft.x,param2.topLeft.y);
            _loc6_ = param2.localToGlobal(_loc5_);
            _loc7_ = this.contents.globalToLocal(_loc6_);
            if(!Main.controlPressed)
            {
               _loc7_.x = Math.round(_loc7_.x / Editor.GRID_SIZE) * Editor.GRID_SIZE;
               _loc7_.y = Math.round(_loc7_.y / Editor.GRID_SIZE) * Editor.GRID_SIZE;
            }
            _loc7_.x = Utils.limit(_loc7_.x,0,maxWidth - _loc9_.getWidth());
            _loc7_.y = Utils.limit(_loc7_.y,0,maxRows * Printing.getPageLength(maxWidth) - _loc9_.getHeight());
            this.updatePosition(_loc7_.x,_loc7_.y,_loc9_,param3);
            _loc6_ = this.contents.localToGlobal(_loc7_);
            _loc5_ = param2.parent.globalToLocal(_loc6_);
            param2.x = _loc5_.x - param2.topLeft.x;
            param2.y = _loc5_.y - param2.topLeft.y;
            if(param3)
            {
               Team.onChange(Comic.key,param1,Team.P_PANEL_XY,null,{
                  "x":_loc7_.x,
                  "y":_loc7_.y
               });
            }
         }
         else
         {
            _loc11_ = _loc8_;
            _loc5_ = new Point(param2.topLeft.x + param2.width * 0.5,param2.topLeft.y + param2.height * 0.5);
            _loc6_ = param2.localToGlobal(_loc5_);
            _loc7_ = this.contents.globalToLocal(_loc6_);
            _loc17_ = this.panels.length;
            _loc19_ = false;
            _loc16_ = 0;
            while(_loc16_ < _loc17_)
            {
               _loc18_ = Panel(this.panels[_loc16_]);
               _loc12_ = new Point(this.getPanelX(_loc18_) + _loc18_.getWidth() * 0.5,this.getPanelY(_loc18_) + _loc18_.getHeight() * 0.5);
               _loc15_ = Point.distance(_loc7_,_loc12_);
               if(isNaN(_loc14_) || _loc15_ < _loc14_)
               {
                  _loc14_ = _loc15_;
                  _loc13_ = _loc16_;
               }
               _loc16_++;
            }
            _loc11_ = _loc13_;
            if(param3 && _loc10_ && this.maxedRows(true,true))
            {
               _loc19_ = true;
               _loc11_ = param4;
            }
            if(_loc19_ || !param3 && _loc11_ != _loc8_)
            {
               this.panels.splice(_loc8_,1);
               this.panels.splice(_loc11_,0,_loc9_);
               _loc16_ = 0;
               while(_loc16_ < _loc17_)
               {
                  (_loc18_ = Panel(this.panels[_loc16_])).index = _loc16_;
                  _loc16_++;
               }
               this.position(Math.min(_loc8_,_loc11_));
            }
            if(param3)
            {
               if(_loc10_)
               {
                  this.savePanelOrder();
                  this.savePanelSizes();
               }
            }
         }
         Main.self.updateStage();
      }
      
      function rearrange(param1:Boolean, param2:int) : void
      {
         var _loc3_:Panel = Panel(this.panels[this.index]);
         var _loc4_:uint = this.index + param2;
         if(this.panels[_loc4_] == null)
         {
            return;
         }
         var _loc5_:Panel = Panel(this.panels[_loc4_]);
         this.panels.splice(_loc3_.index,1,_loc5_);
         this.panels.splice(_loc5_.index,1,_loc3_);
         Utils.rearrange(_loc3_ as DisplayObject,param1,param2,_loc5_ as DisplayObject,Panel);
         this.savePanelOrder();
         this.index = _loc3_.index;
      }
      
      public function updateIndex(param1:String, param2:uint) : void
      {
         var _loc3_:String = this.getPanelKey();
         var _loc4_:int = this.getIndex(param1);
         if(param2 == _loc4_)
         {
            return;
         }
         if(_loc4_ == -1 || this.panels[param2] == null || this.panels[_loc4_] == null)
         {
            return;
         }
         var _loc5_:Panel = this.panels[param2];
         this.panels[param2] = this.panels[_loc4_];
         this.panels[_loc4_] = _loc5_;
         Panel(this.panels[param2]).index = param2;
         Panel(this.panels[_loc4_]).index = _loc4_;
         this.position(Math.min(param2,_loc4_));
         this.setPanelKey(_loc3_);
      }
      
      private function savePanelOrder() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.panels.length;
         var _loc3_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            Panel(this.panels[_loc1_]).index = _loc1_;
            _loc3_.push(Panel(this.panels[_loc1_]).key);
            _loc1_++;
         }
         Main.self.savePanelOrder(_loc3_);
         this.updateMap();
      }
      
      public function setCacheByIndex(param1:Object, param2:uint) : void
      {
         var _loc3_:String = Panel(this.panels[param2]).key;
         this.setCache(param1,_loc3_);
      }
      
      public function updatePanelSizes(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc2_:uint = param1.length;
         for each(_loc3_ in param1)
         {
            this.setPanelData(_loc3_,_loc3_.key);
         }
         this.position(0);
         Main.self.repositionEditor();
      }
      
      public function setPanelData(param1:Object, param2:String = null) : void
      {
         if(param2 == null)
         {
            param2 = this.getPanelKey();
         }
         if(param2 == null)
         {
            return;
         }
         var _loc3_:Panel = this.getPanel(param2);
         _loc3_.setWidth(param1.w);
         _loc3_.setHeight(param1.h);
         _loc3_.resetTempWidth();
         _loc3_.resetTempHeight();
         _loc3_.updateImageSize();
         if(param1.xp != null)
         {
            _loc3_.xp = param1.xp;
            _loc3_.yp = param1.yp;
         }
      }
      
      function setCache(param1:Object, param2:String = null, param3:Boolean = false) : void
      {
         var _loc5_:* = null;
         if(param2 == null)
         {
            param2 = this.getPanelKey();
         }
         if(param2 == null)
         {
            return;
         }
         var _loc4_:Panel = this.getPanel(param2);
         param1.im = 0;
         param1.m = -1;
         if(param3)
         {
            if(_loc4_.cache != null)
            {
               for(_loc5_ in param1)
               {
                  _loc4_.cache[_loc5_] = param1[_loc5_];
               }
            }
         }
         else
         {
            _loc4_.cache = param1;
         }
      }
      
      function getCacheByIndex(param1:int = -1) : Object
      {
         if(param1 == -1)
         {
            param1 = this.index;
         }
         var _loc2_:Panel = Panel(this.panels[param1]);
         if(_loc2_ == null)
         {
            return null;
         }
         return this.getCache(_loc2_.key);
      }
      
      function getCache(param1:String = null) : Object
      {
         var _loc2_:Panel = null;
         if(param1 == null)
         {
            param1 = this.getPanelKey();
         }
         if(param1 == null)
         {
            _loc2_ = this.panels[this.index] as Panel;
         }
         else
         {
            _loc2_ = this.getPanel(param1);
         }
         return _loc2_ != null ? _loc2_.cache : null;
      }
      
      function hasPanel(param1:String = null) : Boolean
      {
         if(param1 == null)
         {
            param1 = this.getPanelKey();
         }
         var _loc2_:Panel = this.getPanel(param1);
         return _loc2_ != null;
      }
      
      function hasCache(param1:String = null) : Boolean
      {
         if(param1 == null)
         {
            param1 = this.getPanelKey();
         }
         var _loc2_:Panel = this.getPanel(param1);
         return _loc2_ != null && _loc2_.cache != null;
      }
      
      public function getIndex(param1:String = null, param2:Boolean = false) : int
      {
         var _loc3_:Panel = this.getPanel(param1);
         if(_loc3_ == null)
         {
            return !!param2 ? -2 : -1;
         }
         return _loc3_.index;
      }
      
      function resetCache() : void
      {
         var _loc2_:Panel = null;
         var _loc1_:String = this.getPanelKey();
         for each(_loc2_ in this.panels)
         {
            if(_loc2_.key != _loc1_)
            {
               _loc2_.resetCache();
            }
         }
      }
      
      function updateNumbers() : void
      {
         var _loc1_:Panel = null;
         for each(_loc1_ in this.panels)
         {
            _loc1_.updateNumber();
         }
      }
      
      function triggerLockUpdates() : void
      {
         var _loc1_:Panel = null;
         for each(_loc1_ in this.panels)
         {
            Team.triggerUpdate(key,_loc1_.key,Team.P_PANEL_LOCK);
         }
      }
      
      function triggerLockUpdate() : void
      {
         var _loc1_:String = this.getPanelKey();
         Team.triggerUpdate(key,_loc1_,Team.P_PANEL_LOCK);
      }
      
      function isLocked(param1:String = null, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         if(param1 == null)
         {
            param1 = this.getPanelKey();
         }
         var _loc4_:Panel;
         if((_loc4_ = this.getPanel(param1)) == null)
         {
            return false;
         }
         if(param2)
         {
            return _panelLocks[param1] != null && _panelLocks[param1].s == Main.sessionID;
         }
         if(param3)
         {
            return _panelLocks[param1] != null && _panelLocks[param1].s != Main.sessionID;
         }
         return _panelLocks[param1] != null;
      }
      
      public function checkLock() : void
      {
         var _loc1_:Panel = this.getPanel();
         if(_loc1_ && _loc1_.locked)
         {
            updateLock(_loc1_.getKey(),_loc1_.locked);
         }
      }
      
      function updateVersion(param1:String, param2:uint) : *
      {
         var _loc3_:Panel = this.getPanel(param1);
         if(_loc3_ == null)
         {
            Main.loadNewScene(param1);
         }
         else if(param2 != _loc3_.version)
         {
            _loc3_.version = param2;
            _loc3_.loadImage();
         }
      }
      
      private function onLoadPanel(param1:PixtonEvent) : void
      {
         ++this.panelsLoaded;
         this.checkPanelsLoaded();
      }
      
      private function checkPanelsLoaded() : void
      {
         if(this.panelsLoaded >= this.panelsToLoad)
         {
            this.onLoadComplete();
         }
      }
      
      public function addNewScene(param1:Object, param2:int = -1) : void
      {
         var _loc3_:Panel = null;
         if(param2 == -1)
         {
            param2 = this.panels.length;
         }
         param1.o = param2;
         _loc3_ = this.createPanel(param1);
         this.insertPanel(param2,_loc3_);
         this.updateMap();
         _loc3_.loadImage();
      }
      
      public function addNewScenes(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc5_:Object = null;
         var _loc2_:uint = this.panels.length;
         var _loc4_:Boolean = false;
         for each(_loc5_ in param1.scenes)
         {
            _loc3_ = parseInt(_loc5_.o) - 1;
            _loc2_ = Math.min(_loc2_,_loc3_);
            this.addNewScene(_loc5_,_loc3_);
            if(_loc3_ <= this.index)
            {
               _loc4_ = true;
            }
         }
         this.position(_loc2_);
         if(_loc4_)
         {
            ++this.index;
            Main.self.repositionEditor();
         }
         Main.self.updateStage();
      }
      
      function setEditKey(param1:String) : void
      {
         this._editKey = param1;
      }
      
      function getEditKey() : String
      {
         return this._editKey;
      }
      
      public function autoHideNonVisibleElements() : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:DisplayObject = null;
         var _loc1_:Number = Main.stageTopY - this.y;
         var _loc2_:Number = _loc1_ - Main.AUTO_HIDE_PADDING;
         var _loc3_:Number = _loc1_ + Main.stageVisibleHeight + Main.AUTO_HIDE_PADDING;
         if(!this.txtHeight.visible || this.txtHeight.y + this.txtHeight.height < _loc2_ || this.txtHeight.y > _loc3_)
         {
            if(this.txtHeight.parent)
            {
               this.txtHeight.parent.removeChild(this.txtHeight);
            }
         }
         else if(this.txtHeight.visible && !this.txtHeight.parent)
         {
            this.addChild(this.txtHeight);
         }
         if(!this.contents)
         {
            return;
         }
         displayManager.clear();
         _loc5_ = this.contents.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if((_loc6_ = this.contents.getChildAt(_loc4_)).y + _loc6_.height < _loc2_ || _loc6_.y > _loc3_)
            {
               displayManager.addItem(_loc6_,_loc2_);
            }
            _loc4_++;
         }
         if(Main.isTimeline())
         {
            self.updateBkgd();
         }
         this.drawMargins();
      }
      
      public function savePanelSizes() : void
      {
         var _loc2_:Panel = null;
         var _loc1_:uint = this.panels.length;
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc1_)
         {
            _loc2_ = this.panels[_loc4_] as Panel;
            if(_loc2_.index != this.index)
            {
               if(_loc2_.hasTempWidth() || _loc2_.hasTempHeight())
               {
                  _loc3_.push({
                     "key":_loc2_.getKey(),
                     "w":_loc2_.getWidth(),
                     "h":_loc2_.getHeight()
                  });
                  _loc2_.resetTempWidth(true);
                  _loc2_.resetTempHeight(true);
               }
            }
            _loc4_++;
         }
         if(_loc3_.length > 0)
         {
            Utils.remote("saveSceneSizes",Utils.mergeObjects({"panels":_loc3_},this.getIDData()),this.onSavePanelSizes);
            Team.onChange(Comic.key,null,Team.P_PANEL_SIZES,null,_loc3_);
         }
      }
      
      public function resetPanelSizes() : void
      {
         var _loc2_:Panel = null;
         var _loc1_:uint = this.panels.length;
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc1_)
         {
            _loc2_ = this.panels[_loc4_] as Panel;
            _loc2_.resetTempWidth();
            _loc2_.resetTempHeight();
            _loc4_++;
         }
      }
      
      private function onSavePanelSizes(param1:Object) : void
      {
      }
      
      public function setPanelPositions(param1:Array) : void
      {
         var _loc3_:Panel = null;
         if(this.panels.length != param1.length)
         {
            return;
         }
         var _loc2_:uint = this.panels.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this.panels[_loc4_] as Panel;
            _loc3_.update(param1[_loc4_]);
            Main.self.savePosition(_loc3_.key,param1[_loc4_].xp,param1[_loc4_].yp);
            this.setCache({
               "xp":param1[_loc4_].xp,
               "yp":param1[_loc4_].yp,
               "w":param1[_loc4_].w,
               "h":param1[_loc4_].h,
               "descLen":param1[_loc4_].descLen
            },_loc3_.key,true);
            Team.onChange(Comic.key,_loc3_.key,Team.P_PANEL_XY,null,{
               "x":param1[_loc4_].xp,
               "y":param1[_loc4_].yp,
               "w":param1[_loc4_].w,
               "h":param1[_loc4_].h
            });
            _loc4_++;
         }
         this.updateBkgd();
      }
   }
}
