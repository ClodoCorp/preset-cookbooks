
include_recipe value_for_platform(
    [ "centos", "redhat", "suse", "fedora" ] => { "default" => "ispmanager::centos" },
    [ "debian", "ubuntu" ] => { "default" => "ispmanager::debian" })

