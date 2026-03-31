# OCI Llama Stack Notes

Reference notes for the OCI-hosted Llama Stack endpoint used during NemoClaw/OpenShell testing.

## Endpoint

- Docs: `https://llama-stack.ai-apps-ord.oci-incubations.com/docs`
- API base URL: `https://llama-stack.ai-apps-ord.oci-incubations.com/v1`

## Integration Notes

- Treat this as an OpenAI-compatible endpoint, not as `ollama-local`.
- `GET /v1/models` is reachable without auth.
- `POST /v1/chat/completions` worked without an auth header for `oci/openai.gpt-5.2`.
- The shorter model form `openai/gpt-5.2` did not work. Use the full OCI-prefixed model ID, for example `oci/openai.gpt-5.2`.
- OpenShell verification failed for `oci/openai.gpt-5.2` because the endpoint rejected the `max_tokens` parameter during provider validation. The inference route was set successfully with `--no-verify`.

## GPT-Family Models Seen

- `oci/openai.gpt-4.1`
- `oci/openai.gpt-4.1-2025-04-14`
- `oci/openai.gpt-4.1-mini`
- `oci/openai.gpt-4.1-mini-2025-04-14`
- `oci/openai.gpt-4.1-nano`
- `oci/openai.gpt-4.1-nano-2025-04-14`
- `oci/openai.gpt-4o`
- `oci/openai.gpt-4o-2024-08-06`
- `oci/openai.gpt-4o-2024-11-20`
- `oci/openai.gpt-4o-mini`
- `oci/openai.gpt-4o-mini-2024-07-18`
- `oci/openai.gpt-4o-mini-search-preview`
- `oci/openai.gpt-4o-mini-search-preview-2025-03-11`
- `oci/openai.gpt-4o-search-preview`
- `oci/openai.gpt-4o-search-preview-2025-03-11`
- `oci/openai.gpt-5`
- `oci/openai.gpt-5-2025-08-07`
- `oci/openai.gpt-5-codex`
- `oci/openai.gpt-5-mini`
- `oci/openai.gpt-5-mini-2025-08-07`
- `oci/openai.gpt-5-nano`
- `oci/openai.gpt-5-nano-2025-08-07`
- `oci/openai.gpt-5.1`
- `oci/openai.gpt-5.1-2025-11-13`
- `oci/openai.gpt-5.1-chat-latest`
- `oci/openai.gpt-5.1-codex`
- `oci/openai.gpt-5.1-codex-max`
- `oci/openai.gpt-5.1-codex-mini`
- `oci/openai.gpt-5.2`
- `oci/openai.gpt-5.2-2025-12-11`
- `oci/openai.gpt-5.2-chat-latest`
- `oci/openai.gpt-5.2-pro`
- `oci/openai.gpt-5.2-pro-2025-12-11`
- `oci/openai.gpt-audio`
- `oci/openai.gpt-image-1`
- `oci/openai.gpt-image-1.5`
- `oci/openai.gpt-oss-120b`
- `oci/openai.gpt-oss-20b`

## Current OpenShell Test State

- OCI host provider name: `nvidia-nim`
- Current inference model used during testing: `oci/openai.gpt-5.2`
