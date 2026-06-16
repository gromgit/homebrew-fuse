# typed: false
# frozen_string_literal: true

# USAGE: Call `setup_fuse` (FUSE2) or `setup_fuse3` (FUSE3) at the start of the `install` block in FUSE formulae
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

  def setup_fuse_includes(fuse_suffix: "")
    mkdir "#{alt_fuse_root}/include" do
      dirs = %W[/usr/local/include/fuse#{fuse_suffix}]
      dirs += %w[/usr/local/include/fuse.h] if fuse_suffix == ""
      Dir[*dirs].each { |f| cp_r f, "." }
    end
  end

  def setup_fuse_libs(fuse_suffix: "")
    mkdir "#{alt_fuse_root}/lib" do
      Dir["/usr/local/lib/libfuse#{fuse_suffix}.*"].each { |f| cp_r f, "." }
    end
  end

  def setup_fuse_pkgconfig(fuse_suffix: "")
    ### OLD METHOD: Fake pkg-config
    # mkdir "#{alt_fuse_root}/bin" do
    #  cp path/"../../lib/fuse-pkg-config", "."
    #  inreplace "fuse-pkg-config", "%FUSE_ROOT%", "#{alt_fuse_root}"
    # end
    # ENV["PKG_CONFIG"] = "#{fuse_pkgconfig}"

    ### NEW METHOD: Fix fuse.pc in alt root
    mkdir "#{alt_fuse_root}/lib/pkgconfig" do
      cp "/usr/local/lib/pkgconfig/fuse#{fuse_suffix}.pc", "."
      inreplace "fuse#{fuse_suffix}.pc", "/usr/local", alt_fuse_root.to_s
    end
    ENV.prepend_path "PKG_CONFIG_PATH", "#{alt_fuse_root}/lib/pkgconfig"
  end

  # def fuse_pkgconfig
  #  return "#{alt_fuse_root}/bin/fuse-pkg-config" if need_alt_fuse?
  #  "pkg-config"
  # end

  def setup_fuse_env(fuse_suffix: "")
    odebug "Setting up FUSE#{fuse_suffix} temp environment under #{alt_fuse_root}"
    setup_fuse_includes(fuse_suffix: fuse_suffix)
    setup_fuse_libs(fuse_suffix: fuse_suffix)
    setup_fuse_pkgconfig(fuse_suffix: fuse_suffix)
    Dir.glob("#{alt_fuse_root}/**/*").each { |f| odebug ">>> #{f}" }
  end

  def disable_macfuse_extensions
    ENV.append "CFLAGS", "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0"
    ENV.append "CPPFLAGS", "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0"
    ENV.append "CXXFLAGS", "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0"
    ENV.append "CGO_CPPFLAGS", "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0"
  end

  def setup_fuse_flags(fuse_suffix: "")
    ENV.append "CFLAGS", "-I#{alt_fuse_root}/include/fuse#{fuse_suffix}"
    ENV.append "CFLAGS", "-I#{alt_fuse_root}/include"
    ENV.append "CPPFLAGS", "-I#{alt_fuse_root}/include/fuse#{fuse_suffix}"
    ENV.append "CPPFLAGS", "-I#{alt_fuse_root}/include"
    ENV.append "CXXFLAGS", "-I#{alt_fuse_root}/include/fuse#{fuse_suffix}"
    ENV.append "CPPFLAGS", "-I#{alt_fuse_root}/include"
    ENV.append "LDFLAGS", "-L#{alt_fuse_root}/lib"
    ENV.append "CGO_CPPFLAGS", "-I#{alt_fuse_root}/include/fuse#{fuse_suffix}"
    ENV.append "CGO_CPPFLAGS", "-I#{alt_fuse_root}/include"
    ENV.append "CGO_LDFLAGS", "-L#{alt_fuse_root}/lib"
    odebug "PKG_CONFIG = #{ENV.fetch("PKG_CONFIG", nil)}"
    odebug "PKG_CONFIG_PATH = #{ENV.fetch("PKG_CONFIG_PATH", nil)}"
    odebug "CFLAGS = #{ENV.fetch("CFLAGS", nil)}"
  end

  def setup_common(disable_exts:)
    disable_macfuse_extensions if disable_exts
    ENV.append "CFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "CPPFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CPPFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "CXXFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CXXFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "CGO_CPPFLAGS", "-D_FILE_OFFSET_BITS=64"
    ENV.append "CGO_CPPFLAGS", "-D_USE_FILE_OFFSET_BITS=64"
    ENV.append "LDFLAGS", "-F/Library/Filesystems/macfuse.fs/Contents/Frameworks"
  end

  def setup_fuse(disable_exts: true)
    setup_common(disable_exts: disable_exts)
    return unless need_alt_fuse?

    setup_fuse_env()
    setup_fuse_flags()
  end

  def setup_fuse3(disable_exts: true)
    setup_common(disable_exts: disable_exts)
    return unless need_alt_fuse?

    setup_fuse_env(fuse_suffix: "3")
    setup_fuse_flags(fuse_suffix: "3")
  end
end
