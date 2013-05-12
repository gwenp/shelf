/* DockRenderer.c generated by valac 0.20.1.4-f5a54, the Vala compiler
 * generated from DockRenderer.vala, do not modify */

/**/
/*  Copyright (C) 2011-2012 Robert Dyer, Michal Hruby, Rico Tzschichholz*/
/**/
/*  This program is free software: you can redistribute it and/or modify*/
/*  it under the terms of the GNU General Public License as published by*/
/*  the Free Software Foundation, either version 3 of the License, or*/
/*  (at your option) any later version.*/
/**/
/*  This program is distributed in the hope that it will be useful,*/
/*  but WITHOUT ANY WARRANTY; without even the implied warranty of*/
/*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the*/
/*  GNU General Public License for more details.*/
/**/
/*  You should have received a copy of the GNU General Public License*/
/*  along with this program.  If not, see <http://www.gnu.org/licenses/>.*/
/**/

#include <glib.h>
#include <glib-object.h>
#include <cairo.h>
#include <float.h>
#include <math.h>
#include <gtk/gtk.h>


#define SHELF_DRAWING_TYPE_DOCK_RENDERER (shelf_drawing_dock_renderer_get_type ())
#define SHELF_DRAWING_DOCK_RENDERER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SHELF_DRAWING_TYPE_DOCK_RENDERER, ShelfDrawingDockRenderer))
#define SHELF_DRAWING_DOCK_RENDERER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SHELF_DRAWING_TYPE_DOCK_RENDERER, ShelfDrawingDockRendererClass))
#define SHELF_DRAWING_IS_DOCK_RENDERER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SHELF_DRAWING_TYPE_DOCK_RENDERER))
#define SHELF_DRAWING_IS_DOCK_RENDERER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SHELF_DRAWING_TYPE_DOCK_RENDERER))
#define SHELF_DRAWING_DOCK_RENDERER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SHELF_DRAWING_TYPE_DOCK_RENDERER, ShelfDrawingDockRendererClass))

typedef struct _ShelfDrawingDockRenderer ShelfDrawingDockRenderer;
typedef struct _ShelfDrawingDockRendererClass ShelfDrawingDockRendererClass;
typedef struct _ShelfDrawingDockRendererPrivate ShelfDrawingDockRendererPrivate;

#define SHELF_TYPE_DOCK_CONTROLLER (shelf_dock_controller_get_type ())
#define SHELF_DOCK_CONTROLLER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SHELF_TYPE_DOCK_CONTROLLER, ShelfDockController))
#define SHELF_DOCK_CONTROLLER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SHELF_TYPE_DOCK_CONTROLLER, ShelfDockControllerClass))
#define SHELF_IS_DOCK_CONTROLLER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SHELF_TYPE_DOCK_CONTROLLER))
#define SHELF_IS_DOCK_CONTROLLER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SHELF_TYPE_DOCK_CONTROLLER))
#define SHELF_DOCK_CONTROLLER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SHELF_TYPE_DOCK_CONTROLLER, ShelfDockControllerClass))

typedef struct _ShelfDockController ShelfDockController;
typedef struct _ShelfDockControllerClass ShelfDockControllerClass;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
typedef struct _ShelfDockControllerPrivate ShelfDockControllerPrivate;

#define SHELF_WIDGETS_TYPE_COMPOSITED_WINDOW (shelf_widgets_composited_window_get_type ())
#define SHELF_WIDGETS_COMPOSITED_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SHELF_WIDGETS_TYPE_COMPOSITED_WINDOW, ShelfWidgetsCompositedWindow))
#define SHELF_WIDGETS_COMPOSITED_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SHELF_WIDGETS_TYPE_COMPOSITED_WINDOW, ShelfWidgetsCompositedWindowClass))
#define SHELF_WIDGETS_IS_COMPOSITED_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SHELF_WIDGETS_TYPE_COMPOSITED_WINDOW))
#define SHELF_WIDGETS_IS_COMPOSITED_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SHELF_WIDGETS_TYPE_COMPOSITED_WINDOW))
#define SHELF_WIDGETS_COMPOSITED_WINDOW_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SHELF_WIDGETS_TYPE_COMPOSITED_WINDOW, ShelfWidgetsCompositedWindowClass))

