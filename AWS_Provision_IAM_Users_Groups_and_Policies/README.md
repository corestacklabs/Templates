
# AWS_Provision_IAM_Users_Groups_and_Policies

This example also creates an AWSAccessKeyId/AWSSecretKey pair associated with the new user. The example is somewhat contrived since it creates all of the users and groups typically you would be creating policies users and/or groups that contain referemces to existing users or groups in your environment. Note that you will need to specify the CAPABILITY_IAM flag when you create the stack to allow this template to execute. You can do this through the AWS management console by clicking on the check box acknowledging that you understand this template creates IAM resources or by specifying the CAPABILITY_IAM flag to the cfn-create-stack command line tool or CreateStack API call. 

### Prerequisites

AWS account

## Deployment

Import the CFN template on to the AWS CloudFormation or click below to deploy to the corestack product 

[![Deploy to Azure](https://docs.corestack.io/wp-content/uploads/2019/09/deploy-to-corestack.svg)](http://192.168.2.201/heatstack/templates?repositories=github&url=https://raw.githubusercontent.com/corestacklabs/Templates/master/AWS_Provision_IAM_Users_Groups_and_Policies/AWS_Provision_IAM_Users_Groups_and_Policies_content.json&engine=cfn&type[0]=Cloud&classification[0]=Provisioning&scope=tenant#/mytemplates)

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/karthick-kk/30e4fd3f279492b4f040d5cd569d21d0) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Corestack developers
* Microsoft Github

