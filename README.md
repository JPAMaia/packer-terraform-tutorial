# PACKER + TERRAFORM TUTORIAL

## Vagrant

### Pre-requisites
```
$ vagrant plugin install vagrant-vbguest --plugin-version 0.30.0
$ vagrant box add bento/centos-7 --box-version 202103.18.0 --insecure
```

### Start VM
```
$ vagrant up
```

### Connect to VM
```
$ vagrant ssh
```

### Stop VM
```
vagrant halt
```

### Destroy VM
```
vagrant destroy -f
```

## Packer

### Initialize
```
packer init .
```

### Format files
```
packer fmt .
```

### Validate files
```
packer validate <VARS> .
```

### Build Image
```
packer build <VARS> .
```

## Terraform

### Initialize
```
terraform init
```

### Format files
```
terraform fmt
```

### Validate files
```
terraform validate
```

### Plan changes
```
terraform apply <VARS>
```

### Apply changes
```
terraform apply <VARS>
```

### Show infrastructure
```
terraform show
```

### Destroy infrastructure
```
terraform destroy
```
