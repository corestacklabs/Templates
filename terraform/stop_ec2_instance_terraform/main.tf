resource "null_resource" "Stop_ec2_instance" {
  provisioner "local-exec" {
    interpreter = [ "bash","-c" ]
    command = <<-EOF
#!/bin/bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
python -m pip install boto3
python3 stop_ec2.py ${var.instance_id} ${var.region}
EOF
  }
}