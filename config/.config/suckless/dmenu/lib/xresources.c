#include <X11/Xresource.h>

void
readxresources(void)
{
	XrmInitialize();
	int s;
	int len = 40;
	char resource[len];
	char *pattern = "dmenu.%s.%s.color";

	char* xrm;
	if ((xrm = XResourceManagerString(drw->dpy))) {
		char *type;
		XrmDatabase xdb = XrmGetStringDatabase(xrm);
		XrmValue xval;

		if (XrmGetResource(xdb, "dmenu.font", "*", &type, &xval))
			fonts[0] = strdup(xval.addr);

		if (XrmGetResource(xdb, "dmenu.selfont", "*", &type, &xval))
			selfonts[0] = strdup(xval.addr);

		if (XrmGetResource(xdb, "dmenu.outfont", "*", &type, &xval))
			outfonts[0] = strdup(xval.addr);

		for (s = 0; s < SchemeLast; s++) {
			snprintf(resource, len, pattern, colors[s][ColResource], "fg");
			if (XrmGetResource(xdb, resource, "*", &type, &xval))
				colors[s][ColFg] = strdup(xval.addr);

			snprintf(resource, len, pattern, colors[s][ColResource], "bg");
			if (XrmGetResource(xdb, resource, "*", &type, &xval))
				colors[s][ColBg] = strdup(xval.addr);
		}

		XrmDestroyDatabase(xdb);
	}
}
