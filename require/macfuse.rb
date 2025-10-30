# typed: false
# frozen_string_literal: true

# USAGE: `depends_on MacfuseRequirement`
class MacfuseRequirement < Requirement
  fatal true

  satisfy(build_env: false) { self.class.binary_osxfuse_installed? }

  def self.binary_osxfuse_installed?
    File.exist?("/usr/local/include/fuse.h") &&
      !File.symlink?("/usr/local/include")
  end

  env do
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_LIBRARY/"Homebrew/os/mac/pkgconfig/fuse"
  end

  def message
    "This formula requires macFUSE. Please run `brew install --cask macfuse` first."
  end

  def display_s
    "macFUSE"
  end
end

# Add `setup_fuse` to base Formula class, for use by FUSE formulae
class Formula
  def need_alt_fuse?
    HOMEBREW_PREFIX.to_s != "/usr/local"
  end

  def alt_fuse_root
    buildpath/"temp"
  end

  def fuse_cmake_args
    return unless need_alt_fuse?

    %W[
      -DCMAKE_INCLUDE_PATH=#{alt_fuse_root}/include/fuse;#{alt_fuse_root}/include
      -DCMAKE_LIBRARY_PATH=#{alt_fuse_root}/lib
      -DCMAKE_CXX_FLAGS=-I#{alt_fuse_root}/include/fuse\ -D_USE_FILE_OFFSET_BITS=64
    ]
    # -DPKG_CONFIG=#{fuse_pkgconfig}
    # -DPKG_CONFIG_EXECUTABLE=#{fuse_pkgconfig}
    # -DFUSE_INCLUDE_DIR=#{alt_fuse_root}/include/fuse
    # -DFUSE_LIBRARIES=#{alt_fuse_root}/lib/libfuse.dylib
  end

  def setup_fuse_includes
    mkdir "#{alt_fuse_root}/include" do
      Dir["/usr/local/include/fuse*"].each { |f| cp_r f, "." }
    end
  end

  def setup_fuse_libs
    mkdir "#{alt_fuse_root}/lib" do
      Dir["/usr/local/lib/*fuse*"].each { |f| cp_r f, "." }
    end
  end

  def setup_fuse_pkgconfig
    ### OLD METHOD: Fake pkg-config
    # mkdir "#{alt_fuse_root}/bin" do
    #  cp path/"../../lib/fuse-pkg-config", "."
    #  inreplace "fuse-pkg-config", "%FUSE_ROOT%", "#{alt_fuse_root}"
    # end
    # ENV["PKG_CONFIG"] = "#{fuse_pkgconfig}"

    ### NEW METHOD: Fix fuse.pc in alt root
    mkdir "#{alt_fuse_root}/lib/pkgconfig" do
      cp "/usr/local/lib/pkgconfig/fuse.pc", "."
      inreplace "fuse.pc", "/usr/local", alt_fuse_root.to_s
      cp "/usr/local/lib/pkgconfig/fuse3.pc", "."
      inreplace "fuse3.pc", "/usr/local", alt_fuse_root.to_s
    end
    ENV.prepend_path "PKG_CONFIG_PATH", "#{alt_fuse_root}/lib/pkgconfig"
  end

  # def fuse_pkgconfig
  #  return "#{alt_fuse_root}/bin/fuse-pkg-config" if need_alt_fuse?
  #  "pkg-config"
  # end

  def setup_fuse_env
    odebug "Setting up FUSE temp environment under #{alt_fuse_root}"
    setup_fuse_includes
    setup_fuse_libs
    setup_fuse_pkgconfig
    Dir.glob("#{alt_fuse_root}/**/*").each { |f| odebug ">>> #{f}" }
  end

  def disable_macfuse_extensions
    ENV.append "CFLAGS", "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0"
    ENV.append "CPPFLAGS", "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0"
    ENV.append "CXXFLAGS", "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0"
    ENV.append "CGO_CPPFLAGS", "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0"
  end

  def setup_fuse_flags
    ENV.append "CFLAGS", "-I#{alt_fuse_root}/include"
    ENV.append "CFLAGS", "-I#{alt_fuse_root}/include/fuse"
    ENV.append "CFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "CPPFLAGS", "-I#{alt_fuse_root}/include"
    ENV.append "CPPFLAGS", "-I#{alt_fuse_root}/include/fuse"
    ENV.append "CPPFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CPPFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "CXXFLAGS", "-I#{alt_fuse_root}/include"
    ENV.append "CXXFLAGS", "-I#{alt_fuse_root}/include/fuse"
    ENV.append "CXXFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CXXFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "LDFLAGS", "-L#{alt_fuse_root}/lib"
    ENV.append "CGO_CPPFLAGS", "-I#{alt_fuse_root}/include"
    ENV.append "CGO_CPPFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CGO_CPPFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "CGO_LDFLAGS", "-L#{alt_fuse_root}/lib"
    disable_macfuse_extensions
    odebug "PKG_CONFIG = #{ENV.fetch("PKG_CONFIG", nil)}"
    odebug "PKG_CONFIG_PATH = #{ENV.fetch("PKG_CONFIG_PATH", nil)}"
    odebug "CFLAGS = #{ENV.fetch("CFLAGS", nil)}"
  end

  def setup_fuse3_flags
    ENV.append "CFLAGS", "-I#{alt_fuse_root}/include/fuse3"
    ENV.append "CFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "CPPFLAGS", "-I#{alt_fuse_root}/include/fuse3"
    ENV.append "CPPFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CPPFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "CXXFLAGS", "-I#{alt_fuse_root}/include/fuse3"
    ENV.append "CXXFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CXXFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "LDFLAGS", "-L#{alt_fuse_root}/lib"
    ENV.append "CGO_CPPFLAGS", "-I#{alt_fuse_root}/include/fuse3"
    ENV.append "CGO_CPPFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CGO_CPPFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "CGO_LDFLAGS", "-L#{alt_fuse_root}/lib"
    disable_macfuse_extensions
    odebug "PKG_CONFIG = #{ENV.fetch("PKG_CONFIG", nil)}"
    odebug "PKG_CONFIG_PATH = #{ENV.fetch("PKG_CONFIG_PATH", nil)}"
    odebug "CFLAGS = #{ENV.fetch("CFLAGS", nil)}"
  end

  def setup_fuse
    return unless need_alt_fuse?

    setup_fuse_env
    setup_fuse_flags
  end

  def setup_fuse3
    return unless need_alt_fuse?

    setup_fuse_env
    setup_fuse3_flags
  end
end
