//---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Shared constants/modules for the Media-Stick case.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-pi0w-media-stick
//---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <modules/dimensions.scad>

Z_PCB = 1.6;  // all PCBs

D_HDMI_CABLE = 4;
X_HDMI_MINI  = 26.5;
Y_HDMI_MINI  = 22.5;
XO_HDMI_MINI = 12.4 + GAP;
X_HDMI       = 20.0 + GAP;
Y_HDMI       = 18.2 + GAP;
Z_HDMI       = 7.8;
Y_HDMI_PLUG  = 14;
X_HDMI_CONN  = 5;
Y_HDMI_CONN  = 6.6 + GAP;

X_PCB_PI0W = 65 + 2*GAP;
Y_PCB_PI0W = 30 + 2*GAP;
H_PCB_PI0W_SCREW = D_HDMI_CABLE+1;   // hight screw-pocket above BT (base-thickness)

X_GPIOS  = 51 + 2*GAP;
Y_GPIOS  =  5 + 2*GAP;
YO_GPIOS = 3.5;

XO_USB  = -X_PCB_PI0W/2 + 54;
X_USB   = 10;
Z_USB   =  5;

Y_SD  = 13;
YO_SD = 1.9;

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

// top:
H_TOP = 12.5 + BT;


// --- helper for mini-HDMI plug and cable   -----------------------------------

module _mini_hdmi_cover(size=[0,0,0]) {
  color("blue") xmove(-size.x/2+FUZZ)
    cuboid([size.x, size.y, size.z],
           rounding=3, edges=FRONT+LEFT, anchor=BOTTOM+CENTER+BACK);
  pie_slice(d=2*size.y, h=size.z, ang=90, spin=-90, anchor=BOTTOM+CENTER);
}

module mini_hdmi_cover(isize=[0,0,0], wall=W2, h=0) {
  difference() {
    _mini_hdmi_cover(size=[isize.x+wall, isize.y+wall, isize.z+h]);
    ymove(FUZZ) zmove(isize.z) _mini_hdmi_cover(size=[isize.x+FUZZ, isize.y, h+FUZZ]);
  }
}


// bottom
//mini_hdmi_cover(isize=[X_HDMI_MINI, Y_HDMI_MINI, BT], wall=W_BASE, h=10);
//mini_hdmi_cover(isize=[X_HDMI_MINI+2*W_BASE, Y_HDMI_MINI+2*W_BASE, BT], wall=0, h=0);

// top
////zmove(2*10+2*BT) xrot(180)
//yflip()
//  mini_hdmi_cover(isize=[X_HDMI_MINI+W_BASE, Y_HDMI_MINI+W_BASE, BT], wall=W_BASE, h=10);
