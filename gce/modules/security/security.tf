resource "google_compute_firewall" "allow-internal-lb" {
  name    = "allow-internal-lb"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
    ports    = ["8080", "443"]
  }

  source_ranges = ["${ var.cidr }"]
  target_tags = ["int-lb"]
}

resource "google_compute_firewall" "allow-health-check" {
  name    = "allow-health-check"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
    ports = ["8080", "443"]
  }

  source_ranges = ["130.211.0.0/22","35.191.0.0/16","${ var.cidr }"]
}

resource "google_compute_firewall" "allow-ssh-bastion" {
  name    = "allow-ssh-bastion"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["${ var.allow_ssh_cidr }"]
  target_tags = ["bastion"]
}

resource "google_compute_firewall" "kubernetes-default-internal-master" {
  name    = "kubernetes-default-internal-master"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["${ var.service_cidr }"]
  target_tags = ["kubernetes-master"]
}

resource "google_compute_firewall" "kubernetes-default-internal-node" {
  name    = "kubernetes-default-internal-node"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["${ var.service_cidr }"]
  target_tags = ["kubernetes-minion"]
}

resource "google_compute_firewall" "kubernetes-master-etcd" {
  name    = "kubernetes-master-etcd"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
    ports    = ["2379", "2380", "2381" ]
  }

  target_tags = ["kubernetes-master"]
  source_tags = ["kubernetes-master"]
}


resource "google_compute_firewall" "kubernetes-master-https" {
  name    = "kubernetes-master-https"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["kubernetes-master"]
}

resource "google_compute_firewall" "kubernetes-minion-all" {
  name    = "kubernetes-minion-all"
  network = "${ var.name }"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }
  
  allow {
    protocol = "esp"
  }

  allow {
    protocol = "ah"
  }

  allow {
    protocol = "sctp"
  }

  source_ranges = ["${ var.cidr }"]
  target_tags = ["kubernetes-minion"]
}
