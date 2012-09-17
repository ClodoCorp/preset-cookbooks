Intro
=====
This repo contains presets, that needed to bootstrap clodo.ru stacks

Usage
=====

Sample usage:
`chef-solo --json-attributes "some path to json role file" --recipe-url "some path to tar.gz cookbooks"`

Todo
====

livestreet:
* memcache
`$config['memcache']['servers'][0]['host'] = 'localhost'`
`$config['memcache']['servers'][0]['port'] = '11211'`
`$config['memcache']['servers'][0]['persistent'] = true;`
`$config['memcache']['compression'] = true;`


