void
exactmatch(void)
{
	static char **tokv = NULL;
	static int tokn = 0;

	int buflen = sizeof text;
	char buf[buflen], *s;
	int i, tokc = 0;
	int sort = enabled(Sort);
	size_t len, textsize;
	struct item *item, *lprefix, *lsubstr, *prefixend, *substrend;
	struct item *lhpprefix, *hpprefixend;

	strlcpy(buf, text, buflen);
	/* separate input text into tokens to be matched individually */
	for (s = strtok(buf, " "); s; tokv[tokc - 1] = s, s = strtok(NULL, " "))
		if (++tokc > tokn && !(tokv = realloc(tokv, ++tokn * sizeof *tokv)))
			die("cannot realloc %zu bytes:", tokn * sizeof *tokv);
	len = tokc ? strlen(tokv[0]) : 0;

	matches = lprefix = lsubstr = matchend = prefixend = substrend = NULL;
	textsize = strlen(text) + 1;
	lhpprefix = hpprefixend = NULL;
	for (item = items; item && item->text; item++)
	{
		for (i = 0; i < tokc; i++)
			if (!fstrstr(item->text, tokv[i]))
				break;
		if (i != tokc && !(dynamic && *dynamic)) /* not all tokens match */
			continue;
		/* exact matches go first, then prefixes with high priority, then prefixes, then substrings */
		if (!tokc || !sort || !fstrncmp(text, item->text, textsize))
			appenditem(item, &matches, &matchend);
		else if (item->hp && !fstrncmp(tokv[0], item->text, len))
			appenditem(item, &lhpprefix, &hpprefixend);
		else if (!fstrncmp(tokv[0], item->text, len))
			appenditem(item, &lprefix, &prefixend);
		else
			appenditem(item, &lsubstr, &substrend);
	}
	if (lhpprefix) {
		if (matches) {
			matchend->right = lhpprefix;
			lhpprefix->left = matchend;
		} else
			matches = lhpprefix;
		matchend = hpprefixend;
	}
	if (lprefix) {
		if (matches) {
			matchend->right = lprefix;
			lprefix->left = matchend;
		} else
			matches = lprefix;
		matchend = prefixend;
	}
	if (lsubstr) {
		if (matches) {
			matchend->right = lsubstr;
			lsubstr->left = matchend;
		} else
			matches = lsubstr;
		matchend = substrend;
	}
	curr = sel = matches;

	if (enabled(InstantReturn) && matches && matches==matchend && !lsubstr) {
		printsel();
		cleanup();
		exit(0);
	}

	calcoffsets();
}
