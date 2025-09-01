static int
issel(size_t id)
{
	for (int i = 0; i < selidsize; i++)
		if (selid[i] == id)
			return 1;
	return 0;
}

static void
printsel(void)
{
	for (int i = 0; i < selidsize; i++) {
		if (selid[i] != -1 && (!sel || sel->id != selid[i])) {
			if (enabled(PrintIndex))
				printf("%d\n", selid[i]);
			else if (double_print && separator && items[selid[i]].text != items[selid[i]].text_output) {
				if (separator_reverse) {
					printf("%s%c%s\n", items[selid[i]].text_output, separator, items[selid[i]].text);
				} else {
					printf("%s%c%s\n", items[selid[i]].text, separator, items[selid[i]].text_output);
				}
			}
			else
				puts(items[selid[i]].text_output);
		}
	}

	if (enabled(PrintIndex))
		printf("%d\n", sel->index);
	else if (double_print && separator && sel->text != sel->text_output) {
		if (separator_reverse) {
			printf("%s%c%s\n", sel->text_output, separator, sel->text);
		} else {
			printf("%s%c%s\n", sel->text, separator, sel->text_output);
		}
	}
	else
		puts(sel->text_output);

}

static void
printinput(void)
{
	for (int i = 0; i < selidsize; i++) {
		if (selid[i] != -1 && (!sel || sel->id != selid[i])) {
			if (enabled(PrintIndex))
				printf("%d\n", selid[i]);
			else
				puts(items[selid[i]].text_output);
		}
	}
	puts(text);
}

static void
selsel(void)
{
	if (!sel)
		return;
	if (issel(sel->id)) {
		for (int i = 0; i < selidsize; i++)
			if (selid[i] == sel->id)
				selid[i] = -1;
	} else {
		for (int i = 0; i < selidsize; i++)
			if (selid[i] == -1) {
				selid[i] = sel->id;
				return;
			}
		selidsize++;
		selid = realloc(selid, (selidsize + 1) * sizeof(int));
		selid[selidsize - 1] = sel->id;
	}
}
