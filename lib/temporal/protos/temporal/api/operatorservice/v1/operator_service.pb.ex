defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.OperatorService.Service do
  @moduledoc false
  use GRPC.Service,
    name: "temporal.api.operatorservice.v1.OperatorService",
    protoc_gen_elixir_version: "0.16.0"

  rpc(
    :AddSearchAttributes,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.AddSearchAttributesRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.AddSearchAttributesResponse,
    %{}
  )

  rpc(
    :RemoveSearchAttributes,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.RemoveSearchAttributesRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.RemoveSearchAttributesResponse,
    %{}
  )

  rpc(
    :ListSearchAttributes,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.ListSearchAttributesResponse,
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
              pattern: {:get, "/api/v1/namespaces/{namespace}/search-attributes"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/cluster/namespaces/{namespace}/search-attributes"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DeleteNamespace,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.DeleteNamespaceRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.DeleteNamespaceResponse,
    %{}
  )

  rpc(
    :AddOrUpdateRemoteCluster,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.AddOrUpdateRemoteClusterRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.AddOrUpdateRemoteClusterResponse,
    %{}
  )

  rpc(
    :RemoveRemoteCluster,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.RemoveRemoteClusterRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.RemoveRemoteClusterResponse,
    %{}
  )

  rpc(
    :ListClusters,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.ListClustersRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.ListClustersResponse,
    %{}
  )

  rpc(
    :GetNexusEndpoint,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.GetNexusEndpointRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.GetNexusEndpointResponse,
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
              pattern: {:get, "/api/v1/nexus/endpoints/{id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/cluster/nexus/endpoints/{id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :CreateNexusEndpoint,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.CreateNexusEndpointRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.CreateNexusEndpointResponse,
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
              pattern: {:post, "/api/v1/nexus/endpoints"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/cluster/nexus/endpoints"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :UpdateNexusEndpoint,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.UpdateNexusEndpointRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.UpdateNexusEndpointResponse,
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
              pattern: {:post, "/api/v1/nexus/endpoints/{id}/update"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:post, "/cluster/nexus/endpoints/{id}/update"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :DeleteNexusEndpoint,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.DeleteNexusEndpointRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.DeleteNexusEndpointResponse,
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
              pattern: {:delete, "/api/v1/nexus/endpoints/{id}"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:delete, "/cluster/nexus/endpoints/{id}"},
          __unknown_fields__: []
        }
      }
    }
  )

  rpc(
    :ListNexusEndpoints,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.ListNexusEndpointsRequest,
    Temporal.Protos.Temporal.Api.Operatorservice.V1.ListNexusEndpointsResponse,
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
              pattern: {:get, "/api/v1/nexus/endpoints"},
              __unknown_fields__: []
            }
          ],
          response_body: "",
          pattern: {:get, "/cluster/nexus/endpoints"},
          __unknown_fields__: []
        }
      }
    }
  )
end

defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.OperatorService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Temporal.Protos.Temporal.Api.Operatorservice.V1.OperatorService.Service
end
