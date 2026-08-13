# store-analyzer

The Cactus AI store-analysis agent. Serves HTTP and WebSocket on port 7777, health at `/healthz`.

## Required values

| Value | Notes |
|---|---|
| `envVars.CACTUS_API_BASE` | In-cluster URL of the Cactus backend, e.g. `http://<backend-service>:8080` |
| `envVars.LLM_PROVIDER` | `google`, `anthropic`, `openai` or `openai-compatible` |
| `envVars.LLM_MODEL` | Model id the provider expects. Must be multimodal |
| `envVars.OPENAI_COMPATIBLE_BASE_URL` | `openai-compatible` only |
| `secrets` | Provider API key, as an env var. See `values.yaml` for the shape |

The provider key is read at request time, not at startup, so a missing or wrong
key leaves the pod healthy and fails the first request instead.

## Notes

- No ingress. The Service is `ClusterIP` and the agent expects to be reached
  from the Cactus backend only.
- Stateless. Working files go to an `emptyDir`; the root filesystem is read-only.
- Behaviour is baked into the image at build time, so changing it means a new
  image tag rather than a values change.
