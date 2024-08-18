# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
COMMIT="a3e413489ccdd05431401357bf21690536425012"

inherit toolchain-funcs

SRC_URI="https://github.com/Lekensteyn/dmg2img/archive/${COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

DESCRIPTION="Convert Apple disk images to IMG format."
HOMEPAGE="https://github.com/Lekensteyn/dmg2img"
LICENSE="GPL-2"
SLOT="0"
IUSE="lzfse"

DEPEND="
	app-arch/bzip2
	dev-libs/openssl
	sys-libs/zlib
	lzfse? ( dev-libs/lzfse )
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_compile() {
	emake HAVE_LZFSE=$(usex lzfse 1 0) CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${ED}" install
}
