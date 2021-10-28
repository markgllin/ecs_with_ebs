data "aws_iam_policy_document" "ecs_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_rexrays_policy" {
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:DeleteVolume",
      "ec2:DeleteSnapshot",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumeAttribute",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeSnapshots",
      "ec2:CopySnapshot",
      "ec2:DescribeSnapshotAttribute",
      "ec2:DetachVolume",
      "ec2:ModifySnapshotAttribute",
      "ec2:ModifyVolumeAttribute",
      "ec2:DescribeTags"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ecs_rexray_iam_policy" {
  name   = "rexray_iam_policy"
  policy = data.aws_iam_policy_document.ecs_rexrays_policy.json
}

resource "aws_iam_role" "ecs_iam_role" {
  name               = "${local.resource_prefix}-ir"
  assume_role_policy = data.aws_iam_policy_document.ecs_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_iam_role_pa" {
  role       = aws_iam_role.ecs_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_rexray_iam_role_pa" {
  role       = aws_iam_role.ecs_iam_role.name
  policy_arn = aws_iam_policy.ecs_rexray_iam_policy.arn
}

resource "aws_iam_instance_profile" "ecs_iam_ip" {
  name = "${local.resource_prefix}-ip"
  role = aws_iam_role.ecs_iam_role.name
}
