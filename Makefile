ARCHIVES="recipes.tgz"
SCP=rsync -az -e ssh
.PHONY: roles archive clean upload
all: upload clean

clean:
	rm -f $(ARCHIVES)
	rm -rf tmpdir

archive:
	mkdir -p tmpdir/
	tar zcf tmpdir/$(ARCHIVES) ./cookbooks ./roles
	cp roles/*.json tmpdir/
	cp -r files/ tmpdir/

upload: archive
#	scp chef-solo.tar.gz cc.kh.clodo.ru:/var/share/tftp/vase-boot/presets/
	$(SCP) tmpdir/* cc00.oversun.clodo.ru:/var/share/tftp/repos/presets/
	$(SCP) tmpdir/files/* pkgs.clodo.ru:/var/www/presets/
	rm -rf tmpdir/

upload_cookbooks:
	cd cookbooks && knife cookbook upload -a -o .
