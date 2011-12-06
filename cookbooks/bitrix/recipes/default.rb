
include_recipe value_for_platform(
    [ "centos", "redhat", "suse", "fedora" ] => { "default" => "bitrix::centos" },
    [ "debian", "ubuntu" ] => { "default" => "bitrix::debian" })

