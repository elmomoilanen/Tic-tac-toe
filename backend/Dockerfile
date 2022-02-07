FROM julia:buster

RUN useradd -ms /bin/sh julia
USER julia

WORKDIR /app

RUN julia -e 'import Pkg; Pkg.update' && \
    julia -e 'import Pkg; Pkg.add("HTTP"); Using HTTP' && \
    julia -e 'import Pkg; Pkg.add("Genie"); Using Genie'

COPY --chown=julia:julia . .

# run backend tests
RUN julia ./test/runtests.jl

ENTRYPOINT ["sh", "/app/entrypoint.sh"]
