/* See LICENSE file for copyright and license details. */

#include <stdint.h>

#ifndef MAX
#define MAX(A, B)               ((A) > (B) ? (A) : (B))
#endif
#ifndef MIN
#define MIN(A, B)               ((A) < (B) ? (A) : (B))
#endif
#define BETWEEN(X, A, B)        ((A) <= (X) && (X) <= (B))
#define LENGTH(X)               (sizeof (X) / sizeof (X)[0])

static const uint64_t
	Alpha = 0x1, // enables transparency
	TopBar = 0x2, // dmenu appears at the top of the screen
	Centered = 0x4, // dmenu appears in the center of the screen
	Xresources = 0x8, // makes dmenu read X resources at startup
	ColorEmoji = 0x10, // enables color emoji support (removes Xft workaround)
	Managed = 0x20, // allow dmenu to be managed by window managers (disables override_redirect)
	Sort = 0x40, // allow dmenu to sort menu items after matching
	CaseSensitive = 0x80, // makes dmenu case sensitive by default
	PrintIndex = 0x100, // makes dmenu print out the 0-based index instead of the matched text itself
	ShowNumbers = 0x200, // makes dmenu display the number of matched and total items in the top right corner
	PasswordInput = 0x400, // indicates that the input is a password and should be masked
	PromptIndent = 0x800, // prevents dmenu from indenting items at the same level as the prompt on multi-line views
	InstantReturn = 0x1000, // makes dmenu select an item immediately if there is only one matching option left
	RestrictReturn = 0x2000, // disables Shift-Return and Ctrl-Return to restrict dmenu to only output one item
	NoInput = 0x4000, // disables the input field in dmenu, forcing the user to select options using mouse or keyboard
	RejectNoMatch = 0x8000, // makes dmenu reject input if it would result in no matching item
	Incremental = 0x10000, // makes dmenu print out the current text each time a key is pressed
	HighlightAdjacent = 0x20000, // makes dmenu highlight items adjacent to the selected item
	ContinuousOutput = 0x40000, // makes dmenu print out selected items immediately rather than at the end
	FuzzyMatch = 0x80000, // allows fuzzy-matching of items in dmenu
	PrintInputText = 0x100000, // makes dmenu print the input text instead of the selected item
	FuncPlaceholder0x200000 = 0x200000,
	FuncPlaceholder0x400000 = 0x400000,
	FuncPlaceholder0x800000 = 0x800000,
	FuncPlaceholder0x1000000 = 0x1000000,
	FuncPlaceholder0x2000000 = 0x2000000,
	FuncPlaceholder0x4000000 = 0x4000000,
	FuncPlaceholder0x8000000 = 0x8000000,
	FuncPlaceholder0x10000000 = 0x10000000,
	FuncPlaceholder0x20000000 = 0x20000000,
	FuncPlaceholder0x40000000 = 0x40000000,
	FuncPlaceholder0x80000000 = 0x80000000,
	FuncPlaceholder0x100000000 = 0x100000000,
	FuncPlaceholder0x200000000 = 0x200000000,
	FuncPlaceholder0x400000000 = 0x400000000,
	FuncPlaceholder0x800000000 = 0x800000000,
	FuncPlaceholder0x1000000000 = 0x1000000000,
	FuncPlaceholder0x2000000000 = 0x2000000000,
	FuncPlaceholder0x4000000000 = 0x4000000000,
	FuncPlaceholder0x8000000000 = 0x8000000000,
	FuncPlaceholder0x10000000000 = 0x10000000000,
	FuncPlaceholder0x20000000000 = 0x20000000000,
	FuncPlaceholder0x40000000000 = 0x40000000000,
	FuncPlaceholder0x80000000000 = 0x80000000000,
	FuncPlaceholder0x100000000000 = 0x100000000000,
	FuncPlaceholder0x200000000000 = 0x200000000000,
	FuncPlaceholder0x400000000000 = 0x400000000000,
	FuncPlaceholder0x800000000000 = 0x800000000000,
	FuncPlaceholder0x1000000000000 = 0x1000000000000,
	FuncPlaceholder0x2000000000000 = 0x2000000000000,
	FuncPlaceholder0x4000000000000 = 0x4000000000000,
	FuncPlaceholder0x8000000000000 = 0x8000000000000,
	FuncPlaceholder0x10000000000000 = 0x10000000000000,
	FuncPlaceholder0x20000000000000 = 0x20000000000000,
	FuncPlaceholder0x40000000000000 = 0x40000000000000,
	FuncPlaceholder0x80000000000000 = 0x80000000000000,
	FuncPlaceholder0x100000000000000 = 0x100000000000000,
	FuncPlaceholder0x200000000000000 = 0x200000000000000,
	FuncPlaceholder0x400000000000000 = 0x400000000000000,
	FuncPlaceholder0x800000000000000 = 0x800000000000000,
	FuncPlaceholder0x1000000000000000 = 0x1000000000000000,
	FuncPlaceholder0x2000000000000000 = 0x2000000000000000,
	FuncPlaceholder0x4000000000000000 = 0x4000000000000000,
	FuncPlaceholder0x8000000000000000 = 0x8000000000000000;

void die(const char *fmt, ...);
void *ecalloc(size_t nmemb, size_t size);
int enabled(const long functionality);
int disabled(const long functionality);
void enablefunc(const long functionality);
void disablefunc(const long functionality);
void togglefunc(const long functionality);
#ifdef __linux__
size_t strlcpy(char * __restrict dst, const char * __restrict src, size_t dsize);
#endif /* __linux__ */
