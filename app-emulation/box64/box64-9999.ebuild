# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 toolchain-funcs optfeature

DESCRIPTION="Linux Userspace x86_64 Emulator with a twist"
HOMEPAGE="https://box86.org"
EGIT_REPO_URI="https://github.com/ptitSeb/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="static"

pkg_setup() {
	if [[ $(tc-endian) == big ]]; then
		eerror "box86/box64 sadly does not support big endian systems."
		die "big endian not supported!"
	fi

	if [[ ${CHOST} != *linux* ]]; then
		eerror "box86/64 requires a linux system."
		die "Not a GNU+Linux system"
	fi

	if [[ ${CHOST} != *gnu* ]]; then #in case musl support is added in master branch
		ewarn ""
		ewarn "box86/64 will likely not build or run on a non-glibc system."
		ewarn ""
	fi
}

src_configure() {
	local -a mycmakeargs=(
		-DNOGIT=0
		-DARM_DYNAREC=0
		-DRV64_DYNAREC=0
	)

	(use arm || use arm64) && mycmakeargs+=( -DARM64=1 -DARM_DYNAREC=1 )
	use riscv && mycmakeargs+=( -DRV64=1 -DRV64_DYNAREC=1 )
	use ppc64 && mycmakeargs+=( -DPPC64LE=1 )
	use loong && mycmakeargs+=( -DLARCH64=1 )
	use amd64 && mycmakeargs+=( -DLD80BITS=1 -DNOALIGN=1 )
	use static && mycmakeargs+=( -DSTATICBUILD=1 )

	cmake_src_configure
}

src_install() {
	cmake_src_install
	dostrip -x "usr/lib/x86_64-linux-gnu/*"
}

pkg_postinst() {
	optfeature "OpenGL for GLES devices" \
		"media-libs/gl4es"
}
