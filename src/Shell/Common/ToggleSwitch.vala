namespace Ensembles.Shell { 
    public class ToggleSwitch : Gtk.Button {
        Gtk.Label text_label;
        Gtk.Box indicator_box;
        bool on = false;
        public signal void toggled (bool active);
        public ToggleSwitch (string label) {
            text_label = new Gtk.Label (label);
            indicator_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            indicator_box.height_request = 4;
            indicator_box.get_style_context ().add_class ("toggle-indicator");
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            box.pack_start (indicator_box);
            box.pack_end (text_label);

            this.add (box);

            this.clicked.connect (() => {
                if (on) {
                    set_active (false);
                } else {
                    set_active (true);
                }
                toggled (on);
            });
            get_style_context ().remove_class ("toggle");
            get_style_context ().add_class ("toggle-switch");
        }

        public void set_active (bool active) {
            if (active) {
                on = true;
                indicator_box.get_style_context ().add_class ("toggle-indicator-active");
            } else {
                on = false;
                indicator_box.get_style_context ().remove_class ("toggle-indicator-active");
            }
        }
    }
}