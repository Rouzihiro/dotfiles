static const char **hpitems = NULL;
static int hplength = 0;

static int
str_compare(const void *s0_in, const void *s1_in)
{
	const char *s0 = *(const char **)s0_in;
	const char *s1 = *(const char **)s1_in;
	return fstrcmp(s0, s1);
}

static void
parse_hpitems(char *src)
{
	int n = 0;
	char *t;

	for (t = strtok(src, ","); t; t = strtok(NULL, ",")) {
		if (hplength + 1 >= n) {
			if (!(hpitems = realloc(hpitems, (n += 8) * sizeof *hpitems)))
				die("Unable to realloc %zu bytes\n", n * sizeof *hpitems);
		}
		hpitems[hplength++] = t;
	}
}
