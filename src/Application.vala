/*
 * Copyright 2020-2023 Subhadeep Jasu <subhadeep107@proton.me>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.ArrangerWorkstation;

namespace Ensembles {
    /**
     * ## Ensembles Application
     *
     * Provides a GTK Application instance where only a single instance
     * is allowed.
     * The Ensembles application works as a conjuncture of two components:
     * - Core: The arranger system and all it's plugins
     * - Shell: The user interface
     */
    public class Application : Gtk.Application {
        static Application _instance = null;

        public static Application instance {
            get {
                if (_instance == null) {
                    _instance = new Application ();
                }
                return _instance;
            }
        }

        //  public static Services.EventBus event_bus = new Services.EventBus ();

        private string[] ? arg_file = null;
        public static bool raw_midi_input = false;
        public static bool kiosk_mode = false;
        public static bool verbose = false;

        //  public static Shell.MainWindow main_window;
        //  public static Core.ArrangerWorkstation arranger_workstation;
        public AWCore aw_core;

        construct {
            flags |= ApplicationFlags.HANDLES_OPEN |
            ApplicationFlags.HANDLES_COMMAND_LINE;
            application_id = Constants.APP_ID;
        }

        protected override void activate () {
            Console.log ("Initializing GUI Theme");
            //  Services.Theme.init_theme ();

            Console.log ("Initializing Main Window");
            //  main_window = new Shell.MainWindow (this);
            //  this.add_window (main_window);
            //  main_window.show_ui ();
            //  Console.log (
            //      "GUI Initialization Complete!",
            //      Console.LogLevel.SUCCESS
            //  );

            Console.log ("Initializing Arranger Workstation");
            aw_core = AWCore.instance
            .load_soundfont_from_path (Constants.SF2DATADIR)
            .load_style_from_path (Constants.PKGDATADIR)
            .initialize ();

            if (Settings.instance.version != Constants.VERSION) {
                Settings.instance.version = Constants.VERSION;
                // Show welcome screen
            }

            if (Constants.PROFILE == "development") {

            }
        }

        protected override int command_line (ApplicationCommandLine cmd) {
            string[] args_cmd = cmd.get_arguments ();
            unowned string[] args = args_cmd;

            GLib.OptionEntry [] options = new OptionEntry [5];
            options [0] = { "", 0, 0, OptionArg.STRING_ARRAY, ref arg_file, null, "URI" };
            options [1] = { "raw", 0, 0, OptionArg.NONE, ref raw_midi_input, _("Enable Raw MIDI Input"), null };
            options [2] = { "kiosk", 0, 0, OptionArg.NONE, ref kiosk_mode, _("Only show the info display"), null };
            options [3] = { "verbose", 0, 0, OptionArg.NONE, ref verbose, _("Print debug messages to terminal"), null };
            options [4] = { null };

            var opt_context = new OptionContext ("actions");
            opt_context.add_main_entries (options, null);
            try {
                opt_context.parse (ref args);
            } catch (Error err) {
                warning (err.message);
                return -1;
            }

            if (verbose || raw_midi_input || kiosk_mode) {
                Console.greet (Constants.VERSION, Constants.DISPLAYVER);
            }

            if (raw_midi_input) {
                Console.log ("Raw MIDI Input Enabled! You can now enable midi input and connect your DAW\n");
            }

            if (kiosk_mode) {
                Console.log ("Starting Ensembles in Kiosk Mode\n");
            }

            if (arg_file != null && arg_file[0] != null) {
                if (GLib.FileUtils.test (arg_file[0], GLib.FileTest.EXISTS) &&
                    arg_file[0].down ().has_suffix (".mid")) {
                    File file = File.new_for_path (arg_file[0]);
                    open ({ file }, "");
                    return 0;
                }
            }

            activate ();
            return 0;
        }

        public void init (string[] args) {
            X.init_threads ();
        }
    }
}
