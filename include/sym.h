/*
	Multiple tentative defintions in different compilation units are not allowed in standard C.
	DONE(211489420e9f0fc49c58579b3de7e704cc47d97c): Fix symtab definition with respect to standard C so that i can remove the -fcommon hack    
	"If you give me anymore trouble, I'll seal you up in bubble gum and send you flying off into space."
*/

#define NSYMS 20	

struct symtab {
	char *name;
	double (*funcptr)();
	double value;
};

struct symtab *symlook();
