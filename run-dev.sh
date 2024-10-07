echo "pub fn get_api_url() { \"http://localhost:8080\" }" > ./client/src/env.gleam 

cd ./client \
  && gleam run -m lustre/dev build app --outdir=../server/priv/static --minify 


cd ..
rm -r ./server/build/dev/erlang/server/priv
mv ./server/priv ./server/build/dev/erlang/server/

cd ./server \
  && gleam run

cd ..
