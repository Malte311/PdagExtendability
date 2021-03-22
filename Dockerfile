FROM julia:1.5

ARG H_GID
ARG H_UID

RUN addgroup --gid $H_GID user \
	&& adduser user --uid $H_UID --ingroup user --gecos "" --home /home/user/ --disabled-password

WORKDIR /home/user/src/
USER user

COPY Manifest.toml Project.toml /home/user/
RUN julia --project=/home/user/ -e 'using Pkg; Pkg.instantiate()' \
	&& echo 'alias julia="julia --project=/home/user/ $@"' >> ~/.bashrc

CMD ["/bin/bash"]