typedef struct _ShelfWidgetsCompositedWindow ShelfWidgetsCompositedWindow;
typedef struct _ShelfWidgetsCompositedWindowClass ShelfWidgetsCompositedWindowClass;

#define SHELF_WIDGETS_TYPE_DOCK_WINDOW (shelf_widgets_dock_window_get_type ())
#define SHELF_WIDGETS_DOCK_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SHELF_WIDGETS_TYPE_DOCK_WINDOW, ShelfWidgetsDockWindow))
#define SHELF_WIDGETS_DOCK_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SHELF_WIDGETS_TYPE_DOCK_WINDOW, ShelfWidgetsDockWindowClass))
#define SHELF_WIDGETS_IS_DOCK_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SHELF_WIDGETS_TYPE_DOCK_WINDOW))
#define SHELF_WIDGETS_IS_DOCK_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SHELF_WIDGETS_TYPE_DOCK_WINDOW))
#define SHELF_WIDGETS_DOCK_WINDOW_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SHELF_WIDGETS_TYPE_DOCK_WINDOW, ShelfWidgetsDockWindowClass))

typedef struct _ShelfWidgetsDockWindow ShelfWidgetsDockWindow;
typedef struct _ShelfWidgetsDockWindowClass ShelfWidgetsDockWindowClass;

#define SHELF_SYSTEM_TYPE_DOCK_POSITION_MANAGER (shelf_system_dock_position_manager_get_type ())
#define SHELF_SYSTEM_DOCK_POSITION_MANAGER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SHELF_SYSTEM_TYPE_DOCK_POSITION_MANAGER, ShelfSystemDockPositionManager))
#define SHELF_SYSTEM_DOCK_POSITION_MANAGER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SHELF_SYSTEM_TYPE_DOCK_POSITION_MANAGER, ShelfSystemDockPositionManagerClass))
#define SHELF_SYSTEM_IS_DOCK_POSITION_MANAGER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SHELF_SYSTEM_TYPE_DOCK_POSITION_MANAGER))
#define SHELF_SYSTEM_IS_DOCK_POSITION_MANAGER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SHELF_SYSTEM_TYPE_DOCK_POSITION_MANAGER))
#define SHELF_SYSTEM_DOCK_POSITION_MANAGER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SHELF_SYSTEM_TYPE_DOCK_POSITION_MANAGER, ShelfSystemDockPositionManagerClass))

typedef struct _ShelfSystemDockPositionManager ShelfSystemDockPositionManager;
typedef struct _ShelfSystemDockPositionManagerClass ShelfSystemDockPositionManagerClass;

#define SHELF_ITEMS_TYPE_TAB_MANAGER (shelf_items_tab_manager_get_type ())
#define SHELF_ITEMS_TAB_MANAGER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SHELF_ITEMS_TYPE_TAB_MANAGER, ShelfItemsTabManager))
#define SHELF_ITEMS_TAB_MANAGER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SHELF_ITEMS_TYPE_TAB_MANAGER, ShelfItemsTabManagerClass))
#define SHELF_ITEMS_IS_TAB_MANAGER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SHELF_ITEMS_TYPE_TAB_MANAGER))
#define SHELF_ITEMS_IS_TAB_MANAGER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SHELF_ITEMS_TYPE_TAB_MANAGER))
#define SHELF_ITEMS_TAB_MANAGER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SHELF_ITEMS_TYPE_TAB_MANAGER, ShelfItemsTabManagerClass))

typedef struct _ShelfItemsTabManager ShelfItemsTabManager;
typedef struct _ShelfItemsTabManagerClass ShelfItemsTabManagerClass;

struct _ShelfDrawingDockRenderer {
	GObject parent_instance;
	ShelfDrawingDockRendererPrivate * priv;
};

struct _ShelfDrawingDockRendererClass {
	GObjectClass parent_class;
};

struct _ShelfDrawingDockRendererPrivate {
	ShelfDockController* _controller;
};

struct _ShelfDockController {
	GObject parent_instance;
	ShelfDockControllerPrivate * priv;
	ShelfWidgetsDockWindow* window;
	ShelfDrawingDockRenderer* renderer;
	ShelfSystemDockPositionManager* position_manager;
	ShelfItemsTabManager* tab_manager;
};

struct _ShelfDockControllerClass {
	GObjectClass parent_class;
};

