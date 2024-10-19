# Use Alpine as the base image
FROM alpine:3.18

# Install inotify-tools, bash, curl, python3, pip (for MkDocs), Pillow, cairosvg
RUN apk add --no-cache inotify-tools bash curl python3 py3-pip cairo-dev pango-dev gdk-pixbuf-dev && \
    curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.19.0/terraform-docs-v0.19.0-linux-amd64.tar.gz && \
    tar -xzf terraform-docs.tar.gz && \
    chmod +x terraform-docs && \
    mv terraform-docs /usr/local/bin/terraform-docs && \
    rm terraform-docs.tar.gz && \
    pip install --no-cache-dir mkdocs mkdocs-material mkdocs-material[imaging] cairosvg Pillow

# Create the working directory inside the container
WORKDIR /usr/src/app

# Copy the scripts and Terraform modules into the container
COPY ./apps/terraform-docs/scripts/monitoring.sh ./apps/terraform-docs/scripts/generate.sh /usr/src/app/scripts/
COPY ./gcp/modules /usr/src/app/gcp/modules

# Ensure the scripts are executable
RUN chmod +x /usr/src/app/scripts/monitoring.sh /usr/src/app/scripts/generate.sh

# Create necessary directories
#RUN mkdir -p /usr/src/app/docs /usr/src/app/site

# Expose the port for MkDocs
EXPOSE 8080

# Run the monitoring script when the container starts
CMD ["/usr/src/app/scripts/monitoring.sh"]




