Technical Questions

Terraform

How would you manage Terraform state for a team of engineers?

To manage Terraform state collaboratively, I use remote state storage with a backend like AWS S3, combined with state locking using DynamoDB to prevent concurrent modifications. This setup allows multiple engineers to safely share and update infrastructure state. Access control can be enforced via IAM policies. Additionally, I enable versioning on the S3 bucket to allow rollback if needed.



What are modules, and why use them?

Modules are reusable, self-contained packages of Terraform configurations. They help organize infrastructure code by grouping related resources, improve code reuse, and simplify management by abstracting complexity. Using modules makes code DRY (Don’t Repeat Yourself), encourages best practices, and makes it easier to maintain and scale infrastructure.



How do you bring infrastructure deployed without Terraform under Terraform’s management?

This can be done using terraform import. First, write Terraform configuration files matching the existing infrastructure. Then use `terraform import` to map existing cloud resources into Terraform’s state file without recreating them. After importing, plan and apply changes carefully to avoid accidental resource replacement.



Kubernetes

How would you troubleshoot a pod that is stuck in CrashLoopBackOff?

- Check pod logs with `kubectl logs <pod> --previous` to see the reason for crash.
- Describe the pod `kubectl describe pod <pod>` to inspect events and container status.
- Verify resource limits to ensure the pod isn’t OOMKilled.
- Confirm the container image is correct and accessible.
- Check startup or liveness/readiness probes configuration.
- Review application configuration or environment variables for errors.



What’s the difference between Deployments, StatefulSets, and DaemonSets?

- Deployments manage stateless applications, providing declarative updates and replica management.
- StatefulSets manage stateful applications requiring stable, unique network IDs and persistent storage, e.g., databases.
- DaemonSets ensure a copy of a pod runs on all (or selected) nodes, useful for logging or monitoring agents.



How would you implement a rolling upgrade of a Kubernetes cluster without downtime?

Use a strategy of draining nodes one by one (`kubectl drain`) to gracefully evict pods, upgrading the Kubernetes version on that node, then bringing it back online (`kubectl uncordon`). Use PodDisruptionBudgets to maintain minimum available pods and configure readiness probes to prevent traffic routing to unhealthy pods. This ensures workload continuity throughout the upgrade.



Helm

How do you provide settings relevant to a specific deployment to Helm?

Pass customized configuration via the `values.yaml` file or directly on the command line using `--set` flags during `helm install` or `helm upgrade`. This allows you to override default chart values for environment-specific settings.


An application is deployed from an internal Helm chart. You need to add resource settings on a Kubernetes deployment’s pod template. There is no suitable setting in the values.yaml that comes with the chart. How do you add this setting to the chart?

You can either:

- Fork the Helm chart and add the resource settings to the deployment template with values referenced in `values.yaml`.
- Or use Helm’s `--set` with JSON patch or apply a Helm post-renderer or Kubernetes `kubectl patch` as a separate step.
- Alternatively, if supported, use Helm chart hooks or overlays (with tools like Kustomize combined with Helm).



 Ansible

What are the advantages of using roles?

Roles provide modularity and reusability by grouping related tasks, variables, files, and templates. They make playbooks easier to read, maintain, and share. Roles also promote best practices by organizing code in a standardized structure.

How would you ensure that a service gets restarted if a playbook edits its config file, but not otherwise?

Use handlers in Ansible. When a config file task makes a change, it notifies a handler that restarts the service. If no change occurs, the handler is not triggered, avoiding unnecessary restarts.



 DevOps Practices

How do you handle secrets in CI/CD pipelines?

Use dedicated secret management tools like HashiCorp Vault, AWS Secrets Manager, or encrypted variables in the CI/CD system. Avoid hardcoding secrets in code or configs. Inject secrets dynamically during runtime and ensure audit logging and fine-grained access control.



What tools and strategies do you use to monitor a production Kubernetes cluster?

- Use Prometheus for metrics collection, Grafana for visualization.
- ELK stack (Elasticsearch, Logstash, Kibana) or EFK (Fluentd) for centralized logging.
- Kube-state-metrics and node-exporter for cluster health.
- Implement alerts with Alertmanager.
- Use Kubernetes liveness/readiness probes and PodDisruptionBudgets to maintain reliability.
- Tools like Kubernetes Dashboard, Lens, or commercial platforms like Datadog, New Relic for comprehensive monitoring.
