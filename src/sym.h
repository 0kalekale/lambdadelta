/*
	Multiple tentative defintions in different compilation units are not allowed in standard C.
	TODO: Fix symtab definition with respect to standard C so that i can remove the -fcommon hack,    
	"If you give me anymore trouble, I'll seal you up in bubble gum and send you flying off into space"
*/

#define NSYMS 20	

extern struct symtab {
	char *name;
	double (*funcptr)();
	double value;
} symtab[NSYMS];

extern struct symtab *symlook();
