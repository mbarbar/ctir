# Prepare release on Travis CI.

ctir_version=`echo "$TRAVIS_TAG" | sed 's/^ctir-//'`
if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  os="ubuntu";
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  os="macos";
else
  echo "Bad OS?"
  travis_terminate 1
fi

echo "TRAVIS_TAG     = $TRAVIS_TAG"
echo "ctir_version   = $ctir_version"
echo "TRAVIS_OS_NAME = $TRAVIS_OS_NAME"
echo "os             = $os"

# Build.
mkdir build;
cd build;
cmake ../llvm -DCMAKE_BUILD_TYPE=MinSizeRel -DLLVM_ENABLE_PROJECTS=clang -DLLVM_TARGETS_TO_BUILD="" -G "Unix Makefiles";
make clang -j8;

# Zip binaries.
cd bin;
ls;
zip --symlink "ctir-clang-v$ctir_version-$os.zip" clang clang++ `find . -maxdepth 1 -regex '\./clang-[0-9][0-9]*'`;
mv ctir-clang*.zip ../..;

# Zip source.
cd ../..;
zip -r "ctir-clang-v$ctir_version-source.zip" clang
