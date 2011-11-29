ARCHIVES="recipes.tgz"

.PHONY: roles archive clean upload

all: upload clean

clean:
	rm -f $(ARCHIVES)

archive:
	tar zcf $(ARCHIVES) ./cookbooks ./roles

roles:
	scp roles/*.json cc00.oversun.clodo.ru:/var/share/tftp/repos/presets/

upload: roles archive
#	scp chef-solo.tar.gz cc.kh.clodo.ru:/var/share/tftp/vase-boot/presets/
	scp $(ARCHIVES) cc00.oversun.clodo.ru:/var/share/tftp/repos/presets/

upload_cookbooks:
	cd cookbooks && knife cookbook upload -a -o .
