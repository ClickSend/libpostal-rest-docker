#!/usr/bin/env bash

set -e
set -x
set -ex
set -u
set -o pipefail

# more bash-friendly output for jq
JQ="jq --raw-output --exit-status"

#SUMMARY: This is the intended name of the new image tag.
#newImageName="date-$(date +%F)_build-${CIRCLE_BUILD_NUM}_branch-${CIRCLE_BRANCH}"
newImageName="${CIRCLE_SHA1}"

#builtImageName="${ENV_NAME}-image"

#SUMMARY: This is the host where your repository lives. For ECR, it's typically of the form: {UniqueId}.dkr.ecr.{location}.amazonaws.com
repositoryHost="${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com"

#SUMMARY: This is the name of the repository you wish to push to.
repositoryName="${CIRCLE_PROJECT_REPONAME}-${ENV_NAME}"

#SUMMARY: This is the intended full path of the new image.
tagPath="$repositoryHost/$repositoryName:$newImageName"

#SUMMARY: The region your ECR registry is in.
ecrRegion="${AWS_REGION}"

#SUMMARY: The base name of the task you want running the image.
#NOTE: This does not include the revision number that is typically added on.
taskName="${CIRCLE_PROJECT_REPONAME}-${ENV_NAME}"

#SUMMARY: memory for the task
taskMemory=256

#SUMMARY: cpu for the task
taskCpu=32

#SUMMARY: This is the port relative to the container. I.e., within your code, this is what port your service is registered on.
containerPort=8080

#SUMMARY: The port on the host that the container port is mapped to. This will be the port you use to access the service publicly.
hostPort=0

#SUMMARY: The name of the cluster the service is running on.
clusterName="${ENV_NAME}-api"

#SUMMARY: The name of the service running the task.
serviceName="${CIRCLE_PROJECT_REPONAME}"

#Nginx repo name
nginxTagPath="$repositoryHost/docker-nginx-lumen-${ENV_NAME}:latest"

#SUMMARY: the definition of the task to run the image.
task_def="[{
      \"name\": \"$serviceName\",
      \"image\": \"$tagPath\",
      \"essential\": true,
      \"memoryReservation\": $taskMemory,
      \"cpu\": $taskCpu,
      \"hostname\": \"$taskName\",
      \"dockerLabels\": {
        \"com.datadoghq.ad.init_configs\": \"[{}]\",
        \"com.datadoghq.ad.logs\": \"[{\\\"source\\\": \\\"$serviceName\\\", \\\"service\\\": \\\"$serviceName\\\"}]\"
      },
      \"environment\": [
        {
          \"name\": \"CIRCLE_PROJECT_REPONAME\",
          \"value\": \"$serviceName\"
        },
        {
          \"name\": \"LIBPOSTAL_VERSION\",
          \"value\": \"v1.0.0\"
        },
        {
          \"name\": \"LIBPOSTAL_DATADIR\",
          \"value\": \"/opt/libpostal_data\"
        },
        {
          \"name\": \"LIBPOSTAL_DATA_FILE\",
          \"value\": \"libpostal_data.tar.gz\"
        },
        {
          \"name\": \"LIBPOSTAL_PARSER_FILE\",
          \"value\": \"parser.tar.gz\"
        },
        {
          \"name\": \"LIBPOSTAL_LANG_CLASS_FILE\",
          \"value\": \"language_classifier.tar.gz\"
        },
        {
          \"name\": \"PKG_CONFIG_PATH\",
          \"value\": \"/usr/local/lib/pkgconfig\"
        }
      ],
      \"portMappings\": [
        {
            \"containerPort\": $containerPort,
            \"hostPort\": $hostPort
        }
      ]
}]"

#SUMMARY: the definition of the volumes that exist for this image.
#vol_def="[{
#      \"name\": \"$serviceName\",
#      \"dockerVolumeConfiguration\": {
#        \"autoprovision\": true,
#        \"labels\": {
#          \"Name\": \"$serviceName\"
#        },
#        \"scope\": \"shared\",
#        \"driver\": \"local\"
#      }
#}]"

#SUMMARY: Tags and pushes the image to ECR
#push_image_to_ecr() {
#  echo "Logging into ECR"
#  eval $(aws ecr get-login --region $ecrRegion)
#
#  echo "Pushing image $tagPath"
#  docker tag $builtImageName $tagPath
#  docker push $tagPath
#}

#SUMMARY: Registers the task with ECS.
register_task_definition() {

    aws configure set region $ecrRegion

    if revision=$(aws ecs register-task-definition --container-definitions "$task_def" --family $taskName | $JQ '.taskDefinition.taskDefinitionArn'); then
        echo "Revision: $revision"
    else
        echo "Failed to register task definition"
        return 1
    fi
}

#SUMMARY: updates the service to use the new image revision.
update_service() {
    if [[ $(aws ecs update-service --cluster $clusterName --service $serviceName --task-definition $revision | \
                   $JQ '.service.taskDefinition') != $revision ]]; then
        echo "Error updating service."
        return 1
    fi

    echo "Deployed!"
    return 0
}

#push_image_to_ecr
register_task_definition
update_service
