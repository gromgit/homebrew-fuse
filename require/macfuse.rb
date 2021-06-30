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
    "This formula requires MacFUSE. Please run `brew install --cask macfuse` first."
  end
end

# Add `setup_fuse` to base Formula class, for use by FUSE formulae
class Formula
  def setup_fuse_includes
    mkdir buildpath/"temp/include" do
      Dir["/usr/local/include/fuse*"].each { |f| cp_r f, "." }
    end
  end

  def setup_fuse_libs
    mkdir buildpath/"temp/lib" do
      Dir["/usr/local/lib/*fuse*"].each { |f| cp_r f, "." }
    end
  end

  def setup_fuse_env
    odebug "Setting up FUSE temp environment under #{buildpath}/temp"
    setup_fuse_includes
    setup_fuse_libs
    Dir.glob(buildpath/"temp/**/*.*").each { |f| odebug ">>> #{f}" }
  end

  def setup_fuse_flags
    ENV.append "CFLAGS", "-I#{buildpath}/temp/include"
    ENV.append "CFLAGS", "-I#{buildpath}/temp/include/fuse"
    ENV.append "CPPFLAGS", "-I#{buildpath}/temp/include"
    ENV.append "CPPFLAGS", "-I#{buildpath}/temp/include/fuse"
    ENV.append "LDFLAGS", "-I#{buildpath}/temp/lib"
  end

  def setup_fuse
    return if HOMEBREW_PREFIX.to_s == "/usr/local"

    setup_fuse_env
    setup_fuse_flags
  end
end
