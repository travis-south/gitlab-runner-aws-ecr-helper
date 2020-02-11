#!/usr/bin/env sh

set -e
# Set tools desired versions
GITLAB_RUNNER_VERSION=v12.7.1
AWS_ECR_HELPER_VERSION=v0.4.0
ALPINE_VERSION=3.9
IMAGE_VERSION=1.0.0

docker image build \
    --build-arg GITLAB_RUNNER_VERSION=${GITLAB_RUNNER_VERSION} \
    --build-arg AWS_ECR_HELPER_VERSION=${AWS_ECR_HELPER_VERSION} \
    --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
    -t travissouth/gitlab-runner-aws-ecr-helper:${IMAGE_VERSION}-alpine${ALPINE_VERSION}-${GITLAB_RUNNER_VERSION}-${AWS_ECR_HELPER_VERSION} \
    -t travissouth/gitlab-runner-aws-ecr-helper:latest \
    .

docker push travissouth/gitlab-runner-aws-ecr-helper:latest
docker push travissouth/gitlab-runner-aws-ecr-helper:${IMAGE_VERSION}-alpine${ALPINE_VERSION}-${GITLAB_RUNNER_VERSION}-${AWS_ECR_HELPER_VERSION}
