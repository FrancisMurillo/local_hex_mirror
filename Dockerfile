FROM bitwalker/alpine-elixir-phoenix:latest

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mkdir -p /opt/app/.cache && \
    mkdir -p /opt/app/_build && \
    mkdir -p /opt/app/local_hex_mirror && \
    mkdir -p /opt/app/local_hex_mirror/deps && \
    chmod -R 777 /opt

ENV MIX_BUILD_PATH=/opt/app/_build
ENV PATH="$PATH:/opt/mix"

WORKDIR /opt/app/local_hex_mirror

EXPOSE 4000

USER default

CMD ["mix", "phx.server"]
