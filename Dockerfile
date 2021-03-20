FROM julia:1.5

ARG H_GID
ARG H_UID

RUN addgroup --gid $H_GID user \
	&& adduser user --uid $H_UID --ingroup user --gecos "" --home /home/user/ --disabled-password

WORKDIR /home/user/src/
USER user

CMD ["/bin/bash"]