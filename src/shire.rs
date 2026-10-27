use zed_extension_api as zed;

/// Theme-only extension: there is no runtime logic, Zed just reads the JSON
/// files in `themes/` and registers every theme family it finds there.
struct ShireExtension;

impl zed::Extension for ShireExtension {
    fn new() -> Self {
        Self
    }
}

zed::register_extension!(ShireExtension);
