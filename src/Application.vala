/*
 * Copyright 2020-2023 Subhadeep Jasu <subhajasu@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

/*
 * This file is part of Ensembles
 */

namespace Ensembles {
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
        public static Settings settings;

        // Ensembles Core
        public static Core.ArrangerCore arranger_core;

        // Ensembles Shell
        public static Shell.MainWindow main_window;

        static Gtk.CssProvider main_css_provider;
        static Gtk.CssProvider complimentary_css_provider;
        private const string COMPLIMENTARY_ACCENT_COLORS =
        "
        @define-color accent_color_complimentary %s;
        @define-color accent_color_complimentary_alternate %s;
        ";

        private static string COMPLIMENTARY_ACCENT_COLORS_STRAWBERRY =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@BANANA_500", "@ORANGE_500");

        private static string COMPLIMENTARY_ACCENT_COLORS_ORANGE =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@BLUEBERRY_500", "@MINT_500");

        private static string COMPLIMENTARY_ACCENT_COLORS_BANANA =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@MINT_500", "@ORANGE_500");

        private static string COMPLIMENTARY_ACCENT_COLORS_LIME =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@BANANA_500", "@BUBBLEGUM_500");

        private static string COMPLIMENTARY_ACCENT_COLORS_MINT =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@BANANA_500", "@SILVER_500");

        private static string COMPLIMENTARY_ACCENT_COLORS_BLUEBERRY =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@BANANA_500", "@MINT_500");

        private static string COMPLIMENTARY_ACCENT_COLORS_BUBBLEGUM =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@MINT_500", "@GRAPE_500");

        private static string COMPLIMENTARY_ACCENT_COLORS_COCOA =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@BANANA_500", "@MINT_500");

        private static string COMPLIMENTARY_ACCENT_COLORS_GRAPE =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@BANANA_500", "@BUBBLEGUM_500");

        private static string COMPLIMENTARY_ACCENT_COLORS_SILVER =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@BLUEBERRY_300", "@STRAWBERRY_300");

        private static string COMPLIMENTARY_ACCENT_COLORS_SLATE =
        COMPLIMENTARY_ACCENT_COLORS.printf ("@MINT_500", "@BANANA_500");

        string[] ? arg_file = null;
        public static bool raw_midi_input = false;

        public static string user_data_dir;
        public static string user_config_dir;

        construct {
            flags |= ApplicationFlags.HANDLES_OPEN | ApplicationFlags.HANDLES_COMMAND_LINE;
            application_id = "com.github.subhadeepjasu.ensembles";
            settings = new Settings (application_id);
        }

        protected override void activate () {
            // Make a new Main Window only if none present
            if (main_window == null) {
                user_data_dir = Environment.get_user_special_dir (GLib.UserDirectory.DOCUMENTS) + "/ensembles";
                user_config_dir = Environment.get_user_config_dir () + "/ensembles";
                arranger_core = new Core.ArrangerCore ();
                //  Hdy.init ();
                Gtk.Settings settings = Gtk.Settings.get_default ();
                // Force dark theme
                settings.gtk_application_prefer_dark_theme = true;
                main_window = new Ensembles.Shell.MainWindow ();
                this.add_window (main_window);

                // This enables the use of keyboard media keys to control the style and song player
                var media_key_listener = Interfaces.MediaKeyListener.listen ();
                media_key_listener.media_key_pressed_play.connect (main_window.media_toggle_play);
                media_key_listener.media_key_pressed_pause.connect (main_window.media_pause);
                media_key_listener.media_key_pressed_prev.connect (main_window.media_prev);

                // This enables the free-desktop sound indicator integration with style and song player
                var sound_indicator_listener = Interfaces.SoundIndicator.listen (main_window);
                arranger_core.song_player_state_changed.connect_after (sound_indicator_listener.change_song_state);

                // Initialize theme, before the window has been shown
                init_theme ();

                // Show the shell
                main_window.present ();

                // ..and then load the data
                new Thread<void> ("load-data", arranger_core.load_data);
            }
        }

        public override void open (File[] files, string hint) {
            // Start the app first
            activate ();

            // Open file if it's valid and exists
            if (files [0].query_exists ()) {
                arranger_core.open_file (files [0]);
            }
        }

        public override int command_line (ApplicationCommandLine cmd) {
            string[] args_cmd = cmd.get_arguments ();
            unowned string[] args = args_cmd;

            GLib.OptionEntry [] options = new OptionEntry [3];
            options [0] = { "", 0, 0, OptionArg.STRING_ARRAY, ref arg_file, null, "URI" };
            options [1] = { "raw", 0, 0, OptionArg.NONE, ref raw_midi_input, _("Enable Raw MIDI Input"), null };
            options [2] = { null };

            var opt_context = new OptionContext ("actions");
            opt_context.add_main_entries (options, null);
            try {
                opt_context.parse (ref args);
            } catch (Error err) {
                warning (err.message);
                return -1;
            }

            if (raw_midi_input) {
                print ("Raw MIDI Input Enabled! You can now connect your DAW\n");
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

        // Find out if the application is running in a Flatpak sandbox
        public static bool get_is_running_from_flatpak () {
            var flatpak_info = File.new_for_path ("/.flatpak-info");
            return flatpak_info.query_exists ();
        }

        // Initialise main theme of the application
        public static void init_theme () {
            GLib.Value value = GLib.Value (GLib.Type.STRING);
            string theme_color = "";
            Gtk.Settings.get_default ().get_property ("gtk-theme-name", ref value);
            theme_color = value.get_string ().replace ("io.elementary.stylesheet.", "");
            if (!value.get_string ().has_prefix ("io.elementary.")) {
                Gtk.Settings.get_default ().set_property ("gtk-icon-theme-name", "elementary");
                Gtk.Settings.get_default ().set_property ("gtk-theme-name", "io.elementary.stylesheet.blueberry");
                theme_color = "blueberry";
            }

            // Initialise display theme at launch
            var selected_theme = settings.get_string ("display-theme");
            selected_theme = Utils.set_display_theme (selected_theme);
            settings.set_string ("display-theme", selected_theme);

            if (main_css_provider == null) {
                main_css_provider = new Gtk.CssProvider ();
                main_css_provider.load_from_resource ("/com/github/subhadeepjasu/ensembles/Application.css");
                Gtk.StyleContext.add_provider_for_display (
                    Gdk.Display.get_default (),
                    main_css_provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
                );
            }

            // Set colors that are complimentary to the accent color for special cases
            /* Only works with elementary themes */
            if (complimentary_css_provider == null) {
                complimentary_css_provider = new Gtk.CssProvider ();
                try {
                    switch (theme_color) {
                        case "strawberry":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_STRAWBERRY.data);
                            break;
                        case "orange":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_ORANGE.data);
                            break;
                        case "banana":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_BANANA.data);
                            break;
                        case "lime":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_LIME.data);
                            break;
                        case "mint":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_MINT.data);
                            break;
                        case "blueberry":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_BLUEBERRY.data);
                            break;
                        case "grape":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_GRAPE.data);
                            break;
                        case "bubblegum":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_BUBBLEGUM.data);
                            break;
                        case "cocoa":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_COCOA.data);
                            break;
                        case "silver":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_SILVER.data);
                            break;
                        case "slate":
                        case "black":
                            complimentary_css_provider.load_from_data (COMPLIMENTARY_ACCENT_COLORS_SLATE.data);
                            break;

                    }
                } catch (Error e) {
                    warning (e.message);
                }
                Gtk.StyleContext.add_provider_for_display (
                    Gdk.Display.get_default (),
                    complimentary_css_provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
                );
            }
        }
    }
}
