class Freecad < Formula
  desc "A parametric 3D modeler"
  homepage "http://www.freecadweb.org"
  url "https://github.com/FreeCAD/FreeCAD/archive/0.17_pre.tar.gz"
  version "0.17-pre"
  sha256 "25648fbaac8a96d7e63d8881fbc79f1829eff2852927e427cfe6d5f4f60a4f95"
  head "https://github.com/FreeCAD/FreeCAD.git", :branch => "master"

  # Debugging Support
  option "with-debug", "Enable debug build"

  # Option to use custom bottles built with FreeCAD-specific option primarily
  # to reduce Travis build times
  option "with-freecad-bottles", "Build using FreeCAD hosted bottles pre-built with FreeCAD-specific options"

  # Optionally install packaging dependencies
  option "with-packaging-utils"

  # Build dependencies
  depends_on "cmake"   => :build
  depends_on "ccache"  => :build

  # Required dependencies
  depends_on :macos => :mavericks
  depends_on "eigen"
  depends_on "freetype"
  depends_on "python"
  depends_on "boost-python"
  depends_on "xerces-c"
  depends_on "cartr/qt4/qt"
  depends_on "cartr/qt4/pyside-tools"
  depends_on "homebrew/science/opencascade"
  depends_on "homebrew/science/orocos-kdl"
  depends_on "homebrew/science/matplotlib"
  depends_on "homebrew/science/med-file"
  depends_on "FreeCAD/freecad/pivy"
  depends_on "FreeCAD/freecad/coin"
  depends_on "FreeCAD/Freecad/nglib"
  depends_on "swig" => :build

  if build.with?("freecad-bottles") && MacOS.version == :yosemite
    ohai "Using pre-packaged FreeCAD bottles"
    depends_on "FreeCAD/freecad/vtk" # Bottled using options --without-python
  else
    depends_on "homebrew/science/vtk" => "without-python"
  end

  if build.with?("packaging-utils")
    depends_on "node"
    depends_on "jq"
  end

  def install
    if build.with?("packaging-utils")
      system "node", "install", "-g", "app_dmg"
    end

    # Set up needed cmake args
    args = std_cmake_args + %W[
      -DBUILD_FEM_NETGEN:BOOL=ON
      -DFREECAD_USE_EXTERNAL_KDL=ON
      -DCMAKE_BUILD_TYPE=#{build.with?("debug") ? "Debug" : "Release"}
    ]

    mkdir "Build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    After installing FreeCAD you may want to do the following:

    1. Amend your PYTHONPATH environmental variable to point to
       the FreeCAD directory
         export PYTHONPATH=#{bin}:$PYTHONPATH
    EOS
  end
end
