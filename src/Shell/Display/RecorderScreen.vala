namespace Ensembles.Shell {
    public class RecorderScreen : WheelScrollableWidget {
        Gtk.Button close_button;
        public signal void close_menu ();

        Gtk.Button new_button;
        Gtk.Button open_button;

        Gtk.Stack main_stack;
        Gtk.Button play_button;
        Gtk.Button rec_button;
        Gtk.Button stop_button;
        Gtk.Stack btn_stack;

        public static Core.MidiRecorder sequencer;

        public RecorderScreen () {
            this.get_style_context ().add_class ("menu-background");

            close_button = new Gtk.Button.from_icon_name ("application-exit-symbolic", Gtk.IconSize.BUTTON);
            close_button.margin_end = 4;
            close_button.halign = Gtk.Align.END;

            new_button = new Gtk.Button.from_icon_name ("document-new-symbolic", Gtk.IconSize.BUTTON);
            open_button = new Gtk.Button.from_icon_name ("document-open-symbolic", Gtk.IconSize.BUTTON);


            var headerbar = new Hdy.HeaderBar ();
            headerbar.set_title ("Recorder");
            headerbar.set_subtitle ("Multi-Track MIDI Sequencer");
            headerbar.get_style_context ().add_class ("menu-header");
            headerbar.pack_start (close_button);
            headerbar.pack_start (new_button);
            headerbar.pack_start (open_button);

            btn_stack = new Gtk.Stack ();
            btn_stack.transition_type = Gtk.StackTransitionType.SLIDE_RIGHT;
            btn_stack.transition_duration = 500;

            play_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.BUTTON);
            rec_button = new Gtk.Button.from_icon_name ("media-record-symbolic", Gtk.IconSize.BUTTON);
            stop_button = new Gtk.Button.from_icon_name ("media-playback-stop-symbolic", Gtk.IconSize.BUTTON);

            var btn_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            btn_box.pack_start (play_button);
            btn_box.pack_end (rec_button);

            btn_stack.add_named (btn_box, "Start");
            btn_stack.add_named (stop_button, "Stop");

            headerbar.pack_end (btn_stack);

            close_button.clicked.connect (() => {
                close_menu ();
            });

            var scrollable = new Gtk.ScrolledWindow (null, null);
            scrollable.hexpand = true;
            scrollable.vexpand = true;
            scrollable.margin = 8;

            this.attach (headerbar, 0, 0, 1, 1);
            this.attach (scrollable, 0, 1, 1, 1);

            main_stack = new Gtk.Stack ();
            main_stack.transition_type = Gtk.StackTransitionType.CROSSFADE;
            main_stack.add_named (get_welcome_widget (), "Welcome");

            var name_grid = new Gtk.Grid ();
            name_grid.attach (new Gtk.Label ("Sequence Name"), 0, 0);
            var name_entry = new Gtk.Entry ();
            name_grid.attach (name_entry, 0, 1);
            name_grid.halign = Gtk.Align.CENTER;
            name_grid.valign = Gtk.Align.CENTER;
            main_stack.add_named (name_grid, "EnterName");

            var sequencer_grid = new Gtk.Grid ();
            main_stack.add_named (sequencer_grid, "SqnGrid");

            name_entry.activate.connect (() => {
                sequencer = new Core.MidiRecorder (name_entry.get_text ());
                var visual = sequencer.get_sequencer_visual ();
                sequencer_grid.add (visual);
                visual.show_all ();
                main_stack.set_visible_child_name ("SqnGrid");

                sequencer.note_event.connect ((channel, key, on, velocity) => {
                    if (MainWindow.synthesizer != null) {
                        if (channel == 0) {
                            MainWindow.synthesizer.send_notes_realtime (key, on, velocity, 6, false);
                        } else {
                            MainWindow.synthesizer.send_notes_realtime (key, on, velocity, channel, false);
                        }
                    }
                });

                sequencer.voice_change.connect ((channel, bank, index) => {
                    if (MainWindow.synthesizer != null) {
                        var voice = new Core.Voice (index, bank, index, "", "");
                        print ("Channel %d\n", channel);
                        if (channel == 0) {
                                MainWindow.synthesizer.change_voice (voice, 6, false);
                        } else {
                            MainWindow.synthesizer.change_voice (voice, channel, false);
                        }
                    }
                });

                sequencer.style_change.connect ((index) => {
                    if (MainWindow.main_display_unit != null && MainWindow.main_display_unit.style_menu != null) {
                        MainWindow.main_display_unit.style_menu.quick_select_row (index, -0);
                    }
                });

                sequencer.style_part_change.connect ((section) => {
                    if (MainWindow.style_controller_view != null) {
                        MainWindow.style_controller_view.set_style_section_by_index (section);
                    }
                });

                sequencer.style_start_stop.connect (() => {
                    if (MainWindow.style_controller_view != null) {
                        MainWindow.style_controller_view.start_stop ();
                    }
                });

                sequencer.recorder_state_change.connect ((state) => {
                    switch (state) {
                        case Core.MidiRecorder.RecorderState.PLAYING:
                        case Core.MidiRecorder.RecorderState.RECORDING:
                        btn_stack.set_visible_child_name ("Stop");
                        break;
                        case Core.MidiRecorder.RecorderState.STOPPED:
                        btn_stack.set_visible_child_name ("Start");
                        break;
                    }
                });
            });

            scrollable.add (main_stack);

            play_button.clicked.connect (() => {
                if (sequencer != null) {
                    sequencer.play ();
                }
            });

            rec_button.clicked.connect (() => {
                sequencer.toggle_sync_start ();
            });

            stop_button.clicked.connect(() => {
                if (sequencer != null) {
                    sequencer.stop ();
                }
            });
        }

        Granite.Widgets.Welcome get_welcome_widget () {
            var welcome = new Granite.Widgets.Welcome ("No Sequence Open", "Create a new sequence to start recording");
            welcome.append ("document-new", "New Sequence", "Creates a new empty sequence file");
            welcome.append ("document-open", "Open Sequence", "Open a pre-recorded sequence file");

            welcome.activated.connect ((index) => {
                switch (index) {
                    case 0:
                        main_stack.set_visible_child_name ("EnterName");
                        break;
                    case 1:
                        //
                        break;
                }
            });

            return welcome;
        }
    }
}