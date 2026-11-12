# Publishing as tickwarden/modalith

## Status

This source tree is prepared for the proposed repository **`tickwarden/modalith`**. It has not been pushed, and no GitHub repository, tag, or release is claimed to exist. Repository-name availability and account permissions have not been checked. Choose another repository name if necessary and update these instructions.

The installable datapack ZIP is separate from the source archive. Do not upload the source archive directly as a datapack: it contains contributor/test files and may have a top-level folder.

## Before publication

- Review the MIT license and attribution; the project is not affiliated with Mojang/Microsoft.
- Run the static checks, unit tests, and local vanilla integration procedure.
- Check `VERSION`, `mdl/pack.mcmeta`, changelog, and release notes agree.
- Inspect `git diff` and ensure no world, credentials, server binary, downloaded JRE, logs, or `.env` files are tracked.
- Review repository visibility. The example below creates a **public** repository; change `--public` to `--private` if you want a private staging repository.
- Set your own Git commit identity. Do not paste authentication tokens into files or commands stored in shell scripts.

## Create a new repository

Install Git and GitHub CLI, then run these commands **inside the extracted Modalith source directory**:

```bash
python tools/lint.py
python -m unittest discover -s tests/unit -v
python tools/build.py

gh auth login
# Confirm that the authenticated account is tickwarden before proceeding:
gh api user --jq .login

# Initialize only if the downloaded source tree has no Git history:
git init -b main
# Configure your own identity if Git has not been configured already:
# git config user.name "YOUR NAME"
# git config user.email "YOUR VERIFIED OR NOREPLY EMAIL"
git add .
git diff --cached --stat
git commit -m "Release Modalith 2.1.0"

# This command publishes the repository publicly when you choose to run it:
gh repo create tickwarden/modalith --public --source=. --remote=origin --push \
  --description "Macro-native Minecraft Java 1.21.6 dialog library with runtime templates and validated callbacks"
```

If the directory is already a Git repository, skip `git init`. If `origin` exists, inspect it before reusing it. Do not force-push to an existing repository. For an existing `tickwarden/modalith`, clone it separately and apply this source tree as a reviewed commit/PR instead.

## Publish the release

After the `main` branch passes the **Validate and package** workflow, push the matching version tag:

```bash
git tag -a v2.1.0 -m "Modalith 2.1.0"
git push origin v2.1.0
```

The release workflow verifies the tag equals `v` + `VERSION`, runs static/unit checks, builds the datapack, and creates a GitHub release with the ZIP and `SHA256SUMS` attached. It uses the repository-scoped `GITHUB_TOKEN`, not a personal token. Repository settings must allow Actions to write release contents. Workflow execution on GitHub itself has not been tested before the repository exists.

Do not also create the same release manually unless you intentionally skip/disable the workflow. The workflow deliberately fails if a conflicting release already exists.

## Recommended repository settings

- Default branch: `main`.
- About topics: `minecraft`, `datapack`, `minecraft-java`, `dialogs`, `mcfunction`, `library`.
- Enable Issues and private vulnerability reporting before advertising them.
- Consider protecting `main` with review and the static validation job once it has run.
- Keep Actions permissions restricted and review third-party action updates; the supplied workflows use official GitHub actions by major version tags.
- Do not advertise CI or release URLs as passing/existing until they have actually run.

## Future releases

Update `VERSION`, pack description/load message, changelog, and release notes together. Run local integration tests again after runtime changes, commit, wait for CI, then push a matching `vX.Y.Z` tag. Packaging is deterministic for identical source bytes within the same Python/zlib toolchain; checksums identify the exact published archive.

The core source root is `mdl/`; the optional demo source root is `mdl_demo/`. Build from the repository root with `python tools/build.py`; publish both ZIPs and their SHA256SUMS. Each ZIP has pack.mcmeta at its root, not an extra source directory.
