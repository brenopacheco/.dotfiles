* Menu-toolbox - plugin

** The idea

  Menu-toolbox plugin provides basic components and functionalities
  for building menus with two simple components, the =menu_box= and
  =menu_item=.

  The =menu_box= is a floating box containing =menu_items= and
  optionally a =search_field=. See image:

  Vertical menu_box          Horizontal menu_box

  ┏menu_box━━━━━┓    ┏menu_box━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━┓
  ┃ : search    ┃    ┃ : search    ┃  Buttom 1   ┃  Buttom 1   ┃ ▶ Buttom 2  ┃                                                             
  ┣━━━━━···━━━━━┫    ┗━━━━━━━━━━━━━┻···━━━━━━━━━━┻━━━━━━━━━━━━━┻━━━━━━━━━━···┛
  ┃  🗹  Radio   ┃
  ┃  ☐  Radio   ┃
  ┃  [ s̲e̲l̲ ⮟]   ┃
  ┃  Buttom 1   ┃
  ┃ ▶ Buttom 2  ┃
  ┃  Buttom 3   ┃
  ┗━━━━━···━━━━━┛

  We can move up and down the list using user defined keybindins (i.e: C-n,
  C-p), specific to the =menu_box=.

  The =search_field= is used to filter =menu_items=. Pressing any key
  besides the movement keys will start entering a seach.

  When entering a /search/ a =filter_function= will perform a filter on
  the =menu_box='s =item_list=. This approach allows great flexibility:

  A =menu_item= can be /highlighted/ by moving up/down the list and
  can be /selected/. When selected, a determined =item_function= is run and
  the =menu_box= can be either closed or not. We can also define a 
  =selectable= attribute on =item_functions=, which allows us to
  create information texts.

  The =item_function= might be to open a new =menu_box= and in that
  case it is usefull that the new opened =menu_box= contains a
  reference for it's parent menu (in order to know where to draw it,
  for example). 
  
*** Complex menu example
 
  - Example of a complex menu:

 ┏━━Settings━━━┓┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━Config 2━━┓
 ┣━━━━━━━━━━━━━┫┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
 ┃ : ^Con.*    ┃┃  Config 2 menu: set some options     ┃
 ┣━━━━━━━━━━━━━┫┃                                      ┃
 ┃  Config 1   ┃┃   🗹   Some setting description       ┃
 ┃ ▶ Config 2  ┃┃   ☐   Some setting description       ┃
 ┃  Config 3   ┃┃   Some field:        ( v̲a̲l̲u̲e̲ )       ┃
 ┃             ┃┃   Select from list: [ s̲e̲l̲e̲c̲t̲i̲o̲n̲ ⮟]   ┃
 ┃             ┃┃   Select from list: [ s̲e̲l̲e̲c̲t̲i̲o̲n̲ ⮟]   ┃
 ┃             ┃┃  ▶ Select from list:┏━━━━━━━━━━━━┓   ┃
 ┣━━━━━━━━━━━━━┫┃   ☐   Some setting d┃ : Op*      ┃   ┃
 ┃  Select   ↹ ┃┃   ☐   Some setting d┣━━━━━━━━━━━━┫   ┃
 ┃  Save     ⏎ ┃┃   🗹   Some setting d┃  Option 1  ┃   ┃
 ┃  Cancel   ⌫ ┃┃   🗹   Some setting d┃  Option 2  ┃   ┃
 ┗━━━━━━━━━━━━━┛┗━━━━━━━━━━━━━━━━━━━━━┃  Option 3  ┃━━━┛
                                      ┃ ▶ Option 4 ┃
                                      ┃  Option 5  ┃
                                      ┗━━━━━···━━━━┛

   In the menu above, we call a first *Settings* =menu_box=. 
   Each entry will:
 - on /hover/ :: popup a child =menu_box= on the side. (unselected)
 - on /selection/ :: focus on the child =menu_box=.

   A =menu_item= of type =list= will, when /selected/, popup another
   child =menu_box= with options to choose from. When the Option 4 is
   /selected/ the value from the =list= item in the *Config 2*
   =menu_box= (parent) will be updated and the popoup is closed. The
   keybindings are easily visible through 3 non-selectable
   =menu_items= which are placed to the bottom of the *Settings* box
   by the =menu_box= =draw= function.
   
