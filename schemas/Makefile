.PHONY = all install

SCHEMAS_PATH = /usr/share/glib-2.0/schemas
GSCHEMA = com.github.trifonovkv.themes-switcher.gschema.xml

all :

clean :

install : $(GSCHEMA)
	$(INSTALL) $^ /usr/share/glib-2.0/schemas/$^
	glib-compile-schemas $(SCHEMAS_PATH) 2> /dev/null

uninstall : 
	rm -f /usr/share/glib-2.0/schemas/$(GSCHEMA)
	glib-compile-schemas $(SCHEMAS_PATH) 2> /dev/null