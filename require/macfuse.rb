# typed: false
# frozen_string_literal: true

# USAGE:
# 1. Start FUSE formula file with `require_relative "../require/macfuse"`
# 2. Add `MacfuseRequirement` as formula dependency

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

require_relative "formula-patch"
