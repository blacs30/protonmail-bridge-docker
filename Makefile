.PHONY: docker

docker: ProtonMail-Bridge-bin-1.1.0-1-x86_64.pkg.tar.xz initProton.sh gpgparams Dockerfile
	docker build -t t4cc0re/protonmail-bridge .

ProtonMail-Bridge-bin-1.1.0-1-x86_64.pkg.tar.xz: PKGBUILD
	makepkg

