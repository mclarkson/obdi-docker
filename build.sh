# clean
opt=$1

rm -rf buildfiles/
rm -rf obdi-worker/buildfiles/

# Build the obdi rpms
docker build $opt build-obdi/ -t obdi-build

# Spin up the build container
docker run --name buildfiles -d obdi-build

# Copy from the build container to buildfiles/ dir
docker cp buildfiles:/obdi/rpmbuild/RPMS buildfiles
docker cp buildfiles:/obdi/rpmbuild/SRPMS buildfiles

# Stop and delete the build container
docker stop buildfiles
docker rm buildfiles

cp -a buildfiles/ obdi-worker/

# Now we can...
# Build obdi worker container
docker build $opt -t mclarkson/obdi-worker obdi-worker

# Build obdi master container
docker build $opt -t mclarkson/obdi-master .
