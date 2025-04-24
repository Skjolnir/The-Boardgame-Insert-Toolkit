// Toolkit that performs all the model generation operations
include <boardgame_insert_toolkit_lib.3.scad>;

// Helper library to simplify creation of single components
// Also includes some basic lid helpers
include <bit_functions_lib.3.scad>;

// Determines whether lids are output.
g_b_print_lid = true;

// Determines whether boxes are output.
g_b_print_box = true; 

// Only render specified box
g_isolated_print_box = "hexbox example 1"; 

// Used to visualize how all of the boxes fit together. 
g_b_visualization = false;          
        
// Outer wall thickness
// Default = 1.5mm
g_wall_thickness = 1.5;

// Provided to make variable math easier
// i.e., it's a lot easier to just type "wall" than "g_wall_thickness"
wall = g_wall_thickness;

// The tolerance value is extra space put between planes of the lid and box that fit together.
// Increase the tolerance to loosen the fit and decrease it to tighten it.
//
// Note that the tolerance is applied exclusively to the lid.
// So if the lid is too tight or too loose, change this value ( up for looser fit, down for tighter fit ) and 
// you only need to reprint the lid.
// 
// The exception is the stackable box, where the bottom of the box is the lid of the box below,
// in which case the tolerance also affects that box bottom.
//
g_tolerance = 0.15;

// This adjusts the position of the lid detents downward. 
// The larger the value, the bigger the gap between the lid and the box.
g_tolerance_detents_pos = 0.1;

// This sets the default font for any labels. 
// See https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Text#Using_Fonts_&_Styles
// for details on picking a new font.
g_default_font = "Noto Serif:style=Regular";

// This determines whether the default single material version is output, or, if printing in multiple materials, 
// which layer to output.
g_print_mmu_layer = "default"; // [ "default" | "mmu_box_layer" | "mmu_label_layer" ]

// Hero realms variables

// Card dimensions (in mm) (cards 63x88, sleeves 66x91)
card_w = 63;
card_h = 88;
card_t = 0.35;

sleeve_padding = 3; // adds to card_w and card_h
sleeve_t = 0; // adds to card_t (default 0.25?)

box_l = 144; // card box interior
box_w = 94; // card box interior
box_h = card_w + sleeve_padding + 2 * wall; // 63 + 3 + 3 = 69, original box is 53, so 16mm lid lift

cmp_l = box_l - 2 * wall;
cmp_w = box_w - 2 * wall;
cmp_h = box_h - 2 * wall;

// Pack definitions: [name, slot count, card count]
packs = [
    [1, 16], // Fire jewels     16
    [1, 80], // market          80 96
    [4, 12], // starter decks   48 144
    [5, 15], // hero decks      75 219
];

// Packs of 20
packs = [
    [4],    // 80 market
    [10], // market          80 96
    [4, 12], // starter decks   48 144
    [5, 15], // hero decks      75 219
];
total_cards = 219; //           219

function MakeCardComponent(index, cards_so_far) =
[
    BOX_COMPONENT,
    [
       [CMP_NUM_COMPARTMENTS_XY, [1,packs[index][0]]],
       [CMP_COMPARTMENT_SIZE_XYZ, [cmp_w, packs[index][0] * packs[index][1] * card_t, cmp_h]],
       [CMP_PADDING_XY, [1, 6]],
       [CMP_CUTOUT_SIDES_4B, [t,t,f,f]],
       [CMP_CUTOUT_HEIGHT_PCT, 80],
       [CMP_CUTOUT_WIDTH_PCT, 80],
       [CMP_CUTOUT_TYPE, BOTH],
       //[POSITION_XY, [CENTER, cards_so_far / total_cards * cmp_l]],
    ]
];
function MakeBoxWithCardSlots() =
[
    "Hero Realms",
    [
        [
            BOX_SIZE_XYZ, [box_w, box_l, box_h]
        ],
        [ BOX_NO_LID_B, true ],
        MakeCardComponent(0, 0),
        MakeCardComponent(1, 16),
        MakeCardComponent(2, 96),
        MakeCardComponent(3, 144),
    ]
];
    
// Data structure processed by MakeAll();
data =
[
    MakeBoxWithCardSlots()
];

// Actually create the boxes based on the data structure above
MakeAll();