typedef void (*ShelfDrawingDockRendererDrawMethod) (void* user_data);

static gpointer shelf_drawing_dock_renderer_parent_class = NULL;

GType shelf_drawing_dock_renderer_get_type (void) G_GNUC_CONST;
GType shelf_dock_controller_get_type (void) G_GNUC_CONST;
#define SHELF_DRAWING_DOCK_RENDERER_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), SHELF_DRAWING_TYPE_DOCK_RENDERER, ShelfDrawingDockRendererPrivate))
enum  {
	SHELF_DRAWING_DOCK_RENDERER_DUMMY_PROPERTY,
	SHELF_DRAWING_DOCK_RENDERER_CONTROLLER
};
ShelfDrawingDockRenderer* shelf_drawing_dock_renderer_new (ShelfDockController* controller);
ShelfDrawingDockRenderer* shelf_drawing_dock_renderer_construct (GType object_type, ShelfDockController* controller);
gboolean shelf_drawing_dock_renderer_draw (ShelfDrawingDockRenderer* self, cairo_t* cr);
static ShelfDockController* shelf_drawing_dock_renderer_get_controller (ShelfDrawingDockRenderer* self);
GType shelf_widgets_composited_window_get_type (void) G_GNUC_CONST;
GType shelf_widgets_dock_window_get_type (void) G_GNUC_CONST;
GType shelf_system_dock_position_manager_get_type (void) G_GNUC_CONST;
GType shelf_items_tab_manager_get_type (void) G_GNUC_CONST;
void shelf_items_tab_manager_draw (ShelfItemsTabManager* self, cairo_t* cr);
static void shelf_drawing_dock_renderer_stroke_shapes (ShelfDrawingDockRenderer* self, cairo_t* ctx, gint x, gint y);
static void shelf_drawing_dock_renderer_draw_shapes (ShelfDrawingDockRenderer* self, cairo_t* ctx, gint x, gint y, ShelfDrawingDockRendererDrawMethod draw_method, void* draw_method_target);
static void _cairo_stroke_shelf_drawing_dock_renderer_draw_method (gpointer self);
static void shelf_drawing_dock_renderer_fill_shapes (ShelfDrawingDockRenderer* self, cairo_t* ctx, gint x, gint y);
static void _cairo_fill_shelf_drawing_dock_renderer_draw_method (gpointer self);
static void shelf_drawing_dock_renderer_bowtie (ShelfDrawingDockRenderer* self, cairo_t* ctx);
static void shelf_drawing_dock_renderer_square (ShelfDrawingDockRenderer* self, cairo_t* ctx);
static void shelf_drawing_dock_renderer_triangle (ShelfDrawingDockRenderer* self, cairo_t* ctx);
static void shelf_drawing_dock_renderer_inf (ShelfDrawingDockRenderer* self, cairo_t* ctx);
static void shelf_drawing_dock_renderer_set_controller (ShelfDrawingDockRenderer* self, ShelfDockController* value);
static GObject * shelf_drawing_dock_renderer_constructor (GType type, guint n_construct_properties, GObjectConstructParam * construct_properties);
static void shelf_drawing_dock_renderer_finalize (GObject* obj);
static void _vala_shelf_drawing_dock_renderer_get_property (GObject * object, guint property_id, GValue * value, GParamSpec * pspec);
static void _vala_shelf_drawing_dock_renderer_set_property (GObject * object, guint property_id, const GValue * value, GParamSpec * pspec);


/**
 * Creates a new dock window.
 */
ShelfDrawingDockRenderer* shelf_drawing_dock_renderer_construct (GType object_type, ShelfDockController* controller) {
	ShelfDrawingDockRenderer * self = NULL;
	ShelfDockController* _tmp0_;
#line 40 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_val_if_fail (controller != NULL, NULL);
#line 42 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = controller;
#line 42 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	self = (ShelfDrawingDockRenderer*) g_object_new (object_type, "controller", _tmp0_, NULL);
#line 40 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	return self;
#line 169 "DockRenderer.c"
}


ShelfDrawingDockRenderer* shelf_drawing_dock_renderer_new (ShelfDockController* controller) {
#line 40 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	return shelf_drawing_dock_renderer_construct (SHELF_DRAWING_TYPE_DOCK_RENDERER, controller);
#line 176 "DockRenderer.c"
}


