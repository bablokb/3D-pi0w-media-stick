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
  // inner part of HDMI-plug (overlapping outer wall of plate)
  move([-4*W_BASE,YO_BASE/2-2*W_BASE, BT])
    cuboid([X_HDMI_MINI+Y_HDMI_MINI+6*W_BASE, 2*W_BASE, H_TOP+FUZZ], anchor=BOTTOM+CENTER);
  // outer wall of plate (top side)
  move([-4*W_BASE,YO_BASE/2-1*W_BASE+FUZZ, BT])
    cuboid([X_HDMI_MINI+Y_HDMI_MINI+2*W_BASE, 2*W_BASE, H_TOP+FUZZ], anchor=BOTTOM+CENTER);
  // USB (power)
  move([XO_USB,+Y_PCB_PI0W/2-2*W_BASE, BT+Z_PCB])
    cuboid([X_USB, 20, Z_USB+Z_PCB+FUZZ], anchor=BOTTOM+CENTER+FRONT);
  // SD-card (left side)
  move([-X_PCB_PI0W/2-W_BASE, 0, BT])
    cuboid([4*W_BASE, Y_HDMI+2*W_BASE, H_TOP+FUZZ], anchor=BOTTOM+CENTER);
  // GPIOs (bottom side)
  move([0, -Y_PCB_PI0W/2+GAP+YO_GPIOS, -FUZZ])
    cuboid([X_GPIOS, Y_GPIOS, BT+2*FUZZ], anchor=BOTTOM+CENTER);
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
    xmove(-x_conn/2) cuboid([x_plug, y_plug+2*W_BASE, H_TOP-Z_HDMI-GAP], anchor=BOTTOM+CENTER);
    yflip_copy() ymove(y_plug/2+W_BASE/2)
        cuboid([x_conn+x_plug, W_BASE, H_TOP], anchor=BOTTOM+CENTER);
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
                    wall=W_BASE, h=H_TOP-BT);
  }
}

// --- locks   --------------------------------------------------------------

module locks() {
  // front and back
  move([-X_HDMI_MINI/2, 0, H_TOP - H_BASE/2]) {
    ymove(-YO_BASE/2+W_BASE)             xcyl(l=L_LOCK, d=D_LOCK);
    ymove(+YO_BASE/2+Y_HDMI_MINI-W_BASE) xcyl(l=L_LOCK, d=D_LOCK);
  }
  // left HDMI plug
  move([-XO_BASE/2-3*(X_HDMI_CONN+X_HDMI)/4, 0, H_TOP - H_BASE/2]) {
    ymove(-Y_HDMI/2-W_BASE)              xcyl(l=L_LOCK, d=D_LOCK);
    ymove(+Y_HDMI/2+W_BASE)              xcyl(l=L_LOCK, d=D_LOCK);
  }
  // right side
  move([+XO_BASE/2-W_BASE, 0, H_TOP - H_BASE/2]) ycyl(l=L_LOCK, d=D_LOCK);
}

// --- logo   ---------------------------------------------------------------

module logo(size=LOGO_SIZE, r=2) {
  xy = LOGO_SIZE[0];
  z  = LOGO_SIZE[1];
  r  = LOGO_SIZE[2];
  rot_copies(n=2, sa=180)
    cuboid(size=[xy, xy, z],
           rounding=r, edges=FRONT+LEFT, anchor=BOTTOM+BACK+RIGHT);
}

// --- final object   -------------------------------------------------------

module top() {
  // plate minus all PCBs
  difference() {
    union() {
      plate();
      // add (front) mini-HDMI-plug cover
      color("green") hdmi_plug_back();
    }
    top_cutouts();
    move([0, YO_BASE/2, -FUZZ]) zrot(90) logo();  // logo cutout
  }
  // add (left) HDMI-plug
  color("green") hdmi_plug_left();
  // add locks
  locks();
}

top();
