# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Vulnerability scanner for container images, file systems, and Git repos"
HOMEPAGE="https://aquasecurity.github.io/trivy"
SRC_URI="
	https://github.com/aquasecurity/trivy/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ixti/trivy/releases/download/v${PV}/trivy-${PV}-vendor.tar.gz
"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-lang/go-1.22.0
"

src_compile() {
	ego build -ldflags="-s -X github.com/aquasecurity/trivy/pkg/version/app.ver=${PV}" ./cmd/trivy
}

src_install() {
	dobin trivy

	default
}