/**
 * {@inheritDoc}
 */
gboolean shelf_drawing_dock_renderer_draw (ShelfDrawingDockRenderer* self, cairo_t* cr) {
	gboolean result = FALSE;
	cairo_t* _tmp0_;
	cairo_t* _tmp1_;
	cairo_t* _tmp2_;
	cairo_t* _tmp3_;
	ShelfDockController* _tmp4_;
	ShelfItemsTabManager* _tmp5_;
	cairo_t* _tmp6_;
#line 56 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_val_if_fail (self != NULL, FALSE);
#line 56 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_val_if_fail (cr != NULL, FALSE);
#line 60 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = cr;
#line 60 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_set_source_rgb (_tmp0_, (gdouble) 0, (gdouble) 0, (gdouble) 0);
#line 62 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp1_ = cr;
#line 62 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_set_line_width (_tmp1_, (gdouble) (10 / 4));
#line 63 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp2_ = cr;
#line 63 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_set_tolerance (_tmp2_, 0.1);
#line 65 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp3_ = cr;
#line 65 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_set_line_join (_tmp3_, CAIRO_LINE_JOIN_ROUND);
#line 67 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp4_ = self->priv->_controller;
#line 67 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp5_ = _tmp4_->tab_manager;
#line 67 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp6_ = cr;
#line 67 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	shelf_items_tab_manager_draw (_tmp5_, _tmp6_);
#line 68 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	result = TRUE;
#line 68 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	return result;
#line 224 "DockRenderer.c"
}


static void _cairo_stroke_shelf_drawing_dock_renderer_draw_method (gpointer self) {
#line 72 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_stroke (self);
#line 231 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_stroke_shapes (ShelfDrawingDockRenderer* self, cairo_t* ctx, gint x, gint y) {
	cairo_t* _tmp0_;
	gint _tmp1_;
	gint _tmp2_;
	cairo_t* _tmp3_;
#line 71 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (self != NULL);
#line 71 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (ctx != NULL);
#line 72 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = ctx;
#line 72 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp1_ = x;
#line 72 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp2_ = y;
#line 72 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp3_ = ctx;
#line 72 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	shelf_drawing_dock_renderer_draw_shapes (self, _tmp0_, _tmp1_, _tmp2_, _cairo_stroke_shelf_drawing_dock_renderer_draw_method, _tmp3_);
#line 254 "DockRenderer.c"
}


