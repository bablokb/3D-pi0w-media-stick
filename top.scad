//---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Top part of the Media-Stick case.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/3D-pi0w-media-stick
//---------------------------------------------------------------------------



include <shared.scad>
include <modules/pcb.scad>
include <modules/wall_locks.scad>

// --- create base-plate to fit all PCBs   ----------------------------------

module plate() {
  cuboid([XO_BASE,YO_BASE,BT],
            rounding=R_BASE, edges="Z",
         anchor=BOTTOM+CENTER);
  // outer wall
  rect_tube(size=[XO_BASE,YO_BASE], wall=W_BASE, h=H_TOP,
            rounding=R_BASE, anchor=BOTTOM+CENTER);
}
		
// --- cutouts for USB and HDMI   ---------------------------------------------

module top_cutouts() {
  // HDMI (back side)
  move([-X_PCB_PI0W/2+XO_HDMI_MINI,YO_BASE/2+W_BASE/2, BT])
    cuboid([X_HDMI_MINI, 4*W_BASE, H_TOP+FUZZ], anchor=BOTTOM+CENTER);
  // USB-power (back side)
  move([XO_USB,+Y_PCB_PI0W/2+W_BASE/2, BT])
    cuboid([X_USB, 4*W_BASE, H_TOP+FUZZ], anchor=BOTTOM+CENTER);
  // SD-card (left side)
  move([-X_PCB_PI0W/2-W_BASE, -YO_SD, BT])
    cuboid([4*W_BASE, Y_SD, H_TOP+FUZZ], anchor=BOTTOM+CENTER);
  // pins (bottom side)
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
    yflip_copy() ymove(y_plug/2+W_BASE/2)
        cuboid([x_conn+x_plug, W_BASE, H_TOP], anchor=BOTTOM+CENTER);
  }
  // plug stop
  y_plug_stop = (Y_HDMI-Y_HDMI_PLUG)/2;
  move([-X_PCB_PI0W/2-W_BASE/2-x_conn-x_plug, 0, 0]) {
    yflip_copy() ymove(y_plug/2-y_plug_stop/2)
      cuboid([W2, y_plug_stop, H_TOP], anchor=BOTTOM+CENTER);
  }
}

// --- back (mini) HDMI plug   ---------------------------------------------

module hdmi_plug_back() {
  move([-1.5*W_BASE, +YI_BASE/2+FUZZ, 0]) yflip() {
    // bottom plate (no wall)
    mini_hdmi_cover(isize=[X_HDMI_MINI+2*W_BASE, Y_HDMI_MINI+2*W_BASE, BT],
                    wall=0, h=0);
    // wall of given width and height
   mini_hdmi_cover(isize=[X_HDMI_MINI+W_BASE, Y_HDMI_MINI+W_BASE, BT],
                    wall=W_BASE, h=H_TOP);
  }
}

// --- final object   -------------------------------------------------------

module top() {
  // plate minus all PCBs
  difference() {
    plate();
    top_cutouts();
  }
  // add (left) HDMI-plug
  color("green") hdmi_plug_left();
  // add (front) mini-HDMI-plug cover
  color("green") hdmi_plug_back();
}

top();

