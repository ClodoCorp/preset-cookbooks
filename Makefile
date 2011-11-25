chef-solo.tar.gz:
	tar zcvf chef-solo.tar.gz ./cookbooks ./roles

clean:
	rm -f chef-solo.tar.gz

archive: chef-solo.tar.gz

upload: archive
#	scp chef-solo.tar.gz cc.kh.clodo.ru:/var/share/tftp/vase-boot/presets/
	scp chef-solo.tar.gz cc00.oversun.clodo.ru:/var/share/tftp/repos/presets/
	rm chef-solo.tar.gz

upload_cookbooks:
	cd cookbooks && knife cookbook upload -a -o .
