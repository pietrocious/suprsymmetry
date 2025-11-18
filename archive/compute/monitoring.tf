# SNS topic for infra alerts
resource "aws_sns_topic" "alerts" {
  name = "production-infrastructure-alerts"
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "pietrouni@gmail.com"  # Your email
}

# cloudwatch alarm for high_cpu
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "production-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 15
  alarm_description   = "triggers when CPU exceeds 70%"
  alarm_actions       = [
    aws_sns_topic.alerts.arn,
    aws_autoscaling_policy.scale_up.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}

# cloudwatch alarm for low_cpu
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "production-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "triggers when CPU below 30%"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}

# cloudwatch alarm for  unhealthy_targets
resource "aws_cloudwatch_metric_alarm" "unhealthy_targets" {
  alarm_name          = "production-unhealthy-targets"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  alarm_description   = "Triggers when any target is unhealthy"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
    TargetGroup  = aws_lb_target_group.app.arn_suffix
  }
}

# scale_up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "production-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

# scale_down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "production-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}
