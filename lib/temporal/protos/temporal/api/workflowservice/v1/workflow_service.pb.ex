defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.WorkflowService.Service do
  @moduledoc false
  use GRPC.Service,
    name: "temporal.api.workflowservice.v1.WorkflowService",
    protoc_gen_elixir_version: "0.16.0"

  rpc(
    :RegisterNamespace,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RegisterNamespaceRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RegisterNamespaceResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/cluster/namespaces"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeNamespace,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNamespaceRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNamespaceResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/cluster/namespaces/{namespace}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListNamespaces,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListNamespacesRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListNamespacesResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/cluster/namespaces"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateNamespace,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateNamespaceRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateNamespaceResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/update"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/cluster/namespaces/{namespace}/update"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DeprecateNamespace,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeprecateNamespaceRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeprecateNamespaceResponse,
    %{}
  )

  rpc(
    :StartWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.StartWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.StartWorkflowExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/workflows/{workflow_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/workflows/{workflow_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ExecuteMultiOperation,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationResponse,
    %{}
  )

  rpc(
    :GetWorkflowExecutionHistory,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkflowExecutionHistoryRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkflowExecutionHistoryResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get, "/api/v1/namespaces/{namespace}/workflows/{execution.workflow_id}/history"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/workflows/{execution.workflow_id}/history"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :GetWorkflowExecutionHistoryReverse,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkflowExecutionHistoryReverseRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkflowExecutionHistoryReverseResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get,
                 "/api/v1/namespaces/{namespace}/workflows/{execution.workflow_id}/history-reverse"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:get, "/namespaces/{namespace}/workflows/{execution.workflow_id}/history-reverse"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :PollWorkflowTaskQueue,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse,
    %{}
  )

  rpc(
    :RespondWorkflowTaskCompleted,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedResponse,
    %{}
  )

  rpc(
    :RespondWorkflowTaskFailed,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskFailedRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskFailedResponse,
    %{}
  )

  rpc(
    :PollActivityTaskQueue,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityTaskQueueRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityTaskQueueResponse,
    %{}
  )

  rpc(
    :RecordActivityTaskHeartbeat,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordActivityTaskHeartbeatRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordActivityTaskHeartbeatResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activity-heartbeat"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activity-heartbeat"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RecordActivityTaskHeartbeatById,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordActivityTaskHeartbeatByIdRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordActivityTaskHeartbeatByIdResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post, "/api/v1/namespaces/{namespace}/activities/{activity_id}/heartbeat"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/heartbeat"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/heartbeat"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities/{activity_id}/heartbeat"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RespondActivityTaskCompleted,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCompletedRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCompletedResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activity-complete"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activity-complete"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RespondActivityTaskCompletedById,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCompletedByIdRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCompletedByIdResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post, "/api/v1/namespaces/{namespace}/activities/{activity_id}/complete"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/complete"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/complete"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities/{activity_id}/complete"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RespondActivityTaskFailed,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskFailedRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskFailedResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activity-fail"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activity-fail"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RespondActivityTaskFailedById,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskFailedByIdRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskFailedByIdResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activities/{activity_id}/fail"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/fail"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/fail"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities/{activity_id}/fail"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RespondActivityTaskCanceled,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCanceledRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCanceledResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activity-resolve-as-canceled"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activity-resolve-as-canceled"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RespondActivityTaskCanceledById,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCanceledByIdRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCanceledByIdResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/activities/{activity_id}/resolve-as-canceled"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/resolve-as-canceled"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/resolve-as-canceled"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post, "/namespaces/{namespace}/activities/{activity_id}/resolve-as-canceled"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RequestCancelWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RequestCancelWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RequestCancelWorkflowExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/cancel"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post, "/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/cancel"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :SignalWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SignalWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SignalWorkflowExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/signal/{signal_name}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/signal/{signal_name}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :SignalWithStartWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SignalWithStartWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SignalWithStartWorkflowExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/signal-with-start/{signal_name}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/workflows/{workflow_id}/signal-with-start/{signal_name}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ResetWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetWorkflowExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/reset"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post, "/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/reset"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :TerminateWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.TerminateWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.TerminateWorkflowExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/terminate"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/terminate"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DeleteWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkflowExecutionResponse,
    %{}
  )

  rpc(
    :ListOpenWorkflowExecutions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListOpenWorkflowExecutionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListOpenWorkflowExecutionsResponse,
    %{}
  )

  rpc(
    :ListClosedWorkflowExecutions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListClosedWorkflowExecutionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListClosedWorkflowExecutionsResponse,
    %{}
  )

  rpc(
    :ListWorkflowExecutions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkflowExecutionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkflowExecutionsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/workflows"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/workflows"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListArchivedWorkflowExecutions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListArchivedWorkflowExecutionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListArchivedWorkflowExecutionsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/archived-workflows"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/archived-workflows"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ScanWorkflowExecutions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ScanWorkflowExecutionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ScanWorkflowExecutionsResponse,
    %{}
  )

  rpc(
    :CountWorkflowExecutions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CountWorkflowExecutionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CountWorkflowExecutionsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/workflow-count"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/workflow-count"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :GetSearchAttributes,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSearchAttributesRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSearchAttributesResponse,
    %{}
  )

  rpc(
    :RespondQueryTaskCompleted,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondQueryTaskCompletedRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondQueryTaskCompletedResponse,
    %{}
  )

  rpc(
    :ResetStickyTaskQueue,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetStickyTaskQueueRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetStickyTaskQueueResponse,
    %{}
  )

  rpc(
    :ShutdownWorker,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ShutdownWorkerRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ShutdownWorkerResponse,
    %{}
  )

  rpc(
    :QueryWorkflow,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.QueryWorkflowRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.QueryWorkflowResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{execution.workflow_id}/query/{query.query_type}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/workflows/{execution.workflow_id}/query/{query.query_type}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkflowExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/workflows/{execution.workflow_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/workflows/{execution.workflow_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeTaskQueue,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/task-queues/{task_queue.name}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/task-queues/{task_queue.name}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :GetClusterInfo,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetClusterInfoRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetClusterInfoResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/cluster-info"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/cluster"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :GetSystemInfo,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSystemInfoRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSystemInfoResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/system-info"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/system-info"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListTaskQueuePartitions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListTaskQueuePartitionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListTaskQueuePartitionsResponse,
    %{}
  )

  rpc(
    :CreateSchedule,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateScheduleRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateScheduleResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/schedules/{schedule_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/schedules/{schedule_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeSchedule,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeScheduleRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeScheduleResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/schedules/{schedule_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/schedules/{schedule_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateSchedule,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateScheduleRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateScheduleResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/schedules/{schedule_id}/update"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/schedules/{schedule_id}/update"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :PatchSchedule,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PatchScheduleRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PatchScheduleResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/schedules/{schedule_id}/patch"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/schedules/{schedule_id}/patch"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListScheduleMatchingTimes,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListScheduleMatchingTimesRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListScheduleMatchingTimesResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get, "/api/v1/namespaces/{namespace}/schedules/{schedule_id}/matching-times"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/schedules/{schedule_id}/matching-times"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DeleteSchedule,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteScheduleRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteScheduleResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:delete, "/api/v1/namespaces/{namespace}/schedules/{schedule_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:delete, "/namespaces/{namespace}/schedules/{schedule_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListSchedules,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListSchedulesRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListSchedulesResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/schedules"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/schedules"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :CountSchedules,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CountSchedulesRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CountSchedulesResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/schedule-count"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/schedule-count"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateWorkerBuildIdCompatibility,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerBuildIdCompatibilityResponse,
    %{}
  )

  rpc(
    :GetWorkerBuildIdCompatibility,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerBuildIdCompatibilityRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerBuildIdCompatibilityResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get,
                 "/api/v1/namespaces/{namespace}/task-queues/{task_queue}/worker-build-id-compatibility"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:get,
             "/namespaces/{namespace}/task-queues/{task_queue}/worker-build-id-compatibility"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateWorkerVersioningRules,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesResponse,
    %{}
  )

  rpc(
    :GetWorkerVersioningRules,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerVersioningRulesRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerVersioningRulesResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get,
                 "/api/v1/namespaces/{namespace}/task-queues/{task_queue}/worker-versioning-rules"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:get, "/namespaces/{namespace}/task-queues/{task_queue}/worker-versioning-rules"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :GetWorkerTaskReachability,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerTaskReachabilityRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerTaskReachabilityResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/worker-task-reachability"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/worker-task-reachability"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeDeployment,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeDeploymentRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeDeploymentResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get,
                 "/api/v1/namespaces/{namespace}/deployments/{deployment.series_name}/{deployment.build_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:get,
             "/namespaces/{namespace}/deployments/{deployment.series_name}/{deployment.build_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeWorkerDeploymentVersion,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get,
                 "/api/v1/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}/{deployment_version.build_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:get,
             "/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}/{deployment_version.build_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListDeployments,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListDeploymentsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListDeploymentsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/deployments"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/deployments"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :GetDeploymentReachability,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetDeploymentReachabilityRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetDeploymentReachabilityResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get,
                 "/api/v1/namespaces/{namespace}/deployments/{deployment.series_name}/{deployment.build_id}/reachability"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:get,
             "/namespaces/{namespace}/deployments/{deployment.series_name}/{deployment.build_id}/reachability"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :GetCurrentDeployment,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetCurrentDeploymentRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.GetCurrentDeploymentResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/current-deployment/{series_name}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/current-deployment/{series_name}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :SetCurrentDeployment,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SetCurrentDeploymentRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SetCurrentDeploymentResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/current-deployment/{deployment.series_name}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/current-deployment/{deployment.series_name}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :SetWorkerDeploymentCurrentVersion,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentCurrentVersionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentCurrentVersionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/worker-deployments/{deployment_name}/set-current-version"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/worker-deployments/{deployment_name}/set-current-version"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeWorkerDeployment,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get, "/api/v1/namespaces/{namespace}/worker-deployments/{deployment_name}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/worker-deployments/{deployment_name}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DeleteWorkerDeployment,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkerDeploymentRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkerDeploymentResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:delete, "/api/v1/namespaces/{namespace}/worker-deployments/{deployment_name}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:delete, "/namespaces/{namespace}/worker-deployments/{deployment_name}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DeleteWorkerDeploymentVersion,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkerDeploymentVersionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkerDeploymentVersionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:delete,
                 "/api/v1/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}/{deployment_version.build_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:delete,
             "/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}/{deployment_version.build_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :SetWorkerDeploymentRampingVersion,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentRampingVersionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentRampingVersionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/worker-deployments/{deployment_name}/set-ramping-version"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/worker-deployments/{deployment_name}/set-ramping-version"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListWorkerDeployments,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkerDeploymentsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkerDeploymentsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/worker-deployments"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/worker-deployments"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :CreateWorkerDeployment,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkerDeploymentRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkerDeploymentResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post, "/api/v1/namespaces/{namespace}/worker-deployments/{deployment_name}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/worker-deployments/{deployment_name}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :CreateWorkerDeploymentVersion,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkerDeploymentVersionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkerDeploymentVersionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateWorkerDeploymentVersionComputeConfig,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionComputeConfigRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionComputeConfigResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}/{deployment_version.build_id}/update-compute-config"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}/{deployment_version.build_id}/update-compute-config"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ValidateWorkerDeploymentVersionComputeConfig,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ValidateWorkerDeploymentVersionComputeConfigRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ValidateWorkerDeploymentVersionComputeConfigResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}/{deployment_version.build_id}/validate-compute-config"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}/{deployment_version.build_id}/validate-compute-config"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateWorkerDeploymentVersionMetadata,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionMetadataRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionMetadataResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}/{deployment_version.build_id}/update-metadata"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/worker-deployment-versions/{deployment_version.deployment_name}/{deployment_version.build_id}/update-metadata"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :SetWorkerDeploymentManager,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentManagerRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentManagerResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/worker-deployments/{deployment_name}/set-manager"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post, "/namespaces/{namespace}/worker-deployments/{deployment_name}/set-manager"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/update/{request.input.name}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/update/{request.input.name}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :PollWorkflowExecutionUpdate,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowExecutionUpdateRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowExecutionUpdateResponse,
    %{}
  )

  rpc(
    :StartBatchOperation,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.StartBatchOperationRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.StartBatchOperationResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/batch-operations/{job_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/batch-operations/{job_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :StopBatchOperation,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.StopBatchOperationRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.StopBatchOperationResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/batch-operations/{job_id}/stop"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/batch-operations/{job_id}/stop"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeBatchOperation,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeBatchOperationRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeBatchOperationResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/batch-operations/{job_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/batch-operations/{job_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListBatchOperations,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListBatchOperationsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListBatchOperationsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/batch-operations"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/batch-operations"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :PollNexusTaskQueue,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusTaskQueueRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusTaskQueueResponse,
    %{}
  )

  rpc(
    :RespondNexusTaskCompleted,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondNexusTaskCompletedRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondNexusTaskCompletedResponse,
    %{}
  )

  rpc(
    :RespondNexusTaskFailed,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondNexusTaskFailedRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondNexusTaskFailedResponse,
    %{}
  )

  rpc(
    :UpdateActivityOptions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateActivityOptionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateActivityOptionsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post, "/api/v1/namespaces/{namespace}/activities-deprecated/update-options"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities-deprecated/update-options"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateWorkflowExecutionOptions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionOptionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionOptionsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/update-options"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post,
             "/namespaces/{namespace}/workflows/{workflow_execution.workflow_id}/update-options"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :PauseActivity,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseActivityRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseActivityResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activities-deprecated/pause"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities-deprecated/pause"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UnpauseActivity,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseActivityRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseActivityResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activities-deprecated/unpause"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities-deprecated/unpause"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ResetActivity,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetActivityRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetActivityResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activities-deprecated/reset"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities-deprecated/reset"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :CreateWorkflowRule,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkflowRuleRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkflowRuleResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/workflow-rules"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/workflow-rules"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeWorkflowRule,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkflowRuleRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkflowRuleResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/workflow-rules/{rule_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/workflow-rules/{rule_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DeleteWorkflowRule,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkflowRuleRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteWorkflowRuleResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:delete, "/api/v1/namespaces/{namespace}/workflow-rules/{rule_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:delete, "/namespaces/{namespace}/workflow-rules/{rule_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListWorkflowRules,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkflowRulesRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkflowRulesResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/workflow-rules"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/workflow-rules"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :TriggerWorkflowRule,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.TriggerWorkflowRuleRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.TriggerWorkflowRuleResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{execution.workflow_id}/trigger-rule"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern:
            {:post, "/namespaces/{namespace}/workflows/{execution.workflow_id}/trigger-rule"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RecordWorkerHeartbeat,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordWorkerHeartbeatRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordWorkerHeartbeatResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/workers/heartbeat"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/workers/heartbeat"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListWorkers,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkersRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkersResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/workers"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/workers"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateTaskQueueConfig,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post, "/api/v1/namespaces/{namespace}/task-queues/{task_queue}/update-config"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/task-queues/{task_queue}/update-config"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :FetchWorkerConfig,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.FetchWorkerConfigRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.FetchWorkerConfigResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/workers/fetch-config"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/workers/fetch-config"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateWorkerConfig,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerConfigRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerConfigResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/workers/update-config"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/workers/update-config"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeWorker,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get, "/api/v1/namespaces/{namespace}/workers/describe/{worker_instance_key}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/workers/describe/{worker_instance_key}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :PauseWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseWorkflowExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/pause"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/workflows/{workflow_id}/pause"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UnpauseWorkflowExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseWorkflowExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseWorkflowExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/unpause"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/workflows/{workflow_id}/unpause"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :StartActivityExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.StartActivityExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.StartActivityExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activities/{activity_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities/{activity_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :StartNexusOperationExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.StartNexusOperationExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.StartNexusOperationExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/nexus-operations/{operation_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/nexus-operations/{operation_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeActivityExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeActivityExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeActivityExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/activities/{activity_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/activities/{activity_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DescribeNexusOperationExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNexusOperationExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNexusOperationExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/nexus-operations/{operation_id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/nexus-operations/{operation_id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :PollActivityExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/activities/{activity_id}/outcome"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/activities/{activity_id}/outcome"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :PollNexusOperationExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusOperationExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusOperationExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:get, "/api/v1/namespaces/{namespace}/nexus-operations/{operation_id}/poll"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/nexus-operations/{operation_id}/poll"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListActivityExecutions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListActivityExecutionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListActivityExecutionsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/activities"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/activities"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListNexusOperationExecutions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListNexusOperationExecutionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ListNexusOperationExecutionsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/nexus-operations"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/nexus-operations"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :CountActivityExecutions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CountActivityExecutionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CountActivityExecutionsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/activity-count"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/activity-count"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :CountNexusOperationExecutions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CountNexusOperationExecutionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.CountNexusOperationExecutionsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "",
              additional_bindings: [],
              response_body: "",
              pattern: {:get, "/api/v1/namespaces/{namespace}/nexus-operation-count"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/namespaces/{namespace}/nexus-operation-count"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RequestCancelActivityExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RequestCancelActivityExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RequestCancelActivityExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activities/{activity_id}/cancel"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities/{activity_id}/cancel"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :RequestCancelNexusOperationExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RequestCancelNexusOperationExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.RequestCancelNexusOperationExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post, "/api/v1/namespaces/{namespace}/nexus-operations/{operation_id}/cancel"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/nexus-operations/{operation_id}/cancel"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :TerminateActivityExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.TerminateActivityExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.TerminateActivityExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post, "/api/v1/namespaces/{namespace}/activities/{activity_id}/terminate"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities/{activity_id}/terminate"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DeleteActivityExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteActivityExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteActivityExecutionResponse,
    %{}
  )

  rpc(
    :PauseActivityExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseActivityExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseActivityExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activities/{activity_id}/pause"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/pause"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/pause"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities/{activity_id}/pause"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ResetActivityExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetActivityExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetActivityExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activities/{activity_id}/reset"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/reset"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/reset"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities/{activity_id}/reset"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UnpauseActivityExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseActivityExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseActivityExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern: {:post, "/api/v1/namespaces/{namespace}/activities/{activity_id}/unpause"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/unpause"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/unpause"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities/{activity_id}/unpause"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateActivityExecutionOptions,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateActivityExecutionOptionsRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateActivityExecutionOptionsResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post, "/api/v1/namespaces/{namespace}/activities/{activity_id}/update-options"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/update-options"},
              __unknown_fields__: []
            },
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/workflows/{workflow_id}/activities/{activity_id}/update-options"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/activities/{activity_id}/update-options"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :TerminateNexusOperationExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.TerminateNexusOperationExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.TerminateNexusOperationExecutionResponse,
    %{
      http: %{
        type: Google.Api.PbExtension,
        value: %Google.Api.HttpRule{
          selector: "",
          body: "*",
          additional_bindings: [
            %Google.Api.HttpRule{
              selector: "",
              body: "*",
              additional_bindings: [],
              response_body: "",
              pattern:
                {:post,
                 "/api/v1/namespaces/{namespace}/nexus-operations/{operation_id}/terminate"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/namespaces/{namespace}/nexus-operations/{operation_id}/terminate"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DeleteNexusOperationExecution,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteNexusOperationExecutionRequest,
    Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteNexusOperationExecutionResponse,
    %{}
  )
end

defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.WorkflowService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Temporal.Protos.Temporal.Api.Workflowservice.V1.WorkflowService.Service
end
