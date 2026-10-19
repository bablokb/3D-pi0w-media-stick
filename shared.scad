//---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Shared constants/modules for the Media-Stick case.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-pi0w-media-stick
//---------------------------------------------------------------------------

include <modules/dimensions.scad>

Z_PCB = 1.6;  // all PCBs

D_HDMI_CABLE = 4;
X_HDMI_MINI  = 26.5;
Y_HDMI_MINI  = 22.0;
X_HDMI       = 20.0 + GAP;
Y_HDMI       = 18.2 + GAP;
Y_HDMI_PLUG  = 14;
X_HDMI_CONN  = 5;
Y_HDMI_CONN  = 6.6 + GAP;

X_PCB_PI0W = 65 + 2*GAP;
Y_PCB_PI0W = 30 + 2*GAP;
H_PCB_PI0W_SCREW = D_HDMI_CABLE+1;   // hight screw-pocket above BT (base-thickness)

// base:
//  - inner dimensions fit PCBs
//  - added wall (W2)
//  - added rim (W2) for wall of top

W_BASE  = W2;
R_BASE  = 3;
H_BASE  = BT+H_PCB_PI0W_SCREW;
XI_BASE = X_PCB_PI0W;
XO_BASE = XI_BASE + 4*W_BASE + 2*GAP;
YI_BASE = Y_PCB_PI0W;
YO_BASE = YI_BASE + 4*W_BASE + 2*GAP;

XO_USB  = -X_PCB_PI0W/2 + 54;
X_USB   = 10;

