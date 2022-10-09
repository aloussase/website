FROM haskell:9.0.2-slim

WORKDIR /opt/app

RUN cabal update

COPY ./website.cabal .
RUN cabal build --only-dependencies -j4

COPY . .
RUN cabal install

CMD ["website"]
