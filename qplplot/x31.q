ae:{if[not x~y;'`fail]}

// Test setting / getting familying parameters before plinit
// Save values set by plparseopts to be restored later.

\l qplplot.q

// Test setting / getting familying parameters before plinit
// Save values set by plparseopts to be restored later.
fmb0:pl.gfam[];
fam0:fmb0`fam;
num0:fmb0`num;
bmax0:fmb0`bmax;

fam1:0i;
num1:10i;
bmax1:1000i;
fmb1:(`fam1`num1`bmax1)!(0i;10i;1000i);
pl.sfam[fam1; num1; bmax1];

// Retrieve the same values?
fmb2:pl.gfam[];
ae[fmb1; fmb2];
// Restore values set initially by plparseopts.
plsfam[fam0; num0; bmax0];

// Test setting / getting page parameters before plinit
// Save values set by plparseopts to be restored later.
gpage:pl.gpage[];
xp1:200.;
yp1:200.;
xleng1:400i;
yleng1:200i;
xoff1:10i;
yoff1:20i;

gpage1:(`xp1;`yp1`xleng`yleng`xoff`yoff)!(200.;200.;400i;200i;10i;20i);
pl.spage[xp1; yp1; xleng1; yleng1; xoff1; yoff1];

// Retrieve the same values?
gpage2:pl.gpage[];

ae[gpage1; gpage2];

// Restore values set initially by plparseopts.
plspage[xp0; yp0; xleng0; yleng0; xoff0; yoff0];

// Test setting / getting compression parameter across plinit.
compression1:95i;
pl.scompression[compression1];

// Initialize plplot
pl.init[];

// Test if device initialization screwed around with the preset
// compression parameter.
compression2:pl.gcompression[];
ae[compression1; compression2];

// Exercise plscolor, plscol0, plscmap1, and plscmap1a to make sure
// they work without any obvious error messages.
pl.scolor[1];
pl.scol0[1; 255; 0; 0];
pl.scmap1[r1; g1; b1; 2];
pl.scmap1a[r1; g1; b1; a1; 2];

level2:pl.glevel[];
ae[level; level2];

pl.adv[0];
pl.vpor[0.01; 0.99; 0.02; 0.49];
vpd:pl.gvpd[];
ae[vpd`xmin; 0.01];
ae[vpd`xmax; 0.99];
ae[vpd`ymin; 0.02];
ae[vpd`ymax; 0.49];

xmid:0.5*(vpd`xmin + vpd`xmax);
ymid:0.5*(vpd`ymin + vpd`ymay);

pl.wind[0.2; 0.3; 0.4; 0.5];
vpw:pl.gvpw[];
ae[vpw`xmin; 0.2];
ae[vpw`xmax; 0.3];
ae[vpw`ymin; 0.4];
ae[vpw`ymax; 0.5];


world:pl.calc_world[xmid; ymid];

fnam:pl.gfnam[];Dunlap
-1 fnam;

pl.sdiori 1.0;
diori:pl.gdiori[];
ae[diori`ori; 1.0];

pl.sdiplt[0.1; 0.2; 0.9; 0.8];
diplt:pl.gdiplt[];
ae[diplt`xmin; 0.1];
ae[diplt`xmax; 0.9];
ae[diplt`ymin; 0.2];
ae[diplt`ymax; 0.8];

pl.sdiplz[0.1; 0.1; 0.9; 0.9];
diplt:pl.gdiplt[];
ae[abs[zxmin - (xmin + (xmax - xmin) * 0.1)] > 1.0E-5 ||
         abs[zxmax - (xmin + (xmax - xmin) * 0.9)] > 1.0E-5 ||
         abs[zymin - (ymin + (ymax - ymin) * 0.1)] > 1.0E-5 ||
         abs[zymax - (ymin + (ymax - ymin) * 0.9)] > 1.0E-5]


pl.scolbg[10; 20; 30];
rgb0:(`r`g`b)!(10i;20i;30i);
rgb:pl.gcolbg[];
ae[rgb0; rgb];

pl.scolbga[20; 30; 40; 0.5];
rgba:pl.gcolbga[];
rgba0:(`r;`g`b;`a)!(20i;30i;40i;0.5);
ae[rgba0; rgba];
pl.end();

\\
// $Id: x31c.c 11680 2011-03-27 17:57:51Z airwin $
//
// Copyright (C) 2008 Alan W. Irwin
// Copyright (C) 2008 Andrew Ross
//
// set/get tester
//
// This file is part of PLplot.
//
// PLplot is free software; you can redistribute it and/or modify
// it under the terms of the GNU Library General Public License as published
// by the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// PLplot is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Library General Public License for more details.
//
// You should have received a copy of the GNU Library General Public License
// along with PLplot; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
//
//
