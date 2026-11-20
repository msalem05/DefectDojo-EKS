resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "region"
      value = "eu-west-2"
    },
    {
      name  = "vpcId"
      value = module.vpc.vpc_id
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    }
  ]

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"

  create_namespace = true

  set = [
    {
      name  = "crds.enabled"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "cert-manager"
    }
  ]

  depends_on = [
    module.eks,
    module.iam
  ]
}

resource "helm_release" "envoy_gateway" {
  name             = "envoy-gateway"
  repository       = "oci://docker.io/envoyproxy"
  chart            = "gateway-helm"
  namespace        = "envoy-gateway-system"
  create_namespace = true

  version = "1.6.1"

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true

  version = "2.15.0"

  set = [
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "external-secrets"
    },
    {
      name  = "installCRDs"
      value = "true"
    }
  ]

  depends_on = [
    module.eks,
    module.iam
  ]
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "argocd_bootstrap" {
  name      = "argocd-bootstrap"
  chart     = "${path.module}/../../k8s/bootstrap"
  namespace = "argocd"

  depends_on = [
    helm_release.argocd
  ]
}

resource "helm_release" "targetgroupbindings" {
  name      = "targetgroupbindings"
  chart     = "${path.module}/../../k8s/platform/targetgroupbindings"
  namespace = "envoy-gateway-system"

  values = [
    yamlencode({
      targetGroups = [
        {
          name        = "envoy-http-tgb"
          arn         = module.nlb.http_tg_arn
          serviceName = "envoy-proxy"
          servicePort = 80
          targetType  = "ip"
        },
        {
          name        = "envoy-https-tgb"
          arn         = module.nlb.https_tg_arn
          serviceName = "envoy-proxy"
          servicePort = 443
          targetType  = "ip"
        }
      ]
    })
  ]

  depends_on = [
    helm_release.aws_load_balancer_controller,
    helm_release.envoy_gateway
  ]
}