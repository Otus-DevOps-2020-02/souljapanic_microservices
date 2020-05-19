output "gitlab-app-ext-ip" {
  value = {
    for instance in google_compute_instance.app :
    instance.name => instance.network_interface[0].access_config[0].nat_ip
  }
}
