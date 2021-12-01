# Pin geodesic version
ARG VERSION=0.147.0
# Use debian base to avoid alpine compatiability issues
ARG OS=debian

FROM cloudposse/geodesic:$VERSION-$OS

ENV DOCKER_IMAGE="<#.cfg.docker_org#>/<#.cfg.docker_image_name#>"
ENV DOCKER_TAG="latest"

# Geodesic banner message
ENV BANNER="<#.cfg.banner#>"

# Default AWS_PROFILE
ENV AWS_PROFILE="<#.cfg.default_aws_profile#>"

# Enable advanced AWS assume role chaining for tools using AWS SDK
# https://docs.aws.amazon.com/sdk-for-go/api/aws/session/
ENV AWS_SDK_LOAD_CONFIG=1

# Region abbreviation "short" (4-5 chars)
# See https://github.com/cloudposse/terraform-aws-utils#introduction
ENV AWS_REGION_ABBREVIATION_TYPE=short
ENV AWS_DEFAULT_REGION=<#.cfg.aws_default_region#>
ENV AWS_DEFAULT_SHORT_REGION=<#.cfg.aws_default_short_region#>

# Install specific version of Terraform
ARG TF_1_VERSION=1.0.4
RUN apt-get update && apt-get install -y -u terraform-1="${TF_1_VERSION}-*"

# Set Terraform 1.x as the default `terraform`
RUN update-alternatives --set terraform /usr/share/terraform/1/bin/terraform

# Pin kubectl minor version (must be within 1 minor version of cluster version)
# Note, however, that due to Docker layer caching and the structure of this
# particular Dockerfile, the patch version will not automatically update
# until you change the minor version or change the base Geodesic version.
# If you want, you can pin the patch level so you can update it when desired.
ARG KUBECTL_VERSION=1.20
RUN apt-get update && apt-get install kubectl-${KUBECTL_VERSION}

# Install Atmos CLI (https://github.com/cloudposse/atmos)
RUN apt-get install atmos

COPY rootfs/ /

WORKDIR /
