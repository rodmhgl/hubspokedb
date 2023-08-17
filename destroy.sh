export TF_INPUT=0
export TF_IN_AUTOMATION=1

ACTION=${1:-destroy}

export ENVIRONMENT=nprd
export WORKING_DIR=./bastion
terraform -chdir=$WORKING_DIR init -backend-config="key=db/${ENVIRONMENT}/hub_bastion.tfstate" -reconfigure -force-copy
# terraform -chdir=$WORKING_DIR plan -var="environment=${ENVIRONMENT}"
terraform -chdir=$WORKING_DIR $ACTION -var="environment=${ENVIRONMENT}" -auto-approve
# terraform -chdir=$WORKING_DIR destroy -var="environment=${ENVIRONMENT}"

export WORKING_DIR=./hub
terraform -chdir=$WORKING_DIR init -backend-config="key=db/${ENVIRONMENT}/hub_landing_zone.tfstate" -reconfigure -force-copy
# terraform -chdir=$WORKING_DIR plan -var="environment=${ENVIRONMENT}"
terraform -chdir=$WORKING_DIR $ACTION -var="environment=${ENVIRONMENT}" -auto-approve
#terraform -chdir=$WORKING_DIR destroy -var="environment=${ENVIRONMENT}" -auto-approve



export ENVIRONMENT=sim
export WORKING_DIR=./bastion
terraform -chdir=$WORKING_DIR init -backend-config="key=db/${ENVIRONMENT}/hub_bastion.tfstate" -reconfigure -force-copy
# terraform -chdir=$WORKING_DIR plan -var="environment=${ENVIRONMENT}"
terraform -chdir=$WORKING_DIR apply -var="environment=${ENVIRONMENT}" -auto-approve
# terraform -chdir=$WORKING_DIR destroy -var="environment=${ENVIRONMENT}"

export WORKING_DIR=./hub
terraform -chdir=$WORKING_DIR init -backend-config="key=db/${ENVIRONMENT}/hub_landing_zone.tfstate" -reconfigure -force-copy
# terraform -chdir=$WORKING_DIR plan -var="environment=${ENVIRONMENT}"
terraform -chdir=$WORKING_DIR $ACTION -var="environment=${ENVIRONMENT}" -auto-approve
# terraform -chdir=$WORKING_DIR destroy -var="environment=${ENVIRONMENT}"
