require 'package'

class Libproxy < Package
  description 'libproxy is a library that provides automatic proxy configuration management.'
  homepage 'https://libproxy.github.io/libproxy/'
  @_ver = '0.4.17'
  version @_ver
  license 'LGPL-2.1+'
  compatibility 'all'
  source_url 'https://github.com/libproxy/libproxy.git'
  git_hashtag @_ver

  # ninja/samu doesn't work, makefiles do.
  def self.build
    Dir.mkdir 'builddir'
    Dir.chdir 'builddir' do
      #system "cmake -G Ninja #{CREW_CMAKE_OPTIONS} .."
      system "cmake -G 'Unix Makefiles' #{CREW_CMAKE_OPTIONS} .."
      system 'make'
    end
    #system 'samu -C builddir'
  end

  def self.install
    #system "samu -C builddir install"
    Dir.chdir 'builddir' do system "make DESTDIR=#{CREW_DEST_DIR} install" end
  end

  def self.check
    #system "samu -C builddir test"
    Dir.chdir 'builddir' do system "make check" end
  end
end
