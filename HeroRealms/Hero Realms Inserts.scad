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

// Pack definitions: [name, card count]
packs = [
    ["Feuerjuwelen", 16],
    ["Markt", 80],
    ["Rot", 12],
    ["Blau", 12],
    ["Gelb", 12],
    ["Grün", 12],
    ["Dieb", 15],
    ["Kämpfer", 15],
    ["Kleriker", 15],
    ["Waldläufer", 15],
    ["Zauberer", 15],
];

function lid_parms( radius, tabs = [ f,f,f,f] ) = 
[
    [ LID_PATTERN_RADIUS,         radius ],        
    [ LID_LABELS_BG_THICKNESS, 4],
    [ LID_INSET_B, t ],
    [ LID_TABS_4B, tabs],

    [ LID_PATTERN_N1,               7 ],
    [ LID_PATTERN_N2,               7 ],
    [ LID_PATTERN_ANGLE,            25.7 ],
    [ LID_PATTERN_ROW_OFFSET,       10 ],
    [ LID_PATTERN_COL_OFFSET,       140 ],
    [ LID_PATTERN_THICKNESS,        0.6 ],

 ];

function MakeCardHolder( label, cards, nolid = false, lidparms ) =
     [ label,
        [
            [ BOX_SIZE_XYZ,
                [
                    card_w + sleeve_padding + 2 * wall,
                    card_h + sleeve_padding + 2 * wall,
                    (card_t + sleeve_t) * cards + 2 * wall
                ]
            ],
            [ BOX_STACKABLE_B, t],
            [ BOX_LID,  lidparms ],

            [ BOX_NO_LID_B, nolid ],

            [ BOX_COMPONENT,
                [
                    [CMP_COMPARTMENT_SIZE_XYZ,
                        [
                            card_w + sleeve_padding,
                            card_h + sleeve_padding,
                            (card_t + sleeve_t) * cards
                        ]
                    ],
                    [CMP_NUM_COMPARTMENTS_XY,               [1,1 ]],  
                    [CMP_CUTOUT_SIDES_4B,               [ f,f,t,t]],
 
            [ LABEL,
                [
                    [ LBL_TEXT,     label ],
                    [ LBL_SIZE,     AUTO ],
                    [ LBL_FONT,     "Noto Serif"],
                    [ ROTATION,     90]

                ]
            ],     
                ]
            ]

        ],
    ];
 
 function TotalCardCount(packs) = 
 [
    totalcount = 0;
    for (i = [0 : len(packs) - 1])
    {
        totalcount += packs[i][1];
    }
    totalcount;
 ];
function MakeBoxWithCardSlots() =
[
    cardsc = function (packs) =
        

    "Hero Realms",
    BOX_SIZE_XYZ,
    [
        card_w + sleeve_padding + 2 * wall,
        card_h + sleeve_padding + 2 * wall,
        (card_t + sleeve_t) * cardsc + 2 * wall
    ]
];
    
// Data structure processed by MakeAll();
data =
[
    MakeBoxWithCardSlots()

        //MakeCardHolder( "Markt", 80, t, lid_parms( 10, [t,t,f,f]) ),   

];

// Actually create the boxes based on the data structure above
MakeAll();
