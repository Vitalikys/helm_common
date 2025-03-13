# Common Helm Chart Template for Kubernetes



## Getting started

```shell
helm repo add public-vit https://vitalikys.github.io/helm_common/
```

```shell
helm search repo public-vit

NAME                            CHART VERSION   APP VERSION     DESCRIPTION                              
public-vit/common-service       1.0.0           1.16.0          Common Template Helm chart for Kubernetes

```

## How to Create a New Version of a Helm Chart

- Create a Separate Branch
- Make Changes to Templates
  - Modify or add the necessary templates in the templates/ directory.
- Update Chart.yaml
  - Increment the appVersion and/or version in `Chart.yaml` to reflect the new release.
- Regenerate the Helm Chart Index
    ```shell
       helm repo index .
    ```
- Create new PR