*** Intellij  Nav-bar example
   
*** Definitions

    
The user /registers/ a =menu=, which is a definition of the =menu=
behavior. When we want to instantiate a =menu=, an =instance= is
created with information about the window, the current search being done, the
active items displayed, etc.

The following attributes define =menu= and =item=. Those marked with
a * are required while others may be empty or a default implementation
is provided.

    - menu          :: =menu= definition for creating =instances=
      - items*      :: static list of =items= in the =menu=
        here we make the distinction of dynamically generated and
        static menus. if an empty list or nothing is given it is
        expected that the /filter/ and /itemize/ functions will be
        defined in order to generate the =menu= items on the fly.
        Type: list
        Default: []
      - searchable* :: whether or not box has a =search_field=
        Type: boolean
        Default: v:true
      - on_enter*   :: command to run when entering the =menu=
        Type: string
        Default: ''
      - on_exit*    :: command to run when exiting the =menu=
        Type: string
        Default: ''
      - height*     :: function defining the height of the box
        API: height(p_size)
      - width*      :: function defining the width of the box
        API: width(p_size)
      - position*   :: function defining the col and row where box begin
        Where to place the box will depend on box size and/or parent's 
        box position.
        Type: function
        API: position(p_size, size) : position
             p_size: parent's size (dict with keys 'width' and 'height')
             position: dictionary with keys 'row' and 'col' as numbers
        Default: 
      - draw*       :: function defining how things are drawn on box
        the function doesn't actually draw th box, but rather returns a list
        of the strings that will be drawn
        API: draw(width, height, labels, search, cur_position, selections) : list
             width: width of the box
             height: height of the box
             labels: list of item /labels/ to be drawn
             search: contents of the =search_field=
             selections: list of =items= currently selected
             list : strings to be drawn on the box
        Default: see image
      - filter*     :: function run every time =search_field= is updated
        this function is used to generate a list of active items to
        the current running instance of =menu=
        API: filter(labels) : list
             labels: list of item labels comming from /item_list/
        Default: simple string match using grep like so:
                 search = abc -> regex = ".*a.*b.*c.*"
                 matches: "aaabc" and "aZZZbZZc" but not "cba"
      - sort*       :: function used for sorting the results of /filter/
        API: filter(labels) : list
             labels: list of item labels output by /filter/
        Default: none
      - itemize* :: this function runs after /sort/ and is used 
        when the /filter/ function actually returns new labels not
        related to the pre-defined =items=. in this case, the list is
        being dynamically generated and a new =item= must be defined 
        based on the label to include information about which
        functions to run when selected, etc...
        API: instantiate(labels) : item list
        Default: when this function is not defined (as is the case of 
        static menus) the default behavior is to lookup the =items= 
        defined for the menu and return those matching the labels.
      - multi*      :: whether =menu= accepts multiple selections
        In that case, we do not define a /on_select/  function for
        each item, but a /sink/ command for the menu.
      - sink*       :: command to run when multiple =items= are selected
        
    - item          :: =item= used in a menu's =instance=
      - on_hover*   :: command run when =menu= /hovers/ over this item
        Default: ''
      - action      :: command run when =item= is selected or multipme
        commands are selected and /action/ is called
      - label       :: label displayed by =menu=. uses parent's size
      - selectable* :: whether or not this item is selectable in=menu=
        Default: v:true
      - exits*      :: boolean. whether parent's =menu= exists on /selection/
        Default: v:true

    
    *Internal*
    
    when an instance of a menu is created, a list of items (=entries=) is
    created based on the menu's items. these are recreated after the
    /filter/ and /itemize/ functions are run. 
    
    - instance         :: an instance of a =menu= 
      - menu           :: menu definitions (instance of menu)
      - buffer         :: the buffer of the window 
      - entries        :: list of active items in menu after 
      - cur_pos        :: index of the =cur_item= on =entries= list
      - search_field   :: the current content of the search
      - selections     :: list of entries currently selected (label keys)
      - functions
            move_up() :: set entry to entry.next
            move_down() :: set entry to entry.prev
            hover() :: call hover function of a given item 
            select() :: add entry key to selections 
            action() :: run /action/ function of current entry
            instantiate() :: generate entries from a /itemize/ output

