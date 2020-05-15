.PHONY = all install

SCHEMAS_PATH = $(DESTDIR)/usr/share/glib-2.0/schemas
GSCHEMA = com.github.trifonovkv.themes-switcher.gschema.xml

all :

install : $(GSCHEMA)
	$(INSTALL) $^ $(SCHEMAS_PATH)/$^

uninstall : 
	rm -f $(SCHEMAS_PATH)/$(GSCHEMA)
	glib-compile-schemas $(SCHEMAS_PATH) 2> /dev/null

start :
	glib-compile-schemas $(SCHEMAS_PATH) 2> /dev/null