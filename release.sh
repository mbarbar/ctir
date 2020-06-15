# Prepare release on Travis CI.

ctir_version=`echo "$TRAVIS_TAG" | sed 's/^ctir-//'`
if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  os="ubuntu18.04";
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  os="macos10.15";
else
  echo "Bad OS?"
  travis_terminate 1
fi

echo "TRAVIS_TAG     = $TRAVIS_TAG"
echo "ctir_version   = $ctir_version"
echo "TRAVIS_OS_NAME = $TRAVIS_OS_NAME"
echo "os             = $os"

mkdir build
mkdir install

# Build.
cd build;
cmake "$TRAVIS_BUILD_DIR/llvm" -DCMAKE_BUILD_TYPE=MinSizeRel       \
                               -DLLVM_ENABLE_PROJECTS=clang        \
                               -DLLVM_TARGETS_TO_BUILD="X86"       \
                               -DCMAKE_INSTALL_PREFIX="../install" \
                               -G "Ninja";
ninja clang;

# Zip binaries.
zip -r --symlink "ctir-clang-v$ctir_version-$os.zip" bin/clang                                                  \
                                                     bin/clang++                                                \
                                                     `find ./bin -maxdepth 1 -regex '\./bin/clang-[0-9][0-9]*'` \
                                                     lib/clang
mv ctir-clang*.zip "$TRAVIS_BUILD_DIR"

# Zip source.
cd "$TRAVIS_BUILD_DIR";
zip -r "ctir-clang-v$ctir_version-source.zip" clang
