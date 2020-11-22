#-------------------------------------------------------------------------------
# Build the rust-g library from the Rust code using Rust
#-------------------------------------------------------------------------------
FROM i386/rust:slim-buster as rustg_build
RUN apt-get update && apt-get install -y --no-install-recommends \
	libssl-dev \
	pkg-config \
	zlib1g-dev
COPY . /rust-g
WORKDIR /rust-g
RUN cargo build --release --features dmi,file,git,hash,http,log,noise,sql,url

#-------------------------------------------------------------------------------
# Create the docker image for the rust-g library
#-------------------------------------------------------------------------------
FROM scratch as rustg_image
COPY . /rust-g
COPY --from=rustg_build /rust-g/target/release/librust_g.so /rust-g/target/release/librust_g.so
