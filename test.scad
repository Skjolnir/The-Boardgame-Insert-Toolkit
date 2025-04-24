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
g_tolerance = 0.1;

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

// Data structure processed by MakeAll();
data = [
    [ "Lid Test", [
        [ BOX_SIZE_XYZ,             [30, 30, 12] ],
        [ BOX_STACKABLE_B, f],
        [ BOX_COMPONENT, [
            [CMP_NUM_COMPARTMENTS_XY, [1,3]],
            [CMP_COMPARTMENT_SIZE_XYZ, [27, 8, 9]],
            [CMP_CUTOUT_SIDES_4B, [t,t,f,f]],
            [CMP_CUTOUT_HEIGHT_PCT, 20],
            [CMP_CUTOUT_WIDTH_PCT, 85],
            [CMP_CUTOUT_TYPE, BOTH],
            [CMP_PADDING_XY, [1, 1]],
            [POSITION_XY, [CENTER, CENTER]],
        ]],
        [ BOX_LID, [
            [ LID_PATTERN_RADIUS,           10  ],        
            [ LID_PATTERN_N1,                8  ],
            [ LID_PATTERN_N2,                8  ],
            [ LID_PATTERN_ANGLE,            22.5],
            [ LID_PATTERN_ROW_OFFSET,       10  ],
            [ LID_PATTERN_COL_OFFSET,      130  ],
            [ LID_PATTERN_THICKNESS,         1  ],
            
            [ LID_LABELS_BG_THICKNESS, 3],
            [ LID_INSET_B,      f],
            [ LID_HEIGHT, 3 ],

            [ LABEL, [   
                [ LBL_TEXT,     "HERO REALMS" ],
                [ LBL_FONT,     g_default_font ],
                [ LBL_SIZE,     AUTO ],
                [ ROTATION,     90 ],
                [ POSITION_XY, [ 0, 0 ]],
            ]]
          ]],
    ]],    
];

// Actually create the boxes based on the data structure above
MakeAll();
