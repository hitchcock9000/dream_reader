# Security and environment management

## Secrets
- Never commit `/home/runner/work/dream_reader/dream_reader/.env`.
- Use `/home/runner/work/dream_reader/dream_reader/.env.example` as the local template.
- Prefer GitHub Actions secrets or deployment platform secrets for CI and production.

## Required configuration
- `GEMINI_API_KEY`: required for dream interpretation.
- `OPENAI_API_KEY`: optional. If omitted, image generation falls back to Pollinations.

## Configuration options
The app supports two configuration paths:
1. Local `.env` file for development.
2. `--dart-define` values for CI, web builds, or platform deployment pipelines.

## Failure modes
- Missing `GEMINI_API_KEY` blocks dream analysis and should surface a user-friendly configuration error.
- Missing `OPENAI_API_KEY` should not block the app; image generation falls back to the non-authenticated provider.
- Invalid model responses should be treated as parse failures and logged with enough context for debugging, without exposing secrets.

## Recommended production hardening
- Add request/session analytics for provider error rates.
- Add redaction rules before logging model responses.
- Add abuse controls and moderation if this becomes a public consumer product.
