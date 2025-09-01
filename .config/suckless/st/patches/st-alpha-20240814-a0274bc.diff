diff --git a/config.def.h b/config.def.h
index 2cd740a..019a4e1 100644
--- a/config.def.h
+++ b/config.def.h
@@ -93,6 +93,9 @@ char *termname = "st-256color";
  */
 unsigned int tabspaces = 8;
 
+/* bg opacity */
+float alpha = 0.8;
+
 /* Terminal colors (16 first used in escape sequence) */
 static const char *colorname[] = {
 	/* 8 normal colors */
diff --git a/x.c b/x.c
index d73152b..f32fd6c 100644
--- a/x.c
+++ b/x.c
@@ -105,6 +105,7 @@ typedef struct {
 	XSetWindowAttributes attrs;
 	int scr;
 	int isfixed; /* is fixed geometry? */
+	int depth; /* bit depth */
 	int l, t; /* left and top offset */
 	int gm; /* geometry mask */
 } XWindow;
@@ -752,7 +753,7 @@ xresize(int col, int row)
 
 	XFreePixmap(xw.dpy, xw.buf);
 	xw.buf = XCreatePixmap(xw.dpy, xw.win, win.w, win.h,
-			DefaultDepth(xw.dpy, xw.scr));
+			xw.depth);
 	XftDrawChange(xw.draw, xw.buf);
 	xclear(0, 0, win.w, win.h);
 
@@ -812,6 +813,10 @@ xloadcols(void)
 			else
 				die("could not allocate color %d\n", i);
 		}
+
+	dc.col[defaultbg].color.alpha = (unsigned short)(0xffff * alpha);
+	dc.col[defaultbg].pixel &= 0x00FFFFFF;
+	dc.col[defaultbg].pixel |= (unsigned char)(0xff * alpha) << 24;
 	loaded = 1;
 }
 
@@ -842,6 +847,12 @@ xsetcolorname(int x, const char *name)
 	XftColorFree(xw.dpy, xw.vis, xw.cmap, &dc.col[x]);
 	dc.col[x] = ncolor;
 
+	if (x == defaultbg) {
+		dc.col[defaultbg].color.alpha = (unsigned short)(0xffff * alpha);
+		dc.col[defaultbg].pixel &= 0x00FFFFFF;
+		dc.col[defaultbg].pixel |= (unsigned char)(0xff * alpha) << 24;
+	}
+
 	return 0;
 }
 
@@ -1134,11 +1145,25 @@ xinit(int cols, int rows)
 	Window parent, root;
 	pid_t thispid = getpid();
 	XColor xmousefg, xmousebg;
+	XWindowAttributes attr;
+	XVisualInfo vis;
 
 	if (!(xw.dpy = XOpenDisplay(NULL)))
 		die("can't open display\n");
 	xw.scr = XDefaultScreen(xw.dpy);
-	xw.vis = XDefaultVisual(xw.dpy, xw.scr);
+
+	root = XRootWindow(xw.dpy, xw.scr);
+	if (!(opt_embed && (parent = strtol(opt_embed, NULL, 0))))
+		parent = root;
+
+	if (XMatchVisualInfo(xw.dpy, xw.scr, 32, TrueColor, &vis) != 0) {
+		xw.vis = vis.visual;
+		xw.depth = vis.depth;
+	} else {
+		XGetWindowAttributes(xw.dpy, parent, &attr);
+		xw.vis = attr.visual;
+		xw.depth = attr.depth;
+	}
 
 	/* font */
 	if (!FcInit())
@@ -1148,7 +1173,7 @@ xinit(int cols, int rows)
 	xloadfonts(usedfont, 0);
 
 	/* colors */
-	xw.cmap = XDefaultColormap(xw.dpy, xw.scr);
+	xw.cmap = XCreateColormap(xw.dpy, parent, xw.vis, None);
 	xloadcols();
 
 	/* adjust fixed window geometry */
@@ -1168,11 +1193,8 @@ xinit(int cols, int rows)
 		| ButtonMotionMask | ButtonPressMask | ButtonReleaseMask;
 	xw.attrs.colormap = xw.cmap;
 
-	root = XRootWindow(xw.dpy, xw.scr);
-	if (!(opt_embed && (parent = strtol(opt_embed, NULL, 0))))
-		parent = root;
-	xw.win = XCreateWindow(xw.dpy, root, xw.l, xw.t,
-			win.w, win.h, 0, XDefaultDepth(xw.dpy, xw.scr), InputOutput,
+	xw.win = XCreateWindow(xw.dpy, parent, xw.l, xw.t,
+			win.w, win.h, 0, xw.depth, InputOutput,
 			xw.vis, CWBackPixel | CWBorderPixel | CWBitGravity
 			| CWEventMask | CWColormap, &xw.attrs);
 	if (parent != root)
@@ -1183,7 +1205,7 @@ xinit(int cols, int rows)
 	dc.gc = XCreateGC(xw.dpy, xw.win, GCGraphicsExposures,
 			&gcvalues);
 	xw.buf = XCreatePixmap(xw.dpy, xw.win, win.w, win.h,
-			DefaultDepth(xw.dpy, xw.scr));
+			xw.depth);
 	XSetForeground(xw.dpy, dc.gc, dc.col[defaultbg].pixel);
 	XFillRectangle(xw.dpy, xw.buf, dc.gc, 0, 0, win.w, win.h);
 
@@ -2047,6 +2069,10 @@ main(int argc, char *argv[])
 	case 'a':
 		allowaltscreen = 0;
 		break;
+	case 'A':
+		alpha = strtof(EARGF(usage()), NULL);
+		LIMIT(alpha, 0.0, 1.0);
+		break;
 	case 'c':
 		opt_class = EARGF(usage());
 		break;
