if [ ! -f config/ssl_key.pem ];
then
  openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=NA/ST=NA/L=NA/O=NA/CN=$(hostname)" \
    -keyout /app/config/ssl_key.pem \
    -out /app/config/ssl_cert.pem
fi

exec elixir -S mix phx.server
