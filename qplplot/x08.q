XPTS:35              // Data points in x
YPTS:46              // Data points in y
alt:60.0 20.0;
az:30.0 60.0;

title:(`$"#frPLplot Example 8 - Alt=60, Az=30";`$"#frPLplot Example 8 - Alt=20, Az=60");


//--------------------------------------------------------------------------
// cmap1_init1
//
// Initializes color map 1 in HLS space.
// Basic grayscale variation from half-dark (which makes more interesting
// looking plot compared to dark) to light.
// An interesting variation on this:
//	s[1] = 1.0
//--------------------------------------------------------------------------
cmap1_init1:{[gray]
    i:0 1f;
    $[gray; [h:0 0f; l:0.5 1.0; s:0 0f]; [h:240 0f; l:0.6 0.6; s:0.8 0.8]];
    pl.scmap1n[256];
    pl.scmap1l[0; 2; i; h; l; s; 0b]}

//--------------------------------------------------------------------------
// main
//
// Does a series of 3-d plots for a given data set, with different
// viewing options in each plot.
//--------------------------------------------------------------------------

rosen=1;

x:((til XPTS)-(XPTS%2))%(XPTS%2);
if[rosen; x*:1.5];
y:((til YPTS)-(YPTS%2))%(YPTS%2);
if[rosen; y*:1.5];
i:0; do[XPTS;
    xx:x[i];
    j:0; do[YPTS;
        yy:y[j];
        $[rosen;
            [.[`z; (i;j); :; xexp[1f - xx; 2f] + 100f * xexp[yy - xexp[xx; 2f]; 2f]];
            $[z[i][j] > 0f;
                .[`z; (i;j); :; log[z[i][j]]];
                .[`z; (i;j); :; -5f]]];
            [r:sqrt[(xx*xx)+yy*yy];
            .[`z; (i;j); :; exp[neg r*r] * cos[2f * M_PI * r]]]];
    z_row_major[(i * YPTS) + j] = z[i][j];
    z_col_major[i + XPTS * j] = z[i][j]]];

    PLFLT    *x; *y; **z; *z_row_major; *z_col_major;
    / PLfGrid2 grid_c; grid_row_major; grid_col_major;
    / typedef struct { PLFLT **f; PLINT nx,ny;}PLfGrid2;
    PLFLT    xx; yy; r;
    PLINT    ifshade;
    PLFLT    zmin; zmax; step;
    PLFLT    clevel[LEVELS];
    PLINT    nlevel = LEVELS;
    int      rosen  = 1;
    // Parse and process command line arguments
pl.MergeOpts[options; "x08c options"; NULL];
/ (void) pl.parseopts[&argc; argv; PL_PARSE_FULL];
if[sombrero; rosen:0]

// Initialize plplot
pl.init();
// Allocate data structures
x:`float$til XPTS    x = (PLFLT *) calloc[XPTS; sizeof [PLFLT]];
    y = (PLFLT *) calloc[YPTS; sizeof [PLFLT]];
    pl.Alloc2dGrid[&z; XPTS; YPTS];
    z_row_major = (PLFLT *) malloc[XPTS * YPTS * sizeof [PLFLT]];
    z_col_major = (PLFLT *) malloc[XPTS * YPTS * sizeof [PLFLT]];
/       pl.exit["Memory allocation error"];
\\
    grid_c.f         = z;
    grid_row_major.f = (PLFLT **) z_row_major;
    grid_col_major.f = (PLFLT **) z_col_major;
    grid_c.nx        = grid_row_major.nx = grid_col_major.nx = XPTS;
    grid_c.ny        = grid_row_major.ny = grid_col_major.ny = YPTS;
    for (i = 0; i < XPTS; i++)

xi:(til XPTS - (XPTS div 2))%(XPTS div 2);
if[rosen; xi*:1.5];
yi:(til YPTS - (YPTS div 2))%(YPTS div 2);
if[rosen; yi+:0.5];

z:(flip enlist XPTS#0f)$(enlist YPTS#0f);
i:0; do[XPTS; xx:x[i];
    j:0; do[YPTS; yy:y[i];
        $[rosen;
            .[`z; (i;j); :; $[zz:xexp[1. - xx; 2.] + 100. * xexp[yy - xexp[xx; 2.]; 2.] > 0; log[zz]; -5f]];
            .[`z; (i;j); :; xexp[neg r:sqrt[(xx*xx)+yy*yy]; 2]*cos[2f*M_PI*r]]];
            @[z_row_major; i * YPTS + j; :; z[i][j]];
            @[z_col_major; i + XPTS * j; :; z[i][j]];  j+:1]; i+:1];

zmax:max raze z; zmin:min raze z;
step:(zmax - zmin) div (nlevel + 1);
clevel:zmin + step + step * til nlevel;

pl.lightsource[1.; 1.; 1.];
k:0; do[2;
    ifshade:0; do[4;
            pl.adv[0];
            pl.vpor[0.0; 1.0; 0.0; 0.9];
            pl.wind[-1.0; 1.0; -0.9; 1.1];
            pl.col0[pl`green];
            pl.mtex[`"t"; 1.0; 0.5; 0.5; title[k]];
            pl.col0[pl`red];
                $[rosen;
                    pl.w3d[1.0; 1.0; 1.0; -1.5; 1.5; -0.5; 1.5; zmin; zmax; alt[k]; az[k]];
                    pl.w3d[1.0; 1.0; 1.0; -1.0; 1.0; -1.0; 1.0; zmin; zmax; alt[k]; az[k]]];
            plbox3[(`$"bcdmnstuv"; "z axis"; 0.0; 0);
                (`$"bnstu"; `$"y axis"; 0.0; 0);
                (`$"bcdmnstuv"; `$"z axis", 0.0, 0)];
            pl.col0[pl`yellow];
            if[ifshade=0; // diffuse light surface plot
                cmap1_init[1];
                pl.fsurf3d[x; y; pl.f2ops_c(); (PLPointer) z; XPTS; YPTS; 0; NULL; 0]];
            if[ifshade=1; // magnitude colored plot
                cmap1_init[0];
                pl.fsurf3d[x; y; pl.f2ops_grid_c(); [PLPointer] & grid_c; XPTS; YPTS; MAG_COLOR; NULL; 0];
            $[ifshade=2; //  magnitude colored plot with faceted squares
                [cmap1_init[0];
                pl.fsurf3d[x; y; pl.f2ops_grid_row_major(); [PLPointer] & grid_row_major; XPTS; YPTS; MAG_COLOR | FACETED; NULL; 0]];
                                // magnitude colored plot with contours
                [cmap1_init[0];
                pl.fsurf3d[x; y; pl.f2ops_grid_col_major(); [PLPointer] & grid_col_major; XPTS; YPTS; MAG_COLOR | SURF_CONT | BASE_CONT; clevel; nlevel]]];
pl.end[];
\\
// $Id: x08c.c 11680 2011-03-27 17:57:51Z airwin $
//
//      3-d plot demo.
//
// Copyright (C) 2004  Alan W. Irwin
// Copyright (C) 2004  Rafael Laboissiere
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
//
