# terraform_ec2-aws
- [x] Status:  Ainda em desenvolvimento.
###
### Módulo para criar uma Instancia na AWS. Para utilizar este módulo é necessário os seguintes arquivos especificados logo abaixo:

   <summary>versions.tf - Arquivo com as versões dos providers.</summary>

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}
```
#
<summary>main.tf - Arquivo que irá consumir o módulo para criar a infraestrutura.</summary>

```hcl
provider "aws" {
  region  = var.region
}

module "ec2" {
  source         = "git::https://github.com/israeldoamaral/terraform-ec2-aws"
  ec2_count      = 1
  ami_id         = "ami-04505e74c0741db8d"
  instance_type  = "t2.micro"
  subnet_id      = module.network.public_subnet[0]
  security_group = module.security_group.security_group_id
  key_name       = module.ssh-key.key_name
  userdata       = "install_jenkins_docker.sh"
  tag_name       = "Nome_da_instancia"
}

```

#
<summary>outputs.tf - Outputs de recursos que serão utilizados em outros módulos. OBS: Lembre-se de modificar o nome do módulo. Ex: "value = module.NOME.public_ip" Onde NOME tem que ser o mesmo criado</summary>

```hcl
output "public_ip" {
     value = module.ec2.public_ip
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network"></a> [network](#module\_network) | github.com/israeldoamaral/terraform-ec2-aws | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ec2_count"></a> [ec2_count](#input\_ec2_count) | Número de instanacias a ser criada, ex: ec2_count = 2 | `string` | `"1"` | yes |
| <a name="input_ami_id"></a> [ami_id](#input\_ami_id) | ID da AMI ex: "ami-04505e74c0741db8d" | `string` | `""` | yes |
| <a name="input_instance_type"></a> [instance_type](#input\_instance_type) | Tipo de instancia da AWS. Ex: t3.medium | `string` | "t2.micro" | yes |
| <a name="input_subnet_id"></a> [subnet_id](#input\_subnet_id) | Id da Subnet criada na VPC, ex: "subnet-02c0fd20a4fc54abd" | `string` | `""` | yes |
| <a name="input_security_group"></a> [security_group](#input\_security_group) | ID do Segurity Group. Ex: sg-00a2eba48a39ad491  | `string` | `""` | no |
| <a name="input_key_name"></a> [key_name](#input\_key_name) | Nome da key Pairs. Ex: terraform-key  | `string` | `" "` | no |
| <a name="input_userdata"></a> [userdata](#input\_userdata) | Nome do script com os comandos a serem executados. Ex: install.sh  | `string` | `""` | no |
| <a name="input_tag_name"></a> [tag_name](#input\_tag_name) | Nome da tag Label da Instancia. Ex: ec2_web  | `string` | `""` | yes |

## Outputs

No outputs.
#
## Como usar.
  - Para utilizar localmente crie os arquivos descritos no começo deste tutorial, main.tf, variables.tf e outputs.tf.
  - Após criar os arquivos, atente-se aos valores default das variáveis, pois podem ser alterados de acordo com sua necessidade. 
  - A variável `ec2_count` define o quantidade de instancias ec2 que seram criadas.
  - A variável `ami_id` define qual AMI será utilizada. OBS: Pode ser obtida através da console da AWS ou utilizando um datasource do Terraform.
  
  > Exemplo de DataSource

  ```hcl
   data "aws_ami" "ubuntu1604" {
   most_recent = true

   filter {
     name   = "name"
     values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
   }

   filter {
     name   = "virtualization-type"
     values = ["hvm"]
   }

   owners = ["099720109477"] # Canonical
   }

  ```
   
  > Aplicando no módulo
  
  ```hcl 
  ami_id = "${data.aws_ami.ubuntu1604.id}"
  ```  
  
  - A variável `instance_type` define qual tipo de Instancia será utilizada. Ex: t2.micro
  - A variável `subnet_id` define qual Id da subnet sera utilizado. OBS: Pode ser obtida pela console da AWS ou utilizando o resultado de um outro módulo.
  - A variável `security_group` define o Id de um Security Group já criado. OBS: Pode ser obtida pela console da AWS ou utilizando o resultado de um outro módulo.
  - A variável `key_name` Nome da chave para acessar uma instancia. OBS: Pode ser obtida pela console da AWS ou utilizando o resultado de um outro módulo.
  - A variável `userdata` Define o nome do arquivo (script) com os comandos a serem executados na instancia. Ex: install.sh
  - A variável `tag_name` Define o nome que sera mostrado no campo tag da instancia.
  - Certifique-se que possua as credenciais da AWS - **`AWS_ACCESS_KEY_ID`** e **`AWS_SECRET_ACCESS_KEY`**.

### Comandos
Para consumir os módulos deste repositório é necessário ter o terraform instalado ou utilizar o container do terraform dentro da pasta do seu projeto da seguinte forma:

* `docker run -it --rm -v $PWD:/app -w /app --entrypoint "" hashicorp/terraform:light sh` 
    
Em seguida exporte as credenciais da AWS:

* `export AWS_ACCESS_KEY_ID=sua_access_key_id`
* `export AWS_SECRET_ACCESS_KEY=sua_secret_access_key`
    
Agora é só executar os comandos do terraform:

* `terraform init` - Comando irá baixar todos os modulos e plugins necessários.
* `terraform fmt` - Para verificar e formatar a identação dos arquivos.
* `terraform validate` - Para verificar e validar se o código esta correto.
* `terraform plan` - Para criar um plano de todos os recursos que serão utilizados.
* `terraform apply` - Para aplicar a criação/alteração dos recursos. 
* `terraform destroy` - Para destruir todos os recursos que foram criados pelo terraform. 
