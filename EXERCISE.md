# DevOps Engineers C1-C2 Exercise v3

## Implementation

- `azure-pipelines.yaml` - Pipeline implementation

## Testing

Rather than testing in the pipeline and submitting these logs, local options to build and verify:

### Option 1: PowerShell Script (Windows)

**Run:**

```powershell
.\run-pipeline-local.ps1
```

**With verbose output:**

```powershell
.\run-pipeline-local.ps1 -Verbose
```

**Capture logs to file:**

```powershell
.\run-pipeline-local.ps1 -Verbose | Tee-Object -FilePath "logs/pipeline-log-PS.txt"
```

---

### Option 2: Bash Script (macOS/Linux/WSL)

**Run:**

```bash
chmod +x run-pipeline-local.sh
./run-pipeline-local.sh
```

**With verbose output:**

```bash
./run-pipeline-local.sh -v
```

**Capture logs to file:**

```bash
./run-pipeline-local.sh -v | tee logs/pipeline-log-BASH.txt
```

---

### Option 3: Docker Container

**Build and run inline:**

```bash
docker build -t dotnet-pipeline-test . 2>&1 | tee logs/docker-build-log.txt
```

**Using Docker Compose:**

```bash
docker-compose up --build 2>&1 | tee logs/docker-compose-log.txt
```

**Run container and save output:**

```bash
docker run --rm dotnet-pipeline-test 2>&1 | tee docker-run-log.txt
```

---

## Getting Logs

### PowerShell

- **To console:** Run script normally, copy output from terminal
- **To file:** Add `| Tee-Object -FilePath "log.txt"` to any command
- **Example:** `.\run-pipeline-local.ps1 | Tee-Object -FilePath "pipeline-results.txt"`

### Bash/Linux

- **To console:** Run script normally, copy output from terminal
- **To file:** Add `| tee filename.txt` to any command
- **Example:** `./run-pipeline-local.sh | tee pipeline-results.txt`

### Docker

- **Capture build logs:** `docker build ... 2>&1 | tee docker-log.txt`
- **Capture runtime logs:** `docker run ... 2>&1 | tee docker-run-log.txt`
- **View logs after container exits:** `docker logs <container-id> > container-log.txt`

---

### GitHub CLI (gh) - Inspect Workflow Runs

**Prerequisites:**

- Install GitHub CLI: <https://cli.github.com/> or `winget install --id GitHub.cli`
- Authenticate: `gh auth login`

**List all workflow runs:**

```bash
gh run list --repo <OWNER>/<REPO>
gh run list --repo <OWNER>/<REPO> --branch main
```

**View logs from a specific run:**

```bash
# View run details and status
gh run view <RUN_ID>

# View full logs for a run
gh run view <RUN_ID> --log

# Save logs to file
gh run view <RUN_ID> --log > workflow-run-log.txt
```

**View logs for a specific job:**

```bash
# List jobs in a run
gh run view <RUN_ID> --json jobs

# View specific job logs
gh run view <RUN_ID> --log | grep "build-and-test"
```

**Monitor a run in real-time:**

```bash
# Watch a running workflow
gh run watch <RUN_ID>

# View latest run
gh run view --repo <OWNER>/<REPO>
```

**Download all logs as artifact:**

```bash
# Works if artifacts were uploaded during the workflow
gh run download <RUN_ID> --dir ./logs
```

**Example workflow:**

```bash
# 1. List recent runs
gh run list --repo YOUR_USERNAME/sample-unit-testing-using-dotnet-test --limit 5

# 2. Get the latest run ID
RUN_ID=$(gh run list --repo YOUR_USERNAME/sample-unit-testing-using-dotnet-test --limit 1 --json databaseId -q '.[0].databaseId')

# 3. View the logs
gh run view $RUN_ID --log

# 4. Save to file
gh run view $RUN_ID --log > github-workflow-run-$RUN_ID.txt
```

---

## File Artifacts Created

- `run-pipeline-local.ps1` - PowerShell script for Windows
- `run-pipeline-local.sh` - Bash script for Unix-like systems
- `Dockerfile` - Multi-stage Docker build (builder + runtime)
- `docker-compose.yml` - Docker Compose orchestration

Each option will:
✓ Restore NuGet dependencies
✓ Build solution in Release configuration
✓ Run unit tests
✓ Display colored progress and errors
✓ Exit with status code for CI/CD integration

### Log files created

- `pipeline-log-PS.txt`
- `pipeline-log-BASH.txt`
- `docker-log`
- `docker-compose-log.txt`
- `workflow-run-log.txt` - Github Actions log
