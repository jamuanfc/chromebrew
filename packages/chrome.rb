require 'package'

class Chrome < Package
  description 'Google Chrome is a fast, easy to use, and secure web browser.'
  homepage 'https://www.google.com/chrome'
  version '100.0.4896.60-1'
  license 'google-chrome'
  compatibility 'x86_64'
  source_url 'https://dl.google.com/linux/chrome/deb//pool/main/g/google-chrome-stable/google-chrome-stable_100.0.4896.60-1_amd64.deb'
  source_sha256 '05ba6d17d2704ffff1e1d554b40aaddabca9256b7e63ff73e99c469393de8a1f'

  depends_on 'nspr'
  depends_on 'cairo'
  depends_on 'gtk3'
  depends_on 'expat'
  depends_on 'cras'
  depends_on 'sommelier'

  no_compile_needed

  def self.install
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin"

    FileUtils.mv 'usr/share', CREW_DEST_PREFIX
    FileUtils.mv 'opt/google/chrome', "#{CREW_DEST_PREFIX}/share"

    FileUtils.ln_s "../share/chrome/google-chrome", "#{CREW_DEST_PREFIX}/bin/google-chrome-stable"
    FileUtils.ln_s "../share/chrome/google-chrome", "#{CREW_DEST_PREFIX}/bin/google-chrome"
  end
end
