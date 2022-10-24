# KS Deploy Demo
## _Elementos previos para la demo_
- Tener instalado en el PC python, docker y git
- Contar con una cuenta de github
- Crear una cuenta gratutita de azure (se elige solo por sencilla sucreación)

## Para crear la infraestructura necesaria

- En el portal de azure, creacion un service principal y un secreto el cual nos ayudara con el login en azure desde github.

![service principal](/docs/tf2.png)
- Agregar el cliente ID, el secreto y el tenant id en los secretos de github.

![secretos github](/docs/tf3.png)
- Luego crear en el portar de azure lo siguiente para poder usar terraform como herramienta de IaC.
    - Un grupo de recursos
    - Una cuenta de almacenamiento
    - Un contenedor
- luego creamos una pipeline con una estado para crear nuestra infra orquestado desde github actions
    - [cicd.tf](.github/workflows/cicd.yml)
    - En el job llamado "deploy-infra" hacemos los siguiente. 
        - Nos autentificamos en azure via cli
        - instalamos terraform. 
        - configuramos todo. 
        - hacemos un terraform plan para crear una plan de despliegue
        - Aplicamos el plan en nuestra cuenta azure gratutia

![service principal](/docs/git1.png)
- con esto y el codigo de infra [main.tf](infrastructure/main.tf)
    - Creamos un grupo de recursos.
    - Un contenedor de registro
    - un cluster de kubernetes en azure.

![service principal](/docs/tf4.png)

## Con esto ya tenemos nuestros recursos para la demo de AKS_
## ACR
- Para esta demo, usamos un codigo de python que esta en la web de kubernetes con el link [https://kubernetes.io/blog/2019/07/23/get-started-with-kubernetes-using-python/](https://kubernetes.io/blog/2019/07/23/get-started-with-kubernetes-using-python/)
- Con este proyecto creamos la imagen en el job "push-image" del pipeline de [cicd.yml](.github/workflows/cicd.yml)
    - Para esto, primeno hacemos login en azure
    - luego creamos una imagen
    - le hacemos docker tag para luego subirla a nuestro contenedor de registro
    - para terminar, hacemos push a nuestro ACR

![ACR](/docs/acr1.png)

Ejecucion de push a ACR en actions de github.
![ACR2](/docs/acr2.png)
  
## AKS
Para deployar la imagen de flask en aks, desde github actions 
- seteamos AKS context.
- Definimos el grupo de recursos donde esta el cluster de kubernetes y su nombre.
- Luegos instalamos el kubectl
- con esta configuraciones previas mas nuestros [deployment.yaml](kubernetes/deployment.yaml)
Todo esto, orquestado desde github actions, en el job "deploy-aks" de [cicd.yml](.github/workflows/cicd.yml)

![AKS1](/docs/aks3.png)

## Resultados
- YML orquestado por github actions.

![ACR2](/docs/git2.png)

- Servicio en AKS

![ACR2](/docs/aks4.png)

- App en AKS

![ACR2](/docs/aks5.png)
