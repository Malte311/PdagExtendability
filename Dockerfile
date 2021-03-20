FROM julia:1.6

RUN mkdir /configs/ && chown www-data:www-data /configs/ \
	&& mkdir /src/ && chown www-data:www-data /src/

RUN julia -e 'using Pkg; Pkg.add("Documenter")'

COPY --chown=www-data:www-data ./configs/ ./configs/

COPY --chown=www-data:www-data ./src/ ./src/