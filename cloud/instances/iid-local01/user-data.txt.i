From nobody Fri Nov  9 14:58:17 2018
Content-Type: multipart/mixed; boundary="===============2534613241816882062=="
MIME-Version: 1.0
Number-Attachments: 1

--===============2534613241816882062==
MIME-Version: 1.0
Content-Type: text/cloud-config
Content-Disposition: attachment; filename="part-001"

#cloud-config
system_info:
  default_user:
    name: test
    lock_passwd: true
    gecos: Local Administrator
    groups: [wheel, adm, systemd-journal]
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
runcmd:
   - "echo root:moose | chpasswd" 

--===============2534613241816882062==--