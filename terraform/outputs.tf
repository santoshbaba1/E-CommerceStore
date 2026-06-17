output "application_url" {
  value = "http://${aws_instance.ecommerce_instance.public_ip}"
}
