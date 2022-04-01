require 'package'

class Openconnect < Package
  version '8.20'
  description 'OpenConnect is an SSL VPN client initially created to support Cisco\'s AnyConnect SSL VPN.'
  homepage 'http://www.infradead.org/openconnect/'
  license 'LGPL-2.1 and GPL-2'
  compatibility 'all'
  source_url 'https://www.infradead.org/openconnect/download/openconnect-8.20.tar.gz'
  source_sha256 'c1452384c6f796baee45d4e919ae1bfc281d6c88862e1f646a2cc513fc44e58b'

  binary_url({
    aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/openconnect/8.20_armv7l/openconnect-8.20-chromeos-armv7l.tar.zst',
     armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/openconnect/8.20_armv7l/openconnect-8.20-chromeos-armv7l.tar.zst',
       i686: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/openconnect/8.20_i686/openconnect-8.20-chromeos-i686.tar.zst',
     x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/openconnect/8.20_x86_64/openconnect-8.20-chromeos-x86_64.tar.zst'
  })
  binary_sha256({
    aarch64: 'a91f0affd7b757088a1c46cbad35790fab7368a8931a929dde723b151a57a2f9',
     armv7l: 'a91f0affd7b757088a1c46cbad35790fab7368a8931a929dde723b151a57a2f9',
       i686: '02427debf304d37bb6bf53bfa8ce0a594de22a0f56e5b780b46c32cd9b512d2b',
     x86_64: '3afc173b89c5126931766d8117d2f850ee23c71514c948d80d6f91768ffd2639'
  })

  depends_on 'libproxy'
  depends_on 'libxml2'
  depends_on 'lz4'
  depends_on 'gnutls'
  depends_on 'vpnc'

  def self.build
    system "./configure \
           #{CREW_OPTIONS} \
           --with-vpnc-script=#{CREW_PREFIX}/etc/vpnc/vpnc-script"
    system 'make'
  end

  def self.install
    system 'make', "DESTDIR=#{CREW_DEST_DIR}", 'install'
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin"
    @vpnc_start = <<~'VPNC_STARTEOF'
      #!/bin/bash
      if test "$1"; then
        sudo ip tuntap add mode tun tun0
        read -r -p "VPN Username: " USER
        read -r -s -p "VPN Password: " PASS
        echo "$PASS" | openconnect --user="$USER" --interface=tun0 -b "$1"
      else
        echo "Usage: vpnc-start vpn.example.com"
      fi
    VPNC_STARTEOF
    File.write "#{CREW_DEST_PREFIX}/bin/vpnc-start", @vpnc_start, perm: 0o755
    @vpnc_stop = <<~'VPNC_STOPEOF'
      #!/bin/bash
      killall openconnect
      sudo ip tuntap del mode tun tun0
    VPNC_STOPEOF
    File.write "#{CREW_DEST_PREFIX}/bin/vpnc-stop", @vpnc_stop, perm: 0o755
  end

  def self.postinstall
    puts
    puts 'Added the following bash scripts:'.lightblue
    puts 'vpnc-start - start vpn'.lightblue
    puts 'vpnc-stop - stop vpn'.lightblue
    puts
  end
end
