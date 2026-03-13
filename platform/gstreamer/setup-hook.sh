addGstreamer0_10LibPath () {
    if test -d "$1/lib/gstreamer-0.10"
    then
        addToSearchPath GST_PLUGIN_SYSTEM_PATH "$1/lib/gstreamer-0.10"
    fi
}

addEnvHooks "$hostOffset" addGstreamer0_10LibPath
