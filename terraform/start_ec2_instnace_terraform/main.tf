resource "null_resource" "delete_old_snapshots" {
  provisioner "local-exec" {
    interpreter = [ "bash","-c" ]
    command = <<-EOF
#!/bin/bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
python -m pip install boto3
python3 start_ec2.py ${var.instance_id} ${var.region}
EOF
  }
}