Helm allows you to customize deployments by passing values to charts. You can do this using several methods:

1. Use a custom values.yaml file
Create or modify a values.yaml file to override default settings from the chart:


helm install my-app ./chart -f custom-values.yaml
Useful when managing multiple configuration values in a structured and reusable format.

2. Use the --set flag for inline values
For quick overrides, you can use the --set flag directly in the command:

helm install my-app ./chart --set image.tag=1.2.3
Best for simple, single-value overrides.

3. Combine both
You can combine a values file with inline settings. Inline values always override file-based values:


helm install my-app ./chart -f values.yaml --set replicaCount=3
4. Unpack and modify the chart directly (if needed)
If the chart doesn't expose a value you'd like to override, or you want to change templates directly, you can untar the chart:

5. helm pull my-chart --untar
cd my-chart
You can now modify the templates/ and values.yaml files as needed before installing.

helm list
Search for charts and versions:

helm search repo nginx --versions
