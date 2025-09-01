static void
buttonpress(XEvent *e)
{
	struct item *item;
	XButtonPressedEvent *ev = &e->xbutton;
	int x = 0, y = 0, h = bh, w, i;
	int cols = columns ? columns : 1;
	int state = CLEANMASK(ev->state, numlockmask);

	if (ev->window != win) {
		/* automatically close dmenu if the user clicks outside of dmenu, but
		 * ignore the scroll wheel and buttons above that. */
		if (ev->button <= Button3) {
			exit(1);
		}
		return;
	}

	/* right-click: exit */
	if (ev->button == Button3)
		exit(1);

	if (prompt && *prompt && (!lines || enabled(PromptIndent)))
		x += promptw;

	/* input field */
	w = (lines > 0 || !matches) ? mw - x : inputw;

	/* left-click on input: clear input,
	 * NOTE: if there is no left-arrow the space for < is reserved so
	 *       add that to the input width */
	if (ev->button == Button1 &&
	   ((lines <= 0 && ev->x >= 0 && ev->x <= x + w +
	   ((!prev || !curr->left) ? TEXTW(lsymbol) : 0)) ||
	   (lines > 0 && ev->y >= y && ev->y <= y + h))) {
		insert(NULL, -cursor);
		drawmenu();
		return;
	}
	/* middle-mouse click: paste selection */
	if (ev->button == Button2) {
		XConvertSelection(dpy, (state & ShiftMask) ? clip : XA_PRIMARY,
		                  utf8, utf8, win, CurrentTime);
		drawmenu();
		return;
	}
	/* scroll up */
	if (ev->button == Button4 && prev) {
		sel = curr = prev;
		calcoffsets();
		drawmenu();
		return;
	}
	/* scroll down */
	if (ev->button == Button5 && next) {
		sel = curr = next;
		calcoffsets();
		drawmenu();
		return;
	}
	if (ev->button != Button1)
		return;
	if (state & ~ControlMask)
		return;
	if (lines > 0) {
		for (i = 0, item = curr; item != next; item = item->right, i++) {

			if (
				(ev->y >= y + ((i % lines) + 1) * bh) && // line y start
				(ev->y <= y + ((i % lines) + 2) * bh) && // line y end
				(ev->x >= x + ((i / lines) * (w / cols))) && // column x start
				(ev->x <= x + ((i / lines + 1) * (w / cols))) // column x end
			) {
				if (enabled(PrintIndex))
					printf("%d\n", (item && !(state & ShiftMask)) ? item->index : -1);
				else if (enabled(ContinuousOutput))
					puts(item->text);
				if (!(state & ControlMask)) {
					sel = item;
					selsel();
					if (disabled(ContinuousOutput) && disabled(PrintIndex))
						printsel();
					exit(0);
				}
				sel = item;
				if (sel) {
					selsel();
					drawmenu();
				}
				return;
			}
		}
	} else if (matches) {
		/* left-click on left arrow */
		x += inputw;
		w = TEXTW(lsymbol);
		if (prev && curr->left) {
			if (ev->x >= x && ev->x <= x + w) {
				sel = curr = prev;
				calcoffsets();
				drawmenu();
				return;
			}
		}
		/* horizontal list: (ctrl)left-click on item */
		for (item = curr; item != next; item = item->right) {
			x += w;
			w = MIN(TEXTW(item->text), mw - x - TEXTW(rsymbol));
			if (ev->x >= x && ev->x <= x + w) {
				if (enabled(PrintIndex))
					printf("%d\n", (item && !(state & ShiftMask)) ? item->index : -1);
				else if (enabled(ContinuousOutput))
					puts(item->text);
				if (!(state & ControlMask)) {
					sel = item;
					selsel();
					if (disabled(ContinuousOutput) && disabled(PrintIndex))
						printsel();
					exit(0);
				}
				sel = item;
				if (sel) {
					selsel();
					drawmenu();
				}
				return;
			}
		}
		/* left-click on right arrow */
		w = TEXTW(rsymbol);
		x = mw - w;
		if (next && ev->x >= x && ev->x <= x + w) {
			sel = curr = next;
			calcoffsets();
			drawmenu();
			return;
		}
	}
}

static void
motionevent(XButtonEvent *ev)
{
	struct item *item;
	int x = 0, y = 0, w, i;
	int cols = columns ? columns : 1;

	if (ev->window != win || matches == 0)
		return;

	if (prompt && *prompt && (!lines || enabled(PromptIndent)))
		x += promptw;

	if (lines > 0) {
		w = mw - x;
		for (i = 0, item = curr; item != next; item = item->right, i++) {
			if (
				(ev->y >= y + ((i % lines) + 1) * bh) && // line y start
				(ev->y <= y + ((i % lines) + 2) * bh) && // line y end
				(ev->x >= x + ((i / lines) * (w / cols))) && // column x start
				(ev->x <= x + ((i / lines + 1) * (w / cols))) // column x end
			) {
				sel = item;
				if (sel) {
					calcoffsets();
					drawmenu();
				}
				return;
			}
		}
	} else {
		x += inputw;
		w = TEXTW(lsymbol);
		/* horizontal list */
		for (item = curr; item != next; item = item->right) {
			x += w;
			w = MIN(TEXTW(item->text), mw - x - TEXTW(rsymbol));
			if (ev->x >= x && ev->x < x + w) {
				sel = item;
				if (sel) {
					calcoffsets();
					drawmenu();
				}
			}
		}
	}
}
