class Shiboken2 < Formula
  desc "GeneratorRunner plugin that outputs C++ code for CPython extensions"
  homepage "https://wiki.qt.io/PySide2"
  url "https://codereview.qt-project.org/gitweb?p=pyside/pyside-setup.git;a=snapshot;h=b09fde6260b255e8b93b0d20a337e701bc940a99;sf=tgz"
  sha256 "47a1dde02358045bd2441ab470d4d917a6b449daa389b3e5d41c513f50645f2f"
  version "5.9-b09fde6"

  head "https://codereview.qt-project.org/p/pyside/pyside-setup.git", :branch => "5.9"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "numpy"
  depends_on "qt"

  option "without-python", "Build without python 2 support"
  depends_on "python@2" => :recommended
  depends_on "python3" => :optional

  def install
    qt = Formula["qt"]

    ENV["LLVM_INSTALL_DIR"] = Formula["llvm"].opt_prefix

    Language::Python.each_python(build) do |python, version|
      mkdir "macbuild#{version}" do
        args = std_cmake_args

        # Building the tests, is effectively a test of Shiboken
        args << "-DBUILD_TESTS=ON"
        args << "-DUSE_PYTHON_VERSION=#{version}"
        args << "-DCMAKE_PREFIX_PATH=#{qt.prefix}/lib/cmake/"
        args << "../sources/shiboken2"

        system "cmake", *args
        system "make", "-j#{ENV.make_jobs}", "install"
      end
    end
  end

  test do
    system "shiboken2", "--version"
  end
end