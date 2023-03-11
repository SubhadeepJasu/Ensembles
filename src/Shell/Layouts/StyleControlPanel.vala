/*
 * Copyright 2020-2023 Subhadeep Jasu <subhajasu@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Ensembles.Models;

namespace Ensembles.Shell.Layouts {
    public class StyleControlPanel : Gtk.Box {
        private Gtk.Button intro_1_button;
        private Gtk.Button intro_2_button;
        private Gtk.Button intro_3_button;
        private Gtk.Button break_button;
        private Gtk.Button variation_a_button;
        private Gtk.Button variation_b_button;
        private Gtk.Button variation_c_button;
        private Gtk.Button variation_d_button;
        private Gtk.Button ending_1_button;
        private Gtk.Button ending_2_button;
        private Gtk.Button ending_3_button;
        private Gtk.Button sync_start_button;

        private StylePartType current_part;
        private StylePartType next_part = StylePartType.VARIATION_A;

        public StyleControlPanel () {
            Object (
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 4,
                hexpand: true
            );
        }

        construct {
            build_ui ();
            build_events ();
        }

        private void build_ui () {
            get_style_context ().add_class ("panel");

            var intro_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (intro_box);

            var intro_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true,
                homogeneous = true
            };
            intro_button_box.get_style_context ().add_class (Granite.STYLE_CLASS_LINKED);
            intro_box.append (intro_button_box);
            intro_box.append (new Gtk.Label (_("INTRO")) { opacity = 0.5 } );

            var variation_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (variation_box);

            var variation_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true,
                homogeneous = true
            };
            variation_button_box.get_style_context ().add_class (Granite.STYLE_CLASS_LINKED);
            variation_box.append (variation_button_box);
            variation_box.append (new Gtk.Label (_("VARIATION/FILL-IN")) { opacity = 0.5 } );

            var break_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (break_box);

            break_button = new Gtk.Button.with_label ("┦┟") {
                hexpand = true,
                height_request = 32
            };
            break_box.append (break_button);
            break_box.append (new Gtk.Label (_("BREAK")) { opacity = 0.5 } );

            var ending_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (ending_box);

            var ending_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true,
                homogeneous = true
            };
            ending_button_box.get_style_context ().add_class (Granite.STYLE_CLASS_LINKED);
            ending_box.append (ending_button_box);
            ending_box.append (new Gtk.Label (_("ENDING")) { opacity = 0.5 } );

            intro_1_button = new Gtk.Button.with_label (_("1")) {
                height_request = 32
            };
            intro_button_box.append (intro_1_button);
            intro_2_button = new Gtk.Button.with_label (_("2")) {
                height_request = 32
            };
            intro_button_box.append (intro_2_button);
            intro_3_button = new Gtk.Button.with_label (_("3")) {
                height_request = 32
            };
            intro_button_box.append (intro_3_button);

            variation_a_button = new Gtk.Button.with_label (_("A")) {
                height_request = 32
            };
            variation_button_box.append (variation_a_button);
            variation_b_button = new Gtk.Button.with_label (_("B")) {
                height_request = 32
            };
            variation_button_box.append (variation_b_button);
            variation_c_button = new Gtk.Button.with_label (_("C")) {
                height_request = 32
            };
            variation_button_box.append (variation_c_button);
            variation_d_button = new Gtk.Button.with_label (_("D")) {
                height_request = 32
            };
            variation_button_box.append (variation_d_button);

            ending_1_button = new Gtk.Button.with_label (_("1")) {
                height_request = 32
            };
            ending_button_box.append (ending_1_button);
            ending_2_button = new Gtk.Button.with_label (_("2")) {
                height_request = 32
            };
            ending_button_box.append (ending_2_button);
            ending_3_button = new Gtk.Button.with_label (_("3")) {
                height_request = 32
            };
            ending_button_box.append (ending_3_button);

            var sync_start_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            append (sync_start_box);
            sync_start_button = new Gtk.Button.from_icon_name ("com.github.subhadeepjasu.ensembles.sync-start-symbolic") {
                tooltip_text = "Sync Start / Stop",
                has_tooltip = true,
                height_request = 32
            };
            sync_start_button.get_style_context ().remove_class ("image-button");
            sync_start_box.append (sync_start_button);
            sync_start_box.append (new Gtk.Label (_("SYNC")) { opacity = 0.5 } );
        }

        private void build_events () {
            intro_1_button.clicked.connect (() => {
                Application.event_bus.style_set_part (StylePartType.INTRO_1);
            });

            intro_2_button.clicked.connect (() => {
                Application.event_bus.style_set_part (StylePartType.INTRO_2);
            });

            intro_3_button.clicked.connect (() => {
                Application.event_bus.style_set_part (StylePartType.INTRO_3);
            });

            variation_a_button.clicked.connect (() => {
                Application.event_bus.style_set_part (StylePartType.VARIATION_A);
            });

            variation_b_button.clicked.connect (() => {
                Application.event_bus.style_set_part (StylePartType.VARIATION_B);
            });

            variation_c_button.clicked.connect (() => {
                Application.event_bus.style_set_part (StylePartType.VARIATION_C);
            });

            variation_d_button.clicked.connect (() => {
                Application.event_bus.style_set_part (StylePartType.VARIATION_D);
            });

            ending_1_button.clicked.connect (() => {
                Application.event_bus.style_set_part (StylePartType.ENDING_1);
            });

            ending_2_button.clicked.connect (() => {
                Application.event_bus.style_set_part (StylePartType.ENDING_2);
            });

            ending_3_button.clicked.connect (() => {
                Application.event_bus.style_set_part (StylePartType.ENDING_3);
            });

            Application.event_bus.style_current_part_changed.connect ((part) => {
                current_part = part;
                highlight_part ();
            });

            Application.event_bus.style_next_part_changed.connect ((part) => {
                next_part = part;
                highlight_part ();
            });
        }

        private void highlight_part () {
            switch (current_part) {
                case StylePartType.INTRO_1:
                intro_1_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.INTRO_2:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.INTRO_3:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.ENDING_1:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.ENDING_2:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.ENDING_3:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.VARIATION_A:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.VARIATION_B:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.VARIATION_C:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.VARIATION_D:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.FILL_A:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().add_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.FILL_B:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().add_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.FILL_C:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().add_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().remove_class ("pulse-fill");
                break;
                case StylePartType.FILL_D:
                intro_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                intro_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_1_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_2_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                ending_3_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_a_button.get_style_context ().remove_class ("pulse-fill");
                variation_b_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_b_button.get_style_context ().remove_class ("pulse-fill");
                variation_c_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_c_button.get_style_context ().remove_class ("pulse-fill");
                variation_d_button.get_style_context ().remove_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
                variation_d_button.get_style_context ().add_class ("pulse-fill");
                break;
            }

            if (current_part != next_part) {
                switch (next_part) {
                    case StylePartType.INTRO_1:
                    intro_1_button.get_style_context ().add_class ("pulse");
                    intro_2_button.get_style_context ().remove_class ("pulse");
                    intro_3_button.get_style_context ().remove_class ("pulse");
                    ending_1_button.get_style_context ().remove_class ("pulse");
                    ending_2_button.get_style_context ().remove_class ("pulse");
                    ending_3_button.get_style_context ().remove_class ("pulse");
                    variation_a_button.get_style_context ().remove_class ("pulse");
                    variation_b_button.get_style_context ().remove_class ("pulse");
                    variation_c_button.get_style_context ().remove_class ("pulse");
                    variation_d_button.get_style_context ().remove_class ("pulse");
                    break;
                    case StylePartType.INTRO_2:
                    intro_1_button.get_style_context ().remove_class ("pulse");
                    intro_2_button.get_style_context ().add_class ("pulse");
                    intro_3_button.get_style_context ().remove_class ("pulse");
                    ending_1_button.get_style_context ().remove_class ("pulse");
                    ending_2_button.get_style_context ().remove_class ("pulse");
                    ending_3_button.get_style_context ().remove_class ("pulse");
                    variation_a_button.get_style_context ().remove_class ("pulse");
                    variation_b_button.get_style_context ().remove_class ("pulse");
                    variation_c_button.get_style_context ().remove_class ("pulse");
                    variation_d_button.get_style_context ().remove_class ("pulse");
                    break;
                    case StylePartType.INTRO_3:
                    intro_1_button.get_style_context ().remove_class ("pulse");
                    intro_2_button.get_style_context ().add_class ("pulse");
                    intro_3_button.get_style_context ().remove_class ("pulse");
                    ending_1_button.get_style_context ().remove_class ("pulse");
                    ending_2_button.get_style_context ().remove_class ("pulse");
                    ending_3_button.get_style_context ().remove_class ("pulse");
                    variation_a_button.get_style_context ().remove_class ("pulse");
                    variation_b_button.get_style_context ().remove_class ("pulse");
                    variation_c_button.get_style_context ().remove_class ("pulse");
                    variation_d_button.get_style_context ().remove_class ("pulse");
                    break;
                    case StylePartType.ENDING_1:
                    intro_1_button.get_style_context ().remove_class ("pulse");
                    intro_2_button.get_style_context ().remove_class ("pulse");
                    intro_3_button.get_style_context ().remove_class ("pulse");
                    ending_1_button.get_style_context ().add_class ("pulse");
                    ending_2_button.get_style_context ().remove_class ("pulse");
                    ending_3_button.get_style_context ().remove_class ("pulse");
                    variation_a_button.get_style_context ().remove_class ("pulse");
                    variation_b_button.get_style_context ().remove_class ("pulse");
                    variation_c_button.get_style_context ().remove_class ("pulse");
                    variation_d_button.get_style_context ().remove_class ("pulse");
                    break;
                    case StylePartType.ENDING_2:
                    intro_1_button.get_style_context ().remove_class ("pulse");
                    intro_2_button.get_style_context ().remove_class ("pulse");
                    intro_3_button.get_style_context ().remove_class ("pulse");
                    ending_1_button.get_style_context ().remove_class ("pulse");
                    ending_2_button.get_style_context ().add_class ("pulse");
                    ending_3_button.get_style_context ().remove_class ("pulse");
                    variation_a_button.get_style_context ().remove_class ("pulse");
                    variation_b_button.get_style_context ().remove_class ("pulse");
                    variation_c_button.get_style_context ().remove_class ("pulse");
                    variation_d_button.get_style_context ().remove_class ("pulse");
                    break;
                    case StylePartType.ENDING_3:
                    intro_1_button.get_style_context ().remove_class ("pulse");
                    intro_2_button.get_style_context ().remove_class ("pulse");
                    intro_3_button.get_style_context ().remove_class ("pulse");
                    ending_1_button.get_style_context ().remove_class ("pulse");
                    ending_2_button.get_style_context ().remove_class ("pulse");
                    ending_3_button.get_style_context ().add_class ("pulse");
                    variation_a_button.get_style_context ().remove_class ("pulse");
                    variation_b_button.get_style_context ().remove_class ("pulse");
                    variation_c_button.get_style_context ().remove_class ("pulse");
                    variation_d_button.get_style_context ().remove_class ("pulse");
                    break;
                    case StylePartType.VARIATION_A:
                    intro_1_button.get_style_context ().remove_class ("pulse");
                    intro_2_button.get_style_context ().remove_class ("pulse");
                    intro_3_button.get_style_context ().remove_class ("pulse");
                    ending_1_button.get_style_context ().remove_class ("pulse");
                    ending_2_button.get_style_context ().remove_class ("pulse");
                    ending_3_button.get_style_context ().remove_class ("pulse");
                    variation_a_button.get_style_context ().add_class ("pulse");
                    variation_b_button.get_style_context ().remove_class ("pulse");
                    variation_c_button.get_style_context ().remove_class ("pulse");
                    variation_d_button.get_style_context ().remove_class ("pulse");
                    break;
                    case StylePartType.VARIATION_B:
                    intro_1_button.get_style_context ().remove_class ("pulse");
                    intro_2_button.get_style_context ().remove_class ("pulse");
                    intro_3_button.get_style_context ().remove_class ("pulse");
                    ending_1_button.get_style_context ().remove_class ("pulse");
                    ending_2_button.get_style_context ().remove_class ("pulse");
                    ending_3_button.get_style_context ().remove_class ("pulse");
                    variation_a_button.get_style_context ().remove_class ("pulse");
                    variation_b_button.get_style_context ().add_class ("pulse");
                    variation_c_button.get_style_context ().remove_class ("pulse");
                    variation_d_button.get_style_context ().remove_class ("pulse");
                    break;
                    case StylePartType.VARIATION_C:
                    intro_1_button.get_style_context ().remove_class ("pulse");
                    intro_2_button.get_style_context ().remove_class ("pulse");
                    intro_3_button.get_style_context ().remove_class ("pulse");
                    ending_1_button.get_style_context ().remove_class ("pulse");
                    ending_2_button.get_style_context ().remove_class ("pulse");
                    ending_3_button.get_style_context ().remove_class ("pulse");
                    variation_a_button.get_style_context ().remove_class ("pulse");
                    variation_b_button.get_style_context ().remove_class ("pulse");
                    variation_c_button.get_style_context ().add_class ("pulse");
                    variation_d_button.get_style_context ().remove_class ("pulse");
                    break;
                    case StylePartType.VARIATION_D:
                    intro_1_button.get_style_context ().remove_class ("pulse");
                    intro_2_button.get_style_context ().remove_class ("pulse");
                    intro_3_button.get_style_context ().remove_class ("pulse");
                    ending_1_button.get_style_context ().remove_class ("pulse");
                    ending_2_button.get_style_context ().remove_class ("pulse");
                    ending_3_button.get_style_context ().remove_class ("pulse");
                    variation_a_button.get_style_context ().remove_class ("pulse");
                    variation_b_button.get_style_context ().remove_class ("pulse");
                    variation_c_button.get_style_context ().remove_class ("pulse");
                    variation_d_button.get_style_context ().add_class ("pulse");
                    break;
                }
            } else {
                intro_1_button.get_style_context ().remove_class ("pulse");
                intro_2_button.get_style_context ().remove_class ("pulse");
                intro_3_button.get_style_context ().remove_class ("pulse");
                ending_1_button.get_style_context ().remove_class ("pulse");
                ending_2_button.get_style_context ().remove_class ("pulse");
                ending_3_button.get_style_context ().remove_class ("pulse");
                variation_a_button.get_style_context ().remove_class ("pulse");
                variation_b_button.get_style_context ().remove_class ("pulse");
                variation_c_button.get_style_context ().remove_class ("pulse");
                variation_d_button.get_style_context ().remove_class ("pulse");
            }
        }
    }
}
