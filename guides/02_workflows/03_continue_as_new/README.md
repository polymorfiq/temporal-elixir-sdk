# Workflows - Workflow Basics Example

Example application for the [Workflow Basics Guide](/guides/02_workflows/01_workflow_basics.md)

## Usage

After following the guide and getting a local Temporal Server running:
```bash
$> mix start.workflow_with_children
```

### Interesting files

- You can see the worker defined in [TemporalGettingStarted.Application](lib/temporal_getting_started/application.ex)


- You can see the workflows defined in [TemporalGettingStarted.Workflows](lib/temporal_getting_started/workflows)


- You can see the workflows utilized in [Mix.Tasks](lib/mix/tasks)
