
# Azure_MySQL_Cluster

This template deploys a MySQL replication environment with one master and one slave servers.It Supports GTID based replication. Deploys a load balancer in front of the 2 VMs, so that the VMs are not directly exposed to the internet. MySQL and SSH ports are exposed through the load balancer using Network Security Group rules. Configures a http based health probe for each MySQL instance that can be used to monitor MySQL health.

### Prerequisites

Microsoft Azure Subscription with required access

## Deployment

Use either Azure CLI or Azure PowerShell to deploy a template. Alternatively, click below to deploy the template directly to the corestack product 

[![Deploy to Azure](https://docs.corestack.io/wp-content/uploads/2019/09/deploy-to-corestack.svg)](http://qa.corestack.io/heatstack/templates?repositories=github&external_redirect=true&name=Azure_MySQL_Cluster&url=https://raw.githubusercontent.com/corestacklabs/Templates/master/arm/Azure_MySQL_Cluster/Azure_MySQL_Cluster_content.json&engine=arm&type[0]=Cloud&classification[0]=Provisioning&services[0]=Azure&scope=tenant#/mytemplates)

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/karthick-kk/30e4fd3f279492b4f040d5cd569d21d0) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Corestack developers
* Microsoft Github

