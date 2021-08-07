EAPI=7
MY_PN="intel-driver-g45-h264"
MY_PV="2.4.1"

inherit autotools

DESCRIPTION="intel-driver-g45-h264"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/vaapi"

if [[ ${PV} != *9999* ]] ; then
	SRC_URI="https://bitbucket.org/alium/g45-h264/downloads/${MY_PN}-${MY_PV}.tar.gz"
	S="${WORKDIR}/intel-vaapi-driver"
	KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0"
IUSE="wayland X"
RESTRICT="test" # No tests

RDEPEND="
	>=x11-libs/libdrm-2.4.52[video_cards_intel,${MULTILIB_USEDEP}]
	>=x11-libs/libva-2.4.0:=[X?,wayland?,drm,${MULTILIB_USEDEP}]
	wayland? (
		>=dev-libs/wayland-1.11[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.1.6[egl,${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	eapply_user
	sed -e 's/intel-gen4asm/\0diSaBlEd/g' -i configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		$(use_enable wayland)
		$(use_enable X x11)
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	find "${D}" -name "*.la" -delete || die
}
