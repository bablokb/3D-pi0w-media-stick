//---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Bottom part of Media-Stick case.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-pi0w-media-stick
//---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <modules/dimensions.scad>
include <modules/pcb.scad>
include <modules/wall_locks.scad>

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

// --- create base-plate to fit all PCBs   ----------------------------------

module plate() {
  cuboid([XO_BASE,YO_BASE,BT],
            rounding=R_BASE, edges="Z",
         anchor=BOTTOM+CENTER);
  // inner wall
  rect_tube(isize=[XI_BASE,YI_BASE], wall=W_BASE, h=H_BASE,
            rounding=R_BASE, anchor=BOTTOM+CENTER);
}
		
// --- module for PI0W PCB   --------------------------------------------------

module pi0w_pcb(hull=false) {
  z = hull ? BT+2*FUZZ : BT;
  zm = hull ? -FUZZ : 0;
  //move([XI_BASE/2-X_PCB_PI0W/2,YI_BASE/2-Y_PCB_PI0W/2,zm])
  zmove(zm)
       pcb(X_PCB_PI0W, Y_PCB_PI0W, z, h_screw=H_BASE,
       edges="Z", screws=!hull);
}

// --- cutouts for USB and HDMI   ---------------------------------------------

module bottom_cutouts() {
  // HDMI (bottom side)
  move([XO_USB-D_HDMI_CABLE,-Y_PCB_PI0W/2-W_BASE, BT])
    cuboid([2*D_HDMI_CABLE, 4*W_BASE, H_PCB_PI0W_SCREW+FUZZ], anchor=BOTTOM+CENTER);
  // HDMI (left side)
  move([-X_PCB_PI0W/2-W_BASE, 0, BT])
    cuboid([4*W_BASE, D_HDMI_CABLE, H_PCB_PI0W_SCREW+FUZZ], anchor=BOTTOM+CENTER);
}

// --- cable ducts   --------------------------------------------------------

module cable_ducts() {
  move([-X_PCB_PI0W/2-GAP, 0, BT-FUZZ]) {
      yflip_copy() ymove(D_HDMI_CABLE/2)
        cuboid([X_PCB_PI0W/2, W_BASE, H_PCB_PI0W_SCREW], anchor=BOTTOM+LEFT+FRONT);
  }
}

// --- left (standard) HDMI plug   ------------------------------------------

module hdmi_plug_left() {
  x_conn = X_HDMI_CONN+2*W_BASE;
  y_conn = Y_HDMI_CONN+2*W_BASE;
  x_plug = X_HDMI+2*W_BASE;
  y_plug = Y_HDMI+2*W_BASE;
  // base + plug
  move([-X_PCB_PI0W/2-W_BASE-x_conn/2-x_plug/2, 0, 0]) {
    cuboid([x_conn+x_plug, y_plug+2*W_BASE, BT], anchor=BOTTOM+CENTER);
    yflip_copy() ymove(y_plug/2-W_BASE/2)
        cuboid([x_conn+x_plug, W_BASE, H_BASE], anchor=BOTTOM+CENTER);
  }
  // connector to cable
  move([-X_PCB_PI0W/2-W_BASE-x_conn/2, 0, 0]) {
    yflip_copy() ymove(y_conn/2)
        cuboid([x_conn, 2*W_BASE, H_BASE], anchor=BOTTOM+CENTER);
  }
  // plug stop
  y_plug_stop = (Y_HDMI-Y_HDMI_PLUG)/2;
  move([-X_PCB_PI0W/2-W_BASE/2-x_conn-x_plug, 0, 0]) {
    yflip_copy() ymove(y_plug/2-y_plug_stop/2)
      cuboid([W2, y_plug_stop, H_BASE], anchor=BOTTOM+CENTER);
  }
}

// --- final object   -------------------------------------------------------

module bottom() {
  // plate minus all PCBs
  difference() {
    plate();
    pi0w_pcb(hull=true);
    bottom_cutouts();
  }
  // add back PCBs
  color("blue") pi0w_pcb();
  // add cable ducts
  cable_ducts();
  // add (left) HDMI-plug
   color("green") hdmi_plug_left();
}

bottom();

