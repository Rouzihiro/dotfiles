static void
drawhighlights(struct item *item, int x, int y, int maxw)
{
	int i, indent, highlightlen;
	char *highlight, *token;
	int num_tokens = sizeof text;
	char restorechar, tokens[num_tokens];
	char *itemtext = item->text;

	if (!(strlen(itemtext) && strlen(text)))
		return;

	/* Do not highlight items scheduled for output */
	if (issel(item->id))
		return;

	drw_setscheme(drw, scheme[item == sel ? SchemeSelHighlight : SchemeNormHighlight]);

	if (enabled(FuzzyMatch)) {
		for (i = 0, highlight = itemtext; *highlight && text[i];) {
			highlightlen = utf8len(highlight);
			if (!fstrncmp(&(*highlight), &text[i], highlightlen)) {
				/* Get indentation */
				restorechar = *highlight;
				*highlight = '\0';
				indent = TEXTW(itemtext) - lrpad;
				*highlight = restorechar;

				/* Highlight character */
				restorechar = highlight[highlightlen];
				highlight[highlightlen] = '\0';
				drw_text(
					drw,
					x + indent + (lrpad / 2),
					y,
					MIN(maxw - indent - lrpad, TEXTW(highlight) - lrpad),
					bh, 0, highlight, 0);
				highlight[highlightlen] = restorechar;
				i += highlightlen;
			}
			highlight++;
		}
		return;
	}

	/* Exact highlighting */
	strlcpy(tokens, text, num_tokens);
	for (token = strtok(tokens, " "); token; token = strtok(NULL, " ")) {
		highlight = fstrstr(itemtext, token);
		while (highlight) {
			// Move item str end, calc width for highlight indent, & restore
			highlightlen = highlight - itemtext;
			restorechar = *highlight;
			itemtext[highlightlen] = '\0';
			indent = TEXTW(itemtext);
			itemtext[highlightlen] = restorechar;

			// Move highlight str end, draw highlight, & restore
			restorechar = highlight[strlen(token)];
			highlight[strlen(token)] = '\0';
			if (indent - (lrpad / 2) - 1 < maxw)
				drw_text(
					drw,
					x + indent - (lrpad / 2) - 1,
					y,
					MIN(maxw - indent, TEXTW(highlight) - lrpad),
					bh, 0, highlight, 0);
			highlight[strlen(token)] = restorechar;

			if (strlen(highlight) - strlen(token) < strlen(token))
				break;
			highlight = fstrstr(highlight + strlen(token), token);
		}
	}
}
