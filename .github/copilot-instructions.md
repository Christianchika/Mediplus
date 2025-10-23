# Copilot / AI agent instructions — Mediplus

This repository is a static HTML theme (Mediplus) with assets and a minimal PHP mail endpoint and optional Terraform infra. The notes below highlight the concrete, discoverable patterns and safe editing rules an AI agent should follow to be productive immediately.

- Project layout (important files/dirs):
  - `index.html`, `*.html` — primary pages. Edit HTML here for content changes.
  - `css/`, `js/`, `img/`, `fonts/` — static assets. `style.css` is the primary theme stylesheet; plugin CSS is under `css/`.
  - `js/main.js` — central JS behavior (sticky header, sliders, forms). Prefer small, focused edits here for UI behavior.
  - `mail/mail.php` — server-side mail handler used by contact/newsletter forms (see forms in `index.html`). Be cautious: this file uses PHP mail() and a hardcoded recipient.
  - `Dockerfile` — simple nginx image that copies site into `/usr/share/nginx/html` for serving.
  - `infra/` — Terraform config (`main.tf`, `variables.tf`, `outputs.tf`) that can provision an EC2 instance and security group.

- Big picture & why:
  - This is a multi-page, static HTML theme intended to be served by a static server (nginx). JS plugins under `js/` provide client-side features. The PHP endpoint is a minimal convenience for contact forms; production deployments often replace this with a proper API or SMTP-backed handler.
  - Terraform scripts offer a simple, opinionated way to place the static site on an EC2 instance; the Terraform defaults include a Windows-style SSH key path which must be adapted per operator.

- Developer workflows (concrete commands)
  - Quick local preview (static files): open `index.html` in a browser or serve via a static server.
  - Build & run with Docker (recommended to reproduce production nginx behavior):
    ```powershell
    docker build -t mediplus .
    docker run --rm -p 80:80 mediplus
    ```
  - Terraform (infra) quick steps — update `infra/variables.tf` before running, especially the SSH public key path:
    ```powershell
    cd infra
    terraform init
    terraform apply
    ```
    Note: `main.tf` currently references a Windows path `C:/Users/user/.ssh/id_rsa.pub` — change to a valid path or variable before apply.
  - Testing `mail/mail.php` locally: PHP's built-in server can serve the repo, but `mail()` may not send on a dev machine. Use a stubbed endpoint or PHPMailer with SMTP for reliable testing.
    ```powershell
    php -S localhost:8000
    # Then open http://localhost:8000/index.html and submit forms
    ```

- Project-specific conventions & gotchas
  - Forms: some contact/newsletter forms submit using `GET` and `target="_blank"` (newsletter), while `mail/mail.php` expects `POST` — check the form method before editing or wiring server code. Example: newsletter form in `index.html` uses `method="get"` and action `mail/mail.php`.
  - `mail/mail.php` contains fragile code patterns (non-standard `$_POST{'name'}` syntax, hardcoded recipient). Avoid changing it without adding tests or a local verification plan.
  - Preserve relative paths for assets (e.g., `css/style.css`, `js/main.js`) — many templates assume flat publishing under web root.
  - The theme includes many third-party JS plugins (owl-carousel, slicknav, magnific-popup). When upgrading plugins, update both the JS and any dependent CSS and HTML markup patterns.

- Integration points & cross-component notes
  - Contact flows: HTML form -> `mail/mail.php`. If migrating to an API, keep the same field names (`name`, `email`, `phone`, `subject`, `message`) to avoid breaking forms.
  - Deployment: Dockerfile (nginx) is the canonical container. Terraform places an EC2 instance but does not automate deploying the built container; infra is focused on VM provisioning.

- Guidance for AI agents editing this repo
  - Small, focused PRs: change a single page or one JS behavior per PR. Keep diffs minimal and preserve file references.
  - When touching `mail/mail.php`: add a local test plan (how to run PHP server) and prefer adding a configuration step (e.g., change hardcoded recipient into a variable) rather than deleting functionality.
  - When suggesting Terraform edits: do not assume a key path — reference `infra/variables.tf` and add a variable or documentation note instructing the human operator to supply their public key path.
  - Add unit/integration tests only when introducing runtime logic (e.g., a new Node/PHP service). For pure HTML/CSS changes, rely on visual/manual checks and include a short test checklist in the PR description.

If anything above is unclear or you want the agent to include automated checks (linting, CI, or a simple smoke test), tell me which area to expand and I will iterate on this guidance.