static void _cairo_fill_shelf_drawing_dock_renderer_draw_method (gpointer self) {
#line 76 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_fill (self);
#line 261 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_fill_shapes (ShelfDrawingDockRenderer* self, cairo_t* ctx, gint x, gint y) {
	cairo_t* _tmp0_;
	gint _tmp1_;
	gint _tmp2_;
	cairo_t* _tmp3_;
#line 75 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (self != NULL);
#line 75 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (ctx != NULL);
#line 76 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = ctx;
#line 76 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp1_ = x;
#line 76 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp2_ = y;
#line 76 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp3_ = ctx;
#line 76 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	shelf_drawing_dock_renderer_draw_shapes (self, _tmp0_, _tmp1_, _tmp2_, _cairo_fill_shelf_drawing_dock_renderer_draw_method, _tmp3_);
#line 284 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_draw_shapes (ShelfDrawingDockRenderer* self, cairo_t* ctx, gint x, gint y, ShelfDrawingDockRendererDrawMethod draw_method, void* draw_method_target) {
	cairo_t* _tmp0_;
	cairo_t* _tmp1_;
	cairo_t* _tmp2_;
	gint _tmp3_;
	gint _tmp4_;
	cairo_t* _tmp5_;
	ShelfDrawingDockRendererDrawMethod _tmp6_;
	void* _tmp6__target;
	cairo_t* _tmp7_;
	cairo_t* _tmp8_;
	cairo_t* _tmp9_;
	ShelfDrawingDockRendererDrawMethod _tmp10_;
	void* _tmp10__target;
	cairo_t* _tmp11_;
	cairo_t* _tmp12_;
	cairo_t* _tmp13_;
	ShelfDrawingDockRendererDrawMethod _tmp14_;
	void* _tmp14__target;
	cairo_t* _tmp15_;
	cairo_t* _tmp16_;
	cairo_t* _tmp17_;
	ShelfDrawingDockRendererDrawMethod _tmp18_;
	void* _tmp18__target;
	cairo_t* _tmp19_;
#line 81 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (self != NULL);
#line 81 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (ctx != NULL);
#line 82 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = ctx;
#line 82 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_save (_tmp0_);
#line 84 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp1_ = ctx;
#line 84 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_new_path (_tmp1_);
#line 85 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp2_ = ctx;
#line 85 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp3_ = x;
#line 85 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp4_ = y;
#line 85 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_translate (_tmp2_, (gdouble) (_tmp3_ + 10), (gdouble) (_tmp4_ + 10));
#line 86 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp5_ = ctx;
#line 86 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	shelf_drawing_dock_renderer_bowtie (self, _tmp5_);
#line 87 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp6_ = draw_method;
#line 87 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp6__target = draw_method_target;
#line 87 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp6_ (_tmp6__target);
#line 89 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp7_ = ctx;
#line 89 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_new_path (_tmp7_);
#line 90 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp8_ = ctx;
#line 90 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_translate (_tmp8_, (gdouble) (3 * 10), (gdouble) 0);
#line 91 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp9_ = ctx;
#line 91 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	shelf_drawing_dock_renderer_square (self, _tmp9_);
#line 92 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp10_ = draw_method;
#line 92 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp10__target = draw_method_target;
#line 92 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp10_ (_tmp10__target);
#line 94 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp11_ = ctx;
#line 94 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_new_path (_tmp11_);
#line 95 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp12_ = ctx;
#line 95 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_translate (_tmp12_, (gdouble) (3 * 10), (gdouble) 0);
#line 96 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp13_ = ctx;
#line 96 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	shelf_drawing_dock_renderer_triangle (self, _tmp13_);
#line 97 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp14_ = draw_method;
#line 97 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp14__target = draw_method_target;
#line 97 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp14_ (_tmp14__target);
#line 99 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp15_ = ctx;
#line 99 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_new_path (_tmp15_);
#line 100 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp16_ = ctx;
#line 100 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_translate (_tmp16_, (gdouble) (3 * 10), (gdouble) 0);
#line 101 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp17_ = ctx;
#line 101 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	shelf_drawing_dock_renderer_inf (self, _tmp17_);
#line 102 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp18_ = draw_method;
#line 102 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp18__target = draw_method_target;
#line 102 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp18_ (_tmp18__target);
#line 104 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp19_ = ctx;
#line 104 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_restore (_tmp19_);
#line 401 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_triangle (ShelfDrawingDockRenderer* self, cairo_t* ctx) {
	cairo_t* _tmp0_;
	cairo_t* _tmp1_;
	cairo_t* _tmp2_;
	cairo_t* _tmp3_;
#line 107 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (self != NULL);
#line 107 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (ctx != NULL);
#line 108 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = ctx;
#line 108 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_move_to (_tmp0_, (gdouble) 10, (gdouble) 0);
#line 109 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp1_ = ctx;
#line 109 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_line_to (_tmp1_, (gdouble) 10, (gdouble) (2 * 10));
#line 110 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp2_ = ctx;
#line 110 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_line_to (_tmp2_, (gdouble) ((-2) * 10), (gdouble) 0);
#line 111 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp3_ = ctx;
#line 111 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_close_path (_tmp3_);
#line 430 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_square (ShelfDrawingDockRenderer* self, cairo_t* ctx) {
	cairo_t* _tmp0_;
	cairo_t* _tmp1_;
	cairo_t* _tmp2_;
	cairo_t* _tmp3_;
	cairo_t* _tmp4_;
#line 114 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (self != NULL);
#line 114 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (ctx != NULL);
#line 115 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = ctx;
#line 115 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_move_to (_tmp0_, (gdouble) 0, (gdouble) 0);
#line 116 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp1_ = ctx;
#line 116 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_line_to (_tmp1_, (gdouble) (2 * 10), (gdouble) 0);
#line 117 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp2_ = ctx;
#line 117 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_line_to (_tmp2_, (gdouble) 0, (gdouble) (2 * 10));
#line 118 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp3_ = ctx;
#line 118 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_line_to (_tmp3_, (gdouble) ((-2) * 10), (gdouble) 0);
#line 119 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp4_ = ctx;
#line 119 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_close_path (_tmp4_);
#line 464 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_bowtie (ShelfDrawingDockRenderer* self, cairo_t* ctx) {
	cairo_t* _tmp0_;
	cairo_t* _tmp1_;
	cairo_t* _tmp2_;
	cairo_t* _tmp3_;
	cairo_t* _tmp4_;
#line 122 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (self != NULL);
#line 122 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (ctx != NULL);
#line 123 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = ctx;
#line 123 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_move_to (_tmp0_, (gdouble) 0, (gdouble) 0);
#line 124 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp1_ = ctx;
#line 124 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_line_to (_tmp1_, (gdouble) (2 * 10), (gdouble) (2 * 10));
#line 125 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp2_ = ctx;
#line 125 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_line_to (_tmp2_, (gdouble) ((-2) * 10), (gdouble) 0);
#line 126 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp3_ = ctx;
#line 126 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_line_to (_tmp3_, (gdouble) (2 * 10), (gdouble) ((-2) * 10));
#line 127 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp4_ = ctx;
#line 127 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_close_path (_tmp4_);
#line 498 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_inf (ShelfDrawingDockRenderer* self, cairo_t* ctx) {
	cairo_t* _tmp0_;
	cairo_t* _tmp1_;
	cairo_t* _tmp2_;
	cairo_t* _tmp3_;
	cairo_t* _tmp4_;
	cairo_t* _tmp5_;
#line 130 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (self != NULL);
#line 130 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (ctx != NULL);
#line 131 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = ctx;
#line 131 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_move_to (_tmp0_, (gdouble) 0, (gdouble) 10);
#line 132 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp1_ = ctx;
#line 132 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_curve_to (_tmp1_, (gdouble) 0, (gdouble) 10, (gdouble) 10, (gdouble) 10, (gdouble) (2 * 10), (gdouble) 0);
#line 133 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp2_ = ctx;
#line 133 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_curve_to (_tmp2_, (gdouble) 10, (gdouble) (-10), (gdouble) (2 * 10), (gdouble) (-10), (gdouble) (2 * 10), (gdouble) 0);
#line 134 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp3_ = ctx;
#line 134 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_curve_to (_tmp3_, (gdouble) 0, (gdouble) 10, (gdouble) (-10), (gdouble) 10, (gdouble) ((-2) * 10), (gdouble) 0);
#line 135 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp4_ = ctx;
#line 135 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_rel_curve_to (_tmp4_, (gdouble) (-10), (gdouble) (-10), (gdouble) ((-2) * 10), (gdouble) (-10), (gdouble) ((-2) * 10), (gdouble) 0);
#line 136 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp5_ = ctx;
#line 136 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	cairo_close_path (_tmp5_);
#line 537 "DockRenderer.c"
}


