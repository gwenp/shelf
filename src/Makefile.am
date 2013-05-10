include $(top_srcdir)/Makefile.common

shelf_VALAFLAGS = \
	$(SHELF_CORE_VALAFLAGS) \
	$(top_builddir)/lib/shelf.vapi \
	--vapidir $(top_srcdir)/vapi \
	$(top_srcdir)/vapi/config.vapi \
	-C \
	$(NULL)

shelfdir = $(bindir)

BUILT_SOURCES = shelf_vala.stamp

shelf_PROGRAMS = shelf

shelf_CFLAGS = \
	$(SHELF_CORE_CFLAGS) \
	-include config.h \
	-I$(top_builddir)/lib \
	$(NULL)

shelf_LDADD = \
	$(SHELF_CORE_LIBS) \
	$(top_builddir)/lib/libshelf.la \
	$(NULL)

shelf_VALASOURCES = \
	PlankMain.vala \
	$(NULL)

nodist_shelf_SOURCES = \
	shelf_vala.stamp \
	$(shelf_VALASOURCES:.vala=.c) \
	$(NULL)

shelf_vala.stamp: $(shelf_VALASOURCES) Makefile
	$(AM_V_VALA)$(VALAC) \
		$(shelf_VALAFLAGS) \
		$(filter %.vala %.c,$^)
	$(AM_V_at)touch $@

CLEANFILES = \
	$(nodist_shelf_SOURCES) \
	$(NULL)

EXTRA_DIST = \
	$(shelf_VALASOURCES) \
	$(NULL)

