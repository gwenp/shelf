distclean_dirs = \
	shelf \
	gtk-doc \
	$(NULL)

phony_deps = \
	shelf-doc \
	shelf-gtk-doc \
	$(NULL)

shelfdocdir=$(datadir)/devhelp/references/shelf
shelfimgdir=$(datadir)/devhelp/references/shelf/img
shelfgtkdocdir=$(datadir)/gtk-doc/html/shelf

common_doc_files = \
	*.css \
	*.png \
	*.js \
	index.htm \
	*.html \
	$(NULL)

shelfdoc_DATA = \
	shelf/shelf/shelf.devhelp2 \
	$(addprefix shelf/shelf/,$(common_doc_files)) \
	$(NULL)

shelfgtkdoc_DATA = gtk-doc/shelf/html/*

shelfimg_DATA = \
	shelf/shelf/img/*.png \
	$(NULL)

$(shelfdoc_DATA) $(shelfimg_DATA): shelf-doc
$(shelfgtkdoc_DATA): shelf-gtk-doc

valadoc_flags = \
	--force \
	--verbose \
	--package-name $(PACKAGE_NAME) \
	--package-version $(PACKAGE_VERSION) \
	$(NULL)

# shelf documentation
shelf_doc_files = \
	$(top_srcdir)/lib/DockController.vala \
	$(top_srcdir)/lib/DockPreferences.vala \
	$(top_srcdir)/lib/DockRenderer.vala \
	$(top_srcdir)/lib/DragManager.vala \
	$(top_srcdir)/lib/HideManager.vala \
	$(top_srcdir)/lib/PositionManager.vala \
	$(top_srcdir)/lib/Drawing/AnimatedRenderer.vala \
	$(top_srcdir)/lib/Drawing/Color.vala \
	$(top_srcdir)/lib/Drawing/DrawingService.vala \
	$(top_srcdir)/lib/Drawing/DockSurface.vala \
	$(top_srcdir)/lib/Drawing/DockTheme.vala \
	$(top_srcdir)/lib/Drawing/HoverTheme.vala \
	$(top_srcdir)/lib/Drawing/Theme.vala \
	$(top_srcdir)/lib/Factories/AbstractMain.vala \
	$(top_srcdir)/lib/Factories/Factory.vala \
	$(top_srcdir)/lib/Factories/ItemFactory.vala \
	$(top_srcdir)/lib/Items/ApplicationDockItem.vala \
	$(top_srcdir)/lib/Items/ApplicationDockItemProvider.vala \
	$(top_srcdir)/lib/Items/DockItem.vala \
	$(top_srcdir)/lib/Items/DockItemProvider.vala \
	$(top_srcdir)/lib/Items/DockItemPreferences.vala \
	$(top_srcdir)/lib/Items/FileDockItem.vala \
	$(top_srcdir)/lib/Items/PlankDockItem.vala \
	$(top_srcdir)/lib/Items/TransientDockItem.vala \
	$(top_srcdir)/lib/Services/Logger.vala \
	$(top_srcdir)/lib/Services/Paths.vala \
	$(top_srcdir)/lib/Services/Preferences.vala \
	$(top_srcdir)/lib/Services/System.vala \
	$(top_srcdir)/lib/Widgets/CompositedWindow.vala \
	$(top_srcdir)/lib/Widgets/DockWindow.vala \
	$(top_srcdir)/lib/Widgets/HoverWindow.vala \
	$(top_srcdir)/lib/Widgets/PoofWindow.vala \
	$(top_srcdir)/lib/Widgets/TitledSeparatorMenuItem.vala \
	$(NULL)

valadoc_flags_shelf = \
	$(valadoc_flags) \
	$(SHELF_DOCS_VALAFLAGS) \
	--pkg shelf-internal \
	--pkg compat \
	--vapidir=$(top_builddir)/lib \
	--vapidir=$(top_srcdir)/vapi \
	$(shelf_doc_files) \
	$(NULL)

shelf-doc: $(shelf_doc_files)
	$(AM_V_GEN)$(VALADOC) \
		-o shelf/ \
		--doclet=html \
		$(valadoc_flags_shelf) \
		$(NULL)

shelf-gtk-doc: $(shelf_doc_files)
	$(AM_V_GEN)$(VALADOC) \
		-X -l -X $(top_builddir)/lib/.libs/libshelf.so \
		-X $(top_builddir)/lib/shelf.h \
		-o gtk-doc/shelf \
		--doclet=gtkdoc \
		$(valadoc_flags_shelf) \
		$(NULL)

.PHONY: $(phony_deps)

distclean-local: distclean-docs
distclean-docs:
	rm -rf $(distclean_dirs)

