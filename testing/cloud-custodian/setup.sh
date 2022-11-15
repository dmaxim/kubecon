python3 -m venv custodian
source custodian/bin/activate
pip install c7n # AWS Support
pip install c7n_azure # Install Azure Package
pip install c7n_gcp # GCP package


# View schema

custodian schema azure

custodian schema azure.resourcegroup