**** example
     
# items
let g:item_1 = {
    \ 'label': 'Item 1',
    \ 'on_select': 'echo "You selected the first item."'
}

let g:item_2 = {
    \ 'label': 'Item 1',
    \ 'on_select': 'echo "You selected the second item."'
}

let g:item_3 = {
    \ 'label': 'Item 1',
    \ 'on_select': 'echo "You selected the third item."'
}

# menu
let g:menu_1 = {
    \ 'item_list' [ item_1, item_2, item_3],
}



# instance
{
  'menu': 'menu_1',
  'items': {
    'label 01' : {
       'next': 
    \ }

  \ }
}

** what is
    what is a menu_box?
    what does the menu_box have?
    what can the menu box do?
    what is the search field?
    what is an item?
    what does the item have?
    what type of items can there be?
    examples of items?
    how do items differ?
    what does the item do?
   
** Notes
*** Unicode characters

   
   | box | items |
   |     |       |

   ━ U+2501     
   ┃ U+2503     
   ┏ U+250F     
   ┗ U+2517     
   ┓ U+2513     
   ┛ U+251B     
   ┳ (U+2533)     
   ┻ (U+253B)     
   ┫ (U+252B)     
   ┣ (U+2523)     
   ☐ (U+2610)
   ⮽ (U+2BBD)
   ☒ (U+2612)
   🗷 (U+1F5F7)
   🗹 (U+1F5F9)
   ⛛ (U+26DB)


   i go into INSERT mode
   Ctrl+v go into ins-special-keys mode
   u2713 insert the Unicode character CHECK MARK (U+2713)

   Unicode Character “❪” (U+276A)
   Unicode Character “❫” (U+276B)
   > underscore s/./&̅/g -- 0305
   > underscore s/./&̲/g -- 0332

   (𝚊̲̅𝚋̲̅𝚌̲̅𝚍̲̅𝚎̲̅𝚏̲̅g̅𝚑̲̅𝚒̲̅𝚓̲̅𝚔̲̅𝚕̲̅𝚖̲̅𝚗̲̅𝚘̲̅𝚙̲̅𝚚̲̅𝚛̲̅𝚜̲̅𝚝̲̅𝚞̲̅𝚟̲̅w̲̅𝚡̲̅𝚢̲̅)
   ❪𝚊̲̅𝚋̲̅𝚌̲̅𝚍̲̅𝚎̲̅𝚏̲̅g̅𝚑̲̅𝚒̲̅𝚓̲̅𝚔̲̅𝚕̲̅𝚖̲̅𝚗̲̅𝚘̲̅𝚙̲̅𝚚̲̅𝚛̲̅𝚜̲̅𝚝̲̅𝚞̲̅𝚟̲̅w̲̅𝚡̲̅𝚢̲̅❫

   Unicode Character “·” (U+00B7) // middle dot
   s̲̅e̲̅l̲̅e̲̅c̲̅t̲̅e̲̅d̲̅

   ┃ list: [s̲̅e̲̅l̲̅.̲̅] ⛛ ┃
   ┃ list: [ selected ⛛] ┃

   s̲e̲l̲.̲
   e̲e̲a̲r̲c̲h̲_f̲i̲e̲l̲d̲


*** Menu_box examples

    ┏menu_box━━━━━━━━━┓
    ┃ : s̲e̲a̲r̲c̲h̲_f̲i̲e̲l̲d̲  ┃ underscore? higlight?
    ┣━━━━━━━━━━━━━━━━━┫
    ┃     ·······     ┃ // indication that the list continues
    ┃ 🗹   radio item  ┃
    ┃ ☐   radio item  ┃
    ┃ list: [ s̲e̲l̲.̲ ⛛] ┃
    ┃ [   Buttom 1  ] ┃
    ┃ >> [ Buttom 1 ] ┃ // this is also highlighted
    ┃ [   Buttom 2  ] ┃
    ┃ [   Buttom 3  ] ┃
    ┃     ·······     ┃ // indication that the list continues
    ┗━━━━━━━━━━━━━━━━━┛

*** Components



   
