include $(top_srcdir)/Makefile.common

AM_CFLAGS = \
	-DWNCK_I_KNOW_THIS_IS_UNSTABLE \
	$(SHELF_CORE_CFLAGS) \
	-w \
	$(NULL)

AM_LDFLAGS = \
	$(LIBM) \
	$(NULL)

AM_VALAFLAGS = \
	$(SHELF_CORE_VALAFLAGS) \
	--vapidir $(top_srcdir)/vapi \
	$(top_srcdir)/vapi/compat.vapi \
	--basedir $(srcdir) \
	--directory $(builddir) \
	-C \
	$(NULL)

BUILT_SOURCES = \
	libshelf_internal_la_vala.stamp \
	libshelf_la_vala.stamp \
	shelf.h \
	shelf-resources.c \
	$(NULL)

libshelfincludedir = $(includedir)/shelf
nodist_libshelfinclude_HEADERS = shelf.h

vapidir = $(datadir)/vala/vapi
nodist_vapi_DATA = \
	shelf.vapi \
	shelf.deps \
	$(NULL)

pkgconfigdir = $(libdir)/pkgconfig
nodist_pkgconfig_DATA = shelf.pc


lib_LTLIBRARIES = libshelf.la

libshelfdir = $(libdir)

libshelf_la_LDFLAGS = \
	$(AM_LDLAGS) \
	-no-undefined \
	-version-info "$(LT_CURRENT)":"$(LT_REVISION)":"$(LT_AGE)" \
	-export-dynamic \
	-export-symbols-regex '^shelf_.*' \
	$(NULL)

libshelf_la_VALAFLAGS = \
	$(builddir)/shelf-internal.vapi \
	$(NULL)

libshelf_la_LIBADD = \
	$(SHELF_CORE_LIBS) \
	$(builddir)/libshelf-internal.la \
	$(NULL)

libshelf_la_VALASOURCES = \
	Factories/AbstractMain.vala \
	Factories/Factory.vala \
	Factories/ItemFactory.vala \
	System/Logger.vala \
	DockController.vala \
	Widgets/DockWindow.vala \
	Widgets/CompositedWindow.vala \
	$(NULL)

nodist_libshelf_la_SOURCES = \
	$(BUILT_SOURCES) \
	$(libshelf_la_VALASOURCES:.vala=.c) \
	$(NULL)

shelf-resources.c: shelf.gresource.xml Makefile $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir $(top_srcdir)/data $(srcdir)/shelf.gresource.xml)
	$(AM_V_GEN) XMLLINT=$(XMLLINT) $(GLIB_COMPILE_RESOURCES) --target $@ --sourcedir $(top_srcdir)/data --generate --c-name shelf $<

shelf.h shelf.vapi: libshelf_la_vala.stamp

libshelf_la_vala.stamp build-abi: libshelf_internal_la_vala.stamp $(libshelf_la_VALASOURCES) Makefile
	$(AM_V_VALA)$(VALAC) \
		$(AM_VALAFLAGS) $(libshelf_la_VALAFLAGS) \
		-H shelf.h \
		--library shelf \
		--symbols build-abi \
		--vapi shelf.vapi \
		$(filter %.vala %.c,$^)
	$(AM_V_at)touch $@

symbols: build-abi
	@cat $(builddir)/build-abi | sort > $(srcdir)/libshelf.symbols


noinst_LTLIBRARIES = libshelf-internal.la

libshelf_internal_la_CFLAGS = \
	$(AM_CFLAGS) \
	-fvisibility=internal \
	$(NULL)

libshelf_internal_la_LDFLAGS = \
	-avoid-version \
	-non_shared \
	-static \
	$(NULL)

libshelf_internal_la_LIBADD = \
	$(SHELF_CORE_LIBS) \
	$(NULL)

libshelf_internal_la_VALASOURCES = \
	$(NULL)

nodist_libshelf_internal_la_SOURCES = \
	$(libshelf_internal_la_VALASOURCES:.vala=.c) \
	$(NULL)

shelf-internal.h shelf-internal.vapi: libshelf_internal_la_vala.stamp

libshelf_internal_la_vala.stamp: $(libshelf_internal_la_VALASOURCES) Makefile
	$(AM_V_VALA)$(VALAC) \
		$(AM_VALAFLAGS) \
		-H shelf-internal.h \
		--library shelf-internal \
		--vapi shelf-internal.vapi \
		$(filter %.vala %.c,$^)
	$(AM_V_at)touch $@


TESTS = abicheck.sh

CLEANFILES = \
	$(nodist_libshelf_la_SOURCES) \
	$(nodist_libshelf_internal_la_SOURCES) \
	build-abi \
	shelf.deps \
	shelf.pc \
	shelf.vapi \
	shelf.h \
	shelf-internal.vapi \
	shelf-internal.h \
	$(NULL)

EXTRA_DIST = \
	$(libshelf_la_VALASOURCES) \
	$(libshelf_internal_la_VALASOURCES) \
	abicheck.sh \
	libshelf.symbols \
	shelf.deps.in \
	shelf.gresource.xml \
	shelf.pc.in \
	$(NULL)

