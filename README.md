# bind-dns

Use packer and terraform to deploy a pair of Bind DNS servers in an AWS VPC to resolve DNS name for K8s API server (or whatever you wish).

## Prerequisites
* a pair of elastic network interfaces in AWS with static private IPs

## Initial Deployment

1. Clone this repo.
```
    $ git clone git@github.com:lander2k2/bind-dns.git
    $ cd kube-cluster
```

2. Export your AWS keys and preferred region.
```
    $ export AWS_ACCESS_KEY_ID="accesskey"
    $ export AWS_SECRET_ACCESS_KEY="secretkey"
    $ export AWS_DEFAULT_REGION="us-east-2"
```

3. Build a CentOS-based image for your DNS servers.  Not the AMI ID for adding to the tfvars.
```
    $ cd images
    $ packer build ns_template_centos.json
```

4. Edit terraform variables.  Add the appropriate values for your environment.
```
    $ cd ../
    $ cp terraform.tfvars.example terraform.tfvars
    $ vi terraform.tfvars
```

5. Deploy the name servers.  The 2 deployed servers will be identical.  Arbitrarily assign one as the master and the other as the slave.
```
    $ terraform init infra
    $ terraform plan infra
    $ terraform apply infra
```

6. Set the variables to configure your name servers.
```
    $ cp dns.env.example dns.env
    $ vi dns.env
```

7. Copy the env vars to your name servers.
```
    $ scp dns.env centos@[master ip]
    $ scp dns.env centos@[slave ip]
```

8. Connect to the master name server and configure.
```
    $ ssh centos@[master ip]
    $ sudo su
    # source dns.env
    # configure_master.sh
```

9. Repeat for the slave name server.
```
    $ ssh centos@[slave ip]
    $ sudo su
    # source dns.env
    # configure_slave.sh
```

10. Update your existing upstream VPC DNS servers to delegate the specified zone to the IPs of your master and slave DNS servers.

## Zone Updates

This update is based on the assumption that your base domain and zone subdomain have *not* changed.  These instructions are to update records within an exisiting zone.

1. Ensure your `dns.env` file is updated and all variables accurate.

2. Generate updated zone file.
```
    $ source dns.env
    $ ./update_zone_conf.sh
```

3. Copy updated zone file to the master bind server and ssh to it.
```
    $ scp -i [private key] [zone file] [user]@[master ip]:~/
    $ ssh -i [private key] [user]@[master ip]
```

4. Update conf on server.  If your zone is `k8s.cnqr-cn.com` your zone subdomain is `k8s` and your base domain is `cnqr-cn.com`.
```
    $ sudo su
    # mv ./[zone file] /etc/named/zones/
    # named-checkzone [zone subdomain].[base domain] /etc/named/zones/db.[zone subdomain].[base domain]  # to validate zone config
    # sudo systemctl restart named
```

## New Zone Records

If you deploy an additional Kubernetes cluster in the same VPC or require additional name records for existing clusters (for things other than the API server), add new variables to the `dns.env` file and edit the `update_zone_conf.sh` script to include the new records in the zone config template.  Then run throug the "Zone Updates" steps above.

Note: this only works for adding new records to an existing zone, e.g `k8s.cnqr-cn.com`.  Adding new zones to the existing bind servers requires additional configuration.

