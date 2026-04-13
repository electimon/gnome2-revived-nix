{
  stdenv,
  gtk2-engines,
  mkDerivation
}:

mkDerivation {
  pname = "yzunight-theme";
  version = "1.0";

  # no external src, everything is inline
  dontUnpack = true;

  buildInputs = [ gtk2-engines ];

  installPhase = ''
    THEME=$out/share/themes/YzuNight
    mkdir -p $THEME/gtk-2.0
    mkdir -p $THEME/metacity-1

    # ── index.theme ──────────────────────────────────────────
    cat > $THEME/index.theme << 'EOF'
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=YzuNight
Comment=Dark navy theme with rose pink accents
Encoding=UTF-8

[X-GNOME-Metatheme]
GtkTheme=YzuNight
MetacityTheme=YzuNight
IconTheme=gnome
CursorTheme=default
ButtonLayout=menu:minimize,maximize,close
EOF

    # ── gtk-2.0/gtkrc ────────────────────────────────────────
    cat > $THEME/gtk-2.0/gtkrc << 'EOF'
gtk-color-scheme = "bg_color:#12141f\nfg_color:#e6e1f5\nbase_color:#161828\ntext_color:#e6e1f5\nselected_bg_color:#5a2d78\nselected_fg_color:#ebe6fa\ntooltip_bg_color:#1c1e36\ntooltip_fg_color:#c8c0e8"

style "default" {
    engine "clearlooks" {
        colorize_scrollbar = TRUE
        style                = CLASSIC
        reliefstyle          = 1
        contrast             = 0.6
    }

    bg[NORMAL]      = @bg_color
    bg[PRELIGHT]    = shade(1.15, @bg_color)
    bg[SELECTED]    = @selected_bg_color
    bg[INSENSITIVE] = shade(0.9, @bg_color)
    bg[ACTIVE]      = shade(0.85, @bg_color)

    fg[NORMAL]      = @fg_color
    fg[PRELIGHT]    = @fg_color
    fg[SELECTED]    = @selected_fg_color
    fg[INSENSITIVE] = shade(0.6, @fg_color)
    fg[ACTIVE]      = @fg_color

    base[NORMAL]      = @base_color
    base[PRELIGHT]    = shade(1.1, @base_color)
    base[SELECTED]    = @selected_bg_color
    base[INSENSITIVE] = shade(0.9, @base_color)
    base[ACTIVE]      = shade(1.05, @base_color)

    text[NORMAL]      = @text_color
    text[PRELIGHT]    = @text_color
    text[SELECTED]    = @selected_fg_color
    text[INSENSITIVE] = shade(0.55, @text_color)
    text[ACTIVE]      = @text_color

    GtkTreeView::odd_row_color      = shade(1.05, @base_color)
    GtkTreeView::even_row_color     = @base_color
    GtkWidget::interior_focus       = 1
    GtkWidget::focus_padding        = 1
    GtkButton::default_border       = { 0, 0, 0, 0 }
    GtkRange::trough_border         = 0
    GtkRange::slider_width          = 14
    GtkScrollbar::slider_width      = 12
    GtkScrollbar::min_slider_length = 28
    GtkCheckButton::indicator_size  = 14
    GtkRadioButton::indicator_size  = 14
    GtkExpander::expander_size      = 14
    GtkToolbar::internal_padding    = 1
    GtkTreeView::expander_size      = 14
    GtkMenu::horizontal_padding     = 0
    GtkMenu::vertical_padding       = 0

    xthickness = 2
    ythickness = 2
}

style "wide" = "default" { xthickness = 4 ythickness = 4 }
style "wider" = "default" { xthickness = 6 ythickness = 6 }

style "menubar" = "default" {
    bg[NORMAL]   = shade(0.75, @bg_color)
    bg[PRELIGHT] = @selected_bg_color
    fg[NORMAL]   = @fg_color
    fg[PRELIGHT] = @selected_fg_color
    text[NORMAL] = @fg_color
}

style "menu" = "default" {
    bg[NORMAL]     = shade(0.82, @bg_color)
    bg[PRELIGHT]   = @selected_bg_color
    fg[NORMAL]     = @fg_color
    fg[PRELIGHT]   = @selected_fg_color
    text[NORMAL]   = @fg_color
    text[PRELIGHT] = @selected_fg_color
}

style "menu_item" = "menu" { xthickness = 3 ythickness = 3 }

style "separator_menu_item" = "default" {
    xthickness = 1
    ythickness = 1
    GtkSeparatorMenuItem::horizontal_padding = 2
}

style "toolbar" = "default" {
    bg[NORMAL]   = shade(0.78, @bg_color)
    bg[PRELIGHT] = shade(1.2, @bg_color)
}

style "notebook" = "wide" {
    bg[NORMAL]   = shade(0.9, @bg_color)
    bg[ACTIVE]   = shade(0.85, @bg_color)
    bg[SELECTED] = @selected_bg_color
}

style "scrollbar" = "default" {
    bg[NORMAL]   = shade(0.72, @bg_color)
    bg[PRELIGHT] = @selected_bg_color
    bg[ACTIVE]   = shade(0.65, @bg_color)
    GtkScrollbar::slider_width      = 12
    GtkScrollbar::trough_border     = 1
    GtkScrollbar::stepper_size      = 14
    GtkScrollbar::min_slider_length = 28
}

style "progressbar" = "default" {
    bg[NORMAL]   = shade(0.7, @bg_color)
    bg[PRELIGHT] = "#e8645a"
    fg[PRELIGHT] = "#ebe6fa"
    xthickness   = 1
    ythickness   = 1
}

style "entry" = "wider" {
    bg[NORMAL]      = @base_color
    bg[PRELIGHT]    = shade(1.08, @base_color)
    bg[SELECTED]    = @selected_bg_color
    bg[INSENSITIVE] = shade(0.88, @base_color)
    text[NORMAL]    = @text_color
    text[SELECTED]  = @selected_fg_color
}

style "button" = "default" {
    bg[NORMAL]      = shade(1.12, @bg_color)
    bg[PRELIGHT]    = shade(1.3, @bg_color)
    bg[ACTIVE]      = @selected_bg_color
    bg[INSENSITIVE] = shade(0.88, @bg_color)
    fg[NORMAL]      = @fg_color
    fg[PRELIGHT]    = @fg_color
    fg[ACTIVE]      = @selected_fg_color
}

style "spinbutton" = "default" {
    bg[NORMAL]   = @base_color
    bg[PRELIGHT] = shade(1.08, @base_color)
    text[NORMAL] = @text_color
}

style "combobox" = "default" {
    bg[NORMAL]   = shade(1.08, @bg_color)
    bg[PRELIGHT] = shade(1.2, @bg_color)
}

style "panel" = "default" {
    bg[NORMAL]   = shade(0.72, @bg_color)
    bg[PRELIGHT] = shade(1.15, @bg_color)
    fg[NORMAL]   = @fg_color
    text[NORMAL] = @fg_color
    xthickness   = 2
    ythickness   = 2
}

style "tooltips" = "default" {
    bg[NORMAL] = @tooltip_bg_color
    fg[NORMAL] = @tooltip_fg_color
    xthickness = 4
    ythickness = 4
}

style "treeview_header" = "default" {
    bg[NORMAL]   = shade(1.05, @bg_color)
    bg[PRELIGHT] = shade(1.2, @bg_color)
    bg[ACTIVE]   = shade(0.9, @bg_color)
}

style "statusbar" = "default" {
    bg[NORMAL] = shade(0.75, @bg_color)
    fg[NORMAL] = shade(0.75, @fg_color)
}

style "frame_label" = "default" {
    fg[NORMAL] = mix(0.6, @fg_color, @bg_color)
}

class "GtkWidget"            style "default"
class "GtkEntry"             style "entry"
class "GtkSpinButton"        style "spinbutton"
class "GtkButton"            style "button"
class "GtkToggleButton"      style "button"
class "GtkCheckButton"       style "button"
class "GtkRadioButton"       style "button"
class "GtkComboBox"          style "combobox"
class "GtkComboBoxEntry"     style "combobox"
class "GtkNotebook"          style "notebook"
class "GtkProgressBar"       style "progressbar"
class "GtkScrollbar"         style "scrollbar"
class "GtkHScrollbar"        style "scrollbar"
class "GtkVScrollbar"        style "scrollbar"
class "GtkScale"             style "scrollbar"
class "GtkHScale"            style "scrollbar"
class "GtkVScale"            style "scrollbar"
class "GtkSeparator"         style "wide"
class "GtkHSeparator"        style "wide"
class "GtkVSeparator"        style "wide"
class "GtkFrame"             style "wide"

widget_class "*<GtkMenuBar>"               style "menubar"
widget_class "*<GtkMenuBar>*<GtkMenuItem>" style "menubar"
widget_class "*<GtkMenu>"                  style "menu"
widget_class "*<GtkMenu>*<GtkMenuItem>"    style "menu_item"
widget_class "*<GtkSeparatorMenuItem>"     style "separator_menu_item"
widget_class "*<GtkToolbar>"               style "toolbar"
widget_class "*<GtkTreeView>*<GtkButton>"  style "treeview_header"
widget_class "*<GtkStatusbar>"             style "statusbar"
widget_class "*<GtkFrame>*<GtkLabel>"      style "frame_label"

widget "gtk-tooltips" style "tooltips"
widget "gtk-tooltip"  style "tooltips"

widget "*PanelWidget*"      style "panel"
widget "*PanelApplet*"      style "panel"
widget "*fast-user-switch*" style "panel"
widget "*CPUFreq*Applet*"   style "panel"
EOF

    # ── metacity-1/metacity-theme-1.xml ──────────────────────
    cat > $THEME/metacity-1/metacity-theme-1.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<metacity_theme>

  <info>
    <n>YzuNight</n>
    <author>Katou Megumi / YzuInfra</author>
    <description>Dark navy theme with rose pink accents.</description>
    <date>2026</date>
    <copyright>2026 Katou Megumi</copyright>
  </info>

  <frame_geometry name="normal" rounded_top_left="3" rounded_top_right="3">
    <distance name="left_width" value="4"/>
    <distance name="right_width" value="4"/>
    <distance name="bottom_height" value="4"/>
    <distance name="left_titlebar_edge" value="0"/>
    <distance name="right_titlebar_edge" value="0"/>
    <distance name="title_vertical_pad" value="4"/>
    <border name="title_border" top="3" bottom="3" left="6" right="6"/>
    <border name="button_border" top="3" bottom="3" left="3" right="3"/>
  </frame_geometry>

  <frame_geometry name="small" parent="normal">
    <distance name="title_vertical_pad" value="1"/>
    <border name="title_border" top="1" bottom="1" left="3" right="3"/>
    <border name="button_border" top="1" bottom="1" left="1" right="1"/>
  </frame_geometry>

  <draw_ops name="titlebar_focused">
    <gradient type="vertical" x="0" y="0" width="width" height="height">
      <color value="#151628"/>
      <color value="#0d0e1e"/>
    </gradient>
    <line color="#e86482" x1="0" y1="0" x2="width" y2="0"/>
  </draw_ops>

  <draw_ops name="titlebar_unfocused">
    <gradient type="vertical" x="0" y="0" width="width" height="height">
      <color value="#111220"/>
      <color value="#0b0c1a"/>
    </gradient>
  </draw_ops>

  <draw_ops name="border_fill">
    <rectangle color="#1c1e36" x="0" y="0" width="width" height="height" filled="true"/>
  </draw_ops>

  <draw_ops name="close_focused">
    <rectangle color="#e86482" x="2" y="2" width="width-4" height="height-4" filled="true"/>
    <line color="#ebe6fa" x1="4" y1="4" x2="width-5" y2="height-5"/>
    <line color="#ebe6fa" x1="width-5" y1="4" x2="4" y2="height-5"/>
  </draw_ops>

  <draw_ops name="close_prelight">
    <rectangle color="#ff7a96" x="2" y="2" width="width-4" height="height-4" filled="true"/>
    <line color="#ffffff" x1="4" y1="4" x2="width-5" y2="height-5"/>
    <line color="#ffffff" x1="width-5" y1="4" x2="4" y2="height-5"/>
  </draw_ops>

  <draw_ops name="close_unfocused">
    <rectangle color="#3a2e52" x="2" y="2" width="width-4" height="height-4" filled="true"/>
    <line color="#6e678a" x1="4" y1="4" x2="width-5" y2="height-5"/>
    <line color="#6e678a" x1="width-5" y1="4" x2="4" y2="height-5"/>
  </draw_ops>

  <draw_ops name="maximize_focused">
    <rectangle color="#2a2548" x="2" y="2" width="width-4" height="height-4" filled="true"/>
    <rectangle color="#a08cd2" x="3" y="3" width="width-6" height="height-6" filled="false"/>
  </draw_ops>

  <draw_ops name="maximize_prelight">
    <rectangle color="#3d3070" x="2" y="2" width="width-4" height="height-4" filled="true"/>
    <rectangle color="#c8b0f0" x="3" y="3" width="width-6" height="height-6" filled="false"/>
  </draw_ops>

  <draw_ops name="maximize_unfocused">
    <rectangle color="#1e1c30" x="2" y="2" width="width-4" height="height-4" filled="true"/>
    <rectangle color="#4a4468" x="3" y="3" width="width-6" height="height-6" filled="false"/>
  </draw_ops>

  <draw_ops name="minimize_focused">
    <rectangle color="#2a2548" x="2" y="2" width="width-4" height="height-4" filled="true"/>
    <line color="#a08cd2" x1="4" y1="height/2" x2="width-5" y2="height/2"/>
  </draw_ops>

  <draw_ops name="minimize_prelight">
    <rectangle color="#3d3070" x="2" y="2" width="width-4" height="height-4" filled="true"/>
    <line color="#c8b0f0" x1="4" y1="height/2" x2="width-5" y2="height/2"/>
  </draw_ops>

  <draw_ops name="minimize_unfocused">
    <rectangle color="#1e1c30" x="2" y="2" width="width-4" height="height-4" filled="true"/>
    <line color="#4a4468" x1="4" y1="height/2" x2="width-5" y2="height/2"/>
  </draw_ops>

  <frame_style name="normal_focused">
    <piece position="entire_background" draw_ops="border_fill"/>
    <piece position="titlebar" draw_ops="titlebar_focused"/>
    <button function="close"    state="normal"   draw_ops="close_focused"/>
    <button function="close"    state="prelight" draw_ops="close_prelight"/>
    <button function="close"    state="pressed"  draw_ops="close_prelight"/>
    <button function="maximize" state="normal"   draw_ops="maximize_focused"/>
    <button function="maximize" state="prelight" draw_ops="maximize_prelight"/>
    <button function="maximize" state="pressed"  draw_ops="maximize_prelight"/>
    <button function="minimize" state="normal"   draw_ops="minimize_focused"/>
    <button function="minimize" state="prelight" draw_ops="minimize_prelight"/>
    <button function="minimize" state="pressed"  draw_ops="minimize_prelight"/>
  </frame_style>

  <frame_style name="normal_unfocused">
    <piece position="entire_background" draw_ops="border_fill"/>
    <piece position="titlebar" draw_ops="titlebar_unfocused"/>
    <button function="close"    state="normal"   draw_ops="close_unfocused"/>
    <button function="close"    state="prelight" draw_ops="close_prelight"/>
    <button function="maximize" state="normal"   draw_ops="maximize_unfocused"/>
    <button function="maximize" state="prelight" draw_ops="maximize_prelight"/>
    <button function="minimize" state="normal"   draw_ops="minimize_unfocused"/>
    <button function="minimize" state="prelight" draw_ops="minimize_prelight"/>
  </frame_style>

  <frame_style name="maximized_focused"   parent="normal_focused"/>
  <frame_style name="maximized_unfocused" parent="normal_unfocused"/>

  <frame_style_set name="normal">
    <frame focus="yes" state="normal"    style="normal_focused"/>
    <frame focus="no"  state="normal"    style="normal_unfocused"/>
    <frame focus="yes" state="maximized" style="maximized_focused"/>
    <frame focus="no"  state="maximized" style="maximized_unfocused"/>
    <frame focus="yes" state="shaded"    style="normal_focused"/>
    <frame focus="no"  state="shaded"    style="normal_unfocused"/>
  </frame_style_set>

  <frame_style_set name="dialog"       parent="normal"/>
  <frame_style_set name="modal_dialog" parent="dialog"/>
  <frame_style_set name="utility"      parent="normal"/>
  <frame_style_set name="border"       parent="normal"/>
  <frame_style_set name="attached"     parent="normal"/>

  <window type="normal"       style_set="normal"/>
  <window type="dialog"       style_set="dialog"/>
  <window type="modal_dialog" style_set="modal_dialog"/>
  <window type="utility"      style_set="utility"/>
  <window type="border"       style_set="border"/>
  <window type="attached"     style_set="attached"/>
  <window type="menu"         style_set="normal"/>

</metacity_theme>
EOF
  '';

  meta = {
    description = "YzuNight GTK2/Metacity theme — dark navy with rose pink accents";
  };
}
