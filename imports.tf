import {
  to = aws_dynamodb_table.terraform_lock
  id = "raghuterraform-lock"
}

import {
  to = aws_iam_openid_connect_provider.eks
  id = "arn:aws:iam::957948932374:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/63287C66C4214ADAFB3E56C6AB653D92"
}

import {
  to = aws_iam_policy.alb_controller
  id = "arn:aws:iam::957948932374:policy/AWSLoadBalancerControllerIAMPolicy"
}
