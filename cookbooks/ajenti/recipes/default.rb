
include_recipe value_for_platform(
    [ "centos", "redhat", "suse", "fedora" ] => { "default" => "ajenti::centos" },
    [ "debian", "ubuntu" ] => { "default" => "ajenti::debian" })

