# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="A Python wrapper for the ALSA API"
HOMEPAGE="https://www.sourceforge.net/projects/pyalsaaudio
	https://pypi.org/project/pyalsaaudio"
SRC_URI="mirror://sourceforge/pyalsaaudio/${P}.tar.gz
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~sparc x86"
IUSE="doc"

RDEPEND="media-libs/alsa-lib"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-0.6[${PYTHON_USEDEP}] )"

RESTRICT="test" # Direct access to ALSA, shouln't be used

python_compile_all() {
	use doc && emake -C doc html
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	"${PYTHON}" test.py -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	local EXAMPLES=( *test.py )

	distutils-r1_python_install_all
}
