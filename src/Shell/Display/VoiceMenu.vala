/*
 * Copyright 2020-2022 Subhadeep Jasu <subhajasu@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.Shell {
    public class VoiceMenu : WheelScrollableWidget {
        uint8 channel;
        Gtk.Button close_button;
        Gtk.ListBox main_list;
        VoiceItem[] voice_rows;
        int _selected_index;
        int i = 0;
        int last_voice_index;

        public signal void close_menu ();
        public signal void change_voice (Ensembles.Core.Voice voice, uint8 channel);
        public VoiceMenu (uint8 channel) {
            this.channel = channel;
            this.get_style_context ().add_class ("menu-background");

            close_button = new Gtk.Button.from_icon_name ("application-exit-symbolic") {
                margin_end = 4,
                halign = Gtk.Align.END
            };


            var headerbar = new Gtk.HeaderBar ();
            //  headerbar.set_title (_("Voice - %s").printf (((channel == 17) ? _("Right 1 (Main)") : (channel == 18)
            //  ? _("Right 2 (Layered)")
            //  : _("Left (Split)"))));
            //  headerbar.set_subtitle (_("Pick a Voice to play %s").printf (((channel == 17) ? "" : (channel == 18)
            //  ? _(" on another layer")
            //  : _(" on left hand side of split"))));
            headerbar.get_style_context ().add_class ("menu-header");
            headerbar.height_request = 42;
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
                change_voice (voice_rows[index].voice, channel);
                switch (channel) {
                    case 17:
                    Ensembles.Application.settings.set_int ("voice-r1-index", index);
                    break;
                    case 18:
                    Ensembles.Application.settings.set_int ("voice-r2-index", index);
                    break;
                    case 19:
                    Ensembles.Application.settings.set_int ("voice-l-index", index);
                    break;
                }
            });

            wheel_scrolled_absolute.connect ((value) => {
                Idle.add (() => {
                    quick_select_row (value);
                    return false;
                });
            });
        }
        public void populate_voice_menu (Ensembles.Core.Voice[] voices) {
            voice_rows = new VoiceItem [voices.length];
            string temp_category = "";
            for (; i < voices.length; i++) {
                bool show_category = false;
                if (temp_category != voices[i].category) {
                    temp_category = voices[i].category;
                    show_category = true;
                }
                var row = new VoiceItem (voices[i], show_category, i);
                voice_rows[i] = row;
                main_list.insert (row, -1);
            }
            load_settings ();
            min_value = 0;
            max_value = voice_rows.length - 1;
            main_list.show ();
        }

        public void populate_plugins () {
            if (Core.InstrumentRack.plugin_voice_reference != null) {
                bool show_category = true;
                last_voice_index = voice_rows.length;
                for (; i < Core.InstrumentRack.plugin_voice_reference.length + last_voice_index; i++) {
                    if (show_category) {
                        show_category = true;
                    }
                    if (Core.InstrumentRack.plugin_voice_reference[i - last_voice_index] != null) {
                        print ("name: %s\n", Core.InstrumentRack.plugin_voice_reference[i - last_voice_index].name);
                        var row = new VoiceItem (
                            Core.InstrumentRack.plugin_voice_reference[i - last_voice_index],
                            show_category,
                            i
                        );

                        voice_rows[i] = row;
                        main_list.insert (row, -1);
                    }
                }
                max_value = voice_rows.length - 1;
                main_list.show ();
            }
        }

        public void scroll_to_selected_row () {
            voice_rows[_selected_index].grab_focus ();
            if (main_list != null) {
                var adj = main_list.get_adjustment ();
                if (adj != null) {
                    int height, _htemp;
                    //  voice_rows[_selected_index].get_preferred_height (out _htemp, out height);
                    //  Timeout.add (200, () => {
                    //      adj.set_value (_selected_index * height);
                    //      return false;
                    //  });
                }
            }
        }

        public void quick_select_row (int index) {
            Idle.add (() => {
                main_list.select_row (voice_rows[index]);
                _selected_index = index;
                scroll_wheel_location = index;
                change_voice (voice_rows[index].voice, channel);
                scroll_to_selected_row ();
                switch (channel) {
                    case 17:
                    if (index <= last_voice_index) {
                        Ensembles.Application.settings.set_int ("voice-r1-index", index);
                    }
                    break;
                    case 18:
                    Ensembles.Application.settings.set_int ("voice-r2-index", index);
                    break;
                    case 19:
                    Ensembles.Application.settings.set_int ("voice-l-index", index);
                    break;
                }
                return false;
            });
        }

        public void load_settings () {
            switch (channel) {
                case 17:
                quick_select_row (Ensembles.Application.settings.get_int ("voice-r1-index"));
                break;
                case 18:
                quick_select_row (Ensembles.Application.settings.get_int ("voice-r2-index"));
                break;
                case 19:
                quick_select_row (Ensembles.Application.settings.get_int ("voice-l-index"));
                break;
            }
        }

        public void scroll_wheel_activate () {
            close_menu ();
        }
    }
}
