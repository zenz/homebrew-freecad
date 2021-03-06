class Coin < Formula
  desc "Retained-mode toolkit for 3D graphics development"
  homepage "https://bitbucket.org/Coin3D/coin/wiki/Home"
  url "https://github.com/coin3d/coin", :using => :git, :tag => "Coin-4.0.0"
  head "https://github.com/coin3d/coin", :using => :git
  version "4.0.0"

  option "with-docs",       "Install documentation"
  option "with-threadsafe", "Include Thread safe traverals (experimental)"

  depends_on "cmake"   => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "boost"

  bottle do
    root_url "https://dl.bintray.com/vejmarie/freecad"
    cellar :any
    sha256 "69ba7ade754a6a5840308d54a80583c94ea101ca156362e9688534fd9c64c284" => :catalina
    sha256 "924ace4807f72ff3691fcbd029c15fbe53b89f74321746c6e322dd7a5635eef2" => :big_sur
  end

  def install

    cmake_args = std_cmake_args
    cmake_args << "-DCOIN_THREADSAFE:BOOL=OFF" if build.without? "threadsafe"
    cmake_args << "-DCOIN_BUILD_DOCUMENTATION:BOOL=OFF" if build.without? "docs"
    cmake_args << "-DCOIN_USE_CPACK:BOOL=OFF"

    mkdir "build-lib" do
      system "mkdir", "../cpack.d"
      system "touch", "../cpack.d/CMakeLists.txt"
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end
end
