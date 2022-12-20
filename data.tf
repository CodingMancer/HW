resource "aws_ebs_volume" "ss_ebs" {
  availability_zone = "us-east-1a"
  size              = 8

  tags = {
    Name = "ss_ebs"
  }
}

resource "aws_ebs_snapshot" "ss_snapshot" {
  volume_id = aws_ebs_volume.ss_ebs.id

  tags = {
    Name = "ss_snapshot"
  }
}

/* resource "aws_ami" "ss_ami" {
  name                = "simplisafehw_ami"
  description         = "basic ami to be used for ec2 instance"
  architecture        = "x86_64"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = "snap-idxxxxxxx"
    volume_size = 8
  }

  tags = {
    Name = "ss_ami"
  }
} */

/* data "aws_ami" "ss_ami" {
  most_recent = true
  owners      = ["526299718963"]

 filter {
 name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
} */