[GitOps Best Practices](https://medium.com/@cloudcomputingtechnologies/gitops-best-practices-2ef73b9b7def)

In 2017, GitOps was initially started as a method to do cluster management and app delivery for Kubernetes. It has since then been used for all cloud-native applications as well.
At its core, GitOps uses Git as the sole source of truth. It alerts the engineer on any discrepancies between Git and all that’s running in the cluster. In case of any differences, the reconcilers in Kubernetes are used to rollback the cluster or update automatically.