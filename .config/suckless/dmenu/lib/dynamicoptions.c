static void
refreshoptions(void)
{
	int dynlen = strlen(dynamic);
	int cmdlen = dynlen + strlen(text) + 2;
	char* cmd = malloc(cmdlen);

	/* Clear selections on refresh */
	for (int i = 0; i < selidsize; i++)
		selid[i] = -1;

	if (cmd == NULL)
		die("malloc:");
	snprintf(cmd, cmdlen, "%s %s", dynamic, text);
	FILE *stream = popen(cmd, "r");
	if (!stream)
		die("popen(%s):", cmd);
	readstream(stream);
	int pc = pclose(stream);
	if (pc == -1)
		die("pclose:");
	free(cmd);
	curr = sel = items;
}

static void
readstream(FILE* stream)
{
	char buf[sizeof text], *p;
	size_t i, imax = 0, size = 0;
	XGlyphInfo ext;

	/* read each line from stdin and add it to the item list */
	for (i = 0; fgets(buf, sizeof buf, stream); i++) {
		if (i + 1 >= size / sizeof *items)
			if (!(items = realloc(items, (size += BUFSIZ))))
				die("cannot realloc %zu bytes:", size);
		if ((p = strchr(buf, '\n')))
			*p = '\0';
		if (!(items[i].text = strdup(buf)))
			die("cannot strdup %zu bytes:", strlen(buf) + 1);
		if (separator && (p = sepchr(items[i].text, separator)) != NULL) {
			*p = '\0';
			items[i].text_output = ++p;
		} else {
			items[i].text_output = items[i].text;
		}
		if (separator_reverse) {
			p = items[i].text;
			items[i].text = items[i].text_output;
			items[i].text_output = p;
		}
		items[i].id = i;
		p = hpitems == NULL ? NULL : bsearch(
			&items[i].text, hpitems, hplength, sizeof *hpitems,
			str_compare
		);
		items[i].hp = p != NULL;
		XftTextExtentsUtf8(drw->fonts->dpy, drw->fonts->xfont, (XftChar8 *)buf, strlen(buf), &ext);
		if (ext.xOff > inputw) {
			inputw = ext.xOff;
			imax = i;
		}
	}

	/* If the command did not give any output at all, then do not clear the existing items */
	if (!i)
		return;

	if (items)
		items[i].text = NULL;
	inputw = items ? TEXTW(items[imax].text) : 0;
	if (!dynamic || !*dynamic)
		lines = MIN(lines, i);
	else {
		text[0] = '\0';
		cursor = 0;
	}
}
