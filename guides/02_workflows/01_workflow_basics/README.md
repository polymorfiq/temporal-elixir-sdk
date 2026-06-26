# Workflows - Workflow Basics Example

Example application for the [Workflow Basics Guide](/guides/02_workflows/01_workflow_basics.md)

## Usage

After following the guide and getting a local Temporal Server running:
```bash
$> mix start.module_workflow 5 10
Workflow result: 5 x 10 = 50

$> mix start.module_workflow 5
Workflow result: 5 x 15 = 75

$> mix start.function_workflow 5
Workflow result: 5 x 30 = 150

$> mix start.function_workflow 5 20
Workflow result: 5 x 20 = 100
```

### Interesting files

- You can see the worker defined in [TemporalGettingStarted.Application](lib/temporal_getting_started/application.ex)


- You can see the workflows defined in [TemporalGettingStarted.Workflows](lib/temporal_getting_started/workflows)


- You can see the workflows utilized in [Mix.Tasks](lib/mix/tasks)
