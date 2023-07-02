terraform {
    required_providers {
        yandex ={
            source = "yandex-cloud/yandex"
            version = "0.93.0"
        }
    }
    required_version = ">= 0.13"
}

// Configure the Yandex.Cloud provider
provider "yandex" {
   token                    = ""
  //service_account_key_file = "path_to_service_account_key_file"
  cloud_id                 = "b1gg91hcfeoail8q0fat"
  folder_id                = "b1gvtnsqbtt8d0csfb6r"
  // zone                     = "var.yc_region_here"
}


resource "yandex_vpc_network" "zero-net" {
 name = "zero-net"
}

// Создать в VPC subnet с названием public, сетью 192.168.10.0/24.

resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.zero-net.id}"
  zone = "ru-central1-a"
}

// NAT-инстанс
resource "yandex_compute_instance" "nat" {
 name = "nat"
 hostname = "nat"
 platform_id = "standard-v1"
 zone = "ru-central1-a"

 resources {
 cores = 2
 memory = 4
  }

 boot_disk {
 initialize_params {
 image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

 network_interface {
 subnet_id = yandex_vpc_subnet.public.id
 nat = true
 ip_address = "192.168.10.254"
  }

 metadata = {
 user-data = file("./yc_meta.yaml")
  }

 scheduling_policy {
 preemptible = "true"
  }
}

// Создать в этой приватной сети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
resource "yandex_compute_instance" "public" {
 name = "public"
 platform_id = "standard-v1"
 zone = "ru-central1-a"

 hostname = "inst-pub"

 resources {
 cores = 2
 memory = 2
  }

 boot_disk {
 initialize_params {
 image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

 network_interface {
 subnet_id = yandex_vpc_subnet.public.id
 nat = true
 ip_address = "192.168.10.4"
 }

 metadata = {
 user-data = file("./yc_meta.yaml")
  }

 scheduling_policy {
 preemptible = "true"
  }
}

//Создать в vpc subnet с названием private, сетью 192.168.20.0/24.

resource "yandex_vpc_subnet" "private" {
 name = "private"
 v4_cidr_blocks = ["192.168.20.0/24"]
 zone = "ru-central1-a"
 network_id = yandex_vpc_network.zero-net.id
 route_table_id = yandex_vpc_route_table.lab-rt-a.id

}

// Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
resource "yandex_vpc_route_table" "lab-rt-a" {
  name = "route-st"
  network_id = "${yandex_vpc_network.zero-net.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   =  "192.168.10.254"
    //yandex_compute_instance.nat.network_interface.0.ip_address
    //"192.168.10.254"

  }
}

//Создать в этой приватной подсети виртуалку с внутренним IP.
resource "yandex_compute_instance" "private" {
 name = "private"
 platform_id = "standard-v1"
 zone = "ru-central1-a"

 hostname = "inst-priv"

 resources {
 cores = 2
 memory = 2
  }

 boot_disk {
 initialize_params {
 image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

 network_interface {
 subnet_id = yandex_vpc_subnet.private.id
 nat = false
 ip_address = "192.168.20.4"
 }

 metadata = {
 user-data = file("./yc_meta.yaml")
  }

 scheduling_policy {
 preemptible = "true"
  }
}
