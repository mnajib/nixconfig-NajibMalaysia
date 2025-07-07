# Git Branch Workflow for MyProject

This document outlines the Git workflow for managing branches across multiple repositories and hosts.

## Hosts Involved
1. **Local Development Host (mylocalhost)**:
   - Work directory: `~/src/myproject/`
   - Internal repos:
     - Internal bare repo (share/backup): `~/GitReposPre/myproject.git/`
     - Staging bare repo: `~/GitRepos/myproject.git/`

2. **Remote Collaboration Host (myremotehost)**:
   - Shared bare repo: `~/GitRepos/myproject.git/`

## Branches Overview
1. **Development Branches**:
   - **alpha** and **beta**:
     - Used in the work directory (1) and internal bare repo (2).
     - Represents active and backup development.

2. **Release Branches**:
   - Example: `NajibOS-v0.0.1`, `NajibOS-v0.0.2`, etc.
   - Used in the staging repo (3) and shared repo (4).
   - Represents stable release versions.

3. **Specialized Branches**:
   - **Feature**:
     - For new feature development.
     - Naming: `feature/<description>`
   - **Bugfix**:
     - For fixing bugs in `alpha`/`beta` or stable releases.
     - Naming: `bugfix/<description>`
   - **Hotfix**:
     - For critical production fixes.
     - Naming: `hotfix/<description>`

## Workflow Steps

### 1. Managing Branches in Work Directory (mylocalhost:~/src/myproject/)
- Development happens on `alpha` or `beta`.
- Commands:
  - `git checkout alpha`
  - `git pull`
  - `git push`

### 2. Managing Branches for Internal Bare Repo (mylocalhost:~/GitReposPre/myproject.git/)
- Backup/Share branches (`alpha`, `beta`):
  - `git push GitReposPre alpha`
  - `git push GitReposPre beta`

### 3. Managing Branches for Staging Bare Repo (mylocalhost:~/GitRepos/myproject.git/)
- For release preparation (`NajibOS-vX.Y.Z`):
  - `git push GitRepos NajibOS-v0.0.1`

### 4. Managing Branches for Shared Bare Remote Repo (myremotehost:~/GitRepos/myproject.git/)
- For release and collaboration (`NajibOS-vX.Y.Z`):
  - `git push myremotehost NajibOS-v0.0.1`

## Using Feature, Bugfix, and Hotfix Branches
1. **Feature Branch**:
   - `git checkout -b feature/login-page`
   - `git push GitReposPre feature/login-page`

2. **Bugfix Branch**:
   - `git checkout -b bugfix/crash-on-login alpha`
   - `git push GitReposPre bugfix/crash-on-login`

3. **Hotfix Branch**:
   - `git checkout -b hotfix/security-patch NajibOS-v0.0.1`
   - `git push GitRepos hotfix/security-patch`
   - `git push myremotehost hotfix/security-patch`

## Notes
- Use **merge** for working directory and local repos (1, 2).
- Use **rebase** for staging and shared repos (3, 4) to ensure linear history.

