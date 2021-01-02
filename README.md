# Helm Boilerplate

This is a Helm boilerplate for a simple or complex project.
For easy use of Helm/Kubernetes, there are functions that allow simple configurations.
However, it is always possible to create more complex configurations.

Example project:

```txt
/
├── Chart.yaml
├── README.md
├── charts
│   ├── <subchart-1>
│   ├── ...
│   └── <subchart-n>
│       ├── Chart.yaml
│       ├── files
│       │   ├── <file-group-1>
│       │   │   ├── example-1.conf
│       │   │   └── example-1.conf
│       │   └── <file-group-2>
│       │       └── example.conf
│       ├── templates
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── ingress.yaml
│       │   ├── scale.yaml
│       │   └── service.yaml
│       └── values.yaml
├── files # all files in this folder are not committed
│   ├── <secret-file-group-1>
│   │   ├── example.pem
│   │   └── example.crt
│   └── <secret-file-group-2>
│       └── example.conf
├── secrets.yaml
├── templates
│   └── secret.yaml
├── values-<subchart-n>.yaml
└── values.yaml
```

In the files `run-\*.sh` and `secrets.sh` are example calls for an appropriate deployment

## Subcharts

Each subproject has its own subchart (under `/charts`), e.g. `frontend server`, `backend server` and a `microservice` is one subchart each.
So it is also possible that each subproject has its own deployment.

In the respective `charts/\*/values.yaml` the default configurations are stored.

For each deployment a separate `/values-\*.yaml` is created, where the configurations are adjusted if necessary.
The minimum configuration is that the respective subcharts are activated.

### ENV

There are different groups of ENV records:

- ENV variable in the context of a container
- ENV variable in the context of a subchart [shared by all containers].
- ENV variable in global context (in subcharts) [shared by all subcharts].

The first two points are defined in the `values.yaml` of the respective subchart and the last point in the `values.yaml` of the main chart.

In the container (in the `deployment.yaml`) you can then define which ENV data sets should be taken.

**Important**: Since this data is in the repo, it should not be critical data, such as credentials or access tokens.

### Files

It is very easy to store files (e.g. configuration files) for the deployment. In each subchart the files can be stored in the folder `files`.

The folder structure is fixed.
The files must be stored in a subfolder.

Example:

```txt
/charts
└── <subchart>
    └── files
        ├── cache
        │   ├── config1.conf
        │   └── config".conf
        └── nginx
            └── web.conf
```

Two `ConfigMaps` are created in this example, with the key `cache` (with the two configuration files) and `nginx` (with one configuration file).

**Important**: Since these files are in the repo, they should not be critical data, such as credentials or access tokens.

## Secrets

Certain configuration must not be committed to Repo, e.g. access data in the form of files or ENV variables.

For this case there is a special secret deployment, which holds the secrets for all other deployments.

### ENV-Secrets

This data is passed as an argument during deployment. The structure is equal to the global ENV variable groups, so not every container has all ENV variables.

### File-Secrets

The files with critical content can be copied to the `files` folder from the main chart before secret deployment.
The folder structure is identical to the `files` from the subcharts.

Example:

```txt
/files
└── certificate
    ├── example.pem
    └── example.crt
```

### Updating the containers

If the records or the files have been changed, all deployments must be updated.
To do this, the following command must be executed for each deployment so that the containers restart.

```bash
kubectl rollout restart deploy <deployment-name>
```

## Todo

- [ ] Using the [required](https://helm.sh/docs/howto/charts_tips_and_tricks/#using-the-required-function) function
- [ ] Tempalte handling in the values.yaml file
- [ ] Creation of a script for restarting the containers
