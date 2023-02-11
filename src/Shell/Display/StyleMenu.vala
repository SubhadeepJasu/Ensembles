/*
 * Copyright 2020-2022 Subhadeep Jasu <subhajasu@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.Shell {
    public class StyleMenu : WheelScrollableWidget {
        Gtk.Button close_button;
        Gtk.ListBox main_list;

        StyleItem[] style_rows;

        int _selected_index;

        public signal void close_menu ();
        public signal void change_style (Ensembles.Core.Style accomp_style);
        public StyleMenu () {
            this.get_style_context ().add_class ("menu-background");

            close_button = new Gtk.Button.from_icon_name ("application-exit-symbolic") {
                margin_end = 4,
                halign = Gtk.Align.END
            };


            var headerbar = new Gtk.HeaderBar () {
                height_request = 42
            };
            //  headerbar.set_title (_("Style"));
            //  headerbar.set_subtitle (_("Pick a Rhythm to accompany you"));
            headerbar.get_style_context ().add_class ("menu-header");
            headerbar.pack_start (close_button);

            main_list = new Gtk.ListBox ();
            main_list.get_style_context ().add_class ("menu-box");

            var scrollable = new Gtk.ScrolledWindow () {
                hexpand = true,
                vexpand = true,
                margin_top = 8,
                margin_bottom = 8,
                margin_start = 8,
                margin_end = 8
            };
            scrollable.set_child (main_list);

            this.attach (headerbar, 0, 0, 1, 1);
            this.attach (scrollable, 0, 1, 1, 1);


            close_button.clicked.connect (() => {
                close_menu ();
            });

            main_list.set_selection_mode (Gtk.SelectionMode.BROWSE);
            main_list.row_activated.connect ((row) => {
                int index = row.get_index ();
                _selected_index = index;
                scroll_wheel_location = index;
                change_style (style_rows[index].accomp_style);
                Ensembles.Application.settings.set_int ("style-index", index);

                if (RecorderScreen.sequencer != null &&
                    RecorderScreen.sequencer.current_state != Core.MidiRecorder.RecorderState.PLAYING) {
                    var event = new Core.MidiEvent ();
                    event.event_type = Core.MidiEvent.EventType.STYLECHANGE;
                    event.value1 = index;

                    Shell.RecorderScreen.sequencer.record_event (event);
                }
            });

            wheel_scrolled_absolute.connect ((value) => {
                Idle.add (() => {
                    quick_select_row (value, 0);
                    return false;
                });
            });
        }

        public void populate_style_menu (Ensembles.Core.Style[] accomp_style) {
            style_rows = new StyleItem [accomp_style.length];
            string temp_category = "";
            for (int i = 0; i < accomp_style.length; i++) {
                bool show_category = false;
                if (temp_category != accomp_style[i].genre) {
                    temp_category = accomp_style[i].genre;
                    show_category = true;
                }
                var row = new StyleItem (accomp_style[i], show_category);
                style_rows[i] = row;
                main_list.insert (row, -1);
            }
            min_value = 0;
            max_value = style_rows.length - 1;
            main_list.show ();
        }

        public void scroll_to_selected_row () {
            style_rows[_selected_index].grab_focus ();
            if (main_list != null) {
                var adj = main_list.get_adjustment ();
                if (adj != null) {
                    int height, _htemp;
                    //  style_rows[_selected_index].get_preferred_height (out _htemp, out height);
                    //  Timeout.add (200, () => {
                    //      adj.set_value (_selected_index * height);
                    //      return false;
                    //  });
                }
            }
        }

        public void quick_select_row (int index, int tempo) {
            Idle.add (() => {
                main_list.select_row (style_rows[index]);
                _selected_index = index;
                scroll_wheel_location = index;
                Core.Style selected_style = style_rows[index].accomp_style;
                if (tempo > 0) {
                    selected_style.tempo = tempo;
                }
                change_style (selected_style);
                scroll_to_selected_row ();
                if (RecorderScreen.sequencer != null &&
                    RecorderScreen.sequencer.current_state != Core.MidiRecorder.RecorderState.PLAYING) {
                    var event = new Core.MidiEvent ();
                    event.event_type = Core.MidiEvent.EventType.STYLECHANGE;
                    event.value1 = index;

                    Shell.RecorderScreen.sequencer.record_event (event);
                }
                return false;
            });
        }

        public void load_settings (int? tempo = 0) {
            quick_select_row (Application.settings.get_int ("style-index"), tempo);
        }

        public void scroll_wheel_activate () {
            close_menu ();
        }
    }
}
