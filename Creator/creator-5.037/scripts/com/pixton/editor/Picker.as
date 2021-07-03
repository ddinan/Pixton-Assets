package com.pixton.editor
{
   import com.pixton.character.BodyPart;
   import com.pixton.character.BodyParts;
   import com.pixton.designer.Designer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   
   public final class Picker
   {
      
      public static var ITEM_WIDTH:Number = 59;
      
      public static var ITEM_HEIGHT:Number = 72;
      
      public static var ITEM_HEIGHT_2:Number = 64;
      
      public static var ITEM_HEIGHT_3:Number = 119;
      
      public static var ITEM_WIDTH_BODY_PART:Number = 25;
      
      public static var ITEM_HEIGHT_BODY_PART:Number = 90;
      
      public static var ITEM_WIDTH_SMALL:Number = 45;
      
      public static var ITEM_HEIGHT_SMALL:Number = 45;
      
      public static var ITEM_WIDTH_BKGD:Number = 128;
      
      public static var ITEM_HEIGHT_BKGD:Number = 87;
      
      public static var COLOR_GRID_SIZE:Number = 16;
      
      public static const OFFSET_X:Number = 3;
      
      public static const BKGD_PADDING:Number = 3;
      
      public static var PALETTE_WIDTH:Number = 230;
      
      private static const PICKER_OFFSET:Number = 10;
      
      private static const MAX_COLS:uint = 6;
      
      private static const MAX_COLS_PROPS:uint = 5;
      
      private static const MAX_COLS_BKGDS:uint = 4;
      
      private static const MAX_ROWS:uint = 4;
      
      private static const LONG_COLS:uint = 6;
      
      private static const LONG_ROWS:uint = 3;
      
      private static const SEARCHING:Boolean = true;
      
      private static const BKGD_WIDTH:Number = 245;
      
      private static const SEARCH_THRESHOLD:uint = 1500;
      
      private static const NO_RESULTS_SPACING:Number = 111;
      
      public static var NAVIGATION_HEIGHT:Number = 46;
      
      public static var target:MovieClip;
      
      public static var bkgd:MovieClip;
      
      public static var clickMode:Boolean;
      
      public static var type:int;
      
      public static var subType:uint;
      
      private static var selectedTarget:Object;
      
      private static var obj:Object;
      
      private static var bodyPart:BodyPart;
      
      private static var bodyPart2:BodyPart;
      
      private static var itemContainer:MovieClip;
      
      public static var navigation:MovieClip;
      
      public static var itemContainerDynamic:MovieClip;
      
      private static var charType:uint;
      
      private static var colorList:Array;
      
      private static var inputText:InputText;
      
      private static var txtMsg:TextField;
      
      private static var recentEvent:Object;
      
      private static var btnNewC:MovieClip;
      
      private static var btnUpload:MovieClip;
      
      private static var btnFlickr:MovieClip;
      
      private static var btnGoogle:MovieClip;
      
      private static var btnRandom:MovieClip;
      
      private static var btnHide:MovieClip;
      
      private static var btnNew:Array;
      
      private static var btnPrev:EditorButton;
      
      private static var btnNext:EditorButton;
      
      public static var btnBack:EditorButton;
      
      public static var btnForward:EditorButton;
      
      public static var btnSearch:EditorButton;
      
      private static var border:MovieClip;
      
      private static var hilite:MovieClip;
      
      private static var data:Object;
      
      public static var select:Select;
      
      private static var selectGrid:SelectGrid;
      
      private static var pool:int;
      
      private static var poolValue:int;
      
      private static var pendingItem:PickerItem;
      
      private static var recentItem:PickerItem;
      
      private static var hideTarget:int;
      
      private static var timeout:int = -1;
      
      private static var doSearchTimeout:Boolean = false;
      
      private static var _recentType:int = -1;
      
      private static var _recentOffset:int = -1;
      
      private static var _recentSearch:String;
      
      private static var _searched:Object = {};
      
      private static const MANY_OPTIONS:uint = 100;
       
      
      public function Picker()
      {
         super();
      }
      
      public static function init(param1:MovieClip) : *
      {
         Picker.target = param1;
         Main.displayManager.SET(param1,DisplayManager.P_VIS,false);
         itemContainer = param1.itemContainer;
         itemContainerDynamic = itemContainer.contents;
         navigation = param1.navigation;
         txtMsg = param1.txtMsg;
         hilite = new MovieClip();
         hilite.mouseEnabled = false;
         param1.addChild(hilite);
         btnPrev = navigation.btnPrev;
         btnNext = navigation.btnNext;
         btnSearch = navigation.btnSearch;
         inputText = navigation.inputText;
         inputText.setMaxChars(32);
         btnSearch.setHandler(onButton,false);
         btnSearch.enable();
         btnBack = param1.btnBack;
         btnForward = param1.btnForward;
         if(Main.isCharCreate())
         {
            btnBack.setHandler(onButton,false);
            btnForward.setHandler(onButton,false);
            btnForward.makePriority();
         }
         border = param1.border;
         bkgd = param1.bkgd;
         btnNewC = itemContainer.btnNewC;
         btnUpload = itemContainer.btnUpload;
         btnFlickr = itemContainer.btnFlickr;
         btnGoogle = itemContainer.btnGoogle;
         btnRandom = itemContainer.btnRandom;
         select = param1.select;
         selectGrid = param1.selectGrid;
         btnHide = param1.btnHide;
         Utils.useHand(btnHide);
         Utils.addListener(select,PixtonEvent.CLICK,onSelect);
         Utils.addListener(selectGrid,PixtonEvent.CLICK,onSelect);
         Utils.addListener(btnHide,MouseEvent.CLICK,onButton);
      }
      
      public static function getRect(param1:MovieClip) : Rectangle
      {
         var _loc2_:Rectangle = select.getRect(param1);
         if(selectGrid.visible)
         {
            _loc2_ = _loc2_.union(selectGrid.getRect(param1));
         }
         return _loc2_;
      }
      
      static function initButtons() : void
      {
         var _loc1_:MovieClip = null;
         btnNew = [btnNewC,btnUpload,btnFlickr,btnGoogle,btnRandom];
         btnNew = Utils.mergeArrays(btnNew,PhotoSet.getButtons());
         for each(_loc1_ in btnNew)
         {
            itemContainer.addChild(_loc1_);
            Utils.useHand(_loc1_);
            _loc1_.mouseChildren = false;
         }
      }
      
      public static function updateColor() : void
      {
         btnPrev.updateColor();
         btnNext.updateColor();
         btnBack.updateColor();
         btnForward.updateColor();
         btnSearch.updateColor();
         select.updateColor();
      }
      
      public static function load(param1:uint, param2:Object, param3:Object = null, param4:Boolean = false, param5:int = 0, param6:int = 0, param7:Boolean = false) : void
      {
         var i:uint = 0;
         var n:uint = 0;
         var item:PickerItem = null;
         var cols:uint = 0;
         var minCols:int = 0;
         var rows:uint = 0;
         var listData:Object = null;
         var list:Array = null;
         var targetClass:Class = null;
         var targetClass2:Class = null;
         var hiliteItems:Array = null;
         var targetType:uint = 0;
         var subType:uint = 0;
         var targetMode:uint = 0;
         var thisX:Number = NaN;
         var thisY:Number = NaN;
         var locked:Boolean = false;
         var lock:Object = null;
         var options:Object = null;
         var button:MovieClip = null;
         var toDuplicate:MovieClip = null;
         var itemRatio:Number = NaN;
         var packData:Object = null;
         var packList:Array = null;
         var categoryList:Array = null;
         var pack:PropPack = null;
         var toDuplicate2:MovieClip = null;
         var ratio:Number = NaN;
         var y0:uint = 0;
         var y1:uint = 0;
         var x0:uint = 0;
         var x1:uint = 0;
         var inputWidth:uint = 0;
         var g:Graphics = null;
         var bkgdX1:Number = NaN;
         var bkgdX2:Number = NaN;
         var bkgdY1:Number = NaN;
         var bkgdY2:Number = NaN;
         var pickerOffset:Number = NaN;
         var type:uint = param1;
         var data:Object = param2;
         var obj:Object = param3;
         var firstRun:Boolean = param4;
         var pool:int = param5;
         var poolValue:int = param6;
         var keepAlive:Boolean = param7;
         var hasMine:Boolean = false;
         var allLocked:Boolean = false;
         var hasPresets:Boolean = false;
         var itemWidth:uint = ITEM_WIDTH;
         var itemHeight:uint = ITEM_HEIGHT;
         var maxX:Number = 0;
         var maxY:Number = 0;
         var selectList:Array = [];
         pendingItem = null;
         hideTarget = NaN;
         txtMsg.visible = false;
         if(firstRun)
         {
            hide(false,keepAlive);
            inputText.text = L.text("help-default");
         }
         if(data.type != null)
         {
            subType = data.type;
         }
         if(Utils.empty(data.search))
         {
            data.search = null;
         }
         if(data.offset == null || data.offset < 0)
         {
            data.offset = 0;
         }
         if(type == _recentType && pool == Pixton.POOL_COMMUNITY && data.paging == null && data.search == null)
         {
            data.search = _recentSearch;
            data.offset = _recentOffset;
            if(data.search)
            {
               inputText.text = data.search;
            }
         }
         _recentType = type;
         _recentSearch = data.search;
         _recentOffset = data.offset;
         for each(button in btnNew)
         {
            button.visible = (type == Globals.PHOTOS || type == Globals.BODY_PHOTOS) && button is PhotoSetButton;
         }
         if(_searched[type] == null)
         {
            _searched[type] = {};
         }
         btnHide.visible = false;
         btnPrev.alpha = Main.BUTTON_ALPHA;
         btnPrev.mouseChildren = false;
         btnNext.alpha = Main.BUTTON_ALPHA;
         btnNext.mouseChildren = false;
         btnPrev.visible = true;
         btnNext.visible = true;
         btnSearch.visible = false;
         btnBack.visible = false;
         btnForward.visible = false;
         clickMode = true;
         if(firstRun)
         {
            select.visible = false;
            selectGrid.visible = false;
         }
         selectGrid.visible = selectGrid.visible && type == Globals.PROPS && Utils.empty(data.search) && pool == Pixton.POOL_PACK;
         var numVisibleButtons:uint = 0;
         doSearchTimeout = pool != Pixton.POOL_COMMUNITY;
         minCols = -1;
         switch(type)
         {
            case Globals.PROPSETS:
               cols = MAX_COLS_BKGDS;
               minCols = 2;
               rows = 3;
               itemWidth = ITEM_WIDTH_BKGD;
               itemHeight = ITEM_HEIGHT_BKGD;
               inputText.visible = true;
               btnSearch.visible = true;
               hasMine = PropSet.has(Pixton.POOL_MINE,subType);
               hasPresets = PropSet.has(Pixton.POOL_PRESET,subType);
               numVisibleButtons = getNumVisibleButtons();
               data.numPerPage = rows * cols;
               if(firstRun)
               {
                  if(subType == PropSet.BACKGROUND)
                  {
                     selectList.push([L.text("preset-b-sets"),Pixton.POOL_PRESET]);
                     if(!Template.isActive())
                     {
                        if(PropSet.COMMUNITY_VISIBLE)
                        {
                           selectList.push([PropSet.COMMUNITY_LABEL,Pixton.POOL_COMMUNITY]);
                        }
                        if(AppSettings.isAdvanced)
                        {
                           selectList.push([L.text("my-b-sets"),Pixton.POOL_MINE]);
                        }
                     }
                     select.setData(selectList);
                  }
                  else
                  {
                     selectList.push([L.text("preset-sets"),Pixton.POOL_PRESET]);
                     if(PropSet.COMMUNITY_VISIBLE)
                     {
                        selectList.push([PropSet.COMMUNITY_LABEL,Pixton.POOL_COMMUNITY]);
                     }
                     if(AppSettings.isAdvanced)
                     {
                        selectList.push([L.text("my-sets"),Pixton.POOL_MINE]);
                     }
                     select.setData(selectList);
                  }
                  select.setSelected(pool);
               }
               if(Utils.empty(data.search) && !(pool == Pixton.POOL_MINE && !FeatureTrial.can(FeatureTrial.PROP_GROUPING)))
               {
                  PropSet.lastPool = pool;
               }
               if(pool == Pixton.POOL_COMMUNITY)
               {
                  if(!Utils.empty(data.search))
                  {
                     if(data.search.length < Main.QUERY_MIN_LENGTH)
                     {
                        Confirm.alert("error-search-len",true,Main.QUERY_MIN_LENGTH);
                        return;
                     }
                     if(!PropSet.searched(data.search))
                     {
                        PropSet.setSearched(data.search);
                        Asset.loadFromServer("loadPropsDyn",function(param1:Object):void
                        {
                           if(!Main.handleError(param1))
                           {
                              return;
                           }
                           if(param1.errorResults)
                           {
                              data.error = param1.errorResults;
                              PropSet.setSearched(data.search,data.error);
                           }
                           else
                           {
                              PropSet.setData(param1,false);
                           }
                           load(type,data,obj,false,pool,poolValue);
                        },{
                           "text":data.search,
                           "type":subType
                        });
                        return;
                     }
                     data.error = PropSet.getSearchError(data.search);
                  }
                  else if(!PropSet.getCommunityLoaded(subType))
                  {
                     PropSet.setCommunityLoaded(subType);
                     Asset.loadFromServer("loadPropsDyn",function(param1:Object):void
                     {
                        if(!Main.handleError(param1))
                        {
                           return;
                        }
                        PropSet.setData(param1,false);
                        load(type,data,obj,false,pool,poolValue);
                     },{"type":subType});
                     return;
                  }
               }
               if(Utils.empty(data.search))
               {
                  listData = PropSet.getList(pool,subType,data.offset,data.numPerPage,data.setting);
               }
               else
               {
                  listData = PropSet.searchList(pool == Pixton.POOL_PACK ? uint(Pixton.POOL_ALL) : uint(pool),subType,data.search,data.offset,data.numPerPage);
                  data.search = listData.search;
                  inputText.text = data.search;
               }
               list = listData.array;
               if(listData.showPrev)
               {
                  btnPrev.alpha = 1;
                  btnPrev.useHandCursor = true;
                  btnPrev.mouseChildren = true;
               }
               if(listData.showNext)
               {
                  btnNext.alpha = 1;
                  btnNext.useHandCursor = true;
                  btnNext.mouseChildren = true;
               }
               n = list.length;
               if(!Utils.empty(data.search) && type == Globals.PROPSETS && pool == Pixton.POOL_PRESET && !_searched[type][data.search])
               {
                  Utils.remote("logSearch",{
                     "type":type,
                     "q":data.search,
                     "n":listData.total
                  });
                  _searched[type][data.search] = true;
               }
               if(n == 0 && pool == Pixton.POOL_MINE && !FeatureTrial.can(FeatureTrial.PROP_GROUPING))
               {
                  Main.promptUpgrade(FeatureTrial.PROP_GROUPING);
               }
               break;
            case Globals.PROPS:
               if(firstRun)
               {
                  hasMine = PropSet.has(Pixton.POOL_MINE,PropSet.OBJECT);
                  selectList.push([L.text("all-props",Style.getName()),Pixton.POOL_PACK]);
                  if(PropSet.COMMUNITY_VISIBLE)
                  {
                     selectList.push([PropSet.COMMUNITY_LABEL,Pixton.POOL_COMMUNITY]);
                  }
                  if(AppSettings.isAdvanced && !Template.isActive())
                  {
                     selectList.push([L.text("my-props"),Pixton.POOL_MINE]);
                  }
                  select.setData(selectList);
                  select.setSelected(pool);
               }
               if(Utils.empty(data.search) && !(pool == Pixton.POOL_MINE && !FeatureTrial.can(FeatureTrial.PROP_GROUPING)))
               {
                  Prop.lastPool = pool;
               }
               if(pool == Pixton.POOL_COMMUNITY)
               {
                  if(!Utils.empty(data.search))
                  {
                     if(data.search.length < Main.QUERY_MIN_LENGTH)
                     {
                        Confirm.alert("error-search-len",true,Main.QUERY_MIN_LENGTH);
                        return;
                     }
                     if(!Prop.searched(data.search))
                     {
                        Prop.setSearched(data.search);
                        Asset.loadFromServer("loadPropsDyn",function(param1:Object):void
                        {
                           if(!Main.handleError(param1))
                           {
                              return;
                           }
                           if(param1.errorResults)
                           {
                              data.error = param1.errorResults;
                              PropSet.setSearched(data.search,data.error);
                           }
                           else
                           {
                              PropSet.setData(param1,false);
                           }
                           load(type,data,obj,false,pool,poolValue);
                        },{
                           "text":data.search,
                           "type":PropSet.OBJECT
                        });
                        return;
                     }
                     data.error = PropSet.getSearchError(data.search);
                  }
                  else if(!PropSet.getCommunityLoaded(PropSet.OBJECT))
                  {
                     PropSet.setCommunityLoaded(PropSet.OBJECT);
                     Asset.loadFromServer("loadPropsDyn",function(param1:Object):void
                     {
                        if(!Main.handleError(param1))
                        {
                           return;
                        }
                        PropSet.setData(param1,false);
                        load(type,data,obj,false,pool,poolValue);
                     },{"type":PropSet.OBJECT});
                     return;
                  }
               }
               if(pool == Pixton.POOL_PACK)
               {
                  if(!selectGrid.visible)
                  {
                     packData = Prop.getList(Pixton.POOL_CATEGORIES,0,0,-1);
                     packList = packData.list as Array;
                     if(packList.length > 0)
                     {
                        categoryList = [];
                        for each(pack in packList)
                        {
                           categoryList.push([pack.getName(),pack.id]);
                        }
                        selectGrid.setData(categoryList);
                     }
                  }
                  selectGrid.setSelected(poolValue);
                  if(poolValue == -1)
                  {
                     poolValue = selectGrid.value;
                  }
               }
               cols = MAX_COLS_PROPS;
               if(pool == Pixton.POOL_COMMUNITY || pool == Pixton.POOL_MINE)
               {
                  rows = 3;
                  itemWidth = ITEM_WIDTH_BKGD;
                  itemHeight = ITEM_HEIGHT_BKGD;
               }
               else
               {
                  rows = MAX_ROWS;
                  itemHeight = ITEM_HEIGHT_2;
               }
               numVisibleButtons = getNumVisibleButtons();
               data.numPerPage = rows * cols;
               inputText.visible = !Template.isActive();
               btnSearch.visible = !Template.isActive();
               if(Template.isActive() && !data.offset)
               {
                  btnPrev.visible = btnNext.visible = false;
               }
               if(pool == Pixton.POOL_MINE && !FeatureTrial.can(FeatureTrial.PROP_GROUPING))
               {
                  Main.promptUpgrade(FeatureTrial.PROP_GROUPING);
                  list = [];
               }
               else
               {
                  if(Utils.empty(data.search))
                  {
                     listData = Prop.getList(pool,poolValue,data.offset,data.numPerPage);
                     if(pool == Pixton.POOL_PACK)
                     {
                        PropPack.lastPoolValue = poolValue;
                        if(data.offset == 0)
                        {
                           listData.showPrev = true;
                        }
                     }
                  }
                  else
                  {
                     selectGrid.deselect();
                     listData = Prop.searchList(pool,poolValue,data.search,data.offset,data.numPerPage);
                     data.search = listData.search;
                     inputText.text = data.search;
                  }
                  list = listData.array;
                  if(listData.showPrev)
                  {
                     btnPrev.alpha = 1;
                     btnPrev.useHandCursor = true;
                     btnPrev.mouseChildren = true;
                  }
                  if(listData.showNext)
                  {
                     btnNext.alpha = 1;
                     btnNext.useHandCursor = true;
                     btnNext.mouseChildren = true;
                  }
               }
               n = list.length;
               if(!Utils.empty(data.search) && pool == Pixton.POOL_PACK && !_searched[type][data.search])
               {
                  Utils.remote("logSearch",{
                     "type":type,
                     "q":data.search,
                     "n":listData.total
                  });
                  _searched[type][data.search] = true;
               }
               break;
            case Globals.PHOTOS:
            case Globals.BODY_PHOTOS:
               if(data.offset == 0 && Utils.empty(data.search))
               {
                  btnUpload.visible = !(Main.isSchools() && !Globals.isFullVersion());
                  btnFlickr.visible = btnUpload.visible && PhotoSet.isVisible("flickr");
                  btnGoogle.visible = btnUpload.visible && PhotoSet.isVisible("google");
               }
               cols = MAX_COLS;
               rows = MAX_ROWS;
               numVisibleButtons = getNumVisibleButtons();
               data.numPerPage = rows * cols - numVisibleButtons;
               itemHeight = ITEM_HEIGHT_2;
               inputText.visible = true;
               btnSearch.visible = true;
               if(Utils.empty(data.search))
               {
                  listData = PropPhoto.getList(Pixton.POOL_MINE,data.offset,data.numPerPage);
               }
               else
               {
                  listData = PropPhoto.searchList(Pixton.POOL_MINE,data.search,data.offset,data.numPerPage);
                  data.search = listData.search;
                  inputText.text = data.search;
               }
               list = listData.array;
               if(listData.showPrev)
               {
                  btnPrev.alpha = 1;
                  btnPrev.useHandCursor = true;
                  btnPrev.mouseChildren = true;
               }
               if(listData.showNext)
               {
                  btnNext.alpha = 1;
                  btnNext.useHandCursor = true;
                  btnNext.mouseChildren = true;
               }
               n = list.length;
               break;
            case Globals.OUTFITS:
               cols = LONG_COLS;
               rows = LONG_ROWS;
               itemHeight = ITEM_HEIGHT_3;
               inputText.visible = true;
               btnSearch.visible = true;
               hasPresets = Character.has(Pixton.POOL_PRESET_OUTFIT);
               allLocked = SkinManager.allLocked();
               pool = Pixton.POOL_PRESET_OUTFIT;
               if(firstRun)
               {
                  if(hasPresets)
                  {
                     selectList.push([L.text("preset-outfits"),Pixton.POOL_PRESET_OUTFIT]);
                  }
                  select.setData(selectList);
               }
               select.setSelected(pool);
               data.numPerPage = rows * cols;
               if(Utils.empty(data.search))
               {
                  Outfit.lastPool = pool;
               }
               if(Utils.empty(data.search))
               {
                  listData = Character.getList(pool,data.offset,data.numPerPage);
               }
               else
               {
                  listData = Character.searchList(pool,data.search,data.offset,data.numPerPage);
                  data.search = listData.search;
                  inputText.text = data.search;
               }
               list = listData.array;
               if(listData.showPrev)
               {
                  btnPrev.alpha = 1;
                  btnPrev.useHandCursor = true;
                  btnPrev.mouseChildren = true;
               }
               if(listData.showNext)
               {
                  btnNext.alpha = 1;
                  btnNext.useHandCursor = true;
                  btnNext.mouseChildren = true;
               }
               n = list.length;
               if(_searched[type] == null)
               {
                  _searched[type] = {};
               }
               if(!Utils.empty(data.search) && pool == Pixton.POOL_PRESET_OUTFIT && !_searched[type][data.search])
               {
                  Utils.remote("logSearch",{
                     "type":type,
                     "q":data.search,
                     "n":listData.total
                  });
                  _searched[type][data.search] = true;
               }
               break;
            case Globals.CHARACTERS:
               cols = LONG_COLS;
               rows = LONG_ROWS;
               itemHeight = ITEM_HEIGHT_3;
               inputText.visible = true;
               btnSearch.visible = true;
               hasMine = Character.has(Pixton.POOL_MINE);
               hasPresets = Character.has(Pixton.POOL_PRESET);
               allLocked = SkinManager.allLocked();
               if(allLocked && !Character.isEditor() || !hasMine && !AppSettings.isAdvanced)
               {
                  pool = Pixton.POOL_PRESET;
               }
               if(firstRun)
               {
                  if(!allLocked || Character.isEditor())
                  {
                     if(AppSettings.isAdvanced && data.skinType == null && !Comic.presetCharsOnly)
                     {
                        selectList.push([L.text("new-c"),Pixton.POOL_NEW]);
                     }
                     if(hasMine || AppSettings.isAdvanced)
                     {
                        selectList.push([L.text("my-char"),Pixton.POOL_MINE]);
                     }
                  }
                  if(hasPresets)
                  {
                     selectList.push([L.text("preset-char"),Pixton.POOL_PRESET]);
                     if(Character.has(Pixton.POOL_PRESET_2))
                     {
                        selectList.push([L.text("preset-char-2"),Pixton.POOL_PRESET_2]);
                     }
                  }
                  if(!allLocked && Character.COMMUNITY_VISIBLE)
                  {
                     selectList.push([L.text("community"),Pixton.POOL_COMMUNITY]);
                  }
                  select.setData(selectList);
               }
               select.setSelected(pool);
               if(Utils.empty(data.offset) && Utils.empty(data.search) && pool == Pixton.POOL_MINE && AppSettings.isAdvanced && data.skinType == null && !Comic.presetCharsOnly)
               {
                  btnNewC.visible = true;
               }
               numVisibleButtons = getNumVisibleButtons();
               data.numPerPage = rows * cols - numVisibleButtons;
               if(Utils.empty(data.search) && pool != Pixton.POOL_NEW)
               {
                  Character.lastPool = pool;
               }
               if(pool == Pixton.POOL_COMMUNITY)
               {
                  if(!Utils.empty(data.search))
                  {
                     if(data.search.length < Main.QUERY_MIN_LENGTH)
                     {
                        Confirm.alert("error-search-len",true,Main.QUERY_MIN_LENGTH);
                        return;
                     }
                     if(!Character.searched(data.search))
                     {
                        Character.setSearched(data.search);
                        Asset.loadFromServer("loadCommunityCharacters",function(param1:Object):void
                        {
                           if(!Main.handleError(param1))
                           {
                              return;
                           }
                           if(param1.errorResults)
                           {
                              data.error = param1.errorResults;
                              Character.setSearched(data.search,data.error);
                           }
                           else
                           {
                              Character.setData(param1,false);
                           }
                           load(type,data,obj,false,pool,poolValue);
                        },{"text":data.search});
                        return;
                     }
                     data.error = Character.getSearchError(data.search);
                  }
                  else if(!Character.communityLoaded)
                  {
                     Character.communityLoaded = true;
                     Asset.loadFromServer("loadCommunityCharacters",function(param1:Object):void
                     {
                        if(!Main.handleError(param1))
                        {
                           return;
                        }
                        Character.setData(param1,false);
                        load(type,data,obj,false,pool,poolValue);
                     });
                     return;
                  }
               }
               if(Utils.empty(data.search))
               {
                  listData = Character.getList(pool,data.offset,data.numPerPage,data.skinType == null ? -1 : int(data.skinType),data.excludeIDs);
                  if(pool == Pixton.POOL_MINE && listData.array.length == 0)
                  {
                     pool = Pixton.POOL_PRESET;
                     select.setSelected(pool);
                     listData = Character.getList(pool,data.offset,data.numPerPage,data.skinType == null ? -1 : int(data.skinType),data.excludeIDs);
                  }
               }
               else
               {
                  listData = Character.searchList(pool,data.search,data.offset,data.numPerPage,data.skinType == null ? -1 : int(data.skinType));
                  data.search = listData.search;
                  inputText.text = data.search;
               }
               list = listData.array;
               if(listData.showPrev)
               {
                  btnPrev.alpha = 1;
                  btnPrev.useHandCursor = true;
                  btnPrev.mouseChildren = true;
               }
               if(listData.showNext)
               {
                  btnNext.alpha = 1;
                  btnNext.useHandCursor = true;
                  btnNext.mouseChildren = true;
               }
               n = list.length;
               if(!Utils.empty(data.search) && pool == Pixton.POOL_PRESET && !_searched[type][data.search])
               {
                  Utils.remote("logSearch",{
                     "type":type,
                     "q":data.search,
                     "n":listData.total
                  });
                  _searched[type][data.search] = true;
               }
               break;
            case Globals.SEQUENCES:
               break;
            case Globals.POSES:
            case Globals.FACES:
               targetType = Pixton.getTargetType(obj);
               subType = obj is Character ? uint(Character(obj).skinType) : uint(0);
               if(firstRun)
               {
                  hasMine = Pose.has(Pixton.POOL_MINE,targetType,subType,type) && FeatureTrial.can(FeatureTrial.SAVE_POSES);
                  hasPresets = Pose.has(Pixton.POOL_PRESET,targetType,subType,type);
                  if(hasMine && hasPresets)
                  {
                     select.setData([[L.text(type == Globals.POSES ? "my-poses" : "my-faces"),Pixton.POOL_MINE],[L.text(type == Globals.POSES ? "preset-poses" : "preset-faces"),Pixton.POOL_PRESET]]);
                     select.setSelected(pool);
                  }
                  else if(hasMine)
                  {
                     pool = Pixton.POOL_MINE;
                  }
                  else
                  {
                     pool = Pixton.POOL_PRESET;
                  }
               }
               if(Utils.empty(data.search))
               {
                  if(type == Globals.POSES)
                  {
                     Pose.lastPoolPose = pool;
                  }
                  else
                  {
                     Pose.lastPoolFace = pool;
                  }
               }
               cols = MAX_COLS;
               rows = MAX_ROWS;
               if(type == Globals.POSES || type == Globals.FACES)
               {
                  itemHeight = ITEM_HEIGHT_2;
               }
               numVisibleButtons = getNumVisibleButtons();
               data.numPerPage = rows * cols - numVisibleButtons;
               inputText.visible = true;
               btnSearch.visible = true;
               if(Utils.empty(data.search))
               {
                  listData = Pose.getList(pool,targetType,subType,type,data.offset,data.numPerPage);
               }
               else
               {
                  listData = Pose.searchList(pool,targetType,subType,type,data.search,data.offset,data.numPerPage);
                  data.search = listData.search;
                  inputText.text = data.search;
               }
               list = listData.array;
               if(listData.showPrev)
               {
                  btnPrev.alpha = 1;
                  btnPrev.useHandCursor = true;
                  btnPrev.mouseChildren = true;
               }
               if(listData.showNext)
               {
                  btnNext.alpha = 1;
                  btnNext.useHandCursor = true;
                  btnNext.mouseChildren = true;
               }
               n = list.length;
               if(!Utils.empty(data.search) && pool == Pixton.POOL_PRESET && !_searched[type][data.search])
               {
                  Utils.remote("logSearch",{
                     "type":type,
                     "q":data.search,
                     "n":listData.total
                  });
                  _searched[type][data.search] = true;
               }
               break;
            case Globals.LOOKS:
            case Globals.EXPRESSION:
               btnPrev.visible = btnNext.visible = false;
               bodyPart = data.bodyPart as BodyPart;
               toDuplicate = bodyPart.target as MovieClip;
               targetClass = Character.getTargetClass(toDuplicate);
               if(data.bodyPart2 != null)
               {
                  bodyPart2 = data.bodyPart2 as BodyPart;
                  toDuplicate2 = bodyPart2.target as MovieClip;
                  targetClass2 = Character.getTargetClass(toDuplicate2);
               }
               else
               {
                  bodyPart2 = null;
                  targetClass2 = null;
               }
               if(type == Globals.LOOKS)
               {
                  charType = Editor.MODE_LOOKS;
                  n = bodyPart.numLooks;
               }
               else
               {
                  charType = Editor.MODE_EXPR;
                  n = bodyPart.numExpressions;
               }
               if(Character(obj).skinType == Globals.HUMAN && (data.basePart == "arm" || data.basePart == "leg"))
               {
                  itemWidth = ITEM_WIDTH_BODY_PART;
                  itemHeight = ITEM_HEIGHT_BODY_PART;
                  cols = Math.ceil(n / 2);
               }
               else
               {
                  if(n >= 30 && !Main.isSavingPoses())
                  {
                     itemWidth = ITEM_WIDTH_SMALL;
                     itemHeight = ITEM_HEIGHT_SMALL;
                  }
                  if(n > MANY_OPTIONS)
                  {
                     cols = 14;
                  }
                  else if(n >= 32)
                  {
                     cols = 8;
                  }
                  else if(n > 16)
                  {
                     cols = 6;
                  }
                  else if(n % 5 == 0)
                  {
                     cols = 5;
                  }
                  else if(n % 4 == 0)
                  {
                     cols = 4;
                  }
                  else if(n % 3 == 0)
                  {
                     cols = 3;
                  }
                  else
                  {
                     cols = MAX_COLS;
                  }
               }
               inputText.visible = false;
               break;
            case Globals.BKGD_GRADIENT:
               btnPrev.visible = btnNext.visible = false;
               n = Palette.NUM_GRADIENTS;
               cols = MAX_COLS;
               inputText.visible = false;
               itemWidth = ITEM_WIDTH_SMALL;
               itemHeight = ITEM_HEIGHT_SMALL;
               break;
            case Globals.BUBBLE_SHAPE:
            case Globals.BUBBLE_SPIKE:
               btnPrev.visible = btnNext.visible = false;
               if(type == Globals.BUBBLE_SHAPE)
               {
                  n = Dialog.NUM_SHAPES - 2;
               }
               else
               {
                  n = Dialog.NUM_SPIKES;
               }
               cols = Math.ceil(Math.sqrt(n));
               inputText.visible = false;
               break;
            case Globals.BORDER_SHAPE:
               btnPrev.visible = btnNext.visible = false;
               n = Border.NUM_SHAPES;
               cols = Math.ceil(Math.sqrt(n));
               inputText.visible = false;
               break;
            case Globals.BORDER_SIZE:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(Border.SIZE_MIN,Border.SIZE_MAX);
               Zoomer(data.slider).value = Border(obj).thickness;
               inputText.visible = false;
               break;
            case Globals.PANEL_SATURATION:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(-10,5);
               Zoomer(data.slider).value = Border(obj).getSaturation();
               inputText.visible = false;
               break;
            case Globals.PANEL_BRIGHTNESS:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(-5,5);
               Zoomer(data.slider).value = Border(obj).getBrightness();
               inputText.visible = false;
               break;
            case Globals.PANEL_CONTRAST:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(-5,5);
               Zoomer(data.slider).value = Border(obj).getContrast();
               inputText.visible = false;
               break;
            case Globals.LINE_ALPHA:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(3,10);
               Zoomer(data.slider).value = Editor(obj).getLineAlpha() * 10;
               inputText.visible = false;
               break;
            case Globals.BUBBLE_BORDER:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(Dialog.BORDER_SIZE_MIN,Dialog.BORDER_SIZE_MAX);
               Zoomer(data.slider).value = Dialog(obj).borderSize;
               inputText.visible = false;
               break;
            case Globals.ALPHA:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(Prop.ALPHA_MIN,Prop.ALPHA_MAX);
               Zoomer(data.slider).value = Prop(obj).getAlpha();
               inputText.visible = false;
               break;
            case Globals.FONT_FACE:
               btnPrev.visible = btnNext.visible = false;
               n = Fonts.getNum();
               if(!AppSettings.isAdvanced && n > 6)
               {
                  n = 6;
               }
               cols = Math.ceil(n / 10);
               itemWidth = 112;
               itemHeight = 28;
               inputText.visible = false;
               break;
            case Globals.FONT_SIZE:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(Dialog.FONT_SIZE_MIN,Dialog.FONT_SIZE_MAX);
               Zoomer(data.slider).value = Dialog(obj).getFontSize();
               inputText.visible = false;
               break;
            case Globals.LEADING:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(Dialog.LEADING_MIN,Dialog.LEADING_MAX);
               Zoomer(data.slider).value = Dialog(obj).getLeading();
               inputText.visible = false;
               break;
            case Globals.PADDING:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(Dialog.PADDING_MIN,Dialog.PADDING_MAX);
               Zoomer(data.slider).value = Dialog(obj).getPadding();
               inputText.visible = false;
               break;
            case Globals.EFFECTS:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(data.min,data.max);
               if(!(data.target is Array))
               {
                  data.target = [data.target];
               }
               Zoomer(data.slider).value = FX(data.fx).getFilter(data.target[0],data.id);
               inputText.visible = false;
               break;
            case Globals.GLOW_AMOUNT:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(FX.GLOW_AMOUNT_MIN,FX.GLOW_AMOUNT_MAX,true);
               Zoomer(data.slider).value = Asset(obj).getGlowAmount();
               inputText.visible = false;
               break;
            case Globals.BLUR_AMOUNT:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(FX.BLUR_AMOUNT_MIN,FX.BLUR_AMOUNT_MAX,false);
               Zoomer(data.slider).value = Asset(obj).getBlurAmount();
               inputText.visible = false;
               break;
            case Globals.BLUR_ANGLE:
               btnPrev.visible = btnNext.visible = false;
               n = 0;
               Zoomer(data.slider).setRange(FX.BLUR_ANGLE_MIN,FX.BLUR_ANGLE_MAX);
               Zoomer(data.slider).value = Asset(obj).getBlurAngle();
               inputText.visible = false;
               break;
            case Globals.DESIGNER:
               btnPrev.visible = true;
               btnNext.visible = true;
               inputText.visible = false;
               btnBack.visible = true;
               btnForward.visible = true;
               btnBack.visible = !Designer.getInstance().isFirst();
               btnForward.visible = !Designer.getInstance().isLast();
               Main.self.onUpdateDesigner(!btnForward.visible);
               if(data.color != null)
               {
                  if(data.list != null)
                  {
                     colorList = data.list;
                  }
                  else if(data.color == Globals.SKIN_COLOR)
                  {
                     colorList = Palette.getColorsByType(Palette.SKIN);
                  }
                  else if(data.color == Globals.HAIR_COLOR)
                  {
                     colorList = Palette.getColorsByType(Palette.HAIR);
                  }
                  else
                  {
                     colorList = Palette.getColorsByType(Palette.OTHER);
                  }
                  n = colorList.length;
               }
               else if(data.part != null)
               {
                  bodyPart = data.bodyPart as BodyPart;
                  if(data.list != null)
                  {
                     if(data.stretch == null && !Utils.inArray(Character(obj).bodyParts.getPart(data.part).look,data.list))
                     {
                        data.list.unshift(Character(obj).bodyParts.getPart(data.part).look);
                     }
                     list = data.list;
                     n = list.length;
                  }
                  else
                  {
                     n = bodyPart.numLooks;
                  }
               }
               else if(data.outfit != null)
               {
                  if(data.list != null)
                  {
                     list = data.list;
                     n = list.length;
                  }
                  else
                  {
                     listData = Character.getList(Pixton.POOL_PRESET_OUTFIT,0,36);
                     list = listData.array;
                     list.unshift(Character(obj).getID());
                     n = list.length;
                     if(data.max != null && n > data.max)
                     {
                        Utils.shuffle(list);
                        list = list.slice(0,data.max);
                        n = list.length;
                     }
                  }
               }
               else if(data.size != null)
               {
                  list = data.list;
                  n = list.length;
               }
               if(data.zoom != null)
               {
                  if(data.ratio != null)
                  {
                     itemRatio = data.ratio;
                  }
                  else
                  {
                     itemRatio = Designer.WH_RATIO;
                  }
               }
               else
               {
                  itemRatio = Comic.defaultWidth / Comic.defaultHeight;
               }
               if(n == 9)
               {
                  rows = 3;
               }
               else if(n == 3)
               {
                  rows = 1;
               }
               else if(n <= 8 && n % 2 == 0)
               {
                  rows = 2;
               }
               else
               {
                  ratio = Designer.FIXED_WIDTH / (Editor.self.bkgd.height * itemRatio);
                  rows = Math.ceil(Math.sqrt(n / ratio));
               }
               cols = Math.ceil(n / rows);
               itemHeight = Math.floor(Designer.FIXED_HEIGHT / rows);
               itemWidth = Math.floor(Designer.FIXED_WIDTH / cols);
               data.numPerPage = rows * cols;
               break;
            default:
               if(type == Globals.SKIN_COLOR && data.colorRange == null)
               {
                  hiliteItems = [0,0.5];
               }
               else if(type == Globals.HAIR_COLOR)
               {
                  hiliteItems = [0.5,1];
               }
               bodyPart = data.bodyPart == null ? null : data.bodyPart as BodyPart;
               btnPrev.visible = btnNext.visible = false;
               clickMode = false;
               if(data.colorRange != null)
               {
                  colorList = Palette.getColorsByRange(data.colorRange);
               }
               else
               {
                  colorList = Palette.getColors(obj is Photo || obj is Character && !Character(obj).silhouette && Character(obj).isLockedLooks() || obj is Editor && Main.ALLOW_TRANSPARENT_BKGD || bodyPart != null && bodyPart.hasImages() || type == Globals.ASSET_COLOR && !(obj is Prop && !(obj is PropSet) && !Prop(obj).hasTransparentFills(data.type)));
               }
               n = colorList.length;
               cols = 24;
               itemWidth = COLOR_GRID_SIZE;
               itemHeight = COLOR_GRID_SIZE;
               inputText.visible = false;
         }
         if(minCols == -1)
         {
            minCols = cols;
         }
         itemContainer.x = 0;
         itemContainer.y = 0;
         var nextLine:Boolean = false;
         navigation.x = itemContainer.x;
         var currentX:Number = 0;
         var currentY:Number = 0;
         if(select.visible)
         {
            currentY = Select.FIXED_HEIGHT;
         }
         var j:uint = 0;
         for each(button in btnNew)
         {
            if(button.visible)
            {
               button.x = currentX;
               button.y = currentY;
               maxX = Math.max(maxX,button.x + button.width);
               maxY = Math.round(button.y + button.height);
               currentX += ITEM_WIDTH + 1;
               if(++j % cols == 0)
               {
                  currentX = 0;
                  currentY += ITEM_HEIGHT_2 + 1;
               }
            }
         }
         if(data.slider != null)
         {
            Utils.addListener(Zoomer(data.slider),PixtonEvent.CHANGE,onItem);
            Zoomer(data.slider).x = data.x;
            Zoomer(data.slider).y = data.y;
            Zoomer(data.slider).visible = true;
         }
         Picker.obj = obj;
         Picker.type = type;
         Picker.subType = subType;
         Picker.pool = pool;
         Picker.poolValue = poolValue;
         PickerItem.resetStagger();
         if(type == Globals.PROPS)
         {
            Prop.resetSpriteCache();
         }
         i = 0;
         loop3:
         while(true)
         {
            if(i >= n)
            {
               hilite.graphics.clear();
               if(hiliteItems != null)
               {
                  y0 = 0;
                  y1 = item.getHeight();
                  x0 = hiliteItems[0] * itemContainer.width;
                  x1 = hiliteItems[1] * itemContainer.width;
                  hilite.graphics.beginFill(16777215,1);
                  hilite.graphics.moveTo(x0,y0);
                  hilite.graphics.lineTo(x1,y0);
                  hilite.graphics.lineTo(x1,y1);
                  hilite.graphics.lineTo(x0,y1);
                  hilite.graphics.lineTo(x0,y0);
                  hilite.graphics.endFill();
                  FX.glow(hilite,3,Palette.RGBtoHex(Editor.COLOR[Editor.HIGHLIGHT]),5,3,false,true);
               }
               else
               {
                  FX.glow(hilite,0);
               }
               if(inputText.visible)
               {
                  inputText.setActive(true,onSearch,onKey,L.text("help-default"));
               }
               for each(button in btnNew)
               {
                  if(button.visible)
                  {
                     Utils.addListener(button,MouseEvent.CLICK,onButton,true);
                     Utils.addListener(button,MouseEvent.ROLL_OVER,onOver,true);
                  }
               }
               if(btnPrev.mouseChildren)
               {
                  btnPrev.setHandler(onButton,false);
                  btnPrev.enable();
               }
               else
               {
                  btnPrev.setHandler();
                  btnPrev.enable(false);
               }
               if(btnNext.mouseChildren)
               {
                  btnNext.setHandler(onButton,false);
                  btnNext.enable();
               }
               else
               {
                  btnNext.setHandler();
                  btnNext.enable(false);
               }
               Picker.data = data;
               bkgd.visible = data.slider == null;
               Select.MIN_WIDTH = minCols * (itemWidth + 1) - 1;
               if(bkgd.visible)
               {
                  if(select.visible)
                  {
                     maxY = Math.max(maxY,Select.FIXED_HEIGHT);
                  }
                  if(btnPrev.visible && btnPrev.alpha < 1 && btnNext.visible && btnNext.alpha < 1 && Utils.empty(data.search) && !select.visible)
                  {
                     btnPrev.visible = false;
                     inputText.visible = false;
                     btnNext.visible = false;
                  }
                  navigation.visible = btnPrev.visible || btnNext.visible || inputText.visible;
                  if(navigation.visible)
                  {
                     navigation.y = maxY + 2;
                     maxX = Math.floor(Math.max(maxX,Select.MIN_WIDTH));
                     inputWidth = maxX;
                     if(btnPrev.visible)
                     {
                        inputWidth -= 46;
                     }
                     if(btnNext.visible)
                     {
                        inputWidth -= 46;
                     }
                     if(btnSearch.visible)
                     {
                        inputWidth -= 46;
                     }
                     navigation.inputText.setWidth(inputWidth);
                     currentX = Math.floor(navigation.inputText.x + navigation.inputText.width + 2);
                     if(btnSearch.visible)
                     {
                        btnSearch.x = currentX;
                        currentX += NAVIGATION_HEIGHT;
                     }
                     if(btnNext.visible)
                     {
                        btnNext.x = currentX;
                        currentX += NAVIGATION_HEIGHT;
                     }
                     maxY += NAVIGATION_HEIGHT;
                  }
                  txtMsg.x = 0;
                  txtMsg.y = NO_RESULTS_SPACING + (!!select.visible ? Select.FIXED_HEIGHT : 0);
                  txtMsg.width = maxX;
                  if(n == 0 && inputText.visible && numVisibleButtons == 0)
                  {
                     txtMsg.text = !!data.error ? data.error : L.text("no-results");
                     data.error = null;
                     txtMsg.visible = true;
                     navigation.y = Math.round(txtMsg.y + txtMsg.height + NO_RESULTS_SPACING);
                     maxY = Math.max(maxY,Math.round(navigation.y + NAVIGATION_HEIGHT));
                  }
               }
               if(select.visible)
               {
                  select.setWidth(maxX + 1);
               }
               if(bkgd.visible)
               {
                  if(selectGrid.visible)
                  {
                     selectGrid.x = maxX + BKGD_PADDING;
                     selectGrid.y = 0;
                     maxX = selectGrid.x + selectGrid.getWidth();
                     maxY = Math.max(maxY,Math.round(selectGrid.y + selectGrid.getHeight()));
                  }
                  g = bkgd.graphics;
                  g.clear();
                  if(type == Globals.DESIGNER)
                  {
                     g.beginFill(Designer.getInstance().getActiveColor());
                  }
                  else
                  {
                     g.beginFill(13421772);
                  }
                  bkgdX1 = -BKGD_PADDING;
                  bkgdX2 = maxX + BKGD_PADDING;
                  bkgdY1 = -BKGD_PADDING;
                  bkgdY2 = maxY + BKGD_PADDING;
                  if(type == Globals.DESIGNER)
                  {
                     bkgdX2 += 1;
                  }
                  g.moveTo(bkgdX1,bkgdY1);
                  g.lineTo(bkgdX2,bkgdY1);
                  g.lineTo(bkgdX2,bkgdY2);
                  g.lineTo(bkgdX1,bkgdY2);
                  g.lineTo(bkgdX1,bkgdY1);
                  g.endFill();
                  if(txtMsg.visible)
                  {
                     g.beginFill(16777215);
                     g.moveTo(0,!!select.visible ? Number(Select.FIXED_HEIGHT) : Number(0));
                     g.lineTo(navigation.width - BKGD_PADDING + 1,!!select.visible ? Number(Select.FIXED_HEIGHT) : Number(0));
                     g.lineTo(navigation.width - BKGD_PADDING + 1,(!!select.visible ? Select.FIXED_HEIGHT : 0) + NO_RESULTS_SPACING * 2 + txtMsg.height - BKGD_PADDING + 1);
                     g.lineTo(0,(!!select.visible ? Select.FIXED_HEIGHT : 0) + NO_RESULTS_SPACING * 2 + txtMsg.height - BKGD_PADDING + 1);
                     g.lineTo(0,!!select.visible ? Number(Select.FIXED_HEIGHT) : Number(0));
                     g.endFill();
                  }
                  if(type == Globals.DESIGNER)
                  {
                     btnBack.x = -12;
                     btnForward.x = maxX + 12;
                     btnBack.y = Math.round(maxY * 0.5 - btnBack.height * 0.5);
                     btnForward.y = btnBack.y;
                  }
               }
               maxX += BKGD_PADDING * 2;
               if(Main.isCharCreate())
               {
                  target.x = Main.UI_WIDTH - Designer.FIXED_WIDTH - btnForward.width - 14;
                  target.y = Designer.FIXED_Y;
               }
               else if(firstRun && Utils.empty(data.search))
               {
                  pickerOffset = PICKER_OFFSET;
                  if(data.r)
                  {
                     if(data.r.x + data.r.width + pickerOffset + maxX > Main.getRightX())
                     {
                        data.x = data.r.x - pickerOffset - maxX;
                     }
                     else
                     {
                        data.x = data.r.x + data.r.width + pickerOffset;
                     }
                     if(data.x < Main.getLeftX())
                     {
                        data.x = Main.getLeftX();
                     }
                     if(data.r.y + data.r.height + pickerOffset + maxY + Main.self.y > Main.getVisibleBottomY())
                     {
                        data.y = Main.getVisibleBottomY() - pickerOffset - maxY - Main.self.y;
                     }
                     else
                     {
                        data.y = data.r.y + data.r.height + pickerOffset;
                     }
                     if(data.y < Main.stageTopY)
                     {
                        data.y = Main.stageTopY;
                     }
                  }
                  else if(data.align == "bottom")
                  {
                     data.y -= itemContainer.height;
                  }
                  else if(data.align == "right")
                  {
                     data.x -= itemContainer.width;
                  }
                  else
                  {
                     if(data.x + maxX > Main.getRightX())
                     {
                        data.x = Main.getRightX() - maxX;
                     }
                     if(data.x < Main.getLeftX())
                     {
                        data.x = Main.getLeftX();
                     }
                     if(data.y + maxY + Main.self.y > Main.getVisibleBottomY())
                     {
                        data.y = Main.getVisibleBottomY() - maxY - Main.self.y;
                     }
                     if(data.y < Main.stageTopY)
                     {
                        data.y = Main.stageTopY;
                     }
                  }
                  data.x = Math.round(data.x);
                  data.y = Math.round(data.y);
                  Utils.matchPosition(target,data,true);
                  target.x += Main.self.x + 3;
                  Main.displayManager.SET(target,DisplayManager.P_X,target.x);
                  Main.displayManager.SET(target,DisplayManager.P_Y,target.y);
               }
               Main.displayManager.SET(target,DisplayManager.P_VIS,true,true);
               if(type == Globals.CHARACTERS)
               {
                  Main.self.updateStage();
               }
               return;
            }
            options = {
               "w":itemWidth,
               "h":itemHeight,
               "index":i,
               "subType":-1,
               "type":type,
               "totalNum":n,
               "cols":cols
            };
            switch(type)
            {
               case Globals.PROPSETS:
               case Globals.PROPS:
               case Globals.PHOTOS:
               case Globals.BODY_PHOTOS:
               case Globals.CHARACTERS:
               case Globals.OUTFITS:
                  if(type == Globals.PROPSETS && pool == Pixton.POOL_MINE && !FeatureTrial.can(FeatureTrial.PROP_GROUPING))
                  {
                     break loop3;
                  }
                  if(type == Globals.PROPSETS && Utils.inArray(pool,[Pixton.POOL_PRESET,Pixton.POOL_COMMUNITY]))
                  {
                     options.lock = PropSet.getLock(list[i]);
                  }
                  else if(Utils.inArray(type,[Globals.PROPS,Globals.PHOTOS,Globals.BODY_PHOTOS]) && pool != Pixton.POOL_MINE)
                  {
                     options.lock = Prop.getLock(list[i]);
                  }
                  options.pool = pool;
                  options.value = list[i];
                  if(type == Globals.PROPSETS && pool == Pixton.POOL_PRESET && data.setting == null && Utils.empty(data.search))
                  {
                     options.showName = true;
                  }
                  options.deletable = Utils.inArray(type,[Globals.CHARACTERS,Globals.OUTFITS]) && pool == Pixton.POOL_MINE;
                  break;
               case Globals.SEQUENCES:
                  options.subType = subType;
                  options.obj = obj;
                  options.value = list[i];
                  break;
               case Globals.POSES:
               case Globals.FACES:
                  options.subType = subType;
                  options.obj = obj;
                  options.value = list[i];
                  options.deletable = pool == Pixton.POOL_MINE;
                  if(!Main.showVectors())
                  {
                     options.obj = {"url":Pose.getURL(type,Character(obj).skinType,null,list[i])};
                  }
                  break;
               case Globals.EXPRESSION:
               case Globals.LOOKS:
                  options.value = Character(obj).getPartValue(data.basePart,type,i);
                  options.targetClass = targetClass;
                  options.bodyPart = bodyPart;
                  options.targetClass2 = targetClass2;
                  options.bodyPart2 = bodyPart2;
                  if(!Main.showVectors())
                  {
                     options.obj = {"url":Pose.getURL(type,bodyPart.skinType,bodyPart.getTargetName(),options.value)};
                  }
                  break;
               case Globals.BORDER_SHAPE:
               case Globals.BKGD_GRADIENT:
                  options.obj = obj;
                  options.value = i;
                  break;
               case Globals.BUBBLE_SHAPE:
                  options.value = Dialog.bubbleShapeMap[i];
                  options.obj = obj;
                  break;
               case Globals.BUBBLE_SPIKE:
                  options.value = i;
                  break;
               case Globals.FONT_FACE:
                  options.index = i - Fonts.unicode.length;
                  options.value = i - Fonts.unicode.length;
                  break;
               case Globals.ALPHA:
               case Globals.FONT_SIZE:
               case Globals.LEADING:
               case Globals.CORNER_RADIUS:
               case Globals.PADDING:
               case Globals.EFFECTS:
               case Globals.GLOW_AMOUNT:
               case Globals.BLUR_AMOUNT:
               case Globals.BLUR_ANGLE:
               case Globals.BORDER_SIZE:
               case Globals.BUBBLE_BORDER:
               case Globals.PANEL_SATURATION:
               case Globals.PANEL_BRIGHTNESS:
               case Globals.PANEL_CONTRAST:
               case Globals.LINE_ALPHA:
                  break;
               case Globals.DESIGNER:
                  if(data.color != null)
                  {
                     options.subType = data.color;
                     options.value = colorList[i];
                     if(Character(obj).bodyParts.getColor(data.color) == options.value)
                     {
                        options.selected = true;
                     }
                  }
                  else if(data.part != null)
                  {
                     if(data.stretch == null && data.list != null)
                     {
                        options.value = list[i];
                     }
                     else if(data.stretch != null)
                     {
                        options.value = i;
                     }
                     else
                     {
                        options.value = Character(obj).getPartValue(BodyParts.getBasePartName(data.part),Globals.LOOKS,i);
                     }
                     if(data.stretch == null)
                     {
                        if(Character(obj).bodyParts.getPart(data.part).look == options.value)
                        {
                           options.selected = true;
                        }
                     }
                  }
                  else if(data.outfit != null)
                  {
                     options.value = list[i];
                  }
                  else if(data.size != null)
                  {
                     options.value = i;
                     if(data.size == "width")
                     {
                        if(Character(obj).bodyWidth == list[i])
                        {
                           options.selected = true;
                        }
                     }
                     else if(data.size == "height")
                     {
                        if(Character(obj).bodyHeight == list[i])
                        {
                           options.selected = true;
                        }
                     }
                     else if(data.size == "size")
                     {
                        Debug.trace(Character(obj).bodyWidth + " x " + Character(obj).bodyHeight);
                        if(Character(obj).bodyWidth == list[i][0] && Character(obj).bodyHeight == list[i][1])
                        {
                           options.selected = true;
                        }
                     }
                  }
                  options.obj = obj;
                  options.extra = data;
                  options.n = n;
                  break;
               default:
                  options.value = colorList[i];
            }
            item = new PickerItem(options);
            if(options.selected === true)
            {
               recentItem = item;
               item.setSelected();
            }
            itemContainerDynamic.addChild(item);
            item.x = currentX;
            item.y = currentY;
            if(Utils.inArray(type,[Globals.PROPSETS,Globals.PROPS,Globals.PHOTOS,Globals.BODY_PHOTOS,Globals.CHARACTERS,Globals.OUTFITS,Globals.POSES,Globals.FACES,Globals.SEQUENCES,Globals.DESIGNER]))
            {
               Utils.addListener(item,MouseEvent.CLICK,onItem);
            }
            else
            {
               Utils.addListener(item,MouseEvent.ROLL_OVER,onItem);
               Utils.addListener(item,MouseEvent.MOUSE_UP,onItem);
            }
            Utils.addListener(item,MouseEvent.ROLL_OVER,onOver);
            currentX += item.getWidth() + 1;
            nextLine = false;
            if(numVisibleButtons > 0)
            {
               if((itemContainerDynamic.numChildren + numVisibleButtons) % cols == 0)
               {
                  nextLine = true;
               }
            }
            else if(itemContainerDynamic.numChildren % cols == 0)
            {
               nextLine = true;
            }
            if(nextLine)
            {
               currentX = 0;
               currentY += item.getHeight() + 1;
            }
            thisX = Math.round(item.x + item.getWidth());
            thisY = Math.round(item.y + item.getHeight());
            maxX = Math.max(maxX,thisX);
            maxY = Math.max(maxY,thisY);
            if(type == Globals.PHOTOS && data.autoPick && i == 0)
            {
               item.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               hide();
               return;
            }
            i++;
         }
         Main.promptUpgrade(FeatureTrial.PROP_GROUPING);
      }
      
      public static function getBottom() : Number
      {
         return target.y + (!!bkgd.visible ? bkgd.height : 0);
      }
      
      private static function resetTimeout() : void
      {
         if(timeout != -1)
         {
            clearTimeout(timeout);
            timeout = -1;
         }
      }
      
      private static function onSearch(param1:Event = null, param2:Boolean = false) : void
      {
         var evt:Event = param1;
         var forceNow:Boolean = param2;
         if(inputText.text == L.text("help-default"))
         {
            return;
         }
         Guide.onSearch();
         resetTimeout();
         if(!forceNow)
         {
            return;
         }
         if(forceNow)
         {
            hide(true);
            load(type,Utils.mergeObjects(data,{
               "offset":0,
               "type":subType,
               "search":inputText.text,
               "searching":SEARCHING
            }),obj,false,pool,poolValue);
         }
      }
      
      private static function onOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         if(type == Globals.DESIGNER)
         {
            return;
         }
         if(param1.currentTarget is PickerItem)
         {
            _loc2_ = PickerItem(param1.currentTarget).getName();
            _loc3_ = PickerItem(param1.currentTarget).getWidth();
            if(PickerItem(param1.currentTarget).lock != null)
            {
               _loc4_ = PickerItem(param1.currentTarget).lock;
            }
            pendingItem = param1.currentTarget as PickerItem;
         }
         else if(param1.currentTarget == btnUpload)
         {
            _loc2_ = L.text("file-upload");
            _loc3_ = param1.currentTarget.width;
         }
         else if(param1.currentTarget == btnFlickr)
         {
            _loc2_ = "Creative Commons";
            _loc3_ = param1.currentTarget.width;
         }
         else if(param1.currentTarget == btnGoogle)
         {
            _loc2_ = "Google Images";
            _loc3_ = param1.currentTarget.width;
         }
         else if(param1.currentTarget == btnRandom)
         {
            _loc2_ = type == Globals.FACES ? L.text("random-expr") : L.text("random-pose");
            _loc3_ = param1.currentTarget.width;
         }
         else if(param1.currentTarget is PhotoSetButton)
         {
            _loc2_ = PhotoSetButton(param1.currentTarget).getName();
            _loc3_ = param1.currentTarget.width;
         }
         else
         {
            _loc2_ = L.text("new-c");
            _loc3_ = param1.currentTarget.width;
         }
         if(_loc2_ != null)
         {
            if(param1.currentTarget is PickerItem)
            {
               Help.show(_loc2_,PickerItem(param1.currentTarget).fill,false,true,false,_loc4_,PickerItem(param1.currentTarget));
               if(type == Globals.PROPS && pool == Pixton.POOL_MINE || type == Globals.PROPSETS && pool == Pixton.POOL_MINE || type == Globals.PHOTOS || type == Globals.BODY_PHOTOS)
               {
                  hideTarget = PickerItem(param1.currentTarget).value;
                  btnHide.x = itemContainer.x + Math.round(PickerItem(param1.currentTarget).x + PickerItem(param1.currentTarget).width - btnHide.width) - 3;
                  btnHide.y = itemContainer.y + PickerItem(param1.currentTarget).y + 2;
                  btnHide.visible = true;
               }
            }
            else
            {
               Help.show(_loc2_,param1.currentTarget,false,true);
            }
         }
         Utils.addListener(param1.currentTarget,MouseEvent.ROLL_OUT,onOut);
      }
      
      private static function onOut(param1:Object) : void
      {
         Help.hide();
         Utils.removeListener(param1.currentTarget,MouseEvent.ROLL_OUT,onOut);
      }
      
      private static function onItem(param1:Object, param2:Boolean = false) : void
      {
         var item:PickerItem = null;
         var action:Function = null;
         var setting:String = null;
         var propType:uint = 0;
         var t:MovieClip = null;
         var evt:Object = param1;
         var forceFinal:Boolean = param2;
         pendingItem = null;
         var isFinal:Boolean = forceFinal || evt.type == MouseEvent.MOUSE_UP;
         if(data.slider == null)
         {
            item = evt.currentTarget as PickerItem;
            if(!isFinal && evt.type != MouseEvent.CLICK)
            {
               recentEvent = evt;
            }
            else
            {
               recentEvent = null;
            }
            type = item.type;
         }
         else
         {
            recentEvent = null;
         }
         if(evt.target is ButtonDelete)
         {
            if(Utils.javascript("confirm",L.text("delete-preset")))
            {
               item.disable();
               switch(type)
               {
                  case Globals.POSES:
                  case Globals.FACES:
                     Main.deletePose(Pose.deletePose(item.value));
                     break;
                  case Globals.CHARACTERS:
                     Main.deleteCharacter(Character.deleteCharacter(item.value));
                     break;
                  case Globals.OUTFITS:
               }
            }
         }
         else
         {
            if(type == Globals.PROPSETS && pool == Pixton.POOL_PRESET && data.setting == null && Utils.empty(data.search))
            {
               setting = Template.extractSetting(item.value);
               if(setting != null)
               {
                  data.setting = setting;
                  data.offset = 0;
                  load(type,data,null,true,pool,poolValue,true);
                  return;
               }
            }
            switch(type)
            {
               case Globals.PROPSETS:
               case Globals.PROPS:
               case Globals.PHOTOS:
               case Globals.BODY_PHOTOS:
               case Globals.CHARACTERS:
               case Globals.OUTFITS:
               case Globals.POSES:
               case Globals.FACES:
               case Globals.SEQUENCES:
                  if(type == Globals.PROPSETS)
                  {
                     propType = Prop.PROP_SET;
                  }
                  else if(type == Globals.PHOTOS || type == Globals.BODY_PHOTOS)
                  {
                     propType = Prop.PROP_PHOTO;
                  }
                  else if(type == Globals.PROPS)
                  {
                     if(item.pool == Pixton.POOL_MINE)
                     {
                        propType = Prop.PROP_SET;
                     }
                     else
                     {
                        propType = Prop.PROP_PRESET;
                     }
                  }
                  action = function(param1:Boolean):*
                  {
                     if(param1)
                     {
                        if(item.pool == Pixton.POOL_NEW)
                        {
                           target.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,item.value,propType,item.pool,data.type));
                        }
                        else
                        {
                           target.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,item.value,propType,null,data.type));
                        }
                     }
                  };
                  if(!Comic.isNew())
                  {
                     if(item.lock == null || Globals.isFullVersion() && item.lock.plusFree_bool == 1 || Platform.exists() && item.lock.platformFree_bool == 1)
                     {
                        action(true);
                        if(type == Globals.OUTFITS)
                        {
                           Character(obj).promptOverwrite();
                        }
                     }
                     else
                     {
                        Credit.purchaseFeature(item.lock,action,item);
                     }
                  }
                  break;
               case Globals.ASSET_COLOR:
                  if(obj is Dialog)
                  {
                     Dialog(obj).setColor(Dialog.BKGD,item.value);
                  }
                  else if(obj is Prop)
                  {
                     Prop(obj).setColor(data.type,item.value);
                  }
                  else
                  {
                     Asset(obj).setColor(Palette.SILHOUETTE_COLOR,item.value);
                  }
                  break;
               case Globals.BUBBLE_BORDER_COLOR:
                  Dialog(obj).setColor(Dialog.BORDER,item.value);
                  break;
               case Globals.TEXT_COLOR:
                  Dialog(obj).setColor(Dialog.TEXT,item.value);
                  break;
               case Globals.BKGD_COLOR:
                  Editor(obj).setColor(item.value);
                  break;
               case Globals.BORDER_COLOR:
                  Border(obj).setColor(item.value);
                  break;
               case Globals.BORDER_SHAPE:
                  Border(obj).shape = item.value;
                  break;
               case Globals.BUBBLE_SHAPE:
                  action = function(param1:Boolean, param2:Boolean = true):*
                  {
                     if(param2 && !param1)
                     {
                        Dialog(obj).setShapeMode();
                     }
                     else if(param1)
                     {
                        Dialog(obj).setShapeMode(item.value,true,param2,true);
                     }
                  };
                  if(!isFinal)
                  {
                     action(true,false);
                  }
                  else if(!Comic.isNew())
                  {
                     if(item.lock == null || Globals.isFullVersion() && item.lock.plusFree_bool == 1 || Platform.exists() && item.lock.platformFree_bool == 1)
                     {
                        action(true);
                     }
                     else
                     {
                        Credit.purchaseFeature(item.lock,action,item);
                     }
                  }
                  break;
               case Globals.BUBBLE_SPIKE:
                  action = function(param1:Boolean, param2:Boolean = true):*
                  {
                     if(param2 && !param1)
                     {
                        Dialog(obj).setSpikeMode();
                     }
                     else if(param1)
                     {
                        Dialog(obj).setSpikeMode(item.value,true,param2);
                     }
                  };
                  if(!isFinal)
                  {
                     action(true,false);
                  }
                  else if(!Comic.isNew())
                  {
                     if(item.lock == null || Globals.isFullVersion() && item.lock.plusFree_bool == 1 || Platform.exists() && item.lock.platformFree_bool == 1)
                     {
                        action(true);
                     }
                     else
                     {
                        Credit.purchaseFeature(item.lock,action,item);
                     }
                  }
                  break;
               case Globals.BKGD_GRADIENT:
                  Editor(obj).setGradient(item.value);
                  break;
               case Globals.LOOKS:
               case Globals.EXPRESSION:
                  action = function(param1:Boolean, param2:Boolean = true):*
                  {
                     if(charType == Editor.MODE_EXPR)
                     {
                        if(item.bodyPart)
                        {
                           bodyPart.expression = !!param1 ? uint(item.bodyPart.expression) : uint(0);
                        }
                        else
                        {
                           bodyPart.expression = !!param1 ? uint(item.value) : uint(0);
                        }
                     }
                     else if(item.bodyPart)
                     {
                        bodyPart.look = !!param1 ? uint(item.bodyPart.look) : uint(0);
                     }
                     else
                     {
                        bodyPart.look = !!param1 ? uint(item.value) : uint(0);
                     }
                     Character(obj).bodyParts.enforceLooks(bodyPart);
                     Character(obj).redraw();
                     Character(obj).onChange(charType,param2);
                     if(param1)
                     {
                        if(type == Globals.LOOKS && param2)
                        {
                           Character(obj).promptOverwrite();
                        }
                     }
                  };
                  if(!isFinal)
                  {
                     action(true,false);
                  }
                  else if(!Comic.isNew())
                  {
                     if(item.lock == null || Globals.isFullVersion() && item.lock.plusFree_bool == 1 || Platform.exists() && item.lock.platformFree_bool == 1)
                     {
                        action(true);
                     }
                     else
                     {
                        Credit.purchaseFeature(item.lock,action,item);
                     }
                  }
                  break;
               case Globals.ALPHA:
                  Prop(obj).setAlpha(evt.value);
                  break;
               case Globals.FONT_FACE:
                  if(isFinal && item.value > Fonts.minFontID && !FeatureTrial.can(FeatureTrial.EXTRA_FONTS))
                  {
                     Main.promptUpgrade(FeatureTrial.EXTRA_FONTS);
                  }
                  Dialog(obj).setPreviewing(!isFinal);
                  Dialog(obj).setFontFace(item.value);
                  Dialog(obj).redraw();
                  break;
               case Globals.FONT_SIZE:
                  Dialog(obj).setFontSize(evt.value);
                  Dialog(obj).redraw();
                  break;
               case Globals.LEADING:
                  Dialog(obj).setLeading(evt.value);
                  Dialog(obj).redraw();
                  break;
               case Globals.PADDING:
                  Dialog(obj).setPadding(evt.value);
                  Dialog(obj).redraw();
                  break;
               case Globals.EFFECTS:
                  for each(t in data.target)
                  {
                     FX(data.fx).setFilter(t,data.id,evt.value);
                  }
                  FX(data.fx).update();
                  break;
               case Globals.GLOW_AMOUNT:
                  Asset(obj).setGlowAmount(evt.value);
                  break;
               case Globals.BLUR_AMOUNT:
                  Asset(obj).setBlurAmount(evt.value);
                  break;
               case Globals.BLUR_ANGLE:
                  Asset(obj).setBlurAngle(evt.value);
                  break;
               case Globals.BORDER_SIZE:
                  Border(obj).thickness = Math.round(evt.value);
                  break;
               case Globals.PANEL_SATURATION:
                  Border(obj).setSaturation(Math.round(evt.value) * 10);
                  break;
               case Globals.PANEL_BRIGHTNESS:
                  Border(obj).setBrightness(Math.round(evt.value) * 10);
                  break;
               case Globals.PANEL_CONTRAST:
                  Border(obj).setContrast(Math.round(evt.value) * 10);
                  break;
               case Globals.LINE_ALPHA:
                  Editor(obj).setLineAlpha(Math.round(evt.value) / 10);
                  break;
               case Globals.BUBBLE_BORDER:
                  Dialog(obj).borderSize = Math.round(evt.value);
                  Dialog(obj).redraw();
                  break;
               case Globals.DESIGNER:
                  isFinal = true;
                  if(data.color != null)
                  {
                     type = Character(obj).getActiveColorType(data.color);
                     Character(obj).setColor(type,item.value,!isFinal,isFinal);
                  }
                  else if(data.part != null)
                  {
                     if(data.stretch != null)
                     {
                        Character(obj).bodyParts.setLooksScale(data.part,data.stretch,data.list[item.value],true);
                     }
                     else
                     {
                        bodyPart.look = item.value;
                        Character(obj).bodyParts.enforceLooks(bodyPart);
                     }
                  }
                  else if(data.outfit != null)
                  {
                     Character(obj).setOutfit(Character.getData(item.value));
                  }
                  else if(data.size == "width")
                  {
                     Character(obj).setBodyWidth(data.list[item.value]);
                  }
                  else if(data.size == "height")
                  {
                     Character(obj).setBodyHeight(data.list[item.value]);
                  }
                  else if(data.size == "size")
                  {
                     Character(obj).setBodyHeight(data.list[item.value][1],false);
                     Character(obj).setBodyWidth(data.list[item.value][0]);
                  }
                  if(recentItem != null)
                  {
                     recentItem.setSelected(false);
                  }
                  item.setSelected();
                  recentItem = item;
                  charType = Editor.MODE_LOOKS;
                  Character(obj).onChange(charType,isFinal);
                  Character(obj).redraw(true);
                  if(isFinal)
                  {
                     Character(obj).promptOverwrite();
                  }
                  Editor.self.setZoom(Editor.ZOOM_BODY,false);
                  break;
               default:
                  type = Character(obj).getActiveColorType(type);
                  Character(obj).setColor(type,item.value,!isFinal,isFinal);
                  Character(obj).onChange(charType,isFinal);
                  if(Utils.inArray(type,[Globals.SKIN_COLOR,Globals.SHIRT_COLOR,Globals.PANT_COLOR,Globals.HAIR_COLOR,Globals.SOCK_COLOR,Globals.SHOE_COLOR]))
                  {
                     Character(obj).redraw();
                  }
                  if(isFinal)
                  {
                     Character(obj).promptOverwrite();
                  }
            }
         }
      }
      
      public static function hide(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:uint = 0;
         var _loc5_:PickerItem = null;
         var _loc6_:MovieClip = null;
         if(recentEvent != null)
         {
            onItem(recentEvent,true);
         }
         resetTimeout();
         btnHide.visible = false;
         if(!param1 && !Main.isCharCreate() && !Utils.inArray(type,[Globals.PROPSETS,Globals.PROPS,Globals.PHOTOS,Globals.BODY_PHOTOS,Globals.CHARACTERS,Globals.OUTFITS,Globals.POSES,Globals.FACES,Globals.SEQUENCES]) && pendingItem != null)
         {
            onItem({
               "currentTarget":pendingItem,
               "type":MouseEvent.MOUSE_UP
            });
         }
         if(data != null && data.slider != null)
         {
            Utils.removeListener(data.slider,PixtonEvent.CHANGE,onItem);
            Zoomer(data.slider).visible = false;
         }
         var _loc4_:uint = itemContainerDynamic.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = itemContainerDynamic.getChildAt(0) as PickerItem;
            if(Utils.inArray(type,[Globals.PROPSETS,Globals.PROPS,Globals.PHOTOS,Globals.BODY_PHOTOS,Globals.CHARACTERS,Globals.OUTFITS,Globals.POSES,Globals.FACES,Globals.SEQUENCES]))
            {
               Utils.removeListener(_loc5_,MouseEvent.CLICK,onItem);
            }
            else
            {
               Utils.removeListener(_loc5_,MouseEvent.ROLL_OVER,onItem);
               Utils.removeListener(_loc5_,MouseEvent.MOUSE_UP,onItem);
            }
            Utils.removeListener(_loc5_,MouseEvent.ROLL_OVER,onOver);
            _loc5_.onRemove();
            itemContainerDynamic.removeChild(_loc5_);
            _loc3_++;
         }
         recentItem = null;
         if(!Main.displayManager.GET(target,DisplayManager.P_VIS))
         {
            return;
         }
         if(param1 != SEARCHING)
         {
            if(inputText.visible)
            {
               inputText.setActive(false);
            }
            for each(_loc6_ in btnNew)
            {
               if(_loc6_.visible)
               {
                  Utils.removeListener(_loc6_,MouseEvent.CLICK,onButton);
                  Utils.removeListener(_loc6_,MouseEvent.ROLL_OVER,onOver);
               }
            }
            if(btnPrev.mouseChildren)
            {
               Utils.removeListener(btnPrev,MouseEvent.CLICK,onButton);
            }
            if(btnNext.mouseChildren)
            {
               Utils.removeListener(btnNext,MouseEvent.CLICK,onButton);
            }
            data = {};
            Main.displayManager.SET(target,DisplayManager.P_VIS,false);
            if(!param2)
            {
               target.dispatchEvent(new PixtonEvent(PixtonEvent.CLOSE,null));
            }
         }
      }
      
      public static function hasFocus() : Boolean
      {
         return inputText.visible && inputText.hasFocus();
      }
      
      private static function onButton(param1:MouseEvent) : void
      {
         var skinTypes:Array = null;
         var thisSearch:String = null;
         var evt:MouseEvent = param1;
         switch(evt.currentTarget)
         {
            case btnNewC:
               skinTypes = Character.getExtraSkinTypes();
               if(!Utils.empty(skinTypes))
               {
                  target.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,null,skinTypes[0],Pixton.POOL_NEW));
               }
               else
               {
                  hide(true);
                  load(type,data,obj,false,Pixton.POOL_NEW,-1);
               }
               break;
            case btnRandom:
               hide();
               Editor.self.randomizeExpression(type);
               break;
            case btnSearch:
               onSearch(null,true);
               break;
            case btnUpload:
               if(!FileUpload.canUploadOwn())
               {
                  Confirm.alert("parent-no-upload",true);
               }
               else if(Main.isPlusTrial || !Globals.isFullVersion() && !FeatureTrial.can(FeatureTrial.IMAGE_UPLOADS))
               {
                  if(PropPhoto.getCount(Pixton.POOL_MINE) > 0)
                  {
                     Main.promptUpgrade();
                  }
                  else
                  {
                     Main.promptUpgrade(FeatureTrial.IMAGE_UPLOADS);
                  }
               }
               else
               {
                  FileUpload.prompt(function(param1:uint):void
                  {
                     var imageID:uint = param1;
                     target.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,imageID,Prop.PROP_PHOTO,function(param1:Boolean):void
                     {
                        data.autoPick = true;
                        load(type,data,obj,true,pool,NaN,true);
                     }));
                  },FileUpload.MEDIA_IMAGE);
               }
               break;
            case btnFlickr:
               if(!FileUpload.canUploadOwn())
               {
                  Confirm.alert("parent-no-upload",true);
               }
               else if(!FeatureTrial.can(FeatureTrial.BROWSE_PHOTOS))
               {
                  Main.promptUpgrade(FeatureTrial.BROWSE_PHOTOS);
               }
               else
               {
                  WebPhoto.showSelector(WebPhoto.ENGINE_FLICKR);
               }
               break;
            case btnGoogle:
               if(!FileUpload.canUploadOwn())
               {
                  Confirm.alert("parent-no-upload",true);
               }
               else if(!Globals.isFullVersion())
               {
                  Main.promptUpgrade(FeatureTrial.BROWSE_PHOTOS,true);
               }
               else
               {
                  WebPhoto.showSelector(WebPhoto.ENGINE_GOOGLE);
               }
               break;
            case btnPrev:
               data.paging = true;
               if(data.offset == 0)
               {
                  thisSearch = data.search;
                  data.search = null;
                  hide(true);
                  if(pool == Pixton.POOL_COMMUNITY)
                  {
                     load(type,data,obj,true,pool,-1,true);
                  }
                  else if(type == Globals.PROPSETS && pool == Pixton.POOL_PRESET && (data.setting != null || !Utils.empty(thisSearch)))
                  {
                     data.setting = null;
                     load(type,data,obj,true,pool,-1,true);
                  }
                  else
                  {
                     load(type,data,obj,false,Pixton.POOL_PACK,-1);
                  }
               }
               else
               {
                  data.offset -= data.numPerPage;
                  hide(true);
                  load(type,data,obj,false,pool,poolValue);
               }
               break;
            case btnNext:
               data.paging = true;
               data.offset += data.numPerPage;
               hide(true);
               load(type,data,obj,false,pool,poolValue);
               break;
            case btnHide:
               Confirm.open("Pixton.comic.confirm",L.text("confirm-remove"),function(param1:Boolean):*
               {
                  if(param1)
                  {
                     target.dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,type,pool,hideTarget));
                     load(type,data,obj,true,pool,NaN,true);
                  }
               });
               break;
            case btnBack:
               Designer.getInstance().navigate(-1);
               break;
            case btnForward:
               Designer.getInstance().navigate(1);
               break;
            default:
               if(evt.currentTarget is PhotoSetButton)
               {
                  if(!FeatureTrial.can(FeatureTrial.BROWSE_PHOTOS) && !FileUpload.forcedVisible)
                  {
                     Main.promptUpgrade(FeatureTrial.BROWSE_PHOTOS);
                  }
                  else
                  {
                     WebPhoto.showSelector(PhotoSetButton(evt.currentTarget).getID().toString(),PhotoSetButton(evt.currentTarget).getName());
                  }
               }
         }
      }
      
      private static function onKey(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(inputText.text != L.text("help-default") && (inputText.text.length > 0 || pool == Pixton.POOL_COMMUNITY))
            {
               onSearch(null,true);
            }
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            inputText.text = "";
         }
         else if(txtMsg.visible)
         {
            txtMsg.visible = false;
         }
         if(Utils.empty(inputText.text) && pool != Pixton.POOL_COMMUNITY)
         {
            onSearch(null,true);
         }
      }
      
      private static function onSelect(param1:PixtonEvent) : void
      {
         hide(true);
         if(inputText.visible)
         {
            inputText.blur();
            inputText.text = L.text("help-default");
         }
         data.offset = 0;
         data.search = null;
         if(param1.value == select)
         {
            load(type,data,obj,false,param1.value2,PropPack.lastPoolValue);
         }
         else
         {
            data.search = null;
            load(type,data,obj,false,Pixton.POOL_PACK,param1.value2);
         }
      }
      
      private static function getNumVisibleButtons() : uint
      {
         var _loc2_:MovieClip = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in btnNew)
         {
            if(_loc2_.visible)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public static function isVisible() : Boolean
      {
         return Main.displayManager.GET(target,DisplayManager.P_VIS);
      }
      
      private static function loadIcon(param1:Object, param2:uint) : void
      {
         if(param1.iconContainer == null || param1.iconContainer.icon == null)
         {
            return;
         }
         var _loc3_:Class = Character.getIconClass(param2);
         if(_loc3_ != null)
         {
            param1.iconContainer.removeChild(param1.iconContainer.icon);
            param1.iconContainer.icon = null;
            param1.iconContainer.addChild(new _loc3_());
         }
      }
   }
}
