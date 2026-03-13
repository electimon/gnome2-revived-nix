addGstreamerLibPath() {
    if [ -d "$1/lib/gstreamer-0.10" ]; then
        GST_PLUGIN_SYSTEM_PATH="${GST_PLUGIN_SYSTEM_PATH:+$GST_PLUGIN_SYSTEM_PATH:}$1/lib/gstreamer-0.10"
        export GST_PLUGIN_SYSTEM_PATH
        export GST_PLUGIN_PATH="$GST_PLUGIN_SYSTEM_PATH"
    fi
}

envHooks+=(addGstreamerLibPath)