static ShelfDockController* shelf_drawing_dock_renderer_get_controller (ShelfDrawingDockRenderer* self) {
	ShelfDockController* result;
	ShelfDockController* _tmp0_;
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = self->priv->_controller;
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	result = _tmp0_;
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	return result;
#line 552 "DockRenderer.c"
}


static gpointer _g_object_ref0 (gpointer self) {
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	return self ? g_object_ref (self) : NULL;
#line 559 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_set_controller (ShelfDrawingDockRenderer* self, ShelfDockController* value) {
	ShelfDockController* _tmp0_;
	ShelfDockController* _tmp1_;
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_return_if_fail (self != NULL);
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp0_ = value;
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_tmp1_ = _g_object_ref0 (_tmp0_);
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_g_object_unref0 (self->priv->_controller);
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	self->priv->_controller = _tmp1_;
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_object_notify ((GObject *) self, "controller");
#line 578 "DockRenderer.c"
}


static GObject * shelf_drawing_dock_renderer_constructor (GType type, guint n_construct_properties, GObjectConstructParam * construct_properties) {
	GObject * obj;
	GObjectClass * parent_class;
	ShelfDrawingDockRenderer * self;
#line 45 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	parent_class = G_OBJECT_CLASS (shelf_drawing_dock_renderer_parent_class);
#line 45 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	obj = parent_class->constructor (type, n_construct_properties, construct_properties);
#line 45 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, SHELF_DRAWING_TYPE_DOCK_RENDERER, ShelfDrawingDockRenderer);
#line 45 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	return obj;
#line 594 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_class_init (ShelfDrawingDockRendererClass * klass) {
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	shelf_drawing_dock_renderer_parent_class = g_type_class_peek_parent (klass);
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_type_class_add_private (klass, sizeof (ShelfDrawingDockRendererPrivate));
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	G_OBJECT_CLASS (klass)->get_property = _vala_shelf_drawing_dock_renderer_get_property;
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	G_OBJECT_CLASS (klass)->set_property = _vala_shelf_drawing_dock_renderer_set_property;
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	G_OBJECT_CLASS (klass)->constructor = shelf_drawing_dock_renderer_constructor;
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	G_OBJECT_CLASS (klass)->finalize = shelf_drawing_dock_renderer_finalize;
#line 611 "DockRenderer.c"
	/**
	 * The controller for this dock.
	 */
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	g_object_class_install_property (G_OBJECT_CLASS (klass), SHELF_DRAWING_DOCK_RENDERER_CONTROLLER, g_param_spec_object ("controller", "controller", "controller", SHELF_TYPE_DOCK_CONTROLLER, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_WRITABLE | G_PARAM_CONSTRUCT_ONLY));
#line 617 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_instance_init (ShelfDrawingDockRenderer * self) {
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	self->priv = SHELF_DRAWING_DOCK_RENDERER_GET_PRIVATE (self);
#line 624 "DockRenderer.c"
}


