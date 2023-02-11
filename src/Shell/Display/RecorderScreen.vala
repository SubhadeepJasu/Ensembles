/*
 * Copyright 2020-2022 Subhadeep Jasu <subhajasu@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Ensembles.Shell {
    public class RecorderScreen : WheelScrollableWidget {
        Gtk.HeaderBar headerbar;
        Gtk.Grid sequencer_grid;
        Gtk.ScrolledWindow scrollable;
        Gtk.Button close_button;
        public signal void close_menu ();

        Gtk.Button new_button;
        Gtk.Button open_button;
        Gtk.Entry name_entry;

        Gtk.Stack main_stack;
        Gtk.Button play_button;
        Gtk.Button rec_button;
        Gtk.Button stop_button;
        Gtk.Stack btn_stack;

        Gtk.FileChooserNative project_folder_chooser;
        Gtk.FileChooserNative project_file_chooser;

        string save_location = "";
        string project_file_name = "";
        string project_name = "";
        string suffix = ".enproj";

        public static Core.MidiRecorder sequencer;

        public RecorderScreen () {
            this.get_style_context ().add_class ("menu-background");

            close_button = new Gtk.Button.from_icon_name ("application-exit-symbolic") {
                margin_end = 4,
                halign = Gtk.Align.END
            };

            new_button = new Gtk.Button.from_icon_name ("document-new-symbolic") {
                sensitive = false
            };
            open_button = new Gtk.Button.from_icon_name ("document-open-symbolic") {
                sensitive = false
            };


            headerbar = new Gtk.HeaderBar () {
                height_request = 42
            };
            //  headerbar.set_title (_("Recorder"));
            //  headerbar.set_subtitle (_("Record playback in multiple tracks"));
            headerbar.get_style_context ().add_class ("menu-header");
            headerbar.pack_start (close_button);
            headerbar.pack_start (new_button);
            headerbar.pack_start (open_button);

            btn_stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_RIGHT,
                transition_duration = 500
            };

            play_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic") {
                sensitive = false
            };
            rec_button = new Gtk.Button.from_icon_name ("media-record-symbolic") {
                sensitive = false
            };
            stop_button = new Gtk.Button.from_icon_name ("media-playback-stop-symbolic");

            var btn_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            btn_box.append (play_button);
            btn_box.append (rec_button);

            btn_stack.add_named (btn_box, "Start");
            btn_stack.add_named (stop_button, "Stop");

            headerbar.pack_end (btn_stack);

            close_button.clicked.connect (() => {
                close_menu ();
                Application.arranger_core.synthesizer.disable_input (false);
            });

            scrollable = new Gtk.ScrolledWindow () {
                hexpand = true,
                vexpand = true,
                margin_start = 8,
                margin_end = 8,
                margin_top = 8,
                margin_bottom = 8
            };

            this.attach (headerbar, 0, 0, 1, 1);
            this.attach (scrollable, 0, 1, 1, 1);

            main_stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.CROSSFADE
            };
            main_stack.add_named (get_welcome_widget (), "Welcome");

            var name_grid = new Gtk.Grid () {
                row_spacing = 4,
                column_spacing = 4,
                row_homogeneous = true
            };

            var header_label = new Gtk.Label (_("Sequence Name"));
            header_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            name_grid.attach (header_label, 0, 0, 2, 1);
            name_entry = new Gtk.Entry () {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER
            };
            name_grid.attach (name_entry, 0, 1, 2, 1);

            save_location = Application.user_data_dir + "/recordings";

            if (DirUtils.create_with_parents (Application.user_data_dir, 2000) != -1) {
                if (DirUtils.create_with_parents (
                    save_location, 2000) != -1) {
                    debug ("Made user projects folder\n");
                }
            }

            var location_label = new Gtk.Label (save_location) {
                ellipsize = Pango.EllipsizeMode.MIDDLE
            };
            location_label.get_style_context ().add_class (Granite.STYLE_CLASS_TERMINAL);
            name_grid.attach (location_label, 0, 2, 2, 1);

            project_folder_chooser = new Gtk.FileChooserNative (_("Select Project Folder"),
                                                                Ensembles.Application.main_window,
                                                                Gtk.FileChooserAction.SELECT_FOLDER,
                                                                _("Select"),
                                                                _("Cancel")
                                                                ) {
                                                                    modal = true
                                                                };

            var location_change_button = new Gtk.Button.with_label (_("Change Project Location"));
            location_change_button.clicked.connect (() => {
                project_folder_chooser.show ();
                project_folder_chooser.hide ();
            });
            project_folder_chooser.response.connect ((response_id) => {
                if (response_id == -3) {
                    save_location = project_folder_chooser.get_file ().get_path ();
                }
                location_label.set_text (save_location);
            });
            name_grid.attach (location_change_button, 0, 3, 1, 1);

            project_file_chooser = new Gtk.FileChooserNative (_("Open Project File"),
                                                                Ensembles.Application.main_window,
                                                                Gtk.FileChooserAction.OPEN,
                                                                _("Open"),
                                                                _("Cancel")
                                                                );
            var file_filter_enproj = new Gtk.FileFilter ();
            file_filter_enproj.add_pattern ("*.enproj");
            file_filter_enproj.set_filter_name (_("Ensembles Recorder Project"));
            project_file_chooser.set_filter (file_filter_enproj);
            project_file_chooser.response.connect ((response_id) => {
                if (response_id == -3) {
                    create_project (project_file_chooser.get_file ().get_path ());
                }
            });

            var create_project_button = new Gtk.Button.with_label (_("Create Project"));
            create_project_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
            create_project_button.clicked.connect (() => {
                project_name = name_entry.get_text ();
                create_project ();
            });
            name_grid.attach (create_project_button, 1, 3, 1, 1);

            main_stack.add_named (name_grid, "EnterName");

            sequencer_grid = new Gtk.Grid ();
            main_stack.add_named (sequencer_grid, "SqnGrid");

            name_entry.activate.connect (() => {
                project_name = name_entry.get_text ();
                create_project ();
            });

            scrollable.set_child (main_stack);

            play_button.clicked.connect (() => {
                if (sequencer != null) {
                    sequencer.play ();
                }
            });

            rec_button.clicked.connect (() => {
                if (sequencer != null) {
                    sequencer.toggle_sync_start ();
                }
            });

            stop_button.clicked.connect (() => {
                if (sequencer != null) {
                    sequencer.stop ();
                    Application.arranger_core.style_player.stop_style ();
                }
            });

            new_button.clicked.connect (() => {
                if (sequencer != null) {
                    sequencer.stop ();
                    Application.arranger_core.style_player.stop_style ();
                }
                main_stack.set_visible_child_name ("EnterName");
                Application.arranger_core.synthesizer.disable_input (true);
                play_button.sensitive = false;
                rec_button.sensitive = false;
                //  sequencer_grid.foreach ((widget) => {
                //      sequencer_grid.remove (widget);
                //      widget.unref ();
                //  });
                name_entry.set_text ("");
                name_entry.grab_focus ();
            });
        }

        void create_project (string? existing_file_path = null) {
            Application.arranger_core.synthesizer.disable_input (false);
            play_button.sensitive = true;
            rec_button.sensitive = true;
            new_button.sensitive = true;
            open_button.sensitive = true;
            project_file_name = project_name.replace (" ", "_");
            project_file_name = project_file_name.replace ("/", "_");
            project_file_name = project_file_name.replace ("\\", "_");
            project_file_name = project_file_name.replace ("\"", "'");
            project_file_name = project_file_name.down ();
            project_file_name += suffix;
            sequencer = new Core.MidiRecorder (project_name,
                                               existing_file_path == null
                                               ? Path.build_filename (save_location, project_file_name)
                                               : existing_file_path,
                                               existing_file_path == null);
            //  headerbar.set_title (_("Recorder") + " - " + project_name);
            var visual = sequencer.get_sequencer_visual ();

            sequencer_grid.attach (visual, 0, 0);
            visual.show ();
            main_stack.set_visible_child_name ("SqnGrid");

            sequencer.project_name_change.connect ((value) => {
                //  headerbar.set_title (_("Recorder") + " - " + value);gr
            });

            sequencer.progress_change.connect ((value) => {
                var adj = scrollable.get_hadjustment ();
                adj.set_value (value);
            });

            sequencer.set_ui_sensitive.connect ((sensitive) => {
                if (Application.main_window.ctrl_panel != null) {
                    Application.main_window.ctrl_panel.set_panel_sensitive (sensitive);
                }
                if (Application.main_window.style_controller_view != null) {
                    Application.main_window.style_controller_view.ready (sensitive);
                }
            });

            sequencer.recorder_state_change.connect ((state) => {
                switch (state) {
                    case Core.MidiRecorder.RecorderState.PLAYING:
                    btn_stack.set_visible_child_name ("Stop");
                    break;
                    case Core.MidiRecorder.RecorderState.RECORDING:
                    play_button.sensitive = !play_button.sensitive;
                    play_button.opacity = play_button.sensitive ? 1.0 : 0.5;
                    btn_stack.set_visible_child_name ("Stop");
                    break;
                    case Core.MidiRecorder.RecorderState.STOPPED:
                    btn_stack.set_visible_child_name ("Start");
                    play_button.sensitive = true;
                    play_button.opacity = 1;
                    if (Application.main_window.ctrl_panel != null) {
                        Application.main_window.ctrl_panel.load_settings ();
                    }
                    break;
                }
            });
        }

        Granite.Placeholder get_welcome_widget () {
            var welcome = new Granite.Placeholder (
                _("No Project Open")
            ) {
                description = _("Create a new project to start recording")
            };
            var doc_new = welcome.append_button (new ThemedIcon ("document-new"), _("New Project"), _("Creates a new project from scratch"));
            var doc_open = welcome.append_button (new ThemedIcon ("document-open"), _("Open Project"), _("Opens a pre-recorded project file"));

            doc_new.clicked.connect (() => {
                main_stack.set_visible_child_name ("EnterName");
                Application.arranger_core.synthesizer.disable_input (true);
                play_button.sensitive = false;
                rec_button.sensitive = false;
                name_entry.grab_focus ();
            });

            doc_open.clicked.connect (() => {
                project_file_chooser.show ();
                project_file_chooser.hide ();
            });

            return welcome;
        }
    }
}
