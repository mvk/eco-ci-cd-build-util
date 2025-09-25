CONTAINERFILE			= Containerfile
NAMESPACE				= $(USER)
ENV_FILE				= podman.env
IMAGE_PYTHON_VERSION	= 3.12
PIP_REQS				= build.util/pip.txt
PIP_REQS_DEV			= build.util/pip-dev.txt
VARS_TO_PRINT			= CONTAINERFILE NAMESPACE ENV_FILE IMAGE_PYTHON_VERSION PIP_REQS PIP_REQS_DEV
# Print the variable's value during parsing
$(info The values of variables:)
$(foreach var,$(VARS_TO_PRINT),$(call print_var_info,$(var)))