static void shelf_drawing_dock_renderer_finalize (GObject* obj) {
	ShelfDrawingDockRenderer * self;
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, SHELF_DRAWING_TYPE_DOCK_RENDERER, ShelfDrawingDockRenderer);
#line 35 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	_g_object_unref0 (self->priv->_controller);
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	G_OBJECT_CLASS (shelf_drawing_dock_renderer_parent_class)->finalize (obj);
#line 636 "DockRenderer.c"
}


/**
 * The main renderer for the dock.
 */
GType shelf_drawing_dock_renderer_get_type (void) {
	static volatile gsize shelf_drawing_dock_renderer_type_id__volatile = 0;
	if (g_once_init_enter (&shelf_drawing_dock_renderer_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (ShelfDrawingDockRendererClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) shelf_drawing_dock_renderer_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (ShelfDrawingDockRenderer), 0, (GInstanceInitFunc) shelf_drawing_dock_renderer_instance_init, NULL };
		GType shelf_drawing_dock_renderer_type_id;
		shelf_drawing_dock_renderer_type_id = g_type_register_static (G_TYPE_OBJECT, "ShelfDrawingDockRenderer", &g_define_type_info, 0);
		g_once_init_leave (&shelf_drawing_dock_renderer_type_id__volatile, shelf_drawing_dock_renderer_type_id);
	}
	return shelf_drawing_dock_renderer_type_id__volatile;
}


static void _vala_shelf_drawing_dock_renderer_get_property (GObject * object, guint property_id, GValue * value, GParamSpec * pspec) {
	ShelfDrawingDockRenderer * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (object, SHELF_DRAWING_TYPE_DOCK_RENDERER, ShelfDrawingDockRenderer);
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	switch (property_id) {
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
		case SHELF_DRAWING_DOCK_RENDERER_CONTROLLER:
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
		g_value_set_object (value, shelf_drawing_dock_renderer_get_controller (self));
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
		break;
#line 666 "DockRenderer.c"
		default:
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
		G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
		break;
#line 672 "DockRenderer.c"
	}
}


static void _vala_shelf_drawing_dock_renderer_set_property (GObject * object, guint property_id, const GValue * value, GParamSpec * pspec) {
	ShelfDrawingDockRenderer * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (object, SHELF_DRAWING_TYPE_DOCK_RENDERER, ShelfDrawingDockRenderer);
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
	switch (property_id) {
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
		case SHELF_DRAWING_DOCK_RENDERER_CONTROLLER:
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
		shelf_drawing_dock_renderer_set_controller (self, g_value_get_object (value));
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
		break;
#line 688 "DockRenderer.c"
		default:
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
		G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
#line 30 "/home/gwen/Programmation/vala/testgit/vala-sandbox/lib/Drawing/DockRenderer.vala"
		break;
#line 694 "DockRenderer.c"
	}
}



